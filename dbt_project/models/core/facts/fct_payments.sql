{{ config(
    unique_key='payment_id',
    cluster_by=['order_key']
) }}

WITH base AS (
SELECT payment_id,
       order_id,
       payment_method,
       amount,
       payment_status,
       payment_timestamp
FROM {{ ref('stg_payments') }}

{% if is_incremental() %}
WHERE payment_timestamp > (SELECT MAX(payment_timestamp) FROM {{ this }})
{% endif %}

)

SELECT {{ dbt_utils.generate_surrogate_key(['b.payment_id']) }} AS payment_key,
       b.payment_id,
       fo.order_key,
       dd.date_key,
       b.payment_method,
       b.amount,
       b.payment_status,
       b.payment_timestamp
FROM base b
JOIN {{ ref('fct_orders') }} fo
ON b.order_id = fo.order_id
JOIN {{ ref('dim_date') }} dd
ON DATE(b.payment_timestamp) = dd.date