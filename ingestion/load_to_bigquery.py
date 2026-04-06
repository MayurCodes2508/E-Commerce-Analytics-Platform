from google.cloud import bigquery, storage
import pandas as pd
import os
import datetime
import tempfile

PROJECT_ID = "intense-pixel-490219-h2"
DATASET = "raw"
BUCKET_NAME = "e_commerce_analytics_bucket"

SAFE_OFFSET = 1000

bq_client = bigquery.Client(project=PROJECT_ID)
storage_client = storage.Client()
bucket = storage_client.bucket(BUCKET_NAME)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_PATH = os.path.normpath(
    os.path.join(SCRIPT_DIR, "..", "data_generator", "output_data")
)

tables = {
    "customers": "customers.csv",
    "products": "products.csv",
    "orders": "orders.csv",
    "order_items": "order_items.csv",
    "payments": "payments.csv",
    "shipments": "shipments.csv"
}

id_columns = {
    "customers": "customer_id",
    "products": "product_id",
    "orders": "order_id",
    "order_items": "order_item_id",
    "payments": "payment_id",
    "shipments": "shipment_id"
}

now = datetime.datetime.utcnow()
date_str = now.strftime("%Y-%m-%d")
run_ts = now.strftime("%Y-%m-%dT%H-%M-%S")

for table_name, file_name in tables.items():
    file_path = os.path.join(BASE_PATH, file_name)
    table_id = f"{PROJECT_ID}.{DATASET}.{table_name}"
    id_col = id_columns[table_name]

    print(f"\n Processing {table_name}...")

    if not os.path.exists(file_path):
        print(f"File not found: {file_path}, skipping")
        continue

    df = pd.read_csv(file_path)

    if df.empty:
        print(f"{table_name} is empty, skipping")
        continue

    try:
        query = f"SELECT MAX({id_col}) AS max_id FROM `{table_id}`"
        result = bq_client.query(query).to_dataframe()
        max_id = result["max_id"][0]

        if pd.isna(max_id):
            max_id = 0

        print(f"Max {id_col} in BQ: {max_id}")

    except Exception:
        print(f"Table may not exist yet. Loading full data.")
        max_id = 0

    lower_bound = max(max_id - SAFE_OFFSET, 0)

    print(f"Applying filter: {id_col} > {lower_bound}")

    df = df[df[id_col] > lower_bound]

    if df.empty:
        print(f"No new rows for {table_name}, skipping")
        continue

    before_dedup = len(df)
    df = df.drop_duplicates(subset=[id_col])
    after_dedup = len(df)

    print(f"Deduped {before_dedup - after_dedup} duplicate rows")

    df["ingestion_timestamp"] = pd.Timestamp.utcnow()

    temp_dir = tempfile.gettempdir()
    local_parquet = os.path.join(temp_dir, f"{table_name}_{run_ts}.parquet")
    df.to_parquet(local_parquet, index=False)

    gcs_path = f"{table_name}/dt={date_str}/run_ts={run_ts}/data.parquet"

    blob = bucket.blob(gcs_path)
    blob.upload_from_filename(local_parquet)

    print(f"Uploaded: gs://{BUCKET_NAME}/{gcs_path}")

    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.PARQUET,
        write_disposition="WRITE_APPEND",
        autodetect=True
    )

    uri = f"gs://{BUCKET_NAME}/{gcs_path}"

    load_job = bq_client.load_table_from_uri(
        uri,
        table_id,
        job_config=job_config
    )

    load_job.result()

    print(f"Loaded {len(df)} rows into {table_name}")