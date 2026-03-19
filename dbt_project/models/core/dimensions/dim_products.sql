SELECT {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_key,
       product_id,
       product_name,
       category,
       brand,
       base_price,
       created_at,
       is_active
FROM {{ ref('stg_products') }}