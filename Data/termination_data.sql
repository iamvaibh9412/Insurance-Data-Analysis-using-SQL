-- Termination Data
-- Create the 'termination' table
CREATE TABLE termination(
  individual_id FLOAT,
  acct_suspd_date DATE
);

-- Load data from CSV file
COPY termination
FROM '/Users/gulsumasenacakir/Downloads/termination.csv'
DELIMITER ','
CSV HEADER;

-- Assign Primary Key (PK)
-- Check for null values in the 'individual_id' column
SELECT *
FROM termination
WHERE individual_id IS NULL;

-- Check for duplicate values in the 'individual_id' column
SELECT individual_id, COUNT(*)
FROM termination
GROUP BY individual_id
HAVING COUNT(*)>1;

-- Add Primary Key constraint to the 'individual_id' column
ALTER TABLE termination
ADD CONSTRAINT pk_termination PRIMARY KEY (individual_id);