
  
    

    create or replace table `intense-pixel-490219-h2`.`ci_dev_core`.`dim_products`
        
  (
    product_key string,
    product_id INT64,
    product_name string,
    category string,
    brand string,
    base_price numeric(18,2),
    created_at date,
    is_active boolean
    
    )

      
    
    

    
    OPTIONS()
    as (
      
    select product_key, product_id, product_name, category, brand, base_price, created_at, is_active
    from (
        SELECT to_hex(md5(cast(coalesce(cast(product_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS product_key,
       product_id,
       product_name,
       category,
       brand,
       base_price,
       created_at,
       is_active
FROM `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_products`
    ) as model_subq
    );
  