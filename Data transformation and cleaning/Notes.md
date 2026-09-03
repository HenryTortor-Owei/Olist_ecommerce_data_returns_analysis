## Dataset details

### --olist_customers_dataset.csv--
(99441, 5)
['customer_id', 'customer_unique_id', 'customer_zip_code_prefix', 'customer_city', 'customer_state']

### --olist_geolocation_dataset.csv--
(1000163, 5)
['geolocation_zip_code_prefix', 'geolocation_lat', 'geolocation_lng', 'geolocation_city', 'geolocation_state']

### --olist_orders_dataset.csv--
(99441, 8)
['order_id', 'customer_id', 'order_status', 'order_purchase_timestamp', 'order_approved_at', 'order_delivered_carrier_date', 'order_delivered_customer_date', 'order_estimated_delivery_date']

### --olist_order_items_dataset.csv--
(112650, 7)
['order_id', 'order_item_id', 'product_id', 'seller_id', 'shipping_limit_date', 'price', 'freight_value']

### --olist_order_payments_dataset.csv--
(103886, 5)
['order_id', 'payment_sequential', 'payment_type', 'payment_installments', 'payment_value']

### --olist_order_reviews_dataset.csv--
(99224, 7)
['review_id', 'order_id', 'review_score', 'review_comment_title', 'review_comment_message', 'review_creation_date', 'review_answer_timestamp']

### --olist_products_dataset.csv--
(32951, 9)
['product_id', 'product_category_name', 'product_name_lenght', 'product_description_lenght', 'product_photos_qty', 'product_weight_g', 'product_length_cm', 'product_height_cm', 'product_width_cm']

### --olist_sellers_dataset.csv--
(3095, 4)
['seller_id', 'seller_zip_code_prefix', 'seller_city', 'seller_state']

### --product_category_name_translation.csv--
(71, 2)

Normal cleaning steps
Nulls
Duplicates
Unique values - Logical errors (use info)
Outliers (describe)
Summary stats (describe)
Blank spaces
Standardize data types


Feature Engineering
Orders dataset:
-- order_purchase_timestamp - Date, time of day
-- order_approved_at - Date, time of day
-- order_estimated_delivery_date - Date, time of day
-- order_delivered_carrier_date - Date, time of day
-- order_delivered_customer_date - Date, time of day

Order items
-- shipping_limit_date - Date, time of day

olist_order_reviews_dataset
-- review_comment_title - Translate
-- review_comment_message - Translate
-- review_creation_date - Extract Date
-- review_answer_timestamp - Extract Date

Products Dataset
-- product_category_name - Translate, use table (JOIN)
-- Columns - lenght to length **

## Value counts
### Customer
-- Customer city
-- Customer state

### geolocation
-- geolocation city
-- geolocation state

order
order_status

order items

payment
payment type

review

products
product_category_name


seller
seller city
seller state





Data types
customer
ids - num

geolocation
ids- num

orders
order id, customer id - num

order items
order id, product id, seller id - num

payments
order_id



Cleaning steps:
Check for nulls - Done
Handle -
Check for duplicates -   Done
Handle - Done / None
Use appropriate datetime data type

create date column in:

Orders table
-- order_purchase_timestamp - Date, time of day
-- order_approved_at - Date, time of day
-- order_estimated_delivery_date - Date, time of day
-- order_delivered_carrier_date - Date, time of day
-- order_delivered_customer_date

olist_order_items
-- shipping_limit_date - Date, time of day


Reviews
-- review_creation_date --
-- review_answer_timestamp --

nulls
-- olist_orders_dataset --
order_delivered_customer_date    2965
order_delivered_carrier_date     1783
order_approved_at                 160

Impute all - Unknown date

-- olist_order_reviews_dataset --
review_comment_title      87656
review_comment_message    58247
dtype: int64

Impute all
No title
No message

