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