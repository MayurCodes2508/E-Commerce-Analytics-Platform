
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_created_at_date_key
from `intense-pixel-490219-h2`.`ci_dev_core`.`fct_orders`
where order_created_at_date_key is null



  
  
      
    ) dbt_internal_test