{{ config(
    unique_key='shipment_key',
    partition_by={'field': 'shipped_at', 'data_type': 'timestamp', 'granularity': 'day'},
    cluster_by=['order_key']
) }}

WITH base AS (
SELECT shipment_id,
       order_id,
       shipment_status,
       shipped_at,
       delivered_at
FROM {{ ref('stg_shipments') }}

{% if is_incremental() %}
WHERE shipped_at > (SELECT COALESCE(TIMESTAMP_SUB(MAX(shipped_at), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM {{ this }})
{% endif %}
)

SELECT {{ dbt_utils.generate_surrogate_key(['b.shipment_id']) }} AS shipment_key,
       b.shipment_id,
       {{ dbt_utils.generate_surrogate_key(['b.order_id']) }} AS order_key,
       dd_shipped.date_key AS shipped_date_key,
       dd_delivered.date_key AS delivered_date_key,
       b.shipment_status,
       b.shipped_at,
       b.delivered_at
FROM base b
JOIN {{ ref('dim_date') }} dd_shipped
ON DATE(b.shipped_at) = dd_shipped.date
LEFT JOIN {{ ref('dim_date') }} dd_delivered
ON DATE(b.delivered_at) = dd_delivered.date