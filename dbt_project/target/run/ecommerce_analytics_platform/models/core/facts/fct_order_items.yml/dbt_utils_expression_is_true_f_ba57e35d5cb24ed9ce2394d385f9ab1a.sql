
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`dev_core`.`fct_order_items`

where not(line_total = quantity * price)


  
  
      
    ) dbt_internal_test