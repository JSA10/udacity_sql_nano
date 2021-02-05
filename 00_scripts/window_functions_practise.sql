-- !window functions

--  create running total of standard_amt_usd in orders
-- over order time 
-- with no date truncation 
-- final table should have two columns
-- 1 with amount added for each row and 2 with running total

SELECT standard_amt_usd,
	SUM(standard_amt_usd) OVER 
		(ORDER BY occurred_at)
         AS cumulative_amt_usd
FROM orders;

/* Creating a Partitioned Running Total Using Window Functions

Now, modify your query from the previous quiz to include partitions. 

Still create a running total of standard_amt_usd (in the orders table) over 
order time, but this time, date truncate occurred_at by year and partition by 
that same year-truncated occurred_at variable. 

Your final table should have three columns: One with the amount being added for 
each row, one for the truncated date, and a final column with the running total 
within each year.
*/

SELECT DATE_TRUNC('year', occurred_at) AS Y,
       standard_amt_usd,
       SUM(standard_amt_usd) OVER 
		(PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at)
         AS cumulative_amt_usd
FROM orders;

-- combining many window functions 

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders
-- in this view - dense_rank is constant at 1 for all account_id values 
-- 


