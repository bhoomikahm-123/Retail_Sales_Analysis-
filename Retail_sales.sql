-- Displaying the retail_sales table
SELECT * FROM retail_sales;

-- Data Exploration and Cleaning
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
SET SQL_SAFE_UPDATES = 0;

-- Data Analysis and Findings

-- 1. retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date= '2022-11-05';

-- 2. retrieve all transactions where the category is 'Clothing' and
-- the quantity sold is more than 3 in the month of Nov-2022:
SELECT * 
FROM retail_sales
WHERE category= 'Clothing'  and
quantity > 3 and date_format(sale_date, '%Y-%m')='2022-11';
 
-- 3. calculate the total sales (total_sale) for each category.
SELECT category , SUM(total_sale) AS Total_sales
FROM retail_sales
GROUP BY category;

-- 4. he average age of customers who purchased items from the 'Beauty' category.
SELECT category, AVG(age) AS Average_age
FROM retail_sales
WHERE category='Beauty';

-- 5. all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sale>1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) 
-- made by each gender in each category.:
SELECT category, gender, COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- 7. calculate the average sale for each month. Find out best selling month in each year
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rn
    FROM retail_sales
    GROUP BY year, month
) AS ranked
WHERE rn = 1;

-- 8.  find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- 9. find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT customer_id) as Customers
FROM retail_sales
GROUP BY category;

-- 10. create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS no_of_orders
FROM retail_sales
GROUP BY shift;

-- END --