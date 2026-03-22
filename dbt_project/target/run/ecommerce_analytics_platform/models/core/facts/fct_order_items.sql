-- back compat for old kwarg name
  
  
        
            
	    
	    
            
        
    

    

    merge into `intense-pixel-490219-h2`.`dev_core`.`fct_order_items` as DBT_INTERNAL_DEST
        using (
        select
        * from `intense-pixel-490219-h2`.`dev_core`.`fct_order_items__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.order_item_key = DBT_INTERNAL_DEST.order_item_key))

    
    when matched then update set
        `order_item_key` = DBT_INTERNAL_SOURCE.`order_item_key`,`order_item_id` = DBT_INTERNAL_SOURCE.`order_item_id`,`order_key` = DBT_INTERNAL_SOURCE.`order_key`,`product_key` = DBT_INTERNAL_SOURCE.`product_key`,`order_item_created_at_date_key` = DBT_INTERNAL_SOURCE.`order_item_created_at_date_key`,`created_at` = DBT_INTERNAL_SOURCE.`created_at`,`quantity` = DBT_INTERNAL_SOURCE.`quantity`,`price` = DBT_INTERNAL_SOURCE.`price`,`line_total` = DBT_INTERNAL_SOURCE.`line_total`
    

    when not matched then insert
        (`order_item_key`, `order_item_id`, `order_key`, `product_key`, `order_item_created_at_date_key`, `created_at`, `quantity`, `price`, `line_total`)
    values
        (`order_item_key`, `order_item_id`, `order_key`, `product_key`, `order_item_created_at_date_key`, `created_at`, `quantity`, `price`, `line_total`)


    