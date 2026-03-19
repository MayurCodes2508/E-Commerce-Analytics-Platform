
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select gross_revenue
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`
where gross_revenue is null



  
  
      
    ) dbt_internal_test