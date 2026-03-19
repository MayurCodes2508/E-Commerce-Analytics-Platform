



select
    1
from `intense-pixel-490219-h2`.`prod_marts`.`mrt_sales_trends`

where not(completed_orders <= valid_orders)

