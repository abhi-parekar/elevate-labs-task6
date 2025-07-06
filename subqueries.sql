USE ecommerce;

-- 1. Scalar Subquery: Get name of customer who placed the latest order
SELECT name FROM Customer
WHERE customer_id = (
  SELECT customer_id FROM OrderTable
  ORDER BY order_date DESC
  LIMIT 1
);

-- 2. Subquery in WHERE with IN: Get products that are part of any order
SELECT * FROM Product
WHERE product_id IN (
  SELECT product_id FROM Order_Item
);

-- 3. Subquery in WHERE with EXISTS: Customers who have placed at least one order
SELECT * FROM Customer c
WHERE EXISTS (
  SELECT 1 FROM OrderTable o
  WHERE o.customer_id = c.customer_id
);

-- 4. Correlated Subquery: Orders where amount > average order amount of that customer
SELECT o.order_id, o.customer_id, p.amount
FROM OrderTable o
JOIN Payment p ON o.order_id = p.order_id
WHERE p.amount > (
  SELECT AVG(p2.amount)
  FROM Payment p2
  JOIN OrderTable o2 ON p2.order_id = o2.order_id
  WHERE o2.customer_id = o.customer_id
);

-- 5. Subquery in SELECT (Scalar): Total order amount for each customer
SELECT c.customer_id, c.name,
  (SELECT SUM(p.amount)
   FROM OrderTable o
   JOIN Payment p ON o.order_id = p.order_id
   WHERE o.customer_id = c.customer_id) AS total_spent
FROM Customer c;

-- 6. Subquery in FROM clause (Derived Table): Get avg payment per customer
SELECT customer_id, ROUND(avg_payment, 2)
FROM (
  SELECT o.customer_id, AVG(p.amount) AS avg_payment
  FROM OrderTable o
  JOIN Payment p ON o.order_id = p.order_id
  GROUP BY o.customer_id
) AS customer_avg;

-- 7. Subquery using NOT EXISTS: Customers who never placed an order
SELECT * FROM Customer c
WHERE NOT EXISTS (
  SELECT 1 FROM OrderTable o
  WHERE o.customer_id = c.customer_id
);
