-- ================================================================
-- HR ANALYTICS — WORKFORCE SQL QUERIES
-- Author: Divith Raju
-- Tools: PostgreSQL 15
-- Dataset: IBM HR Analytics (Kaggle)
-- ================================================================

-- ================================================================
-- QUERY 1: COMPANY-WIDE ATTRITION OVERVIEW
-- Business Question: What is our headline attrition number?
-- ================================================================
SELECT
    COUNT(*)                                                    AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)         AS employees_left,
    SUM(CASE WHEN attrition = 'No'  THEN 1 ELSE 0 END)         AS employees_stayed,
    ROUND(
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    )                                                           AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 0)                               AS avg_monthly_income,
    ROUND(AVG(years_at_company), 1)                             AS avg_tenure_years
FROM hr_employees;


-- ================================================================
-- QUERY 2: ATTRITION BY DEPARTMENT WITH COST ESTIMATE
-- Business Question: Which department is bleeding the most — and what does it cost?
-- ================================================================
SELECT
    department,
    COUNT(*)                                                            AS total_headcount,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)                 AS employees_lost,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate_pct,
    ROUND(AVG(monthly_income) * 12, 0)                                  AS avg_annual_salary,
    -- Turnover cost = 50% of annual salary per attrited employee
    ROUND(
        SUM(CASE WHEN attrition='Yes' THEN monthly_income * 12 * 0.50 ELSE 0 END), 0
    )                                                                   AS est_turnover_cost_inr,
    RANK() OVER (ORDER BY AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) DESC) AS attrition_rank
FROM hr_employees
GROUP BY department
ORDER BY attrition_rate_pct DESC;


-- ================================================================
-- QUERY 3: JOB ROLE DEEP DIVE
-- Business Question: Which specific roles have the highest risk?
-- ================================================================
SELECT
    job_role,
    department,
    COUNT(*)                                                            AS headcount,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)                 AS attrited,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_monthly_income,
    ROUND(AVG(job_satisfaction), 2)                                     AS avg_job_satisfaction,
    ROUND(AVG(work_life_balance), 2)                                    AS avg_wlb,
    -- Flag critical roles
    CASE
        WHEN AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) > 0.25
            THEN '🔴 Critical — Immediate intervention'
        WHEN AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) > 0.15
            THEN '🟡 Monitor — Above average risk'
        ELSE '🟢 Stable'
    END AS risk_status
FROM hr_employees
GROUP BY job_role, department
HAVING COUNT(*) >= 10
ORDER BY attrition_pct DESC;


-- ================================================================
-- QUERY 4: OVERTIME ATTRITION ANALYSIS
-- Business Question: How much does overtime drive attrition?
-- ================================================================
SELECT
    over_time,
    COUNT(*)                                                            AS employees,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)                   AS attrited,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 2)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_monthly_income,
    ROUND(AVG(job_satisfaction), 2)                                     AS avg_job_satisfaction,
    ROUND(AVG(work_life_balance), 2)                                    AS avg_work_life_balance,
    -- Revenue impact
    ROUND(
        SUM(CASE WHEN attrition='Yes' THEN monthly_income * 12 * 0.50 ELSE 0 END), 0
    )                                                                   AS overtime_related_turnover_cost
FROM hr_employees
GROUP BY over_time
ORDER BY attrition_pct DESC;


-- ================================================================
-- QUERY 5: SALARY ANALYSIS — Do We Pay Enough to Retain?
-- Business Question: Is there a salary gap between who stays and who leaves?
-- ================================================================
SELECT
    attrition,
    COUNT(*)                                        AS employees,
    ROUND(AVG(monthly_income), 0)                   AS avg_monthly_income,
    ROUND(MIN(monthly_income), 0)                   AS min_income,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY monthly_income), 0) AS p25_income,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY monthly_income), 0) AS median_income,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monthly_income), 0) AS p75_income,
    ROUND(MAX(monthly_income), 0)                   AS max_income
FROM hr_employees
GROUP BY attrition;


-- ================================================================
-- QUERY 6: SALARY QUARTILE ATTRITION RATES
-- Business Question: Is the lowest salary band a revolving door?
-- ================================================================
WITH salary_quartiles AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY monthly_income) AS salary_quartile
    FROM hr_employees
)
SELECT
    salary_quartile,
    CASE salary_quartile
        WHEN 1 THEN 'Q1 — Lowest Pay'
        WHEN 2 THEN 'Q2'
        WHEN 3 THEN 'Q3'
        WHEN 4 THEN 'Q4 — Highest Pay'
    END                                                                 AS salary_band_label,
    COUNT(*)                                                            AS employees,
    ROUND(MIN(monthly_income), 0)                                       AS min_salary,
    ROUND(MAX(monthly_income), 0)                                       AS max_salary,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)                   AS attrited,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    -- Compare to Q4 (reference group)
    ROUND(
        AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) /
        NULLIF(AVG(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0)) OVER (
            WHERE salary_quartile = 4
        ), 0), 2
    )                                                                   AS relative_risk_vs_q4
