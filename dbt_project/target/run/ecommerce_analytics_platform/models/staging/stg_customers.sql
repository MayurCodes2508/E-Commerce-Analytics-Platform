

  create or replace view `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_customers`
  OPTIONS()
  as SELECT customer_id,
       TRIM(customer_name) AS customer_name,
       TRIM(email) AS email,
       CAST(signup_date AS DATE) AS signup_date,
       TRIM(country) AS country,
       TRIM(city) AS city,
       is_active,
       CAST(created_at AS DATE) AS created_at,
       ingestion_timestamp
FROM `intense-pixel-490219-h2`.`raw`.`customers`
QUALIFY ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY ingestion_timestamp DESC) = 1;

