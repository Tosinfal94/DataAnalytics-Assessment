use adashi_staging;

-- Assessment Q4

WITH transaction_summary AS (
    SELECT 
        sa.owner_id,
        COUNT(*) AS total_transactions,
        SUM(sa.confirmed_amount) / 100 AS total_transaction_value_naira  -- Converts from kobo to Naira
    FROM savings_savingsaccount sa
    WHERE sa.confirmed_amount > 0
    GROUP BY sa.owner_id
),
user_tenure AS (
    SELECT 
        uc.id AS customer_id,
        CONCAT_WS(' ', uc.first_name, uc.last_name) AS name, 
        TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser uc
),
clv_calc AS (
    SELECT 
        ut.customer_id,
        ut.name,
        ut.tenure_months,
        ts.total_transactions,
        ROUND(
            (ts.total_transactions / NULLIF(ut.tenure_months, 0)) * 12 * 
            (0.001 * ts.total_transaction_value_naira / NULLIF(ts.total_transactions, 0)), 2
        ) AS estimated_clv
    FROM user_tenure ut
    INNER JOIN transaction_summary ts ON ut.customer_id = ts.owner_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;


