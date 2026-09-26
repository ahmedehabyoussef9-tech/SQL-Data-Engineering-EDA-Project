CREATE TABLE IF NOT EXISTS staging.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INTEGER
);

INSERT INTO staging.priority_roles (role_id, role_name, priority_lvl)
VALUES
    (401, 'Software Engineer', 3);

SELECT *
FROM staging.priority_roles;



-- --------------------------------------------

-- priority_jobs_snapshot_INTITAL

CREATE OR REPLACE TABLE main.priority_jobs_snapshot (
    job_id              INT PRIMARY KEY,
    job_title_short     VARCHAR(40),
    company_name        VARCHAR(40),
    job_posted_date     TIMESTAMP,
    salary_year_avg     DOUBLE,
    priority_lvl        INT,
    updated_at          TIMESTAMP
);

INSERT INTO main.priority_jobs_snapshot
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
    r.priority_lvl,
    CURRENT_TIMESTAMP
FROM
    data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles r
    ON jpf.job_title_short = r.role_name;

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;

SELECT *
FROM main.priority_jobs_snapshot;




-- ---------------------------------------------------------





-- ---------------------------------------------------------



-- Create TEMP Source Table
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.job_postings_fact jpf
LEFT JOIN data_jobs.company_dim cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles r
    ON jpf.job_title_short = r.role_name;


-- UPDATE Statement
UPDATE main.priority_jobs_snapshot AS tgt
SET 
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at
FROM src_priority_jobs AS src
WHERE tgt.job_id = src.job_id
    AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;

SELECT *
FROM main.priority_jobs_snapshot;

-- INSERT Statement

INSERT INTO main.priority_jobs_snapshot
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
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
FROM src_priority_jobs AS src


-- DELETE Statement

DELETE FROM main.priority_jobs_snapshot AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM src_priority_jobs AS src
    WHERE src.job_id = tgt.job_id
);



-- Final Check Query
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,

    MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;