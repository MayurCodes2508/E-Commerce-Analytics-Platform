
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `intense-pixel-490219-h2`.`dev_staging`.`stg_shipments`

where not(delivered_at delivered_at IS NULL OR delivered_at >= shipped_at)


  
  
      
    ) dbt_internal_test