-- Identify investment or savings plans with no transaction in over 365 days
WITH latest_tx AS (
    SELECT
        plan_id,
        MAX(created_on) AS last_transaction_date  -- Most recent transaction date per plan
    FROM
        savings_savingsaccount
    GROUP BY
        plan_id
),
     plan_activity AS (
         SELECT
             p.id AS plan_id,
             p.owner_id,
             CASE
                 WHEN p.is_a_goal = 1 THEN 'Savings'
                 WHEN p.is_a_fund = 1 OR p.is_fixed_investment = 1 THEN 'Investment'
                 ELSE 'Other'
                 END AS type,  -- Classify plan type
             l.last_transaction_date,
             DATEDIFF(CURRENT_DATE, l.last_transaction_date) AS inactivity_days  -- Calculate inactivity in days
         FROM
             plans_plan p
                 LEFT JOIN latest_tx l ON p.id = l.plan_id  -- Join latest transaction data to each plan
         WHERE
             p.is_a_goal = 1 OR p.is_a_fund = 1 OR p.is_fixed_investment = 1  -- Consider only savings or investment plans
     )
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM
    plan_activity
WHERE
    last_transaction_date IS NOT NULL  -- Ignore plans with no transactions ever
  AND inactivity_days > 365  -- Select only plans inactive for more than a year
ORDER BY
    inactivity_days DESC;  -- Sort by longest inactivity
