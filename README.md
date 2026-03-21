🛒 E-Commerce Analytics Platform (End-to-End Data Pipeline)

📌 Overview

This project simulates a production-grade analytics platform for an e-commerce business. It covers the full data lifecycle — from data generation and ingestion to transformation, modeling, analytics, and automation.

The goal is to demonstrate how modern data teams build scalable, reliable, and production-ready analytics systems.

---

🚀 Key Features

🔹 Data Engineering

- Synthetic OLTP data generation (customers, orders, payments, shipments)
- Incremental data ingestion into BigQuery
- Append-only raw layer with ingestion metadata

🔹 Data Modeling (dbt)

Layered architecture:

- Staging → cleaning & deduplication  
- Core → dimensional modeling (facts & dimensions)  
- Intermediate → reusable business logic  
- Marts → analytics-ready datasets  

- Star schema design with proper grain handling

🔹 Performance Optimization

- Incremental models for large fact tables  
- Partitioning & clustering for efficient querying  

🔹 Data Quality & Governance

- Data tests (not null, unique, relationships, business rules)  
- Model contracts (schema enforcement)  
- Source freshness checks  
- Environment separation (dev / prod)  
- IAM-based access control  

🔹 Observability

- Ingestion timestamps  
- `dbt_loaded_at` tracking in marts  
- Data freshness validation  

🔹 Analytics & BI

Power BI dashboard powered by marts

Key metrics:
- Gross, Net, and Realized Revenue  
- Total / Valid / Completed Orders  
- Average Order Value (AOV)  

🔹 Metadata & Lineage

- dbt exposures linking models → dashboard  
- Full lineage visualization using dbt docs  

🔹 CI/CD & Orchestration 🚀

- CI Pipeline (GitHub Actions)
  - Runs on push / PR  
  - Validates dbt models and tests  

- CD Pipeline 
  - Deploys models to production after CI passes  

- Orchestration (GitHub Actions Cron)
  - Runs daily automated pipeline  
  - Flow:
    ```
    Data Generation → Ingestion → dbt (prod)
    ```
  - Uses secure GCP OIDC authentication (no service account keys) 

---

🏗️ Architecture
Data Generator (Python) ↓ BigQuery (Raw Layer) ↓ dbt (Staging → Core → Intermediate → Marts) ↓ Power BI Dashboard
Copy code

---

📊 Data Model

Dimensions
- `dim_customers`
- `dim_products`
- `dim_date`

Facts
- `fct_orders`
- `fct_order_items`
- `fct_payments`
- `fct_shipments`

Intermediate
- `int_sales_base`

Marts
- `mrt_sales_trends`
- `mrt_product_sales`
- `mrt_order_status_bucket`

---

📈 Dashboard Highlights

The Power BI dashboard provides:

- Revenue trends over time  
- Product performance analysis  
- Order lifecycle distribution  
- KPI tracking (Revenue, Orders, AOV)  

> ⚠️ Note: Data is synthetically generated and may not reflect real-world distributions.

---

🧠 Key Business Logic

- Gross Revenue → All orders  
- Net Revenue → Excludes refunded orders  
- Realized Revenue → Delivered orders only  
- AOV → Revenue / Orders (aligned with each metric)  

---

🛠️ Tech Stack

- Warehouse: BigQuery  
- Transformation: dbt  
- Orchestration & CI/CD: GitHub Actions  
- Data Generation: Python (Pandas, Faker)  
- BI Tool: Power BI  

---

⚙️ How to Run (Local)

1. Install dependencies
pip install -r requirements.txt
Copy code

2. Generate Data
python data_generator/scripts/generate_customers.py python data_generator/scripts/generate_orders.py python data_generator/scripts/generate_order_items.py python data_generator/scripts/generate_payments.py python data_generator/scripts/generate_shipments.py
Copy code

3. Ingest to BigQuery
python ingestion/load_to_bigquery.py
Copy code

4. Run dbt Models
dbt build --target dev dbt build --target prod
Copy code

5. Serve Documentation
dbt docs generate dbt docs serve
Copy code

---

🔄 Automated Pipeline

Once deployed:
Runs daily via GitHub Actions: → Generate data → Load into BigQuery → Transform using dbt (prod) → Validate with tests
Copy code

---

🔐 Environments

- dev → development & testing  
- prod → production-ready models for BI  

---

🔄 Future Enhancements

- Slim CI (state-based runs)  
- Cost monitoring (BigQuery)  
- Data anomaly detection  
- Semantic layer (dbt metrics)  

---

🎯 What This Project Demonstrates

- End-to-end data pipeline design  
- Dimensional modeling best practices  
- CI/CD for data pipelines  
- Workflow orchestration  
- Data quality enforcement  
- Business-focused analytics  

---

👤 Author

Mayur  

Aspiring Analytics Engineer / Data Engineer