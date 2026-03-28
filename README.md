# Egypt Data Job Market Analysis

An SQL-based analysis of the data job market in Egypt, exploring top-paying roles, in-demand skills, and the most strategic skills to learn for a career in data.

SQL queries used in this project: [sql_project folder](/sql_project/)

---

## Background

As someone entering the data field in Egypt, I built this project to answer a practical question: which skills and roles should I focus on? Rather than relying on global trends, I filtered the analysis specifically to the Egyptian job market to get locally relevant insights.

The dataset comes from [Luke Barousse's SQL Course](https://lukebarousse.com/sql) and contains real job postings with titles, salaries, locations, and required skills.

### Questions this project answers:

1. What are the top-paying data roles in Egypt?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data roles in Egypt?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

---

## Tools Used

**Database & Querying:** PostgreSQL, SQL

**IDE:** Visual Studio Code

**SQL Techniques:** JOINs, CTEs, Aggregations, Subqueries, Window Functions

**Version Control:** Git & GitHub

---

## The Analysis

### 1. Top-Paying Data Roles in Egypt

To identify the highest-paying roles, I filtered job postings to Egypt only, removed nulls, and focused on four core data roles: Data Analyst, Data Scientist, Data Engineer, and Data Architect.

```sql
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
```

**Results:**

| Job Title | Company | Salary (USD/year) |
|---|---|---:|
| Data Scientist | Visa | $157,500 |
| Data Engineer | Klivvr | $147,500 |
| Lead Data Scientist | Money Fellows | $106,440 |
| Data Engineer | Mondia Group | $96,773 |
| Data Engineer | Nawy Real Estate | $96,773 |
| Data Scientist | Mondia Group | $90,670 |
| Data Engineering Lead | Klivvr | $79,200 |
| Data Analyst | HEINEKEN | $75,550 |
| Data Scientist | Nawy Real Estate | $70,000 |
| Data Quality Engineer | Klivvr | $64,800 |

**Key findings:**
- Data Scientist and Data Engineer roles dominate the top 10, with the highest salary reaching $157,500 at Visa.
- The salary range across the top 10 spans from $64,800 to $157,500, showing significant variation even within senior roles.
- Klivvr appears three times in the top 10, making it one of the most active high-paying employers for data roles in Egypt.
- The only Data Analyst role in the top 10 is at HEINEKEN at $75,550, suggesting Data Scientist and Data Engineer roles command higher compensation in the Egyptian market.

---

### 2. Skills Required for Top-Paying Jobs

Using the top 10 results from query 1 as a CTE, I joined the skills tables to identify what employers require for high-paying data roles.

```sql
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
```

**Key findings:**
- SQL appears in 9 of the top 10 highest-paying job postings, making it the most consistently required skill for high-compensation roles.
- Python follows closely, appearing in 7 of the top 10 postings.
- Beyond the core two, skills like Scala, Java, AWS, Redshift, Airflow, NoSQL, and Excel appear across the remaining roles, reflecting the engineering-heavy nature of top-paying data work in Egypt.

---

### 3. Most In-Demand Skills for Data Roles in Egypt

This query identifies the skills appearing most frequently across all data role job postings in Egypt, regardless of salary.

```sql
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
```

**Results:**

| Skill | Demand Count |
|---|---:|
| Python | 664 |
| SQL | 632 |
| Tableau | 295 |
| Spark | 266 |
| Excel | 255 |
| AWS | 221 |
| Power BI | 215 |
| Azure | 191 |
| Java | 185 |
| R | 172 |

**Key findings:**
- Python edges out SQL as the most demanded skill overall in Egypt's data job market, with 664 vs 632 postings.
- The gap between the top two (Python, SQL) and the rest is significant — Tableau at 295 is less than half of Python's demand count.
- Cloud platforms (AWS, Azure) and big data tools (Spark) appear in the top 10, reflecting growing infrastructure requirements even in the Egyptian market.
- Both Power BI and Tableau appear, but Tableau leads by 80 postings.

---

### 4. Skills Associated with Higher Salaries in Egypt

This query calculates the average salary for each skill across Egypt-based data roles with specified salaries.

```sql
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
```

**Results (Top 10):**

| Skill | Average Salary (USD) |
|---|---:|
| SAS | $157,500 |
| Jupyter | $157,500 |
| Shell | $157,500 |
| Elasticsearch | $157,500 |
| MATLAB | $157,500 |
| Linux | $157,500 |
| C++ | $152,500 |
| Java | $124,637 |
| Cassandra | $119,085 |
| Hadoop | $116,667 |

**Key findings:**
- The top six skills all share the same average salary of $157,500, which corresponds to the Visa Data Scientist posting — meaning these skills are tied to a single high-salary role rather than broadly distributed high pay.
- Java, Cassandra, and Hadoop show genuinely high salaries across multiple postings, making them more reliable signals of earning potential.
- SQL, despite being the most consistently required skill, averages $88,756 — reflecting its ubiquity across roles of all seniority levels rather than specialization premium.

---

### 5. Most Optimal Skills to Learn

This query combines demand and salary to identify skills that offer both job security and financial return — the most strategic skills to prioritize.

```sql
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
```

**Results:**

| Skill | Average Salary (USD) | Demand Count |
|---|---:|---:|
| Python | $86,644 | 11 |
| SQL | $88,756 | 9 |
| Scala | $108,709 | 5 |
| Java | $124,637 | 4 |
| Spark | $100,254 | 4 |
| Flow | $88,163 | 4 |
| Excel | $85,629 | 4 |
| R | $80,879 | 4 |
| MongoDB | $67,835 | 4 |
| Hadoop | $116,667 | 3 |

**Key findings:**
- Python and SQL lead in demand count, appearing in 11 and 9 postings respectively among roles with specified salaries. These are the baseline skills for the Egyptian data job market.
- Java and Hadoop offer the highest average salaries ($124,637 and $116,667) among skills with meaningful demand, representing a strong return for those willing to go beyond the basics.
- Scala and Spark offer a strong balance of demand and salary, making them high-value additions for anyone targeting Data Engineer roles specifically.
- MongoDB shows the lowest average salary ($67,835) in the top 10, suggesting it appears in lower-seniority postings.

---

## What I Learned

- Writing multi-table JOINs and CTEs became natural through repeated application across all five queries. The pattern of building a filtered CTE first, then joining additional tables, is now a reliable approach for complex questions.
- GROUP BY with aggregate functions requires discipline — every non-aggregated column in SELECT must appear in GROUP BY. This caused real errors early on and forced a clear understanding of how SQL evaluates grouped queries.
- The difference between what's in demand and what's high-paying is not the same thing. SQL is everywhere but doesn't command a salary premium precisely because it's a baseline expectation. That distinction has direct implications for skill prioritization.

---

## Conclusions

For anyone targeting data roles in the Egyptian job market in 2023:

1. **Python and SQL are non-negotiable.** They lead in both demand and consistent presence across high-paying roles. Everything else builds on these two.
2. **Data Scientist and Data Engineer roles pay significantly more than Data Analyst** in the Egyptian market. If salary is the priority, the technical depth required for those roles is worth pursuing.
3. **Scala, Java, Spark, and Hadoop** represent the next tier — lower demand than Python/SQL but substantially higher average salaries, and concentrated in engineering roles.
4. **Cloud skills (AWS, Azure) appear in the top 10 most demanded skills** but not prominently in the top-paying skills list, suggesting they are becoming table stakes rather than differentiators.
5. The Egyptian data job market is smaller than global markets, meaning salary data is influenced heavily by a small number of high-paying postings. Interpret averages with that context in mind.
