
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select date
from `intense-pixel-490219-h2`.`dev_core`.`dim_date`
where date is null



  
  
      
    ) dbt_internal_test