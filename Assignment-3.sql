--Discount Effects
--Using SampleRetail database generate a report including product IDs and discount effects 
--on whether the increase in the discount rate positively impacts the number of orders for the products.

--For this, statistical analysis methods can be used. However, this is not expected.
--In this assignment, you are expected to generate a solution using SQL with a logical approach. 
--Sample Result: 
--Product_id 	Discount Effect
--1 			Positive
--2 			Negative
--3 			Negative
--4 			Neutral


With dt AS
	(SELECT DISTINCT product_id, discount,SUM(quantity) as sum_quantity,
	 LAG(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY product_id) as previous_quantity,
	 SUM(quantity)-LAG(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY product_id) as difference_quantity
	FROM sale.order_item 
GROUP BY discount, product_id
)
(
	SELECT dt.product_id, 
	CASE 
		WHEN SUM(dt.difference_quantity) > 0 THEN 'Positive'
		WHEN SUM(dt.difference_quantity) < 0 THEN 'Negative'
		ELSE 'Neutral'
	END AS Discount_Effect
	FROM dt
GROUP BY product_id
)


--ALTERNATIVE WITH Difference_quantity COLUMN
With dt AS
	(SELECT DISTINCT product_id, discount,SUM(quantity) as sum_quantity,
	 LAG(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY product_id) as previous_quantity,
	 SUM(quantity)-LAG(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY product_id) as difference_quantity
	FROM sale.order_item 
GROUP BY discount, product_id
)
(
	SELECT dt.product_id, SUM(dt.difference_quantity) as Difference_quantity,
	CASE 
		WHEN SUM(dt.difference_quantity) > 0 THEN 'Positive'
		WHEN SUM(dt.difference_quantity) < 0 THEN 'Negative'
		ELSE 'Neutral'
	END AS Discount_Effect
	FROM dt
GROUP BY product_id
)


