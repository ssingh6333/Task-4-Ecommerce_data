use Ecommerce;
SHOW VARIABLES LIKE 'local_infile';
DROP TABLE ecommerce_data;
CREATE TABLE ecommerce_data (
    InvoiceNo VARCHAR(30),
    StockCode VARCHAR(30),
    Description VARCHAR(200),
    Quantity INT,
    InvoiceDate VARCHAR(30), -- temporarily keep as text
    UnitPrice DECIMAL(10,2),
    CustomerID VARCHAR(20),
    Country VARCHAR(40)
);
LOAD DATA LOCAL INFILE 'C:/Users/Dell/Downloads/Ecom_utf.csv'  -- import the data
INTO TABLE ecommerce_data
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country);
ALTER TABLE ecommerce_data ADD InvoiceDate_clean DATETIME;
SET SQL_SAFE_UPDATES = 0;

UPDATE ecommerce_data
SET InvoiceDate_clean = 
    CASE
        WHEN InvoiceDate LIKE '%/%' THEN STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')
        WHEN InvoiceDate LIKE '%-%' THEN STR_TO_DATE(InvoiceDate, '%m-%d-%Y %H:%i')
        ELSE NULL
    END;
-- Select command
select *
from ecommerce_data
limit 10;
-- Total Revenue
select 
round(sum(Quantity * UnitPrice),2) As TotalRevenue
from ecommerce_data;
-- Revenue by country
Select Country ,
Round(sum(Quantity * UnitPrice),2) As Total_Revenue
From ecommerce_data
Group by Country
Order by Total_Revenue Desc;
-- Total Top 10 Customer spending
SELECT 
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Spent
FROM ecommerce_data
GROUP BY CustomerID
ORDER BY Total_Spent DESC
LIMIT 10;

-- Most Sold Product
SELECT 
    Description,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_data
GROUP BY Description
ORDER BY Total_Quantity DESC
LIMIT 10;





