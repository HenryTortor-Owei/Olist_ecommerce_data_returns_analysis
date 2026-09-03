-- Sellers

select count(*) sellers_count from sellers;
select count(*) from order_items;

-- Here, we use order_items and orders
-- since order items has seller_id
SELECT
    oi.seller_id,
    SUM(oo.order_status = 'canceled') AS cancellation_count,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(oo.order_status = 'canceled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM order_items oi
JOIN orders oo
    ON oi.order_id = oo.order_id
GROUP BY oi.seller_id
HAVING COUNT(*) >= 100
ORDER BY cancellation_rate DESC
limit 20;

-- There are, in fact sellers with high cancellation rates
-- But the question is, is it attributed to them as sellers?
-- Or to the products they sell?


WITH top_sellers AS (
    SELECT
        oi.seller_id,
        ROUND(
            SUM(oo.order_status = 'canceled') * 100.0 / COUNT(*),
            2
        ) AS seller_cancellation_rate
    FROM order_items oi
    JOIN orders oo
        ON oi.order_id = oo.order_id
    GROUP BY oi.seller_id
    HAVING COUNT(*) >= 100
    ORDER BY seller_cancellation_rate DESC
    LIMIT 20
)

SELECT
    ts.seller_id,
    seller_name,
    pp.product_category_name,
    SUM(oo.order_status = 'canceled') AS cancellation_count,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(oo.order_status = 'canceled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM top_sellers ts
JOIN order_items oi
    ON ts.seller_id = oi.seller_id
JOIN products pp
    ON oi.product_id = pp.product_id
JOIN orders oo
    ON oi.order_id = oo.order_id
JOIN sellers ss
	ON ss.seller_id = oi.seller_id

GROUP BY
    ts.seller_id,
    ss.seller_name,
    pp.product_category_name
HAVING COUNT(*) >= 20
ORDER BY
    -- seller_name asc,
    cancellation_rate desc
    limit 10;
    