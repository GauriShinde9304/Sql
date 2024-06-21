Create Database Customer_Segmentation;
Use Customer_Segmentation;
CREATE TABLE OnlineRetail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATE,
    InvoiceTime TIME,
    CustomerID VARCHAR(20),
    Country VARCHAR(50)
);
Select*From OnlineRetail;
SELECT COUNT(*)FROM OnlineRetail;

##Q1 What is the distribution of order values across all customers in the dataset?

SELECT CustomerID, InvoiceNo, SUM(Quantity) AS TotalOrderValue
FROM OnlineRetail
GROUP BY CustomerID, InvoiceNo;
SELECT CustomerID, SUM(TotalOrderValue) AS CustomerTotalOrderValue
FROM (
    SELECT CustomerID, InvoiceNo, SUM(Quantity) AS TotalOrderValue
    FROM OnlineRetail
    GROUP BY CustomerID, InvoiceNo
) AS InvoiceTotals
GROUP BY CustomerID;
-- Calculate summary statistics
SELECT 
    MIN(CustomerTotalOrderValue) AS MinOrderValue,
    MAX(CustomerTotalOrderValue) AS MaxOrderValue,
    AVG(CustomerTotalOrderValue) AS AvgOrderValue,
    STDDEV(CustomerTotalOrderValue) AS StdDevOrderValue
FROM (
    SELECT CustomerID, SUM(TotalOrderValue) AS CustomerTotalOrderValue
    FROM (
        SELECT CustomerID, InvoiceNo, SUM(Quantity) AS TotalOrderValue
        FROM OnlineRetail
        GROUP BY CustomerID, InvoiceNo
    ) AS InvoiceTotals
    GROUP BY CustomerID
) AS CustomerTotals;

##Q2How many unique products has each customer purchased?

SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY UniqueProductsPurchased DESC; 

##Q3 Which customers have only made a single purchase from the company?
SELECT CustomerID
FROM OnlineRetail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

##Q4 Which products are most commonly purchased together by customers in the dataset?

SELECT 
    a.StockCode AS ProductA, 
    a.Description AS DescriptionA, 
    b.StockCode AS ProductB, 
    b.Description AS DescriptionB, 
    COUNT(*) AS Frequency
FROM 
    OnlineRetail a
JOIN 
    OnlineRetail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
GROUP BY 
    a.StockCode, a.Description, b.StockCode, b.Description
ORDER BY 
    Frequency DESC;


