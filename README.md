# DataAnalytics-Assessment
# Customer Transaction Analysis – SQL Assessment

This repository contains SQL scripts that I used to complete the assessment. The database used is `adashi_staging`.

---

##  Overview of Assessments

### **Assessment Q1**
**Objective**: Get total savings and investment activity per user, including:
- Count of savings and investment accounts
- Sum of all deposits (converted from **kobo to naira**)
- Full customer name

**Tables Involved**:
- `users_customuser`
- `savings_savingsaccount`
- `plans_plan`

**Key Logic**:
- Used **`INNER JOIN`** subqueries to aggregate savings and investment per user.
- Calculated `total_deposits` by summing both and dividing by 100 (from kobo to naira).
- Used `COALESCE` and `CONCAT` to handle cases where `name` might be null.

---

###  **Assessment Q2**
**Objective**: Analyze how frequently users transact and segment them as:
- **High Frequency**: ≥10 transactions/month
- **Medium Frequency**: 3–9 transactions/month
- **Low Frequency**: ≤2 transactions/month

**Tables Involved**:
- `savings_savingsaccount`

**Key Logic**:
- Used `PERIOD_DIFF` between first and last transaction date to compute active months.
- Computed average transactions/month per user.
- Used a `CASE` statement to assign frequency category.

**Note**: Used `FIELD()` in `ORDER BY` to force custom ordering of the frequency segments.

---

###  *Assessment Q3**
**Objective**: Identify **active plans** (savings or investment) with **no transactions in over 365 days**.

**Tables Involved**:
- `savings_savingsaccount`
- `plans_plan`

**Key Logic**:
- Filtered only relevant plans using `is_regular_savings = 1` or `is_a_fund = 1`.
- Extracted `MAX(transaction_date)` per plan to determine last activity.
- Used `DATEDIFF` to calculate inactivity in days and filtered where it's > 365.

---

### **Assessment Q4**
**Objective**: Estimate the **CLV** per customer using:
- `CLV = (Transactions / Tenure) * 12 * Avg Profit per Transaction`
- Where profit per transaction = 0.1% of transaction value

**Tables Involved**:
- `savings_savingsaccount`
- `users_customuser`

**Key Logic**:
- Extracted account tenure in **months** using `TIMESTAMPDIFF`.
- Converted all amounts from **kobo to naira**.
- Used `NULLIF` to avoid division by zero.
- Profit per transaction: `0.001 * total_value / transaction_count`
