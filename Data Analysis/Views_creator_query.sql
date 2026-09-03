-- Overall cancellation picture
CREATE OR REPLACE VIEW vw_returns_overview AS
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN order_status = 'canceled' THEN order_id
    END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN order_status = 'canceled' THEN order_id
        END) * 100.0 / COUNT(DISTINCT order_id),
        2
    ) AS cancellation_rate
FROM orders;


-- Cancellation by product category
CREATE OR REPLACE VIEW vw_returns_category AS
SELECT
    pp.product_category_name,
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
FROM order_items oi
JOIN products pp
    ON oi.product_id = pp.product_id
JOIN orders oo
    ON oi.order_id = oo.order_id
GROUP BY pp.product_category_name;


-- Cancellation by seller
CREATE OR REPLACE VIEW vw_returns_seller AS
SELECT
    oi.seller_id,
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
FROM order_items oi
JOIN orders oo
    ON oi.order_id = oo.order_id
GROUP BY oi.seller_id;


-- Cancellation by payment method
CREATE OR REPLACE VIEW vw_returns_payment AS
SELECT
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN o.order_status = 'canceled' THEN p.order_id
    END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN o.order_status = 'canceled' THEN p.order_id
        END) * 100.0 / COUNT(DISTINCT p.order_id),
        2
    ) AS cancellation_rate
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY p.payment_type;


-- Cancellation by number of installments
CREATE OR REPLACE VIEW vw_returns_installments AS
SELECT
    p.payment_installments,
    COUNT(DISTINCT p.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN o.order_status = 'canceled' THEN p.order_id
    END) AS canceled_orders,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN o.order_status = 'canceled' THEN p.order_id
        END) * 100.0 / COUNT(DISTINCT p.order_id),
        2
    ) AS cancellation_rate
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
GROUP BY p.payment_installments;


-- Cancellation by number of payment records
CREATE OR REPLACE VIEW vw_returns_payment_sequential AS
SELECT
    payment_count,
    COUNT(*) AS total_orders,
    SUM(canceled) AS canceled_orders,
    ROUND(
        SUM(canceled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM (
    SELECT
        p.order_id,
        COUNT(*) AS payment_count,
        MAX(
            CASE
                WHEN o.order_status = 'canceled' THEN 1
                ELSE 0
            END
        ) AS canceled
    FROM payments p
    JOIN orders o
        ON p.order_id = o.order_id
    GROUP BY p.order_id
) x
GROUP BY payment_count;


-- Product price and freight cost
CREATE OR REPLACE VIEW vw_returns_cost AS
SELECT
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    pp.product_category_name,
    o.order_status,
    CASE
        WHEN o.order_status = 'canceled' THEN 1
        ELSE 0
    END AS canceled
FROM order_items oi
JOIN products pp
    ON oi.product_id = pp.product_id
JOIN orders o
    ON oi.order_id = o.order_id;


-- Cancellation by customer location
CREATE OR REPLACE VIEW vw_returns_location AS
SELECT
    c.customer_state,
    c.customer_city,
    oo.order_id,
    oo.order_status,
    CASE
        WHEN oo.order_status = 'canceled' THEN 1
        ELSE 0
    END AS canceled
FROM orders oo
JOIN customers c
    ON oo.customer_id = c.customer_id;


-- Delivery performance and cancellation
CREATE OR REPLACE VIEW vw_returns_delivery AS
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    CASE
        WHEN order_status = 'canceled' THEN 1
        ELSE 0
    END AS canceled,

    CASE
        WHEN order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    END AS delivery_days,

    CASE
        WHEN order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    END AS delivery_vs_estimate_days

FROM orders;