FROM salary_quartiles
GROUP BY salary_quartile
ORDER BY salary_quartile;


-- ================================================================
-- QUERY 7: TENURE LIFECYCLE — When Does Attrition Peak?
-- Business Question: At which year should we focus retention efforts?
-- ================================================================
SELECT
    years_at_company,
    COUNT(*)                                                            AS total_employees,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)                   AS attrited,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    -- Running cumulative attrition count
    SUM(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END))
        OVER (ORDER BY years_at_company ROWS UNBOUNDED PRECEDING)      AS cumulative_attrited,
    CASE
        WHEN years_at_company <= 1  THEN '🔴 Critical — Year 1 crisis'
        WHEN years_at_company <= 3  THEN '🟡 Risk zone — Early tenure'
        WHEN years_at_company <= 7  THEN '🟠 Watch — Mid tenure'
        ELSE '🟢 Stable — Long tenure'
    END                                                                 AS lifecycle_stage
FROM hr_employees
GROUP BY years_at_company
HAVING COUNT(*) >= 5
ORDER BY years_at_company;


-- ================================================================
-- QUERY 8: SATISFACTION SCORES BREAKDOWN
-- Business Question: Are our low-satisfaction employees identifiable before they quit?
-- ================================================================
SELECT
    job_satisfaction,
    work_life_balance,
    environment_satisfaction,
    COUNT(*)                                                            AS employees,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income
FROM hr_employees
GROUP BY job_satisfaction, work_life_balance, environment_satisfaction
HAVING COUNT(*) >= 15
ORDER BY attrition_pct DESC
LIMIT 20;


-- ================================================================
-- QUERY 9: DISTANCE FROM HOME IMPACT
-- Business Question: Are far-commute employees a retention risk?
-- ================================================================
SELECT
    CASE
        WHEN distance_from_home BETWEEN 1  AND 5  THEN '1 — Near (0-5km)'
        WHEN distance_from_home BETWEEN 6  AND 10 THEN '2 — Local (5-10km)'
        WHEN distance_from_home BETWEEN 11 AND 20 THEN '3 — Medium (10-20km)'
        ELSE                                            '4 — Far (20km+)'
    END                                                                 AS distance_bucket,
    COUNT(*)                                                            AS employees,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)                   AS attrited,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income
FROM hr_employees
GROUP BY distance_bucket
ORDER BY distance_bucket;


-- ================================================================
-- QUERY 10: PROMOTION DROUGHT ANALYSIS
-- Business Question: Does lack of promotion drive people to quit?
-- ================================================================
SELECT
    years_since_last_promotion,
    COUNT(*)                                                            AS employees,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income,
    ROUND(AVG(job_satisfaction), 2)                                     AS avg_job_satisfaction,
    -- Promotion drought flag
    CASE
        WHEN years_since_last_promotion >= 5 THEN '⚠️  Promotion drought — High risk'
        WHEN years_since_last_promotion >= 3 THEN '📋 Due for review'
        ELSE '✅ Recently promoted'
    END                                                                 AS promotion_status
FROM hr_employees
GROUP BY years_since_last_promotion
ORDER BY years_since_last_promotion;


-- ================================================================
-- QUERY 11: DEMOGRAPHIC ANALYSIS (Age & Gender)
-- Business Question: Are there demographic patterns in attrition?
-- ================================================================
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '55+'
    END                                                                 AS age_group,
    gender,
    COUNT(*)                                                            AS employees,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income
FROM hr_employees
GROUP BY age_group, gender
ORDER BY age_group, gender;


-- ================================================================
-- QUERY 12: MARITAL STATUS ATTRITION
-- Business Question: Does personal life situation affect retention?
-- ================================================================
SELECT
    marital_status,
    COUNT(*)                                                            AS employees,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income,
    ROUND(AVG(work_life_balance), 2)                                    AS avg_wlb
FROM hr_employees
GROUP BY marital_status
ORDER BY attrition_pct DESC;


-- ================================================================
-- QUERY 13: HIGH-PERFORMER ATTRITION — Are We Losing Our Best?
-- Business Question: Do we lose high-performers disproportionately?
-- ================================================================
SELECT
    performance_rating,
    CASE performance_rating
        WHEN 1 THEN 'Low Performer'
        WHEN 2 THEN 'Needs Improvement'
        WHEN 3 THEN 'Meets Expectations'
        WHEN 4 THEN 'Exceeds Expectations'
    END                                                                 AS rating_label,
    COUNT(*)                                                            AS employees,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)                   AS attrited,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income,
    -- Revenue impact of losing high performers
    ROUND(
        SUM(CASE WHEN attrition='Yes' THEN monthly_income*12*0.50 ELSE 0 END), 0
    )                                                                   AS turnover_cost
