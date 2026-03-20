
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        order_status_bucket as value_field,
        count(*) as n_records

    from `intense-pixel-490219-h2`.`dev_marts`.`mrt_order_status_bucket`
    group by order_status_bucket

)

select *
from all_values
where value_field not in (
    'Completed','Cancelled/Refunded','Paid','Created','Other'
)



  
  
      
    ) dbt_internal_test