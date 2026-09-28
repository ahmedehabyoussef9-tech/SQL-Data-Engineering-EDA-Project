-- Step 2: DW - Load data from CSV files into tables

SELECT '=== Loading company_dim Table ===' AS info;

INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true,
    HEADER=true);

SELECT '=== Loading skills_dim Table ===' AS info;

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true)
WHERE skills IS NOT NULL;

SELECT '=== Loading job_postings_fact Table ===' AS info;

INSERT INTO job_postings_fact (
    job_id,
    company_id,
    role_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_schedule_type,
    job_work_from_home,
    search_location,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
    )
SELECT
    j.job_id,
    j.company_id,
    r.role_id,
    j.job_title_short,
    j.job_title,
    j.job_location,
    j.job_via,
    j.job_schedule_type,
    j.job_work_from_home,
    j.search_location,
    j.job_posted_date,
    j.job_no_degree_mention,
    j.job_health_insurance,
    j.job_country,
    j.salary_rate,
    j.salary_year_avg,
    j.salary_hour_avg
FROM
    read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
    AUTO_DETECT=true,
    HEADER=true) AS j
INNER JOIN job_roles_dim AS r
    ON j.job_title_short = r.role_name;

SELECT '=== Loading skills_job_dim Table ===' AS info;

INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true);

    -- Verify data was loaded correctly
SELECT 'Company Dimension' AS table_name, COUNT(*) as record_count FROM company_dim
UNION ALL
SELECT 'Skills Dimension', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Dimension', COUNT(*) FROM skills_job_dim;

-- Show sample data
SELECT '=== Company Dimension Sample ===' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '=== Job Postings Fact Sample ===' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '=== Skills Job Bridge Sample ===' AS info;
SELECT * FROM skills_job_dim LIMIT 5;

SELECT '=== Roles Job Dimension Sample ===' AS info;
SELECT DISTINCT * FROM job_roles_dim
ORDER BY role_id;