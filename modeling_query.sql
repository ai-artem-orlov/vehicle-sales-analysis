
-- CREATING A RELATIONAL DATABASE ============================================================================================================================

USE vehicle_sales

-- Changing data types

ALTER TABLE portfolio.vehicle_sales_data
ALTER COLUMN year INTEGER;

ALTER TABLE portfolio.vehicle_sales_data
ALTER COLUMN state CHAR(2);

ALTER TABLE portfolio.vehicle_sales_data
ALTER COLUMN condition INTEGER;

ALTER TABLE portfolio.vehicle_sales_data
ALTER COLUMN odometer INTEGER;

ALTER TABLE portfolio.vehicle_sales_data
ALTER COLUMN mmr NUMERIC;

ALTER TABLE portfolio.vehicle_sales_data
ALTER COLUMN sellingprice NUMERIC;

-- Transforming saledate column

ALTER TABLE portfolio.vehicle_sales_data
ADD weekday_name CHAR(3);

ALTER TABLE portfolio.vehicle_sales_data
ADD month_name CHAR(3);

ALTER TABLE portfolio.vehicle_sales_data
ADD day_of_month INTEGER;

ALTER TABLE portfolio.vehicle_sales_data
ADD year_of_sale INTEGER;

ALTER TABLE portfolio.vehicle_sales_data
ADD time TIME(0);

ALTER TABLE portfolio.vehicle_sales_data
ADD timezone VARCHAR(14);

UPDATE portfolio.vehicle_sales_data
SET weekday_name = LEFT(sale_date, 3),
	month_name = SUBSTRING(sale_date, 5, 3),
	day_of_month = SUBSTRING(sale_date, 9, 2),
	year_of_sale = SUBSTRING(sale_date, 12, 4),
	time = SUBSTRING(sale_date, 17, 8),
	timezone = SUBSTRING(sale_date, 26, 14);

-- Creating relational database structure

CREATE TABLE make (
 make_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
 make VARCHAR(50));

CREATE TABLE seller (
 seller_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
 seller VARCHAR(50));

CREATE TABLE calendar (
 sale_date VARCHAR(50),
 weekday_name CHAR(3),
 month_name CHAR(3),
 day_of_month INTEGER,
 year_of_sale INTEGER,
 time TIME(0),
 timezone VARCHAR(14));

CREATE TABLE car (
 car_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
 make VARCHAR(50),
 year INTEGER,
 model VARCHAR(50),
 trim VARCHAR(50),
 body VARCHAR(50),
 transmission VARCHAR(50),
 color VARCHAR(50),
 interior VARCHAR(50),
 mmr NUMERIC);

CREATE TABLE sale (
sale_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY, 
sellingprice NUMERIC,
state CHAR(2),
condition INTEGER,
odometer INTEGER,
seller VARCHAR(50),
sale_date VARCHAR(50),
year INTEGER,
model VARCHAR(50),
trim VARCHAR(50),
body VARCHAR(50),
transmission VARCHAR(50),
color VARCHAR(50),
interior VARCHAR(50),
mmr NUMERIC);

-- Inserting data into the database

INSERT INTO make (make)
SELECT DISTINCT make FROM portfolio.vehicle_sales_data; 

INSERT INTO seller (seller)
SELECT DISTINCT seller FROM portfolio.vehicle_sales_data;

INSERT INTO calendar (sale_date, weekday_name, month_name, day_of_month, year_of_sale, time, timezone)
SELECT DISTINCT sale_date, weekday_name, month_name, day_of_month, year_of_sale, time, timezone FROM portfolio.vehicle_sales_data;

ALTER TABLE calendar
ADD month_number INTEGER;
UPDATE calendar
SET month_number =  CASE month_name
        WHEN 'Jan' THEN 01
        WHEN 'Feb' THEN 02
        WHEN 'Mar' THEN 03
        WHEN 'Apr' THEN 04
        WHEN 'May' THEN 05
        WHEN 'Jun' THEN 06
        WHEN 'Jul' THEN 07
        WHEN 'Aug' THEN 08
        WHEN 'Sep' THEN 09
        WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11
        WHEN 'Dec' THEN 12
        ELSE NULL
    END;

