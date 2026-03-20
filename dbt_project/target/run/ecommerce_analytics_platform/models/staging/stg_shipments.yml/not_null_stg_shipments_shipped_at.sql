
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipped_at
from `intense-pixel-490219-h2`.`dev_staging`.`stg_shipments`
where shipped_at is null



  
  
      
    ) dbt_internal_test