-- ---------------------------------------------------------------------------------------
-- -----------------Feature Engineering----------------------

-- time_of_day

SELECT 
	time,
	(CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
	) AS time_of_day
 FROM sales;
 
 ALTER TABLE sales ADD COLUMN time_of_day1    VARCHAR(20)     NOT NULL;
 
 UPDATE sales 
 SET time_of_day1 = (
	 CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END 
);

ALTER TABLE sales
RENAME COLUMN time_of_day1 TO time_of_day;

------- day_name---------------
ALTER TABLE sales
ADD COLUMN day_name     VARCHAR(10);

SELECT date, DAYNAME(date) as day_name
FROM sales;

UPDATE sales
SET day_name = DAYNAME(date);

------- month_name-----------------

ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
set month_name = MONTHNAME(date);

-- --------------------- Generic-----------

-- How many unique cities are in the data?

SELECT DISTINCT(city) from sales;

-- Which city is in each branch?

------------------------- Product ------------------------
SELECT DISTINCT(city), branch FROM sales;

-- How many unique product lines are there?

SELECT COUNT(DISTINCT(product_line)) FROM sales;

-- What is the most common payment method?
SELECT payment_method, COUNT(payment_method) as cnt FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT product_line, COUNT(product_line) as cnt from sales
GROUP BY product_line
ORDER BY cnt desc;

-- What is the total revenue by month?
SELECT SUM(total) AS total_revenue, month_name
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest cogs?
SELECT SUM(cogs), month_name
FROM sales
GROUP BY month_name
ORDER BY SUM(cogs) DESC;

-- What product line had the largest revenue?
SELECT product_line,SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT city, SUM(total) as total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT SUM(VAT), product_line
FROM sales
GROUP BY product_line
ORDER BY SUM(VAT) DESC;

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT ROUND(AVG(rating), 2) AS avg_rate, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rate DESC;

--------------- Sales ------------------------------------
-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest tax percent?
SELECT AVG(VAT) AS avg_tax, city
FROM sales
GROUP BY city
ORDER BY avg_tax DESC;

-- Which customer pays the most in VAT?
SELECT AVG(VAT) AS avg_tax, customer_type
FROM sales
GROUP BY customer_type
ORDER BY avg_tax DESC;

---------- Customer-----------------------------------------------------------
-- How many unique customer types does the data have?
SELECT DISTINCT(customer_type)
FROM sales;

-- How many unique payment methods are there?
SELECT DISTINCT(payment_method)
FROM sales;

-- What is the most common customer type?
SELECT COUNT(customer_type), customer_type
FROM sales
GROUP BY customer_type;

-- Which customer type buys the most?
SELECT customer_type,
COUNT(*) AS cstm_cnt
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT COUNT(gender), gender
FROM sales
GROUP BY gender;

-- What is the gender distribution per branch?
SELECT branch, gender, count(gender)
FROM sales
WHERE branch = 'A'
GROUP BY gender;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, SUM(rating) AS most_rating
FROM sales
GROUP BY time_of_day
ORDER BY most_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, SUM(rating) AS most_rating
FROM sales
WHERE branch = 'B'
GROUP BY time_of_day
ORDER BY most_rating DESC;

-- Which day of the week has the best avg ratings?
SELECT AVG(rating) AS avg_rate, day_name
FROM sales
GROUP BY day_name
ORDER BY avg_rate DESC;