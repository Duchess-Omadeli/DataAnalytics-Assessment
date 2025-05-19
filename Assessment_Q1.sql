-- Select the total deposits, savings count, and investment count per user (with at least one of each type), ordered by deposit amount
SELECT
    u.id AS owner_id,  -- User ID
    CONCAT(u.first_name, " ", u.last_name) AS name,  -- Full name of user
    COUNT(DISTINCT CASE WHEN p.is_a_goal = 1 THEN p.id END) AS savings_count,  -- Count of unique savings plans
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 OR p.is_fixed_investment = 1 THEN p.id END) AS investment_count,  -- Count of unique investment plans
    ROUND(SUM(s.amount), 2) AS total_deposits  -- Sum of deposit amounts rounded to 2 decimal places
FROM
    users_customuser u
        JOIN plans_plan p ON p.owner_id = u.id  -- Join plans with users
        JOIN savings_savingsaccount s ON s.plan_id = p.id  -- Join savings accounts with plans
WHERE
    s.amount > 0  -- Only include positive deposit transactions
GROUP BY
    u.id, u.name
HAVING
    savings_count >= 1 AND investment_count >= 1  -- Filter for users with both savings and investment plans
ORDER BY
    total_deposits DESC;  -- Sort by highest total deposits
