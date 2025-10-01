

USE sakila;

SET profiling = 1;

-- 1)

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('52137', '12345', '85012');

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code NOT IN ('52137', '12345', '85012');

SELECT a.address_id, a.address, a.postal_code, c.city
FROM address a
JOIN city c ON a.city_id = c.city_id
WHERE a.postal_code IN ('52137');

SHOW PROFILES;


CREATE INDEX idx_postal_code ON address(postal_code);

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('52137', '12345', '85012');

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code NOT IN ('52137', '12345', '85012');

SELECT a.address_id, a.address, a.postal_code, c.city
FROM address a
JOIN city c ON a.city_id = c.city_id
WHERE a.postal_code IN ('52137');

SHOW PROFILES;

--   - Ahora las consultas utilizan el índice B-Tree en postal_code.
--   - El tiempo de ejecución se reduce drásticamente, ya no es necesario recorrer toda la tabla.
--   - Esto se nota especialmente con condiciones de igualdad o IN.


-- 2)


SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'NICK';

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name = 'WAHLBERG';

--   - Ambas columnas tienen índices.
--   - Pero, la utilidad del índice depende de cuántos valores distintos hay.
--   - first_name tiene muchos repetidos, por lo cual el índice no ayuda tanto.
--   - last_name suele tener más variabilidad, entonces la búsqueda es más rápida y eficiente.


-- 3) 
--   - LIKE con porcentajes (%) obliga a MySQL a escanear toda la columna.
--   - Es lento para textos largos.
SELECT film_id, title, description
FROM film
WHERE description LIKE '%drama%';

--   - MATCH utiliza un índice FULLTEXT, diseñado para búsquedas de palabras en textos largos.
--   - Mucho más rápido y además permite ranking por relevancia.
SELECT film_id, title
FROM film_text
WHERE MATCH(title, description) AGAINST('drama');


