
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_active
from `intense-pixel-490219-h2`.`prod_staging`.`stg_products`
where is_active is null



  
  
      
    ) dbt_internal_test