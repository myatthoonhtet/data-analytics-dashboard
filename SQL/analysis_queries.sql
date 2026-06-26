SELECT * FROM public.categories 

SELECT * FROM public.customers

SELECT * FROM public.employees

SELECT * FROM public.order_details

SELECT * FROM public.suppliers 

SELECT * FROM public.orders

SELECT * FROM public.products 

SELECT * FROM public.shippers 

SELECT * FROM public.us_states 


-- sale fact

SELECT
	od.order_id,
	od.product_id,
	o.customer_id,
	o.order_date,
	o.employee_id,
	o.ship_via AS "shipper_id",
	o.ship_country,
	od.unit_price,
	od.quantity,
	od.discount,
	ROUND((od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS line_total
FROM
	orders o
LEFT JOIN order_details od ON
	o.order_id = od.order_id


-- Top 10 Products by Sales

SELECT 
    p.product_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM products p
LEFT JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;


/* SELECT DISTINCT(product_id) FROM order_details */


-- Top 10 Customers by Sales


SELECT 
    c.company_name AS customer_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM orders o
LEFT JOIN order_details od
ON o.order_id = od.order_id
LEFT JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.company_name
ORDER BY total_sales DESC
LIMIT 10;


/* SELECT o.order_id,
		c.company_name
FROM public.customers c 
LEFT JOIN public.orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL */


-- Top 10 Countries by Sales

SELECT 
    o.ship_country AS country,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM orders o
LEFT JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.ship_country
ORDER BY total_sales DESC
LIMIT 10;


/* SELECT country,count(country)
FROM public.customers
GROUP BY country */

/* SELECT count(DISTINCT(country))
FROM public.customers */



-- Sales by Category

SELECT c.category_id,
    c.category_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM products p
LEFT JOIN order_details od
ON p.product_id = od.product_id
LEFT JOIN categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;

/* SELECT * FROM public.categories */


-- Sales by Shipper (shipping company contribution)

SELECT 
    s.company_name AS shipper_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM orders o
LEFT JOIN order_details od
ON o.order_id = od.order_id
LEFT JOIN shippers s
ON s.shipper_id = o.ship_via
GROUP BY s.company_name
ORDER BY total_sales DESC;

SELECT * FROM public.shippers 



-- Sales by Employee

SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM orders o
LEFT JOIN order_details od
ON o.order_id = od.order_id
LEFT JOIN employees e
ON o.employee_id = e.employee_id
GROUP BY employee_name
ORDER BY total_sales DESC;










