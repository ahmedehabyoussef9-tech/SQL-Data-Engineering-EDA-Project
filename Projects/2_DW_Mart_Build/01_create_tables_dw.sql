-- Step 1: DW - Create star schema tables

DROP TABLE IF EXISTS skills_job_dim;
DROP TABLE IF EXISTS job_postings_fact;
DROP TABLE IF EXISTS skills_dim;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS job_roles_dim;

CREATE TABLE company_dim (
    company_id  INT PRIMARY KEY,
    name        VARCHAR
);

CREATE TABLE skills_dim (
    skill_id    INT PRIMARY KEY,
    skills      VARCHAR,
    type        VARCHAR
);

CREATE TABLE job_roles_dim (
    role_id   INTEGER PRIMARY KEY,
    role_name VARCHAR UNIQUE
);

INSERT INTO job_roles_dim (role_id, role_name)
VALUES
    (1, 'Data Scientist'),
    (2, 'Data Analyst'),
    (3, 'Business Analyst'),
    (4, 'Data Engineer'),
    (5, 'Cloud Engineer'),
    (6, 'Software Engineer'),
    (7, 'Machine Learning Engineer'),
    (8, 'Senior Data Analyst'),
    (9, 'Senior Data Engineer'),
    (10, 'Senior Data Scientist');

CREATE TABLE job_postings_fact (
    job_id                INT PRIMARY KEY,
    company_id            INT,
    role_id               INT,
    job_title_short       VARCHAR,
    job_title             VARCHAR,
    job_location          VARCHAR,
    job_via               VARCHAR,
    job_schedule_type     VARCHAR,
    job_work_from_home    BOOLEAN,
    search_location       VARCHAR,
    job_posted_date       TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance  BOOLEAN,
    job_country           VARCHAR,
    salary_rate           VARCHAR,
    salary_year_avg       DOUBLE,
    salary_hour_avg       DOUBLE,
    FOREIGN KEY (company_id) REFERENCES company_dim (company_id),
    FOREIGN KEY (role_id) REFERENCES job_roles_dim (role_id)
);

CREATE TABLE skills_job_dim (
    skill_id INT,
    job_id INT,
    PRIMARY KEY (skill_id, job_id),
    FOREIGN KEY (skill_id) REFERENCES skills_dim (skill_id),
    FOREIGN KEY (job_id) REFERENCES  job_postings_fact (job_id)
);

