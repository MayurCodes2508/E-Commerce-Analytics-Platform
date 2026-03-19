
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        shipment_status as value_field,
        count(*) as n_records

    from `intense-pixel-490219-h2`.`prod_staging`.`stg_shipments`
    group by shipment_status

)

select *
from all_values
where value_field not in (
    'in_transit','processing','delivered','returned','shipped'
)



  
  
      
    ) dbt_internal_test