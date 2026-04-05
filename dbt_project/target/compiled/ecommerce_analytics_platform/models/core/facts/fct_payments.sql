

WITH base AS (
SELECT payment_id,
       order_id,
       payment_method,
       amount,
       payment_status,
       payment_timestamp
FROM `intense-pixel-490219-h2`.`dev_staging`.`stg_payments`


WHERE payment_timestamp > (SELECT COALESCE(TIMESTAMP_SUB(MAX(payment_timestamp), INTERVAL 3 DAY), TIMESTAMP('1970-01-01')) FROM `intense-pixel-490219-h2`.`dev_core`.`fct_payments`)

)

SELECT to_hex(md5(cast(coalesce(cast(b.payment_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS payment_key,
       b.payment_id,
       to_hex(md5(cast(coalesce(cast(b.order_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS order_key,
       dd_payment.date_key AS payment_date_key,
       b.payment_method,
       b.amount,
       b.payment_status,
       b.payment_timestamp
FROM base b
JOIN `intense-pixel-490219-h2`.`dev_core`.`dim_date` dd_payment
ON DATE(b.payment_timestamp) = dd_payment.date