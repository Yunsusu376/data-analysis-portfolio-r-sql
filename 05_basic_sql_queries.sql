-- ------------------------------------------------------------
-- Title: SQL — Basic Queries
-- Notes:
--   - Queries only (no dataset included).
--   - SQL keywords are written in UPPERCASE for readability.
--   - Each question block includes a brief purpose comment.
-- ------------------------------------------------------------


-- Q1 ---------------------------------------------------------
-- Purpose: Count how many actors share each last name, and list last names alphabetically.
SELECT
  last_name,
  COUNT(*) AS actor_count
FROM actor
GROUP BY last_name
ORDER BY last_name ASC;


-- Q2 ---------------------------------------------------------
-- Purpose: Same as Q1, but keep only last names shared by at least 3 actors.
-- Notes:
--   - HAVING filters aggregated results (after GROUP BY).
--   - Sort by actor_count descending; tie-breaker by last_name ascending.
SELECT
  last_name,
  COUNT(*) AS actor_count
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 3
ORDER BY actor_count DESC, last_name ASC;


-- Q3 ---------------------------------------------------------
-- Purpose: List all comedy films (title + year) and sort by revenue highest to lowest.
-- Note:
--   - This assumes genre is stored as a single value 'Comedy'.
--   - If a film can have multiple genres, you may need a genre bridge table or LIKE filtering.
SELECT
  title,
  film_year
FROM movies
WHERE genre = 'Comedy'
ORDER BY revenue_mils DESC;


-- Q4 ---------------------------------------------------------
-- Purpose: Count how many films exist for each year (oldest year first).
SELECT
  film_year,
  COUNT(*) AS film_number
FROM movies
GROUP BY film_year
ORDER BY film_year ASC;


-- Q5 ---------------------------------------------------------
-- Purpose: Show directors who directed more than 4 films.
-- Output: director name + number of films; sort by most films, tie-breaker alphabetically.
SELECT
  director,
  COUNT(*) AS film_number
FROM movies
GROUP BY director
HAVING COUNT(*) > 4
ORDER BY film_number DESC, director ASC;


-- Q6 ---------------------------------------------------------
-- Purpose: For each year, show the highest revenue (oldest year first).
-- Output: film_year + max revenue_mils.
SELECT
  film_year,
  MAX(revenue_mils) AS max_revenue
FROM movies
GROUP BY film_year
ORDER BY film_year ASC;


-- Q7 ---------------------------------------------------------
-- Purpose: For districts starting with A/B/C/D, show each district's highest postal code.
-- Note:
--   - Using multiple LIKE conditions; could also use a regex/pattern depending on DB.
SELECT
  district,
  MAX(postal_code) AS max_postal_code
FROM address
WHERE district LIKE 'A%'
   OR district LIKE 'B%'
   OR district LIKE 'C%'
   OR district LIKE 'D%'
GROUP BY district
ORDER BY district ASC;


-- Q8 ---------------------------------------------------------
-- Purpose:
--   - Find top 15 customers by average payment amount (average < 4.5),
--   - Round average to 3 decimals, and sort highest average first.
-- Notes:
--   - HAVING applies the condition to the aggregated AVG(amount).
--   - LIMIT returns only the top 15 after sorting.
SELECT
  customer_id,
  ROUND(AVG(amount), 3) AS avg_amount
FROM payment
GROUP BY customer_id
HAVING AVG(amount) < 4.5
ORDER BY avg_amount DESC
LIMIT 15;


-- Q9 ---------------------------------------------------------
-- Purpose: Count actors whose last name is shared by 3 or more other actors.
-- Interpretation:
--   - "3 or more other actors" means group size >= 4 total.
-- Approach:
--   - Subquery finds last names with COUNT(*) >= 4,
--   - Outer query counts actors whose last_name is in that set.
SELECT
  COUNT(*) AS total_actors
FROM actor
WHERE last_name IN (
  SELECT
    last_name
  FROM actor
  GROUP BY last_name
  HAVING COUNT(*) >= 4
);


-- Q10 --------------------------------------------------------
-- Purpose: Compute total revenue by month using EXTRACT().
-- Notes:
--   - This groups by month number (1–12) across all years.
--   - If you need month-by-year, include EXTRACT(YEAR FROM payment_date) in SELECT/GROUP BY.
SELECT
  EXTRACT(MONTH FROM payment_date) AS month,
  SUM(amount) AS total_revenue
FROM payment
GROUP BY EXTRACT(MONTH FROM payment_date)
ORDER BY month ASC;
