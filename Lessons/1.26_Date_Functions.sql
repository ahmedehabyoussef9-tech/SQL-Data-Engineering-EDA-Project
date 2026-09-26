-- Extract Statement

SELECT
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact;

-- DATE_TRUNC

SELECT
    DATE_TRUNC('month', job_posted_date) AS month,
    COUNT(*) AS postings
FROM job_postings_fact
GROUP BY month
ORDER BY month;

SELECT
    job_posted_date,
    job_posted_date::DATE AS Date,
    job_posted_date::TIME AS Time,
    job_posted_date::TIMESTAMP AS Timestamp,
    job_posted_date::TIMESTAMPTZ AS Timestamptz
FROM job_postings_fact;

