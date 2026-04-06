# Dataset Information

## Dataset: IBM HR Analytics Employee Attrition & Performance

**Source:** Kaggle — Free, publicly available  
**Download Link:** https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset  
**File:** `WA_Fn-UseC_-HR-Employee-Attrition.csv`

## How to Set Up

1. Download from the Kaggle link above (free account required)
2. Place file in this `/data/` folder with the exact filename above
3. Run: `jupyter notebook notebooks/hr_analytics.ipynb`

> **Note:** If the file is not present, the notebook automatically generates realistic synthetic data with the same structure. You can run everything without downloading.

## Dataset Overview

| Property | Value |
|---|---|
| Rows | 1,470 employees |
| Columns | 35 features |
| Target Variable | `Attrition` (Yes/No) |
| Attrition Rate | 16.1% |
| Source | IBM (fictional but realistic) |

## Key Columns Used in This Analysis

| Column | Description |
|---|---|
| Attrition | Yes / No — target variable |
| Department | Sales / Research & Development / Human Resources |
| JobRole | 9 different role categories |
| OverTime | Yes / No |
| MonthlyIncome | Monthly salary in $ (we treat as ₹ for India context) |
| YearsAtCompany | Tenure in years |
| JobSatisfaction | 1 (Low) to 4 (Very High) |
| WorkLifeBalance | 1 (Bad) to 4 (Best) |
| EnvironmentSatisfaction | 1 (Low) to 4 (Very High) |
| DistanceFromHome | km from office |
| YearsSinceLastPromotion | Years since last promotion |
| PerformanceRating | 1-4 scale |
| Age | Employee age |
| Gender | Male / Female |
| MaritalStatus | Single / Married / Divorced |
| TrainingTimesLastYear | Number of trainings attended |
| NumCompaniesWorked | Previous companies |

## Note on Currency
The original IBM dataset uses USD. For this analysis, we treat values as ₹ to reflect an Indian company context. The relative patterns and insights remain valid.
