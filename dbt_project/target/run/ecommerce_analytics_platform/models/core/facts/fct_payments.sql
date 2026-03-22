-- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into `intense-pixel-490219-h2`.`dev_core`.`fct_payments` as DBT_INTERNAL_DEST
        using (
        select
        * from `intense-pixel-490219-h2`.`dev_core`.`fct_payments__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.payment_key = DBT_INTERNAL_DEST.payment_key))

    
    when matched then update set
        `payment_key` = DBT_INTERNAL_SOURCE.`payment_key`,`payment_id` = DBT_INTERNAL_SOURCE.`payment_id`,`order_key` = DBT_INTERNAL_SOURCE.`order_key`,`payment_date_key` = DBT_INTERNAL_SOURCE.`payment_date_key`,`payment_method` = DBT_INTERNAL_SOURCE.`payment_method`,`amount` = DBT_INTERNAL_SOURCE.`amount`,`payment_status` = DBT_INTERNAL_SOURCE.`payment_status`,`payment_timestamp` = DBT_INTERNAL_SOURCE.`payment_timestamp`
    

    when not matched then insert
        (`payment_key`, `payment_id`, `order_key`, `payment_date_key`, `payment_method`, `amount`, `payment_status`, `payment_timestamp`)
    values
        (`payment_key`, `payment_id`, `order_key`, `payment_date_key`, `payment_method`, `amount`, `payment_status`, `payment_timestamp`)


    