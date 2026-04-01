-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

select 
	city_name,
	round((population * 0.25)/1000000,2) as customers_millions,
	city_rank
from `coffee-492003.Coffee_sales.City`
order by 2 desc;

-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
with cte as (
  select
	  c.city_name,
    sum(s.total) as revenue,
    extract(year from s.sale_date) as `year`,
    extract(quarter from s.sale_date) `quarter`
from `coffee-492003.Coffee_sales.Sales` s 
join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id
group by 
	c.city_id,
    c.city_name,
    extract(year from s.sale_date),
    extract(quarter from s.sale_date) 
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
    count(*) as cnt
from `coffee-492003.Coffee_sales.Sales` s 
join `coffee-492003.Coffee_sales.Products` p using(product_id)
group by 
	p.product_name
having lower(product_name) like '%coffee%'
order by cnt desc;

-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?
select
		c.city_name,
        count(distinct cs.customer_id) as num_customers,
        round(sum(s.total) / count(distinct cs.customer_id),2) as avg_sales
from `coffee-492003.Coffee_sales.Sales` s
join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id 
group by 
	c.city_id,
    c.population,
    c.city_name
order by avg_sales desc;

-- City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.

select
	  c.city_name,
    round(c.population/1000000 ,2) as customers_millions,
    count(distinct s.customer_id) as consumers
from `coffee-492003.Coffee_sales.Sales` s
join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id 
group by 
	  c.city_id,
	  c.city_name,
    c.population;


-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?


with ranked as (
    select
        c.city_name,
        s.product_id,
        p.product_name,
        count(*) as sales_volume,
        sum(s.total) as total_sales,
        row_number() over (partition by c.city_id order by count(*) desc) as rn
    from `coffee-492003.Coffee_sales.Sales` s
      join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
      join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id 
      join `coffee-492003.Coffee_sales.Products` p on p.product_id   = s.product_id
    group by 
        c.city_id,
        c.city_name,
        s.product_id,
        p.product_name
)
select
    city_name,
    product_id,
    product_name,
    sales_volume,
    total_sales,
    rn as `rank`
from ranked
where rn <= 3
order by
    city_name,
    rn;

-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

select 	
	  c.city_name,
	  count(distinct cs.customer_id) as unique_customer
from `coffee-492003.Coffee_sales.Sales` s
    join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
    join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id 
    join `coffee-492003.Coffee_sales.Products` p on p.product_id   = s.product_id
where 	
	  lower(p.product_name) like '%coffee%'
group by	
	  c.city_name;
	
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

select
	c.city_name,
      round(sum(s.total) / count(distinct cs.customer_id),2) as avg_sales,
      round(c.estimated_rent / count(distinct cs.customer_id),2) as avg_rent
from `coffee-492003.Coffee_sales.Sales` s
    join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
    join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id 
group by 	
	  c.city_name,
    c.estimated_rent;

-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

with monthly_sales as (
    select
        extract(year from s.sale_date) as sale_year,
        extract(month from s.sale_date) as sale_month,
        round(sum(s.total), 2) as total_sales
    from `coffee-492003.Coffee_sales.Sales` as s
    group by
        extract(year from s.sale_date),
        extract(month from s.sale_date)
),
growth as (
    select
        sale_year,
        sale_month,
        total_sales,
        lag(total_sales) over (
            order by sale_year, sale_month
        ) as prev_month_sales,
        round(
            (total_sales - lag(total_sales) over (
                order by sale_year, sale_month
            )) / lag(total_sales) OVER (
                order by sale_year, sale_month
            ) * 100
        , 2) as growth_rate
    from monthly_sales
)
select
    sale_year,
    sale_month,
    total_sales,
    prev_month_sales,
    concat(growth_rate, '%') as  growth_rate
from growth
order by
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
        ROUND(c.population * 0.25 / 1000000, 2) AS est_coffee_consumers_in_million,
        row_number() over (order by sum(s.total) desc) as rn 
    from `coffee-492003.Coffee_sales.Sales` s
      join `coffee-492003.Coffee_sales.Customers` cs on cs.customer_id = s.customer_id
      join `coffee-492003.Coffee_sales.City` c on c.city_id = cs.city_id 
    group by 
        c.city_name,
        c.estimated_rent,
        c.population
)
select 
	  city_name,
    total_sales,
	  total_rent,
    est_coffee_consumers_in_million,
    customers
from cte
where 
    rn <= 3;
    

