
CREATE DATABASE imdb;
USE imdb;


CREATE TABLE film (
    film_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year YEAR,
    CONSTRAINT pkfilm PRIMARY KEY (film_id)
);


CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    CONSTRAINT pkactor PRIMARY KEY (actor_id)
);


CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    CONSTRAINT pkfilmactor PRIMARY KEY (actor_id, film_id)
);

ALTER TABLE film ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE actor ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE film_actor
ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
ADD FOREIGN KEY (film_id) REFERENCES film(film_id);

INSERT INTO actor (first_name, last_name) VALUES
('Leonardo', 'DiCaprio'),
('Johnny', 'Depp'),
('Scarlett', 'Johansson'),
('Tom', 'Hanks');


INSERT INTO film (title, description, release_year) VALUES
('Inception', 'a', 2010),
('Los Piratas del Caribe', 'a', 2003),
('Viuda Negra', 'a', 2021),
('Forrest Gump', 'a', 1994);


INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1), 
(2, 2),
(3, 3), 
(4, 4),
(1, 4);