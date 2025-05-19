# DataAnalytics-Assessment
This repository contains the solutions to the SQL assessment questions for the Data Analytics assessment. Each question has been answered using a structured SQL query, and all necessary explanations and challenges encountered are documented below.
## Repository Structure
DataAnalytics-Assessment/
├── Assessment_Q1.sql  # Solution for Question 1
├── Assessment_Q2.sql  # Solution for Question 2
├── Assessment_Q3.sql  # Solution for Question 3
├── Assessment_Q4.sql  # Solution for Question 4
└── README.md          # Explanation and documentation
## Per-Question Explanations
## Question 1
The query identifies customers with at least one funded savings plan and one funded investment plan, sorted by their total deposits.

SELECT Clause
Retrieves:

owner_id: The unique ID of the customer.

name: Full name of the customer, created by concatenating their first and last names.

savings_count: The number of distinct funded savings accounts (savings_savingsaccount) per customer.

investment_count: The number of distinct funded investment plans (plans_plan) per customer.

total_deposits: The sum of balances from funded savings accounts and investment plans.

FROM and LEFT JOIN Clauses
users_customuser (Main Table): Base table containing customer information.

savings_savingsaccount and plans_plan: Joined on owner_id, with filters for funded accounts (s.is_funded = TRUE and p.is_funded = TRUE).

WHERE Clause
Ensures only customers with at least one matching savings (s.id IS NOT NULL) and one matching investment (p.id IS NOT NULL) are considered.

GROUP BY Clause
Groups data by each customer (u.id, u.first_name, u.last_name) to calculate aggregate metrics like savings_count, investment_count, and total_deposits.

HAVING Clause
Filters out customers who don’t meet the criteria of at least one funded savings account (savings_count > 0) and one funded investment plan (investment_count > 0).

ORDER BY Clause
Sorts the resulting customers by their total deposits in descending order (total_deposits DESC).


## Question 2
Step 1: Counting Transactions per Customer per Month
Purpose: This step creates a temporary dataset (monthly_transactions) that counts how many transactions each customer made in each month.

Key Points:

It uses CONCAT to combine the first and last names of customers into a full name.

Transactions are grouped by the month (DATE_TRUNC('month', transaction_date)) and customer.

COUNT(*) calculates the number of transactions for each group.

Step 2: Calculating the Average Transactions per Month
Purpose: This step calculates the average number of transactions per month for each customer.

Key Points:

It uses the AVG function on transaction_count from the monthly_transactions dataset.

Groups the data by customer_name to compute the per-customer average.

Step 3: Categorizing Customers Based on Transaction Frequency
Purpose: Classify customers into frequency categories (High, Medium, or Low) based on their average monthly transactions.

Key Points:

A CASE statement defines the frequency category:

High Frequency: ≥10 transactions/month

Medium Frequency: 3–9 transactions/month

Low Frequency: ≤2 transactions/month

COUNT(customer_name) calculates the number of customers in each category.

The results are grouped by avg_transactions_per_month and sorted by the customer count (customer_count DESC).

Question 3


Question 4

## Challenges
Question 2: Ambiguity in Column Names
Issue: Some column names were ambiguous, making it challenging to interpret their purpose.

Resolution: Reviewed the schema documentation and verified data relationships to ensure accurate usage.

## General Challenge: Query Optimization
Issue: Some queries took longer to execute due to large datasets.

Resolution: Reviewed indexing and applied best practices such as filtering early in the query.

