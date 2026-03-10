Task 3 — SQL query (10 min)
Given Tables: 

products: id, name, category, price, created_at 
orders: id, order_date, customer_id, status, total_amount 
order_items: id, order_id, product_id, quantity, price 
Question: Write an SQL query to find the top 5 best-selling products based on the total quantity sold across all orders.

# class Product
#     has_many :order_items
#     has_many :orders, through: :order_items
# end

# class Order
#     has_many :order_items
#     has_many :products, through: :order_items
# end

# class OrderItem
#     belongs_to :order
#     belongs_to :product
# end

# SQL Query to find the top 5 best-selling products based on total quantity sold across all orders:
SELECT p.name, SUM(oitems.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oitems ON p.id = oitems.product_id
GROUP BY p.id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;