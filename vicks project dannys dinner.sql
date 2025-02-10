/* Project case study questions */

-- What is the total amount each customer spent at the restaurant?
-- How many days has each customer visited the restaurant?
-- What was the first item from the menu purchased by each customer?
-- What is the most purchased item on the menu and how many times was it purchased by all customers?
-- Which item was the most popular for each customer?
-- Which item was purchased first by the customer after they became a member?
-- Which item was purchased just before the customer became a member?
-- What is the total items and amount spent for each member before they became a member?
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?
-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?

/* create database vicks_dinner */

-- creating sales table

 /* create table sales(
customer_id varchar(1),
order_date date,
product_id integer
)
*/

-- inserting data into sales table

/* insert into sales
values('A','2024-01-01','1');
insert into sales
values('A','2024-01-01','2');
insert into sales
values('A','2024-01-07','2');
insert into sales
values('A','2024-01-11','3');
insert into sales
values('A','2024-01-11','3');
insert into sales
values('A','2024-01-01','3');
insert into sales
values('B','2024-01-01','2');
insert into sales
values('B','2024-01-02','2');
insert into sales
values('B','2024-01-04','1');
insert into sales
values('B','2024-01-11','1');
insert into sales
values('B','2024-01-16','3');
insert into sales
values('B','2024-02-01','3');
insert into sales
values('C','2024-01-01','3');
insert into sales
values('C','2024-01-01','3');
insert into sales
values('C','2024-02-01','3'); 
*/

-- creating menu table

/* create table menu(
product_id integer,
product_name varchar(5),
price integer
);
*/

-- inserting data into menu table

/* insert into menu
values('1','sushi','10');
insert into menu
values('2','curry','10');
insert into menu
values('3','ramen','10');
*/

-- CREATING TABLE MEMBERS

/* create table members(
customer_id varchar(1),
join_date date
);
*/

-- inserting data into members table

/* insert into members
values('A', '2024-01-07');
insert into members
values('B', '2024-01-09');
*/

/* update menu
set price = 15
where product_id = 2;
*/
/* UPDATE MENU
SET PRICE = 12
WHERE PRODUCT_ID = 3;
*/

-- case study (1), what is the total amount each customer spent at the restaurant

select customer_id, sum(price) as total_amount_spent from sales 
join menu on sales.product_id = menu.product_id
group by customer_id
order by customer_id;

-- case study (2), how many days has each customer visited the restaurant?

with days as (
 select customer_id, count(order_date) as days, row_number() over(partition by customer_id order by count(order_date))days_visited 
 from sales
 group by customer_id
)
select customer_id, days from days;

-- case study (3),  what was the first item purchased from the menu by each customer

with first_buy as (
 select customer_id, sales.product_id, product_name, order_date, row_number() over(partition by customer_id order by order_date )first_purchased
from sales
join  menu on sales.product_id = menu.product_id
)
select customer_id,product_name, product_id, order_date from first_buy
where first_purchased = 1;

-- case study (4),  what is the most purchased item on the menu

select sales.product_id, product_name, count(sales.product_id) as most 
from sales
join menu on sales.product_id = menu.product_id
group by sales.product_id, product_name
;

-- case study (5), which item was the most popular for each customer

with most as
(
select  customer_id, product_name, count(sales.product_id) as most_pop,
 row_number() over(partition by customer_id order by count(sales.product_id)desc)most_purchased
from sales
join menu on sales.product_id = menu.product_id
group by customer_id, sales.product_id, product_name
)
select customer_id, product_name, most_pop from most
where most_purchased = 1;

-- case study (6), which item was purchased first by the customer after they became a member

with first_as_mem as
(
select sales.customer_id, menu.product_name, order_date, row_number() over(partition by sales.customer_id order by sales.order_date) 
as mem_first
from sales
join menu on sales.product_id = menu.product_id
join members on sales.customer_id = members.customer_id
where order_date >= join_date
)
select customer_id, product_name, order_date from first_as_mem
where mem_first = 1;

-- case study (7), which item was purchased just before the customer became a member

with before_as_mem as
(
select sales.customer_id, menu.product_name, join_date, sales.order_date, row_number() over(partition by sales.customer_id order by sales.order_date desc) 
as before_mem
from sales
join menu on sales.product_id = menu.product_id
join members on sales.customer_id = members.customer_id
where order_date < join_date
)
select customer_id, product_name, order_date,join_date from before_as_mem
where before_mem = 1;

--  case study (8), what is the total items and amount spent for each member before they became a member

select sales.customer_id, 
count(sales.product_id) total_items, sum(menu.price)amount_spent
from sales
join menu on sales.product_id = menu.product_id
join members on sales.customer_id = members.customer_id
where order_date < join_date
group by 1
order by 1;

-- case study (9), if each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?

select sales.customer_id, sum(
case 
when menu.product_name = 'sushi' then 20 * menu.price
else 10 * menu.price
end)
 as total_points
from sales
join menu on sales.product_id = menu.product_id
group by 1
order by customer_id;


-- case study (10), in the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi-how many points do customer A and B have at the end of january?

select sales.customer_id, 
sum(menu.price) * 2 AS total_points
from sales
join menu on sales.product_id = menu.product_id
join members on sales.customer_id = members.customer_id
where order_date >= join_date and sales.order_date <= '2024-01-31'
group by 1
order by 1;