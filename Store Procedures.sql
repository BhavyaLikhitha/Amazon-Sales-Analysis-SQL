/*
-- Store Procedure
create a function as soon as the product is sold the the same quantity should deducted from inventory table
after adding any sales records it should update the stock in the inventory table based on the product and qty purchased
-- 
*/

CREATE OR REPLACE PROCEDURE add_sales
(
p_order_id INT,
p_customer_id INT,
p_seller_id INT,
p_order_item_id INT,
p_product_id INT,
p_quantity INT
)
LANGUAGE plpgsql
AS $$

DECLARE 
-- all variables decleration here
v_count INT;
v_price FLOAT;
v_product_name VARCHAR(50);

BEGIN
-- Fetching product name and price based product_id entered
	SELECT 
		price, product_name
		INTO
		v_price, v_product_name
	FROM products
	WHERE product_id = p_product_id;
	
-- checking stock and product availability in inventory	
	SELECT 
		COUNT(*) 
		INTO
		v_count
	FROM inventory
	WHERE 
		product_id = p_product_id
		AND 
		stock >= p_quantity;
		
	IF v_count > 0 THEN
	-- add into orders and order_items table
	-- update inventory
		INSERT INTO orders(order_id, order_date, customer_id, seller_id)
		VALUES
		(p_order_id, CURRENT_DATE, p_customer_id, p_seller_id);

		-- adding into order list
		INSERT INTO order_items(order_item_id, order_id, product_id, quantity, price_per_unit, total_sales)
		VALUES
		(p_order_item_id, p_order_id, p_product_id, p_quantity, v_price, v_price*p_quantity);

		--updating inventory
		UPDATE inventory
		SET stock = stock - p_quantity
		WHERE product_id = p_product_id;
		
		RAISE NOTICE 'Thank you product: % sale has been added and also stock in inventory is also updated',v_product_name; 

	ELSE
		RAISE NOTICE 'Uhh Ohh! Sorry: % dont have % stock remaining in the inventory', v_product_name,v_quantity;

	END IF;


END;
$$

SELECT *
FROM inventory
WHERE 
	product_id = 1;

-- p_order_id INT,
-- p_customer_id INT,
-- p_seller_id INT,
-- p_order_item_id INT,
-- p_product_id INT,
-- p_quantity INT

CALL add_sales
(
25045, 2, 5, 25504, 1, 11
);

-------------------------
/*
Scenario: Automating Inventory Adjustment Based on Returns
Problem:
When a product is returned, automatically update the inventory by adding the returned quantity back to the stock.
*/

