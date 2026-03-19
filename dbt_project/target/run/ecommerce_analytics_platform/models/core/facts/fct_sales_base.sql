-- back compat for old kwarg name
  
  
        
    

    

    merge into `intense-pixel-490219-h2`.`dev_core`.`fct_sales_base` as DBT_INTERNAL_DEST
        using (
        select
        * from `intense-pixel-490219-h2`.`dev_core`.`fct_sales_base__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on (FALSE)

    

    when not matched then insert
        (`order_item_key`, `order_key`, `product_key`, `date_key`, `date`, `order_status`, `product_name`, `category`, `line_total`)
    values
        (`order_item_key`, `order_key`, `product_key`, `date_key`, `date`, `order_status`, `product_name`, `category`, `line_total`)


    