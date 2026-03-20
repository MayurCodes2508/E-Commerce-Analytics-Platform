



select
    1
from `intense-pixel-490219-h2`.`ci_dev_marts`.`mrt_sales_trends`

where not(net_revenue_by_date <= gross_revenue_by_date)

