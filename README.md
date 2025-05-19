# 📊 DataAnalytics-Assessment

Welcome to my **SQL Proficiency Assessment** repository. This collection of SQL queries is designed to demonstrate my ability to extract, transform, and analyze data in a relational database system to solve real-world business problems. Each solution is focused on clarity, accuracy, and efficiency.


---

## 📁 Per-Question Explanations

---

### Assessment_Q1.sql – *High-Value Customers with Multiple Products*
**Objective**: Identify customers with at least one funded savings plan and one funded investment plan, then rank them by total deposits.

**Approach**:
- Join `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Filter for funded savings (`is_a_goal = 1`) and funded investments (`is_a_fund = 1` or `is_fixed_investment = 1`).
- Group by user and calculate:
  - Count of savings plans
  - Count of investment plans
  - Total deposit value
- Use `HAVING` clause to ensure users have both savings and investment products.

---

### Assessment_Q2.sql – *Transaction Frequency Analysis*
**Objective**: Classify customers by average monthly transaction frequency.

**Approach**:
- Group savings transactions by user and month.
- Count total transactions per customer and compute average per month.
- Categorize customers using CASE WHEN:
  - ≥10 = High Frequency
  - 3–9 = Medium Frequency
  - ≤2 = Low Frequency
- Aggregate final results by frequency category and compute averages.

---

### Assessment_Q3.sql – *Account Inactivity Alert*
**Objective**: Flag savings or investment plans that have had no inflow in over one year.

**Approach**:
- Determine the last transaction date per plan.
- Calculate days of inactivity using `DATEDIFF`.
- Filter for plans with no activity in over 365 days.
- Classify plans as "Savings", "Investment", or "Other".

---

### Assessment_Q4.sql – *Customer Lifetime Value (CLV) Estimation*
**Objective**: Estimate each customer's CLV based on tenure and transaction activity.

**Approach**:
- Calculate account tenure in months using signup date and current date.
- Sum total transaction volume per customer.
- Apply CLV formula:  
  `CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction`
- Use `0.1%` of transaction value as profit per transaction.
- Sort by highest estimated CLV.

---

## ⚙️ Challenges Encountered

- **Data Normalization**: Some monetary values were in kobo and had to be converted to naira for accurate interpretation.
- **Handling NULLs**: Inactivity and transaction analyses required careful handling of users with no records (LEFT JOINs and NULL filtering).
- **Monthly Aggregation**: Grouping by customer per month needed careful handling of date truncation to avoid incorrect frequency buckets.

---

## 📌 Notes

- All queries use standard SQL and are tested in a MySQL-compatible environment.
- Data was assumed to be clean and structured as described in the assessment (e.g., field names like `confirmed_amount`, `created_on`, etc.).

---
