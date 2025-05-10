-----DATA CLEANING


SELECT *
FROM dbo.[retail_sales ]
WHERE transactions_id IS NULL;

SELECT *
FROM dbo.[retail_sales ]

ALTER TABLE retail_sales
ADD CONSTRAINT pk_transactions_id PRIMARY KEY (transactions_id);


SELECT *
FROM dbo.[retail_sales ]
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time is NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL 
	OR cogs IS NULL
	OR total_sale IS NULL;


DELETE FROM dbo.[retail_sales ]
WHERE quantiy IS NULL
   OR price_per_unit IS NULL 
   OR cogs IS NULL
   OR total_sale IS NULL;





SELECT *
FROM dbo.[retail_sales ]
--WHERE quantiy IS NULL
   --OR price_per_unit IS NULL 
   --OR cogs IS NULL
   --OR total_sale IS NULL;

-----DATA EXPLORATION

--Q1. How many sales we have?

SELECT COUNT(*) AS  total_sale
FROM dbo.[retail_sales ];

ANS : 1997

---Q2. how many unique customer we have?

SELECT COUNT (DISTINCT customer_id)
FROM dbo.[retail_sales ];

ANS: 155


--Q3. how many category we have ?

SELECT DISTINCT category
FROM dbo.[retail_sales ];

ANS: Beauty, Electronics, Clothing


----DATA ANALYSIS---
Q1: Write the SQL query to retreive all the column for sale made on '2022-11-05'?
Q2: Write the SQL query to retreive all the transactions where the category is Clothing the quantity sold is more than 
	10 in the month of November 2022?
Q3: Write the SQL query to calculate the total sales for each category?
Q4: Write the SQL query to find the average ages of customers who purchased item from Beauty category?
Q5: Write the SQL query to find all the transactions where the total sales is greater than 1000?
Q6: Write the SQL query to find total number of transactions made by each gender in each category?
Q7: Write the SQL query to calculate the average sales for each month and find out best selling month in each year?
Q8: Write the SQL query to find top 5 best customer based on the highest total sale?
Q9: Write the SQL query to find the number of unique who purhased item from each category?
Q10: Write the SQL query to create each shift and number of orders( Example Morning <=12 , afternoon between 12 nad 17 
		and Evening >17)


		----SOLUTIONS-----
1. 
SELECT *
FROM dbo.[retail_sales ]
WHERE sale_date = '2022-11-05';

2.
SELECT 
		category,	
		transactions_id, 
		quantiy, 
		sale_date
FROM dbo.[retail_sales ]
WHERE category = 'Clothing'
AND quantiy >= 4
AND FORMAT(sale_date,'yyyy-MM') ='2022-11';

SELECT 
		category,
		SUM(quantiy * price_per_unit) AS Total_sale
FROM dbo.[retail_sales ]
GROUP BY category;

--Q4: Write the SQL query to find the average ages of customers who purchased item from Beauty category?
SELECT category,
		AVG(AGE) AS avg_age
FROM dbo.[retail_sales ]
WHERE  category ='Beauty'
GROUP BY category;

--Q5: Write the SQL query to find all the transactions where the total sales is greater than 1000?

SELECT *
FROM dbo.[retail_sales ]
WHERE total_sale >1000;

--Q6: Write the SQL query to find total number of transactions made by each gender in each category?

SELECT category,
		gender,
		COUNT(*) AS total_transactions
FROM dbo.[retail_sales ]
GROUP BY gender, category
ORDER BY category;


--Q7: Write the SQL query to calculate the average sales for each month and find out best selling month in each year?
  
  SELECT
		Year,
		Month,
		Average_Sale
FROM
(  
  SELECT 
    YEAR(sale_date) AS Year,
    MONTH(sale_date) AS Month, 
    AVG(total_sale) AS Average_Sale,
    RANK() OVER (
        PARTITION BY YEAR(sale_date)
        ORDER BY AVG(total_sale) DESC
    ) AS Sales_Rank
FROM 
    dbo.[retail_sales ]
GROUP BY 
    YEAR(sale_date), MONTH(sale_date)
--ORDER BY 
   -- Year, Month
   ) AS T1
	WHERE Sales_Rank=1;


	--Q8: Write the SQL query to find top 5 best customer based on the highest total sale?
SELECT TOP(5) 
    customer_id,
    SUM(total_sale) AS t_sale
FROM 
    dbo.[retail_sales ]
GROUP BY 
    customer_id
ORDER BY 
    t_sale DESC;

--Q9: Write the SQL query to find the number of unique customers who purhased item from each category?

SELECT COUNT(DISTINCT(customer_id)),
		category
FROM dbo.[retail_sales ]
GROUP BY category;


--Q10: Write the SQL query to create each shift and number of orders( Example Morning <=12 , afternoon between 12 nad 17 
		and Evening >17)

SELECT 
    COUNT(transactions_id) AS orders_number,
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM 
    dbo.[retail_sales ]
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END;


	--End of the Project.
