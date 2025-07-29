
#1
CREATE VIEW list_of_customers AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    ci.city,
    co.country,
    CASE 
        WHEN c.active = 1 THEN 'active'
        ELSE 'inactive'
    END AS status,
    c.store_id
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

#2

CREATE VIEW film_details AS
SELECT 
    f.film_id,
    f.title,
    f.description,
    c.name AS category,
    f.rental_rate AS price,
    f.length,
    f.rating,
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id;

#3

CREATE VIEW sales_by_film_category AS
SELECT 
    c.name AS category,
    SUM(p.amount) AS total_rental
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

#4

CREATE VIEW actor_information AS
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

#5

CREATE VIEW actor_info AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;


#6

-- Vista: list_of_customers Muestra una lista de clientes con su información completa: ID del cliente, nombre completo, dirección, ciudad, país, código postal, teléfono, estado (activo/inactivo) y tienda asignada. Ideal para reportes administrativos o sistemas CRM.

-- Vista: film_details Muestra detalles completos de cada película: ID, título, descripción, categoría, precio de alquiler, duración, rating y una lista de actores (como texto separado por comas). Útil para catálogos o interfaces de búsqueda enriquecida.

-- Vista: sales_by_film_category Muestra las ventas totales agrupadas por categoría de película: Nombre de categoría y total recaudado por alquileres. Útil para análisis financiero y decisiones de contenido.

-- Vista: actor_information Devuelve información de actores con la cantidad de películas en las que han actuado: ID del actor, nombre, apellido y total de películas. Útil para rankings o análisis de participación.

-- Vista: actor_info Similar a actor_information. Muestra cuántas películas tiene cada actor. Se une actor con film_actor y se agrupa para contar apariciones. La subconsulta implícita es una agregación COUNT(*) con GROUP BY.


