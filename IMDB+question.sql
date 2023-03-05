USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    COUNT(*)
FROM
    director_mapping;
-- director_mapping - 3867
SELECT 
    COUNT(*)
FROM
    genre;
-- genre - 14662
SELECT 
    COUNT(*)
FROM
    movie;
-- movie - 7997
SELECT 
    COUNT(*)
FROM
    names;
-- names - 25735
SELECT 
    COUNT(*)
FROM
    ratings;
-- ratings - 7997
SELECT 
    COUNT(*)
FROM
    role_mapping;
-- role_mapping - 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
Select 
	sum(CASE WHEN title is null THEN 1 ELSE 0 END) as title_null,
    sum(CASE WHEN year is null THEN 1 ELSE 0 END) as year_null,
    sum(CASE WHEN date_published is null THEN 1 ELSE 0 END) as date_published_null,
    sum(CASE WHEN duration is null THEN 1 ELSE 0 END) as duration_null,
    sum(CASE WHEN country is null THEN 1 ELSE 0 END) as country_null,
    sum(CASE WHEN worlwide_gross_income is null THEN 1 ELSE 0 END) as worlwide_gross_income_null,
    sum(CASE WHEN languages is null THEN 1 ELSE 0 END) as languages_null,
    sum(CASE WHEN production_company is null THEN 1 ELSE 0 END) as production_company_null
FROM
	movie;
-- 4 columns (i.e., country, worlwide_gross_income, languages, production_company) are the columns that has null values.


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	year,
    count(id) as number_of_movies
FROM 
	movie
GROUP BY
	year;
/*output
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|   2944			|
|	2019		|	2001			|
+---------------+-------------------+

*/

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY COUNT(id) DESC;
/*March month has highest number of movies released 
december month has lowest number of movies released
*/



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
WITH movies_USA_India as 
(SELECT count(*) as no_of_movies
FROM movie
WHERE year = '2019'
GROUP BY
	country
	HAVING COUNTRY REGEXP 'USA|India'
)
SELECT sum(no_of_movies)
FROM movies_USA_India;

/*
USA/india in 2019 is 1059
*/






/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT count(m.id) as movie_count,
		g.genre
FROM movie m
	inner join
    genre g
    on m.id = g.movie_id
GROUP BY
	g.genre
order by
	count(m.id) desc
    LIMIT 1;

/*Drama has the highest number of movies(4285) produced overall*/






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movie_1_genre as (
SELECT DISTINCT m.id,
	count(g.genre)
FROM movie m
	inner join
    genre g
    on m.id = g.movie_id
GROUP BY
	 m.id
    HAVING count(g.genre) = 1)
SELECT count(*) FROM movie_1_genre;
-- 3289 movies have single genre








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	g.genre,
    avg(m.duration) as average_duration
FROM movie as m
	inner join
    genre as g
    on m.id = g.movie_id
GROUP BY
    g.genre;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
		g.genre,
        count(m.id) as movie_count,
        rank() over (order by count(m.id) desc) as genre_rank
FROM movie m
	inner join
    genre g
    on m.id = g.movie_id
GROUP BY
	g.genre
order by
	count(m.id) desc;
-- Thriller is in rank 3



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT min(avg_rating) as min_avg_rating,
		max(avg_rating) as max_avg_rating,
        min(total_votes) as min_total_votes,
        max(total_votes) as max_total_votes,
        min(median_rating) as min_median_rating,
        max(median_rating) as max_median_rating
FROM ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT 
	m.title,
    r.avg_rating,
    rank() over(order by r.avg_rating desc) as movie_rank
FROM
	movie as m
    inner join
		ratings as r
        on m.id = r.movie_id
ORDER BY
	r.avg_rating desc
LIMIT 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
	r.median_rating,
	count(m.id) as movie_count
FROM 
	movie as m
    inner join
		ratings as r
        on m.id = r.movie_id
GROUP BY
	r.median_rating
ORDER BY
	count(m.id) desc;
	

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
    count(id) as movie_count,
    rank() over(order by count(id) desc) as prod_company_rank
FROM 
	movie
WHERE id in 
	(
		SELECT movie_id
        From ratings
        WHERE avg_rating > 8
    )
GROUP BY
	production_company
    HAVING production_company is not null
ORDER BY
	count(id) desc;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
		count(m.id) as movie_count
FROM
	movie as m
    inner join
		genre as g
        on m.id = g.movie_id
        inner join
			ratings as r
			on m.id = r.movie_id
WHERE 
	m.year=2017 and 
	month(m.date_published) = 3 and 
    m.country regexp 'USA' and 
    r.total_votes > 1000
GROUP BY
	g.genre
ORDER BY
	count(m.id) desc;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below

SELECT 
	m.title,
    r.avg_rating,
    g.genre
FROM
	movie as m
    inner join
		ratings as r
        on m.id = r.movie_id
        inner join
			genre as g
            on m.id = g.movie_id
WHERE
	m.title regexp '^The' and 
    r.avg_rating > 8
GROUP BY
	g.genre,
    m.title;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	count(m.id),
    m.date_published
