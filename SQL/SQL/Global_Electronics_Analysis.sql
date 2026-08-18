CREATE DATABASE global_electronics;
USE global_electronics;
SHOW TABLES;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM exchange_rates;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM stores;

-- 1.Total sales transactions
SELECT COUNT(*) AS total_transactions
FROM sales;

-- 2.How many unique customers have purchased?
SELECT COUNT(DISTINCT CustomerKey) AS unique_customers
FROM sales;

-- 3.How many different products have actually been sold?
SELECT COUNT(DISTINCT ProductKey) AS total_products_sold
FROM sales;

-- 4.How many individual units of products were sold across all transactions?
SELECT SUM(QUANTITY) AS total_quantity
FROM sales;

-- 5.Which 10 products have sold the highest number of units?
SELECT ProductKey,SUM(Quantity) AS total_quantity
FROM sales
GROUP BY ProductKey
ORDER BY total_quantity DESC
LIMIT 10;

-- 6.What are the names and details of the 10 products with the highest quantity sold?
SELECT products.ProductKey, products.ProductName, SUM(sales.Quantity) AS total_quantity
FROM sales
JOIN products
ON sales.ProductKey = products.ProductKey
GROUP BY products.ProductKey, products.ProductName
ORDER BY total_quantity DESC
LIMIT 10;

-- 7.Which brand sells the most
SELECT products.Brand, SUM(sales.quantity) as total_quantity
FROM sales
JOIN products
ON sales.ProductKey = products.ProductKey
GROUP BY products.Brand
ORDER BY total_quantity DESC
LIMIT 10;

-- 8.Which product categories sell the most units?
SELECT products.Category, SUM(sales.quantity) as total_quantity
FROM sales
JOIN products
ON sales.ProductKey = products.ProductKey
GROUP BY products.Category
ORDER BY total_quantity DESC
LIMIT 10;

-- 9.Which categories generate the most revenue?
SELECT products.Category, SUM(sales.Quantity * products.UnitPriceUSD) AS total_revenue
FROM sales
JOIN products
ON sales.ProductKey = products.ProductKey
GROUP BY products.Category
ORDER BY total_revenue DESC;

-- 10.Total Revenue and Total Profit
SELECT SUM(sales.Quantity * products.UnitPriceUSD) AS total_revenue,
SUM(sales.Quantity * products.UnitCostUSD) AS total_cost,
SUM(sales.Quantity * (products.UnitPriceUSD - products.UnitCostUSD)) AS total_profit
FROM sales
JOIN products
ON sales.ProductKey = products.ProductKey;

-- 11.What percentage of revenue does the company keep as profit?
SELECT
    SUM(sales.Quantity * products.UnitPriceUSD) AS total_revenue,
    SUM(
        sales.Quantity * (products.UnitPriceUSD - products.UnitCostUSD)
    ) AS total_profit,
    ROUND(
        SUM(sales.Quantity * (products.UnitPriceUSD - products.UnitCostUSD))
        / SUM(sales.Quantity * products.UnitPriceUSD) * 100,
        2
    ) AS profit_margin_percentage
FROM sales
JOIN products
    ON sales.ProductKey = products.ProductKey;
    
-- 12.Total Number of Sales Transactions
SELECT COUNT(*) AS total_transactions FROM sales;

-- 13.Average Quantity per Transaction
SELECT ROUND(AVG(Quantity), 2) AS avg_quantity_per_transaction
FROM sales;

-- 14.Average Product Selling Price
SELECT ROUND(AVG(UnitPriceUSD), 2) AS avg_unit_price
FROM products;

-- 15.Top 10 Most Profitable Products
SELECT
    products.ProductKey,
    products.ProductName,
    SUM(
        sales.Quantity *
        (products.UnitPriceUSD - products.UnitCostUSD)
    ) AS total_profit
FROM sales
JOIN products
    ON sales.ProductKey = products.ProductKey
GROUP BY
    products.ProductKey,
    products.ProductName
ORDER BY total_profit DESC
LIMIT 10;

-- 16.Top 10 Products by Revenue
SELECT
    products.ProductKey,
    products.ProductName,
    SUM(sales.Quantity * products.UnitPriceUSD) AS total_revenue
FROM sales
JOIN products
    ON sales.ProductKey = products.ProductKey
GROUP BY
    products.ProductKey,
    products.ProductName
ORDER BY total_revenue DESC
LIMIT 10;

-- 17.Profit by Brand
SELECT
    products.Brand,
    ROUND(
        SUM(
            sales.Quantity *
            (products.UnitPriceUSD - products.UnitCostUSD)
        ),
        2
    ) AS total_profit
FROM sales
JOIN products
    ON sales.ProductKey = products.ProductKey
GROUP BY products.Brand
ORDER BY total_profit DESC;

-- 18.Profit by Category
SELECT
    products.Category,
    ROUND(
        SUM(
            sales.Quantity *
            (products.UnitPriceUSD - products.UnitCostUSD)
        ),
        2
    ) AS total_profit
FROM sales
JOIN products
    ON sales.ProductKey = products.ProductKey
GROUP BY products.Category
ORDER BY total_profit DESC;

-- 19.Product Profit Margin
SELECT
    products.ProductKey,
    products.ProductName,
    ROUND(
        (
            products.UnitPriceUSD - products.UnitCostUSD
        ) / products.UnitPriceUSD * 100,
        2
    ) AS profit_margin_percentage
FROM products
WHERE products.UnitPriceUSD > 0
ORDER BY profit_margin_percentage DESC
LIMIT 10;

-- 20.Final Business Summary
SELECT
    COUNT(*) AS total_transactions,
    SUM(sales.Quantity) AS total_units_sold,
    ROUND(
        SUM(sales.Quantity * products.UnitPriceUSD),
        2
    ) AS total_revenue,
    ROUND(
        SUM(sales.Quantity * products.UnitCostUSD),
        2
    ) AS total_cost,
    ROUND(
        SUM(
            sales.Quantity *
            (products.UnitPriceUSD - products.UnitCostUSD)
        ),
        2
    ) AS total_profit,
    ROUND(
        SUM(
            sales.Quantity *
            (products.UnitPriceUSD - products.UnitCostUSD)
        )
        /
        SUM(sales.Quantity * products.UnitPriceUSD) * 100,
        2
    ) AS profit_margin_percentage
FROM sales
JOIN products
    ON sales.ProductKey = products.ProductKey;

-- 21. Available Currencies
SELECT DISTINCT Currency
FROM exchange_rates;

-- 22. Average Exchange Rate by Currency
SELECT
    Currency,
    ROUND(AVG(ExchangeRate), 4) AS average_exchange_rate
FROM exchange_rates
GROUP BY Currency
ORDER BY average_exchange_rate DESC;

-- 23. Minimum and Maximum Exchange Rate
SELECT
    Currency,
    MIN(ExchangeRate) AS minimum_exchange_rate,
    MAX(ExchangeRate) AS maximum_exchange_rate
FROM exchange_rates
GROUP BY Currency
ORDER BY Currency;
