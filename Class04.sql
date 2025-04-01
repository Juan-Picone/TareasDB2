use sakila;
#1

select title, special_features from film
where rating like 'PG-13';

#2

select distinct length from film
order by length asc;

#3

select title, rental_rate, replacement_cost from film
where replacement_cost < 24.00 and replacement_cost > 20.00
order by replacement_cost asc;

#4

select f.title, c.`name` as category , f.rating from film_category fc
inner join film f on fc.film_id = f.film_id
inner join category c on fc.category_id = c.category_id
where special_features like 'Behind the Scenes';

#5

select a.first_name, a.last_name  from film_actor fa
inner join film f on fa.film_id = f.film_id
inner join actor a on fa.actor_id = a.actor_id
where title like 'ZOOLANDER FICTION';

#6

select s.store_id, a.address, c.city, co.country from store s
inner join address a on s.address_id = a.address_id
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id
where s.store_id = 1;

#7
select title, rating from film
where rating = rating in(select rating from film);

#8
select f.title, st.first_name, st.last_name from inventory i
inner join film f on i.film_id = f.film_id
inner join store s on i.store_id = s.store_id
inner join staff st on s.manager_staff_id = st.staff_id
where s.store_id = 2

