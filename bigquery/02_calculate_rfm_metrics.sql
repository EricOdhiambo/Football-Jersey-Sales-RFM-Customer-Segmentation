-- Step 2: Calculate recency, frequency, monetary, r, f, m ranks
-- Combine views with CTEs
CREATE OR REPLACE VIEW `rfmanalysis-497208.sales.rfm_metrics`
AS
WITH current_date AS (
  SELECT DATE('2026-05-24') AS analysis_date -- today's date
),
rfm AS (
  SELECT
    CustomerID,
    MAX(OrderDate) AS last_order_date,
    DATE_DIFF((SELECT analysis_date FROM current_date), MAX(OrderDate), DAY) AS recency,
    COUNT(*) AS frequency,
    SUM(OrderValue) AS monetary
  FROM `rfmanalysis-497208.sales.sales_2025`
  GROUP BY CustomerID
)
SELECT
  rfm.*,
  ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
  ROW_NUMBER() OVER(ORDER BY frequency DESC) AS f_rank,
  ROW_NUMBER() OVER(ORDER BY monetary DESC) AS m_rank
FROM rfm;
