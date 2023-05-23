-- 1. Find the top 3 customers who have the maximum count of orders.
SELECT TOP 3 Cust_ID, Customer_Name, COUNT(*) AS Order_Count
FROM dbo.e_commerce_data
GROUP BY Cust_ID, Customer_Name
ORDER BY Order_Count DESC

--2. Find the customer whose order took the maximum time to get shipping
SELECT TOP 1 Cust_ID, Customer_Name, DaysTakenForShipping
FROM dbo.e_commerce_data
ORDER BY DaysTakenForShipping DESC;

--3. Count the total number of unique customers in January and how many of them
--came back every month over the entire year in 2011

USE ecommercedata
SELECT COUNT (DISTINCT [Cust_ID]) unique_customers_january
FROM dbo.e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 1;

-- Count customers who came back every month over the entire year in 2011
SELECT COUNT(*) AS Customers_Came_Back_Every_Month
FROM (
    SELECT Cust_ID, COUNT(DISTINCT MONTH(Order_Date))
    FROM dbo.e_commerce_data
    WHERE YEAR(Order_Date) = 2011
    GROUP BY Cust_ID
    HAVING COUNT(DISTINCT MONTH(Order_Date)) = 12
) AS subquery;

--4. Write a query to return for each user the time elapsed between the first
--purchasing and the third purchasing, in ascending order by Customer ID.

USE ecommercedata
SELECT 
    Cust_ID,
    DATEDIFF(day, MIN(Order_Date), MAX(Order_Date)) AS elapsed_time
FROM 
    dbo.e_commerce_data
WHERE 
    Cust_ID IN (
        SELECT Cust_ID
        FROM (
            SELECT 
                Cust_ID,
                ROW_NUMBER() OVER (PARTITION BY Cust_ID ORDER BY Ord_ID) AS row_num
            FROM 
                dbo.e_commerce_data
        ) AS subquery
        WHERE row_num = 1 OR row_num = 3
    )
GROUP BY 
    Cust_ID
ORDER BY 
    Cust_ID, elapsed_time;

--5. Write a query that returns customers who purchased both product 11 and
--product 14, as well as the ratio of these products to the total number of
--products purchased by the customer

with t1 as (
	select distinct Cust_ID,
		SUM(case when Prod_ID = 'Prod_11' then Order_Quantity else 0 end) as Prod_11_Quantity_sum,
		SUM(case when Prod_ID = 'Prod_14' then Order_Quantity else 0 end) as Prod_14_Quantity_sum,
		SUM(Order_Quantity) as total_order_quantity
from dbo.e_commerce_data
group by Cust_ID
having SUM(case when prod_id = 'Prod_11' then Order_Quantity else 0 end) >= 1 and
       SUM(case when prod_id = 'Prod_14' then Order_Quantity else 0 end) >= 1
)
select Cust_ID,
    cast(1.0 * Prod_11_Quantity_sum / total_order_quantity as numeric (10,2)) as ratio_Prod_11,
    cast(1.0 * Prod_14_Quantity_sum / total_order_quantity as numeric (10,2)) as ratio_Prod_14
from t1
order by Cust_ID;



--Customer Segmentation
--Categorize customers based on their frequency of visits. The following steps will guide you. If you want, you can track your own way.
--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--2. Create a “view” that keeps the number of monthly visits by users.(Show separately all months from the beginning business)
--3. For each visit of customers, create the next month of the visit as a separate
--column.
--4. Calculate the monthly time gap between two consecutive visits by each
--customer.
--5. Categorise customers using average time gaps. Choose the most fitted
--labeling model for you.
--For example:
--o Labeled as churn if the customer hasn't made another purchase in the
--months since they made their first purchase.
--o Labeled as regular if the customer has made a purchase every month.
--Etc.

--Month-Wise Retention Rate
--Find month-by-month customer retention ratei since the start of the business.
--There are many different variations in the calculation of Retention Rate. But we will--try to calculate the month-wise retention rate in this project.
--So, we will be interested in how many of the customers in the previous month could--be retained in the next month.
--Proceed step by step by creating “views”. You can use the view you got at the end of--the Customer Segmentation section as a source.
--1. Find the number of customers retained month-wise. (You can use time gaps)
--2. Calculate the month-wise retention rate.
--Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total--Number of Customers in the Current Month