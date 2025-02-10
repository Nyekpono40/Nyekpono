-- data exploration project --

-- fetching the entire dataset for exploration

select * from people.citizen;

-- fetching data from citizens of indonesia only using where clause and comparism operator

select * from people.citizen
where country = 'indonesia';

-- fetching records of specific columns in the table

select first_name, last_name, gender from people.citizen;

-- using logical operator to get more specific record of citizens from indonesia with salary above 350000

select * from people.citizen
where country = 'indonesia' and salary > 350000;

-- getting records of salaries of citizens from france in ascending order using order by clause

select  * from people.citizen
where country = 'france' 
order by salary;

-- using the limit clause in getting record of the top 5 earners in france

select * from people.citizen
where country = 'france' 
order by salary desc
limit 5;


-- using groupby clause and max function to get record of the aggregate salaries of each country

select country, max(salary) from people.citizen
group by country;


-- using round function to roundup the figures to get only a digit after the decimal point

select country, round(max(salary),1) from people.citizen
group by country;


-- fetching all the country names and their average salaries of citizens whose average salary should be greater than 500000

select country, avg(salary) from people.citizen
group by country
having avg(salary) > 500000;

-- filtering records from the first_name column using like operator

select first_name, last_name,country, gender, salary from people.citizen
where first_name like 'b%a';