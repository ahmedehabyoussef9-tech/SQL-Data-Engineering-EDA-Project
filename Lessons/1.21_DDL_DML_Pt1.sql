-- .read Lessons\1.21_DDL_DML_Pt1.sql
-- USE data_jobs;
CREATE DATABASE IF NOT EXISTS job_mart;

SHOW DATABASES;

-- DROP DATABASE IF EXISTS job_mart;

SELECT *
FROM information_schema.schemata;

USE job_mart;

CREATE SCHEMA IF NOT EXISTS staging;

-- DROP IF EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(40)
);

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'job_mart';

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (101, 'Data Engineer'),
    (102, 'Senior Data Engineer'),
    (201, 'Data Analyst'),
    (202, 'Senior Data Analyst'),
    (301, 'Data Scientist'),
    (302, 'Senior Data Scientist');

SELECT *
FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles
ADD column preferred_roles boolean;

ALTER TABLE staging.preferred_roles
DROP TABLE staging.preferred_roles;

UPDATE staging.preferred_roles
SET preferred_roles = TRUE
WHERE role_id = 101 OR role_id = 102;

UPDATE staging.preferred_roles
SET preferred_roles = FALSE
WHERE role_id != 101 AND role_id != 102;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_roles TO priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN  priority_roles TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INT;

SELECT *
FROM staging.priority_roles;

UPDATE staging.priority_roles
SET priority_lvl = 4
WHERE role_id = 302;