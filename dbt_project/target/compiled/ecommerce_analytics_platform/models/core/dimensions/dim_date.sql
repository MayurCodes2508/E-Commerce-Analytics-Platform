WITH calendar AS (
SELECT date
FROM UNNEST(GENERATE_DATE_ARRAY('2025-01-01', '2030-12-31')) AS date
)

SELECT CAST(FORMAT_DATE('%Y%m%d', date) AS INT64) AS date_key,
       date
FROM calendar