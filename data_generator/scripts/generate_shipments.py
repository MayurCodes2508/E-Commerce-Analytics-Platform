import pandas as pd
import random
import os
from datetime import datetime, timedelta
from google.cloud import bigquery

PROJECT_ID = os.getenv("GCP_PROJECT_ID", "intense-pixel-490219-h2")
RAW_DATASET = os.getenv("RAW_DATASET", "raw")

# Backfill switch: set true to generate for OVERRIDE_DATE only, false for normal mode.
ENABLE_DATE_OVERRIDE = os.getenv("ENABLE_DATE_OVERRIDE", "false").lower() == "true"
OVERRIDE_DATE = os.getenv("OVERRIDE_DATE", "")  # YYYY-MM-DD


def get_business_datetime(order_date_value):
    if ENABLE_DATE_OVERRIDE:
        if not OVERRIDE_DATE:
            raise ValueError("ENABLE_DATE_OVERRIDE is true, but OVERRIDE_DATE is empty.")
        return datetime.strptime(OVERRIDE_DATE, "%Y-%m-%d")
    return pd.to_datetime(order_date_value)


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
    else:
        existing_shipments = pd.DataFrame()
        processed_orders = []

    last_shipment_id = get_max_id_from_bigquery("shipments", "shipment_id")

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

        order_time = get_business_datetime(order["order_date"])

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