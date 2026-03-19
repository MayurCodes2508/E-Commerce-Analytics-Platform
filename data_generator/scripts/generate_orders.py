import pandas as pd
import random
from datetime import datetime, timedelta
import os

IS_INITIAL_LOAD = False
DAYS_BACKFILL = 90

def get_dates():
    today = datetime.today()

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
        last_order_id = existing_orders["order_id"].max()
    else:
        existing_orders = pd.DataFrame()
        last_order_id = 0

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