import pandas as pd
import random
import os
from datetime import datetime
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

def generate_payments():
    orders_path = "../output_data/orders.csv"
    order_items_path = "../output_data/order_items.csv"
    payments_path = "../output_data/payments.csv"

    orders = pd.read_csv(orders_path)
    order_items = pd.read_csv(order_items_path)

    payment_methods = [
        "credit_card",
        "paypal",
        "apple_pay",
        "google_pay",
        "bank_transfer"
    ]

    payment_statuses = [
        "success",
        "failed",
        "refunded"
    ]

    order_items["line_total"] = order_items["price"] * order_items["quantity"]
    order_totals = order_items.groupby("order_id")["line_total"].sum().to_dict()

    if os.path.exists(payments_path):
        existing_payments = pd.read_csv(payments_path)
        processed_orders = existing_payments["order_id"].unique()
    else:
        existing_payments = pd.DataFrame()
        processed_orders = []

    last_payment_id = get_max_id_from_bigquery("payments", "payment_id")

    new_orders = orders[~orders["order_id"].isin(processed_orders)]

    if new_orders.empty:
        print("No new payments to generate")
        return

    payments = []
    payment_counter = last_payment_id

    for _, order in new_orders.iterrows():
        order_id = order["order_id"]

        payment_counter += 1

        order_total = order_totals.get(order_id, 0)

        payments.append({
            "payment_id": payment_counter,
            "order_id": order_id,
            "payment_method": random.choice(payment_methods),
            "amount": order_total,
            "payment_status": random.choice(payment_statuses),
            "payment_timestamp": get_business_datetime(order["order_date"])
        })

    new_payments_df = pd.DataFrame(payments)

    final_payments = pd.concat([existing_payments, new_payments_df], ignore_index=True)

    os.makedirs(os.path.dirname(payments_path), exist_ok=True)
    final_payments.to_csv(payments_path, index=False)

    print(f"{len(new_payments_df)} payments generated")
    print("Payments appended successfully")


def main():
    generate_payments()


if __name__ == "__main__":
    main()