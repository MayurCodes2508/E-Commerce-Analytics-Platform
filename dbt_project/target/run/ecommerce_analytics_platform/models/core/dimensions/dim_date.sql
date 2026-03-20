
  
    

    create or replace table `intense-pixel-490219-h2`.`ci_dev_core`.`dim_date`
        
  (
    date_key INT64,
    date date
    
    )

      
    
    

    
    OPTIONS()
    as (
      
    select date_key, date
    from (
        WITH calendar AS (
SELECT date
FROM UNNEST(GENERATE_DATE_ARRAY('2025-01-01', '2030-12-31')) AS date
)

SELECT CAST(FORMAT_DATE('%Y%m%d', date) AS INT64) AS date_key,
       date
FROM calendar
    ) as model_subq
    );
  