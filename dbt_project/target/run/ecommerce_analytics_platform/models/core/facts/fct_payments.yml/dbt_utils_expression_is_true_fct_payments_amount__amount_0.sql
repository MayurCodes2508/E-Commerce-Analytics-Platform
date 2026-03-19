
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`dev_core`.`fct_payments`

where not(amount amount >= 0)


  
  
      
    ) dbt_internal_test