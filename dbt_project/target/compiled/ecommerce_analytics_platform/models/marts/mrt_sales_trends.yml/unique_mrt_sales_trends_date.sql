
    
    

with dbt_test__target as (

  select date as unique_field
  from `intense-pixel-490219-h2`.`prod_marts`.`mrt_sales_trends`
  where date is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


