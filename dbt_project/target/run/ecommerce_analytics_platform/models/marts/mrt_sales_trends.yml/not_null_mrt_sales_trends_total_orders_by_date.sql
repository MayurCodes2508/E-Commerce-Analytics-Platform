
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_orders_by_date
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_sales_trends`
where total_orders_by_date is null



  
  
      
    ) dbt_internal_test