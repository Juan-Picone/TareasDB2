use sakila;
#1
select first_name, last_name
from actor
where last_name in (
    select last_name
    from actor
    group by last_name
    having count(*) > 1
)
order by last_name, first_name;
#2
select first_name, last_name from actor
where actor_id not in (select actor_id from film_actor);
#3

select c.first_name, c.last_name, f.title
from customer c
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where c.customer_id in (
    select r.customer_id
    from rental r
    inner join inventory i on r.inventory_id = i.inventory_id
    group by r.customer_id
    having count(distinct i.film_id) = 1
);
#4
select c.first_name, c.last_name, f.title
from customer c
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where c.customer_id in (
    select r.customer_id from rental r
    inner join inventory i on r.inventory_id = i.inventory_id
    group by r.customer_id
    having count(distinct i.film_id) > 1
);
#5
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' or'CATCH AMISTAD'
);
#6
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' and f.title not like 'CATCH AMISTAD'
);
#7
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' and f.title like 'CATCH AMISTAD'
);
#8
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id not in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' or'CATCH AMISTAD'
);