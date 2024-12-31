# 📚 Amazon Sales Intelligence: From EDA to Business Solutions

<div style="text-align: center;">
    <img src="logo.jpg" alt="alt text" width="600" height="130">
</div>


## 🚀 Project Overview
This project focuses on performing an **Exploratory Data Analysis (EDA)** and solving **critical business problems** using a dataset of **50,000+ rows**. By analyzing the data from various interconnected tables, I aim to uncover insights, detect anomalies, and provide actionable solutions to optimize business processes for Amazon's operations. 🛒

---

<div style="text-align: center;">
    <img src="Amazon Sales Dashboard.jpg" alt="alt text" >
</div>

👉 **[Explore the Dashboard Here](https://app.powerbi.com/view?r=eyJrIjoiYWQyMGE4YWYtOTI3MS00NmZkLWI1NmMtNTdmN2ExNDczYzJlIiwidCI6ImE4ZWVjMjgxLWFhYTMtNGRhZS1hYzliLTlhMzk4YjkyMTVlNyIsImMiOjN9&pageName=dca30f971ee5444d21a2)**
---

## 🛠️ Technologies Used
- **PostgreSQL**: Used for database querying and analysis.
- **SQL**: Wrote advanced queries for data exploration and problem-solving.
- **Power Query**: ETL (Extract, Transform, Load) for Power BI integration and new measures calculation.
- **Power BI 📊**: Interactive dashboards for data visualization and reporting.
---

## 💡 What Makes This Project Unique?
- **Real-World Problems**: Tackles realistic challenges faced in large-scale e-commerce operations.
- **Scalable Dataset**: Demonstrates the ability to handle large datasets effectively.
- **Actionable Insights**: Provides data-driven recommendations to optimize key business processes.
- **Interactive Dashboard**: Features an attractive and interactive dashboard design, making it easier to demonstrate and explore insights efficiently.
- **Detailed Power BI Analysis**: Connected all SQL queries to Power BI and designed a **6-page interactive dashboard**:
  1. **Overview**: Highlights key metrics like total revenue, sales, profit, and trends.
  2. **Sales**: Focuses on trends, target vs. actual sales, and category contribution.
  3. **Customer**: Analyzes customer behavior, retention, and segmentation.
  4. **Product**: Details product performance, profit margins, and return percentages.
  5. **Logistics**: Provides insights into shipping delays, inventory, and delivery metrics.
  6. **Insights**: Consolidates high-level metrics like successful orders, inactive sellers, and payment breakdowns.

---

## 🔑 Objectives

### 🎯 Primary Goals:
1. **Data Exploration**: Understand the structure and relationships of data across multiple tables.
2. **Data Quality Checks**: Ensure data consistency, accuracy, and completeness.
3. **Insight Generation**: Extract key metrics like revenue, profit, sales trends, and customer behavior.
4. **Problem-Solving**: Solve critical business issues through SQL-based analysis.

---


## 💼 Business Problems Solved

### 🔍 1. Data Overview & Quality Checks 🧹
- Explored all tables to understand their structure and content.
- Checked for **missing values**, **duplicate primary keys**, and **foreign key mismatches**.
- Ensured data integrity across interconnected tables.

### 📦 2. Inventory Management 🚛
- **Problem**: Real-time stock updates after sales and returns.
  - Automated stock reduction in the inventory after a sale.
  - Automated inventory updates when products are returned.

### 💰 3. Revenue Forecasting 📈
- **Problem**: Predict next quarter's revenue based on historical trends.
  - Calculated average monthly revenue from the previous quarter.
  - Projected revenue for the next quarter.

### 🛒 4. Dynamic Pricing Adjustments 💸
- **Problem**: Optimize pricing based on sales performance.
  - Increased prices by **10%** for products with high demand (>500 units sold).
  - Reduced prices by **5%** for slow-moving products (<100 units sold).

### 📊 5. Profit Analysis 💹
- **Problem**: Monthly profit tracking for each product.
  - Automated monthly profit calculations (sales revenue - COGS).
  - Stored results in a dedicated `monthly_profit` table.

### 📝 6. Comprehensive Sales Reporting 📃
- **Problem**: Generate detailed sales reports.
  - Quarterly sales report for each seller, summarizing:
    - **Total Revenue**
    - **Total Orders**
    - **Top-Selling Products**

### 🧐 7. Anomaly Detection 🚨
- Detected products with unusually high or low prices (outliers).
- Identified orders with missing shipping or payment information.

### 📈 8. Trend Analysis 📆
- Analyzed **monthly sales trends** and **state-wise customer distribution**.
- Detected changes in customer behavior and sales growth over time.

### 🤝 9. Customer Insights 👤
- Segmented customers into **Returning** and **New** based on return frequencies.
- Analyzed top customers in each state and their total spend.
- Suggested **cross-sell opportunities** (e.g., customers who purchased Product A but not Product B).

---


## 📊 Dataset Details
The dataset consists of 50,000+ rows spread across multiple tables:

- **`Category`**: Contains details about product categories.
- **`Customers`**: Information about Amazon's customers, including names, states, and addresses.
- **`Sellers`**: Data about sellers and their origin.
- **`Products`**: Product details, including price, cost, and category.
- **`Orders`**: Records of customer orders with dates and statuses.
- **`Order_items`**: Information on products ordered, quantities, and prices.
- **`Payments`**: Payment statuses and details for each order.
- **`Shipping`**: Shipping details, including providers and delivery status.
- **`Inventory`**: Stock details for each product and warehouse information.

---

## ⚙️ Steps Followed

### 🛠️ Exploratory Data Analysis (EDA):
1. **Data Overview**: Displayed all records and key statistics for initial understanding.
2. **Data Quality Checks**: Validated data consistency and resolved anomalies.
3. **Descriptive Statistics**: Computed metrics like average price, order quantity, and revenue.
4. **Relationship Exploration**: Explored key relationships between tables (e.g., customers, orders, and products).
5. **Trend Analysis**: Analyzed trends over time, monthly revenue, and customer segmentation.
6. **Anomalies and Outliers**: Detected and flagged unusual data points.
7. **Visualization Preparation**: Prepared summarized data for graphical representation.

---

## 🚀 Key Highlights

- 📂 **Dataset Scale**: Analyzed over **50,000+ rows** across multiple interconnected tables.
- 🧮 **Complex Queries**: Wrote advanced SQL queries involving joins, subqueries, and window functions.
- 🔄 **Automation**: Automated inventory updates for sales and returns.
- 📈 **Insights Delivered**: Provided actionable business insights for revenue growth, pricing strategies, and customer retention.
- 🛠️ **Problem-Solving**: Addressed real-world business problems, improving operational efficiency.

---

## 📌 Future Scope

- **Advanced Machine Learning**: Build predictive models for sales forecasting and customer segmentation.
- **Deeper Analysis**: Explore additional dimensions like regional sales performance or seasonality.

---

