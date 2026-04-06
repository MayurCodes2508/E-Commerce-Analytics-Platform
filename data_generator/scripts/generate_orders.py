import pandas as pd
import random
from datetime import datetime, timedelta
import os
from google.cloud import bigquery

IS_INITIAL_LOAD = False
DAYS_BACKFILL = 90
PROJECT_ID = os.getenv("GCP_PROJECT_ID", "intense-pixel-490219-h2")
RAW_DATASET = os.getenv("RAW_DATASET", "raw")

# Backfill switch: set true to generate for OVERRIDE_DATE only, false for normal mode.
ENABLE_DATE_OVERRIDE = os.getenv("ENABLE_DATE_OVERRIDE", "false").lower() == "true"
OVERRIDE_DATE = os.getenv("OVERRIDE_DATE", "")  # YYYY-MM-DD


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

def generate_orders():
    orders_path = "../output_data/orders.csv"
    customers_path = "../output_data/customers.csv"

    customers = pd.read_csv(customers_path)
    customer_ids = customers["customer_id"].tolist()

    if os.path.exists(orders_path):
        existing_orders = pd.read_csv(orders_path)
    else:
        existing_orders = pd.DataFrame()

    last_order_id = get_max_id_from_bigquery("orders", "order_id")

    order_statuses = [
        "created",
        "paid",
        "cancelled",
        "delivered",
        "shipped",
        "refunded"
    ]

    dates = get_dates()

    new_orders = []
    current_id = last_order_id

    for date in dates:

        if IS_INITIAL_LOAD:
            num_orders = random.randint(80, 120)
        else:
            num_orders = random.randint(50, 100)

        for _ in range(num_orders):
            current_id += 1

            customer_id = random.choice(customer_ids)
            status = random.choice(order_statuses)

            new_orders.append({
                "order_id": current_id,
                "customer_id": customer_id,
                "order_date": date,   
                "order_status": status
            })

    new_orders_df = pd.DataFrame(new_orders)

    final_orders = pd.concat([existing_orders, new_orders_df], ignore_index=True)

    os.makedirs(os.path.dirname(orders_path), exist_ok=True)
    final_orders.to_csv(orders_path, index=False)

    print(f"{len(new_orders_df)} new orders generated")
    print("Orders appended successfully")


def main():
    generate_orders()


if __name__ == "__main__":
    main()