
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipment_id
from `intense-pixel-490219-h2`.`ci_dev_core`.`fct_shipments`
where shipment_id is null



  
  
      
    ) dbt_internal_test