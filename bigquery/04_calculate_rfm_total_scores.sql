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
