
  
    

    create or replace table `intense-pixel-490219-h2`.`dev_marts`.`mrt_sales_trends`
      
    
    

    
    OPTIONS()
    as (
      SELECT
    date,

    SUM(line_total) AS gross_revenue_by_date,

    SUM(CASE
        WHEN order_status NOT IN ('cancelled', 'refunded') THEN line_total
    END) AS net_revenue_by_date,

    SUM(CASE
        WHEN order_status IN ('delivered', 'shipped') THEN line_total
    END) AS realized_revenue_by_date,

    COUNT(DISTINCT order_key) AS total_orders_by_date,
  
    COUNT(DISTINCT CASE
        WHEN order_status NOT IN ('cancelled', 'refunded') THEN order_key
    END) AS valid_orders_by_date,

    COUNT(DISTINCT CASE
        WHEN order_status IN ('delivered', 'shipped') THEN order_key
    END) AS completed_orders_by_date,

    SAFE_DIVIDE(SUM(line_total), COUNT(DISTINCT order_key)) AS gross_aov_by_date,

    SAFE_DIVIDE(SUM(CASE
        WHEN order_status NOT IN ('cancelled', 'refunded') THEN line_total
    END), COUNT(DISTINCT CASE
        WHEN order_status NOT IN ('cancelled', 'refunded') THEN order_key
    END)) AS net_aov_by_date,

    SAFE_DIVIDE(SUM(CASE
        WHEN order_status IN ('delivered', 'shipped') THEN line_total
    END), COUNT(DISTINCT CASE
        WHEN order_status IN ('delivered', 'shipped') THEN order_key
    END)) AS realized_aov_by_date,
    CURRENT_TIMESTAMP() AS dbt_loaded_at

FROM `intense-pixel-490219-h2`.`dev_core`.`int_sales_base`
GROUP BY date
    );
  