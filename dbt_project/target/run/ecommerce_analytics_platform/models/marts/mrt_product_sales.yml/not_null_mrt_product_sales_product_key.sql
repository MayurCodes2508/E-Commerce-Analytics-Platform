
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_key
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_product_sales`
where product_key is null



  
  
      
    ) dbt_internal_test