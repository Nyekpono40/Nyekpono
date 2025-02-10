-- sql data cleaning and exploration project --

-- create customers table

/* create table customers(
customer_id smallint unsigned,
customer_name varchar(30) not null,
phone_no char(11) not null,
primary key(customer_id)
); */

-- inserting data into customers table

/* insert into customers(customer_id, customer_name, phone_no)
values(1 , 'victor', '07085366976');

insert into customers(customer_id, customer_name, phone_no)
values(2 , 'isaiah', '08085200678');

insert into customers(customer_id, customer_name, phone_no)
values(3 , 'jeremiah', '09085600679');

insert into customers(customer_id, customer_name, phone_no)
values(4 , 'ezekiel', '07098643645'); */

-- creating orders table

 /* create table orders (
orders_id int unsigned , 
customer_id smallint unsigned not null , 
order_details varchar(100) not null,
primary key(orders_id)
);
*/

-- inserting data into orders table
/*
insert into orders
values(1, 1,'pizza,coke');

insert into orders
values(2, 1,'pizza,fanta');

insert into orders
values(3, 3,'chicken,coke');

insert into orders
values(4, 4,'fried rice,fruit juice');

insert into orders
values(5, 2,'rice and stew,table water');

insert into orders
values(6, 1,'coconut rice,coke');
*/

-- finding out the total no of records from the orders table

select count(*) from orders;

-- altering our customers table to add an email address column
/*
alter table customers
add email_address varchar(30) not null;
*/
-- updating the customers table to add fields for the new column
/*
update customers
set email_address = 'wayforward@gmail.com'
where customer_id= 1;

update customers
set email_address = 'benedictn@gmail.com'
where customer_id= 2;

update customers
set email_address = 'alexis@gmail.com'
where customer_id= 3;

update customers
set email_address = 'okan@gmail.com'
where customer_id= 4;
*/
-- joining the two tables together to easily disect information from both 

 select * from customers c
 join orders o on o.customer_id = c.customer_id;

-- fetching data for the last three orders that were placed

select orders_id, c.customer_id, customer_name, order_details
from customers c
join orders o on o.customer_id = c.customer_id
order by orders_id desc
limit 3;

-- finding out the customer with the highest order
select customer_name, count(customers.customer_id) as max
from customers
join orders on orders.customer_id = customers.customer_id
group by customer_name
limit 1;


-- fetching record of customers that have eaten rice in our restaurant
select *
from customers
join orders on orders.customer_id = customers.customer_id
where order_details like '%rice%';

-- fetching record of customers that have not eaten rice in our restaurant
select *
from customers
join orders on orders.customer_id = customers.customer_id
where order_details not like '%rice%';
