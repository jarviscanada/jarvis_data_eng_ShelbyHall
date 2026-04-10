SQL
-- Identify hosts with below-average memory capacity for resource planning
SELECT hi.id,
       hi.hostname,
       hi.total_mem,
       AVG(hi.total_mem) OVER () AS avg_memory
FROM host_info hi
WHERE hi.total_mem < (SELECT AVG(total_mem) FROM host_info)
ODER BY hi.total_mem ASC;

-- Identify hosts with missing or delayed metric reporting within last 2 minutes
SELECT hi.hostname,
       MAX(hu."timestamp") AS last_reported,
       NOW() - MAX(hu."timestamp") AS time_since_last_report
FROM host_info hi
LEFT JOIN host_usage hu
    ON hu.host_id = hi.id
GROUP BY hi.hostname
HAVING MAX(hu."timestamp") < NOW() - INTERVAL '2 minutes'
    OR MAX(hu."timestamp") IS NULL
ORDER BY last_reported ASC NULLS FIRST;


