SELECT {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,
       customer_id,
       customer_name,
       email,
       signup_date,
       country,
       city,
       is_active,
       created_at
FROM {{ ref('stg_customers') }}