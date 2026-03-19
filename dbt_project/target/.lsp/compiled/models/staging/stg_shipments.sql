SELECT shipment_id,
       order_id,
       TRIM(shipment_status) AS shipment_status,
       CAST(shipped_at AS TIMESTAMP) AS shipped_at,
       CAST(delivered_at AS TIMESTAMP) AS delivered_at,
       ingestion_timestamp
FROM `intense-pixel-490219-h2`.`raw`.`shipments`
QUALIFY ROW_NUMBER() OVER(PARTITION BY shipment_id ORDER BY ingestion_timestamp DESC) = 1