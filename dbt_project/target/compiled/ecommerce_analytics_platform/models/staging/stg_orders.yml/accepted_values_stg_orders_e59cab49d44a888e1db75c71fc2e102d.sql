
    
    

with all_values as (

    select
        order_status as value_field,
        count(*) as n_records

    from `intense-pixel-490219-h2`.`ci_dev_staging`.`stg_orders`
    group by order_status

)

select *
from all_values
where value_field not in (
    'paid','created','delivered','cancelled','refunded','shipped'
)


