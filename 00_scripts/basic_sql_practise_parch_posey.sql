

SELECT id, account_id, occurred_at
FROM orders

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 15;


SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;


/* Write a query that displays the order ID, account ID, and total dollar amount 
for all the orders, sorted first by the account ID (in ascending order), and then 
by the total dollar amount (in descending order). */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;


/* Pulls the first 5 rows and all columns from the orders table that have a dollar 
amount of gloss_amt_usd greater than or equal to 1000.

Pulls the first 10 rows and all columns from the orders table that have a 
total_amt_usd less than 500. */

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

SELECT * 
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/* Filter the accounts table to include the company name, website, and the primary 
point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.*/

SELECT name, website, primary_poc 
FROM accounts
WHERE name = 'Exxon Mobil';


/* Write a query that finds the percentage of revenue that comes from poster paper 
for each order. You will need to use only the columns that end with _usd. 
(Try to do this without using the total column.) Display the id and account_id fields also.
*/

SELECT id, account_id, 
poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS percent_poster
FROM orders
LIMIT 10;

-- JOINS

-- Try pulling all the data from the accounts table, and all the data from the orders table.

SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/* Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, 
and the website and the primary_poc from the accounts table. */

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, 
accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
/* Notice this result is the same as if you switched the tables in the FROM and JOIN. 
Additionally, which side of the = a column is listed doesn't matter. */


-- Joining more than two tables - natural extension of ERD - primary and foreign key relationships

SELECT web_events.channel, accounts.name, orders.total
FROM web_events
JOIN accounts
ON web_events.id = accounts.id
JOIN orders 
ON accounts.id = orders.account_id;

-- alias version of above
SELECT w.channel, a.name, o.total
FROM web_events AS w
JOIN accounts a
ON w.id = a.id
JOIN orders o
ON a.id = o.account_id;

-- can also alias column names
Select t1.column1 AS aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 t2;


/* Provide a table for all web_events associated with account name of Walmart. 
There should be three columns. Be sure to include the primary_poc, time of the
event, and the channel for each event. Additionally, you might choose to add a 
fourth column to assure only Walmart events were chosen.*/

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.name = 'Walmart';

/* Provide a table that provides the region for each sales_rep along with their
associated accounts. Your final table should include three columns: the region 
name, the sales rep name, and the account name. Sort the accounts alphabetically
(A-Z) according to account name.*/ 

SELECT r.name region, sr.name sales_rep, a.name account
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
ORDER BY account;


/* Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. Your final 
table should have 3 columns: region name, account name, and unit price. A few 
accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing 
by zero. */

SELECT r.name region, a.name account, o.total_amt_usd / (o.total + 0.0001) unit_price
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id;
-- must be better way to remove null results than articiallty divide by a non zero number






-- Final quiz for JOINS lesson

/* Provide a table that provides the region for each sales_rep along with their 
associated accounts. This time only for the Midwest region. 

Your final table should include three columns: the region name, the sales rep 
name, and the account name. Sort the accounts alphabetically (A-Z) according to
account name.
*/ 

SELECT sr.name rep, r.name region, a.name account
FROM sales_reps sr
JOIN region r
ON sr.region_id = r.id
   AND r.name = 'Midwest'
LEFT JOIN accounts a
ON sr.id = a.sales_rep_id;

/* Provide a table that provides the region for each sales_rep along with their 
associated accounts. 

This time only for accounts where the sales rep has a first 
name starting with S and in the Midwest region. 

Your final table should include 
three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/

SELECT sr.name rep, r.name region, a.name account
FROM sales_reps sr
JOIN region r
ON sr.region_id = r.id
   AND r.name = 'Midwest'
   AND sr.name LIKE 'S%'
LEFT JOIN accounts a
ON sr.id = a.sales_rep_id
ORDER BY a.name;

/* Provide a table that provides the region for each sales_rep along with their 
associated accounts. 

This time only for accounts where the sales rep has a last name starting with K 
and in the Midwest region. 

Your final table should include three columns: the region name, the sales rep name,
and the account name. Sort the accounts alphabetically (A-Z) according to account
name.*/

SELECT sr.name rep, r.name region, a.name account
FROM sales_reps sr
JOIN region r
ON sr.region_id = r.id
   AND r.name = 'Midwest'
   AND sr.name LIKE '% K%'
LEFT JOIN accounts a
ON sr.id = a.sales_rep_id
ORDER BY a.name;

/* Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. 

However, you should only provide the results if the standard order quantity exceeds
100. 

Your final table should have 3 columns: region name, account name, and unit price. 

In order to avoid a division by zero error, adding .01 to the denominator here 
is helpful total_amt_usd/(total+0.01).*/

-- starting from JOIN in solution - has the same one throughout from Q1 
SELECT r.name region, a.name account, o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps sr
   ON r.id = sr.region_id
LEFT JOIN accounts a
   ON sr.id = a.sales_rep_id
LEFT JOIN orders o
   ON a.id = o.account_id
WHERE o.standard_qty > 100;



/* Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. 

However, you should only provide the results if the standard order quantity exceeds 
100 and the poster order quantity exceeds 50. 

Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the smallest unit price first. 

In order to avoid a division by zero error, adding .01 to the denominator here 
is helpful (total_amt_usd/(total+0.01).
*/

SELECT r.name region, a.name account, o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps sr
   ON r.id = sr.region_id
LEFT JOIN accounts a
   ON sr.id = a.sales_rep_id
LEFT JOIN orders o
   ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;




/* Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. 

However, you should only provide the results if the standard order quantity 
exceeds 100 and the poster order quantity exceeds 50. 

Your final table should have 3 columns: region name, account name, and unit price. 

Sort for the largest unit price first. In order to avoid a division by zero error,
adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).*/

SELECT r.name region, a.name account, o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps sr
   ON r.id = sr.region_id
LEFT JOIN accounts a
   ON sr.id = a.sales_rep_id
LEFT JOIN orders o
   ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price desc;

/* What are the different channels used by account id 1001? Your final table 
should have only 2 columns: account name and the different channels. 

You can try SELECT DISTINCT to narrow down the results to only the unique values.*/

SELECT DISTINCT a.name account, w.channel channel
FROM accounts a
LEFT JOIN web_events w
   ON a.id = w.account_id
WHERE a.id = 1001;


/* Find all the orders that occurred in 2015. 

Your final table should have 4 columns: occurred_at, account name, order total, 
and order total_amt_usd.*/

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
LEFT JOIN accounts a
   ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;



-- Working with DATEs

/* Find the sales in terms of total dollars for all orders in each year, 
ordered from greatest to least. Do you notice any trends in the yearly sales 
totals? */

SELECT DATE_TRUNC('year', o.occurred_at) AS year, 
       sum(o.total_amt_usd) AS total_dollars
  FROM orders o
  GROUP BY DATE_TRUNC('year', o.occurred_at)
  ORDER BY total_dollars desc

-- could group by column ID to streamline code  
SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;


/* Which month did Parch & Posey have the greatest sales in terms of total 
dollars? Are all months evenly represented by the dataset? */

SELECT DATE_TRUNC('month', o.occurred_at) AS month, 
       sum(o.total_amt_usd) AS total_dollars
  FROM orders o
  GROUP BY DATE_TRUNC('month', o.occurred_at)
  ORDER BY total_dollars desc
  
-- Could remove 2013 and 2017 as very small numbers as only one month in  each year

SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 
  
/* Which year did Parch & Posey have the greatest sales in terms of total 
number of orders? Are all years evenly represented by the dataset? */

SELECT DATE_TRUNC('year', o.occurred_at) AS year, 
       COUNT(o.total_amt_usd) AS total_orders
  FROM orders o
  GROUP BY DATE_TRUNC('year', o.occurred_at)
  ORDER BY total_dollars desc

/* Which month did Parch & Posey have the greatest sales in terms of total 
number of orders? Are all months evenly represented by the dataset? */ 

SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

/* In which month of which year did Walmart spend the most on gloss paper 
in terms of dollars? */

SELECT DATE_TRUNC('month', o.occurred_at) AS month, 
       sum(o.total_amt_usd) AS total_dollars
  FROM orders o
  LEFT JOIN accounts a
     ON o.account_id = a.id
     WHERE a.name = 'Walmart'
  GROUP BY DATE_TRUNC('month', o.occurred_at)
  ORDER BY total_dollars desc

-- lecture solution
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- CASE (WHEN) 

/* Write a query to display for each order, the account ID, total amount of 
the order, and the level of the order - ‘Large’ or ’Small’ - depending on if 
the order is $3000 or more, or smaller than $3000. */

SELECT a.id AS account_id, 
       o.total_amt_usd AS total_spend, 
       CASE WHEN o.total_amt_usd > 3000 THEN 'Large'
            ELSE 'Small' END AS order_level
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id;





