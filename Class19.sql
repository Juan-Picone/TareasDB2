USE sakila;

#1

CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'M@rtinP1cone';

#2

GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

CREATE TABLE sakila.test_table (
    id INT,
    name VARCHAR(50)
);


-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'test_table'


#4

UPDATE sakila.film
SET title = 'LAS ASOMBROSAS AVENTURAS DE JUAN FRATTIN Y TEO'
WHERE film_id = 1;

#5

REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';

#6

UPDATE sakila.film
SET title = 'LAS ASOMBROSAS AVENTURAS DE JUAN FRATTIN Y TEO 2: MAS BASE DE DATOS QUE NUNCA'
WHERE film_id = 1;

-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'

