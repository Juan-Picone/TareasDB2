use sakila;

#1
select f.title from inventory i
right join film f on i.film_id = f.film_id
where inventory_id is null;

#2
select f.title from rental r
join inventory i  on r.inventory_id = i.inventory_id
right join film f on i.film_id = f.film_id
where rental_id is null;

#3

select c.first_name, c.last_name, c.store_id, f.title, r.rental_date, r.return_date from rental r
join inventory i  on r.inventory_id = i.inventory_id
join customer c on r.customer_id = c.customer_id
right join film f on i.film_id = f.film_id
where  r.rental_date is not null 
order by c.store_id, c.last_name;

#4
select sum(p.amount) as total, concat(co.country,c.city)as "direccion", concat (m.first_name, m.last_name) as "Nombre" from store s
inner join  staff m on s.manager_staff_id = m.staff_id
inner join  address a on s.address_id = a.address_id
inner join  city c on a.city_id = c.city_id
inner join  country co on c.country_id = co.country_id
inner join  inventory i on s.store_id = i.store_id
inner join  rental r on i.inventory_id = r.inventory_id
inner join  payment p on r.rental_id = p.rental_id
group by s.store_id, "direccion", "Nombre"
order by total desc;

#5
select 
    concat(a.first_name, ' ', a.last_name) as nombre,
    count(fa.film_id) as cantidad
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
group by nombre
order by cantidad desc
limit 1;




