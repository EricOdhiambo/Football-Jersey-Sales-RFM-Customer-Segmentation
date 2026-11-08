--Step 3: Assigning deciles (10=best, 1 =worst)
CREATE OR REPLACE VIEW `rfmanalysis-497208.sales.rfm_scores`
AS
SELECT 
  *,
  NTILE(10) OVER(ORDER BY r_rank DESC) AS r_score,
  NTILE(10) OVER(ORDER BY f_rank DESC) AS f_score,
  NTILE(10) OVER(ORDER BY m_rank DESC) AS m_score
FROM `rfmanalysis-497208.sales.rfm_metrics`;