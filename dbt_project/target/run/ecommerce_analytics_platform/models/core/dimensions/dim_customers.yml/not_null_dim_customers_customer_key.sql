
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_key
from `intense-pixel-490219-h2`.`ci_dev_core`.`dim_customers`
where customer_key is null



  
  
      
    ) dbt_internal_test