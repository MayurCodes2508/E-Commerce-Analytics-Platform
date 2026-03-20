



select
    1
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_sales_trends`

where not(valid_orders_by_date <= total_orders_by_date)

