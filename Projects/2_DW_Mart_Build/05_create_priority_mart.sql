-- Step 5: Mart - Create priority roles mart

DROP SCHEMA IF EXISTS priority_mart CASCADE;

CREATE SCHEMA priority_mart;

SELECT '=== Loading Roles for Priority Mart ===' AS info;
CREATE OR REPLACE TABLE priority_mart.priority_roles(
    role_id         INT     PRIMARY KEY,
    role_name       VARCHAR,
    priority_lvl    INT
);

INSERT INTO priority_mart.priority_roles(role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Scientist', 2),
    (2, 'Data Analyst', 1),
    (3, 'Business Analyst', 4),
    (4, 'Data Engineer', 2),
    (5, 'Cloud Engineer', 4),
    (6, 'Software Engineer', 3),
    (7, 'Machine Learning Engineer', 2),
    (8, 'Senior Data Analyst', 2),
    (9, 'Senior Data Engineer', 1);

SELECT *
FROM priority_mart.priority_roles;


-- ------------------------------------------
SELECT '=== Loading Snapshot for Priority Mart ===' AS info;

CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot (
    job_id              INT PRIMARY KEY,
    job_title_short     VARCHAR(40),
    company_name        VARCHAR(40),
    job_posted_date     TIMESTAMP,
    salary_year_avg     DOUBLE,
    priority_lvl        INT,
    updated_at          TIMESTAMP
);

INSERT INTO priority_mart.priority_jobs_snapshot
(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP
FROM 
    job_postings_fact jpf
LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles pr
    ON jpf.role_id = pr.role_id;

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;