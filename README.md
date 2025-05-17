# 🛒 Retail Sales Data Analysis using SQL

## 📌 Description
This project involves exploring, cleaning, and analyzing a retail sales dataset using SQL. The objective is to uncover patterns in customer behavior, product category performance, time-based trends, and more using structured queries. The project includes insights like best-selling categories, top customers, and peak shopping hours.

---
## 🧰 Tools & Technologies
- **SQL**: MySQL
- **Environment**: MySQL Workbench / DB Browser
- **Optional**: Excel (for preloading data)

---

## 🗂️ Database Schema
The project uses a single table: `retail_sales`.
```sql
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```
## 🧹 Data Cleaning
To ensure quality analysis:
- Removed rows with `NULL` values in critical fields like `sale_date`, `customer_id`, `price_per_unit`, etc.
- Ensured `SQL_SAFE_UPDATES` was turned off to allow deletions.

```sql
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```
## 3. Data Analysis & Findings

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```
2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * 
FROM retail_sales
WHERE category= 'Clothing'  and
quantity > 3 and date_format(sale_date, '%Y-%m')='2022-11'; 
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category , SUM(total_sale) AS Total_sales
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category, AVG(age) AS Average_age
FROM retail_sales
WHERE category='Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
FROM retail_sales
WHERE total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category, gender, COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT customer_id) as Customers
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS no_of_orders
FROM retail_sales
GROUP BY shift;
```
🔗 Project File

- [Download SQL file here](Retai_sales.sql)
