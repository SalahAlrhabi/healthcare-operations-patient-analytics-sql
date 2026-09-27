-- ============================================================
-- Hospital Operations Analysis
-- ============================================================
-- This section looks at hospital admissions, length of stay,
-- ICU utilization, and 30-day readmissions across the network.
-- ============================================================


-- 1. Total Admissions
-- Check the total number of hospital admissions.

SELECT 
	COUNT(*) AS total_admissions
FROM admissions_clean;



-- 2. Admissions by Facility
-- Compare admission volume across hospital facilities.

SELECT 
    f.facility_name, COUNT(a.admission_id) AS admissions
FROM
    admissions_clean AS a
        INNER JOIN
    facilities_clean AS f ON a.facility_id = f.facility_id
GROUP BY f.facility_id , f.facility_name
ORDER BY admissions;



-- 3. Average Length of Stay
-- Calculate the average number of days patients stay in the hospital.

SELECT 
    ROUND(AVG(length_of_stay_days), 2) AS avg_length_of_stay
FROM
    admissions_clean;



-- 4. Admissions and Length of Stay by Specialty
-- Compare admission volume and average length of stay across specialties.

SELECT 
    p.specialty,
    COUNT(a.admission_id) AS admissions,
    ROUND(AVG(length_of_stay_days), 2) AS avg_length_of_stay
FROM
    admissions_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.attending_physician_id = p.physician_id
GROUP BY P.specialty
ORDER BY admissions DESC;



-- 5. ICU Utilization
-- Measure average ICU stay, total ICU days, and ICU share of hospital stay.

SELECT 
    ROUND(AVG(icu_days), 2) AS avg_icu_days,
    SUM(icu_days) AS total_icu_days,
    ROUND(100.0 * SUM(icu_days) / SUM(length_of_stay_days),
            2) AS icu_utilization_pct
FROM
    admissions_clean;



-- 6. Total Length of Stay
-- Calculate the total number of inpatient days across all admissions.

SELECT 
    SUM(length_of_stay_days)
FROM
    admissions_clean;



-- 7. 30-Day Readmission Distribution
-- Show the number and percentage of admissions by readmission status.

SELECT 
    readmitted_within_30_days,
    COUNT(*) AS admissions,
    ROUND(
		100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
	) AS percentage
FROM
    admissions_clean 
    group by readmitted_within_30_days
    ORDER by admissions DESC;



-- 8. Readmission Rate by Facility
-- Compare 30-day readmission rates across hospital facilities.

SELECT 
    f.facility_name,
    COUNT(*) AS total_admissions,
    SUM(CASE
        WHEN a.readmitted_within_30_days = 'Yes' THEN 1
        ELSE 0
    END) AS readmissions,
    ROUND(100.0 * SUM(CASE
                WHEN a.readmitted_within_30_days = 'Yes' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS readmission_rate
FROM
    admissions_clean AS a
        INNER JOIN
    facilities_clean AS f ON a.facility_id = f.facility_id
GROUP BY f.facility_id , f.facility_name
ORDER BY total_admissions DESC;


-- ============================================================
-- End of Hospital Operations Analysis
-- ============================================================