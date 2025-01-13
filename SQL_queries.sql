--- Create Database ---
create database if not exists walmartsales

--- create Table ---

create table if not exists sales(
       invoice_id varchar(30) not null primary key,
       branch varchar(100) not null,
       city  varchar(30) not null,
       customer_type varchar(30) not null,
       gender varchar(10) not null,
       product_line varchar(100) not null,
       unit_price decimal(10,2) not null,
       quantity int not null,
       vat float(6,4) not null,
       total decimal(12,4) not null,
       date datetime not null,
       time time not null,
       payment_method varchar(15) not null,
       cogs decimal (10,2) not null,
       gross_margin_pct  float(11,9),
       gross_income decimal (12,4) not null,
       rating float(2,1)
);
select * from walmartsales.sales;

-- Feature Engineering --

-- time of Day --

select
   time,
   (case
       when time between '00:00:00' and '12:00:00' then 'Morning'
       when time between '12:01:00' and '16:00:00' then 'Afternoon'
       else 'Evening'
	end) as time_of_day
from sales;
select * from walmartsales.sales;
alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
    case
       when time between '00:00:00' and '12:00:00' then 'Morning'
       when time between '12:01:00' and '16:00:00' then 'Afternoon'
       else 'Evening'
	end
);
DESCRIBE sales; #To check whether time_of_day column are available or not in the sales Table which I have created 
SET SQL_SAFE_UPDATES = 0; # To Disable the Safe update Mode
SET SQL_SAFE_UPDATES = 1; #  To Re-Enable the safe update mode

-- Add a New Column called Day_name--

select
    date, dayname(date)
    from sales;

alter table sales add column day_name varchar(20);

update sales
set day_name= dayname(date);

SET SQL_SAFE_UPDATES = 0; # To Disable the Safe update Mode
select * from walmartsales.sales;
-- Month Name --
select date,monthname(date) from sales;

alter table sales add column month_name varchar(30);

update sales
set month_name = monthname(date);
------------------------------------------------------------------------------------------------
-- Generic Questions --
-- How many Unique cities does the data have ?--

select Distinct(city) from sales;

-- In which city is each branch?--

select distinct city,branch from sales;
-- How many unique product lines does the data have?--
select count(distinct(product_line)) from sales;

-- What is the most common payment method?--

select payment_method,count(payment_method) as sd from sales group by payment_method order by sd desc;

-- What is the total revenue by month?--

select * from sales;

SELECT
   MONTH_NAME AS MONTH,
   SUM(TOTAL) AS TOTAL
   FROM SALES
GROUP BY MONTH_NAME
ORDER BY TOTAL DESC;

-- What month had the largest COGS?--

SELECT MONTH_NAME AS MONTH, SUM(COGS) AS COGS FROM SALES GROUP BY MONTH_NAME ORDER BY COGS DESC;

select * from sales;
-- What product line had the largest revenue?--

SELECT PRODUCT_LINE, SUM(TOTAL) AS TOTAL FROM SALES GROUP BY PRODUCT_LINE ORDER BY TOTAL DESC;

-- What is the city with the largest revenue?--
SELECT CITY, SUM(TOTAL) AS LARGEST_REVENUE FROM SALES GROUP BY CITY ORDER BY LARGEST_REVENUE DESC;

-- What product line had the largest VAT?--

SELECT PRODUCT_LINE, AVG(VAT) AS AVG_TAX FROM SALES GROUP BY PRODUCT_LINE ORDER BY AVG_TAX DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales--

-- Which branch sold more products than average product sold? --

SELECT BRANCH, SUM(QUANTITY) AS QTY FROM SALES GROUP BY BRANCH HAVING SUM(QUANTITY)> (SELECT AVG(QUANTITY) FROM SALES);

-- What is the most common product line by gender? -- 

SELECT GENDER,PRODUCT_LINE,COUNT(GENDER) AS TOTAL_CNT FROM SALES GROUP BY GENDER,PRODUCT_LINE
ORDER BY TOTAL_CNT DESC;



-- What is the average rating of each product line? --

SELECT AVG(RATING) AS AVG_RATING,PRODUCT_LINE FROM SALES GROUP BY PRODUCT_LINE ORDER BY AVG_RATING DESC;

-- Number of sales made in each time of the day per weekday--
select time_of_day, count(*) as total_sales from sales group by time_of_day;

-- Which of the customer types brings the most revenue? --
select* from sales;

select customer_type,  sum(total) as most_revenue from sales group by customer_type order by most_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)? --

select city, avg(vat) as avg_vat from sales group by city order by avg_vat desc;

-- Which customer type pays the most in VAT? --

select customer_type,avg(vat) as Most_payee from sales group by customer_type order by Most_payee desc;

-- How many unique customer types does the data have? --
select * from sales;

select count(distinct customer_type) from sales;

-- How many unique payment methods does the data have? --

select distinct  payment_method from sales;

-- What is the most common customer type?--
select customer_type, sum(total) from sales group by customer_type;

-- What is the gender of most of the customers?
select gender,count(*) as gender_cnt from sales group by gender order by gender_cnt desc; 

-- What is the gender distribution per branch? --
select branch, count(gender) as gender_count from sales group by branch order by gender_count desc;

-- Which time of the day do customers give most ratings?

select time_of_day,avg(rating) as rat from sales where branch ='b' group by time_of_day order by rat desc;

-- Which day fo the week has the best avg ratings? --

select day_name, avg(rating) as avg_rating from sales group by day_name order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?
select branch,day_name, avg(rating) as avg_rating from sales group by day_name,branch order by avg_rating desc;






















       