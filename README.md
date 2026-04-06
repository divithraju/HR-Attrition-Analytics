# 👥 HR Analytics — Employee Attrition & Workforce Intelligence Dashboard<div align="center">

![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-2.0-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-Interactive-3F4F75?style=for-the-badge&logo=plotly&logoColor=white)
![Streamlit](https://img.shields.io/badge/Streamlit-Live_Demo-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)

</div>

Workforce Data → Attrition Drivers → Cost of Turnover → Retention Strategy

## 📌 Business Problem

A mid-size technology company with **1,470 employees** is facing a **16.1% annual attrition rate** — nearly double the industry average of **9%**.  

The HR team has no data-driven answer to the key question:  
👉 *"Who is leaving, why, and what is it costing us?"*

Without this visibility, the company is spending:  
💰 **₹2.3 crore per year** on replacement hiring, onboarding, and productivity loss  

Most of these losses are **predictable and preventable**.

---

### 🎯 Objective

Build an **end-to-end HR analytics system** that:

- Identifies **root causes of attrition**  
- Quantifies the **true cost of turnover by department**  
- Provides a **prioritized retention action plan** for HR & leadership  

---

## 🎯 Key Business Questions Answered

| # | Question | Finding |
|---|----------|---------|
| 1 | What is our true attrition rate and cost? | **16.1% attrition = ₹2.31 crore/year** |
| 2 | Which departments lose the most people? | Sales (**20.6%**) and R&D (**19.0%**) |
| 3 | What is the #1 driver of attrition? | Overtime — **30.5% vs 10.4%** |
| 4 | Does salary drive attrition? | Bottom quartile = **3.1x higher attrition** |
| 5 | Which job roles are highest risk? | Sales Rep (**39.8%**), Lab Tech (**23.9%**), HR (**23.1%**) |
| 6 | What does the attrition lifecycle look like? | Peak at **Year 1 (34%)** |
| 7 | Does work-life balance matter? | WLB=1 → **31.2% vs 14.8%** |
| 8 | Who should HR act on immediately? | **47 high-risk employees identified** |

---

### 💡 Key Takeaway

- Attrition is **not random** — it is **predictable and segment-driven**  
- A focused intervention strategy can significantly reduce **₹2+ crore annual loss**

## 📊 Dashboard Preview

### 🧾 Workforce Overview & Financial Impact

| Metric | Value | Description |
|--------|------|-------------|
| Total Employees | **1,470** | Current workforce size |
| Attrition Rate | **16.1%** | Annual employee churn |
| Attrition Cost | **₹2.31 crore** | Total annual loss |
| Employees Left | **237** | Employees who left this year |

---

### 📉 Key Visuals

- **Attrition by Department**  
  → Horizontal bar chart  

- **Overtime vs Attrition**  
  → Side-by-side comparison  

- **Salary Band Analysis**  
  → Box plots by attrition  

- **At-Risk Employee Table**  
  → Sortable & filterable table  
## 📁 Project Structure

- **notebooks/**
  - `hr_analytics.ipynb` – Full analysis (run this first)

- **sql/**
  - `hr_queries.sql` – 16 workforce SQL queries

- **dashboard/**
  - `app.py` – Streamlit interactive dashboard

- **data/**
  - `README_data.md` – Dataset info + download link

- **reports/**
  - `hr_executive_summary.md` – Board-ready findings

- **README.md**
  - Project overview

## 🔍 Analysis Methodology

### 1. Attrition Cost Modeling

Goes beyond *"who left"* to answer *"what did it cost"* using industry-standard assumptions:

- **Recruitment cost:** 15% of annual salary  
- **Onboarding cost:** 10% of annual salary  
- **Productivity loss:** 25% of annual salary (first 3 months)  

💰 **Total cost per attrited employee:** ~50% of annual salary  

---

### 2. Multi-Factor Attrition Driver Analysis

Tested **15+ variables** against attrition using statistical tests and EDA:

- Overtime, salary band, job role, department, tenure  
- Work-life balance, job satisfaction, environment satisfaction  
- Distance from home, number of companies worked  

---

### 3. Employee Risk Scoring

Built a **composite risk score** using weighted factors:

- Overtime requirement (**0.25**)  
- Salary quartile (**0.20**)  
- Job satisfaction (**0.20**)  
- Years since last promotion (**0.15**)  
- Work-life balance (**0.10**)  
- Distance from home (**0.10**)  

---

### 4. Survival Analysis (Tenure-Based)

- Identified **when attrition peaks** in the employee lifecycle  
- Helps determine **optimal intervention timing**  

---

### 5. Department-Level Cost Attribution

- Calculated **turnover cost per department**  
- Enables **prioritized HR investment decisions**  

---

## 💡 Top 6 Findings & Recommendations

### 🔹 Finding 1: Overtime is the #1 Attrition Driver

- Overtime employees churn: **30.5%**  
- Non-overtime employees churn: **10.4%**  
- Explains **31% of total attrition**

**🎯 Action:**
- Audit overtime distribution  
- Hire **2 additional FTEs in Sales**  
- 💰 Cost: ₹28L/year → Savings: ₹47L/year  

---

### 🔹 Finding 2: The Year-1 Crisis

- **34% of attrition occurs in Year 1**  

**🎯 Action:**
- Launch structured **90-day onboarding program**  
- Assign **senior buddy** to each new hire  
- Monthly progress check-ins  

---

### 🔹 Finding 3: Sales Reps are Walking Out

- Sales Rep attrition: **39.8%**  
- Ramp time: **6 months**

**🎯 Action:**
- Increase base salary by **₹1.5L/year**  
- Expected attrition reduction → **~25%**  
- 💰 Estimated savings: ₹38L/year  

---

### 🔹 Finding 4: Salary Band 1 is a Revolving Door

- Lowest salary quartile → **3.1x higher attrition**

**🎯 Action:**
- Conduct **market compensation benchmarking**  
- Adjust pay for **top 3 high-risk roles**  

---

### 🔹 Finding 5: Work-Life Balance Predicts Attrition

- WLB = 1 → **31.2% churn**

**🎯 Action:**
- Flag employees with **WLB ≤ 2**  
- Conduct **manager 1:1 interventions**  

---

### 🔹 Finding 6: Distance from Home Matters

## 📈 Financial Impact Summary

| Department | Attrited Employees | Avg Salary | Turnover Cost | Priority |
|------------|-------------------|------------|----------------|----------|
| Sales      | 92                | ₹6.8L      | ₹31.3L         | 🔴 Critical |
| R&D        | 133               | ₹7.1L      | ₹47.2L         | 🔴 Critical |
| HR         | 12                | ₹5.9L      | ₹3.5L          | 🟡 Medium |
| **Total**  | **237**           | —          | **₹82.0L**     | — |

---

### 💡 Note

- These represent **direct replacement costs only**  
- Additional impact includes:
  - Productivity loss  
  - Knowledge transfer gaps  

💰 **Estimated additional cost:** ₹1.49 crore  
👉 **Total annual attrition cost:** **₹2.31 crore**



- >20km → **21.3% attrition**  
- <5km → **12.7% attrition**

**🎯 Action:**
- Introduce **2-day WFH policy**  
- Expected attrition reduction: **~30% (high-distance group)**

  ## 🛠️ Tech Stack

| Tool               | Purpose                                   |
|--------------------|-------------------------------------------|
| Python + Pandas    | Data manipulation, feature engineering    |
| Plotly + Seaborn   | 14+ visualizations                        |
| Scipy              | Chi-square tests, statistical analysis    |
| PostgreSQL         | 16 workforce analytics queries            |
| Streamlit          | Interactive HR dashboard                  |

---

## 🚀 How to Run

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/divithraju/hr-attrition-analytics
cd hr-attrition-analytics
```

---

### 2️⃣ Install Dependencies

```bash
pip install -r requirements.txt
```

---

### 3️⃣ Run the Full Analysis

```bash
jupyter notebook notebooks/hr_analytics.ipynb
```

---

### 4️⃣ Launch the Dashboard

```bash
streamlit run dashboard/app.py
```

---

## 📊 Dataset

- **IBM HR Analytics – Employee Attrition & Performance** (Kaggle, public)  
- See: `data/README_data.md` for download instructions  

---

## 📋 Requirements

```txt
pandas==2.0.3
numpy==1.24.3
plotly==5.15.0
seaborn==0.12.2
matplotlib==3.7.1
scipy==1.11.1
streamlit==1.25.0
psycopg2-binary==2.9.7
jupyter==1.0.0
```

---

## 🔗 Connect

- LinkedIn:https://www.linkedin.com/in/divithraju/  
- GitHub: https://github.com/divithraju  


