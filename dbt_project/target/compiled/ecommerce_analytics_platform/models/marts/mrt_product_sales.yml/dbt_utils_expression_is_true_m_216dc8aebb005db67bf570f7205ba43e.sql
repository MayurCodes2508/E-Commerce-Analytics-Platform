



select
    1
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_product_sales`

where not(realized_revenue_by_product <= net_revenue_by_product)

