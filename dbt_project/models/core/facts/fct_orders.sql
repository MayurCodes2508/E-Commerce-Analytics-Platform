{{ config(
    unique_key='order_id',
    cluster_by=['customer_key']
) }}

WITH base AS (
SELECT order_id,
       customer_id,
       created_at,
       order_status
FROM {{ ref('stg_orders') }}

{% if is_incremental() %}
WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
{% endif %}

)

SELECT {{ dbt_utils.generate_surrogate_key(['b.order_id']) }} AS order_key,
       b.order_id,
       dc.customer_key,
       dd.date_key,
       b.created_at,
       b.order_status
FROM base b
JOIN {{ ref('dim_customers') }} dc
ON b.customer_id = dc.customer_id
JOIN {{ ref('dim_date') }} dd
ON DATE(b.created_at) = dd.date