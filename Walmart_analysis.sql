use [Walmart Analysis]

--EXTRACTING INSIGHTS

--1.Quarterly Sales
select sum(total_sales) as Total_Sales,sale_quarter
from WalmartSales_Cleaned
group by sale_quarter

--2.Total Sales By Category 
SELECT 
    category,
    SUM(total_sales) AS total_revenue,
    AVG(profit_margin) AS avg_profit_margin,
    COUNT(*) AS total_transactions
FROM WalmartSales_Cleaned
GROUP BY category
ORDER BY total_revenue DESC;

--3.Top Performing Cities
SELECT 
    City,
    SUM(total_sales) AS city_revenue,
    AVG(rating) AS avg_rating
FROM WalmartSales_Cleaned
GROUP BY City
ORDER BY city_revenue DESC;

--4.Branch Level Performance
SELECT 
    Branch,
    COUNT(*) AS transactions,
    SUM(total_sales) AS revenue,
    AVG(profit_margin) AS avg_margin
FROM WalmartSales_Cleaned
GROUP BY Branch
order by 3 desc;

--5. Sales Trend Over Time(Monthly)
SELECT 
    FORMAT(sale_date, 'yyyy-MM') AS YearMonth,
    SUM(total_sales) AS revenue,
    COUNT(*) AS orders
FROM WalmartSales_Cleaned
GROUP BY FORMAT(sale_date, 'yyyy-MM')
ORDER BY YearMonth;

--6.Payment Method Preferences
SELECT 
    payment_method,
    COUNT(*) AS usage_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS usage_percentage
FROM WalmartSales_Cleaned
GROUP BY payment_method
ORDER BY usage_count DESC;

--7.
SELECT 
    time_of_day,
    COUNT(*) AS total_orders,
    SUM(total_sales) AS total_revenue
FROM WalmartSales_Cleaned
GROUP BY time_of_day
ORDER BY total_orders DESC;

--8.Rating Distribution by Category
SELECT 
    category,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM WalmartSales_Cleaned
GROUP BY category;

--9.Top 3 Cities By Revenue
WITH CityRevenue AS (
    SELECT 
        City,
        SUM(total_sales) AS revenue
    FROM WalmartSales_Cleaned
    GROUP BY City
),
RankedCities AS (
    SELECT 
        City,
        revenue,
        RANK() OVER (ORDER BY revenue DESC) AS rank_position
    FROM CityRevenue
)
SELECT * FROM RankedCities
WHERE rank_position <= 3;

--Subtables For Joins
-- Create a Category Dimension Table
SELECT DISTINCT category INTO DimCategory FROM WalmartSales_Cleaned;
-- Create a Branch Dimension Table
SELECT DISTINCT Branch, City INTO DimBranch FROM WalmartSales_Cleaned;
-- Create a Payment Method Dimension Table
SELECT DISTINCT payment_method INTO DimPaymentMethod FROM WalmartSales_Cleaned;

--10.CategoryWise Profit Margin vs Total Sales
WITH CategorySales AS (
    SELECT 
        category,
        SUM(total_sales) AS total_revenue,
        AVG(profit_margin) AS avg_profit
    FROM WalmartSales_Cleaned
    GROUP BY category
)
SELECT 
    cs.category,
    cs.total_revenue,
    cs.avg_profit,
    dc.category AS category_name
FROM CategorySales cs
JOIN DimCategory dc ON cs.category = dc.category;

--11.Peak Shopping Hours Analysis
WITH HourlySales AS (
    SELECT 
        DATEPART(HOUR, sale_time) AS sale_hour,
        COUNT(*) AS total_orders,
        SUM(total_sales) AS total_revenue
    FROM WalmartSales_Cleaned
    GROUP BY DATEPART(HOUR, sale_time)
)
SELECT * FROM HourlySales
ORDER BY total_orders DESC;
