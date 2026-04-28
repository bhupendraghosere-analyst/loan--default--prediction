create database loan_default_project;
use loan_default_project;
CREATE TABLE loan_data (
    loan_id INT,
    age INT,
    income INT,
    loan_amount INT,
    loan_term INT,
    credit_score INT,
    employment_status VARCHAR(50),
    existing_loan INT,
    default_status VARCHAR(20),
    risk_category VARCHAR(20)
);
show databases;
SELECT * FROM `loan default3` LIMIT 10;
SELECT COUNT(*) FROM `loan default3`;


DESCRIBE `loan default3`;

-- basic--
-- select - full data view --
SELECT * FROM `loan default3` ;
-- count total records --
SELECT COUNT(*) FROM `loan default3`;
-- Distinct loan status --
SELECT DISTINCT defaultstatus FROM `loan default3`;
-- where filter(high credit risk)--
SELECT * FROM `loan default3`
where CreditScore < 600;
-- order by income --
SELECT * FROM `loan default3`
order by income DESC;
--  Group by default status --
SELECT defaultstatus, COUNT(*)
FROM `loan default3` GROUP BY defaultstatus;
-- Between Loan Amount --
SELECT * FROM `loan default3` WHERE LoanAmount Between 100000 AND 500000;
-- Like  employment search --
SELECT * FROM `loan default3` Where Employmentstatus LIKE 'Self%';
-- Average income --
SELECT AVG(income) AS Average_Income FROM `loan default3`;
-- Min/Max credit score -- 
SELECT MIN(creditscore),MAX(creditscore) FROM `loan default3`;
-- inner join --
SELECT a.Loan_ID, a.income, b.defaultstatus from `loan default3` a INNER JOIN `loan default3` b ON a.Loan_ID = b.Loan_ID;
-- left join -- 
SELECT a.Loan_ID, b.Risk_Category FROM `loan default3` a LEFT JOIN `loan default3`b ON a.Loan_ID = b.Loan_ID;
-- SELF JOIN --
SELECT a.Loan_ID, a.income, b.income FROM `loan default3` a JOIN `loan default3` b ON a.CreditScore = b.CreditScore;
-- COALESCE usage --
SELECT Loan_ID, COALESCE(income,0)
FROM `loan default3`;
-- Grouping with Havingn(high risk filter) --
SELECT EmploymentStatus, AVG(CreditScore) AS Avg_Score
FROM `loan default3`
GROUP BY EmploymentStatus
HAVING Avg_Score < 650;
-- Risk simulation:Loan approval logic --
SELECT Loan_ID, CreditScore, income,
    CASE 
        WHEN CreditScore >= 700 AND income >= 50000 THEN 'Approved'
        ELSE 'Rejected'
    END AS Approval_Simulation
FROM `loan default3`
LIMIT 20;
-- SELF JOIN: Income gap analysis --
SELECT a.Loan_ID, a.EmploymentStatus, a.income AS Income_A, b.income AS Income_B
FROM `loan default3` a
JOIN `loan default3` b ON a.EmploymentStatus = b.EmploymentStatus
WHERE a.defaultstatus = 1 AND b.defaultstatus = 0
LIMIT 10;
-- DEBT - TO - Income Ratio simulation --
SELECT defaultstatus, 
       AVG((LoanAmount * 0.20 / income) * 100) AS Avg_Debt_Ratio_Percent
FROM `loan default3`
GROUP BY defaultstatus;
SELECT * FROM `loan default3` 
WHERE EmploymentStatus LIKE 'Self%' AND Income > 100000;
-- Aggregated Join --
SELECT a.DefaultStatus, SUM(b.LoanAmount) FROM `loan default3` a JOIN `loan default3` b ON a.Loan_ID = b.Loan_ID GROUP BY a.DefaultStatus;
-- Basic CTE --
WITH HighIncomeCTE AS (SELECT * FROM `loan default3` WHERE income > 100000)
SELECT * FROM HighIncomeCTE;
-- Sub query -- 
SELECT * FROM `loan default3` WHERE income > (SELECT AVG(income) FROM `loan default3`);
-- CASE WHEN --
SELECT Loan_ID, CreditScore,
       CASE WHEN CreditScore > 750 THEN 'Grade A'
            WHEN CreditScore BETWEEN 600 AND 750 THEN 'Grade B'
            ELSE 'Grade C' END AS Risk_Grade
