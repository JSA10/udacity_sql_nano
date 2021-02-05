
-- subquery practise - first subquery

/* stages - create inner query, test independently, name it, 
then wrap outer query to use inner's output */
SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY day, channel
	ORDER BY event_count DESC;

SELECT * 
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY day, channel
	ORDER BY event_count DESC) sub;
	
	
SELECT channel, AVG(event_count) AS avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_count
	FROM web_events
	GROUP BY day, channel) sub
	GROUP BY channel
	ORDER BY avg_event_count DESC;

-- Views examples 

-- Parch & Posey tables - focus a view on sales managers from north-east region
-- create view for north-east region 
CREATE VIEW north_east_reps
AS 
SELECT s.id, s.name AS sales_reps, r.name AS region
FROM sales_reps AS s
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Northeast';

SELECT * FROM north_east_reps LIMIT 100;


-- average price paid by region and account
CREATE VIEW avg_price_region_account
AS
SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

SELECT * FROM avg_price_region_account;


-- Subquery saved as a view - using first subquery example 
CREATE VIEW avg_web_events_channel
AS
SELECT channel, AVG(events) AS average_events
   FROM (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) as events
         FROM web_events 
         GROUP BY 1,2) sub
GROUP BY channel;

-- pull month level infromation from first order ever placed in orders table and then summarise avg qty for each paper type for that month
SELECT AVG(sub.standard_qty) avg_std_qty, AVG(sub.gloss_qty) avg_gloss_qty, AVG(sub.poster_qty) avg_poster_qty
FROM 
 (SELECT * 
	FROM orders o 
	WHERE DATE_TRUNC('month', occurred_at) = 
		(SELECT DATE_TRUNC('month', MIN(occurred_at)) as min_month
			FROM orders)
	ORDER BY o.occurred_at) sub
	;



-- combine the two tables - using second to filter the first
-- Selecting the most used channel for each account 
SELECT t3.name, t3.channel, t3.count
	FROM
		(SELECT accounts.name as name, web_events.channel as channel, Count(*) as count
			FROM accounts
			JOIN web_events ON accounts.id = Web_events.account_id
			GROUP BY 1, 2
			ORDER BY 1,3) t3
	JOIN (SELECT T1.name, Max(T1.count)
				FROM (
					SELECT accounts.name as name, web_events.channel as channel, Count(*) as count
						 FROM accounts
						 JOIN web_events ON accounts.id = Web_events.account_id
						 GROUP BY 1, 2
						 ORDER BY 1,3) as T1
				GROUP BY 1) t2
	ON t2.name = t3.name AND t2.max = t3.count
	ORDER BY t3.name, t3.count;




