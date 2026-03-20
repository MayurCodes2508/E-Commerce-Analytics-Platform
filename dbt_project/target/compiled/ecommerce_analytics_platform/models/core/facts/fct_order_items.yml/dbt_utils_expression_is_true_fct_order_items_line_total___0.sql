



select
    1
from `intense-pixel-490219-h2`.`ci_dev_core`.`fct_order_items`

where not(line_total >= 0)

