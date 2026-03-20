
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select payment_key
from `intense-pixel-490219-h2`.`dev_core`.`fct_payments`
where payment_key is null



  
  
      
    ) dbt_internal_test