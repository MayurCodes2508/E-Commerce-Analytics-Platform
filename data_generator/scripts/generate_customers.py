import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta
import os

fake = Faker()

IS_INITIAL_LOAD = False
DAYS_BACKFILL = 90

def get_dates():
    today = datetime.today().date()

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
        last_customer_id = existing_customers["customer_id"].max()
    else:
        existing_customers = pd.DataFrame()
        last_customer_id = 0

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