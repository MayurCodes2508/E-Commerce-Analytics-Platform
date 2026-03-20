-- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into `intense-pixel-490219-h2`.`dev_core`.`fct_orders` as DBT_INTERNAL_DEST
        using (
        select
        * from `intense-pixel-490219-h2`.`dev_core`.`fct_orders__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.order_key = DBT_INTERNAL_DEST.order_key))

    
    when matched then update set
        `order_key` = DBT_INTERNAL_SOURCE.`order_key`,`order_id` = DBT_INTERNAL_SOURCE.`order_id`,`customer_key` = DBT_INTERNAL_SOURCE.`customer_key`,`order_created_at_date_key` = DBT_INTERNAL_SOURCE.`order_created_at_date_key`,`created_at` = DBT_INTERNAL_SOURCE.`created_at`,`order_status` = DBT_INTERNAL_SOURCE.`order_status`
    

    when not matched then insert
        (`order_key`, `order_id`, `customer_key`, `order_created_at_date_key`, `created_at`, `order_status`)
    values
        (`order_key`, `order_id`, `customer_key`, `order_created_at_date_key`, `created_at`, `order_status`)


    