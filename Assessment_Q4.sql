-- Step 1: Aggregate transaction volume per customer
WITH user_tx AS (
    SELECT
        p.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) / 100.0 AS total_transaction_value_naira
    FROM
        savings_savingsaccount s
            INNER JOIN
        plans_plan p ON s.plan_id = p.id
    WHERE
        p.is_regular_savings = 1 OR p.is_a_fund = 1  -- Filter for savings & investment plans
    GROUP BY
        p.owner_id
),

-- Step 2: Calculate tenure in months
     user_tenure AS (
         SELECT
             id AS customer_id,
             CONCAT(first_name, ' ', last_name) AS name,
             TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
         FROM
             users_customuser
     ),

-- Step 3: Combine and estimate CLV
     clv_calc AS (
         SELECT
             t.owner_id as customer_id,
             u.name,
             u.tenure_months,
             t.total_transactions,

             -- Avoid division by zero for new customers
             CASE
                 WHEN u.tenure_months = 0 THEN 0
                 ELSE ROUND((t.total_transactions / u.tenure_months) * 12 * (t.total_transaction_value_naira / t.total_transactions * 0.001), 2)
                 END AS estimated_clv
         FROM
             user_tx t
                 JOIN
             user_tenure u ON t.owner_id = u.customer_id
     )

-- Final Output
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM
    clv_calc
ORDER BY
    estimated_clv DESC;