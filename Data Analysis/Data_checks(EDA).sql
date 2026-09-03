Use olist;

drop database olist;
SELECT "customer", COUNT(*) Value_count FROM customers
UNION ALL
SELECT "order_items", COUNT(*) FROM order_items
UNION ALL
SELECT "order_payments", COUNT(*) FROM payment
UNION ALL
SELECT "orders", COUNT(*) FROM orders
UNION ALL
SELECT "sellers", COUNT(*) FROM sellers
ORDER BY 2 DESC;

-- SELECT count(customer_id),count(customer_unique_id) FROM orders;

-- SELECT * from customers;
SELECT * FROM reviews;
select * from customers;
-- select * from geolocation
select * from products;
select * from orders;

select * from order_items;
-- group by order_id
-- order by 2 desc;

-- Working with orders --
select order_status, count(*) count, count(*)* 100 / sum(count(*)) over() order_perc_per_year, year(order_purchase_timestamp)  year1
from orders
group by order_status, year(order_purchase_timestamp)
order by 4 desc;












