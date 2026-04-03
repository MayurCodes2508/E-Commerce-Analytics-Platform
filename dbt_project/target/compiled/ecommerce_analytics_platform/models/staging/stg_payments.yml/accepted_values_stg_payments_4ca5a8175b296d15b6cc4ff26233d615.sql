
    
    

with all_values as (

    select
        payment_method as value_field,
        count(*) as n_records

    from `intense-pixel-490219-h2`.`dev_staging`.`stg_payments`
    group by payment_method

)

select *
from all_values
where value_field not in (
    'apple_pay','credit_card','paypal','bank_transfer','google_pay'
)


