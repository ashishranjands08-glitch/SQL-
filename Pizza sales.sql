create database pizzaSale;
use pizzaSale;

select * from pizza_types;

create table orders(
	order_id int,
    date date,
    time time
    );
    
    
create table order_details(
	order_details_id int,
    order_id int,
    pizza_id text,
    quanitity int
    );
    
    
select * from orders;



-- Retrieve the total number of orders placed.

select
	count(*)
from 
orders;

-- Calculate the total revenue generated from pizza sales.
select
	round(sum(od.quanitity * p.price),2) revenue
from order_details od 
join pizzas p
on od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
select
	pt.name,
    p.price price
from pizzas p 
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
order by p.price desc
limit 1;

-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(*) count_of_sale
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY count_of_sale DESC
LIMIT 1;
-- List the top 5 most ordered pizza types along with their quantities.
select * from order_details;


SELECT 
		p.pizza_type_id, COUNT(od.order_id) count_of_orders,sum(od.quanitity) quantity
FROM
	order_details od
JOIN
pizzas p 
ON od.pizza_id = p.pizza_id
GROUP BY p.pizza_type_id
ORDER BY count_of_orders DESC
LIMIT 5;






-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
		pt.category, 
        COUNT(od.order_id) count_of_orders,
        sum(od.quanitity) quantity
FROM
	order_details od
JOIN
pizzas p 
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY count_of_orders DESC;

-- Determine the distribution of orders by hour of the day.
select
	hour(time) hours,
    count(order_id) orders
from orders
group by hours
order by orders desc;

-- Join relevant tables to find the category-wise distribution of pizzas.
select
	pt.category,
    count(pizza_id) count_of_pizzas
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
group by pt.category;
-- Group the orders by date and calculate the average number of pizzas ordered per day.
select
	avg(count_orders) avg_ordes
from
	(select
		date(date),
		count(order_id) count_orders
	from orders
	group by date(date))t;
-- Determine the top 3 most ordered pizza types based on revenue.
select * from pizza_types;

SELECT 
    pt.name, COUNT(od.order_id) count_of_orders
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY count_of_orders DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.name,
    CONCAT(ROUND(SUM(od.quanitity * p.price) / (SELECT 
                            SUM(od.quanitity * p.price) revenue
                        FROM
                            pizzas p
                                JOIN
                            order_details od ON p.pizza_id = od.pizza_id) * 100,
                    2),
            '%') percentage_revenue
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name;


-- Analyze the cumulative revenue generated over time.
select
date,
round(sum(rvn) over(order by date),2) as cum_sum
from(
select
	o.date,
    sum(p.price*od.quanitity) rvn
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join orders o
on o.order_id = od.order_id
group by o.date)t;
