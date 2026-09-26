USE data_jobs;


-- Aggregate Function
SELECT
    COUNT(*)
FROM
    job_postings_fact;


-- Window Functions
SELECT
    job_id,
    COUNT(*) OVER()
FROM
    job_postings_fact;


-- Partiation by
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG (salary_hour_avg)OVER(PARTITION BY job_title_short) AS salary_hour_avg_per_job_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL;


-- Rank
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;

-- Order by, Partaion by

SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS avg_hour
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;

-- Row_number() - provide a new job_id

SELECT
    *,
    ROW_NUMBER() OVER(
        ORDER BY job_posted_date
    )
FROM
    job_postings_fact
ORDER BY
    job_posted_date
LIMIT 20;

-- LAG() - Time Based Comparison of company yearly salary

SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS prev_job_posting,
    salary_year_avg - LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change

FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;
