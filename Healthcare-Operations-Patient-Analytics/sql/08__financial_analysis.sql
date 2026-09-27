-- ============================================================
-- Financial Analysis
-- ============================================================
-- This section looks at billing, insurance coverage, patient
-- payments, and hospital charges across the network.
-- ============================================================


-- 1. Appointment Billing Overview
-- Review total billed amounts, insurance coverage, and patient payments.

SELECT 
    ROUND(SUM(billed_amount_usd), 2) AS total_billed,
    ROUND(SUM(insurance_covered_usd), 2) AS insurance_covered,
    ROUND(SUM(patient_paid_usd), 2) AS patient_paid
FROM
    appointments_clean;



-- 2. Appointment Billing by Facility
-- Compare total appointment billing and patient payments across facilities.

SELECT 
    f.facility_name,
    ROUND(SUM(a.billed_amount_usd), 2) AS total_billed,
    ROUND(SUM(a.patient_paid_usd), 2) AS patient_paid
FROM
    appointments_clean AS a
        INNER JOIN
    facilities_clean AS f ON a.facility_id = f.facility_id
GROUP BY f.facility_id , f.facility_name
ORDER BY total_billed DESC;



-- 3. Appointment Billing by Specialty
-- Compare appointment volume and billing across medical specialties.

SELECT 
    p.specialty,
    COUNT(a.appointment_id) AS appointments,
    ROUND(SUM(a.billed_amount_usd), 2) AS total_billed,
    ROUND(AVG(a.billed_amount_usd), 2) AS avg_billed
FROM
    appointments_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.physician_id = p.physician_id
GROUP BY p.specialty
ORDER BY appointments DESC;



-- 4. Admission Charges Overview
-- Review total admission charges, insurance coverage, and patient payments.

SELECT 
    ROUND(SUM(total_charges_usd), 2) AS total_charges,
    ROUND(SUM(insurance_covered_usd), 2) AS insurance_covered,
    ROUND(SUM(patient_paid_usd), 2) AS patient_paid
FROM
    admissions_clean;



-- 5. Admission Charges by Facility
-- Compare total and average admission charges across facilities.

SELECT 
    f.facility_name,
    ROUND(SUM(total_charges_usd), 2) AS total_charges,
    ROUND(AVG(total_charges_usd), 2) AS avg_charges
FROM
    admissions_clean AS a
        INNER JOIN
    facilities_clean AS f ON a.facility_id = f.facility_id
GROUP BY f.facility_id , f.facility_name
ORDER BY total_charges DESC;


-- ============================================================
-- End of Financial Analysis
-- ============================================================