-- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into `intense-pixel-490219-h2`.`dev_core`.`fct_shipments` as DBT_INTERNAL_DEST
        using (
        select
        * from `intense-pixel-490219-h2`.`dev_core`.`fct_shipments__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.shipment_key = DBT_INTERNAL_DEST.shipment_key))

    
    when matched then update set
        `shipment_key` = DBT_INTERNAL_SOURCE.`shipment_key`,`shipment_id` = DBT_INTERNAL_SOURCE.`shipment_id`,`order_key` = DBT_INTERNAL_SOURCE.`order_key`,`shipped_date_key` = DBT_INTERNAL_SOURCE.`shipped_date_key`,`delivered_date_key` = DBT_INTERNAL_SOURCE.`delivered_date_key`,`shipment_status` = DBT_INTERNAL_SOURCE.`shipment_status`,`shipped_at` = DBT_INTERNAL_SOURCE.`shipped_at`,`delivered_at` = DBT_INTERNAL_SOURCE.`delivered_at`
    

    when not matched then insert
        (`shipment_key`, `shipment_id`, `order_key`, `shipped_date_key`, `delivered_date_key`, `shipment_status`, `shipped_at`, `delivered_at`)
    values
        (`shipment_key`, `shipment_id`, `order_key`, `shipped_date_key`, `delivered_date_key`, `shipment_status`, `shipped_at`, `delivered_at`)


    