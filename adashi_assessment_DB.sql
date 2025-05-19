
SELECT * FROM plans_plan


SELECT * FROM withdrawals_withdrawal;

SELECT * FROM savings_savingsaccount;

SELECT * FROM users_customuser;




-- Removing Duplicates from plans_plan table
SELECT id, name, description, amount, start_date,last_charge_date, next_charge_date,created_on,
frequency_id,owner_id, status_id, interest_rate, withdrawal_date, default_plan, plan_type_id, 
goal,locked, next_returns_date, last_returns_date, cowry_amount, debit_card, is_archived, 
is_deleted, is_goal_achieved, is_a_goal, is_interest_free, plan_group_id, is_deleted_from_group, 
is_a_fund, purchased_fund_id, is_a_wallet, currency_is_dollars, is_auto_rollover, 
is_vendor_plan, plan_source, is_donation_plan, donation_description, donation_expiry_date, 
donation_link,	link_code, charge_payment_fee, donation_is_approved,is_emergency_plan, 
is_personal_challenge, currency_id,	is_a_usd_index, usd_index_id, open_savings_plan, new_cycle,
recurrence, is_bloom_note, is_managed_portfolio, 
portfolio_holdings_id, is_fixed_investment, is_regular_savings, preset_id,
COUNT(*) AS duplicate_count
FROM plans_plan
GROUP BY 
id, name, description, amount, start_date,last_charge_date, next_charge_date,created_on, frequency_id,
owner_id, status_id, interest_rate, withdrawal_date, default_plan, plan_type_id, goal,locked, 
next_returns_date, last_returns_date, cowry_amount, debit_card, is_archived, is_deleted, is_goal_achieved, 
is_a_goal, is_interest_free, plan_group_id, is_deleted_from_group, is_a_fund, purchased_fund_id, 	
is_a_wallet, currency_is_dollars, is_auto_rollover, 
is_vendor_plan, plan_source, is_donation_plan,
donation_description, donation_expiry_date, donation_link,	
link_code, charge_payment_fee, donation_is_approved,
is_emergency_plan, is_personal_challenge, currency_id,	
is_a_usd_index, usd_index_id, open_savings_plan, new_cycle,
recurrence, is_bloom_note, is_managed_portfolio, 
portfolio_holdings_id, is_fixed_investment, is_regular_savings, preset_id
HAVING COUNT(*) > 1;

-- Checking Duplicates from withdrawals_withdrawal
SELECT 
id, amount, amount_withdrawn, transaction_reference,	transaction_date, new_balance,
bank_id, owner_id, plan_id, transaction_channel_id,	transaction_status_id,
transaction_type_id, fee_in_kobo, description, gateway, gateway_response, session_id,	
currency, fee_in_cents, payment_id, created_on, updated_on, withdrawal_intent_id, 
COUNT(*) AS duplicate_count
FROM withdrawals_withdrawal
GROUP BY 
id, amount, amount_withdrawn, transaction_reference,	transaction_date, new_balance,
bank_id, owner_id, plan_id, transaction_channel_id,	transaction_status_id,
transaction_type_id, fee_in_kobo, description, gateway, gateway_response, session_id,	
currency, fee_in_cents, payment_id, created_on, updated_on, withdrawal_intent_id
HAVING COUNT(*) > 1










-- Task 1: : Write a query to find customers with at least one 
-- funded savings plan AND one funded investment plan, sorted by total deposits.

 SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.balance + p.balance) AS total_deposits
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id AND s.is_funded = TRUE
LEFT JOIN 
    plans_plan p ON u.id = p.owner_id AND p.is_funded = TRUE
WHERE 
    s.id IS NOT NULL AND p.id IS NOT NULL
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    savings_count > 0 AND investment_count > 0
ORDER BY 
    total_deposits DESC;



--Task 2: Calculate the average number of transactions per customer per month and categorize them:
--●	"High Frequency" (≥10 transactions/month)
--●	"Medium Frequency" (3-9 transactions/month)
--●	"Low Frequency" (≤2 transactions/month)

WITH monthly_transactions AS (
    -- Step 1: Count transactions per customer per month
    SELECT 
        CONCAT(u.first_name,' ', u.last_name) AS customer_name,
        DATE_TRUNC('month', transaction_date) AS transaction_month,
        COUNT(*) AS transaction_count
    FROM 
          savings_savingsaccount AS s
	JOIN 
	      users_customuser AS U
	ON u.id = s.owner_id 
    GROUP BY 
        CONCAT(u.first_name,' ', u.last_name) , DATE_TRUNC('month', transaction_date)
),
average_transactions AS (
    -- Step 2: Calculate the average transactions per month for each customer
    SELECT 
        customer_name,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM 
        monthly_transactions
    GROUP BY 
        customer_name
)
-- Step 3: Categorize customers based on their average transaction frequency
SELECT 
    
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
	COUNT(customer_name) AS customer_count,
    avg_transactions_per_month
FROM 
    average_transactions
GROUP BY 
	avg_transactions_per_month 
ORDER BY 
    customer_count DESC


	  






--Task 3: Find all active accounts (savings or investments) with no transactions in the 
--last 1 year (365 days)
SELECT description,
COUNT(*) AS no_acct
FROM  savings_savingsaccount
GROUP BY description




--Task 4: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
--●	Account tenure (months since signup)
--●	Total transactions
--●	Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
--●	Order by estimated CLV from highest to lowest
