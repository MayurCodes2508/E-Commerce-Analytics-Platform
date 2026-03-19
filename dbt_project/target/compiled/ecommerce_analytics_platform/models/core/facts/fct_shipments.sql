

WITH base AS (
SELECT shipment_id,
       order_id,
       shipment_status,
       shipped_at,
       delivered_at
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_shipments`


WHERE shipped_at > (SELECT MAX(shipped_at) FROM `intense-pixel-490219-h2`.`prod_core`.`fct_shipments`)


)



SELECT to_hex(md5(cast(coalesce(cast(b.shipment_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS shipment_key,
       b.shipment_id,
       fo.order_key,
       dd.date_key,
       b.shipment_status,
       b.shipped_at,
       b.delivered_at
FROM base b
JOIN `intense-pixel-490219-h2`.`prod_core`.`fct_orders` fo
ON b.order_id = fo.order_id
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_date` dd
ON DATE(b.shipped_at) = dd.date