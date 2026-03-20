
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select gross_revenue_by_product
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_product_sales`
where gross_revenue_by_product is null



  
  
      
    ) dbt_internal_test