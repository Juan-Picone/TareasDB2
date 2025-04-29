USE sakila;

#1
SELECT title, rating
FROM film
WHERE length <= ALL (SELECT length FROM film WHERE length IS NOT NULL);
#2
SELECT title
FROM film f1
WHERE length <= ALL (SELECT length FROM film WHERE length IS NOT NULL)
  AND NOT EXISTS (
    SELECT 1
    FROM film f2
    WHERE f2.film_id <> f1.film_id
      AND f2.length = f1.length
  );
#3
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    p.amount AS lowest_payment
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    payment p ON c.customer_id = p.customer_id
WHERE 
    p.amount <= ALL (
        SELECT amount 
        FROM payment 
        WHERE customer_id = c.customer_id
    )
ORDER BY 
    c.customer_id;
#4
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    (SELECT MIN(amount) FROM payment WHERE customer_id = c.customer_id) AS lowest_payment,
    (SELECT MAX(amount) FROM payment WHERE customer_id = c.customer_id) AS highest_payment
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
ORDER BY 
    c.customer_id;