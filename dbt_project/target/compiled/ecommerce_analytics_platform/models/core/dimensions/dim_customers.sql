SELECT to_hex(md5(cast(coalesce(cast(customer_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS customer_key,
       customer_id,
       customer_name,
       email,
       signup_date,
       country,
       city,
       is_active,
       created_at
FROM `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_customers`