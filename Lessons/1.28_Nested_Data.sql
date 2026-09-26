-- Array Intro
SELECT['Python', 'SQL', 'R'] AS skills_array;

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;





-- STRUCT
SELECT  { skill: 'python', type: 'programming' } AS skill_struct;

WITH skill_struct AS (
SELECT
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s
)
SELECT
    s.skill,
    s.type
FROM
    skill_struct;


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    ) AS z
FROM skill_table;



-- Array of Structs
SELECT
    [
        {skill: 'python', type: 'programming'},
        {skill: 'sql', type: 'query language'}
    ] AS array_of_structs ;


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query language'
    UNION ALL
    SELECT 'r', 'programming'
), skills_array_struct AS (
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    ORDER BY skills) AS z
FROM skill_table
)
SELECT
    z[1],
    z[2],
    z[3]
FROM skills_array_struct;

-- Mapping

WITH skill_map AS (
    SELECT MAP
        {'skill':'python', 'type':'programming'} AS skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM skill_map;

-- JSON
WITH raw_skill_json AS (
    SELECT
        '{"skill":"python","type":"programming"}'::JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill :=JSON_EXTRACT_STRING(skill_json, '$.skill'),
        type :=JSON_EXTRACT_STRING(skill_json, '$.type')
    ) AS json_extract
FROM
    raw_skill_json;

-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM
    job_postings_fact jpf
LEFT JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
WHERE
    salary_year_avg IS NOT NULL
GROUP BY ALL;


-- Analyze the median salary per skill

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC
LIMIT 40;


-- Array of Structs - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, skills and type in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills)
    ) AS skill_type
FROM
    job_postings_fact jpf
LEFT JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
WHERE
    salary_year_avg IS NOT NULL
GROUP BY ALL;

-- Analyze the median salary per type of skill

WITH flat_skills_struct AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skill_type) AS skill
    FROM
        job_skills_array_struct
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills_struct
GROUP BY skill
ORDER BY median_salary DESC
LIMIT 40;