



select
    1
from `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`

where not(net_revenue net_revenue <= gross_revenue)