FROM 
	movie as m
    inner join
		ratings as r
        on m.id = r.movie_id
WHERE 
	r.median_rating = 8
GROUP BY
	m.date_published
    HAVING m.date_published between '2018-04-01' and '2019-04-01'
ORDER BY
	m.date_published;
			

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH German_votes as
(
SELECT 
	m.languages,
    sum(r.total_votes) as German_votes
FROM 
	movie as m
    inner join
		ratings as r
        on m.id = r.movie_id
WHERE m.languages regexp 'German'
GROUP BY
	m.languages
)
SELECT sum(German_votes) 
FROM German_votes;
-- 4421525 votes for german movies
WITH Italian_votes as 
(
SELECT 
	m.languages,
    sum(r.total_votes) as Italian_votes
FROM 
	movie as m
    inner join
		ratings as r
        on m.id = r.movie_id
WHERE m.languages regexp 'Italian'
GROUP BY
	m.languages
)	
SELECT 
    sum(Italian_votes)
FROM 
	Italian_votes;

-- 2559540 votes for italian movies

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	sum(CASE WHEN name is null THEN 1 ELSE 0 END) as name_nulls,
    sum(CASE WHEN height is null THEN 1 ELSE 0 END) as height_nulls,
    sum(CASE WHEN date_of_birth is null THEN 1 ELSE 0 END) as date_of_birth_nulls,
    sum(CASE WHEN known_for_movies is null THEN 1 ELSE 0 END) as known_for_movies_nulls
FROM 
	names;






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genre as (
	SELECT g.genre,
			count(g.movie_id)
	FROM
		genre g
		INNER JOIN
			ratings as r
			on g.movie_id = r.movie_id
	WHERE r.avg_rating > 8
	GROUP BY 
		g.genre
	ORDER BY
		count(g.movie_id) desc
	LIMIT 3
)    

		

SELECT n.name as director_name,
		count(m.id) as movie_count,
        g.genre
FROM
	movie as m
    INNER JOIN
		genre g
        on m.id = g.movie_id
        INNER JOIN
        ratings as r
        on m.id = r.movie_id
    INNER JOIN
		director_mapping as dm
        on m.id = dm.movie_id
        INNER JOIN
			names as n
            on dm.name_id = n.id
WHERE r.avg_rating > 8 and
		g.genre in 
		(SELECT genre
		FROM top_genre
		)
GROUP BY
	n.name
ORDER BY
	count(m.id) desc
LIMIT 3;








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name as actor_name,
	count(m.id) as movie_count
FROM 
	movie as m
        INNER JOIN
			role_mapping as rm
            on m.id = rm.movie_id
            INNER JOIN
				names as n
                on rm.name_id = n.id
WHERE m.id in 
		(SELECT movie_id 
		FROM ratings 
        WHERE median_rating >= 8) and 
	rm.category = 'actor'
GROUP BY
	n.id
ORDER BY
	count(m.id) desc
LIMIT 2;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	m.production_company,
    sum(r.total_votes) as vote_count,
    Rank() over( order by sum(r.total_votes) desc) as Prod_company_rank
FROM
	movie as m
    INNER JOIN
		ratings as r
        on m.id = r.movie_id
        
GROUP BY
	m.production_company
ORDER BY
	sum(r.total_votes) desc
LIMIT 3;









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name as actor_name,
		sum(r.total_votes) as total_votes,
		count(m.id) as movie_count,
        r.avg_rating as actor_avg_rating,
        RANK() over(ORDER BY r.avg_rating desc) as actor_rank
FROM movie as m
	INNER JOIN
		ratings as r
        on m.id = r.movie_id
	INNER JOIN
    role_mapping as rm
    on m.id = rm.movie_id
		INNER JOIN
        names as n
        on rm.name_id = n.id
WHERE m.id in 
	(
		SELECT id FROM movie WHERE country regexp 'INDIA'
    ) and 
	rm.category = 'actor' 
GROUP BY 
	rm.name_id
HAVING count(m.id) >=5
ORDER BY
	r.avg_rating desc;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH hindi_actress as (
SELECT m.id as movie_id,
	m.languages as languages,
    m.country,
    n.name as actress_name
From movie as m
	INNER JOIN
    role_mapping as rm
    on m.id = rm.movie_id
		INNER JOIN
        names as n
        on rm.name_id = n.id
Where 
	m.languages regexp 'Hindi' and 
    rm.category = 'actress'

    )		

SELECT ha.actress_name,
		sum(r.total_votes) as total_votes,
		count(ha.movie_id) as movie_count,
        round(avg(r.avg_rating),2) as actress_avg_rating,
        RANK() over(ORDER BY avg(r.avg_rating) desc) as actress_rank
FROM hindi_actress as ha
	INNER JOIN
		ratings as r
        on ha.movie_id = r.movie_id
WHERE ha.country regexp 'India'
GROUP BY 
	ha.actress_name
HAVING 
    count(ha.movie_id) >= 3 
ORDER BY
	avg(r.avg_rating) desc
