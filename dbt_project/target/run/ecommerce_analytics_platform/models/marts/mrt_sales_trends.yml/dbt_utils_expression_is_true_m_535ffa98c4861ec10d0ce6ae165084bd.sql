
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`

where not(completed_orders <= valid_orders)


  
  
      
    ) dbt_internal_test