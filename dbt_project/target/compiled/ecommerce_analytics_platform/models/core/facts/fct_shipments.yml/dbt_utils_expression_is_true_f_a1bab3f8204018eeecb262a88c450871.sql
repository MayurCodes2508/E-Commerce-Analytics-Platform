



select
    1
from (select * from `intense-pixel-490219-h2`.`dev_core`.`fct_shipments` where delivered_at is not null) dbt_subquery

where not(delivered_at >= shipped_at)