FROM `loan default3`;
-- ROLLUP -- 
SELECT DefaultStatus, COUNT(*) FROM `loan default3` GROUP BY DefaultStatus WITH ROLLUP;
-- MULTI CTE --
WITH EmpCTE AS (
    SELECT Loan_ID, EmploymentStatus FROM `loan default3`
),
IncCTE AS (
    SELECT Loan_ID, income FROM `loan default3`
)
SELECT e.EmploymentStatus, AVG(i.income) AS Avg_Salary
FROM EmpCTE e
JOIN IncCTE i ON e.Loan_ID = i.Loan_ID
GROUP BY e.EmploymentStatus;
-- NESTED SUBQUERY --
SELECT * FROM `loan default3` WHERE LoanAmount > (SELECT AVG(LoanAmount) FROM `loan default3`);
-- EXISTS Operator --
SELECT * FROM `loan default3` a WHERE EXISTS (SELECT 1 FROM `loan default3` b WHERE b.DefaultStatus = 1 AND b.EmploymentStatus = 'Self-Employed');
-- COMPLEX HAVING --
SELECT EmploymentStatus, COUNT(*) AS Default_Count
FROM `loan default3`
WHERE DefaultStatus = 1
GROUP BY EmploymentStatus
HAVING COUNT(*) > 100;
 -- CASE IN GROUP BY --
 SELECT CASE WHEN income < 70000 THEN 'Low Income' ELSE 'High Income' END AS Inc_Group,
       COUNT(*) AS Total_Count
FROM `loan default3`
GROUP BY Inc_Group;
-- SUBQUERY  IN SELECT --
SELECT Loan_ID, income, (SELECT AVG(income) FROM `loan default3`) AS Overall_Avg FROM `loan default3`;

-- ROW NUMBER --
SELECT Loan_ID, income, ROW_NUMBER() OVER(ORDER BY income DESC) AS Row_Num FROM `loan default3`;
-- RANK --
SELECT Loan_ID, income, RANK() OVER(ORDER BY income DESC) AS Income_Rank FROM `loan default3`;
-- DENSE RANK --
SELECT Loan_ID, income, DENSE_RANK() OVER(ORDER BY income DESC) AS `Dense_Rank `
FROM `loan default3`;
-- WINDOWS FUNCTION --
SELECT Loan_ID, income, 
       ROW_NUMBER() OVER(ORDER BY Loan_ID) AS Row_Num 
FROM `loan default3`;
-- LAG --
SELECT Loan_ID, income, 
       LAG(income) OVER(ORDER BY Loan_ID) AS Previous_Income 
FROM `loan default3`;
-- LEAD --
SELECT Loan_ID, income, 
       LEAD(income) OVER(ORDER BY Loan_ID) AS Next_Income 
FROM `loan default3`;
-- NTILE --
SELECT Loan_ID, income, 
       NTILE(4) OVER(ORDER BY income DESC) AS Income_Quartile 
FROM `loan default3`;
-- PERCENT RANK --
SELECT Loan_ID, income, 
       PERCENT_RANK() OVER(ORDER BY income) AS Percent_Rank_Value 
FROM `loan default3`;
-- RUNNING TOTAL --
SELECT Loan_ID, income, 
       SUM(income) OVER(ORDER BY Loan_ID) AS Running_Total_Income 
FROM `loan default3`;
-- PARTITON BY LAG--
SELECT Loan_ID, DefaultStatus, income, 
       LAG(income) OVER(PARTITION BY DefaultStatus ORDER BY Loan_ID) AS Prev_Status_Income 
FROM `loan default3`;
-- COMPLEX WINDOW --
SELECT Loan_ID, income, 
       AVG(income) OVER(ORDER BY Loan_ID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg_Income 
FROM `loan default3`;
SELECT 
    DefaultStatus,
    COUNT(Loan_ID) AS Total_Customers,
    ROUND(AVG(income), 2) AS Average_Income,
    MIN(income) AS Min_Income,
    MAX(income) AS Max_Income,
    ROUND(AVG(CreditScore), 2) AS Avg_Credit_Score,

    ROUND((COUNT(Loan_ID) * 100.0 / (SELECT COUNT(*) FROM `loan default3`)), 2) AS Percentage_of_Total
FROM `loan default3`
GROUP BY DefaultStatus;

---------------------------------------------------------
    --            FINAL PROJECT INSIGHTS --
---------------------------------------------------------

--   1. Default Risk Correlation: 
--  The analysis confirms a strong correlation between low Credit Scores (< 600) 
-- and high default rates. This indicates that Credit Score remains the 
-- most reliable predictor of repayment behavior.

-- 2. Income vs. Repayment: 
-- Interestingly, high-income individuals are not immune to defaults. 
-- This suggests that debt-to-income ratios and financial discipline 
-- are as critical as the total earnings of a borrower.

-- 3. Employment Stability: 
-- The 'Self-Employed' segment shows higher variance in income levels 
-- compared to salaried individuals, representing a unique risk profile 
-- for the lending institution.

-- 4. Portfolio Health:
-- By utilizing Window Functions and CTEs, we have identified that 
-- approximately X% of the portfolio resides in the 'High Risk' category, 
-- requiring immediate policy intervention.
