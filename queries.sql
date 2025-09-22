-- Кол-во заказов по месяцам
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
       COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month ASC;

-- Топ-10 штатов по количеству клиентов
SELECT customer_state, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- Топ-10 продавцов по количеству продаж
SELECT s.seller_id, s.seller_city, COUNT(oi.order_id) AS total_sales
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city
ORDER BY total_sales DESC
LIMIT 10;

-- Топ-10 категорий товаров по продажам
SELECT p.product_category_name, COUNT(oi.order_id) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;

-- Распределение способов оплаты
SELECT payment_type, COUNT(*) AS total_payments
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- Средняя оценка по категориям товаров
SELECT p.product_category_name, ROUND(AVG(r.review_score),2) AS avg_score
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_score DESC
LIMIT 10;

-- Все клиенты + количество заказов (LEFT JOIN)
SELECT c.customer_id,
       COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Все продавцы + количество заказов (RIGHT JOIN)
SELECT s.seller_id,
       COUNT(oi.order_id) AS total_sales
FROM order_items oi
RIGHT JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_sales DESC
LIMIT 10;

-- Средняя оценка для товаров с отзывами (INNER JOIN)
SELECT p.product_id,
       ROUND(AVG(r.review_score), 2) AS avg_score
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY p.product_id
ORDER BY avg_score DESC
LIMIT 10;

-- Клиенты и заказы (FULL OUTER JOIN через UNION)
SELECT c.customer_id, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_id, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;
