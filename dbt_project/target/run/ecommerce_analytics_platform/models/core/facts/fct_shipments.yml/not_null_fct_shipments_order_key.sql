
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_key
from `intense-pixel-490219-h2`.`ci_dev_core`.`fct_shipments`
where order_key is null



  
  
      
    ) dbt_internal_test