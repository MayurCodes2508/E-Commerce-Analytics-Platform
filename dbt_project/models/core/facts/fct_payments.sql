{{ config(
    unique_key='payment_key',
    partition_by={'field': 'payment_timestamp', 'data_type': 'timestamp', 'granularity': 'day'},
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
WHERE payment_timestamp > (SELECT COALESCE(TIMESTAMP_SUB(MAX(payment_timestamp), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM {{ this }})
{% endif %}
)

SELECT {{ dbt_utils.generate_surrogate_key(['b.payment_id']) }} AS payment_key,
       b.payment_id,
       {{ dbt_utils.generate_surrogate_key(['b.order_id']) }} AS order_key,
       dd_payment.date_key AS payment_date_key,
       b.payment_method,
       b.amount,
       b.payment_status,
       b.payment_timestamp
FROM base b
JOIN {{ ref('dim_date') }} dd_payment
ON DATE(b.payment_timestamp) = dd_payment.date