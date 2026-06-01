SELECT * FROM decodelabs_sales_data.sales_data;

USE decodelabs_sales_data;

ALTER TABLE sales_data
CHANGE COLUMN `ï»¿OrderID` OrderID varchar(50);

ALTER TABLE sales_data ADD COLUMN New_Date DATE;
SET SQL_SAFE_UPDATES = 0;

UPDATE sales_data 
SET New_Date = STR_TO_DATE(TRIM(Date), '%d/%m/%Y');

SELECT Date, New_Date FROM sales_data LIMIT 10;

ALTER TABLE sales_data DROP COLUMN Date;

ALTER TABLE sales_data CHANGE COLUMN New_Date Date DATE;

ALTER TABLE sales_data 
MODIFY COLUMN ItemsInCart INT,
MODIFY COLUMN Quantity INT,
MODIFY COLUMN UnitPrice DOUBLE,
MODIFY COLUMN TotalPrice DOUBLE;

SET SQL_SAFE_UPDATES = 1;

SELECT 
    CouponCode,
    COUNT(OrderID) AS Total_Orders,
    ROUND(SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(OrderID) * 100, 2) AS Cancellation_Rate_Percent,
    ROUND(SUM(TotalPrice), 2) AS Gross_Revenue
FROM sales_data
GROUP BY CouponCode
ORDER BY Cancellation_Rate_Percent DESC;

SELECT 
    ReferralSource,
    COUNT(DISTINCT CustomerID) AS Unique_Buyers,
    ROUND(AVG(UnitPrice), 2) AS Avg_Item_Price_Bought,
    ROUND(SUM(TotalPrice), 2) AS Total_Revenue
FROM sales_data
GROUP BY ReferralSource
ORDER BY Total_Revenue DESC;

SELECT 
    SUBSTRING_INDEX(ShippingAddress, ' ', -2) AS Location_Region, s
    COUNT(OrderID) AS Order_Count,
    ROUND(AVG(TotalPrice), 2) AS Average_Spend
FROM sales_data
GROUP BY Location_Region
HAVING Order_Count > 5
ORDER BY Average_Spend DESC;

SELECT 
    DAYNAME(Date) AS Day_Of_Week,
    COUNT(OrderID) AS Total_Orders,
    ROUND(SUM(TotalPrice), 2) AS Gross_Revenue,
    ROUND(SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(OrderID) * 100, 2) AS Cancellation_Rate_Percent
FROM sales_data
GROUP BY DAYNAME(Date), DAYOFWEEK(Date)
ORDER BY DAYOFWEEK(Date);

SELECT 
    CASE 
        WHEN ItemsInCart BETWEEN 1 AND 3 THEN 'Small Cart (1-3)'
        WHEN ItemsInCart BETWEEN 4 AND 6 THEN 'Medium Cart (4-6)'
        ELSE 'Large Bulk Cart (7+)'
    END AS Cart_Grouping,
    COUNT(OrderID) AS Total_Orders,
    ROUND(AVG(UnitPrice), 2) AS Avg_Price_Per_Item,
    ROUND(AVG(TotalPrice), 2) AS Avg_Total_Order_Value
FROM sales_data
GROUP BY 
    CASE 
        WHEN ItemsInCart BETWEEN 1 AND 3 THEN 'Small Cart (1-3)'
        WHEN ItemsInCart BETWEEN 4 AND 6 THEN 'Medium Cart (4-6)'
        ELSE 'Large Bulk Cart (7+)'
    END
ORDER BY Avg_Total_Order_Value DESC;