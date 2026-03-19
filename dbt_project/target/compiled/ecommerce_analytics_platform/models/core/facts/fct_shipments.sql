

WITH base AS (
SELECT shipment_id,
       order_id,
       shipment_status,
       shipped_at,
       delivered_at
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_shipments`


WHERE shipped_at > (SELECT COALESCE(TIMESTAMP_SUB(MAX(shipped_at), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM `intense-pixel-490219-h2`.`prod_core`.`fct_shipments`)

)

SELECT to_hex(md5(cast(coalesce(cast(b.shipment_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS shipment_key,
       b.shipment_id,
       to_hex(md5(cast(coalesce(cast(b.order_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_key,
       dd_shipped.date_key AS shipped_date_key,
       dd_delivered.date_key AS delivered_date_key,
       b.shipment_status,
       b.shipped_at,
       b.delivered_at
FROM base b
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_date` dd_shipped
ON DATE(b.shipped_at) = dd_shipped.date
LEFT JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_date` dd_delivered
ON DATE(b.delivered_at) = dd_delivered.date