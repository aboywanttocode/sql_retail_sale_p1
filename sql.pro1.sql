-- sql retail sales analysis -p1
create database sql_project_p2;

--create table
drop table if exists retail_sales;
create table retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,	
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantity	INT,
				price_per_unit FLOAT,	
				cogs	FLOAT,
				total_sale	FLOAT
			);
--data cleaning
select * from retail_sales
limit 10;

select
	count(*) 
	from retail_sales

select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

select * from retail_sales
where customer_id is null

select * from retail_sales
where gender is null

 

select * from retail_sales
where 
	category is null
	or
	age is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

delete from retail_sales
	where 
	category is null
	or
	age is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null
-- data exploration

--how many sales we have
select count(*) as total_sale from retail_sales

--how many unique customer we have
select count(distinct customer_id) as total_sale from retail_sales

select count(distinct category) as total_sale from retail_sales

select distinct category from retail_sales

--My analysis & findings
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
	where sale_date='2022-11-05';
		
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select * from retail_sales
	where 
	category='Clothing' 
	AND 
	quantity >= 4 
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1
select * from retail_sales
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	round(avg(age)) as avg_age
from retail_sales
where category ='Beauty'
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale >1000
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
	select
		gender,
		category,
		count(*) as total_trans
		from retail_sales
	group by
		category,gender
	order by "total_trans"
	select * from retail_sales
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
	select 
	year,
	month,
	avg_sale
	from
	(
	select 
		extract(year from sale_date ) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract (year from sale_date) order by AVG(total_sale) DESC) as rank
	from retail_sales
	group by 1,2
	) as t1
where rank = 1
select * from retail_sales
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
	select 
		customer_id, 
		sum(total_sale) as total_sale	
	from retail_sales
	group by 1
	order by 2 DESC
	limit 5
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
	select 
		category,
		count(distinct customer_id) as unique_customer_id
	from retail_sales
	group by category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
	with hourly_sale
	as
	(
	select *, 
		Case
			when extract (hour from sale_time) <=12 then 'Morning'
			when extract (hour from sale_time) between 12 and 17 then 'afternoon'
			else 'evening'
		End as shift
	from retail_sales
	)
	select 
	shift,
	count(*) as total_orders
	from
	hourly_sale
	group by shift