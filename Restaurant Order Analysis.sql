USE restaurant_db;

-- View the menu_items table and write a query to find the number of items on the menu --

select count(menu_item_id) as total_items
from menu_items;

-- What are the least and most expensive items on the menu? --

select menu_item_id, item_name as expensive_item, max(price) as highest_price
from menu_items
group by 1,2
order by 3 desc
limit 1;

select menu_item_id, item_name as expensive_item, min(price) as least_price
from menu_items
group by 1,2
order by 3 asc
limit 1;

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu? --

select count(menu_item_id) as total_dishes
from menu_items
where category= "Italian";

select menu_item_id, item_name as expensive_item, max(price) as highest_price
from menu_items
where category= "Italian"
group by 1,2
order by 3 desc
limit 1;

select menu_item_id, item_name as expensive_item, min(price) as least_price
from menu_items
where category= "Italian"
group by 1,2
order by 3 asc
limit 1;

-- How many dishes are in each category? What is the average dish price within each category? --

select category,count(*) as total_dishes
from menu_items
group by 1;

-- View the order_details table. What is the date range of the table? --

select min(order_date) as min_date, max(order_date) as max_date
from order_details;

-- How many orders were made within this date range? How many items were ordered within this date range? --

select count(*) as total_orders
from order_details; 

-- Which orders had the most number of items? --

select order_id, order_date, count(order_id) as total_items
from order_details
group by 1,2
order by 3 desc
limit 1;

-- How many orders had more than 12 items? --

select count(order_id) as total_orders
from (SELECT order_id, COUNT(item_id) as total_items
FROM order_details
GROUP BY order_id
HAVING total_items > 12) a;

-- Combine the menu_items and order_details tables into a single table --

select *
from menu_items m join order_details o
on m.menu_item_id=o.item_id
order by o.order_details_id asc;

-- What were the least and most ordered items? What categories were they in? --

select m.category as least_ordered_category,  count(o.item_id) as no_of_orders
from menu_items m join order_details o
on m.menu_item_id=o.item_id
group by 1
order by 2 asc
limit 1;

select m.category as most_ordered_category,  count(o.item_id) as no_of_orders
from menu_items m join order_details o
on m.menu_item_id=o.item_id
group by 1
order by 2 desc
limit 1;

-- What were the top 5 orders that spent the most money? --

select o.order_id,sum(m.price) as total_spent
from menu_items m join order_details o
on m.menu_item_id=o.item_id
group by 1
order by 2 desc
limit 5;

-- View the details of the highest spend order. Which specific items were purchased? --

select m.category,count(o.item_id)
from menu_items m join order_details o
on m.menu_item_id=o.item_id
where order_id=(select o.order_id
from menu_items m join order_details o
on m.menu_item_id=o.item_id
group by 1
order by sum(m.price)  desc
limit 1)
group by 1;

-- BONUS: View the details of the top 5 highest spend orders --

with cte as (
    SELECT o.order_id
    FROM menu_items m
    JOIN order_details o ON m.menu_item_id = o.item_id
    GROUP BY o.order_id
    ORDER BY SUM(m.price) DESC
    LIMIT 5
)
SELECT o.order_id,m.category,count(o.item_id)
FROM menu_items m
JOIN order_details o ON m.menu_item_id = o.item_id
WHERE o.order_id IN (
select order_Id
from cte
)
group by 1,2;

