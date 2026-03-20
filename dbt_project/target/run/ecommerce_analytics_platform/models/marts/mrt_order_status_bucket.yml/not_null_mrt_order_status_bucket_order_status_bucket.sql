
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_status_bucket
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_order_status_bucket`
where order_status_bucket is null



  
  
      
    ) dbt_internal_test