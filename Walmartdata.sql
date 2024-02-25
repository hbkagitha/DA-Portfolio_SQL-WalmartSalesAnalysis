create database if not exists walmartsales;
create table if not exists sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city  VARCHAR(30) NOT NULL,
customer_type  VARCHAR(30) NOT NULL,
gender  VARCHAR(10) NOT NULL,
product_line  VARCHAR(100) NOT NULL, 
unit_price Decimal(10,2) not null,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL, 
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9) NOT NULL,
gross_income DECIMAl(12,4) NOT NULL,
rating FLOAT(2,1)
);


-- ----------------------------------------------------------------------------------------------
-- ---------------------------------Feature Engineering------------------------------------------

-- ------Time_of_Day-----------------------------------------------------------------------------

select 
      time,
      (case when time between "00:00:00" and "12:00:00" then "Morning"
			when time between "12:01:00" and "16:00:00" then "Afternoon"
			else "Evening"
       end     
      ) as time_of_day
from sales;      
AlTER TABLE sales add column time_of_day VARCHAR(20);
UPDATE  sales
SET time_of_day =   (case when time between "00:00:00" and "12:00:00" then "Morning"
			when time between "12:01:00" and "16:00:00" then "Afternoon"
			else "Evening"
       end     
      );
      
-- day_name--------------------------------------------------------------------------------------
select date,dayname(date) from sales;
AlTER TABLE sales add column day_name VARCHAR(10);
UPDATE sales
set day_name = dayname(date);

-- month_name-------------------------------------------------------------------------------------
select date,monthname(date) from sales;
AlTER TABLE sales add column month_name VARCHAR(10);
UPDATE sales
set month_name = monthname(date);


-- --------------------------------------------------------------------------------------------------
-- -------------------------------------Generic Analysis---------------------------------------------

-- What are the unique cities? 
select distinct city from sales;
select distinct branch from sales;
-- In which city is each branch located?
select distinct city, branch from sales;

-- ----------------------------------------------------------------------------------------------------
-- -------------------------------------Product Analysis-----------------------------------------------

-- How many unique product lines?
select count(distinct product_line) from sales;

-- Most common payment method?
select  payment_method,count(payment_method) as cnt from sales
group by payment_method
order by cnt desc;

-- What is the most selling product_line used?
select product_line ,count(product_line) as cnt from sales
group by product_line
order by cnt desc;

-- Total revenue by month?
select month_name,sum(total) as revenue from sales
group by month_name
order by revenue desc;

-- Month with greatest Cost of goods sold(Cogs)?
select month_name,sum(cogs) as total_cogs from sales
group by month_name
order by total_cogs desc;

-- Product_line with Largest Revenue?
select product_line ,sum(total) as revenue from sales
group by product_line
order by revenue desc;

-- City with Largest Revenue?
select branch,city ,sum(total) as revenue from sales
group by city,branch
order by revenue desc;

-- Product line with largest VAT?
select product_line,avg(VAT) as avg_tax from sales
group by product_line
order by avg_tax desc;

-- Which branch solds more products than avg product sold?
select branch,sum(quantity) as qty from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select gender,product_line,count(gender) as total_cnt from sales
group by gender,product_line
order by total_cnt desc;

-- What is the avg rating of each product line?
select product_line,round(avg(rating),2) as avg_rating from sales
group by product_line
order by avg_rating desc;

-- Add a new column to show Good or Bad product line depending on avg sales?
 -- select product_line,,
        -- (case when avg_tax 
        
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------Sales Analysis----------------------------------------------  
     
-- Number of sales made in each time of the day per weekday?
select time_of_day,count(quantity) as total from sales
where day_name = "Monday"
group by time_of_day
order by total desc;

-- What customer type brings more revenue?
select customer_type,round(sum(total),2) as revenue from sales
group by customer_type
order by revenue desc;

-- Which city has largest tax percentage/VAT?
select city,ceil(avg(VAT)) as tax_pct from sales
group by city 
order by tax_pct desc;

-- Which customer_type pays most VAT?
select customer_type,round(avg(VAT),2) as TAX from sales
group by customer_type
order by TAX desc;

-- -----------------------------------------------------------------------------------------------
-- --------------------------------------Customer Analysis----------------------------------------

-- Unique type of customers?
select distinct customer_type from sales;

-- Unique payment methods?
select distinct payment_method from sales;

-- Most common customer type?
select customer_type,count(invoice_id) as id from sales
group by customer_type
order by id desc;

-- Gender of most of the customers?
select gender,count(*) as cnt from sales
group by gender 
order by cnt desc;

-- Gender distribution per branch?
select gender,count(*) as gender_cnt from sales
where branch = "A"
group by gender
order by gender_cnt desc;

-- Which customer type buys the most?
select customer_type, count(*) as cnt from sales 
group by customer_type
order by cnt desc;

-- What time of the day customers give most ratings?
select time_of_day,count(rating) as rat_cnt from sales
group by time_of_day
order by rat_cnt desc;

-- What time of the day customers give most ratings per branch?
select time_of_day,count(rating) as rat_cnt from sales
where branch = "A"
group by time_of_day
order by rat_cnt desc;

-- Which day of the week has best average ratings?
select day_name,avg(rating) as avg_rat from sales
group by day_name
order by avg_rat desc;

 -- Which day of the week has best average ratings per branch?
select day_name,avg(rating) as avg_rat from sales
where branch = "A"
group by day_name
order by avg_rat desc;




      

        