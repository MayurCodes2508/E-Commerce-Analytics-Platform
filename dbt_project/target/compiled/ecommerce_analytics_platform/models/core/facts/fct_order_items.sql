

WITH base AS (
SELECT oi.order_item_id,
       oi.order_id,
       oi.product_id,
       o.created_at,
       oi.quantity,
       oi.price
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_order_items` oi
JOIN `intense-pixel-490219-h2`.`prod_staging`.`stg_orders` o
ON oi.order_id = o.order_id


WHERE o.created_at > (SELECT COALESCE(TIMESTAMP_SUB(MAX(o.created_at), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM `intense-pixel-490219-h2`.`prod_core`.`fct_order_items`)


)

SELECT to_hex(md5(cast(coalesce(cast(b.order_item_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_item_key,
       b.order_item_id,
	   to_hex(md5(cast(coalesce(cast(b.order_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_key,
       dp.product_key,
       dd_order_item_created_at.date_key AS order_item_created_at_date_key,
       b.created_at,
       b.quantity,
       b.price,
       b.quantity * b.price AS line_total
FROM base b
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_products` dp
ON b.product_id = dp.product_id
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_date` dd_order_item_created_at
ON DATE(b.created_at) = dd_order_item_created_at.date