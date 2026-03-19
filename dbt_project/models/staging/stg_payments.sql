SELECT payment_id,
       order_id,
       TRIM(payment_method) AS payment_method,
       CAST(amount AS NUMERIC) AS amount,
       TRIM(payment_status) AS payment_status,
       CAST(payment_timestamp AS TIMESTAMP) AS payment_timestamp,
       ingestion_timestamp
FROM {{ source('raw', 'payments') }}
QUALIFY ROW_NUMBER() OVER(PARTITION BY payment_id ORDER BY ingestion_timestamp DESC) = 1 