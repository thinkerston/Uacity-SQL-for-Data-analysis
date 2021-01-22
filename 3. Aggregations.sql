/*Aggregations Questions*/
--Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) as poster_amount
FROM orders


-- Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) as standard_amount
FROM orders

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) as total_dollars
FROM orders

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

--Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd) / COUNT(standard_qty) as price_unit
FROM orders

/*Questions: MIN, MAX, & AVERAGE*/
-- When was the earliest order ever placed? You only need to return the date.
SELECT MAX(occurred_at) as last_occurred_at
FROM orders

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at DESC
LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX (occurred_at) as last_occurred
FROM web_events;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, 
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, 
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) AS standard_avg, AVG(gloss_qty) AS gloss_avg, AVG(poster_qty) as poster_avg
FROM orders


-- Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/*GROUP BY*/

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT orders.occurred_at, accounts.name
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
ORDER BY orders.occurred_at
LIMIT 1


-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT accounts.name, SUM(total_amt_usd) sum_orders
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY accounts.name;


--Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT accounts.name, MAX(web_events.occurred_at) max_occurred_at, web_events.channel
FROM accounts
JOIN web_events
ON web_events.account_id = accounts.id
GROUP BY accounts.name, web_events.channel
LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(web_events.channel) number_channel_used
FROM web_events
GROUP BY channel;

-- Who was the primary contact associated with the earliest web_event?
SELECT MIN(web_events.occurred_at) first_web_event, sales_reps.name 
FROM accounts
JOIN web_events
ON web_events.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name
LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT MIN(orders.total_amt_usd), accounts.name
FROM accounts
JOIN orders
ON orders.account_id = accounts.id
GROUP BY accounts.name
LIMIT 1;

--Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT COUNT(sales_reps.name) number_sales_reps, region.name 
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
GROUP BY region.name