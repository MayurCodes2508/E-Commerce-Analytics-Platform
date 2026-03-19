

WITH base AS (
SELECT order_id,
       customer_id,
       created_at,
       order_status
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_orders`


WHERE created_at > (SELECT COALESCE(TIMESTAMP_SUB(MAX(created_at), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM `intense-pixel-490219-h2`.`prod_core`.`fct_orders`)

)

SELECT to_hex(md5(cast(coalesce(cast(b.order_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_key,
       b.order_id,
       to_hex(md5(cast(coalesce(cast(b.customer_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS customer_key,
       dd_order_created_at.date_key AS order_created_at_date_key,
       b.created_at,
       b.order_status
FROM base b
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_customers` dc
ON b.customer_id = dc.customer_id
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_date` dd_order_created_at
ON DATE(b.created_at) = dd_order_created_at.date