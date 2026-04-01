-- MySQL Workbench Query

-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

SELECT 
	city_name,
	ROUND(
	(population * 0.25)/1000000, 
	2) as `customers(Millions)`,
	city_rank
FROM city
ORDER BY 2 DESC;

-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
with cte as (select
	c.city_name,
    sum(s.total) as revenue,
    year(s.sale_date) as `year`,
    quarter(s.sale_date) `quarter`
from sales s 
join customers cs on cs.customer_id = s.customer_id
join city c on c.city_id = cs.city_id
group by 
	c.city_id,
    c.city_name,
    year(s.sale_date),
    quarter(s.sale_date) 
order by revenue desc
)
select 	
	city_name,
    revenue
from cte 
where `quarter` = 4 and `year` = 2023;

-- Sales Count for Each Product
-- How many units of each coffee product have been sold?
select 
	p.product_name,
    count(*) as count
from sales s 
join products p using(product_id)
group by 
	p.product_name
having product_name like '%coffee%'
order by count desc;

-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?
select
		c.city_name,
        count(distinct cs.customer_id) as num_customers,
        round(sum(s.total) / count(distinct cs.customer_id),2) as avg_sales
from sales s
join customers cs on cs.customer_id = s.customer_id
join city c on c.city_id = cs.city_id 
group by 
	c.city_id,
    c.population,
    c.city_name
order by avg_sales desc;

-- City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.

select
	c.city_name,
    round(c.population/1000000 ,2) as `customers(Millions)`,
    count(distinct s.customer_id) as consumers
from sales s
join customers cs on cs.customer_id = s.customer_id
join city c on c.city_id = cs.city_id
group by 
	c.city_id,
	c.city_name,
    c.population;


-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?


WITH ranked AS (
    SELECT
        c.city_name,
        s.product_id,
        p.product_name,
        COUNT(*)                              AS sales_volume,
        SUM(s.total)                          AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY c.city_id
            ORDER BY COUNT(*) DESC
        )                                     AS rn
    FROM sales s
    JOIN customers cs ON cs.customer_id = s.customer_id
    JOIN city c       ON c.city_id      = cs.city_id
    JOIN products p   ON p.product_id   = s.product_id
    GROUP BY
        c.city_id,
        c.city_name,
        s.product_id,
        p.product_name
)
SELECT
    city_name,
    product_id,
    product_name,
    sales_volume,
    total_sales,
    rn AS `rank`
FROM ranked
WHERE rn <= 3
ORDER BY
    city_name,
    rn;

-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

select 	
	c.city_name,
	count(distinct cs.customer_id) as unique_customer
from sales s 
join customers cs on cs.customer_id = s.customer_id
join city c on c.city_id = cs.city_id
join products p on p.product_id = s.product_id
where 	
	p.product_name like '%coffee%'
group by	
	c.city_name;
	
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

select
	c.city_name,
    round(sum(s.total) / count(distinct cs.customer_id),2) as avg_sales,
    round(c.estimated_rent / count(distinct cs.customer_id),2) as avg_rent
from sales s 
join customers cs on cs.customer_id = s.customer_id
join city c on c.city_id = cs.city_id
group by 	
	c.city_name,
    c.estimated_rent;

-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

WITH monthly_sales AS (
    SELECT
        YEAR(s.sale_date)                    AS sale_year,
        MONTH(s.sale_date)                   AS sale_month,
        ROUND(SUM(s.total), 2)               AS total_sales
    FROM sales s
    GROUP BY
        YEAR(s.sale_date),
        MONTH(s.sale_date)
),
growth AS (
    SELECT
        sale_year,
        sale_month,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY sale_year, sale_month
        )                                    AS prev_month_sales,
        ROUND(
            (total_sales - LAG(total_sales) OVER (
                ORDER BY sale_year, sale_month
            )) / LAG(total_sales) OVER (
                ORDER BY sale_year, sale_month
            ) * 100
        , 2)                                 AS growth_rate
    FROM monthly_sales
)
SELECT
    sale_year,
    sale_month,
    total_sales,
    prev_month_sales,
    CONCAT(growth_rate, '%')                 AS growth_rate
FROM growth
ORDER BY
    sale_year,
    sale_month;

-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
with cte as (
select
	c.city_name,
    sum(s.total) as total_sales,
    c.estimated_rent as total_rent,
    count(distinct cs.customer_id) as customers,
    ROUND(c.population * 0.25 / 1000000, 2) AS `est_coffee_consumers(Million)`,
    row_number() over (order by sum(s.total) desc) as rn 

from sales s 
join customers cs on cs.customer_id = s.customer_id
join city c on c.city_id = cs.city_id

group by 
	c.city_name,
    c.estimated_rent,
    c.population
)
select 
	city_name,
    total_sales,
	total_rent,
    `est_coffee_consumers(Million)`,
    customers
from cte
where 
rn <= 3;
    

