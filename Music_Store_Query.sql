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

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
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

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
 
 SELECT TOP 10 artist.artist_id, artist.name, COUNT(artist.artist_id) AS Total_track_count FROM artist
 JOIN album ON artist.artist_id = album.artist_id
 JOIN track ON album.album_id = track.album_id
 JOIN genre ON track.genre_id = genre.genre_id
 WHERE genre.genre_id = 1
 GROUP BY artist.artist_id, artist.name
 ORDER BY Total_track_count DESC;

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT * FROM TRACK

SELECT track.name, track.milliseconds FROM track
WHERE track.milliseconds>(
SELECT AVG(milliseconds) FROM track)
ORDER BY track.milliseconds DESC;
