/* ============================================================
   PROJECT: Healthcare Operations & Patient Analytics
   FILE: 03_data_cleaning.sql

   PURPOSE:
   - Clean raw healthcare data
   - Standardize column names
   - Convert data types
   - Preserve raw tables
   - Create analysis-ready tables
   ============================================================ */


/* ============================================================
   1. STANDARDIZE COLUMN NAMES
   ============================================================ */

/* Facilities */

ALTER TABLE facilities
CHANGE `ï»¿facility_id` facility_id TEXT;


/* Physicians */

ALTER TABLE physicians
CHANGE `ï»¿physician_id` physician_id TEXT;


/* Patients */

ALTER TABLE patients
CHANGE `ï»¿patient_id` patient_id TEXT;


/* Admissions */

ALTER TABLE admissions
CHANGE `ï»¿admission_id` admission_id TEXT;


/* ============================================================
   2. CREATE CLEAN FACILITIES TABLE
   ============================================================ */

DROP TABLE IF EXISTS facilities_clean;

CREATE TABLE facilities_clean AS
SELECT
    TRIM(facility_id) AS facility_id,
    TRIM(facility_name) AS facility_name,
    TRIM(facility_type) AS facility_type,
    TRIM(country) AS country,
    TRIM(city) AS city,
    TRIM(region) AS region,
    beds_total,
    opened_year,
    TRIM(accreditation) AS accreditation,
    TRIM(operates_emergency_dept) AS operates_emergency_dept,
    TRIM(provides_inpatient_care) AS provides_inpatient_care
FROM facilities;


/* ============================================================
   3. CREATE CLEAN PHYSICIANS TABLE
   ============================================================ */

DROP TABLE IF EXISTS physicians_clean;

CREATE TABLE physicians_clean AS
SELECT
    TRIM(physician_id) AS physician_id,
    TRIM(physician_name) AS physician_name,
    TRIM(gender) AS gender,
    TRIM(specialty) AS specialty,
    TRIM(facility_id) AS facility_id,
    TRIM(seniority) AS seniority,
    years_experience,
    TRIM(board_certified) AS board_certified,
    TRIM(is_accepting_new_patients) AS is_accepting_new_patients
FROM physicians;


/* ============================================================
   4. CREATE CLEAN PATIENTS TABLE
   ============================================================ */

DROP TABLE IF EXISTS patients_clean;

CREATE TABLE patients_clean AS
SELECT
    TRIM(patient_id) AS patient_id,
    TRIM(patient_name) AS patient_name,
    TRIM(gender) AS gender,

    STR_TO_DATE(
        TRIM(date_of_birth),
        '%Y-%m-%d'
    ) AS date_of_birth,

    TRIM(country) AS country,
    TRIM(city) AS city,
    TRIM(blood_group) AS blood_group,
    TRIM(insurance_provider) AS insurance_provider,
    TRIM(insurance_type) AS insurance_type,
    TRIM(has_chronic_condition) AS has_chronic_condition,
    TRIM(registered_facility_id) AS registered_facility_id,

    STR_TO_DATE(
        TRIM(registered_date),
        '%Y-%m-%d'
    ) AS registered_date,

    age_years

FROM patients;


/* ============================================================
   5. CREATE CLEAN APPOINTMENTS TABLE
   ============================================================ */

DROP TABLE IF EXISTS appointments_clean;

CREATE TABLE appointments_clean AS
SELECT
    TRIM(appointment_id) AS appointment_id,
    TRIM(patient_id) AS patient_id,
    TRIM(physician_id) AS physician_id,
    TRIM(facility_id) AS facility_id,

    STR_TO_DATE(
        TRIM(appointment_date),
        '%Y-%m-%d'
    ) AS appointment_date,

    TRIM(appointment_month) AS appointment_month,
    TRIM(appointment_type) AS appointment_type,
    TRIM(booking_channel) AS booking_channel,
    TRIM(appointment_status) AS appointment_status,

    CAST(
        NULLIF(TRIM(wait_time_minutes), '')
        AS DECIMAL(10,2)
    ) AS wait_time_minutes,

    CAST(
        NULLIF(TRIM(consultation_minutes), '')
        AS DECIMAL(10,2)
    ) AS consultation_minutes,

    CAST(
        NULLIF(TRIM(satisfaction_score), '')
        AS DECIMAL(5,2)
    ) AS satisfaction_score,

    CAST(
        NULLIF(TRIM(billed_amount_usd), '')
        AS DECIMAL(15,2)
    ) AS billed_amount_usd,

    CAST(
        NULLIF(TRIM(insurance_covered_usd), '')
        AS DECIMAL(15,2)
    ) AS insurance_covered_usd,

    CAST(
        NULLIF(TRIM(patient_paid_usd), '')
        AS DECIMAL(15,2)
    ) AS patient_paid_usd,

    UPPER(TRIM(currency)) AS currency

FROM appointments;


/* ============================================================
   6. CREATE CLEAN ADMISSIONS TABLE
   ============================================================ */

DROP TABLE IF EXISTS admissions_clean;

