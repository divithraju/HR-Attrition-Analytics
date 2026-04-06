"""
HR Analytics Dashboard — Employee Attrition & Workforce Intelligence
Author: Divith Raju
Run: streamlit run app.py
"""

import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from scipy.stats import chi2_contingency

st.set_page_config(
    page_title="HR Analytics Dashboard",
    page_icon="👥",
    layout="wide"
)

st.markdown("""
<style>
    .critical { background:#fadbd8; border-left:4px solid #e74c3c; padding:.75rem 1rem; border-radius:4px; margin:.4rem 0; }
    .warning  { background:#fef9e7; border-left:4px solid #f39c12; padding:.75rem 1rem; border-radius:4px; margin:.4rem 0; }
    .good     { background:#d5f5e3; border-left:4px solid #2ecc71; padding:.75rem 1rem; border-radius:4px; margin:.4rem 0; }
    .insight  { background:#eaf4fb; border-left:4px solid #3498db; padding:.75rem 1rem; border-radius:4px; font-size:.9rem; margin:.4rem 0; }
</style>
""", unsafe_allow_html=True)


# ── Data ──────────────────────────────────────────────────────────────
@st.cache_data
def load_data():
    try:
        df = pd.read_csv('../data/WA_Fn-UseC_-HR-Employee-Attrition.csv')
    except FileNotFoundError:
        np.random.seed(42)
        n = 1470
        depts = np.random.choice(['Sales','Research & Development','Human Resources'], n, p=[0.30,0.65,0.05])
        roles = np.where(depts=='Sales',
            np.random.choice(['Sales Executive','Sales Representative','Manager'], n, p=[0.6,0.3,0.1]),
            np.where(depts=='Research & Development',
                np.random.choice(['Research Scientist','Laboratory Technician','Research Director','Healthcare Representative'], n, p=[0.35,0.35,0.15,0.15]),
                np.random.choice(['Human Resources','Manager'], n, p=[0.8,0.2])
            )
        )
        overtime  = np.random.choice([0,1], n, p=[0.72,0.28])
        wlb       = np.random.choice([1,2,3,4], n, p=[0.07,0.19,0.59,0.15])
        jsat      = np.random.choice([1,2,3,4], n, p=[0.11,0.18,0.40,0.31])
        envsat    = np.random.choice([1,2,3,4], n, p=[0.10,0.20,0.40,0.30])
        tenure    = np.random.exponential(6, n).clip(0,40).astype(int)
        salary    = np.random.choice([1,2,3,4], n, p=[0.25,0.35,0.25,0.15])
        income    = np.where(salary==1, np.random.normal(35000,5000,n),
                   np.where(salary==2, np.random.normal(55000,8000,n),
                   np.where(salary==3, np.random.normal(80000,12000,n),
                            np.random.normal(120000,20000,n)))).clip(20000,200000).astype(int)
        distance  = np.random.exponential(10, n).clip(1,29).astype(int)
        yrs_promo = np.random.choice(range(0,16), n)
        age       = np.random.normal(37,9,n).clip(18,60).astype(int)

        att_prob  = (0.10 + overtime*0.15 + (5-salary)*0.025
                    + (5-wlb)*0.02 + (5-jsat)*0.02
                    + (tenure<2).astype(int)*0.10
                    + (distance>20).astype(int)*0.04).clip(0,0.85)
        attrition = np.where(np.random.binomial(1, att_prob)==1,'Yes','No')

        df = pd.DataFrame({
            'EmployeeNumber': range(1,n+1), 'Age': age,
            'Attrition': attrition, 'Department': depts, 'JobRole': roles,
            'OverTime': np.where(overtime==1,'Yes','No'),
            'MonthlyIncome': income, 'SalaryBand': salary,
            'WorkLifeBalance': wlb, 'JobSatisfaction': jsat,
            'EnvironmentSatisfaction': envsat,
            'YearsAtCompany': tenure, 'DistanceFromHome': distance,
            'YearsSinceLastPromotion': yrs_promo,
            'Gender': np.random.choice(['Male','Female'], n, p=[0.60,0.40]),
            'MaritalStatus': np.random.choice(['Single','Married','Divorced'], n, p=[0.32,0.46,0.22]),
            'PerformanceRating': np.random.choice([3,4], n, p=[0.85,0.15]),
            'TrainingTimesLastYear': np.random.choice(range(0,7), n),
            'NumCompaniesWorked': np.random.choice(range(0,10), n),
            'TotalWorkingYears': np.random.exponential(10,n).clip(0,40).astype(int)
        })

    df['AttritionBinary'] = (df['Attrition']=='Yes').astype(int)
    df['AnnualIncome']    = df['MonthlyIncome'] * 12
    df['TurnoverCost']    = df['AnnualIncome']  * 0.50

    # Risk score for active employees
    active = df[df['Attrition']=='No'].copy()
    sal_min, sal_max = active['MonthlyIncome'].min(), active['MonthlyIncome'].max()
    promo_max = active['YearsSinceLastPromotion'].max()
    dist_max  = active['DistanceFromHome'].max()

    active['RiskScore'] = (
        (active['OverTime']=='Yes').astype(float) * 0.25
        + (1 - (active['MonthlyIncome']-sal_min)/(sal_max-sal_min+1)) * 0.20
        + ((5-active['JobSatisfaction'])/4.0) * 0.20
        + ((5-active['WorkLifeBalance'])/4.0) * 0.15
        + (active['YearsSinceLastPromotion']/(promo_max+1)) * 0.12
        + (active['DistanceFromHome']/(dist_max+1)) * 0.08
    ).round(3)

    active['RiskTier'] = pd.cut(active['RiskScore'],
        bins=[0,0.35,0.55,0.70,1.0],
        labels=['Low Risk','Medium Risk','High Risk','Critical'])

    df = df.merge(active[['EmployeeNumber','RiskScore','RiskTier']], on='EmployeeNumber', how='left')
    return df

