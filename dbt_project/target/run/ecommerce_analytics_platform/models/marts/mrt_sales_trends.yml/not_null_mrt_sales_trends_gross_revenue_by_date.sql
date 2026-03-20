
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select gross_revenue_by_date
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`
where gross_revenue_by_date is null



  
  
      
    ) dbt_internal_test