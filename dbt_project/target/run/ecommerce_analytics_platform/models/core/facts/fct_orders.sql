
  
    

    create or replace table `intense-pixel-490219-h2`.`ci_dev_core`.`fct_orders`
        
  (
    order_key string,
    order_id INT64,
    customer_key string,
    order_created_at_date_key INT64,
    created_at timestamp,
    order_status string
    
    )

      
    partition by timestamp_trunc(created_at, day)
    cluster by customer_key

    
    OPTIONS()
    as (
      
    select order_key, order_id, customer_key, order_created_at_date_key, created_at, order_status
    from (
        

WITH base AS (
SELECT order_id,
       customer_id,
       created_at,
       order_status
FROM `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_orders`


)

SELECT to_hex(md5(cast(coalesce(cast(b.order_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_key,
       b.order_id,
       to_hex(md5(cast(coalesce(cast(b.customer_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS customer_key,
       dd_order_created_at.date_key AS order_created_at_date_key,
       b.created_at,
       b.order_status
FROM base b
JOIN `intense-pixel-490219-h2`.`ci_dev_core`.`dim_customers` dc
ON b.customer_id = dc.customer_id
JOIN `intense-pixel-490219-h2`.`ci_dev_core`.`dim_date` dd_order_created_at
ON DATE(b.created_at) = dd_order_created_at.date
    ) as model_subq
    );
  