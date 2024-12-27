-- Amazon Project Advanced SQL
-- IMPORTING THE TABLES
-- 1.category table

CREATE TABLE Category(
category_id INT PRIMARY KEY,
category_name VARCHAR(20)
);

-- 2.CUSTOMER TABLE
CREATE TABLE Customers(
customer_id INT PRIMARY KEY,
f_name VARCHAR(20),
l_name VARCHAR(20),
state VARCHAR(20),
address VARCHAR(10) DEFAULT ('xxxxxxxxxx')
);

-- 3.SELLER TABLE
CREATE TABLE Sellers(
seller_id INT PRIMARY KEY,
seller_name VARCHAR(25),
origin VARCHAR(10)
);

-- 4.PRODUCTS TABLE
CREATE TABLE Products(
product_id INT PRIMARY KEY,
product_name VARCHAR(60),
price FLOAT,
cogs FLOAT,
category_id INT,
CONSTRAINT product_fk_category FOREIGN KEY(category_id) REFERENCES Category(category_id)
);


-- 5.ORDERS TABLE
CREATE TABLE Orders(
order_id INT PRIMARY KEY,
order_date DATE,
customer_id INT, --foreign key
CONSTRAINT orders_fk_customer FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),
seller_id INT, --foreign key
CONSTRAINT orders_fk_seller FOREIGN KEY(seller_id) REFERENCES Sellers(seller_id),
order_status VARCHAR(15)
);

--6. ORDER ITEM TABLE
CREATE TABLE Order_items(
order_item_id INT PRIMARY KEY,
order_id INT, --foreign key
CONSTRAINT orderitem_fk_orders FOREIGN KEY(order_id) REFERENCES Orders(order_id),
product_id INT, --foreign key
CONSTRAINT orderitem_fk_products FOREIGN KEY(product_id) REFERENCES Products(product_id),
quantity INT,
price_per_unit FLOAT
);

--7.PAYMENT TABLE
CREATE TABLE Payments(
payment_id INT PRIMARY KEY,
order_id INT,
CONSTRAINT payments_fk_orders FOREIGN KEY(order_id) REFERENCES Orders(order_id),
payment_date DATE,
payment_status VARCHAR(20)
);

--8.SHIPPING TABLE
CREATE TABLE Shipping(
shipping_id INT PRIMARY KEY,
order_id INT,
CONSTRAINT shipping_fk_orders FOREIGN KEY(order_id) REFERENCES Orders(order_id),
shipping_date DATE,
return_date DATE,
shipping_providers VARCHAR(20),
delivery_status VARCHAR(20)
);

-- 9.INVENTORY TABLE
CREATE TABLE Inventory(
inventory_id INT PRIMARY KEY,
product_id INT,
CONSTRAINT inventory_fk_products FOREIGN KEY(product_id) REFERENCES Products(product_id),
stock INT,
warehouse_id INT,
last_stock_date DATE
);

-- EVERY TABLE IS CREATED SUCCESSFULLY AND IMPORTED THE DATA FROM EXCEL AS WELL