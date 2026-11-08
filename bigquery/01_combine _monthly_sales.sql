-- Step 1: Append all monthly sales tables together; 
-- This script combines monthly sales data
CREATE OR REPLACE TABLE 
  `rfmanalysis-497208.sales.sales_2025` AS 

SELECT * FROM `rfmanalysis-497208.sales.sales202501`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202502`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202503`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202504`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202505`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202506`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202507`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202508`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202509`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202510`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202511`
UNION ALL 
SELECT * FROM `rfmanalysis-497208.sales.sales202512`;