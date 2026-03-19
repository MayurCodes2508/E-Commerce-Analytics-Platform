select * from (
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
SELECT * FROM base
) as __preview_sbq__ limit 1000