ALTER TABLE calendar
ADD date_id VARCHAR(20);

UPDATE calendar 
SET date_id = CONCAT(
	CAST(year_of_sale AS CHAR(4)),
	(CASE WHEN LEN(CAST(month_number AS VARCHAR)) = 2 THEN CAST(month_number AS VARCHAR) ELSE CONCAT('0', CAST(month_number AS VARCHAR)) END),
	(CASE WHEN LEN(CAST(day_of_month AS VARCHAR)) = 2 THEN CAST(day_of_month AS VARCHAR) ELSE CONCAT('0',CAST(day_of_month AS VARCHAR)) END),
	LEFT(CAST(time AS VARCHAR),2), 
	SUBSTRING(CAST(time AS VARCHAR),4,2), 
	SUBSTRING(CAST(time AS VARCHAR),7,2), 
	(CASE WHEN timezone = 'GMT-0700 (PDT)' THEN '7' ELSE '8' END)
	);

ALTER TABLE calendar
ALTER COLUMN date_id BIGINT;

ALTER TABLE calendar
ADD date DATE;
UPDATE calendar
SET date = CAST((CONCAT(year_of_sale,'-',month_number,'-',day_of_month)) AS DATE);

INSERT INTO car (make, year, model, trim, body, transmission, color, interior, mmr)
SELECT DISTINCT  make, year, model, trim, body, transmission, color, interior, mmr FROM portfolio.vehicle_sales_data;
	
ALTER TABLE car
ADD make_id INTEGER;

UPDATE car
SET make_id = (
	SELECT make.make_id
	FROM make
	WHERE make.make = car.make);

ALTER TABLE car
DROP COLUMN make;

INSERT INTO sale (sellingprice, state, condition, odometer, seller, sale_date, year, model, trim, body, transmission, color, interior, mmr)
SELECT sellingprice, state, condition, odometer, seller, sale_date, year, model, trim, body, transmission, color, interior, mmr FROM portfolio.vehicle_sales_data;

ALTER TABLE sale
ADD seller_id INTEGER;

UPDATE sale
SET seller_id = (
	SELECT seller.seller_id
	FROM seller
	WHERE seller.seller = sale.seller);

ALTER TABLE sale
ADD date_id BIGINT;

UPDATE sale
SET date_id = (
	SELECT calendar.date_id
	FROM calendar
	WHERE calendar.sale_date = sale.sale_date);

ALTER TABLE sale
ADD car_id INTEGER;

UPDATE sale
SET car_id = (
	SELECT car.car_id
	FROM car
	WHERE car.year = sale.year AND car.model = sale.model AND car.trim = sale.trim AND car.body = sale.body AND car.transmission = sale.transmission AND car.color = sale.color AND car.interior = sale.interior AND car.mmr = sale.mmr);

ALTER TABLE sale
DROP COLUMN year, model, trim, body, transmission, color, interior, mmr, seller, sale_date;

-- Adding constrains

ALTER TABLE car
ADD CONSTRAINT FK_MakeCar
FOREIGN KEY (make_id) REFERENCES make(make_id);

ALTER TABLE sale
ADD CONSTRAINT FK_CarSale
FOREIGN KEY (car_id) REFERENCES car(car_id);

ALTER TABLE calendar
ALTER COLUMN date_id BIGINT NOT NULL;

ALTER TABLE calendar
ADD CONSTRAINT PK_Calendar
PRIMARY KEY (date_id);

ALTER TABLE sale
ADD CONSTRAINT FK_CalendarSale
FOREIGN KEY (date_id) REFERENCES calendar(date_id);

ALTER TABLE sale
ADD CONSTRAINT FK_SellerSale
FOREIGN KEY (seller_id) REFERENCES seller(seller_id);

