SELECT
        oi.order_item_key,
        oi.order_key,
        p.product_key,
        oi.date_key,
        d.date,
        o.order_status,
        p.product_name,
        p.category,
        oi.line_total
    FROM `intense-pixel-490219-h2`.`dev_core`.`fct_order_items` oi
    JOIN `intense-pixel-490219-h2`.`dev_core`.`fct_orders` o ON oi.order_key = o.order_key
    JOIN `intense-pixel-490219-h2`.`dev_core`.`dim_products` p ON oi.product_key = p.product_key
    JOIN `intense-pixel-490219-h2`.`dev_core`.`dim_date` d ON oi.date_key = d.date_key