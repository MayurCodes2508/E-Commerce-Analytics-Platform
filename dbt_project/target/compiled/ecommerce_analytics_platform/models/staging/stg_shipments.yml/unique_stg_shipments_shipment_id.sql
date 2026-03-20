
    
    

with dbt_test__target as (

  select shipment_id as unique_field
  from `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_shipments`
  where shipment_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


