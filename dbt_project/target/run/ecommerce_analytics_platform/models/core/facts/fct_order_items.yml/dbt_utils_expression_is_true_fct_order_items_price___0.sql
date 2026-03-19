
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`prod_core`.`fct_order_items`

where not(price >= 0)


  
  
      
    ) dbt_internal_test