CREATE OR REPLACE PROCEDURE update_inventory_on_return(
    p_order_id INT,
    p_product_id INT,
    p_quantity_returned INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if the product exists in the inventory
    IF EXISTS (SELECT 1 FROM inventory WHERE product_id = p_product_id) THEN
        -- Update inventory stock
        UPDATE inventory
        SET stock = stock + p_quantity_returned
        WHERE product_id = p_product_id;

        RAISE NOTICE 'Inventory updated: Product ID % returned with quantity %', 
            p_product_id, p_quantity_returned;
    ELSE
        RAISE NOTICE 'Product ID % does not exist in inventory.', p_product_id;
    END IF;
END;
$$

CALL update_inventory_on_return(2505, 1, 10);


/*Scenario: Revenue Forecast for Next Quarter
Problem:
Calculate the projected revenue for the next quarter based on the average monthly revenue in the last quarter.
*/
WITH LastQuarterRevenue AS (
    SELECT 
        EXTRACT(MONTH FROM o.order_date) AS month,
        SUM(oi.quantity * oi.price_per_unit) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_date >= (CURRENT_DATE - INTERVAL '3 MONTH')
    GROUP BY EXTRACT(MONTH FROM o.order_date)
),
ProjectedRevenue AS (
    SELECT 
        ROUND(AVG(monthly_revenue)::numeric, 2) * 3 AS projected_revenue
    FROM LastQuarterRevenue
)
SELECT 
    projected_revenue
FROM ProjectedRevenue;


/*
1. Dynamic Pricing Adjustment Based on Sales Performance
Problem:
Automatically adjust product prices at the end of each month based on sales performance:

Increase the price by 10% for products with more than 500 units sold.
Decrease the price by 5% for products with less than 100 units sold.
Maintain current pricing for other products.

*/

CREATE OR REPLACE PROCEDURE adjust_pricing_based_on_sales()
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_id INT;
    v_total_units_sold INT;
BEGIN
    FOR v_product_id, v_total_units_sold IN
        SELECT 
            p.product_id, 
            SUM(oi.quantity) AS total_units_sold
        FROM products p
        JOIN order_items oi ON p.product_id = oi.product_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE EXTRACT(MONTH FROM o.order_date) = EXTRACT(MONTH FROM CURRENT_DATE) - 1
        GROUP BY p.product_id
    LOOP
        -- Adjust prices based on sales performance
        IF v_total_units_sold >= 4 THEN
            UPDATE products
            SET price = price * 1.10
            WHERE product_id = v_product_id;
            RAISE NOTICE 'Increased price by 10%% for Product ID % due to high sales (% units sold).', v_product_id, v_total_units_sold;

        ELSIF v_total_units_sold < 4 THEN
            UPDATE products
            SET price = price * 0.95
            WHERE product_id = v_product_id;
            RAISE NOTICE 'Decreased price by 5%% for Product ID % due to low sales (% units sold).', v_product_id, v_total_units_sold;
        ELSE
            RAISE NOTICE 'Price unchanged for Product ID % (% units sold).', v_product_id, v_total_units_sold;
        END IF;
    END LOOP;
END;
$$;

-- Call the procedure
CALL adjust_pricing_based_on_sales();


/*
3. Automating Monthly Profit Analysis
Problem:
Calculate the monthly profit for each product by subtracting the cost of goods sold (COGS) from the total sales and insert the results into a monthly_profit table.
*/


CREATE TABLE monthly_profit (
    product_id INT,
    product_name VARCHAR(100),
    total_revenue NUMERIC,
    total_cogs NUMERIC,
    profit NUMERIC,
    month DATE
);

CREATE OR REPLACE PROCEDURE calculate_monthly_profit(p_month INT, p_year INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_id INT;
    v_product_name VARCHAR(100);
    v_total_revenue NUMERIC;
    v_total_cogs NUMERIC;
    v_profit NUMERIC;
BEGIN
    FOR v_product_id, v_product_name, v_total_revenue, v_total_cogs IN
        SELECT 
            p.product_id,
            p.product_name,
            SUM(oi.quantity * oi.price_per_unit) AS total_revenue,
            SUM(oi.quantity * p.cogs) AS total_cogs
        FROM products p
        JOIN order_items oi ON p.product_id = oi.product_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE EXTRACT(MONTH FROM o.order_date) = p_month
          AND EXTRACT(YEAR FROM o.order_date) = p_year
        GROUP BY p.product_id, p.product_name
    LOOP
        -- Calculate profit
        v_profit := v_total_revenue - v_total_cogs;

        -- Insert into monthly_profit table
        INSERT INTO monthly_profit (product_id, product_name, total_revenue, total_cogs, profit, month)
        VALUES (v_product_id, v_product_name, v_total_revenue, v_total_cogs, v_profit, MAKE_DATE(p_year, p_month, 1));

        RAISE NOTICE 'Profit calculated for Product ID % (%: Revenue = %, COGS = %, Profit = %).', 
            v_product_id, v_product_name, v_total_revenue, v_total_cogs, v_profit;
    END LOOP;
END;
$$;

CALL calculate_monthly_profit(8, 2023); -- For August 2023


SELECT * FROM monthly_profit;


/*3. Generate Quarterly Sales Report
Problem:
Generate a quarterly sales report for each seller, summarizing total revenue, total orders, and top-selling product.
*/
CREATE TABLE quarterly_sales_report (
    report_id SERIAL PRIMARY KEY,
    seller_id INT,
    seller_name VARCHAR(100),
    total_revenue NUMERIC,
    total_orders INT,
    top_product_id INT,
    top_product_name VARCHAR(100),
    report_quarter INT,
    report_year INT,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE generate_quarterly_sales_report(p_quarter INT, p_year INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_seller_id INT;
    v_seller_name VARCHAR(100);
    v_total_revenue NUMERIC;
    v_total_orders INT;
    v_top_product_id INT;
    v_top_product_name VARCHAR(100);
BEGIN
    FOR v_seller_id, v_seller_name IN
        SELECT seller_id, seller_name
        FROM sellers
    LOOP
        -- Calculate total revenue and orders
        SELECT 
            COALESCE(SUM(oi.quantity * oi.price_per_unit), 0) AS total_revenue,
            COALESCE(COUNT(DISTINCT o.order_id), 0) AS total_orders
        INTO v_total_revenue, v_total_orders
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.seller_id = v_seller_id
          AND EXTRACT(QUARTER FROM o.order_date) = p_quarter
          AND EXTRACT(YEAR FROM o.order_date) = p_year;

        -- Identify top-selling product
        SELECT 
            COALESCE(oi.product_id, NULL),
            COALESCE(p.product_name, 'N/A')
        INTO v_top_product_id, v_top_product_name
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        WHERE EXISTS (
            SELECT 1
            FROM orders o
            WHERE o.order_id = oi.order_id
              AND o.seller_id = v_seller_id
              AND EXTRACT(QUARTER FROM o.order_date) = p_quarter
              AND EXTRACT(YEAR FROM o.order_date) = p_year
        )
        GROUP BY oi.product_id, p.product_name
        ORDER BY SUM(oi.quantity) DESC
        LIMIT 1;

        -- Insert the report into the quarterly_sales_report table
        INSERT INTO quarterly_sales_report (
            seller_id, seller_name, total_revenue, total_orders, 
            top_product_id, top_product_name, report_quarter, report_year
        )
        VALUES (
            v_seller_id, v_seller_name, v_total_revenue, v_total_orders,
            v_top_product_id, v_top_product_name, p_quarter, p_year
        );

        -- Optional: Log the report
        RAISE NOTICE 'Seller: % | Revenue: % | Orders: % | Top Product: % (%).', 
            v_seller_name, v_total_revenue, v_total_orders, v_top_product_name, v_top_product_id;
    END LOOP;
END;
$$;

CALL generate_quarterly_sales_report(3, 2023);
SELECT * 
FROM quarterly_sales_report;