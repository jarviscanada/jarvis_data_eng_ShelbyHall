-- Show table schema
\d+ retail;

-- Show first 10 rows

SELECT * FROM retail limit 10;

-- Check # of records

SELECT COUNT(*) FROM retail;

-- Number of clients (e.g. unique client ID)

SELECT COUNT(DISTINCT customer_id) FROM retail;

-- Invoice date range (e.g. max/min dates)

SELECT MAX(invoice_date), MIN(invoice_date) FROM retail;

-- Number of SKU/merchants (e.g. unique stock code)

SELECT COUNT(DISTINCT stock_code) FROM retail;

-- Calculate average invoice amount excluding invoices with a negative amount (e.g. exclude cancelled orders)

SELECT AVG(invoice_total)
FROM(
	SELECT invoice_no, SUM(unit_price * quantity) AS invoice_total
	FROM retail
	GROUP BY invoice_no
	HAVING SUM(unit_price * quantity) > 0
) 	AS positive_invoices;

-- Calculate total revenue (e.g. sum of unit_price * quantity)

SELECT SUM(unit_price * quantity) FROM retail;

-- Calculate total revenue by YYYYMM

SELECT
	(EXTRACT(YEAR FROM invoice_date)::int * 100 + EXTRACT(MONTH FROM invoice_date)::int) AS yyyymm,
	SUM(unit_price * quantity) AS sum
FROM retail
GROUP BY yyyymm
ORDER BY yyyymm;




