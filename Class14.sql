use sakila;

#1

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    a.address,
    ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

#2

SELECT 
    f.title,
    l.name AS language,
    CASE f.rating
        WHEN 'G' THEN 'General Audiences – All ages admitted'
        WHEN 'PG' THEN 'Parental Guidance Suggested – Some material may not be suitable for children'
        WHEN 'PG-13' THEN 'Parents Strongly Cautioned – Some material may be inappropriate for children under 13'
        WHEN 'R' THEN 'Restricted – Under 17 requires accompanying parent or adult guardian'
        WHEN 'NC-17' THEN 'Adults Only – No one 17 and under admitted'
        ELSE 'Not Rated'
    END AS rating_description
FROM film f
JOIN language l ON f.language_id = l.language_id;

#3

SET @actor_input = 'WILL SMITH';

SET @actor_name = UPPER(@actor_input);

SELECT 
    f.title, 
    f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE UPPER(CONCAT(a.first_name, ' ', a.last_name)) LIKE CONCAT('%', @actor_name, '%');

#4

SELECT 
    f.title,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6);

#5

SELECT CAST(rental_date AS CHAR) AS rental_str
FROM rental
LIMIT 5;

SELECT CONVERT(rental_date, CHAR) AS rental_str
FROM rental
LIMIT 5;

#6

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    IFNULL(a.phone, 'Sin teléfono') AS telefono
FROM customer c
JOIN address a ON c.address_id = a.address_id;

