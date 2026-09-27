-- ============================================================
-- Patient Analysis
-- ============================================================
-- This section explores the patient population, including
-- demographics, geographic distribution, insurance coverage,
-- chronic conditions, and age groups.
-- ============================================================


SELECT 
    COUNT(*) AS total_patients
FROM
    patients_clean;



-- 2. Gender Distribution
-- Show the number and percentage of patients by gender.

SELECT
    gender,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS patient_percentage
FROM patients_clean
GROUP BY gender
ORDER BY patient_count DESC;



-- 3. Patient Distribution by Country
-- Compare the patient population across countries.

SELECT
    country,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS patient_percentage
FROM patients_clean
GROUP BY country
ORDER BY patient_count DESC;



-- 4. Insurance Coverage
-- Show how patients are distributed across insurance types.

SELECT
    insurance_type,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS patient_percentage
FROM patients_clean
GROUP BY insurance_type
ORDER BY patient_count DESC;



-- 5. Chronic Conditions
-- Compare patients based on whether they have a chronic condition.

SELECT
    has_chronic_condition,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS patient_percentage
FROM patients_clean
GROUP BY has_chronic_condition
ORDER BY patient_count DESC;



-- 6. Age Group Distribution
-- Group patients into age ranges to understand the age profile.

SELECT
    CASE
        WHEN age_years < 18 THEN 'Under 18'
        WHEN age_years BETWEEN 18 AND 29 THEN '18-29'
        WHEN age_years BETWEEN 30 AND 44 THEN '30-44'
        WHEN age_years BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS patient_percentage
FROM patients_clean
GROUP BY
    CASE
        WHEN age_years < 18 THEN 'Under 18'
        WHEN age_years BETWEEN 18 AND 29 THEN '18-29'
        WHEN age_years BETWEEN 30 AND 44 THEN '30-44'
        WHEN age_years BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
    END
ORDER BY patient_count DESC;


-- ============================================================
-- End of Patient Analysis
-- ============================================================