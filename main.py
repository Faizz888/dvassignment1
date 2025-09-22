import mysql.connector
import pandas as pd

config = {
    "host": "localhost",
    "user": "olist",
    "password": "2004",
    "database": "olist_db", 
}

conn = mysql.connector.connect(**config)
cursor = conn.cursor()

# --- SQL-запросы ---
queries = {
    "orders_per_month": """
        SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
               COUNT(*) AS total_orders
        FROM orders
        GROUP BY month
        ORDER BY month ASC
        LIMIT 12;
    """,

    "top_states_by_customers": """
        SELECT customer_state, COUNT(*) AS customer_count
        FROM customers
        GROUP BY customer_state
        ORDER BY customer_count DESC
        LIMIT 10;
    """,

    "top_sellers": """
        SELECT s.seller_id, s.seller_city, COUNT(oi.order_id) AS total_sales
        FROM order_items oi
        JOIN sellers s ON oi.seller_id = s.seller_id
        GROUP BY s.seller_id, s.seller_city
        ORDER BY total_sales DESC
        LIMIT 10;
    """,

    "top_products": """
        SELECT p.product_category_name, COUNT(oi.order_id) AS total_sales
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        GROUP BY p.product_category_name
        ORDER BY total_sales DESC
        LIMIT 10;
    """,

    "payment_types_distribution": """
        SELECT payment_type, COUNT(*) AS total_payments
        FROM order_payments
        GROUP BY payment_type
        ORDER BY total_payments DESC;
    """,

    "avg_review_score_per_category": """
        SELECT p.product_category_name, ROUND(AVG(r.review_score),2) AS avg_score
        FROM order_reviews r
        JOIN orders o ON r.order_id = o.order_id
        JOIN order_items oi ON o.order_id = oi.order_id
        JOIN products p ON oi.product_id = p.product_id
        GROUP BY p.product_category_name
        ORDER BY avg_score DESC
        LIMIT 10;
    """
}

for name, query in queries.items():
    print(f"\n--- {name} ---")
    df = pd.read_sql(query, conn)
    print(df)
    df.to_excel(f"{name}.xlsx", index=False)

cursor.close()
conn.close()