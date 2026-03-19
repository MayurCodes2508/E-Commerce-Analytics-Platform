
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select created_at
from `intense-pixel-490219-h2`.`prod_staging`.`stg_orders`
where created_at is null



  
  
      
    ) dbt_internal_test