-- Customer Churn Analysis
-- SQL analysis of customer churn patterns

USE customer_churn_analysis;

-- 1. Overall churn rate

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned;


-- 2. Churn rate by contract type

SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- 3. Churn rate by tenure group

SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
        WHEN tenure BETWEEN 61 AND 72 THEN '61-72 months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
GROUP BY tenure_group
ORDER BY
    CASE tenure_group
        WHEN '0-12 months' THEN 1
        WHEN '13-24 months' THEN 2
        WHEN '25-48 months' THEN 3
        WHEN '49-60 months' THEN 4
        WHEN '61-72 months' THEN 5
    END;


    -- 4. Churn rate by internet service

SELECT
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;

-- 5. Churn rate by payment method

SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- 6. Churn by contract type and internet service

SELECT
    Contract,
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
GROUP BY Contract, InternetService
ORDER BY churn_rate_pct DESC;


-- 7. Average monthly charges by churn status

SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges,
    ROUND(AVG(tenure), 2) AS avg_tenure_months
FROM telco_customer_churn_cleaned
GROUP BY Churn;


-- 8. Churn rate by monthly charge group

SELECT
    CASE
        WHEN MonthlyCharges < 30 THEN 'Under $30'
        WHEN MonthlyCharges < 60 THEN '$30-$59.99'
        WHEN MonthlyCharges < 90 THEN '$60-$89.99'
        ELSE '$90+'
    END AS monthly_charge_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
GROUP BY monthly_charge_group
ORDER BY
    CASE monthly_charge_group
        WHEN 'Under $30' THEN 1
        WHEN '$30-$59.99' THEN 2
        WHEN '$60-$89.99' THEN 3
        WHEN '$90+' THEN 4
    END;


    -- 9. High-risk customer segment

SELECT
    COUNT(*) AS high_risk_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco_customer_churn_cleaned
WHERE Contract = 'Month-to-month'
  AND InternetService = 'Fiber optic'
  AND tenure <= 12;