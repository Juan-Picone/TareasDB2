use sakila;


#1

INSERT INTO customer (
    store_id, first_name, last_name, email, address_id, active, create_date
)
VALUES (
    1,
    'Juan',
    'Frattin',
    'soyjuanfraok@gmail.com',
    (
        SELECT MAX(a.address_id)
        FROM address a
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = 'United States'
    ),
    1,
    NOW()
);

#2

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (
    NOW(),
    (
        SELECT i.inventory_id
        FROM inventory i
        JOIN film f ON i.film_id = f.film_id
        WHERE f.title = 'HOLES BRANNIGAN'
        ORDER BY i.inventory_id DESC
        LIMIT 1
    ),
    (
        SELECT c.customer_id
        FROM customer c
        ORDER BY c.customer_id DESC
        LIMIT 1
    ),
    NULL,
    (
        SELECT s.staff_id
        FROM staff s
        WHERE s.store_id = 2
        ORDER BY s.staff_id ASC
        LIMIT 1
    )
);

#3

UPDATE film f
JOIN (
    SELECT * FROM (
        SELECT 'G' AS rating, 2001 AS y
    ) AS t1
    JOIN (
        SELECT 'PG' AS rating, 2002 AS y
    ) AS t2 ON 0
    JOIN (
        SELECT 'PG-13' AS rating, 2003 AS y
    ) AS t3 ON 0
    JOIN (
        SELECT 'R' AS rating, 2004 AS y
    ) AS t4 ON 0
    JOIN (
        SELECT 'NC-17' AS rating, 2005 AS y
    ) AS t5 ON 0
) AS m ON f.rating = m.rating
SET f.release_year = m.y;


#4

UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
    SELECT r1.rental_id
    FROM rental r1
    WHERE r1.return_date IS NULL
    ORDER BY r1.rental_date DESC
    LIMIT 1
);

#5

DELETE FROM payment
WHERE rental_id IN (
    SELECT r.rental_id
    FROM rental r
    WHERE r.inventory_id IN (
        SELECT i.inventory_id
        FROM inventory i
        JOIN film f ON i.film_id = f.film_id
        WHERE f.title = 'HOLES BRANNIGAN'
    )
);


DELETE FROM rental
WHERE inventory_id IN (
    SELECT i.inventory_id
    FROM inventory i
    JOIN film f ON i.film_id = f.film_id
    WHERE f.title = 'HOLES BRANNIGAN'
);


DELETE FROM inventory
WHERE film_id = (
    SELECT f.film_id
    FROM film f
    WHERE f.title = 'HOLES BRANNIGAN'
);


DELETE FROM film_actor
WHERE film_id = (
    SELECT f.film_id
    FROM film f
    WHERE f.title = 'HOLES BRANNIGAN'
);


DELETE FROM film_category
WHERE film_id = (
    SELECT f.film_id
    FROM film f
    WHERE f.title = 'HOLES BRANNIGAN'
);


DELETE FROM film
WHERE title = 'HOLES BRANNIGAN';

#6

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (
    NOW(),
    (
        SELECT i.inventory_id
        FROM inventory i
        WHERE NOT EXISTS (
            SELECT 1
            FROM rental r
            WHERE r.inventory_id = i.inventory_id AND r.return_date IS NULL
        )
        LIMIT 1
    ),
    (
        SELECT c.customer_id
        FROM customer c
        ORDER BY c.customer_id DESC
        LIMIT 1
    ),
    NULL,
    (
        SELECT s.staff_id
        FROM staff s
        WHERE s.store_id = (
            SELECT i2.store_id
            FROM inventory i2
            WHERE NOT EXISTS (
                SELECT 1
                FROM rental r2
                WHERE r2.inventory_id = i2.inventory_id AND r2.return_date IS NULL
            )
            LIMIT 1
        )
        LIMIT 1
    )
);


INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (
        SELECT c.customer_id
        FROM customer c
        ORDER BY c.customer_id DESC
        LIMIT 1
    ),
    (
        SELECT s.staff_id
        FROM staff s
        WHERE s.store_id = (
            SELECT i2.store_id
            FROM inventory i2
            WHERE NOT EXISTS (
                SELECT 1
                FROM rental r2
                WHERE r2.inventory_id = i2.inventory_id AND r2.return_date IS NULL
            )
            LIMIT 1
        )
        LIMIT 1
    ),
    (
        SELECT r3.rental_id
        FROM rental r3
        WHERE r3.return_date IS NULL
        ORDER BY r3.rental_date DESC
        LIMIT 1
    ),
    (
        SELECT f.rental_rate
        FROM film f
        JOIN inventory i ON i.film_id = f.film_id
        WHERE i.inventory_id = (
            SELECT i2.inventory_id
            FROM inventory i2
            WHERE NOT EXISTS (
                SELECT 1
                FROM rental r2
                WHERE r2.inventory_id = i2.inventory_id AND r2.return_date IS NULL
            )
            LIMIT 1
        )
        LIMIT 1
    ),
    NOW()
);


