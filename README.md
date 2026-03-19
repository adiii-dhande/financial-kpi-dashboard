# Financial KPI Dashboard
> Multi-page financial analytics report | Python · SQL · MySQL · Power BI · DAX · Tableau

## Project Overview
Extracted, cleaned, and transformed **57,311 financial records** across **4 regions** and **5 products** — 
uncovering revenue patterns, expense breakdowns, and profit margin trends through 
interactive Power BI reports with 15+ custom DAX measures.

## Tools & Technologies
| Category | Tools |
|---|---|
| Database | MySQL |
| Programming | Python (Pandas, NumPy) |
| Visualization | Power BI, Tableau |
| Query Language | SQL (CTEs, Window Functions) |
| DAX Measures | Power BI DAX |
| Version Control | Git, GitHub |

## Dataset
| Metric | Value |
|---|---|
| Total Records | 57,311 |
| Regions | 4 (North, South, East, West) |
| Products | 5 (Product A–E) |
| Reporting Period | FY 2024 |
| Dashboards Built | 3 |

## Key Business Metrics Uncovered
- **Gross Revenue:** $2.87B (↑ 18.4% YoY)
- **Total Expense:** $1.89B (↑ 12.1% YoY)
- **Net Profit:** $981M (↑ 24.7% YoY)
- **Expense Ratio:** 65.8% (↓ 2.1pp improved)
- **Top Product:** Product A — $634M revenue, 124,800 units sold
- **Best Margin Region:** North — 36.2%

## Pipeline Architecture
```
Raw Financial Data (CSV/Excel)
        ↓
Python (Pandas, NumPy) — Cleaning & Transformation
        ↓
MySQL — Structured Storage & SQL Queries
        ↓
SQL CTEs & Window Functions — Aggregation & Analysis
        ↓
Power BI + DAX — Interactive KPI Reports
```

## Dashboards
### Dashboard 1 — Executive Summary
- Top-level KPIs: Revenue, Expense, Profit, Expense Ratio
- Revenue vs Expense monthly trend
- Regional performance breakdown
- YoY growth comparison

### Dashboard 2 — Expense & Profit Analysis
- Stacked monthly expense vs profit (36 months)
- Expense breakdown: Operations 38%, Marketing 24%, IT 19%, HR 19%
- P&L waterfall: Revenue → COGS → OpEx → Marketing → Net Profit
- Regional profit margin comparison
- YoY expense growth trajectory

### Dashboard 3 — Product Performance
- Top 5 products by revenue (Product A: $634M → Product E: $552M)
- Product × Region heatmap — revenue intensity
- Profit margin by product
- Quarterly revenue patterns (2023 vs 2024)
- Units sold distribution

## DAX Measures Built (15+)
- Net Profit Margin %
- YoY Revenue Growth %
- Expense Ratio
- Running Total Revenue
- QoQ Profit Change
- Product Revenue Share %
- Regional Margin %
- P&L Waterfall measures
- Dynamic filter measures for drill-through

## Key SQL Techniques Used
- CTEs for modular financial aggregations
- Window functions for running totals and YoY comparisons
- Joins across product, region, and transaction tables
- Subqueries for expense ratio calculations

## Author
**Aditya Dhande**
- Email: adidhande35@gmail.com
- LinkedIn: [linkedin.com/in/adityadhande](https://linkedin.com)
- Portfolio: [[Portfolio](https://adityadhande.lovable.app/)]
