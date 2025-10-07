USE sakila;

#1

DELIMITER BD2

CREATE FUNCTION copias_por_tienda(
    p_film_identifier VARCHAR(100),
    p_store_id INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_film_id INT;
    DECLARE v_count INT;

    
    IF p_film_identifier REGEXP '^[0-9]+$' THEN
        SET v_film_id = CAST(p_film_identifier AS UNSIGNED);
    ELSE
        
        SELECT film_id INTO v_film_id
        FROM film
        WHERE title = p_film_identifier
        LIMIT 1;
    END IF;

    
    SELECT COUNT(*) INTO v_count
    FROM inventory
    WHERE film_id = v_film_id
      AND store_id = p_store_id;

    RETURN v_count;
END BD2

DELIMITER ;

#2

DELIMITER BD2

CREATE PROCEDURE clientes_pais(
    IN p_country VARCHAR(50),
    OUT p_customer_list TEXT
)
BEGIN
    DECLARE v_first_name VARCHAR(45);
    DECLARE v_last_name VARCHAR(45);
    DECLARE v_done BOOLEAN DEFAULT FALSE;


    DECLARE customer_cursor CURSOR FOR
        SELECT cu.first_name, cu.last_name
        FROM customer cu
        JOIN address a ON cu.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = p_country;


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;


    SET p_customer_list = '';


    OPEN customer_cursor;


    customer_loop: LOOP
        FETCH customer_cursor INTO v_first_name, v_last_name;
        IF v_done THEN
            LEAVE customer_loop;
        END IF;


        IF p_customer_list = '' THEN
            SET p_customer_list = CONCAT(v_first_name, ' ', v_last_name);
        ELSE
            SET p_customer_list = CONCAT(p_customer_list, '; ', v_first_name, ' ', v_last_name);
        END IF;
    END LOOP;


    CLOSE customer_cursor;
END BD2

DELIMITER ;

# 3

DELIMITER BD2

CREATE FUNCTION inventory_in_stock(p_inventory_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out INT;

    -- Contamos cuántas veces se alquiló este inventario (históricamente)
    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    -- Contamos si hay un alquiler activo (sin return_date)
    SELECT COUNT(rental_id) INTO v_out
    FROM rental
    WHERE inventory_id = p_inventory_id
      AND return_date IS NULL;

    -- Si nunca se alquiló, está disponible
    IF v_rentals = 0 THEN
        RETURN TRUE;
    -- Si existe al menos un alquiler activo, no está disponible
    ELSEIF v_out > 0 THEN
        RETURN FALSE;
    -- Si se alquiló pero todos fueron devueltos, está disponible
    ELSE
        RETURN TRUE;
    END IF;
END BD2



CREATE PROCEDURE film_in_stock(
    IN p_film_id INT,
    IN p_store_id INT,
    OUT p_film_count INT
)
READS SQL DATA
BEGIN
    -- Contamos solo las copias (inventarios) que están disponibles
    SELECT COUNT(*) INTO p_film_count
    FROM inventory i
    WHERE i.film_id = p_film_id
      AND i.store_id = p_store_id
      AND inventory_in_stock(i.inventory_id) = TRUE;
END BD2

DELIMITER ;

