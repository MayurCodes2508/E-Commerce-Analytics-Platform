SELECT product_key,
       product_name,
       category,
       SUM(line_total) AS gross_revenue_by_product,

       SUM(CASE
               WHEN order_status NOT IN ('cancelled', 'refunded') THEN line_total
           END) AS net_revenue_by_product,

       SUM(CASE
               WHEN order_status IN ('delivered', 'shipped') THEN line_total
           END) AS realized_revenue_by_product,
       CURRENT_TIMESTAMP() AS dbt_loaded_at

FROM `intense-pixel-490219-h2`.`dev_core`.`int_sales_base`
GROUP BY product_key, product_name, category

-- just