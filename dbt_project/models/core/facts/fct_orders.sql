{{ config(
    unique_key='order_key',
    partition_by={'field': 'created_at', 'data_type': 'timestamp', 'granularity': 'day'},
    cluster_by=['customer_key']
) }}

WITH base AS (
SELECT order_id,
       customer_id,
       created_at,
       order_status
FROM {{ ref('stg_orders') }}

{% if is_incremental() %}
WHERE created_at > (SELECT COALESCE(TIMESTAMP_SUB(MAX(created_at), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM {{ this }})
{% endif %}
)

SELECT {{ dbt_utils.generate_surrogate_key(['b.order_id']) }} AS order_key,
       b.order_id,
       {{ dbt_utils.generate_surrogate_key(['b.customer_id']) }} AS customer_key,
       dd_order_created_at.date_key AS order_created_at_date_key,
       b.created_at,
       b.order_status
FROM base b
JOIN {{ ref('dim_customers') }} dc
ON b.customer_id = dc.customer_id
JOIN {{ ref('dim_date') }} dd_order_created_at
ON DATE(b.created_at) = dd_order_created_at.date