FROM hr_employees
GROUP BY performance_rating
ORDER BY performance_rating DESC;


-- ================================================================
-- QUERY 14: AT-RISK EMPLOYEE PRIORITY LIST
-- Business Question: Give HR the specific employee IDs to contact
-- ================================================================
WITH risk_scored AS (
    SELECT
        employee_number,
        department,
        job_role,
        over_time,
        monthly_income,
        job_satisfaction,
        work_life_balance,
        years_since_last_promotion,
        distance_from_home,
        -- Composite risk score (same logic as Python model)
        ROUND(
            CASE WHEN over_time = 'Yes' THEN 0.25 ELSE 0 END
            + (1 - (monthly_income::float - MIN(monthly_income) OVER()) /
                NULLIF(MAX(monthly_income) OVER() - MIN(monthly_income) OVER(), 1)) * 0.20
            + ((5 - job_satisfaction) / 4.0) * 0.20
            + ((5 - work_life_balance) / 4.0) * 0.15
            + (years_since_last_promotion::float / NULLIF(MAX(years_since_last_promotion) OVER(), 0)) * 0.12
            + (distance_from_home::float / NULLIF(MAX(distance_from_home) OVER(), 0)) * 0.08
        , 3)                                                            AS risk_score
    FROM hr_employees
    WHERE attrition = 'No'  -- Only active employees
)
SELECT
    employee_number,
    department,
    job_role,
    over_time,
    monthly_income,
    job_satisfaction,
    work_life_balance,
    years_since_last_promotion,
    risk_score,
    CASE
        WHEN risk_score >= 0.70 THEN '🔴 CRITICAL — Call this week'
        WHEN risk_score >= 0.55 THEN '🟠 HIGH — Schedule 1:1 this month'
        WHEN risk_score >= 0.35 THEN '🟡 MEDIUM — Include in engagement survey'
        ELSE '🟢 LOW — Monitor quarterly'
    END AS recommended_action
FROM risk_scored
ORDER BY risk_score DESC
LIMIT 50;


-- ================================================================
-- QUERY 15: TRAINING & DEVELOPMENT vs ATTRITION
-- Business Question: Does investing in training help retain employees?
-- ================================================================
SELECT
    training_times_last_year,
    COUNT(*)                                                            AS employees,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0) * 100, 1)     AS attrition_pct,
    ROUND(AVG(job_satisfaction), 2)                                     AS avg_job_satisfaction,
    ROUND(AVG(monthly_income), 0)                                       AS avg_income
FROM hr_employees
GROUP BY training_times_last_year
ORDER BY training_times_last_year;


-- ================================================================
-- QUERY 16: EXECUTIVE DASHBOARD — ONE-PAGE BOARD SUMMARY
-- Business Question: What does the CHRO present to the board?
-- ================================================================
SELECT 'Total Employees'            AS metric,
    CAST(COUNT(*) AS VARCHAR)       AS value
FROM hr_employees
UNION ALL
SELECT 'Annual Attrition Rate',
    CONCAT(ROUND(AVG(CASE WHEN attrition='Yes' THEN 1.0 ELSE 0)*100,1),'%')
FROM hr_employees
UNION ALL
SELECT 'Employees Who Left',
    CAST(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS VARCHAR)
FROM hr_employees
UNION ALL
SELECT 'Direct Turnover Cost (est)',
    CONCAT('Rs.',ROUND(SUM(CASE WHEN attrition='Yes' THEN monthly_income*12*0.50 ELSE 0 END)/100000,1),'L')
FROM hr_employees
UNION ALL
SELECT 'Total Turnover Cost (incl. knowledge loss)',
    CONCAT('Rs.',ROUND(SUM(CASE WHEN attrition='Yes' THEN monthly_income*12*0.90 ELSE 0 END)/10000000,2),' crore')
FROM hr_employees
UNION ALL
SELECT 'Highest Risk Department',       'Sales (20.6% attrition)' UNION ALL
SELECT 'Highest Risk Job Role',         'Sales Representative (39.8%)' UNION ALL
SELECT '#1 Attrition Driver',           'Overtime requirement (30.5% vs 10.4%)' UNION ALL
SELECT 'Year-1 Attrition Rate',         '~34% — Onboarding crisis' UNION ALL
SELECT 'Recommended Annual Investment', 'Rs.80.5L retention programs' UNION ALL
SELECT 'Projected Annual Savings',      'Rs.1.45 crore (ROI: 180%)';

-- ================================================================
-- END OF QUERIES
-- Full Python analysis: notebooks/hr_analytics.ipynb
-- Interactive dashboard: streamlit run dashboard/app.py
-- ================================================================
