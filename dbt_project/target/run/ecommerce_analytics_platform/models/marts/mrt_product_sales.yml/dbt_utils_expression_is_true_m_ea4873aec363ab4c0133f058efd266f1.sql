
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_product_sales`

where not(realized_revenue_by_product <= net_revenue)


  
  
      
    ) dbt_internal_test