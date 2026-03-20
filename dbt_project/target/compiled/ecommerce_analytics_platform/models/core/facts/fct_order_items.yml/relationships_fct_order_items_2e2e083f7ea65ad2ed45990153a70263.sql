
    
    

with child as (
    select product_key as from_field
    from `intense-pixel-490219-h2`.`ci_dev_core`.`fct_order_items`
    where product_key is not null
),

parent as (
    select product_key as to_field
    from `intense-pixel-490219-h2`.`ci_dev_core`.`dim_products`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


