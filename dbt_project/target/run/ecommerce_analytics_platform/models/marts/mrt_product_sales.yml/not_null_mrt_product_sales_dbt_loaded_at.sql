
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select dbt_loaded_at
from `intense-pixel-490219-h2`.`prod_marts`.`mrt_product_sales`
where dbt_loaded_at is null



  
  
      
    ) dbt_internal_test