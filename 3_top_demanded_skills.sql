/*
Question: What are the most in-demand skills for data role?
- Identify the top 10 in-demand skills for a data roles.
- Focus on all job postings.
- Why? Retrieves the top 10 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/
WITH data_roles AS 
(
    SELECT
        j.job_id
    FROM
        job_postings_fact AS j
    WHERE
        j.job_title_short IN ('Data Analyst', 'Data Scientist', 'Data Engineer', 'Data Architect')
        AND j.search_location IN ('Egypt')
)
SELECT
    s.skills,
    COUNT(*) AS skill_count
FROM
    data_roles AS dr
JOIN
    skills_job_dim sj ON dr.job_id = sj.job_id
JOIN
    skills_dim s ON sj.skill_id = s.skill_id
GROUP BY
    s.skills
ORDER BY
    skill_count DESC
LIMIT 10;