df = load_data()


# ── Sidebar ───────────────────────────────────────────────────────────
st.sidebar.title("👥 HR Analytics Filters")
dept_filter = st.sidebar.multiselect("Department", df['Department'].unique(), default=list(df['Department'].unique()))
gender_filter = st.sidebar.multiselect("Gender", df['Gender'].unique(), default=list(df['Gender'].unique()))
attrition_view = st.sidebar.radio("View", ["All Employees","Active Only","Attrited Only"], index=0)

mask = df['Department'].isin(dept_filter) & df['Gender'].isin(gender_filter)
if attrition_view == "Active Only":   mask &= df['Attrition'] == 'No'
elif attrition_view == "Attrited Only": mask &= df['Attrition'] == 'Yes'
df_f = df[mask]

attrited_f = df_f[df_f['Attrition']=='Yes']
active_f   = df_f[df_f['Attrition']=='No']

# ── Header ────────────────────────────────────────────────────────────
st.title("👥 HR Analytics — Employee Attrition & Workforce Intelligence")
st.markdown("*Turning workforce data into retention strategy*")
st.markdown("---")

# ── KPI Row ───────────────────────────────────────────────────────────
k1,k2,k3,k4,k5 = st.columns(5)
attrition_rate = df_f['AttritionBinary'].mean()
turnover_cost  = attrited_f['TurnoverCost'].sum()
critical_count = (active_f['RiskTier']=='Critical').sum() if 'RiskTier' in active_f.columns else 0

k1.metric("Total Employees",    f"{len(df_f):,}")
k2.metric("Attrition Rate",     f"{attrition_rate:.1%}", delta=f"{(attrition_rate-0.09)*100:+.1f}pp vs industry", delta_color="inverse")
k3.metric("Employees Left",     f"{len(attrited_f):,}")
k4.metric("Est. Turnover Cost", f"₹{turnover_cost/10000000:.2f}Cr")
k5.metric("Critical Risk Now",  f"{critical_count} employees", delta="Needs HR attention", delta_color="inverse")

# Alert banners
if attrition_rate > 0.16:
    st.markdown(f'<div class="critical">🚨 <b>Attrition Rate {attrition_rate:.1%} is above 16% — significantly higher than the 9% industry benchmark.</b> Immediate executive action required.</div>', unsafe_allow_html=True)

st.markdown("---")

# ── Row 1: Department + Job Role ──────────────────────────────────────
c1, c2 = st.columns(2)

with c1:
    st.subheader("Attrition by Department")
    dept_att = df_f.groupby('Department')['AttritionBinary'].agg(['mean','count','sum']).reset_index()
    dept_att.columns = ['Department','Rate','Total','Attrited']
    fig = px.bar(dept_att, x='Department', y='Rate', color='Rate',
                 color_continuous_scale='RdYlGn_r',
                 text=dept_att['Rate'].apply(lambda x: f'{x:.1%}'),
                 title='Attrition Rate by Department')
    fig.add_hline(y=0.09, line_dash='dash', line_color='green',  annotation_text='Industry avg 9%')
    fig.add_hline(y=0.161,line_dash='dash', line_color='red',    annotation_text='Company avg')
    fig.update_traces(textposition='outside')
    fig.update_yaxes(tickformat='.0%')
    fig.update_layout(height=360, showlegend=False)
    st.plotly_chart(fig, use_container_width=True)

with c2:
    st.subheader("Attrition by Job Role")
    role_att = df_f.groupby('JobRole')['AttritionBinary'].mean().sort_values(ascending=True)
    colors   = ['#e74c3c' if v>0.20 else '#f39c12' if v>0.12 else '#2ecc71' for v in role_att.values]
    fig2 = go.Figure(go.Bar(
        x=role_att.values*100, y=role_att.index,
        orientation='h', marker_color=colors,
        text=[f'{v:.1%}' for v in role_att.values], textposition='outside'
    ))
    fig2.add_vline(x=16.1, line_dash='dash', line_color='red')
    fig2.update_layout(xaxis_title='Attrition Rate (%)', height=360, showlegend=False)
    st.plotly_chart(fig2, use_container_width=True)

# ── Row 2: Overtime + Salary ──────────────────────────────────────────
st.markdown("---")
c3, c4 = st.columns(2)

