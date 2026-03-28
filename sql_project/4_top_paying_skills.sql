/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for data roles.
- Focuses on roles with specified salaries in Egypt.
- Why? It reveals how different skills impact salary levels for data roles and 
    helps identify the most financially rewarding skills to acquire or improve.
*/
WITH skill_salary AS 
(
    SELECT
        s.skills,
        ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact AS j
    JOIN
        skills_job_dim sj ON j.job_id = sj.job_id
    JOIN
        skills_dim s ON sj.skill_id = s.skill_id
    WHERE
        j.search_location IN ('Egypt')
        AND j.salary_year_avg IS NOT NULL
        AND j.job_title_short IN ('Data Analyst', 'Data Scientist', 'Data Engineer', 'Data Architect')
    GROUP BY
        s.skills
)   
SELECT
    skills,
    avg_salary
FROM
    skill_salary
ORDER BY
    avg_salary DESC
LIMIT 25;