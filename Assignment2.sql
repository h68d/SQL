-- ASSIGNMENT2
-- 1. Product Sales
-- You need to create a report on whether customers who purchased the product named
-- '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.
-- 'Polk Audio - 50 W Woofer - Black' 

SELECT DISTINCT c.customer_id, c.first_name, c.last_name,
CASE
    WHEN EXISTS (
        SELECT 1
        FROM [sale].[orders] o
        JOIN [sale].[order_item] oi ON o.order_id = oi.order_id
        JOIN [product].[product] p ON oi.product_id = p.product_id
        WHERE o.customer_id = c.customer_id
        AND p.product_name = 'Polk Audio - 50 W Woofer - Black'
    ) THEN 'Yes'
    ELSE 'No'
END AS Other_Product
FROM [sale].[customer] c
JOIN [sale].[orders] o ON c.customer_id = o.customer_id
JOIN [sale].[order_item] oi ON o.order_id = oi.order_id
JOIN [product].[product] p ON oi.product_id = p.product_id
WHERE p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'



-- 2. Convertion Rate
-- Below you see a table of the actions of customers visiting the website by clicking on two different 
-- types of advertisements given by an E-Commerce company. 
-- Write a query to return the conversion rate for each Advertisement type.


-- a.    Create above table (Actions) and insert values,
CREATE TABLE Actions (
    Visitor_ID INT,
    Adv_Type CHAR(1),
    Action VARCHAR(10)
);

INSERT INTO Actions (Visitor_ID, Adv_Type, Action) VALUES
(1, 'A', 'Left'),
(2, 'A', 'Order'),
(3, 'B', 'Left'),
(4, 'A', 'Order'),
(5, 'A', 'Review'),
(6, 'A', 'Left'),
(7, 'B', 'Left'),
(8, 'B', 'Order'),
(9, 'B', 'Review'),
(10, 'A', 'Review');

--b.    Retrieve count of total Actions and Orders for each Advertisement Type,
SELECT Adv_Type, 
COUNT(*) AS Total_Actions, 
SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Total_Orders
FROM Actions
GROUP BY Adv_Type;

--c.Calculate Orders (Conversion) rates for each Advertisement Type by dividing 
--by total count of actions casting as float by multiplying by 1.0.

SELECT 
	Adv_Type, 
	CAST(SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) * 1.00 / COUNT(*) AS DECIMAL(3,2)) AS Conversion_Rate
	--cast(1.0*2.0/1.5 as decimal(3,2)) AS something
FROM 
	Actions
GROUP BY 
	Adv_Type;
	
