-- ── 1. Executive KPI Summary ─────────────────────────────────────────────────
SELECT
    ROUND(SUM(revenue) / 1e9, 2)         AS total_revenue_b,
    ROUND(SUM(expense) / 1e9, 2)         AS total_expense_b,
    ROUND(SUM(profit)  / 1e9, 3)         AS net_profit_b,
    ROUND(SUM(expense)*100.0/SUM(revenue),1) AS expense_ratio_pct,
    ROUND(AVG(margin_pct), 1)             AS avg_margin_pct
FROM financial_records;


-- ── 2. Revenue, Expense, Profit by Product ───────────────────────────────────
SELECT
    product,
    COUNT(transaction_id)                 AS total_transactions,
    SUM(units_sold)                       AS total_units,
    ROUND(SUM(revenue) / 1e6, 0)         AS revenue_m,
    ROUND(SUM(expense) / 1e6, 0)         AS expense_m,
    ROUND(SUM(profit)  / 1e6, 0)         AS profit_m,
    ROUND(AVG(margin_pct), 1)             AS avg_margin_pct
FROM financial_records
GROUP BY product
ORDER BY revenue_m DESC;


-- ── 3. P&L Waterfall ─────────────────────────────────────────────────────────
WITH totals AS (
    SELECT
        ROUND(SUM(revenue)/1e6, 0)                                    AS gross_revenue_m,
        ROUND(SUM(CASE WHEN expense_category='Operations'
                       THEN expense ELSE 0 END)/1e6, 0)               AS cogs_m,
        ROUND(SUM(CASE WHEN expense_category='IT'
                       THEN expense ELSE 0 END)/1e6, 0)               AS operating_exp_m,
        ROUND(SUM(CASE WHEN expense_category='Marketing'
                       THEN expense ELSE 0 END)/1e6, 0)               AS marketing_m,
        ROUND(SUM(profit)/1e6, 0)                                     AS net_profit_m
    FROM financial_records
)
SELECT 'Total Revenue'  AS line_item, gross_revenue_m  AS amount_m FROM totals
UNION ALL SELECT 'COGS',             -cogs_m           FROM totals
UNION ALL SELECT 'Operating Exp',    -operating_exp_m  FROM totals
UNION ALL SELECT 'Marketing',        -marketing_m      FROM totals
UNION ALL SELECT 'Net Profit',        net_profit_m     FROM totals;


-- ── 4. Profit Margin by Region ────────────────────────────────────────────────
SELECT
    region,
    ROUND(SUM(revenue)/1e6, 0)  AS revenue_m,
    ROUND(SUM(expense)/1e6, 0)  AS expense_m,
    ROUND(SUM(profit) /1e6, 0)  AS profit_m,
    ROUND(AVG(margin_pct), 1)    AS avg_margin_pct
FROM financial_records
GROUP BY region
ORDER BY avg_margin_pct DESC;


-- ── 5. Expense Breakdown by Category ─────────────────────────────────────────
SELECT
    expense_category,
    ROUND(SUM(expense)/1e6, 0)                           AS expense_m,
    ROUND(SUM(expense)*100.0/SUM(SUM(expense)) OVER(),1) AS expense_share_pct
FROM financial_records
GROUP BY expense_category
ORDER BY expense_m DESC;


-- ── 6. Monthly Revenue Trend with Running Total (Window Functions) ────────────
SELECT
    DATE_FORMAT(date, '%Y-%m')                          AS month,
    ROUND(SUM(revenue)/1e6, 1)                          AS revenue_m,
    ROUND(SUM(expense)/1e6, 1)                          AS expense_m,
    ROUND(SUM(profit) /1e6, 1)                          AS profit_m,
    ROUND(SUM(SUM(revenue)) OVER
          (ORDER BY DATE_FORMAT(date,'%Y-%m'))/1e6, 1)  AS running_total_revenue_m
FROM financial_records
GROUP BY month
ORDER BY month;


-- ── 7. YoY Revenue & Expense Growth ──────────────────────────────────────────
WITH yearly AS (
    SELECT
        YEAR(date)               AS yr,
        ROUND(SUM(revenue)/1e6, 0) AS revenue_m,
        ROUND(SUM(expense)/1e6, 0) AS expense_m,
        ROUND(SUM(profit) /1e6, 0) AS profit_m
    FROM financial_records
    GROUP BY yr
)
SELECT
    yr,
    revenue_m,
    expense_m,
    profit_m,
    LAG(revenue_m) OVER (ORDER BY yr) AS prev_revenue_m,
    ROUND(
        (revenue_m - LAG(revenue_m) OVER (ORDER BY yr))
        *100.0 / LAG(revenue_m) OVER (ORDER BY yr), 1
    )                                  AS yoy_revenue_growth_pct
FROM yearly
ORDER BY yr;


-- ── 8. Quarterly Performance 2023 vs 2024 ────────────────────────────────────
SELECT
    YEAR(date)              AS yr,
    QUARTER(date)           AS qtr,
    CONCAT('Q',QUARTER(date)) AS quarter_label,
    ROUND(SUM(revenue)/1e6, 0) AS revenue_m,
    ROUND(SUM(profit) /1e6, 0) AS profit_m,
    ROUND(AVG(margin_pct), 1)  AS avg_margin_pct
FROM financial_records
WHERE YEAR(date) IN (2023, 2024)
GROUP BY yr, qtr
ORDER BY yr, qtr;


-- ── 9. Product × Region Revenue Heatmap ──────────────────────────────────────
SELECT
    product,
    region,
    ROUND(SUM(revenue)/1e6, 0) AS revenue_m,
    ROUND(AVG(margin_pct), 1)   AS avg_margin_pct,
    SUM(units_sold)              AS total_units
FROM financial_records
GROUP BY product, region
ORDER BY product, revenue_m DESC;


-- ── 10. Margin by Product ─────────────────────────────────────────────────────
SELECT
    product,
    ROUND(AVG(margin_pct), 1)  AS avg_margin_pct,
    ROUND(SUM(units_sold), 0)  AS total_units_sold,
    ROUND(SUM(revenue)/1e6, 0) AS revenue_m
FROM financial_records
GROUP BY product
ORDER BY avg_margin_pct DESC;


-- ── 11. Top Product by Region ─────────────────────────────────────────────────
WITH ranked AS (
    SELECT
        region,
        product,
        ROUND(SUM(revenue)/1e6, 0) AS revenue_m,
        ROW_NUMBER() OVER
            (PARTITION BY region ORDER BY SUM(revenue) DESC) AS rank_in_region
    FROM financial_records
    GROUP BY region, product
)
SELECT region, product, revenue_m
FROM ranked
WHERE rank_in_region = 1
ORDER BY revenue_m DESC;
