{{ config(
    unique_key='shipment_id',
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
WHERE shipped_at > (SELECT MAX(shipped_at) FROM {{ this }})
{% endif %}

)



SELECT {{ dbt_utils.generate_surrogate_key(['b.shipment_id']) }} AS shipment_key,
       b.shipment_id,
       fo.order_key,
       dd.date_key,
       b.shipment_status,
       b.shipped_at,
       b.delivered_at
FROM base b
JOIN {{ ref('fct_orders') }} fo
ON b.order_id = fo.order_id
JOIN {{ ref('dim_date') }} dd
ON DATE(b.shipped_at) = dd.date