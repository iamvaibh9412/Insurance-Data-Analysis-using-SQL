-- 1) Analyze monthly changes in termination counts
-- This query calculates the month-over-month percentage change in termination counts.
SELECT 
  term_date,
  total,
  COALESCE(ROUND(((total - LAG(total) OVER (ORDER BY term_date))::NUMERIC/LAG(total) OVER (ORDER BY term_date))*100, 2), 0) AS percentage_change
FROM(
  SELECT
    TO_CHAR(acct_suspd_date, 'YYYY-MM') AS term_date,
    COUNT(individual_id) as total
  FROM termination
  GROUP BY term_date
  ORDER BY term_date
) AS monthly_totals;


-- 2) Analyze average tenure and total terminations by month
-- This query provides insights into customer tenure and total terminations for each month.
WITH tenure_term AS(
  SELECT 
    TO_CHAR(acct_suspd_date, 'YYYY-MM') as date,
    ROUND(AVG(days_tenure)::NUMERIC, 2) AS tenure,
  COUNT(individual_id) AS total_term
  FROM customer c
  JOIN termination t USING (individual_id)
  GROUP BY date
  ORDER BY date
)
SELECT
  date,
  tenure,
  total_term,
  RANK() OVER (ORDER BY tenure DESC) AS rank_tenure,
  RANK() OVER (ORDER BY total_term DESC) AS rank_term
FROM tenure_term;

