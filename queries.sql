--Problem 1: Customer Demographics and Country-wise Distribution with Window Functions and CASE
--Count the number of customers from each country and add a "rank" to each country based on customer count.

-- CTE to get the number of customers per country
WITH Customer_Country AS (
    SELECT 
        c.country_name, 
        COUNT(cs.id) AS customer_count
    FROM customer cs
    JOIN country c ON cs.country_id = c.id
    GROUP BY c.country_name
)

-- Select country name, customer count, and rank by customer count
SELECT 
    country_name, 
    customer_count, 
    RANK() OVER (ORDER BY customer_count DESC) AS country_rank
FROM Customer_Country;


--Problem 2: Most Popular Card Types in Different Countries with CASE and Window Functions
--Identify the most popular card type in each country and rank them.

-- Select country, card type, and count of card usages, ranked by usage within each country
SELECT 
    c.country_name,  -- Country name
    ct.card_type_name,  -- Card type name
    COUNT(*) AS card_usage_count,  -- Count of card usages for each country and card type
    RANK() OVER (PARTITION BY c.country_name ORDER BY COUNT(*) DESC) AS card_rank  -- Rank card types by usage count within each country
FROM card_number cn
JOIN customer cs ON cn.customer_id = cs.id  -- Join to customer table
JOIN country c ON cs.country_id = c.id  -- Join to country table
JOIN card_type ct ON cn.card_type_id = ct.id  -- Join to card type table
GROUP BY c.country_name, ct.card_type_name  -- Group by country and card type
ORDER BY c.country_name, card_usage_count DESC;  -- Order by country and usage count in descending order


--Problem 3: Transaction Patterns Over Time with Intervals
--Analyzing customer transaction patterns by calculating monthly transaction 
--totals with an interval of time (e.g., last 6 months).

SELECT 
    EXTRACT(YEAR FROM ct.date) AS year,  -- Extract the year from the transaction date
    EXTRACT(MONTH FROM ct.date) AS month,  -- Extract the month from the transaction date
    SUM(ct.amount) AS total_transaction_amount  -- Sum the transaction amounts for each month
FROM card_transaction ct
WHERE ct.date >= CURRENT_DATE - INTERVAL '6 MONTH'  -- Filter transactions from the last 6 months
GROUP BY year, month  -- Group results by year and month
ORDER BY year, month;  -- Order the results by year and month


--Problem 4: Top 5 Customers by Total Transaction Value using COALESCE for Null Values
--Identifying the top 5 customers who spent the most, and using COALESCE to handle customers with no transactions.

SELECT cs.first_name, cs.last_name, 
       COALESCE(SUM(ct.amount), 0) AS total_spent  -- Sum of transaction amounts, default to 0 if NULL
FROM customer cs
LEFT JOIN card_number cn ON cs.id = cn.customer_id  -- Join with card_number to link customers and cards
LEFT JOIN card_transaction ct ON cn.id = ct.card_number_id  -- Join with card_transaction to get transaction amounts
GROUP BY cs.id  -- Group by customer to get total spent per customer
ORDER BY total_spent DESC  -- Order by total spent in descending order
LIMIT 5;  -- Limit to the top 5 customers by total spent


--Problem 5: Year-over-Year Transaction Growth with Window Function
--Calculate the year-over-year (YoY) growth in total transaction value for each year.

SELECT 
    EXTRACT(YEAR FROM ct.date) AS year,  -- Extract the year from the transaction date
    SUM(ct.amount) AS total_transaction,  -- Total transaction amount for each year
    LAG(SUM(ct.amount)) OVER (ORDER BY EXTRACT(YEAR FROM ct.date)) AS previous_year_transaction,  -- Get the previous year's transaction amount
    (SUM(ct.amount) - LAG(SUM(ct.amount)) OVER (ORDER BY EXTRACT(YEAR FROM ct.date))) /  -- Calculate the year-over-year growth
    LAG(SUM(ct.amount)) OVER (ORDER BY EXTRACT(YEAR FROM ct.date)) * 100 AS yoy_growth  -- Percentage growth compared to the previous year
FROM card_transaction ct
GROUP BY EXTRACT(YEAR FROM ct.date)  -- Group by year to calculate totals and growth
ORDER BY year;  -- Order by year


--Problem 6: Transaction Statistics for Each Country using Temporary Tables
--Create a temporary table to store transaction statistics by country, and use it for further analysis.

-- Create a temporary table to store transaction stats by country
CREATE TEMPORARY TABLE Country_Transaction_Stats AS
SELECT 
    c.country_name,  -- Country name
    SUM(ct.amount) AS total_amount,  -- Total transaction amount per country
    COUNT(ct.id) AS transaction_count  -- Number of transactions per country
FROM card_transaction ct
JOIN card_number cn ON ct.card_number_id = cn.id  -- Join to get card details
JOIN customer cs ON cn.customer_id = cs.id  -- Join to get customer details
JOIN country c ON cs.country_id = c.id  -- Join to get country details
GROUP BY c.country_name;  -- Group by country

-- Select all data from the temporary table
SELECT * FROM Country_Transaction_Stats;

-- Drop the temporary table after usage
DROP TEMPORARY TABLE Country_Transaction_Stats;


--Problem 7: Card Usage Over Time with Window Function and CASE
--Track card usage over time and categorize customers based on their activity (e.g., frequent, occasional users).

SELECT 
    cs.first_name,  -- Customer first name
    cs.last_name,  -- Customer last name
    COUNT(ct.id) AS transaction_count,  -- Count of transactions per customer
    CASE  -- Classify customers based on their transaction count
        WHEN COUNT(ct.id) > 10 THEN 'Frequent User'  -- More than 10 transactions
        WHEN COUNT(ct.id) BETWEEN 5 AND 10 THEN 'Occasional User'  -- Between 5 and 10 transactions
        ELSE 'Infrequent User'  -- Less than 5 transactions
    END AS usage_category
FROM customer cs
LEFT JOIN card_number cn ON cs.id = cn.customer_id  -- Join to card_number table
LEFT JOIN card_transaction ct ON cn.id = ct.card_number_id  -- Join to card_transaction table
GROUP BY cs.id  -- Group by customer to calculate transaction count
ORDER BY transaction_count DESC;  -- Order by transaction count in descending order


--Problem 8: Stored Procedure for Top Customers by Country
--Create a stored procedure that returns the top 5 customers by transaction value for a specific country.

-- Create or replace the function to get the top customers by country
CREATE OR REPLACE FUNCTION GetTopCustomersByCountry(country_name VARCHAR)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, total_spent DECIMAL) AS $$
BEGIN
    RETURN QUERY
    -- Select the top 5 customers by total spent in the given country
    SELECT cs.first_name, cs.last_name, SUM(ct.amount) AS total_spent
    FROM customer cs
    JOIN country c ON cs.country_id = c.id
    JOIN card_number cn ON cs.id = cn.customer_id
    JOIN card_transaction ct ON cn.id = ct.card_number_id
    WHERE c.country_name = GetTopCustomersByCountry.country_name  -- Use the function parameter
    GROUP BY cs.id
    ORDER BY total_spent DESC
    LIMIT 5;
END;
$$ LANGUAGE plpgsql;

-- Call the function for a specific country
SELECT * FROM GetTopCustomersByCountry('United States');