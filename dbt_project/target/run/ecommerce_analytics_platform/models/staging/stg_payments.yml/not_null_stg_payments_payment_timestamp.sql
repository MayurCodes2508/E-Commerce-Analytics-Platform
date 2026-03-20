
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select payment_timestamp
from `intense-pixel-490219-h2`.`dev_staging`.`stg_payments`
where payment_timestamp is null



  
  
      
    ) dbt_internal_test