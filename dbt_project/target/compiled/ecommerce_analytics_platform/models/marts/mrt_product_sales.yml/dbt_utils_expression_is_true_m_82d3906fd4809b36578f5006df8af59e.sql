



select
    1
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_product_sales`

where not(net_revenue_by_product <= gross_revenue_by_product)

