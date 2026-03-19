



select
    1
from `intense-pixel-490219-h2`.`dev_staging`.`stg_shipments`

where not(delivered_at (shipment_status NOT IN ('delivered', 'returned') OR delivered_at IS NOT NULL))

