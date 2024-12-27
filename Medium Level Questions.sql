/*
MEDIUM LEVEL QUESTIONS
These questions involve complex GROUP BY, aggregation, subqueries, CASE statements, and window functions.
Count and Distinct
Join with Aggregation
Aggregate Functions and CASE
Nested Aggregation
Conditional Aggregation
Simple Subquery
Correlated Subquery
Subquery in WHERE Clause
Subquery in SELECT Clause
Subquery with EXISTS
IN Clause with Subquery
NOT IN Clause
Subquery with JOIN
Subquery with HAVING
Multi-level Subqueries
RANK() Function
DENSE_RANK() Function
ROW_NUMBER() Function
NTILE() Function
OVER Clause
*/

-- 16. Find the total number of distinct products sold in each category.
SELECT c.category_name, COUNT(DISTINCT p.product_id) AS distinct_products
FROM Category c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name;

-- 17. Find the total number of orders and the total revenue generated for each customer.
SELECT c.customer_id, CONCAT(c.f_name, ' ', c.l_name) AS customer_name, COUNT(o.order_id) AS total_orders,
       SUM(oi.quantity * oi.price_per_unit) AS total_revenue
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.f_name, c.l_name;

-- 18. Find the number of orders for each order status.
SELECT o.order_status, COUNT(*) AS total_orders
FROM Orders o
GROUP BY o.order_status;

-- 19. Find the category with the highest total revenue.
SELECT c.category_name, SUM(oi.quantity * oi.price_per_unit) AS total_revenue
FROM Category c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC
LIMIT 1;

-- 20. Count the number of successful and failed payments for each customer.
SELECT c.customer_id, CONCAT(c.f_name, ' ', c.l_name) AS customer_name,
       SUM(CASE WHEN p.payment_status = 'Successful' THEN 1 ELSE 0 END) AS successful_payments,
       SUM(CASE WHEN p.payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payments
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.customer_id, c.f_name, c.l_name;

-- 21. Find the product with the highest price.
SELECT product_name, price
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);

-- 22. Find all products whose price is above the average price in their category.
SELECT product_name, price
FROM Products p
WHERE price > (SELECT AVG(price) FROM Products p2 WHERE p2.category_id = p.category_id);

-- 23. Retrieve the names of customers who have ordered at least one product in the 'Pet Supplies' category.
SELECT DISTINCT CONCAT(c.f_name, ' ', c.l_name) AS customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.category_id = (SELECT category_id FROM Category WHERE category_name = 'Pet Supplies');

-- 24. For each product, display its name and the total number of times it has been ordered.
SELECT p.product_name, SUM(oi.quantity) AS total_orders
FROM Products p
JOIN Order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name;

-- 25. List all customers who have made at least one order.
SELECT DISTINCT CONCAT(c.f_name, ' ', c.l_name) AS customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

-- 26. Find the names of sellers who have sold 'Apple' products.
SELECT DISTINCT s.seller_name
FROM Sellers s
JOIN Orders o ON s.seller_id = o.seller_id
JOIN Order_items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.product_name LIKE '%Apple%';

-- 27. List all customers who have not placed any orders.
SELECT CONCAT(c.f_name, ' ', c.l_name) AS customer_name
FROM Customers c
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE c.customer_id = o.customer_id);

-- 28. Find the names of products that are out of stock.
SELECT product_name
FROM Products p
WHERE p.product_id IN (SELECT product_id FROM Inventory WHERE stock = 0);

-- 29. Retrieve sellers who have an average selling price of their products greater than 300.
SELECT s.seller_name
FROM Sellers s
JOIN Orders o ON s.seller_id = o.seller_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY s.seller_name
HAVING AVG(oi.price_per_unit) > 300;

-- 30. Find the product that has generated the highest revenue.
SELECT p.product_name, SUM(oi.quantity * oi.price_per_unit) AS total_revenue
FROM Products p
JOIN Order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 1;

-- 31. Rank the products based on their total sales amount for each category.
SELECT c.category_name, p.product_name, SUM(oi.quantity * oi.price_per_unit) AS total_sales,
       RANK() OVER (PARTITION BY c.category_name ORDER BY SUM(oi.quantity * oi.price_per_unit) DESC) AS rank
FROM Products p
JOIN Order_items oi ON p.product_id = oi.product_id
JOIN Category c ON p.category_id = c.category_id
GROUP BY c.category_name, p.product_name;

-- 32. List the top 5 customers based on the total amount spent.
SELECT CONCAT(c.f_name, ' ', c.l_name) AS customer_name, SUM(oi.quantity * oi.price_per_unit) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.f_name, c.l_name
ORDER BY total_spent DESC
LIMIT 5;

-- 33. Assign a row number to each product in the products table, ordered by price descending.
SELECT product_name, price, ROW_NUMBER() OVER (ORDER BY price DESC) AS row_number
FROM Products;

-- 34. Divide all customers into 4 quartiles based on the total amount they have spent.
SELECT CONCAT(c.f_name, ' ', c.l_name) AS customer_name, SUM(oi.quantity * oi.price_per_unit) AS total_spent,
       NTILE(4) OVER (ORDER BY SUM(oi.quantity * oi.price_per_unit) DESC) AS quartile
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.f_name, c.l_name;

-- 35. For each order, calculate the running total of sales for the corresponding customer.
SELECT o.order_id, o.customer_id, SUM(oi.quantity * oi.price_per_unit) AS order_total,
       SUM(SUM(oi.quantity * oi.price_per_unit)) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS running_total
FROM Orders o
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_id, o.order_date;