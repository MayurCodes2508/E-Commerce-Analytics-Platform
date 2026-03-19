
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`prod_marts`.`mrt_sales_trends`

where not(net_revenue <= gross_revenue)


  
  
      
    ) dbt_internal_test