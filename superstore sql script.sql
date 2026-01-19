-- Overall Business Performance
SELECT COUNT(DISTINCT order_id) as total_orders,COUNT(DISTINCT customer_id) as total_customers,
COUNT(DISTINCT product_id) as total_products,ROUND(SUM(sales), 2) as total_revenue,
ROUND(SUM(profit), 2) as total_profit,
ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin_percent
FROM orders;

-- Performance by Category
SELECT category,ROUND(SUM(sales), 2) as total_sales,ROUND(SUM(profit), 2) as total_profit,
SUM(quantity) as total_quantity, COUNT(DISTINCT order_id) as order_count,
ROUND(AVG(discount) * 100, 2) as avg_discount_percent,
ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin
FROM orders
GROUP BY category
ORDER BY total_sales DESC;

-- Top 10 Sub-Categories by Profit
SELECT sub_category,category,ROUND(SUM(sales), 2) as total_sales,
ROUND(SUM(profit), 2) as total_profit,SUM(quantity) as units_sold,
ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin
FROM orders
GROUP BY sub_category, category
ORDER BY total_profit DESC
LIMIT 10;

-- Sales Performance by Region
SELECT region, ROUND(SUM(sales), 2) as total_sales, ROUND(SUM(profit), 2) as total_profit,
COUNT(DISTINCT customer_id) as unique_customers,COUNT(DISTINCT order_id) as total_orders,
ROUND(AVG(sales), 2) as avg_order_value,ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- Top States
SELECT state,region,COUNT(DISTINCT order_id) as order_count,
ROUND(SUM(sales), 2) as total_sales,
ROUND(SUM(profit), 2) as total_profit,
ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin
FROM orders
GROUP BY state, region
ORDER BY total_sales DESC
LIMIT 10;

-- Monthly Sales Trend
SELECT DATE_FORMAT(order_date, '%Y-%m') as month,ROUND(SUM(sales), 2) as monthly_sales,
ROUND(SUM(profit), 2) as monthly_profit,
COUNT(DISTINCT order_id) as order_count,
COUNT(DISTINCT customer_id) as unique_customers
FROM orders
GROUP BY month
ORDER BY month;

-- Yearly Comparison
SELECT YEAR(order_date) as year,ROUND(SUM(sales), 2) as yearly_sales,
ROUND(SUM(profit), 2) as yearly_profit,COUNT(DISTINCT order_id) as order_count,
COUNT(DISTINCT customer_id) as customer_count
FROM orders
GROUP BY year
ORDER BY year;

-- Performance by Customer Segment
SELECT 
    segment,
    COUNT(DISTINCT customer_id) as customer_count,
    COUNT(DISTINCT order_id) as total_orders,
    ROUND(SUM(sales), 2) as total_sales,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(AVG(sales), 2) as avg_order_value,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_margin
FROM orders
GROUP BY segment
ORDER BY total_sales DESC;

-- Top Customers by Sales
SELECT customer_name,customer_id,segment,
COUNT(DISTINCT order_id) as order_count,
ROUND(SUM(sales), 2) as total_sales,
ROUND(SUM(profit), 2) as total_profit,
ROUND(AVG(sales), 2) as avg_order_value
FROM orders
GROUP BY customer_id, customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 Products by Profit
SELECT product_name,category,sub_category,
COUNT(DISTINCT order_id) as times_ordered,
SUM(quantity) as total_quantity_sold,
ROUND(SUM(sales), 2) as total_sales,
ROUND(SUM(profit), 2) as total_profit,
ROUND(AVG(discount) * 100, 2) as avg_discount
FROM orders
GROUP BY product_name, category, sub_category
ORDER BY total_profit DESC
LIMIT 10;

-- AOV by Customer Segment and Category
SELECT segment,category,
COUNT(DISTINCT order_id) as order_count,
ROUND(AVG(sales), 2) as avg_order_value,
ROUND(SUM(sales), 2) as total_sales
FROM orders
GROUP BY segment, category
ORDER BY segment, total_sales DESC;

-- Top 10 Products with Biggest Losses
SELECT product_name, category, sub_category, COUNT(*) as loss_order_count,
SUM(quantity) as total_quantity,
ROUND(SUM(sales), 2) as total_sales,
ROUND(SUM(profit), 2) as total_loss
FROM orders
WHERE profit < 0
GROUP BY product_name, category, sub_category
ORDER BY total_loss ASC
LIMIT 10;

-- Customer Segmentation by Purchase Frequency
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-time Buyer'
        WHEN order_count BETWEEN 2 AND 5 THEN 'Occasional (2-5)'
        WHEN order_count BETWEEN 6 AND 10 THEN 'Regular (6-10)'
        ELSE 'Frequent (11+)'
    END as customer_type,
    COUNT(*) as number_of_customers,
    ROUND(SUM(total_sales), 2) as revenue,
    ROUND(AVG(total_sales), 2) as avg_customer_value
FROM (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) as order_count,
        SUM(sales) as total_sales
    FROM orders
    GROUP BY customer_id
) as customer_summary
GROUP BY customer_type
ORDER BY revenue DESC;