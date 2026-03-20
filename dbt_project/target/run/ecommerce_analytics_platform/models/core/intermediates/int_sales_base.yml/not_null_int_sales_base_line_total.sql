
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select line_total
from `intense-pixel-490219-h2`.`dev_core`.`int_sales_base`
where line_total is null



  
  
      
    ) dbt_internal_test