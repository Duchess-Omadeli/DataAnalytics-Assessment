-- This query identifies all user plans that are either savings or investments
-- and have been inactive (i.e., had no transactions) for more than 365 days.

-- Step 1: Get the most recent transaction date for each plan
WITH latest_tx AS (
    SELECT
        plan_id,
        MAX(created_on) AS last_transaction_date  -- Find the latest transaction date for each plan
    FROM
        savings_savingsaccount
    GROUP BY
        plan_id
),

-- Step 2: Enrich each plan with type, last transaction date, and inactivity duration
     plan_activity AS (
         SELECT
             p.id AS plan_id,
             p.owner_id,
             CASE
                 WHEN p.is_a_goal = 1 THEN 'Savings'  -- Classify as savings plan
                 WHEN p.is_a_fund = 1 OR p.is_fixed_investment = 1 THEN 'Investment'  -- Classify as investment plan
                 ELSE 'Other'  -- Fallback for any other plan type
                 END AS type,
             l.last_transaction_date,
             DATEDIFF(CURRENT_DATE, l.last_transaction_date) AS inactivity_days  -- Days since last transaction
         FROM
             plans_plan p
                 LEFT JOIN latest_tx l ON p.id = l.plan_id  -- Join to get last transaction per plan
         WHERE
             p.is_a_goal = 1 OR p.is_a_fund = 1 OR p.is_fixed_investment = 1  -- Consider only savings and investment plans
     )

-- Step 3: Select only inactive plans (no transactions in the last year)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM
    plan_activity
WHERE
    last_transaction_date IS NOT NULL  -- Exclude plans with no transactions ever
  AND inactivity_days > 365  -- Filter for plans inactive for more than one year
ORDER BY
    inactivity_days DESC;  -- Show the most inactive plans first
