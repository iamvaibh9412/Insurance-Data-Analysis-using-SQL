-- Address Data
-- Create the 'address' table
CREATE TABLE address (
    address_id FLOAT,
    latitude FLOAT,
    longitude FLOAT,
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    county VARCHAR(50)
);

-- Load data from CSV file
COPY address
FROM '/Users/gulsumasenacakir/Downloads/address.csv'
DELIMITER ','
CSV HEADER;

-- Assign Primary Key
-- Check for null values in the 'address_id' column
SELECT *
FROM address
WHERE address_id IS NULL;

-- Check for duplicate values in the 'address_id' column
SELECT address_id, COUNT(*)
FROM address
GROUP BY address_id
HAVING COUNT(*)>1

-- Add Primary Key constraint to the 'address_id' column
ALTER TABLE address
ADD CONSTRAINT pk_address PRIMARY KEY (address_id);