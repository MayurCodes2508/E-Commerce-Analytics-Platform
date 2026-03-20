
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_active
from `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_customers`
where is_active is null



  
  
      
    ) dbt_internal_test