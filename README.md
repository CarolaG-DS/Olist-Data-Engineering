### Olist E-commerce: SQL Data Engineering

### Project Objective
The objective of this project is to transform a raw Brazilian marketplace dataset (CSV) into a structured and optimized SQL database. The primary focus is on data cleaning and the development of logistical metrics, such as delivery lead times, to support data-driven business decisions.

### Tech Stack
* **Database:** SQLite
* **Management Tool:** DBeaver
* **Language:** SQL (DDL, DQL)

### ETL Process (Extract, Transform, Load)

#### 1. Extraction
Data was imported from raw CSV files. During the ingestion phase, a data type anomaly was identified: timestamps were imported as `NVARCHAR` (text), which prevented direct temporal mathematical operations.

### 2. Transformation
This phase represented the core data engineering effort:
* **Date Standardization:** Converted string-based timestamps into proper `DATE` objects using the `date()` function.
* **Performance Metrics:** Developed a `delivery_days` metric using `julianday()` to calculate the precise interval between purchase and customer delivery.
* **Data Quality:** * Identified and removed inconsistent records (orders marked as 'delivered' but lacking a physical delivery date).
    * Handled missing values by differentiating between `NULL` entries and empty strings (`''`).
* **Aggregations:** Calculated total revenue by state and unique order counts to identify market leaders.

### 3. Loading
To automate and streamline access to processed data, a **Database View** named `orders_clean` was implemented. This view allows for direct querying of filtered and calculated data, eliminating the need to rewrite cleaning logic for future analyses.

## Code Structure (SQL View)
```sql
CREATE VIEW orders_clean AS
SELECT 
    order_id,
    customer_id,
    order_status,
    date(order_purchase_timestamp) AS purchase_date,
    date(order_delivered_customer_date) AS delivery_date,
    julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date != '';