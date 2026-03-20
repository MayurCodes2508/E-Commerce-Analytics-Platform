
  
    

    create or replace table `intense-pixel-490219-h2`.`ci_dev_core`.`fct_order_items`
        
  (
    order_item_key string,
    order_item_id INT64,
    order_key string,
    product_key string,
    order_item_created_at_date_key INT64,
    created_at timestamp,
    quantity INT64,
    price numeric(18,2),
    line_total numeric(18,2)
    
    )

      
    partition by timestamp_trunc(created_at, day)
    cluster by order_key, product_key

    
    OPTIONS()
    as (
      
    select order_item_key, order_item_id, order_key, product_key, order_item_created_at_date_key, created_at, quantity, price, line_total
    from (
        

WITH base AS (
SELECT oi.order_item_id,
       oi.order_id,
       oi.product_id,
       o.created_at,
       oi.quantity,
       oi.price
FROM `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_order_items` oi
JOIN `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_orders` o
ON oi.order_id = o.order_id



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
JOIN `intense-pixel-490219-h2`.`ci_dev_core`.`dim_products` dp
ON b.product_id = dp.product_id
JOIN `intense-pixel-490219-h2`.`ci_dev_core`.`dim_date` dd_order_item_created_at
ON DATE(b.created_at) = dd_order_item_created_at.date
    ) as model_subq
    );
  