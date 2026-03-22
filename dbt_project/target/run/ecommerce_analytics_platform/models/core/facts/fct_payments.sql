
  
    

    create or replace table `intense-pixel-490219-h2`.`prod_core`.`fct_payments`
        
  (
    payment_key string,
    payment_id INT64,
    order_key string,
    payment_date_key INT64,
    payment_method string,
    amount numeric(18,2),
    payment_status string,
    payment_timestamp timestamp
    
    )

      
    partition by timestamp_trunc(payment_timestamp, day)
    cluster by order_key

    
    OPTIONS()
    as (
      
    select payment_key, payment_id, order_key, payment_date_key, payment_method, amount, payment_status, payment_timestamp
    from (
        

WITH base AS (
SELECT payment_id,
       order_id,
       payment_method,
       amount,
       payment_status,
       payment_timestamp
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_payments`


)

SELECT to_hex(md5(cast(coalesce(cast(b.payment_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS payment_key,
       b.payment_id,
       to_hex(md5(cast(coalesce(cast(b.order_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_key,
       dd_payment.date_key AS payment_date_key,
       b.payment_method,
       b.amount,
       b.payment_status,
       b.payment_timestamp
FROM base b
JOIN `intense-pixel-490219-h2`.`prod_core`.`dim_date` dd_payment
ON DATE(b.payment_timestamp) = dd_payment.date
    ) as model_subq
    );
  