Use [Music DB];

/* Q1: Who is the senior most employee based on job title? */

SELECT TOP 1 first_name, last_name, title FROM employee
ORDER BY levels DESC;


/* Q2: Which countries have the most Invoices? */

SELECT * FROM INVOICE

SELECT COUNT(*) as Num_of_invoice, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY Num_of_Invoice DESC;


/* Q3: What are top 3 values of total invoice? */

SELECT TOP 3 
CAST(total AS DECIMAL (10,2)) AS Total 
FROM invoice
ORDER BY total DESC;


/* Q4: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT * FROM invoice

SELECT TOP 1 billing_city, CAST(sum(total) AS DECIMAL (10,2)) AS total_revenue FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC;

/* Q5: Who is the best customer? 
The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT TOP 1 
customer.customer_id, first_name, last_name, CAST(SUM(total) AS DECIMAL(10,2)) AS total 
FROM customer
JOIN invoice 
ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, first_name, last_name
ORDER BY total DESC;

/* Moderate Level */
/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*Mehod - 1*/

SELECT DISTINCT first_name, last_name, email
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/*Mehod - 2*/

SELECT DISTINCT first_name, last_name, email
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
 
 SELECT TOP 10 artist.artist_id, artist.name, COUNT(artist.artist_id) AS Total_track_count FROM artist
 JOIN album ON artist.artist_id = album.artist_id
 JOIN track ON album.album_id = track.album_id
 JOIN genre ON track.genre_id = genre.genre_id
 WHERE genre.genre_id = 1
 GROUP BY artist.artist_id, artist.name
 ORDER BY Total_track_count DESC;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT * FROM TRACK

SELECT track.name, track.milliseconds FROM track
WHERE track.milliseconds>(
SELECT AVG(milliseconds) FROM track)
ORDER BY track.milliseconds DESC;

/* Difficult Level */

/* Q1: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */

SELECT * FROM invoice
SELECT * FROM invoice_line
SELECT * FROM TRACK
SELECT * FROM ALBUM
SELECT * FROM ARTIST
SELECT * FROM customer

SELECT customer.customer_id, customer.first_name, customer.last_name, artist.name, SUM(total) FROM customer
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON track.album_id = album.album_id
JOIN artist ON album.artist_id = artist.artist_id
ORDER BY customer.customer_id;

WITH best_selling_artist AS(
	SELECT TOP 1 artist.artist_id AS artist_id, artist.name AS artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON  artist.artist_id = album.artist_id
	GROUP BY artist_id
	ORDER BY total_sales DESC
	)



/* Q2: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre 
with the highest amount of purchases.
Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */