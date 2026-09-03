-- Cancellation trends

select order_status, count(*) count, count(*) * 100 / sum(count(*)) over() status_percentage
from orders
group by order_status
order by 2 desc;

--  Most orders were delivered (97%)
-- 0.6% - 625 orders, got cancelled
-- The question is, for these cancelled orders
-- What can we find out about why?

select * from orders
where order_status = "canceled" and order_delivered_customer_date is not null;

-- This tells us that 6 orders were returned
-- So
-- We find general trends on cancelled orders and see if there are any for the returned ones.

select datediff(order_delivered_carrier_date, order_approved_at) datediff, order_status from orders
where order_status = "canceled"
order by datediff desc;

-- No strong correlation between the carrier receiving the package late and the customer cancelling.

select datediff(order_estimated_delivery_date, order_approved_at) datediff, order_status from orders
-- where order_status = "canceled"
order by datediff desc;

-- come back to this, use a case to group andcheck percentage of cancelled in each goroup

-- Looking at products

select product_category_name, count(*) product_category_count, count(*) over() overall_product_count
from order_items oi inner join products pp
on oi.product_id = pp.product_id
inner join orders oo
on oi.order_id = oo.order_id
where order_status = "canceled"
group by product_category_name
order by 2 desc;

-- We have a list of commonly returned products
-- Lets check how they compare with non cancelled orders

select product_category_name, count(*) product_category_count, count(*) over() overall_product_count
from order_items oi inner join products pp
on oi.product_id = pp.product_id
inner join orders oo
on oi.order_id = oo.order_id
where order_status <> "canceled"
group by product_category_name
order by 2 desc;

-- of the top cancelled product categories, how do they compare with their non cancelled counterparts.
-- Checking and ordering by cancellation volume

SELECT
    product_category_name,
    SUM(order_status = 'canceled') AS canceled_count,
    SUM(order_status <> 'canceled') AS non_canceled_count,
    COUNT(*) AS total_count
FROM order_items oi
JOIN products pp ON oi.product_id = pp.product_id
JOIN orders oo ON oi.order_id = oo.order_id
GROUP BY product_category_name
ORDER BY canceled_count DESC;

-- Top categories here are: 
-- esporte_lazer
-- utilidades_domesticas
-- informatica_acessorios
-- beleza_saude
-- moveis_decoracao
-- brinquedos
-- automotivo
-- relogios_presentes
-- bebes
-- ferramentas_jardim


-- ordering by cancellation percentage for categories

SELECT
    product_category_name,
    SUM(order_status = 'canceled') AS canceled_count,
    SUM(order_status <> 'canceled') AS non_canceled_count,
    COUNT(*) AS total_count, round(SUM(order_status = 'canceled') * 100/count(*),2) cancelled_percentage
FROM order_items oi
JOIN products pp ON oi.product_id = pp.product_id
JOIN orders oo ON oi.order_id = oo.order_id
WHERE product_category_name is not null
GROUP BY product_category_name
HAVING COUNT(*) >= 500
ORDER BY cancelled_percentage DESC
limit 20;

-- Weve limited the total amount of orders to 500 to
-- eliminate orders too small to have any real pattern
-- Considering that, the top categories are:

-- instrumentos_musicais
-- livros_interesse_geral
-- eletroportateis
-- consoles_games
-- brinquedos
-- automotivo
-- utilidades_domesticas
-- bebes

-- Furthermore, these have cancellation rates > the 
-- cancellation rate of the entire dataset: 0.63%

-- Also, We have three commonalities between the two lists:
-- brinquedos
-- automotivo
-- utilidades_domesticas


