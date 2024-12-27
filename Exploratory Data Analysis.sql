-- EXPLORATORY DATA ANALYSIS (EDA)

-- STEP 1: Data Overview
-- Display all data from each table for initial exploration
SELECT * FROM Category;       -- View all records in the Category table
SELECT * FROM Customers;      -- View all records in the Customers table
SELECT * FROM Sellers;        -- View all records in the Sellers table
SELECT * FROM Products;       -- View all records in the Products table
SELECT * FROM Orders;         -- View all records in the Orders table
SELECT * FROM Order_items;    -- View all records in the Order_items table
SELECT * FROM Payments;       -- View all records in the Payments table
SELECT * FROM Shipping;       -- View all records in the Shipping table
SELECT * FROM Inventory;      -- View all records in the Inventory table

-- Check the distinct payment statuses in the Payments table
SELECT DISTINCT payment_status
FROM Payments;

-- Count the number of rows where return_date is not NULL in the Shipping table
SELECT COUNT(return_date) AS Non_Null_Returns
FROM Shipping
WHERE return_date IS NOT NULL;

-- STEP 2: Data Quality Checks

-- Check for NULL values in each column across all tables
SELECT 
    'Category' AS Table_Name, 
    COUNT(*) AS Total_Rows,
    COUNT(category_id) AS Non_Null_Ids,
    COUNT(category_name) AS Non_Null_Names
FROM Category
UNION
SELECT 
    'Customers', COUNT(*), COUNT(customer_id), COUNT(f_name)
FROM Customers
UNION
SELECT 
    'Sellers', COUNT(*), COUNT(seller_id), COUNT(seller_name)
FROM Sellers;

-- Check for duplicate primary keys in Category table
SELECT category_id, COUNT(*)
FROM Category
GROUP BY category_id
HAVING COUNT(*) > 1;

-- Check for duplicate primary keys in Customers table
SELECT customer_id, COUNT(*)
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Ensure every product's category_id exists in the Category table
SELECT p.category_id 
FROM Products p
LEFT JOIN Category c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

-- Ensure every order's customer_id exists in the Customers table
SELECT o.customer_id 
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- STEP 3: Descriptive Statistics

-- Basic statistics for product prices in the Products table
SELECT 
    MIN(price) AS Min_Price,
    MAX(price) AS Max_Price,
    AVG(price) AS Avg_Price,
    STDDEV(price) AS Stddev_Price
FROM Products;

-- Quantity distribution for order items in the Order_items table
SELECT 
    MIN(quantity) AS Min_Quantity,
    MAX(quantity) AS Max_Quantity,
    AVG(quantity) AS Avg_Quantity
FROM Order_items;

-- Count distinct categories in the Category table
SELECT COUNT(DISTINCT category_name) AS Unique_Categories 
FROM Category;

-- Count distinct customer names in the Customers table
SELECT COUNT(DISTINCT f_name || ' ' || l_name) AS Unique_Customers 
FROM Customers;

-- STEP 4: Relationship Exploration

-- Category-Level Analysis: Count products per category
SELECT 
    c.category_name, 
    COUNT(p.product_id) AS Product_Count
FROM Category c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

-- Customer Behavior: Count the number of orders per customer
SELECT 
    c.f_name || ' ' || c.l_name AS Customer_Name,
    COUNT(o.order_id) AS Total_Orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY Customer_Name
ORDER BY 1
LIMIT 5;

-- Seller Performance: Total orders and average order value per seller
SELECT 
    s.seller_name, 
    COUNT(o.order_id) AS Total_Orders,
    AVG(oi.price_per_unit * oi.quantity) AS Avg_Order_Value
FROM Sellers s
LEFT JOIN Orders o ON s.seller_id = o.seller_id
LEFT JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY s.seller_name;

-- STEP 5: Trend Analysis

-- Order trends over time (monthly aggregation)
SELECT 
    DATE_TRUNC('month', order_date) AS Month,
    COUNT(order_id) AS Total_Orders
FROM Orders
GROUP BY Month
ORDER BY Month;

-- State-wise customer distribution
SELECT 
    state, 
    COUNT(customer_id) AS Total_Customers
FROM Customers
GROUP BY state
ORDER BY Total_Customers DESC;

-- STEP 6: Anomalies and Outliers

-- Detect products with unusually high or low prices (outliers)
SELECT * 
FROM Products
WHERE price < (SELECT AVG(price) - 3 * STDDEV(price) FROM Products)
   OR price > (SELECT AVG(price) + 3 * STDDEV(price) FROM Products);

-- Identify orders with missing shipping or payment information
SELECT o.order_id, s.delivery_status, p.payment_status
FROM Orders o
LEFT JOIN Shipping s ON o.order_id = s.order_id
LEFT JOIN Payments p ON o.order_id = p.order_id
WHERE s.shipping_id IS NULL OR p.payment_id IS NULL;

-- STEP 7: Visualization Preparation

-- Product count and total sales by category
SELECT 
    c.category_name, 
    COUNT(p.product_id) AS Product_Count,
    SUM(oi.price_per_unit * oi.quantity) AS Total_Sales
FROM Category c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name;
