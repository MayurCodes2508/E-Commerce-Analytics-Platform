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
    FROM {{ ref('fct_order_items') }} oi
    JOIN {{ ref('fct_orders') }} o ON oi.order_key = o.order_key
    JOIN {{ ref('dim_products') }} p ON oi.product_key = p.product_key
    JOIN {{ ref('dim_date') }} d ON oi.date_key = d.date_key
   