SELECT
    table_name,
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'job_postings_fact'
ORDER BY data_type;

DESCRIBE job_postings_fact;

SELECT CAST('1W23' AS VARCHAR(10)) AS EMP_ID;

SELECT
    CAST(job_id AS VARCHAR(6) )||'-'|| CAST(company_id AS VARCHAR(6)) AS 'Job & Company ID', --"more" unique identifier
    CAST(job_work_from_home AS INT) AS 'Job Work From Home' , -- from boolean to numeric value
    CAST(job_posted_date AS DATE) AS 'Job Posted Date', -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS 'Salary Year AVG' -- from double to no decimal places
FROM
    job_postings_fact
WHERE
    job_work_from_home IS NOT NULL
AND salary_year_avg IS NOT NULL
LIMIT 10;