-- ANALYTICAL QUERIES ==========================================================================================================================================================

--Explanation of following delete statements is included in the analytical query 0.4.
DELETE FROM sale WHERE LEFT(date_id, 6) IN ('201401','201402','201412','201507');
DELETE FROM calendar WHERE LEFT(date_id, 6) IN ('201401','201402','201412','201507');

-- 0. BASIC ANALYSIS
-- 0.1. What is the number of sales in the dataset?
SELECT 
	COUNT(sale_id) AS number_of_sales
FROM sale;
/*The dataset has 397682 observations.*/

-- 0.2. How many different car manufacturers and car models are introduced in the dataset?
SELECT
	COUNT(DISTINCT make_id) AS number_of_manufacturers,
	COUNT(DISTINCT CONCAT(make_id, model)) AS number_of_models
FROM car;
/*The number of manufacturers is 53 and the number of car models is 767.*/

-- 0.3. What time period does the data refer to?
SELECT
	MIN(date) AS earliest_date,
	MAX(date) AS latest_date
FROM calendar;
/*Dataset covers period from 2015-01-01 to 2015-06-30 (6 months).*/

-- 0.4. How are sales distributed over time?
SELECT 
	year_of_sale,
	month_name,
	COUNT(sale_id) AS number_of_sales
FROM sale
LEFT JOIN calendar
ON sale.date_id = calendar.date_id
GROUP BY year_of_sale, month_name, month_number
ORDER BY year_of_sale, month_number;
/*The dataset doesn't cover a continuous period as there is no data for months March-November 2014 and potentially 
partially missing data for December 2014 and July 2015 (based on the first and last date of the month with sales records). 
Therefore, the analysis will be conducted only on the 6-months period from January 2015 to June 2015.*/

-- 0.5. How many states does the data cover?
SELECT
	COUNT(DISTINCT state) AS number_of_states
FROM sale;
/*Sales are recorded in 34 US states.*/

-- 0.6. How are sales distributed over states?
SELECT 
	state,
	COUNT(sale_id) AS number_of_sales
FROM sale
GROUP BY state
ORDER BY number_of_sales DESC;
/*The most sales were documented in FL, CA, and TX. On the onther hand, the least sales were recorded in AL, OK, and NM.*/

-- 0.7. How many sellers are included in the dataset?
SELECT
	COUNT(seller_id) AS number_of_sellers
FROM seller;
/*11661 sellers are included in the dataset.*/

-- 0.8. What is the distribution of sallers by size?
SELECT 
	seller_category,
	COUNT(seller) AS number_of_sellers
FROM
	(SELECT 
		seller,
		(CASE WHEN COUNT(sale_id) >= 1000 THEN 'Big'
		WHEN COUNT(sale_id) >= 100 THEN 'Medium'
		ELSE 'Small' END) AS seller_category
	FROM sale
	JOIN seller 
	ON sale.seller_id = seller.seller_id
	GROUP BY seller) AS categories
GROUP BY seller_category;
/*Small sellers dominate in the dataset (10772). There are also 413 medium and 56 big sellers.*/

-- 0.9. What is the distribution of sold car prices?
SELECT
	price_category,
	COUNT(sale_id) AS number_of_sales
FROM
	(SELECT
		sale_id,
		(CASE WHEN sellingprice < 40000 THEN 1
		WHEN sellingprice < 80000 THEN 2
		WHEN sellingprice < 120000 THEN 3
		WHEN sellingprice < 160000 THEN 4
		WHEN sellingprice < 200000 THEN 5
		ELSE 6 END) AS price_category
	FROM sale) AS categories
GROUP BY price_category
ORDER BY price_category;
--Supporting query for binning:
SELECT MIN(sellingprice) as min_price, AVG(sellingprice) as avg_price, MAX(sellingprice) as max_price from sale;
/*Most of the cars in the dataset were sold for less than 40k. There was only one car which was sold for more than 200k.*/

