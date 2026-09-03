select * from payments;
select payment_type, count(*) from payments
group by payment_type;

select * from payments
order by payment_sequential desc;

select count(distinct(order_id)) from payments;
-- group by order_id;

select count(*) from orders;

select * from order_items;
select * from products;


-- What effect does payments have on cancellation/returns?

-- Paymet methods?
-- Installments?
-- Do an installment count for return, analyse relationships

-- What orders that were cancelled cost the most?

SELECT
    payment_type,
    COUNT(DISTINCT op.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN oo.order_status = 'canceled' THEN op.order_id END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN oo.order_status = 'canceled' THEN op.order_id END)
        * 100.0 / COUNT(DISTINCT op.order_id),
        2
    ) AS cancellation_rate
FROM payments op
JOIN orders oo
    ON op.order_id = oo.order_id
GROUP BY payment_type
ORDER BY cancellation_rate DESC;

-- Vouchers seems to have a relaivley high cancellation rate
-- The rest are around average

SELECT
    payment_installments,
    COUNT(DISTINCT op.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN oo.order_status = 'canceled' THEN op.order_id END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN oo.order_status = 'canceled' THEN op.order_id END)
        * 100.0 / COUNT(DISTINCT op.order_id),
        2
    ) AS cancellation_rate
FROM payments op
JOIN orders oo
    ON op.order_id = oo.order_id
GROUP BY payment_installments
ORDER BY payment_installments;

-- No strong relationship

-- Payment sequential (number of payment methods used)

WITH order_payment_count AS (
    SELECT
        order_id,
        COUNT(*) AS payment_count
    FROM payments
    GROUP BY order_id
)

SELECT
    opc.payment_count,
    COUNT(*) AS total_orders,
    SUM(oo.order_status = 'canceled') AS canceled_orders,
    ROUND(
        SUM(oo.order_status = 'canceled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM order_payment_count opc
JOIN orders oo
    ON opc.order_id = oo.order_id
GROUP BY opc.payment_count
ORDER BY opc.payment_count;

-- No strong relationship. Most had only one payment type used

-- On price

SELECT
    pp.product_category_name,
    COUNT(*) AS canceled_items,
    ROUND(SUM(oi.price), 2) AS canceled_product_value,
    ROUND(AVG(oi.price), 2) AS avg_product_price
FROM order_items oi
JOIN products pp ON oi.product_id = pp.product_id
JOIN orders oo ON oi.order_id = oo.order_id
WHERE oo.order_status = 'canceled'
GROUP BY pp.product_category_name
ORDER BY canceled_product_value DESC;


-- Top 5 in terms of item value:
-- cool_stuff
-- esporte_lazer
-- informatica_acessorios
-- relogios_presentes
-- automotivo

-- item price and cancellation
SELECT
    CASE
        WHEN oi.price < 50 THEN 'Under 50'
        WHEN oi.price < 100 THEN '50-99'
        WHEN oi.price < 250 THEN '100-249'
        WHEN oi.price < 500 THEN '250-499'
        ELSE '500+'
    END AS price_band,
    COUNT(*) AS total_items,
    SUM(oo.order_status = 'canceled') AS canceled_items,
    ROUND(
        SUM(oo.order_status = 'canceled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM order_items oi
JOIN orders oo ON oi.order_id = oo.order_id
GROUP BY price_band
ORDER BY MIN(oi.price);

-- Items priced 250 - 499 and 500+ items have higher cancellation rates than usual

-- freight cost and calculation
SELECT
    CASE
        WHEN oi.freight_value < 10 THEN 'Under 10'
        WHEN oi.freight_value < 25 THEN '10-24'
        WHEN oi.freight_value < 50 THEN '25-49'
        WHEN oi.freight_value < 100 THEN '50-99'
        ELSE '100+'
    END AS freight_band,
    COUNT(*) AS total_items,
    SUM(oo.order_status = 'canceled') AS canceled_items,
    ROUND(
        SUM(oo.order_status = 'canceled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM order_items oi
JOIN orders oo ON oi.order_id = oo.order_id
GROUP BY freight_band
ORDER BY MIN(oi.freight_value);

-- Items under 10 and 100+ have cancellation rates more than the average

git remote add origin https://github.com/HenryTortor-Owei/Olist_ecommerce_data_returns_analysis.git