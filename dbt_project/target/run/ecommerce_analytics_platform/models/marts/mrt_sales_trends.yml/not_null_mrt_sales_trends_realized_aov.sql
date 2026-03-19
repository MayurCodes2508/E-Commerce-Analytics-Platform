
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select realized_aov
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`
where realized_aov is null



  
  
      
    ) dbt_internal_test