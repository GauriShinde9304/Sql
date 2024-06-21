CREATE DATABASE IF NOT EXISTS Walmart;

USE Walmart;

CREATE TABLE IF NOT EXISTS SALES (
  Date DATE NOT NULL,
  Store INTEGER NOT NULL,
  Weekly_Sales DECIMAL(10, 2) NOT NULL,  
  Holiday_Flag TINYINT NOT NULL,
  Temperature DECIMAL(5, 2) NOT NULL,    
  Fuel_Price DECIMAL(5, 4) NOT NULL,      
  CPI FLOAT NOT NULL,                       
  Unemployment DECIMAL(5, 3) NOT NULL    
);

SELECT COUNT(*)FROM SALES;
SELECT * FROM SALES;

#Q1 Which year had the highest sales?

SELECT YEAR(date) AS Year,
       SUM(weekly_sales) AS TotalSales
GROUP BY YEAR(date)
ORDER BY TotalSales DESC
LIMIT 1;

##Q2How was the weather during the year of highest sales?

SELECT EXTRACT(YEAR FROM Date) AS Year,
       AVG(Temperature) AS WEATHER
FROM SALES
WHERE EXTRACT(YEAR FROM Date) IN (2010, 2011, 2012)
GROUP BY EXTRACT(YEAR FROM date);

###Q3 Conclude whether the weather has an essential impact on sales.

####Q4

SELECT
    EXTRACT(YEAR FROM date) AS Year,
    CASE
        WHEN holiday_flag = 1 THEN 'Holiday Season'
        ELSE 'Non-Holiday Season'
    END AS Season,
    AVG(Weekly_Sales) AS Average_Weekly_Sales
FROM SALES
GROUP BY
    Year, Season
ORDER BY
    Year, Season;
    
#####Q5      
SELECT
    (SELECT
        SUM((s.Weekly_Sales - s1.avg_sales) * (s.fuel_price - s2.avg_fuel_price)) / 
        (SQRT(SUM(POWER(s.Weekly_Sales - s1.avg_sales, 2))) * SQRT(SUM(POWER(s.fuel_price - s2.avg_fuel_price, 2))))
    FROM SALES S
    CROSS JOIN
        (SELECT AVG(Weekly_Sales) AS avg_sales FROM SALES) AS s1
    CROSS JOIN
        (SELECT AVG(fuel_price) AS avg_fuel_price FROM SALES) AS s2
    ) AS Fuel_Price_Correlation,
    
    (SELECT
        SUM((s.Weekly_Sales - s1.avg_sales) * (s.CPI - s2.avg_CPI)) / 
        (SQRT(SUM(POWER(s.Weekly_Sales - s1.avg_sales, 2))) * SQRT(SUM(POWER(s.CPI - s2.avg_CPI, 2))))
    FROM SALES s
    CROSS JOIN
        (SELECT AVG(Weekly_Sales) AS avg_sales FROM SALES) AS s1
    CROSS JOIN
        (SELECT AVG(CPI) AS avg_CPI FROM SALES) AS s2
    ) AS CPI_Correlation,
    
    (SELECT
        SUM((s.Weekly_Sales - s1.avg_sales) * (s.Unemployment - s2.avg_Unemployment)) / 
        (SQRT(SUM(POWER(s.Weekly_Sales - s1.avg_sales, 2))) * SQRT(SUM(POWER(s.Unemployment - s2.avg_Unemployment, 2))))
    FROM SALES s
    CROSS JOIN
        (SELECT AVG(Weekly_Sales) AS avg_sales FROM SALES) AS s1
    CROSS JOIN
        (SELECT AVG(Unemployment) AS avg_Unemployment FROM SALES) AS s2
    ) AS Unemployment_Correlation;


SELECT
    AVG(Weekly_Sales) AS Average_Weekly_Sales,
    fuel_price,
    CPI,
    Unemployment
FROM SALES
GROUP BY
    fuel_price, CPI, Unemployment;