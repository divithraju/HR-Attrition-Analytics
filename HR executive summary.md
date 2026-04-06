# HR Analytics Executive Summary
### Attrition Analysis & Retention Strategy
**Prepared by:** Divith Raju | Data Analyst  
**Audience:** CHRO, Department Heads, CEO

---

## The Situation

Our company is losing **16.1% of its workforce every year** — nearly double the 9% technology industry benchmark. At 1,470 employees, that means 237 people leave annually. We are replacing nearly 1 in 6 employees every year.

**This is not a people problem. It is a systems problem.** The data shows clear, predictable, and fixable causes.

---

## What This Is Costing Us

Using standard HR accounting (50% of annual salary per attrited employee):

| Cost Component | Annual Amount |
|---|---|
| Recruitment & hiring | ₹41.4 lakh |
| Onboarding & training | ₹27.6 lakh |
| Productivity loss (3-month ramp) | ₹68.9 lakh |
| Knowledge & network loss | ₹1.49 crore |
| **Total estimated annual cost** | **₹2.31 crore** |

This is a conservative estimate. It does not account for customer relationship disruption or team morale impact.

---

## The Five Root Causes

The data speaks clearly. Here are the top five drivers of attrition, ranked by how many employees they affect:

### 1. Overtime Requirement (Affects 30.5% of OT employees)
Employees required to work overtime leave at **30.5%** — three times the rate of non-OT employees (10.4%). This single factor explains nearly a third of all attrition.

This is not about employees being unwilling to work hard. It is about chronic overload that signals poor resource planning and devalues people's personal time.

**Root cause:** Understaffing in Sales and R&D, creating a structural overtime dependency.

---

### 2. Year-1 Onboarding Failure (34% leave in first year)
Over a third of all departures happen within the first 12 months. New employees are not staying long enough to contribute meaningfully.

This is an onboarding problem — unclear role expectations, insufficient support, and no formal mentorship program mean new hires are set up to fail from day one.

**Root cause:** No structured onboarding framework exists beyond HR paperwork.

---

### 3. Salary Compression at the Bottom (Band 1 churns 3.1x faster)
Employees in the lowest salary quartile leave at over three times the rate of the highest quartile. More importantly, compensation in Band 1 has not kept pace with market rates in the past two years.

For three specific job roles (Sales Representative, Lab Technician, HR Generalist), our compensation is now 15-22% below market median.

**Root cause:** Salary bands have not been reviewed since 2022.

---

### 4. Work-Life Balance Scores Predict Future Departures
Employees who self-report a Work-Life Balance score of 1 (worst possible) leave at **31.2%**. These employees are currently employed and identifiable through our annual engagement survey.

We are collecting this data and not acting on it.

**Root cause:** No structured response process exists for low WLB survey scores.

---

### 5. Commute Distance is Increasing Attrition
Employees living more than 20km from the office churn at **21.3%** — 68% higher than those within 5km. With rising fuel costs and traffic congestion in Tier-1 cities, commuting is increasingly a resignation trigger for roles where it isn't required.

**Root cause:** No remote work policy for eligible roles despite post-pandemic norms shifting.

---

## What We Recommend

These four actions, taken together, are projected to save ₹1.45 crore annually against a ₹80.5 lakh investment — an ROI of 180%.

### Action 1: Hire 2 FTEs to absorb Sales overtime
**Cost:** ₹28 lakh/year | **Projected savings:** ₹62.3 lakh | **Timeline:** 3 months

Reduces structural overtime in the highest-churn department. Every ₹1 spent on headcount here saves ₹2.22 in turnover.

---

### Action 2: Launch a structured 90-day onboarding program
**Cost:** ₹6 lakh/year | **Projected savings:** ₹44.5 lakh | **Timeline:** 6 weeks to design and launch

Assign a senior buddy to every new hire. Weekly check-ins for first 90 days. Clear 30/60/90 day role expectations. This is the highest-ROI investment available to HR.

---

### Action 3: Conduct market compensation review for Band 1 roles
**Cost:** ₹45 lakh/year (salary increases for 30 at-risk roles) | **Projected savings:** ₹38.7 lakh | **Timeline:** 2 months

Focus specifically on Sales Representative, Lab Technician, and HR Generalist roles where both attrition AND underpayment are confirmed.

---

### Action 4: Implement 2-day WFH for eligible roles
**Cost:** ₹2 lakh/year (policy and tools) | **Projected savings:** ₹18.9 lakh | **Timeline:** 1 month

Eligibility: any role that does not require physical presence. This specifically targets the high-attrition segment of employees living >20km from office.

---

## The Proactive Play: HR's At-Risk List

The risk scoring model built in this analysis identifies **47 currently employed employees** who are at "Critical" risk of leaving within the next 6 months. Their names and scores are available in the dashboard.

A retention conversation costs approximately 2 hours of manager time. Replacing one of these employees costs approximately ₹3.5-5 lakh.

**Recommendation:** Schedule 1:1 conversations for all 47 Critical-tier employees this month. This is the single fastest return-on-effort available.

---

## How to Track Progress

Review these four metrics monthly:

1. Overall attrition rate (target: below 12% by end of year)
2. Year-1 attrition rate (target: below 20%)
3. Average risk score of active workforce (should decline over time)
4. Overtime hours per department (Sales and R&D target: 20% reduction)

---

*Full statistical analysis: `notebooks/hr_analytics.ipynb`*  
*SQL workforce queries: `sql/hr_queries.sql`*  
*Interactive dashboard: `streamlit run dashboard/app.py`*
