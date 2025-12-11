-- Customer Data
-- Create the 'customer' table
CREATE TABLE customer(
   individual_id FLOAT,
   address_id FLOAT,
   curr_ann_prem FLOAT,
   days_tenure FLOAT,
   cust_orig_date DATE,
   age_in_years FLOAT,
   date_of_birth DATE,
   social_sec_number VARCHAR(50)
);

-- Load data from CSV file
COPY customer
FROM '/Users/gulsumasenacakir/Downloads/customer.csv'
DELIMITER ','
CSV HEADER;

-- Assign Primary Key (PK)
-- Check for null values in the 'individual_id' column
SELECT *
FROM customer
WHERE individual_id IS NULL; -- Only one null value is found

-- Remove the row with null 'individual_id'
DELETE FROM customer
WHERE individual_id IS NULL;

-- Check for duplicate values in the 'individual_id' column
SELECT individual_id, COUNT(*)
FROM customer
GROUP BY individual_id
HAVING COUNT(*)>1;

-- Add Primary Key constraint to the 'individual_id' column
ALTER TABLE customer
ADD CONSTRAINT pk_customer PRIMARY KEY (individual_id);

-- Assign Foreign Key (FK)
-- First, check for full match of 'address_id' between 'customer' and 'address' tables
SELECT COUNT(*)
FROM customer c
WHERE NOT EXISTS(
  SELECT 1
  FROM address a
  WHERE a.address_id = c.address_id
);

-- Then, add Foreign Key constraint linking 'address_id' in 'customer' to 'address_id' in 'address'
ALTER TABLE customer
ADD CONSTRAINT fk_address
FOREIGN KEY (address_id) REFERENCES address(address_id);