
  
    

    create or replace table `intense-pixel-490219-h2`.`prod_core`.`dim_customers`
        
  (
    customer_key string,
    customer_id INT64,
    customer_name string,
    email string,
    signup_date date,
    country string,
    city string,
    is_active boolean,
    created_at date
    
    )

      
    
    

    
    OPTIONS()
    as (
      
    select customer_key, customer_id, customer_name, email, signup_date, country, city, is_active, created_at
    from (
        SELECT to_hex(md5(cast(coalesce(cast(customer_id as string), '_dbt_utils_surrogate_key_null_') as string))) AS customer_key,
       customer_id,
       customer_name,
       email,
       signup_date,
       country,
       city,
       is_active,
       created_at
FROM `intense-pixel-490219-h2`.`prod_staging`.`stg_customers`
    ) as model_subq
    );
  