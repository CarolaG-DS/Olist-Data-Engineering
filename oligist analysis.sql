SELECT * FROM olist_orders_dataset -- selects all columns from orders datasets
LIMIT 10;
PRAGMA table_info(olist_orders_dataset); --tells us the structure: columns and type of data, e.g. number or text
SELECT 
    order_id,
    order_status,
    date(order_purchase_timestamp) AS purchase_date, --change that columns in date
    date(order_delivered_customer_date) AS delivery_date --as creates the alias, i.e. nicknames
FROM olist_orders_dataset
LIMIT 20;
SELECT 
    order_id,
    date(order_purchase_timestamp) AS purchase_date,
    date(order_delivered_customer_date) AS delivery_date,
    julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS delivery_days --transform the date into decimal writing a formula
FROM olist_orders_dataset
WHERE order_status = 'delivered' --filter, only takes the order that have been delivered
LIMIT 20;
SELECT 
    orders.order_id, -- tables-dataset.column format
    orders.order_status,
    items.product_id,
    items.price,
    julianday(orders.order_delivered_customer_date) - julianday(orders.order_purchase_timestamp) AS delivery_days
FROM olist_orders_dataset AS orders
JOIN olist_order_items_dataset AS items 
    ON orders.order_id = items.order_id --join on the same variable
WHERE orders.order_status = 'delivered'
ORDER BY delivery_days DESC
LIMIT 20;
SELECT 
    orders.order_id,
    customers.customer_city,
    customers.customer_state,
    julianday(orders.order_delivered_customer_date) - julianday(orders.order_purchase_timestamp) AS delivery_days
FROM olist_orders_dataset AS orders
JOIN olist_order_items_dataset AS items 
    ON orders.order_id = items.order_id
JOIN olist_customers_dataset AS customers 
    ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
ORDER BY delivery_days DESC
LIMIT 20;
SELECT 
    customers.customer_state,
    ROUND(AVG(julianday(orders.order_delivered_customer_date) - julianday(orders.order_purchase_timestamp)), 2) AS avg_delivery_time, --avg does the mean
    COUNT(orders.order_id) AS total_orders --count how many orders have been done in a state
FROM olist_orders_dataset AS orders
JOIN olist_customers_dataset AS customers 
    ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_state --groups by puts all the costumers ofthe same state in one group and it calculates the mean
ORDER BY avg_delivery_time DESC; --order the dataset by descending delivery time, from the states that waited longer to those what waited less
SELECT 
    customers.customer_state,
    ROUND(SUM(items.price), 2) AS total_revenue, --to calculate the total sales foreach state
    COUNT(DISTINCT orders.order_id) AS unique_orders --if a client buy e.g. 3 items in 1 order, this 3 items would be named the samed and COUNT woukd count them 3 times, DISTINCT count them once
FROM olist_orders_dataset AS orders
JOIN olist_order_items_dataset AS items 
    ON orders.order_id = items.order_id
JOIN olist_customers_dataset AS customers 
    ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_state
ORDER BY total_revenue DESC;

--missing values analysis
SELECT 
    order_status, 
    COUNT(order_id) AS missing_deliveries --gives us total number of order for each state , in this case that have not been delivered
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NULL --if null it means costumer never received the item
GROUP BY order_status
ORDER BY missing_deliveries DESC;

SELECT 
    order_status, 
    COUNT(order_id) AS missing_deliveries
FROM olist_orders_dataset
WHERE order_delivered_customer_date = '' OR order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY missing_deliveries DESC;

CREATE VIEW orders_clean AS --this saves a formula, not crete a new table that occupy space 
SELECT 
    order_id,
    customer_id,
    order_status,
    date(order_purchase_timestamp) AS purchase_date,
    date(order_delivered_customer_date) AS delivery_date,
    julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date != ''; --NOT INCLUDE those items that say DELIVERED but the date is missing 


  
  
  
  
  SELECT * FROM orders_clean 
LIMIT 10;

SELECT customer_id, delivery_days
FROM orders_clean
ORDER BY delivery_days DESC
LIMIT 5;