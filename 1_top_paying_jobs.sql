/*
Question: What are the top-paying jobs in data roles?
- Identify the top 10 highest-paying data roles that are available in Egypt, based on the average yearly salary.
- Focuses on job postings with specified salaries (remove nulls)
- BONUS: Include company names of top 10 roles
- Why? Highlight the top-paying opportunities for data role, offering insights into employment options.
*/
SELECT
    j.job_id,
    j.job_title,
    j.job_title_short,
    j.salary_year_avg,
    j.job_location,
    j.job_posted_date,
    j.search_location,
    c.name AS company_name
FROM
    job_postings_fact AS j
JOIN 
    company_dim c ON j.company_id = c.company_id
WHERE
    j.search_location IN ('Egypt')
    AND j.salary_year_avg IS NOT NULL
    AND j.job_title_short IN ('Data Analyst', 'Data Scientist', 'Data Engineer', 'Data Architect')
ORDER BY
    j.salary_year_avg DESC
LIMIT 10;