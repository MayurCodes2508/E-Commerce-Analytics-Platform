import pandas as pd
import random
import os
from datetime import timedelta

def generate_shipments():
    orders_path = "../output_data/orders.csv"
    payments_path = "../output_data/payments.csv"
    shipments_path = "../output_data/shipments.csv"

    orders = pd.read_csv(orders_path)
    payments = pd.read_csv(payments_path)

    shipment_statuses = [
        "processing",
        "shipped",
        "in_transit",
        "delivered",
        "returned"
    ]

    if os.path.exists(shipments_path):
        existing_shipments = pd.read_csv(shipments_path)
        processed_orders = existing_shipments["order_id"].unique()
        last_shipment_id = existing_shipments["shipment_id"].max()
    else:
        existing_shipments = pd.DataFrame()
        processed_orders = []
        last_shipment_id = 0

    successful_payments = payments[payments["payment_status"] == "success"]
    paid_orders = successful_payments["order_id"].unique()

    eligible_orders = orders[
        (orders["order_id"].isin(paid_orders)) &
        (~orders["order_id"].isin(processed_orders))
    ]

    if eligible_orders.empty:
        print("No new shipments to generate")
        return

    shipments = []
    shipment_counter = last_shipment_id

    for _, order in eligible_orders.iterrows():
        shipment_counter += 1

        order_time = pd.to_datetime(order["order_date"])

        shipped_at = order_time + timedelta(hours=random.randint(2, 24))

        status = random.choices(
            shipment_statuses,
            weights=[10, 20, 30, 35, 5],  
            k=1
        )[0]

        delivered_at = None

        if status in ["in_transit", "delivered", "returned"]:
            delivered_at = shipped_at + timedelta(days=random.randint(2, 7))

        shipments.append({
            "shipment_id": shipment_counter,
            "order_id": order["order_id"],
            "shipment_status": status,
            "shipped_at": shipped_at,
            "delivered_at": delivered_at
        })

    new_shipments_df = pd.DataFrame(shipments)

    final_shipments = pd.concat(
        [existing_shipments, new_shipments_df],
        ignore_index=True
    )

    os.makedirs(os.path.dirname(shipments_path), exist_ok=True)
    final_shipments.to_csv(shipments_path, index=False)

    print(f"{len(new_shipments_df)} shipments generated")
    print("Shipments appended successfully")


def main():
    generate_shipments()


if __name__ == "__main__":
    main()