-- ==========================================================================================================================================================

-- 1.COMPETITION ANALYSIS
-- 1.1. What sellers did generate the highest revenue during the January-June 2015 period?
SELECT TOP(10)
	seller,
	CAST(ROUND(SUM(sellingprice)/1000000, 2) AS FLOAT) AS revenue_in_mln
FROM sale
JOIN seller
ON seller.seller_id = sale.seller_id
JOIN calendar
ON sale.date_id = calendar.date_id
GROUP BY seller
ORDER BY SUM(sellingprice) DESC;
/*FORD MOTOR CREDIT COMPANY LLC, THE HERTZ CORPORATION, and NISSAN INFINITI LT were the leaders in revenue generation in first 6 month of 2015.
They generated 251,02 mln, 199,73 mln, and 171,21 mln of revenue correspondingly.*/

-- 1.2. Which sellers had the highest average month-to-month revenue growth in first 6 month of 2015?
WITH monthly_revenue_per_seller AS	
	(SELECT
		seller,
		month_number,
		SUM(sellingprice) AS current_month_revenue,
		LAG(SUM(sellingprice),1) OVER (PARTITION BY seller ORDER BY month_number) AS previous_month_revenue
	FROM sale
	JOIN seller
	ON sale.seller_id = seller.seller_id
	JOIN calendar
	ON sale.date_id = calendar.date_id
	GROUP BY seller, month_number)
SELECT TOP(20)
	seller,
	CAST(AVG(current_month_revenue - previous_month_revenue) AS FLOAT) AS avg_revenue_change
FROM monthly_revenue_per_seller
WHERE previous_month_revenue IS NOT NULL
GROUP BY seller
ORDER BY avg_revenue_change DESC;
/*Sellers which had the highest average month-to-month revenue growth were: ARS/FORD-LINCOLN DEALER PROGRAM, THE HERTZ CORPORATION, FCA US LLC.
E.g. It means that ARS/FORD-LINCOLN DEALER PROGRAM on average were increasing their monthly revenue by 7704300 compared to previous months in January-June 2015 period.
Note: it doesn't necessarily mean that they increased m2m revenue in each month or that there were no decreases as mean might be impacted by outliers.*/

-- 1.3. What is the average price of cars sold by each seller?
SELECT 
	seller,
	CAST(ROUND(AVG(sellingprice),0) AS FLOAT) AS avg_selling_price
FROM sale
JOIN seller
ON sale.seller_id = seller.seller_id
GROUP BY seller
ORDER BY avg_selling_price DESC;
/*PHELPS AUTO SALES, FINANCIAL SERVICES REMARKETING (BMW INT), and AUTOLINK SALES LLC sell the most expensive cars.
The average selling price for PHELPS AUTO SALES is 161000.*/

-- 1.4. What is the average difference between selling price and car's market value (mmr) for each seller?
SELECT seller, CAST(AVG(sellingprice - mmr) AS NUMERIC) AS avg_price_diff
FROM sale
JOIN car 
ON sale.car_id = car.car_id
JOIN seller 
ON sale.seller_id = seller.seller_id
GROUP BY seller
ORDER BY avg_price_diff DESC;
/*This query allows to analyze how talented the salesforce of each seller is and how good their selling mechanism is.
The best-performing sellers are PURE PURSUIT AUTOMOTIVE, AUTO WORLD SALES & SERVICE LLC, and CONTINENTAL AUTO GROUP.
They sell cars on average for more than market value by 10k+.*/

-- 1.5. What sellers operate in multiple states?
SELECT 
	seller,
	COUNT(DISTINCT state) AS number_of_states
FROM sale
JOIN seller
ON seller.seller_id = sale.seller_id
GROUP BY seller
HAVING COUNT(DISTINCT state) > 1
ORDER BY number_of_states DESC;
/*There are 1676 sellers which operate in multiple states.*/

-- 1.6. How many sellers operate in each state?
SELECT
	state,
	COUNT(DISTINCT sale.seller_id) AS number_of_sellers
