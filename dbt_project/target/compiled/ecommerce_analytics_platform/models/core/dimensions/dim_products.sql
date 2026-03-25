SELECT to_hex(md5(cast(coalesce(cast(product_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS product_key,
       product_id,
       product_name,
       category,
       brand,
       base_price,
       created_at,
       is_active
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_products`