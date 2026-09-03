
-- For location, we want to see if there are any cities, states where cancellations are higher

Select * from customers;

-- Starting with state
SELECT
    c.customer_state,
    COUNT(DISTINCT oo.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN oo.order_status = 'canceled' THEN oo.order_id
    END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN oo.order_status = 'canceled' THEN oo.order_id
        END) * 100.0 / COUNT(DISTINCT oo.order_id),
        2
    ) AS cancellation_rate
FROM orders oo
JOIN customers c
    ON oo.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY cancellation_rate DESC;

-- It is clear that SP (presumably Sao Paulo) and RJ (Presumably Rio de janeiro) 
-- have a higher cancellation rate than the average
-- Cancel volume is high too so its a legitimate pattern

-- For customer_city

SELECT
    c.customer_city,
    COUNT(DISTINCT oo.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN oo.order_status = 'canceled' THEN oo.order_id
    END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN oo.order_status = 'canceled' THEN oo.order_id
        END) * 100.0 / COUNT(DISTINCT oo.order_id),
        2
    ) AS cancellation_rate
FROM orders oo
JOIN customers c
    ON oo.customer_id = c.customer_id
GROUP BY c.customer_city
HAVING COUNT(DISTINCT oo.order_id) >= 100 and canceled_orders > 10
ORDER BY cancellation_rate DESC;

-- For customer cities, Heres our top 5 when we filter out the noise:

-- guarulhos
-- sao paulo
-- campinas
-- rio de janeiro

-- This confirms the state level analysis for sao paulo and rio