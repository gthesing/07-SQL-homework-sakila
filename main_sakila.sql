USE sakila;

-- ============================= --
-- =========== Part 1 ========== --
-- ============================= --

-- a -- 
SELECT first_name, last_name 
FROM actor;

-- b -- 
SELECT CONCAT(first_name, " ", last_name) 
AS actor_name 
FROM actor;


-- ============================= --
-- =========== Part 2 ========== --
-- ============================= --

-- a --
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='JOE';

-- b --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- c --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- d --
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');


-- ============================= --
-- =========== Part 3 ========== --
-- ============================= --

-- a --
ALTER TABLE actor
ADD description BLOB;

-- b --
ALTER TABLE actor
DROP COLUMN description;


-- ============================= --
-- =========== Part 4 ========== --
-- ============================= --

-- a --
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- b --
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- c --
UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

-- d --
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO';


-- ============================= --
-- =========== Part 5 ========== --
-- ============================= --

-- a --
SHOW CREATE TABLE address;


-- ============================= --
-- =========== Part 6 ========== --
-- ============================= --

-- a --
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- b --
SELECT staff.first_name, staff.last_name, COUNT(payment.staff_id)
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY payment.staff_id;

-- c --
SELECT film.title, COUNT(film_actor.film_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;

-- d --
SELECT film_id
FROM film
WHERE title = 'HUNCHBACK IMPOSSIBLE';
SELECT COUNT(film_id)
FROM inventory
WHERE film_id = 439;

-- e --
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;


-- ============================= --
-- =========== Part 7 ========== --
-- ============================= --

-- a --
SELECT title
FROM film
WHERE (title LIKE 'Q%' OR title LIKE 'K%') AND language_id = (
	SELECT language_id 
    FROM language 
    WHERE name = 'ENGLISH');

-- b --
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id = (
		SELECT film_id
		FROM film
		WHERE title = 'ALONE TRIP'));

-- c --
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
	SELECT address_id 
    FROM address 
    WHERE city_id IN (
		SELECT city_id 
        FROM city
        WHERE country_id = (
			SELECT country_id
            FROM country
            WHERE country = 'Canada')));

-- d --
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id = (
		SELECT category_id
		FROM category
		WHERE name = 'Family'));
        
-- e --
SELECT film.title, COUNT(film.title)
FROM inventory
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(film.title) DESC;

-- f --
SELECT staff.store_id, SUM(payment.amount)
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY staff.store_id;

-- g --
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- h --
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;


-- ============================= --
-- =========== Part 8 ========== --
-- ============================= --

-- a --
CREATE OR REPLACE VIEW top_five_genres_by_gross_revenue AS 
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- b --
SELECT * FROM top_five_genres_by_gross_revenue;

-- c --
DROP VIEW top_five_genres_by_gross_revenue; 







