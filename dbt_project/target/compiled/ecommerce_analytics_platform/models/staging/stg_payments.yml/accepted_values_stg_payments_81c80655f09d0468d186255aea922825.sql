
    
    

with all_values as (

    select
        payment_status as value_field,
        count(*) as n_records

    from `intense-pixel-490219-h2`.`prod_staging`.`stg_payments`
    group by payment_status

)

select *
from all_values
where value_field not in (
    'success','failed','refunded'
)


