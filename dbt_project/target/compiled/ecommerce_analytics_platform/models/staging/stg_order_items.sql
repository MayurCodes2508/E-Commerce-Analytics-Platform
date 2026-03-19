SELECT order_item_id,
       order_id,
       product_id,
       quantity,
       CAST(price AS NUMERIC) AS price,
       ingestion_timestamp
FROM `intense-pixel-490219-h2`.`raw`.`order_items`
QUALIFY ROW_NUMBER() OVER(PARTITION BY order_item_id ORDER BY ingestion_timestamp DESC) = 1