CREATE TABLE admissions_clean AS
SELECT
    TRIM(admission_id) AS admission_id,
    TRIM(patient_id) AS patient_id,
    TRIM(facility_id) AS facility_id,
    TRIM(attending_physician_id) AS attending_physician_id,

    STR_TO_DATE(
        TRIM(admission_date),
        '%Y-%m-%d'
    ) AS admission_date,

    STR_TO_DATE(
        TRIM(discharge_date),
        '%Y-%m-%d'
    ) AS discharge_date,

    TRIM(admission_month) AS admission_month,
    TRIM(admission_type) AS admission_type,
    TRIM(ward_type) AS ward_type,

    length_of_stay_days,
    icu_days,

    TRIM(discharge_disposition) AS discharge_disposition,
    TRIM(readmitted_within_30_days) AS readmitted_within_30_days,

    room_charges_usd,
    procedure_charges_usd,
    pharmacy_charges_usd,
    total_charges_usd,
    insurance_covered_usd,
    patient_paid_usd,

    UPPER(TRIM(currency)) AS currency

FROM admissions;


/* ============================================================
   7. STANDARDIZE MONTH COLUMNS
   ============================================================ */

/* Rebuild appointment_month from appointment_date */

UPDATE appointments_clean
SET appointment_month =
    DATE_FORMAT(appointment_date, '%Y-%m');


/* Rebuild admission_month from admission_date */

UPDATE admissions_clean
SET admission_month =
    DATE_FORMAT(admission_date, '%Y-%m');


/* ============================================================
   8. VALIDATE ROW COUNTS
   ============================================================ */

SELECT
    'facilities' AS table_name,
    COUNT(*) AS row_count
FROM facilities_clean

UNION ALL

SELECT
    'physicians',
    COUNT(*)
FROM physicians_clean

UNION ALL

SELECT
    'patients',
    COUNT(*)
FROM patients_clean

UNION ALL

SELECT
    'appointments',
    COUNT(*)
FROM appointments_clean

UNION ALL

SELECT
    'admissions',
    COUNT(*)
FROM admissions_clean;


/* ============================================================
   9. VALIDATE DUPLICATE IDS
   ============================================================ */

SELECT
    facility_id,
    COUNT(*) AS record_count
FROM facilities_clean
GROUP BY facility_id
HAVING COUNT(*) > 1;


SELECT
    physician_id,
    COUNT(*) AS record_count
FROM physicians_clean
GROUP BY physician_id
HAVING COUNT(*) > 1;


SELECT
    patient_id,
    COUNT(*) AS record_count
FROM patients_clean
GROUP BY patient_id
HAVING COUNT(*) > 1;


SELECT
    appointment_id,
    COUNT(*) AS record_count
FROM appointments_clean
GROUP BY appointment_id
HAVING COUNT(*) > 1;


SELECT
    admission_id,
    COUNT(*) AS record_count
FROM admissions_clean
GROUP BY admission_id
HAVING COUNT(*) > 1;


/* ============================================================
   10. VALIDATE REFERENTIAL INTEGRITY
   ============================================================ */


/* Appointments → Patients */

SELECT COUNT(*) AS orphan_records
FROM appointments_clean a
LEFT JOIN patients_clean p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


/* Appointments → Physicians */

SELECT COUNT(*) AS orphan_records
FROM appointments_clean a
LEFT JOIN physicians_clean p
    ON a.physician_id = p.physician_id
WHERE p.physician_id IS NULL;


/* Appointments → Facilities */

SELECT COUNT(*) AS orphan_records
FROM appointments_clean a
LEFT JOIN facilities_clean f
    ON a.facility_id = f.facility_id
WHERE f.facility_id IS NULL;


/* Admissions → Patients */

SELECT COUNT(*) AS orphan_records
FROM admissions_clean a
LEFT JOIN patients_clean p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


/* Admissions → Physicians */

SELECT COUNT(*) AS orphan_records
FROM admissions_clean a
LEFT JOIN physicians_clean p
    ON a.attending_physician_id = p.physician_id
WHERE p.physician_id IS NULL;


/* Admissions → Facilities */

SELECT COUNT(*) AS orphan_records
FROM admissions_clean a
LEFT JOIN facilities_clean f
    ON a.facility_id = f.facility_id
WHERE f.facility_id IS NULL;


/* ============================================================
   11. FINAL DATA QUALITY CHECK
   ============================================================ */


/* Appointments */

SELECT
    COUNT(*) AS total_records,

    SUM(appointment_date IS NULL) AS null_dates,

    SUM(wait_time_minutes IS NULL) AS null_wait_time,

    SUM(consultation_minutes IS NULL) AS null_consultation,

    SUM(satisfaction_score IS NULL) AS null_satisfaction,

    SUM(billed_amount_usd IS NULL) AS null_billed_amount

FROM appointments_clean;


/* Admissions */

SELECT
    COUNT(*) AS total_records,

    SUM(admission_date IS NULL) AS null_admission_date,

    SUM(discharge_date IS NULL) AS null_discharge_date,

    SUM(length_of_stay_days IS NULL) AS null_los,

    SUM(total_charges_usd IS NULL) AS null_total_charges

FROM admissions_clean;


/* ============================================================
   12. FINAL DATASET OVERVIEW
   ============================================================ */

SELECT
    'facilities_clean' AS table_name,
    COUNT(*) AS records
FROM facilities_clean

UNION ALL

SELECT
    'physicians_clean',
    COUNT(*)
FROM physicians_clean

UNION ALL

SELECT
    'patients_clean',
    COUNT(*)
FROM patients_clean

UNION ALL

SELECT
    'appointments_clean',
    COUNT(*)
FROM appointments_clean

UNION ALL

SELECT
    'admissions_clean',
    COUNT(*)
FROM admissions_clean;


/* ============================================================
   END OF DATA CLEANING
   ============================================================ */