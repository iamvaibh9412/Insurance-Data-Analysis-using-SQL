-- Demographic Data
-- Create the 'demographic' table
CREATE TABLE demographic(
  individual_id FLOAT,
  income FLOAT,
  has_children FLOAT,
  length_of_residence FLOAT,
  marital VARCHAR(50),
  home_market_value VARCHAR(255),
  home_owner FLOAT,
  college_degree FLOAT,
  good_credit FLOAT
);

-- Load data from CSV file
COPY demographic
FROM '/Users/gulsumasenacakir/Downloads/demographic.csv'
DELIMITER ','
CSV HEADER;

-- Assign Primary Key (PK)
-- Check for null values in the 'individual_id' column
SELECT *
FROM demographic
WHERE individual_id IS NULL;

-- Check for duplicate values in the 'individual_id' column
SELECT individual_id, COUNT(*)
FROM demographic
GROUP BY individual_id
HAVING COUNT(*)>1;

-- Add Primary Key constraint to the 'individual_id' column
ALTER TABLE demographic
ADD CONSTRAINT pk_demographic PRIMARY KEY (individual_id);