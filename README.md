# E-Commerce Analytics Platform

## Portfolio Summary
This project demonstrates an end-to-end analytics engineering workflow for e-commerce data, from synthetic operational data generation to production-style transformation and reporting layers in BigQuery.

The repository focuses on reliable data modeling patterns, automated execution, and analytics-ready outputs using dbt.

## What I Built
- Synthetic source data generation for customers, products, orders, order items, payments, and shipments.
- Cloud ingestion pipeline that stages Parquet files in GCS and appends data into BigQuery raw tables.
- Layered dbt project with staging, core, intermediate, and marts.
- Dimensional model with three dimensions and four fact tables.
- KPI marts for sales trends, product sales, and order status distribution.
- CI, CD, and scheduled orchestration with GitHub Actions using GCP OIDC authentication.

## End-to-End Pipeline Architecture
```text
Python Data Generators (CSV)
  -> GCS Parquet Staging
  -> BigQuery Raw Tables (append)
  -> dbt Transformations
      - staging (cleaning + deduplication)
      - core dimensions/facts (surrogate keys + incremental facts)
      - intermediate business layer
      - marts (analytics KPIs)
  -> Dashboard Exposure (sales_dashboard)
```

## How Data Flows Through the System
1. Scripts in data_generator/scripts create or append CSV data in data_generator/output_data.
2. ingestion/load_to_bigquery.py reads CSV files, applies a safe overlap window, deduplicates by table key, adds ingestion_timestamp, writes Parquet, uploads to GCS, and appends to BigQuery raw tables.
3. dbt sources define raw tables with freshness thresholds.
4. Staging models clean and type-cast fields and keep the latest record per business key using ROW_NUMBER and QUALIFY over ingestion_timestamp.
5. Core models build dimensions and incremental fact tables with BigQuery partitioning, clustering, and a 3-day lookback in incremental logic.
6. int_sales_base joins facts and dimensions into reusable sales logic.
7. Mart models aggregate business metrics and add dbt_loaded_at for load observability.
8. exposures.yml links mart outputs to the sales_dashboard exposure.

## Key Engineering Decisions
- Layered dbt structure to separate raw cleanup, reusable business logic, and BI-ready outputs.
- Incremental fact models with merge strategy plus partitioning and clustering for scalable queries.
- Source freshness checks and model-level tests (not_null, unique, relationships, accepted_values).
- Contracts enabled on core dimensions and facts.
- Ingestion design uses overlap plus deduplication to reduce missed late-arriving records.

## Core Models
Dimensions:
- dim_customers
- dim_products
- dim_date

Facts:
- fct_orders
- fct_order_items
- fct_payments
- fct_shipments

Intermediate:
- int_sales_base

Marts:
- mrt_sales_trends
- mrt_product_sales
- mrt_order_status_bucket

## Automation in This Repository
- CI workflow: .github/workflows/ci.yml
  - Runs on push and pull request to main.
  - Executes dbt deps and dbt build --target ci.
- CD workflow: .github/workflows/cd.yml
  - Runs when CI succeeds on main.
  - Executes dbt deps and dbt build --target prod.
- Orchestrator workflow: .github/workflows/orchestrator.yml
  - Runs on schedule (every 12 hours) and manual dispatch.
  - Executes generation, ingestion, and dbt build --target prod.

## Run Locally
1. Install dependencies:

```bash
pip install -r requirements.txt
```

2. Generate source data (run from data_generator/scripts):

```bash
python generate_products.py
python generate_customers.py
python generate_orders.py
python generate_order_items.py
python generate_payments.py
python generate_shipments.py
```

3. Ingest to BigQuery (run from ingestion):

```bash
python load_to_bigquery.py
```

4. Run dbt (run from dbt_project):

```bash
dbt deps
dbt build --target <your_target>
```

5. Generate and serve docs (run from dbt_project):

```bash
dbt docs generate --target <your_target>
dbt docs serve
```

## Technologies Used
- Python
- dbt and dbt-bigquery
- BigQuery
- Google Cloud Storage
- dbt_utils
- GitHub Actions