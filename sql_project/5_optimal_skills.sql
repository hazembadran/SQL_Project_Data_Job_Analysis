/*
Answer: What are the most optimal skills to learn (high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for data roles.
- Concentrates on roles in Egypt with specified salaries.
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in the data field. 
*/
WITH skill_salary AS 
(
    SELECT
        s.skills,
        ROUND(AVG(j.salary_year_avg), 0) AS avg_salary,
        COUNT(*) AS skill_count
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
    avg_salary,
    skill_count
FROM
    skill_salary
ORDER BY
    skill_count DESC,
    avg_salary DESC
LIMIT 10;