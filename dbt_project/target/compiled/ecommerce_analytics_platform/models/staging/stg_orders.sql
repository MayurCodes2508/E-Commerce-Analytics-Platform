SELECT order_id,
       customer_id,
       CAST(order_date AS TIMESTAMP) AS created_at,
       TRIM(order_status) AS order_status,
       ingestion_timestamp
FROM `intense-pixel-490219-h2`.`raw`.`orders`
QUALIFY ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY ingestion_timestamp DESC) = 1