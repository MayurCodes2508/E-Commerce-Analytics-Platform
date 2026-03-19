



select
    1
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_product_sales`

where not(net_revenue <= gross_revenue)

