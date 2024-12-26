-- Checking Data Tables
Select * 
From employee_test;

Select * 
From employee_perf;

-- DESCRIPTIVE: Employee Demography 
-- 1. How many employees do we have in the organisation and what is the maximum length of service?
SELECT COUNT("employee_id"), MAX("length_of_service")
FROM employee_test;

-- 2. How many employees are there in each department?
SELECT "department", COUNT("employee_id") AS "NumberOfEmployee"
FROM employee_test
GROUP BY "department";

-- 3. What is the proportion of male to female employees?
SELECT "gender", COUNT("employee_id")
FROM employee_test
GROUP BY "gender";

-- 4. Group Employee age into 5 categories (20– 29, 30– 39, 40-49, 50-59, >60). What age group has the highest and lowest employee?
SELECT
      CASE
          WHEN "age" BETWEEN 20 and 29 THEN '20-29'
          WHEN "age" BETWEEN 30 and 39 THEN '30-39'
          WHEN "age" BETWEEN 40 and 49 THEN '40-49'
          WHEN "age" BETWEEN 50 and 59 THEN '50-59'
          ELSE '>60'
      END AS "AgeBracket", COUNT("employee_id") AS "NumberOfEmployee"
FROM employee_test
GROUP BY "AgeBracket"
ORDER BY "NumberOfEmployee";

-- 5. Which department has the most employees and has the fewest employees?
SELECT "department", COUNT("employee_id") AS "NumberOfEmployee"
FROM employee_test
GROUP BY "department"
ORDER BY "NumberOfEmployee";

-- DIAGNOSTIC: Employee Performance
-- 1. Who has the highest average training score among all employees?
SELECT "employee_id", MAX("avg_training_score") AS "MaxScore"
FROM employee_test
GROUP BY "employee_id"
ORDER BY "MaxScore" DESC
LIMIT 5;

-- 2. What is the average training score of employees in each department
SELECT "department", AVG("avg_training_score") AS "DeptAvgScore"
FROM employee_test
GROUP BY "department"

-- 2. What is the average training score of employees in each department
SELECT "department", ROUND(AVG("avg_training_score"), 1) AS "DeptAvgScore"
FROM employee_test
GROUP BY "department";

-- 3. What is the average rating for the previous year by department?
SELECT "department", ROUND(AVG("previous_year_rating"), 1) AS "AvgPrevRating"
FROM employee_test
GROUP BY "department";

-- 4. What is the average training score of employees by education type?
SELECT COALESCE("education", 'N/A'), ROUND(AVG("avg_training_score"), 1) AS "DeptAvgScore"
FROM employee_test
GROUP BY "education";

-- 5. What is the average previous year rating by recruitment channel?
SELECT "recruitment_channel", ROUND(AVG("previous_year_rating"), 1) AS "AvgPrevRating"
FROM employee_test
GROUP BY "recruitment_channel";

-- 6. Based on the age group created what is the average previous year rating and average training score?
SELECT
      CASE
          WHEN "age" BETWEEN 20 and 29 THEN '20-29'
          WHEN "age" BETWEEN 30 and 39 THEN '30-39'
          WHEN "age" BETWEEN 40 and 49 THEN '40-49'
          WHEN "age" BETWEEN 50 and 59 THEN '50-59'
          ELSE '>60'
      END AS "AgeBracket", ROUND(AVG("previous_year_rating"), 1) AS "AvgPrevRating",
ROUND(AVG("avg_training_score"), 2) AS "AvgTrainingScore"
FROM employee_test
GROUP BY "AgeBracket";

-- 7. Group Average training scores into grades (A,B,C,D,E,F) and what grade had the highest and lowest number of employees?
SELECT
      CASE
          WHEN "avg_training_score" BETWEEN 0 AND 39 THEN 'F'
          WHEN "avg_training_score" BETWEEN 40 AND 44 THEN 'E'
          WHEN "avg_training_score" BETWEEN 45 AND 49 THEN 'D'
          WHEN "avg_training_score" BETWEEN 50 AND 59 THEN 'C'
          WHEN "avg_training_score" BETWEEN 60 AND 69 THEN 'B'
          ELSE 'A'
      END AS "Grade", COUNT("employee_id") AS "NumberOfEmployee"
FROM employee_test
GROUP BY "Grade"
ORDER BY "NumberOfEmployee"

-- DIAGNOSTIC: Attrition Analysis
-- 1. What is the Average Attrition Rate?
SELECT attrition
FROM employee_perf;
-- Convert the attrition rate (yes, no) to numerical values
SELECT
      Round(Avg(CASE WHEN "attrition" = 'Yes' THEN 1 ELSE 0
   END), 3) AS "AttritionRate"
FROM employee_perf;

-- 2. Which regions have the highest rate of departures (employees who have left), and what are the corresponding departments?
SELECT "region",
     SUM(CASE WHEN "attrition" = 'Yes' THEN 1 ELSE 0 
     END) AS "NoOfAttrition"
From employee_perf
LEFT JOIN employee_test ON employee_test.employee_id = employee_perf.employee_id
GROUP BY "region"
ORDER BY "NoOfAttrition" DESC;

-- 3. Which departments have the highest average job satisfaction?
SELECT "department", ROUND(Avg(jobsatisfaction),2) AS "AvgSatisfaction"
FROM employee_perf
LEFT JOIN employee_test ON employee_test.employee_id = employee_perf.employee_id
GROUP BY "department"
ORDER BY "AvgSatisfaction" DESC;

-- 4. Which regions have the highest average job satisfaction and what is the the rating?
SELECT "region", ROUND(Avg(jobsatisfaction),2) AS "AvgSatisfaction"
FROM employee_perf
LEFT JOIN employee_test ON employee_test.employee_id = employee_perf.employee_id
GROUP BY "region"
ORDER BY "AvgSatisfaction" DESC;

-- 5. Which departments have the highest rate of departures?
SELECT "department",
     SUM(CASE WHEN "attrition" = 'Yes' THEN 1 ELSE 0 
     END) AS "NoOfAttrition"
From employee_perf
LEFT JOIN employee_test ON employee_test.employee_id = employee_perf.employee_id
GROUP BY "department"
ORDER BY "NoOfAttrition" DESC;
