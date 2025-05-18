use adashi_staging;

-- Assessment Q3

WITH latest_tx AS (
    SELECT 
        sa.plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        MAX(sa.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount sa
    JOIN plans_plan p ON sa.plan_id = p.id
    WHERE sa.confirmed_amount > 0
      AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    GROUP BY sa.plan_id, p.owner_id, type
),
inactivity AS (
    SELECT 
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
    FROM latest_tx
)
SELECT *
FROM inactivity
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
