USE [Walmart Analysis]
--CLEANING DATA 


select * from [Walmart ]
-- Checking column data types and nulls
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Walmart';

-- Check for missing values
SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity
FROM [Walmart ];

-- Update unit_price to remove '$' and cast to decimal
UPDATE [Walmart ]
SET unit_price = REPLACE(unit_price, '$', '');

-- Alter column to correct data type (if not already decimal)
ALTER TABLE [Walmart]
ALTER COLUMN unit_price DECIMAL(10, 2);

-- Remove rows with null unit_price or quantity
DELETE FROM [Walmart ]
WHERE unit_price IS NULL OR quantity IS NULL;

-- Create a cleaned version of the table
SELECT 
    invoice_id,
    Branch,
    City,
    category,
    CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    quantity,
    CONVERT(DATE, date, 105) AS sale_date,
    CAST(time AS TIME) AS sale_time,
    payment_method,
    rating,
    profit_margin
INTO WalmartSales_Cleaned
FROM [Walmart ]
WHERE unit_price IS NOT NULL AND quantity IS NOT NULL;

-- Add total_sales column and day_of_week

ALTER TABLE WalmartSales_Cleaned ADD total_sales DECIMAL(10,2), day_of_week VARCHAR(10);
UPDATE WalmartSales_Cleaned
SET 
    total_sales = unit_price * quantity,
    day_of_week = DATENAME(WEEKDAY, sale_date);

-- Add time_of_day column
ALTER TABLE WalmartSales_Cleaned ADD time_of_day VARCHAR(10);

UPDATE WalmartSales_Cleaned
SET time_of_day = 
    CASE 
        WHEN CAST(sale_time AS TIME) BETWEEN '06:00:00' AND '12:00:00' THEN 'Morning'
        WHEN CAST(sale_time AS TIME) BETWEEN '12:00:01' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;

-- Add month and quarter
ALTER TABLE WalmartSales_Cleaned ADD sale_month VARCHAR(15), sale_quarter VARCHAR(10);
UPDATE WalmartSales_Cleaned
SET 
    sale_month = DATENAME(MONTH, sale_date),
    sale_quarter = 'Q' + CAST(DATEPART(QUARTER, sale_date) AS VARCHAR);

SELECT  *
FROM WalmartSales_Cleaned
ORDER BY sale_date ASC;