FROM sale
JOIN seller
ON seller.seller_id = sale.seller_id
GROUP BY state
ORDER BY number_of_sellers DESC;
/*The most competitive states are CA, FL, PA, TX, and GA as there are more than 1000 operating sellers.*/

-- ==========================================================================================================================================================

-- 2. PORTFOLIO ANALYSIS
-- 2.1. Which car model is sold the most by each seller?
CREATE TABLE #model_sales_per_seller (seller VARCHAR(50), make VARCHAR(50), model VARCHAR(50), units_sold INT)
INSERT INTO #model_sales_per_seller (seller, make, model, units_sold)
SELECT 
		seller,
		make,
		model,
		COUNT(sale_id) AS units_sold
FROM dbo.seller 
JOIN sale
ON seller.seller_id = sale.seller_id
JOIN car
ON sale.car_id = car.car_id
JOIN make
ON car.make_id = make.make_id
GROUP BY seller, make, model;
--(creating temporary tables instead of CTEs as it allows to preview steps results independently)
CREATE TABLE #max_model_sales_per_seller (seller VARCHAR(50), max_units_sold INT)
INSERT INTO #max_model_sales_per_seller (seller, max_units_sold)
SELECT 
	seller,
	MAX(units_sold) AS max_units_sold
FROM #model_sales_per_seller
GROUP BY seller;
--There are many sellers who didn't sell more than 10 cars of any model. As they are small players, they should be filtered out in the following query for clearer analysis
CREATE TABLE #bestsellers_per_seller (seller VARCHAR(50), make VARCHAR(50), model VARCHAR(50), units_sold INT)
INSERT INTO #bestsellers_per_seller (seller, make, model, units_sold)
SELECT
	x.seller,
	y.make,
	y.model,
	x.max_units_sold AS units_sold
FROM #max_model_sales_per_seller AS x
JOIN #model_sales_per_seller AS y
ON x.seller = y.seller AND x.max_units_sold = y.units_sold
WHERE x.max_units_sold >=10 
ORDER BY units_sold DESC;
/*With no surprise, often the best selling car models for sellers are those that were produced by manufacturers they work for.
For example INFINITI G SEDAN is the best selling car model for NISSAN INFINITI LT.*/
--But which models are bestsellers for sellers most often?
SELECT
	make,
	model,
	COUNT(seller) AS bestseller_for_seller_number
FROM #bestsellers_per_seller
GROUP BY make, model
ORDER BY bestseller_for_seller_number DESC;
/*Ford F-150, Honda Accord, and BMW 3 Series are the best selling cars for the highest number of sellers.*/
--And which car manufacturers create bestsellers most often?
SELECT
	make,
	COUNT(seller) AS bestseller_for_seller_number
FROM #bestsellers_per_seller
GROUP BY make
ORDER BY bestseller_for_seller_number DESC;
/*The podium places of car manufacturers that produce bestsellers for distributors were taken by Ford, Chevrolet, and Honda.*/

-- 2.2. Which car models grew in popularity?
CREATE VIEW growing_in_popularity AS
WITH sales_by_month_and_model AS
	(SELECT
		make,
		model,
		month_number,
		COUNT(sale_id) AS current_mon_num_of_sales,
		LEAD(COUNT(sale_id), 1) OVER(PARTITION BY make, model ORDER BY month_number) AS next_mon_num_of_sales
	FROM sale
	JOIN car 
	ON sale.car_id = car.car_id
	JOIN make
	ON car.make_id = make.make_id
	JOIN calendar
	ON calendar.date_id = sale.date_id
	WHERE CONCAT(make, ' ', model) IN (SELECT CONCAT(make, ' ', model) AS car_model
									   FROM sale 
									   JOIN calendar ON sale.date_id = calendar.date_id
									   JOIN car ON sale.car_id = car.car_id
									   JOIN make ON car.make_id = make.make_id
									   GROUP BY make, model
									   HAVING COUNT(DISTINCT month_number) = 6) -- We want to analyze only the models which were sold in every month from January to June 2015.
	GROUP BY make, model, month_number),
