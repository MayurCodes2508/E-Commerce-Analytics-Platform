



select
    1
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`

where not(completed_orders_by_date <= valid_orders)

