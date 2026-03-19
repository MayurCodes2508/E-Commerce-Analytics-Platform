
  
    

    create or replace table `intense-pixel-490219-h2`.`prod_marts`.`mrt_sales_trends`
      
    
    

    
    OPTIONS()
    as (
      SELECT
    date,

    SUM(line_total) AS gross_revenue,

    SUM(CASE
        WHEN order_status != 'refunded' THEN line_total
    END) AS net_revenue,

    SUM(CASE
        WHEN order_status IN ('delivered', 'shipped') THEN line_total
    END) AS realized_revenue,

    COUNT(DISTINCT order_key) AS total_orders,
  
    COUNT(DISTINCT CASE
        WHEN order_status != 'cancelled' THEN order_key
    END) AS valid_orders,

    COUNT(DISTINCT CASE
        WHEN order_status IN ('delivered', 'shipped') THEN order_key
    END) AS completed_orders,

    SAFE_DIVIDE(SUM(line_total), COUNT(DISTINCT order_key)) AS gross_aov,

    SAFE_DIVIDE(SUM(CASE
        WHEN order_status != 'refunded' THEN line_total
    END), COUNT(DISTINCT CASE
        WHEN order_status != 'cancelled' THEN order_key
    END)) AS net_aov,

    SAFE_DIVIDE(SUM(CASE
        WHEN order_status IN ('delivered', 'shipped') THEN line_total
    END), COUNT(DISTINCT CASE
        WHEN order_status IN ('delivered', 'shipped') THEN order_key
    END)) AS realized_aov,
    CURRENT_TIMESTAMP() AS dbt_loaded_at

FROM `intense-pixel-490219-h2`.`prod_core`.`int_sales_base`
GROUP BY date
    );
  