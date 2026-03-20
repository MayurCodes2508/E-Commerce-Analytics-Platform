
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select delivered_date_key as from_field
    from `intense-pixel-490219-h2`.`ci_dev_core`.`fct_shipments`
    where delivered_date_key is not null
),

parent as (
    select date_key as to_field
    from `intense-pixel-490219-h2`.`ci_dev_core`.`dim_date`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test