use adashi_staging;

-- Assessment Q2

SELECT 
    u.id AS owner_id,
    COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name,
    s.savings_count,
    i.investment_count,
    ROUND((s.total_savings_amount + i.total_investment_amount) / 100, 2) AS total_deposits
FROM users_customuser u
INNER JOIN (
    SELECT 
        sa.owner_id,
        COUNT(*) AS savings_count,
        SUM(sa.confirmed_amount) AS total_savings_amount
    FROM savings_savingsaccount sa
    INNER JOIN plans_plan p ON sa.plan_id = p.id
    WHERE p.is_regular_savings = 1 AND sa.confirmed_amount > 0
    GROUP BY sa.owner_id
) s ON u.id = s.owner_id
INNER JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(amount) AS total_investment_amount
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0
    GROUP BY owner_id
) i ON u.id = i.owner_id
ORDER BY total_deposits DESC;

