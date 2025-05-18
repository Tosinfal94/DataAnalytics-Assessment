use adashi_staging;

-- Assessment Q2

WITH user_tx_summary AS (
    SELECT
        sa.owner_id,
        COUNT(*) AS total_transactions,
        PERIOD_DIFF(
            DATE_FORMAT(MAX(sa.transaction_date), '%Y%m'),
            DATE_FORMAT(MIN(sa.transaction_date), '%Y%m')
        ) + 1 AS active_months
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),
user_avg_tx AS (
    SELECT
        u.owner_id,
        ROUND(total_transactions / active_months, 2) AS avg_tx_per_month
    FROM user_tx_summary u
),
user_categories AS (
    SELECT
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM user_avg_tx
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM user_categories
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
