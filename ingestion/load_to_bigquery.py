from google.cloud import bigquery
from google.api_core.exceptions import NotFound
import pandas as pd
import os

PROJECT_ID = "intense-pixel-490219-h2"
DATASET = "raw"

client = bigquery.Client(project=PROJECT_ID)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_PATH = os.path.normpath(os.path.join(SCRIPT_DIR, "..", "data_generator", "output_data"))

tables = {
    "customers": ("customers.csv", "customer_id"),
    "products": ("products.csv", "product_id"),
    "orders": ("orders.csv", "order_id"),
    "order_items": ("order_items.csv", "order_item_id"),
    "payments": ("payments.csv", "payment_id"),
    "shipments": ("shipments.csv", "shipment_id")
}

for table_name, (file_name, id_column) in tables.items():
    file_path = os.path.join(BASE_PATH, file_name)

    print(f"\nProcessing {file_name}...")

    if not os.path.exists(file_path):
        print(f"File not found: {file_path}, skipping")
        continue

    df = pd.read_csv(file_path)

    if df.empty:
        print(f"{file_name} is empty, skipping")
        continue

    df["ingestion_timestamp"] = pd.Timestamp.utcnow()

    table_id = f"{PROJECT_ID}.{DATASET}.{table_name}"

    try:
        query = f"""
        SELECT MAX({id_column}) AS max_id
        FROM `{table_id}`
        """

        result = client.query(query).to_dataframe()
        max_id = result["max_id"][0]

        if pd.isna(max_id):
            max_id = 0

    except NotFound:
        print("Table does not exist yet, creating new table.")
    except Exception as exc:
        print(f"Error checking max id for {table_name}: {exc}")
        raise

    if df.empty:
        print(f"No new rows for {table_name}")
        continue

    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_APPEND",
        autodetect=True  
    )

    job = client.load_table_from_dataframe(
        df,
        table_id,
        job_config=job_config
    )

    job.result()

    print(f"{len(df)} new rows appended to {table_name}")