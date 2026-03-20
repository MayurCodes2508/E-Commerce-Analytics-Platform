
  
    

    create or replace table `intense-pixel-490219-h2`.`ci_dev_core`.`fct_shipments`
        
  (
    shipment_key string,
    shipment_id INT64,
    order_key string,
    shipped_date_key INT64,
    delivered_date_key INT64,
    shipment_status string,
    shipped_at timestamp,
    delivered_at timestamp
    
    )

      
    partition by timestamp_trunc(shipped_at, day)
    cluster by order_key

    
    OPTIONS()
    as (
      
    select shipment_key, shipment_id, order_key, shipped_date_key, delivered_date_key, shipment_status, shipped_at, delivered_at
    from (
        

WITH base AS (
SELECT shipment_id,
       order_id,
       shipment_status,
       shipped_at,
       delivered_at
FROM `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_shipments`


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
JOIN `intense-pixel-490219-h2`.`ci_dev_core`.`dim_date` dd_shipped
ON DATE(b.shipped_at) = dd_shipped.date
LEFT JOIN `intense-pixel-490219-h2`.`ci_dev_core`.`dim_date` dd_delivered
ON DATE(b.delivered_at) = dd_delivered.date
    ) as model_subq
    );
  