-- 1) Analyze the relationship between churn status and key customer attributes
-- This query categorizes customers based on their churn status (whether they have cancelled their insurance or not).
WITH churn AS (
-- Step 1: Join customer and termination tables to get churn information for each customer
  SELECT 
    c.*,
    t.acct_suspd_date
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
),
updated_churn AS(
-- Step 2: Create a new dataset with relevant fields and assign churn status
  SELECT
    individual_id,
    curr_ann_prem,
    days_tenure,
    age_in_years,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE curr_ann_prem > 0
)
-- Step 3: Calculate the average annual premium, average age, and average tenure based on their churn status
SELECT 
  CASE WHEN churn = 1 THEN 'YES' ELSE 'NO' END AS churn_status,
  AVG(curr_ann_prem) AS avg_premium,
  AVG(age_in_years) AS avg_age,
  AVG(days_tenure) AS avg_tenure
FROM updated_churn
GROUP BY churn_status;

-- 2) Analyze the churn rate based on tenure 
-- This query categorizes customers into different tenure groups based on how long they have been with the company (in days).
WITH churn AS (
-- Step 1: Join customer and termination tables to get churn information for each customer
  SELECT 
    c.*,
    t.acct_suspd_date
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
),
updated_churn AS (
-- Step 2: Create a new dataset with relevant fields and assign churn status
  SELECT
    individual_id,
    curr_ann_prem,
    days_tenure,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE curr_ann_prem > 0
)
-- Step 3: Analyze churn rate by tenure group
SELECT 
  CASE 
    WHEN days_tenure <= 365 THEN 'Less than 1 year'
    WHEN days_tenure BETWEEN 366 AND 1095 THEN '1-3 years'
    WHEN days_tenure BETWEEN 1096 AND 1825 THEN '3-5 years'
    ELSE 'More than 5 years'
  END AS tenure_group,
  COUNT(*) AS customer_count,
  (SUM(churn)::NUMERIC / COUNT(*) * 100) AS churn_rate
FROM updated_churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;

-- 3) Analyze the churn rate based on income levels
-- This query examines the relationship between customer income levels and churn rate.
WITH churn AS (
-- Step 1: Join customer, termination, and demographic tables to get churn information and demographic data 
  SELECT 
    c.*,
    t.acct_suspd_date,
    d.income,
    d.college_degree,
    d.has_children
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
  LEFT JOIN demographic d ON c.individual_id = d.individual_id
),
updated_churn AS (
-- Step 2: Assign churn status and select relevant fields for analysis
  SELECT
    individual_id,
    income,
    college_degree,
    has_children,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE income IS NOT NULL
    AND curr_ann_prem > 0
)
-- Step 3: Analyze churn rate by income group
SELECT 
  CASE 
    WHEN income <= 47500 THEN 'Low Income'
    WHEN income BETWEEN 47501 AND 87500 THEN 'Middle Income'
    ELSE 'High Income'
  END AS income_group,
  (SUM(churn)::NUMERIC / COUNT(*) * 100) AS churn_rate
FROM updated_churn
GROUP BY income_group
ORDER BY churn_rate DESC;

-- 4) Analyze the churn rate based on education level
-- This query examines the relationship between a customer's education level (whether they have a college degree or not) and their churn rate.
WITH churn AS (
-- Step 1: Join customer, termination, and demographic tables to get churn information and demographic data 
  SELECT 
    c.*,
    t.acct_suspd_date,
    d.college_degree
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
  LEFT JOIN demographic d ON c.individual_id = d.individual_id
),
updated_churn AS (
-- Step 2: Assign churn status and select relevant fields for analysis
  SELECT
    individual_id,
    college_degree,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE curr_ann_prem > 0
)
-- Step 3: Analyze churn rate by education level
SELECT 
  CASE WHEN college_degree = 1 THEN 'College Degree' ELSE 'No College Degree' END AS education_level,
  (SUM(churn)::NUMERIC / COUNT(*) * 100) AS churn_rate
FROM updated_churn
GROUP BY education_level;

-- 5) Analyze the churn rate based on home ownership
-- This query examines the relationship between a customer's home ownership status and their churn rate.
WITH churn AS (
-- Step 1: Join customer, termination, and demographic tables to get churn information and demographic data 
  SELECT 
    c.*,
    t.acct_suspd_date,
    d.home_owner
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
  LEFT JOIN demographic d ON c.individual_id = d.individual_id
),
updated_churn AS (
-- Step 2: Assign churn status and select relevant fields for analysis
  SELECT
    individual_id,
    home_owner,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE curr_ann_prem > 0
)
-- Step 3: Analyze churn rate based on home ownership
SELECT 
  CASE WHEN home_owner = 1 THEN 'Owner' ELSE 'Not Owner' END AS status,
  (SUM(churn)::NUMERIC / COUNT(*) * 100) AS churn_rate
FROM updated_churn
GROUP BY status;

-- 6) Analyze the churn rate based on credit status
-- This query examines the relationship between a customer's credit status and their churn rate.
WITH churn AS (
-- Step 1: Join customer, termination, and demographic tables to get churn information and demographic data 
  SELECT 
    c.*,
    t.acct_suspd_date,
    d.good_credit
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
  LEFT JOIN demographic d ON c.individual_id = d.individual_id
),
updated_churn AS (
-- Step 2: Assign churn status and select relevant fields for analysis
  SELECT
    individual_id,
    good_credit,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE curr_ann_prem > 0
)
-- Step 3: Analyze churn rate based on credit status
SELECT 
  CASE WHEN good_credit = 1 THEN 'Good Credit' ELSE 'Not Good Credit' END AS status,
  (SUM(churn)::NUMERIC / COUNT(*) * 100) AS churn_rate
FROM updated_churn
GROUP BY status;

-- 7) Analyze the churn rate by city
-- This query examines the churn rate for each city, showing the top 10 cities with the highest churn rates.
WITH churn AS (
-- Step 1: Join customer, termination, and address tables to get churn information and geographic data
  SELECT 
    c.*,
    t.acct_suspd_date,
    a.city,
	a.county
  FROM customer c
  LEFT JOIN termination t ON c.individual_id = t.individual_id
  LEFT JOIN address a ON c.address_id = a.address_id
),
updated_churn AS (
-- Step 2: Assign churn status and select relevant fields for analysis
  SELECT
    individual_id,
    city,
	county,
    CASE WHEN acct_suspd_date IS NULL THEN 0 ELSE 1 END AS churn
  FROM churn
  WHERE curr_ann_prem > 0
)
-- Step 3: Analyze churn rate by city
SELECT 
  city,
  county,
  COUNT(*) AS customer_count,
  (SUM(churn)::NUMERIC / COUNT(*) * 100) AS churn_rate
FROM updated_churn
GROUP BY city, county
ORDER BY churn_rate DESC
LIMIT 10; 

