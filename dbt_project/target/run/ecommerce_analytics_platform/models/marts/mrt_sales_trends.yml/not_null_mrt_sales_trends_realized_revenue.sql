
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select realized_revenue
from `intense-pixel-490219-h2`.`prod_marts`.`mrt_sales_trends`
where realized_revenue is null



  
  
      
    ) dbt_internal_test