LIMIT 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
	m.title,
    (CASE 
    WHEN r.avg_rating >8 THEN 'Superhit Movies'
    WHEN r.avg_rating between 7 and 8  THEN 'Hit movies'
    WHEN r.avg_rating between 5 and 7  THEN 'One-time-watch Movies'
    ELSE
    'Flop Movies'
    END) as movie_category
FROM
	movie as m
    INNER JOIN
		genre as g
        on m.id = g.movie_id
        INNER JOIN
			ratings as r
            on m.id = r.movie_id
WHERE
	g.genre regexp 'thriller|Thriller'
GROUP BY
		m.title;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT g.genre,
		round(avg(m.duration),1) as avg_duration,
        SUM(round(avg(m.duration),1)) OVER(order by round(avg(m.duration),1)) as running_total_duration,
         AVG(round(avg(m.duration),1)) OVER(order by round(avg(m.duration),1)) as moving_avg_duration
FROM 
	movie as m
    INNER JOIN
		genre g
        on m.id = g.movie_id
GROUP BY
	g.genre
ORDER BY
	round(avg(m.duration),1);





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
SELECT 
	 (CASE 
            WHEN worlwide_gross_income regexp 'INR' THEN replace(worlwide_gross_income,'INR ','')
            WHEN worlwide_gross_income regexp '$' THEN replace(worlwide_gross_income,'$ ','')
            ELSE
				worlwide_gross_income
			END) as worldwide_gross_income
FROM movie;

CREATE VIEW top_genre as (
	SELECT g.genre
	FROM 
	movie as m
	INNER JOIN
		genre as g
		on m.id = g.movie_id
	GROUP BY
		g.genre
	ORDER BY
		count(m.id) desc
	LIMIT 3
);
WITH standardised_gross as (
SELECT *,
	 (CASE 
            WHEN worlwide_gross_income regexp 'INR' 
            THEN cast(replace(worlwide_gross_income,'INR ','') as float) * 0.012
            WHEN worlwide_gross_income regexp '$' THEN cast(replace(worlwide_gross_income,'$ ','') as float)
            ELSE
				cast(worlwide_gross_income as float)
			END) as worldwide_gross_income
FROM movie
WHERE
	worlwide_gross_income is not null
)
SELECT 
	genre,
    s.year,
    s.title as movie_name,
    sum(s.worldwide_gross_income) as worldwide_gross_income,
	rank() over(order by sum(s.worldwide_gross_income) desc) as movie_rank
FROM
	standardised_gross as s
    INNER JOIN
		genre as g
        on s.id = g.movie_id
WHERE g.genre in  	
	(SELECT genre
	FROM 
	top_genre
    )
GROUP BY
	s.year
ORDER BY
	sum(s.worldwide_gross_income) desc
LIMIT 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	count(id)as movie_count,
    rank() over(order by count(id) desc) as prod_comp_rank
FROM
	movie
WHERE
	POSITION(',' in languages) > 0 and    
    id in (
		SELECT m.id 
        FROM movie as m 
			INNER JOIN ratings as r 
            on m.id = r.movie_id 
        WHERE r.median_rating >= 8)
GROUP BY
	production_company
HAVING production_company is not null
ORDER BY
	count(id) desc
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name as actress_name,
    sum(r.total_votes) as total_votes,
    count(m.id) as movie_count,
    r.avg_rating as actress_avg_rating,
    rank() over(order by count(m.id) desc) as actress_rank
FROM
	movie as m
    INNER JOIN 
		ratings as r
        on m.id = r.movie_id
        INNER JOIN
			role_mapping as rm
            on m.id = rm.movie_id
            INNER JOIN
				names as n
                on rm.name_id = n.id
WHERE
	r.avg_rating > 8 and
    rm.category = 'actress' and
	m.id in (SELECT movie_id from genre where genre regexp 'Drama')
GROUP BY
	n.name
ORDER BY
	count(m.id) desc
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_movie_date as 
(SELECT 
	dm.name_id as Director_id,
    n.name as Director_name,
    m.id as movie_id,
    m.date_published,
    m.duration as duration,
    Lead(m.date_published,1) over(partition by dm.name_id order by m.date_published ) as next_movie_date
FROM
	movie as m
    INNER JOIN
    director_mapping as dm
		on m.id = dm.movie_id
        INNER JOIN
			names as n
            on dm.name_id = n.id

order by
	n.name,
    m.date_published
),
date_diff as 
(SELECT *,
	(case when next_movie_date is null then 0 else datediff(next_movie_date,date_published) end) as date_diff
FROM next_movie_date)
SELECT dd.Director_id,
	dd.Director_name,
    count(dd.movie_id) as number_of_movies,
    round(avg(dd.date_diff)) as avg_inter_movie_days,
    r.avg_rating,
    r.total_votes,
    min(r.avg_rating) as min_rating,
    max(r.avg_rating) as max_rating,
    sum(dd.duration) as total_duration
FROM date_diff as dd
	INNER JOIN
		ratings as r 
        on dd.movie_id = r.movie_id
Group by Director_id
HAVING avg_inter_movie_days>0
ORDER BY
	count(dd.movie_id) desc
LIMIT 9;
