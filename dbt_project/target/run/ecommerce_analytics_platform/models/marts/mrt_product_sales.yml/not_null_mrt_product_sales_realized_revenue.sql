
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select realized_revenue
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_product_sales`
where realized_revenue is null



  
  
      
    ) dbt_internal_test