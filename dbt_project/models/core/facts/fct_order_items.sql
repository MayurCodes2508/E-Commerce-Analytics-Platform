{{ config(
    unique_key='order_item_id',
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
WHERE o.created_at > (SELECT MAX(created_at) FROM {{ this }})
{% endif %}

)

SELECT {{ dbt_utils.generate_surrogate_key(['b.order_item_id']) }} AS order_item_key,
       b.order_item_id,
	   fo.order_key,
       dp.product_key,
       dd.date_key,
       b.created_at,
       b.quantity,
       b.price,
       b.quantity * b.price AS line_total
FROM base b
JOIN {{ ref('fct_orders') }} fo
ON b.order_id = fo.order_id
JOIN {{ ref('dim_products') }} dp
ON b.product_id = dp.product_id
JOIN {{ ref('dim_date') }} dd
ON DATE(b.created_at) = dd.date