
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_item_created_at_date_key
from `intense-pixel-490219-h2`.`prod_core`.`fct_order_items`
where order_item_created_at_date_key is null



  
  
      
    ) dbt_internal_test