create database [Pizza Sales]

use [Pizza Sales]

select count (order_id) as [Total Orders]
from orders

select * from order_details
select * from pizzas

select round(sum(order_details.quantity * pizzas.price),3) as [Total Sales]
from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id

select top 1 pizza_types.name, pizzas.price
	from pizzas
		join pizza_types 
		on pizzas.pizza_type_id = pizza_types.pizza_type_id
		order by pizzas.price desc

select pizzas.size, count(order_details.order_details_id) as [Size]
	from pizzas 
		join order_details 
		on pizzas.pizza_id = order_details.pizza_id
	group by pizzas.size
	order by count(order_details.order_details_id) desc

-- List the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name, sum(order_details.quantity) as [Ordered Quantity]
	from pizzas
	join pizza_types
	on pizzas.pizza_type_id = pizza_types.pizza_type_id
		join order_details
		on order_details.pizza_id = pizzas.pizza_id
	group by pizza_types.name
	order by [Ordered Quantity] desc


select sum(order_details.quantity) as [Ordered Quantity], 
	pizza_types.category
		from pizzas
			join pizza_types
			on pizzas.pizza_type_id = pizza_types.pizza_type_id
		join order_details
		on order_details.pizza_id = pizzas.pizza_id
	group by pizza_types.category
	order by [Ordered Quantity] desc

select DATEPART(hour, Time) as [Hours], count(*) as [Total Ordered by hours]
		from orders
	group by DATEPART(hour, Time)
	order by count(*) desc


select category, count(name) as Pizza
		from pizza_types
	group by category
	order by Pizza


select avg(Quantity) as [Average orders per Day]
from
	(select orders.date, sum(order_details.quantity) as [Quantity]
		from orders
		join order_details
		on orders.order_id = order_details.order_id
		group by orders.date)
	as order_quantity;


select top 3 pizza_types.name, 
sum(order_details.quantity * pizzas.price) as [Revenue]
	from pizzas
		join pizza_types
		on pizzas.pizza_type_id = pizza_types.pizza_type_id
	join order_details
	on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by sum(order_details.quantity * pizzas.price) desc



select pizza_types.name, round(sum(order_details.quantity * pizzas.price) / 
	(select round(sum(order_details.quantity * pizzas.price),3) as [Total Sales]
		from order_details
		join pizzas 
		on order_details.pizza_id = pizzas.pizza_id) *100, 2) as [Revenue]
	from pizzas
	join pizza_types
	on pizzas.pizza_type_id = pizza_types.pizza_type_id
		join order_details
		on order_details.pizza_id = pizzas.pizza_id
	group by pizza_types.name
	order by sum(order_details.quantity * pizzas.price) desc


select [Order Date], Total, sum(Total) over (order by [Order Date]) as [Cummulative Orders]
		from
			(select orders.date as [Order Date], round(sum(order_details.quantity * pizzas.price),2) as [Total]
		from pizzas
		join order_details
		on pizzas.pizza_id = order_details.pizza_id
	join orders
	on orders.order_id = order_details.order_id
group by orders.date) as sales
order by [Order Date];


select category, name, Revenue, ranking
from
	(select category, name, Revenue, rank() over (partition by category order by Revenue desc) as ranking
		from
			(select category, name, round(sum(quantity * price),3) as Revenue
				from pizza_types
				join pizzas
				on pizza_types.pizza_type_id = pizzas.pizza_type_id
		join order_details
		on pizzas.pizza_id = order_details.pizza_id
	group by category, name) as a) as b
	where ranking <=3;









select * from order_details
select * from pizza_types
select * from pizzas
select * from orders