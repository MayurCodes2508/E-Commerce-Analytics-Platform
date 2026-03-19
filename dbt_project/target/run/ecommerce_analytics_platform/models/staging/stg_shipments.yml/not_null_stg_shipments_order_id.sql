
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_id
from `intense-pixel-490219-h2`.`prod_staging`.`stg_shipments`
where order_id is null



  
  
      
    ) dbt_internal_test