
  
    

    create or replace table `intense-pixel-490219-h2`.`prod_marts`.`mrt_order_status_bucket`
      
    
    

    
    OPTIONS()
    as (
      SELECT CASE
           WHEN order_status IN ('delivered', 'shipped') THEN 'Completed'
           WHEN order_status IN ('cancelled', 'refunded') THEN 'Cancelled/Refunded'
           WHEN order_status = 'paid' THEN 'Paid'
           WHEN order_status = 'created' THEN 'Created'
           ELSE 'Other'
       END AS order_status_bucket,
       COUNT(DISTINCT order_key) AS total_orders,
       CURRENT_TIMESTAMP() AS dbt_loaded_at
FROM `intense-pixel-490219-h2`.`prod_core`.`int_sales_base`
GROUP BY order_status_bucket
    );
  