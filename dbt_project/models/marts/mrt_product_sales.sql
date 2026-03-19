SELECT product_key,
       product_name,
       category,
       SUM(line_total) AS gross_revenue,

       SUM(CASE
               WHEN order_status != 'refunded' THEN line_total
           END) AS net_revenue,

       SUM(CASE
               WHEN order_status IN ('delivered', 'shipped') THEN line_total
           END) AS realized_revenue,
       CURRENT_TIMESTAMP() AS dbt_loaded_at

FROM {{ ref('int_sales_base') }}
GROUP BY product_key, product_name, category