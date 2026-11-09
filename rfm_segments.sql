
-- ---------------------------------------------------------------------------------------------------------------
-- Project: Football Jersey Sales Analysis
-- Author: Odhiambo Paul Erick
-- Date: 2026-05-24
-- Description: This SQL script performs an RFM analysis on football jerseys sales data, to segment customers based on 
-- their recency of purchase, frequency of purchase, and monetary value of their purchase. 
-- The script combines monthly sales data from January 2025 to December 2025, calculates RFM metrics, assigns scores, 
-- and creates customer segments for targeted marketing strategies.
-- ---------------------------------------------------------------------------------------------------------------



-- Step 1: Append all monthly sales tables together

CREATE OR REPLACE TABLE `rfmanalysis-497208.sales.sales_2025` AS 
SELECT * FROM `rfmanalysis-497208.sales.sales202501`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202502`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202503`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202504`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202505`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202506`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202507`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202508`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202509`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202510`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202511`
UNION ALL SELECT * FROM `rfmanalysis-497208.sales.sales202512`;

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

--Step 3: Assigning deciles (10=best, 1 =worst)
CREATE OR REPLACE VIEW `rfmanalysis-497208.sales.rfm_scores`
AS
SELECT 
  *,
  NTILE(10) OVER(ORDER BY r_rank DESC) AS r_score,
  NTILE(10) OVER(ORDER BY f_rank DESC) AS f_score,
  NTILE(10) OVER(ORDER BY m_rank DESC) AS m_score,
FROM `rfmanalysis-497208.sales.rfm_metrics`;


-- Step 4: Total score
CREATE OR REPLACE VIEW `rfmanalysis-497208.sales.rfm_total_scores`
AS
SELECT
 CustomerID,
 recency,
 frequency,
 monetary,
 r_score,
 f_score,
 m_score,
 (r_score + f_score + m_score) AS rfm_total_score
FROM `rfmanalysis-497208.sales.rfm_scores`
ORDER BY rfm_total_score DESC;
-- dsds

-- Step 5: BI ready rfm segments table
CREATE OR REPLACE TABLE `rfmanalysis-497208.sales.rfm_segments_final`
AS
SELECT
   CustomerID,
   recency,
   frequency,
   monetary,
   r_score,
   f_score,
   m_score,
   rfm_total_score,
   CASE
    WHEN rfm_total_score >= 28 THEN 'Champions'
    WHEN rfm_total_score >= 24 THEN 'Loyal VIPs'
    WHEN rfm_total_score >= 20 THEN 'Potential Loyalists'
    WHEN rfm_total_score >= 16 THEN 'Promising'
    WHEN rfm_total_score >= 12 THEN 'Engaged'
    WHEN rfm_total_score >= 8 THEN 'Requires Attention'
    WHEN rfm_total_score >= 4 THEN 'At Risk'
    ELSE 'Lost/Inactive'
   END AS rfm_segment
FROM `rfmanalysis-497208.sales.rfm_total_scores`
ORDER BY rfm_total_score DESC;










