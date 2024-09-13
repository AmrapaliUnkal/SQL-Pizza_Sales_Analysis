Create database Pizza_Analysis;
use Pizza_Analysis;

alter table orders
add constraint pk primary key (order_id);

select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

/* Basic:
1. Retrieve the total number of orders placed.
2. Calculate the total revenue generated from pizza sales.
3. Identify the highest-priced pizza.
4. Identify the most common pizza size ordered.
5. List the top 5 most ordered pizza types along with their quantities.


Intermediate:
1. Join the necessary tables to find the total quantity of each pizza category ordered.
2. Determine the distribution of orders by hour of the day.
3. Join relevant tables to find the category-wise distribution of pizzas.
4. Group the orders by date and calculate the average number of pizzas ordered per day.
5. Determine the top 3 most ordered pizza types based on revenue.

Advanced:
Calculate the percentage contribution of each pizza type to total revenue.
Analyze the cumulative revenue generated over time.
Determine the top 3 most ordered pizza types based on revenue for each pizza category. */

-- 1. Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_Numbers_Of_Orders
FROM
    orders;

-- 2. Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS Total_Revenue
FROM
    order_details o
        JOIN
    pizzas p USING (pizza_id);

-- 3. Identify the highest-priced pizza.

SELECT 
    pt.name, p.price AS Highest_price
FROM
    pizzas p
        JOIN
    pizza_types pt USING (Pizza_type_id)
ORDER BY p.price DESC
LIMIT 1;

-- 4. Identify the most common pizza size ordered.

SELECT 
    p.size, SUM(od.quantity) AS highest_sold
FROM
    order_details od
        JOIN
    pizzas p USING (pizza_id)
GROUP BY p.size
ORDER BY highest_sold DESC
LIMIT 1;

-- 5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    name AS Pizza_Type, SUM(quantity) AS quantities
FROM
    order_details
        JOIN
    pizzas USING (pizza_id)
        JOIN
    pizza_types USING (pizza_type_id)
GROUP BY Pizza_Type
ORDER BY quantities DESC
LIMIT 5;

-- Intermediate:
-- 1. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS Quantity
FROM
    order_details od
        JOIN
    pizzas p USING (pizza_id)
        JOIN
    pizza_types pt USING (pizza_type_id)
GROUP BY pt.category
ORDER BY Quantity DESC;

-- 2. Determine the distribution of orders by hour of the day.

select * from orders;

SELECT 
    EXTRACT(HOUR FROM time) AS hours,
    COUNT(order_id) AS Distribution_of_orders
FROM
    orders
GROUP BY hours
ORDER BY hours;

-- 3. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    pt.category, SUM(od.quantity) AS Total_Pizzas_Distributed
FROM
    order_details od
        JOIN
    pizzas p USING (pizza_id)
        JOIN
    pizza_types pt USING (pizza_type_id)
GROUP BY pt.category;

-- 4. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    Extract(Day from date) as DAY, round(AVG(total_quantity),2) AS Avg_Pizzas_Ordered
FROM
    (SELECT 
        o.date, SUM(od.quantity) AS total_quantity
    FROM
        order_details od
    JOIN orders o USING (order_id)
    GROUP BY o.date) AS daily_pizzas
GROUP BY date;

-- 5. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, SUM(od.quantity * p.price) AS Revenue_Generated
FROM
    order_details od
        JOIN
    pizzas p USING (pizza_id)
        JOIN
    pizza_types pt USING (pizza_type_id)
GROUP BY pt.name
ORDER BY Revenue_Generated DESC
LIMIT 3;

-- Advanced:

-- 1. Calculate the percentage contribution of each pizza type to total revenue.

WITH Total_Revenue AS (
    SELECT 
        ROUND(SUM(od.quantity * p.price), 2) AS Total_Revenue_Cal
    FROM 
        order_details od 
    JOIN 
        pizzas p USING(pizza_id)
),
Per_Pizza_Revenue AS (
    SELECT 
        pt.name, 
        ROUND(SUM(od.quantity * p.price), 2) AS Per_Pizza_Revenue_Cal
    FROM 
        order_details od 
    JOIN 
        pizzas p USING(pizza_id)
    JOIN 
        pizza_types pt USING(pizza_type_id) 
    GROUP BY 
        pt.name
)
SELECT 
    ppr.name, 
    ROUND((ppr.Per_Pizza_Revenue_Cal / tr.Total_Revenue_Cal) * 100) AS Percentage_Contribution 
FROM 
    Total_Revenue tr 
JOIN 
    Per_Pizza_Revenue ppr;
    
-- 2. Analyze the cumulative revenue generated over time.
    
SELECT 
    o.date,
    -- (SUM(od.quantity * p.price)) AS Daily_Revenue,
    SUM(round(SUM(od.quantity * p.price))) OVER (ORDER BY o.date) AS Cumulative_Revenue
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizzas p USING(pizza_id)
GROUP BY 
    o.date
ORDER BY 
    o.date;
    

    
    

        










    
    