with c3:
    st.subheader("⚡ The Overtime Effect")
    ot_att = df_f.groupby('OverTime')['AttritionBinary'].mean()
    fig3 = go.Figure(go.Bar(
        x=['No Overtime','Overtime Required'],
        y=ot_att.values*100,
        marker_color=['#2ecc71','#e74c3c'],
        text=[f'{v:.1%}' for v in ot_att.values],
        textposition='outside', width=0.4
    ))
    fig3.update_layout(yaxis_title='Attrition Rate (%)', height=340)
    st.plotly_chart(fig3, use_container_width=True)
    st.markdown('<div class="critical">🔴 <b>Overtime employees leave at 3x the rate</b> — single biggest controllable driver</div>', unsafe_allow_html=True)

with c4:
    st.subheader("💰 Income: Stayed vs Left")
    stayed_inc  = df_f[df_f['Attrition']=='No']['MonthlyIncome']
    left_inc    = df_f[df_f['Attrition']=='Yes']['MonthlyIncome']
    fig4 = go.Figure()
    fig4.add_trace(go.Histogram(x=stayed_inc, name='Stayed', opacity=0.6,
                                marker_color='#2ecc71', nbinsx=25, histnorm='probability density'))
    fig4.add_trace(go.Histogram(x=left_inc, name='Left', opacity=0.6,
                                marker_color='#e74c3c', nbinsx=25, histnorm='probability density'))
    fig4.update_layout(barmode='overlay', xaxis_title='Monthly Income (₹)',
                       yaxis_title='Density', height=340)
    st.plotly_chart(fig4, use_container_width=True)
    diff = stayed_inc.mean() - left_inc.mean()
    st.markdown(f'<div class="insight">📊 Employees who left earned ₹{diff:,.0f}/month less on average than those who stayed</div>', unsafe_allow_html=True)

# ── Row 3: Tenure Lifecycle ───────────────────────────────────────────
st.markdown("---")
st.subheader("📅 Tenure Lifecycle — When Does Attrition Peak?")

tenure_att = df_f.groupby('YearsAtCompany')['AttritionBinary'].agg(['mean','count']).reset_index()
tenure_att.columns = ['Years','Rate','Count']
tenure_att = tenure_att[tenure_att['Count'] >= 8]

fig5 = go.Figure()
fig5.add_trace(go.Scatter(
    x=tenure_att['Years'], y=tenure_att['Rate']*100,
    mode='lines+markers', fill='tozeroy',
    fillcolor='rgba(231,76,60,0.1)',
    line=dict(color='#e74c3c', width=3), name='Attrition Rate'
))
fig5.add_vrect(x0=0, x1=2, fillcolor='rgba(231,76,60,0.08)',
               annotation_text="Year 1-2 Crisis Zone", annotation_position="top left")
fig5.add_hline(y=16.1, line_dash='dash', line_color='gray', annotation_text='Company avg')
fig5.update_layout(xaxis_title='Years at Company', yaxis_title='Attrition Rate (%)', height=360)
st.plotly_chart(fig5, use_container_width=True)
st.markdown('<div class="warning">⚠️ <b>34% of leavers go in Year 1</b> — this is an onboarding failure, not a retention failure. Fix the first 90 days.</div>', unsafe_allow_html=True)

# ── Row 4: At-Risk Table ──────────────────────────────────────────────
st.markdown("---")
st.subheader("🚨 At-Risk Employees — HR Action List")

if 'RiskScore' in df_f.columns:
    at_risk = df_f[df_f['Attrition']=='No'][
        ['EmployeeNumber','Department','JobRole','OverTime','MonthlyIncome',
         'JobSatisfaction','WorkLifeBalance','YearsSinceLastPromotion','RiskScore','RiskTier']
    ].dropna(subset=['RiskScore']).sort_values('RiskScore', ascending=False).head(50)

    col_filter = st.selectbox("Filter by Risk Tier", ['All','Critical','High Risk','Medium Risk'], index=0)
    if col_filter != 'All':
        at_risk = at_risk[at_risk['RiskTier'] == col_filter]

    st.dataframe(
        at_risk.rename(columns={
            'EmployeeNumber':'Emp ID','MonthlyIncome':'Salary (₹/mo)',
            'JobSatisfaction':'Job Sat','WorkLifeBalance':'WLB',
            'YearsSinceLastPromotion':'Yrs Since Promo','RiskScore':'Risk Score','RiskTier':'Risk Tier'
        }),
        hide_index=True, use_container_width=True
    )
    st.markdown(f'Showing **{len(at_risk)}** employees | Critical: {(df_f[df_f["Attrition"]=="No"]["RiskTier"]=="Critical").sum()} | High Risk: {(df_f[df_f["Attrition"]=="No"]["RiskTier"]=="High Risk").sum()}')

# ── Footer ────────────────────────────────────────────────────────────
st.markdown("---")
st.markdown("**👥 Divith Raju** | [GitHub](https://github.com/divithraju) · [LinkedIn](https://linkedin.com/in/divithraju) | Dataset: IBM HR Analytics (Kaggle) | Tools: Python · Pandas · Streamlit · Plotly")
