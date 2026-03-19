SELECT product_id,
       TRIM(product_name) AS product_name,
       TRIM(category) AS category,
       TRIM(brand) AS brand,
       CAST(base_price AS NUMERIC) AS base_price,
       CAST(created_at AS DATE) AS created_at,
       is_active,
       ingestion_timestamp
FROM {{ source('raw', 'products') }}
QUALIFY ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY ingestion_timestamp DESC) = 1