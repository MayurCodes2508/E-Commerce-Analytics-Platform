import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta
import os
from google.cloud import bigquery

fake = Faker()

IS_INITIAL_LOAD = False
DAYS_BACKFILL = 90
PROJECT_ID = os.getenv("GCP_PROJECT_ID", "intense-pixel-490219-h2")
RAW_DATASET = os.getenv("RAW_DATASET", "raw")

# Backfill switch: set true to generate for OVERRIDE_DATE only, false for normal mode.
ENABLE_DATE_OVERRIDE = os.getenv("ENABLE_DATE_OVERRIDE", "false").lower() == "true"
OVERRIDE_DATE = os.getenv("OVERRIDE_DATE", "") 


def get_max_id_from_bigquery(table_name, id_column):
    """Get current max ID from raw BigQuery table; return 0 if table is unavailable."""
    try:
        client = bigquery.Client(project=PROJECT_ID)
        query = (
            f"SELECT COALESCE(MAX(CAST({id_column} AS INT64)), 0) AS max_id "
            f"FROM `{PROJECT_ID}.{RAW_DATASET}.{table_name}`"
        )
        result = client.query(query).to_dataframe()
        max_id = result["max_id"][0]
        return int(max_id) if pd.notna(max_id) else 0
    except Exception as exc:
        print(f"Warning: could not read max {id_column} from BigQuery ({exc}). Falling back to 0.")
        return 0

def get_dates():
    today = datetime.today().date()

    if ENABLE_DATE_OVERRIDE:
        if not OVERRIDE_DATE:
            raise ValueError("ENABLE_DATE_OVERRIDE is true, but OVERRIDE_DATE is empty.")
        return [datetime.strptime(OVERRIDE_DATE, "%Y-%m-%d").date()]

    if IS_INITIAL_LOAD:
        return [today - timedelta(days=i) for i in range(DAYS_BACKFILL)]
    else:
        return [today]

def generate_customers():
    output_path = "../output_data/customers.csv"

    countries = [
        "USA", "UK", "Canada", "Germany", "India",
        "Australia", "France", "Netherlands", "Spain", "Italy"
    ]

    if os.path.exists(output_path):
        existing_customers = pd.read_csv(output_path)
    else:
        existing_customers = pd.DataFrame()

    last_customer_id = get_max_id_from_bigquery("customers", "customer_id")

    customers = []
    current_id = last_customer_id

    dates = get_dates()

    for date in dates:

        if os.path.exists(output_path):
            new_customer_count = random.randint(1, 20)
        else:
            new_customer_count = random.randint(10, 30)

        for _ in range(new_customer_count):
            current_id += 1

            customers.append({
                "customer_id": current_id,
                "customer_name": fake.name(),
                "email": fake.unique.email(),
                "signup_date": fake.date_between(start_date="-2y", end_date="today"),
                "country": random.choice(countries),
                "city": fake.city(),
                "is_active": True,
                "created_at": date
            })

    new_customers = pd.DataFrame(customers)

    final_customers = pd.concat([existing_customers, new_customers], ignore_index=True)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    final_customers.to_csv(output_path, index=False)

    print(f"{len(new_customers)} customers added")
    print("Customers appended successfully")

def main():
    generate_customers()

if __name__ == "__main__":
    main()