sales_diff_by_month_and_model AS
	(SELECT
	make,
	model,
	month_number,
	(next_mon_num_of_sales - current_mon_num_of_sales) AS next_month_sales_difference
	FROM sales_by_month_and_model
	WHERE next_mon_num_of_sales IS NOT NULL)
SELECT TOP(20)
	make,
	model,
	SUM(next_month_sales_difference) AS sum_m2m_sale_changes
FROM sales_diff_by_month_and_model
WHERE CONCAT(make, ' ', model) IN (SELECT car_model
								   FROM (SELECT CONCAT(make, ' ', model) AS car_model, COUNT(next_month_sales_difference) AS num_of_positive_diffs
										 FROM sales_diff_by_month_and_model
										 WHERE next_month_sales_difference > 0
										 GROUP BY make, model) AS count_diffs
								   WHERE num_of_positive_diffs >= 3) --making sure that we analyze only the car models which had at least 3 months with month-to-month sales increase as it indicates a more stable positive trend.
GROUP BY make, model
HAVING SUM(next_month_sales_difference) > 0
ORDER BY sum_m2m_sale_changes DESC;
/*Top 3 cars that grew in popularity during the first 6 months of 2015 were: NISSAN LEAF, GMC SAVANA CARGO, and CHEVROLET SONIC.*/

-- 2.3. Which car models are sold on average for more than market value (mmr) suggests?
--(Opportunity to buy for less in one place and sell for more in other place)
CREATE VIEW sold_for_more_than_mmr AS
SELECT TOP(20)
	make,
	model,
	ROUND(CAST(AVG(sellingprice-mmr) AS FLOAT),2) AS avg_price_diff_from_mmr
FROM make
JOIN car
ON make.make_id = car.make_id
JOIN sale
ON car.car_id = sale.car_id
GROUP BY make, model
ORDER BY avg_price_diff_from_mmr DESC;
/*ASTON MARTIN RAPIDE, CADILLAC CTS-V WAGON, and ASTON MARTIN DB9 are the leaders among cars that are sold for more than market value suggests.
There is a potential in these models as it indicates low price elasticity which means that demand decreases slower with price increase.
There is an opportunity to get high sales margins with these models.*/

-- 2.4. Which car models either grew in popularity or were sold on average for more than the market value (mmr) suggests?
SELECT make, model 
FROM growing_in_popularity
UNION
SELECT make, model
FROM sold_for_more_than_mmr;
/*There is no intersection between top 20 cars that grew in popularity and top 20 cars that were sold on average for more than the market value suggests.
Therefore, the resulting table consists of 40 different car models.*/

-- 2.5. Which combinations of car attributes (body, transmission) were in highest demand?
SELECT DISTINCT 
	body, 
	transmission,
	COUNT(sale_id) AS sales_number
FROM car
INNER JOIN sale
ON car.car_id = sale.car_id
GROUP BY body, transmission
ORDER BY sales_number DESC;
/*Automatic sedans, suvs, and minivans were in highest demand in first 6 months of 2015.*/

-- 2.6. What car color is the best-selling for each car manufacturer?
SELECT make, color, num_of_sales
FROM
	(SELECT 
		make.make, 
		car.color, 
		COUNT(sale.sale_id) AS num_of_sales, 
		MAX(COUNT(sale.sale_id)) OVER (PARTITION BY make) AS max_sales_by_manu
	FROM sale 
	LEFT JOIN car
	ON sale.car_id = car.car_id
	LEFT JOIN make
	ON car.make_id = make.make_id
	GROUP BY make.make, car.color) AS subselect
WHERE num_of_sales = max_sales_by_manu
ORDER BY make;
/*The best selling car color for most of the manufacturers is black. However, sometimes white, red, and silver are bestsellers too.*/