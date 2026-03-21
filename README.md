🛒 E-Commerce Analytics Platform (End-to-End Data Pipeline)

📌 Overview

This project simulates a production-grade analytics platform for an e-commerce business. It covers the full data lifecycle — from raw data generation and ingestion to transformation, modeling, and dashboarding.

The goal is to demonstrate how modern data teams build scalable, reliable, and business-ready analytics systems.

---

🚀 Key Features

🔹 Data Engineering

Synthetic OLTP data generation (customers, orders, payments, shipments)

Incremental data ingestion into BigQuery

Append-only raw layer with ingestion metadata


🔹 Data Modeling (dbt)

Layered architecture:

Staging → cleaning & deduplication

Core → dimensional modeling (facts & dimensions)

Intermediate → reusable business logic

Marts → analytics-ready datasets


Star schema design with proper grain handling


🔹 Performance Optimization

Incremental models for large fact tables

Table clustering for efficient querying


🔹 Data Quality & Governance

Data tests (not null, unique, relationships, business rules)

Model contracts (schema enforcement)

Source freshness checks

Environment separation (dev / prod)

IAM-based access control


🔹 Observability

Ingestion timestamps

"dbt_loaded_at" tracking in marts

Data freshness validation


🔹 Analytics & BI

Power BI dashboard powered by marts

Key metrics:

Gross, Net, and Realized Revenue

Total / Valid / Completed Orders

Average Order Value (AOV)



🔹 Metadata & Lineage

dbt exposures linking models → dashboard

Full lineage visualization using dbt docs

---

🏗️ Architecture

Data Generation (Python)

↓

BigQuery (raw layer)

↓

dbt (staging → core → intermediate → marts)

↓

Power BI Dashboard

---

📊 Data Model

Dimensions

"dim_customers"

"dim_products"

"dim_date"


Facts

"fct_orders"

"fct_order_items"

"fct_payments"

"fct_shipments"


Intermediate

"int_sales_base"


Marts

"mrt_sales_trends"

"mrt_product_sales"

"mrt_order_status_bucket"

---

📈 Dashboard Highlights

The Power BI dashboard provides:

Revenue trends over time

Product category performance

Order lifecycle distribution

KPI tracking (Revenue, Orders, AOV)


«Note: Data is synthetically generated and may not reflect real-world distributions.»

---

🧠 Key Business Logic

Gross Revenue → All orders

Net Revenue → Excludes refunded orders

Realized Revenue → Delivered & shipped orders only

AOV → Revenue / Orders (aligned with each revenue type)

---

🛠️ Tech Stack

Warehouse: BigQuery

Transformation: dbt

Orchestration (planned): Prefect / GitHub Actions
Orchestration: Prefect

Data Generation: Python (Pandas, Faker)

BI Tool: Power BI

---

⚙️ How to Run

1. Generate Data


python data_generator/scripts/generate_products.py
python data_generator/scripts/generate_customers.py
python data_generator/scripts/generate_orders.py
python data_generator/scripts/generate_order_items.py
python data_generator/scripts/generate_payments.py
python data_generator/scripts/generate_shipments.py

2. Ingest to BigQuery


python ingestion/load_to_bigquery.py

3. Run dbt Models


dbt build --target dev
dbt build --target prod

4. Serve Documentation


dbt docs generate
dbt docs serve

5. Run End-to-End with Prefect (recommended)


pip install -r orchestration/requirements.txt
python orchestration/prefect_flow.py

Optional: Run only dbt with Prefect parameters


python -c "from orchestration.prefect_flow import ecommerce_pipeline; ecommerce_pipeline(run_generation=False, run_ingestion=False, run_dbt=True, dbt_target='prod')"

---

🔐 Environments

dev → development & testing

stg → validating data before pushing to prod

prod → production-ready models for BI

---

🔄 Future Enhancements

CI/CD pipeline (GitHub Actions)

Semantic layer (dbt metrics)

Monitoring & alerting

Improved data realism (state transitions)

---

🎯 What This Project Demonstrates

End-to-end data pipeline design

Dimensional modeling best practices

Data quality enforcement

Production-ready dbt workflows

Business-focused analytics

---

👤 Author

Mayur

Aspiring Analytics Engineer / Data Engineer