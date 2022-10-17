-- Create vine table
CREATE TABLE IF NOT EXISTS vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);

-- Read vine_table.csv
COPY vine_table 
FROM PROGRAM 'curl "https://raw.githubusercontent.com/Daniel-Sanudo/Amazon_Vine_Analysis/main/vine_table.csv"';

-- Show imported data
SELECT *
FROM vine_table
LIMIT 20;

-- Select reviews with 20 or more votes
SELECT *
INTO vine_votes
FROM vine_table
WHERE total_votes>=20;

-- Show table with entries with 20 or more votes
SELECT *
FROM vine_votes
LIMIT 20;

-- Select reviews with 50% or more helpful votes
SELECT *
INTO helpful_votes
FROM vine_votes
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

-- Show table with helpful entries > 50%
SELECT *
FROM helpful_votes
LIMIT 20;

-- Select paid vine reviews
SELECT *
INTO paid_vines
FROM helpful_votes
WHERE vine = 'Y';

-- Show paid vines
SELECT *
FROM paid_vines

-- Select unpaid vine reviews
SELECT *
INTO unpaid_vines
FROM helpful_votes
WHERE vine='N';

-- Show unpaid vines
SELECT *
FROM unpaid_vines
LIMIT 20;

-- Paid 5 star review analysis
WITH paid_analysis AS (
	-- Created the review type column to merge the data
	WITH paid_count AS (
		SELECT COUNT(review_id) as paid_review_count,
		'Paid' as review_type
		FROM paid_vine
	),
	paid_five_stars AS (
		SELECT COUNT(review_id) as five_star_count,
		'Paid' as review_type
		FROM paid_vine
		WHERE star_rating = 5
	)
	SELECT paid_count.paid_review_count,
	paid_five_stars.five_star_count as paid_five_star_review_count,
	CONCAT(ROUND(CAST(paid_five_stars.five_star_count AS FLOAT)/CAST(paid_count.paid_review_count AS FLOAT)*100),
		  '%') AS percentage_of_five_star_reviews,
	'final' as summary_type
	FROM paid_count 
	FULL JOIN paid_five_stars
	ON paid_count.review_type = paid_five_stars.review_type
),
-- unpaid 5 star review analysis
unpaid_analysis AS (
	-- Created the review type column to merge the data
	WITH unpaid_count AS (
		SELECT COUNT(review_id) as unpaid_review_count,
		'unpaid' as review_type
		FROM unpaid_vine
	),
	unpaid_five_stars AS (
		SELECT COUNT(review_id) as five_star_count,
		'unpaid' as review_type
		FROM unpaid_vine
		WHERE star_rating = 5
	)
	SELECT unpaid_count.unpaid_review_count,
	unpaid_five_stars.five_star_count as unpaid_five_star_review_count,
	CONCAT(ROUND(CAST(unpaid_five_stars.five_star_count AS FLOAT)/CAST(unpaid_count.unpaid_review_count AS FLOAT)*100),
		  '%') AS percentage_of_five_star_reviews,
	'final' as summary_type
	FROM unpaid_count 
	FULL JOIN unpaid_five_stars
	ON unpaid_count.review_type = unpaid_five_stars.review_type
)
SELECT paid_analysis.paid_review_count, 
	paid_analysis.paid_five_star_review_count,
	paid_analysis.percentage_of_five_star_reviews as percentage_of_5_star_paid_reviews, 
	unpaid_analysis.unpaid_review_count,
	unpaid_analysis.unpaid_five_star_review_count,
	unpaid_analysis.percentage_of_five_star_reviews as percentage_of_5_star_unpaid_reviews
INTO full_vine_analysis
FROM paid_analysis
FULL JOIN unpaid_analysis
ON paid_analysis.summary_type = unpaid_analysis.summary_type;

-- Show the resulting analysis
SELECT *
FROM full_vine_analysis;

-- Create new table to display results in a clearer way
CREATE TABLE IF NOT EXISTS vine_summary (
  vine_type TEXT,
  total_review_count INTEGER,
  five_star_review_count INTEGER,
  five_star_percentage TEXT
);

-- Insert paid data into new summary
INSERT INTO vine_summary
SELECT
	'Paid', 
	fv.paid_review_count, 
	fv.paid_five_star_review_count, 
	fv.percentage_of_5_star_paid_reviews
FROM full_vine_analysis AS fv;

-- Insert unpaid data into new summary
INSERT INTO vine_summary
SELECT
	'Unpaid', 
	fv.unpaid_review_count, 
	fv.unpaid_five_star_review_count, 
	fv.percentage_of_5_star_unpaid_reviews
FROM full_vine_analysis AS fv;

SELECT * FROM vine_summary