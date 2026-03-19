{{ config(
    unique_key='order_item_key',
    partition_by={'field': 'created_at', 'data_type': 'timestamp', 'granularity': 'day'},
    cluster_by=['order_key', 'product_key']
) }}

WITH base AS (
SELECT oi.order_item_id,
       oi.order_id,
       oi.product_id,
       o.created_at,
       oi.quantity,
       oi.price
FROM {{ ref('stg_order_items') }} oi
JOIN {{ ref('stg_orders') }} o
ON oi.order_id = o.order_id

{% if is_incremental() %}
WHERE o.created_at > (SELECT COALESCE(TIMESTAMP_SUB(MAX(o.created_at), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM {{ this }})
{% endif %}

)

SELECT {{ dbt_utils.generate_surrogate_key(['b.order_item_id']) }} AS order_item_key,
       b.order_item_id,
	   {{ dbt_utils.generate_surrogate_key(['b.order_id']) }} AS order_key,
       dp.product_key,
       dd_order_item_created_at.date_key AS order_item_created_at_date_key,
       b.created_at,
       b.quantity,
       b.price,
       b.quantity * b.price AS line_total
FROM base b
JOIN {{ ref('dim_products') }} dp
ON b.product_id = dp.product_id
JOIN {{ ref('dim_date') }} dd_order_item_created_at
ON DATE(b.created_at) = dd_order_item_created_at.date