
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select payment_id
from `intense-pixel-490219-h2`.`prod_staging`.`stg_payments`
where payment_id is null



  
  
      
    ) dbt_internal_test