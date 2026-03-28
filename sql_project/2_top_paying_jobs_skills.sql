/*
Question: What skills are required for the top-paying data ?
- Use the top 10 highest-paying data roles from first query.
- Add the specific skills required for these roles.
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
helping job seekers understand which skills to develop that align with top salaries
*/
WITH top_paying_jobs AS 
(
    SELECT
        j.job_id,
        j.job_title_short,
        j.salary_year_avg,
        j.job_location,
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
    LIMIT 10
)
SELECT
    tpj.*,
    s.skills
FROM
    top_paying_jobs AS tpj
JOIN
    skills_job_dim sj ON tpj.job_id = sj.job_id
JOIN
    skills_dim s ON sj.skill_id = s.skill_id
ORDER BY
    tpj.salary_year_avg DESC; 

/*
Here's the breakdown of the most demanded skills for data roles in 2023, based on job postings in Egypt:
SQL is leading with a bold count of 9.
Python follows closely with a bold count of 7.
Other skills like Scala, Java, AWS, Redshift, Airflow, NoSQL, and Excel show varying degrees of demand.
This insight highlights the critical skills that employers are looking for in data jobs, 
guiding job seekers on which skills to prioritize for career growth in the data field.
*/