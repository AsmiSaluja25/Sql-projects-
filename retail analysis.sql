SELECT * FROM retail_sales
LIMIT 10
								----- DATA CLEANING-----
-- Checking for null values --
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
-- no null values in transactions_id

-- checks for null values--
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
 -- Delete the null values--

 DELETE FROM retail_sales
 WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
							-- Data Exploration --

-- How many sales we have?--
SELECT COUNT(*)as total_sale FROM retail_sales
-- shows there have been 1997 sales 

-- check how many customers we have --
SELECT COUNT(*)as customer_id FROM retail_sales
-- shows 1997 ie includes duplicates 

--- remove duplicates --
SELECT COUNT(DISTINCT customer_id )as total_sale FROM retail_sales
-- shows the total sale by showing no of customers 

--check the different types of category --
SELECT DISTINCT category FROM retail_sales
-- tells us there are 3 categories in our data ie - electronics, clothing and beauty 

-- to get just the no of categories  --
SELECT COUNT(DISTINCT category ) FROM retail_sales
-- gives 3 (no)

			--- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS--

-- Retrieve all columns for sales made on 2022-11-05 --
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
-- shows about 11 sales on that date --

-- Retrieve all transactions where the category is clothing and the quantity sold 
-- ** is more than 4 in the month of nov 2022 **
SELECT * FROM retail_sales WHERE 
category = 'Clothing'
AND quantiy >= 4 
AND TO_CHAR (sale_date,'YYYY-MM') = '2022-11'

--**calculate the total sales for each category **
SELECT category,
SUM(total_sale) 
FROM retail_sales
GROUP BY category

-- find the average age of customers who purchased items from the beauty categoty 
SELECT ROUND(AVG(age),2)
FROM retail_sales 
WHERE category = 'Beauty'
-- the avg age is 40.4157....
-- round is used to round up the result to upto 2 places 

-- find all transactions where the total_sales is greater than 1000
SELECT * 
FROM retail_sales 
WHERE total_sale> 1000 

-- find the total number of transactions(transaction_id)made by each gender in each category 
SELECT category, gender,
COUNT(*) 
FROM retail_sales 
GROUP BY category, gender 
ORDER BY 1 -- puts similar things together 

--** cal the aveage sale for each month, find out best selling month in each year ** 
SELECT
	year, month, avg_sale
	FROM(

		SELECT
		EXTRACT (YEAR FROM sale_date) as year,
		EXTRACT (MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK()OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC)as rank
		FROM retail_sales
		GROUP BY 1,2 
		ORDER BY 1,3 DESC
	)as t1
	WHERE rank = 1
	
-- **find  top 5 customers based on the highest total sales 
-- many customers have shopped repeatedly soo we group by customers and sum the sales for each 
SELECT  customer_id, 
SUM(total_sale)
FROM retail_sales 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- find the no  of unique customers who purchased items from each category 
SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category 

-- **create each shift and no of orders (eg - morning < 12)
WITH hourly_sale -- creates a table with shift column 
AS
(
SELECT *, 
CASE 
	WHEN EXTRACT (HOUR FROM sale_time)< 12 THEN 'Morning'
	WHEN EXTRACT (HOUR FROM sale_time)BETWEEN 12 AND 17  THEN 'Afternoon'
	ELSE 'Evening'
	END as shift 

FROM retail_sales)

SELECT shift, 
COUNT(*) as total_orders
FROM hourly_sale 
GROUP BY shift 


---- End of project ----	

