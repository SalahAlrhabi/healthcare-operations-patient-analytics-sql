/* ============================================================
   PROJECT: Healthcare Operations & Patient Analytics
   FILE: 02_data_audit.sql
   PURPOSE:
   - Validate data structure
   - Check missing values
   - Check duplicate IDs
   - Validate dates and numeric fields
   - Validate categorical values
   - Check referential integrity
   - Validate healthcare business rules
   ============================================================ */


/* ============================================================
   1. STRUCTURAL AUDIT
   ============================================================ */

DESCRIBE facilities;
DESCRIBE physicians;
DESCRIBE patients;
DESCRIBE appointments;
DESCRIBE admissions;


/* ============================================================
   2. ROW COUNT AUDIT
   ============================================================ */

SELECT 'facilities' AS table_name, COUNT(*) AS row_count
FROM facilities

UNION ALL

SELECT 'physicians', COUNT(*)
FROM physicians

UNION ALL

SELECT 'patients', COUNT(*)
FROM patients

UNION ALL

SELECT 'appointments', COUNT(*)
FROM appointments

UNION ALL

SELECT 'admissions', COUNT(*)
FROM admissions;


/* ============================================================
   3. MISSING VALUE AUDIT
   Checks both NULL and empty strings
   ============================================================ */


/* Facilities */

SELECT
    SUM(`ï»¿facility_id` IS NULL OR `ï»¿facility_id` = '') AS missing_facility_id,
    SUM(facility_name IS NULL OR facility_name = '') AS missing_facility_name,
    SUM(facility_type IS NULL OR facility_type = '') AS missing_facility_type,
    SUM(country IS NULL OR country = '') AS missing_country,
    SUM(city IS NULL OR city = '') AS missing_city,
    SUM(region IS NULL OR region = '') AS missing_region,
    SUM(beds_total IS NULL) AS missing_beds,
    SUM(opened_year IS NULL) AS missing_opened_year,
    SUM(accreditation IS NULL OR accreditation = '') AS missing_accreditation
FROM facilities;


/* Physicians */

SELECT
    SUM(`ï»¿physician_id` IS NULL OR `ï»¿physician_id` = '') AS missing_physician_id,
    SUM(physician_name IS NULL OR physician_name = '') AS missing_physician_name,
    SUM(gender IS NULL OR gender = '') AS missing_gender,
    SUM(specialty IS NULL OR specialty = '') AS missing_specialty,
    SUM(facility_id IS NULL OR facility_id = '') AS missing_facility_id,
    SUM(seniority IS NULL OR seniority = '') AS missing_seniority,
    SUM(years_experience IS NULL) AS missing_experience
FROM physicians;


/* Patients */

SELECT
    SUM(`ï»¿patient_id` IS NULL OR `ï»¿patient_id` = '') AS missing_patient_id,
    SUM(patient_name IS NULL OR patient_name = '') AS missing_patient_name,
    SUM(gender IS NULL OR gender = '') AS missing_gender,
    SUM(date_of_birth IS NULL OR date_of_birth = '') AS missing_dob,
    SUM(country IS NULL OR country = '') AS missing_country,
    SUM(city IS NULL OR city = '') AS missing_city,
    SUM(blood_group IS NULL OR blood_group = '') AS missing_blood_group,
    SUM(insurance_provider IS NULL OR insurance_provider = '') AS missing_insurance_provider,
    SUM(insurance_type IS NULL OR insurance_type = '') AS missing_insurance_type,
    SUM(registered_facility_id IS NULL OR registered_facility_id = '') AS missing_facility_id,
    SUM(registered_date IS NULL OR registered_date = '') AS missing_registered_date,
    SUM(age_years IS NULL) AS missing_age
FROM patients;


/* Appointments */

SELECT
    SUM(appointment_id IS NULL OR appointment_id = '') AS missing_appointment_id,
    SUM(patient_id IS NULL OR patient_id = '') AS missing_patient_id,
    SUM(physician_id IS NULL OR physician_id = '') AS missing_physician_id,
    SUM(facility_id IS NULL OR facility_id = '') AS missing_facility_id,
    SUM(appointment_date IS NULL OR appointment_date = '') AS missing_date,
    SUM(appointment_month IS NULL OR appointment_month = '') AS missing_month,
    SUM(appointment_type IS NULL OR appointment_type = '') AS missing_type,
    SUM(booking_channel IS NULL OR booking_channel = '') AS missing_channel,
    SUM(appointment_status IS NULL OR appointment_status = '') AS missing_status,
    SUM(wait_time_minutes IS NULL OR wait_time_minutes = '') AS missing_wait,
    SUM(consultation_minutes IS NULL OR consultation_minutes = '') AS missing_consultation,
    SUM(satisfaction_score IS NULL OR satisfaction_score = '') AS missing_satisfaction,
    SUM(billed_amount_usd IS NULL OR billed_amount_usd = '') AS missing_billed,
    SUM(insurance_covered_usd IS NULL OR insurance_covered_usd = '') AS missing_insurance,
    SUM(patient_paid_usd IS NULL OR patient_paid_usd = '') AS missing_patient_paid,
    SUM(currency IS NULL OR currency = '') AS missing_currency
FROM appointments;


/* Admissions */

SELECT
    SUM(`ï»¿admission_id` IS NULL OR `ï»¿admission_id` = '') AS missing_admission_id,
    SUM(patient_id IS NULL OR patient_id = '') AS missing_patient_id,
    SUM(facility_id IS NULL OR facility_id = '') AS missing_facility_id,
    SUM(attending_physician_id IS NULL OR attending_physician_id = '') AS missing_physician_id,
    SUM(admission_date IS NULL OR admission_date = '') AS missing_admission_date,
    SUM(discharge_date IS NULL OR discharge_date = '') AS missing_discharge_date,
    SUM(admission_month IS NULL OR admission_month = '') AS missing_month,
    SUM(admission_type IS NULL OR admission_type = '') AS missing_admission_type,
    SUM(ward_type IS NULL OR ward_type = '') AS missing_ward,
    SUM(length_of_stay_days IS NULL) AS missing_los,
    SUM(icu_days IS NULL) AS missing_icu_days,
    SUM(discharge_disposition IS NULL OR discharge_disposition = '') AS missing_disposition,
    SUM(readmitted_within_30_days IS NULL OR readmitted_within_30_days = '') AS missing_readmission,
    SUM(total_charges_usd IS NULL) AS missing_total_charges,
    SUM(insurance_covered_usd IS NULL) AS missing_insurance,
    SUM(patient_paid_usd IS NULL) AS missing_patient_paid,
    SUM(currency IS NULL OR currency = '') AS missing_currency
FROM admissions;


/* ============================================================
   4. DUPLICATE / UNIQUENESS AUDIT
   ============================================================ */


/* Facilities */

SELECT
    `ï»¿facility_id` AS facility_id,
    COUNT(*) AS record_count
FROM facilities
GROUP BY `ï»¿facility_id`
HAVING COUNT(*) > 1;


/* Physicians */

SELECT
    `ï»¿physician_id` AS physician_id,
    COUNT(*) AS record_count
FROM physicians
GROUP BY `ï»¿physician_id`
HAVING COUNT(*) > 1;


/* Patients */

SELECT
    `ï»¿patient_id` AS patient_id,
    COUNT(*) AS record_count
FROM patients
GROUP BY `ï»¿patient_id`
HAVING COUNT(*) > 1;


/* Appointments */

SELECT
    appointment_id,
    COUNT(*) AS record_count
FROM appointments
GROUP BY appointment_id
HAVING COUNT(*) > 1;


/* Admissions */

SELECT
    `ï»¿admission_id` AS admission_id,
    COUNT(*) AS record_count
FROM admissions
GROUP BY `ï»¿admission_id`
HAVING COUNT(*) > 1;


/* ============================================================
   5. APPOINTMENT DATE VALIDATION
   ============================================================ */

SELECT
    MIN(appointment_date) AS min_date,
    MAX(appointment_date) AS max_date,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN STR_TO_DATE(appointment_date, '%Y-%m-%d') IS NULL
            THEN 1
            ELSE 0
        END
    ) AS invalid_dates
FROM appointments;


/* Appointment Month Validation */

SELECT
    COUNT(*) AS mismatched_months
FROM appointments
WHERE appointment_month <>
      DATE_FORMAT(
          STR_TO_DATE(appointment_date, '%Y-%m-%d'),
          '%Y-%m'
      );


/* ============================================================
   6. APPOINTMENT NUMERIC VALIDATION
   ============================================================ */

SELECT
    SUM(
        CASE
            WHEN wait_time_minutes = ''
              OR wait_time_minutes IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_wait,

    SUM(
        CASE
            WHEN wait_time_minutes REGEXP '[^0-9.]'
            THEN 1 ELSE 0
        END
    ) AS invalid_wait,

    SUM(
        CASE
            WHEN consultation_minutes = ''
              OR consultation_minutes IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_consultation,

    SUM(
        CASE
            WHEN consultation_minutes REGEXP '[^0-9.]'
            THEN 1 ELSE 0
        END
    ) AS invalid_consultation,

    SUM(
        CASE
            WHEN satisfaction_score <> ''
             AND satisfaction_score REGEXP '[^0-9.]'
            THEN 1 ELSE 0
        END
    ) AS invalid_satisfaction,

    SUM(
        CASE
            WHEN billed_amount_usd REGEXP '[^0-9.]'
            THEN 1 ELSE 0
        END
    ) AS invalid_billed,

    SUM(
        CASE
            WHEN insurance_covered_usd REGEXP '[^0-9.]'
            THEN 1 ELSE 0
        END
    ) AS invalid_insurance,

    SUM(
        CASE
            WHEN patient_paid_usd REGEXP '[^0-9.]'
            THEN 1 ELSE 0
        END
    ) AS invalid_patient_paid

FROM appointments;


/* Negative Values */

SELECT
    SUM(
        CASE WHEN CAST(wait_time_minutes AS DECIMAL(10,2)) < 0
        THEN 1 ELSE 0 END
    ) AS negative_wait,

    SUM(
        CASE WHEN CAST(consultation_minutes AS DECIMAL(10,2)) < 0
        THEN 1 ELSE 0 END
    ) AS negative_consultation,

    SUM(
        CASE WHEN CAST(billed_amount_usd AS DECIMAL(15,2)) < 0
        THEN 1 ELSE 0 END
    ) AS negative_billed,

    SUM(
        CASE WHEN CAST(insurance_covered_usd AS DECIMAL(15,2)) < 0
        THEN 1 ELSE 0 END
    ) AS negative_insurance,

    SUM(
        CASE WHEN CAST(patient_paid_usd AS DECIMAL(15,2)) < 0
        THEN 1 ELSE 0 END
    ) AS negative_patient_paid

FROM appointments;


/* ============================================================
   7. APPOINTMENT CATEGORY VALIDATION
   ============================================================ */

SELECT DISTINCT appointment_type
FROM appointments
ORDER BY appointment_type;

SELECT DISTINCT booking_channel
FROM appointments
ORDER BY booking_channel;

SELECT DISTINCT appointment_status
FROM appointments
ORDER BY appointment_status;

SELECT DISTINCT currency
FROM appointments
ORDER BY currency;


/* Satisfaction Score Distribution */

SELECT
    satisfaction_score,
    COUNT(*) AS record_count
FROM appointments
WHERE satisfaction_score IS NOT NULL
  AND satisfaction_score <> ''
GROUP BY satisfaction_score
ORDER BY satisfaction_score;


/* Satisfaction Missingness by Status */

SELECT
    appointment_status,
    COUNT(*) AS total_appointments,

    SUM(
        CASE
            WHEN satisfaction_score IS NULL
              OR satisfaction_score = ''
            THEN 1 ELSE 0
        END
    ) AS missing_satisfaction,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN satisfaction_score IS NULL
                  OR satisfaction_score = ''
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS missing_rate

FROM appointments

GROUP BY appointment_status
ORDER BY total_appointments DESC;


/* ============================================================
   8. REFERENTIAL INTEGRITY AUDIT
   ============================================================ */


/* Appointments → Patients */

SELECT COUNT(*) AS orphan_appointments_patients
FROM appointments a
LEFT JOIN patients p
    ON a.patient_id = p.`ï»¿patient_id`
WHERE p.`ï»¿patient_id` IS NULL;


/* Appointments → Physicians */

SELECT COUNT(*) AS orphan_appointments_physicians
FROM appointments a
LEFT JOIN physicians p
    ON a.physician_id = p.`ï»¿physician_id`
WHERE p.`ï»¿physician_id` IS NULL;


/* Appointments → Facilities */

SELECT COUNT(*) AS orphan_appointments_facilities
FROM appointments a
LEFT JOIN facilities f
    ON a.facility_id = f.`ï»¿facility_id`
WHERE f.`ï»¿facility_id` IS NULL;


/* Admissions → Patients */

SELECT COUNT(*) AS orphan_admissions_patients
FROM admissions a
LEFT JOIN patients p
    ON a.patient_id = p.`ï»¿patient_id`
WHERE p.`ï»¿patient_id` IS NULL;


/* Admissions → Physicians */

SELECT COUNT(*) AS orphan_admissions_physicians
FROM admissions a
LEFT JOIN physicians p
    ON a.attending_physician_id = p.`ï»¿physician_id`
WHERE p.`ï»¿physician_id` IS NULL;


/* Admissions → Facilities */

SELECT COUNT(*) AS orphan_admissions_facilities
FROM admissions a
LEFT JOIN facilities f
    ON a.facility_id = f.`ï»¿facility_id`
WHERE f.`ï»¿facility_id` IS NULL;


/* ============================================================
   9. ADMISSIONS DATE VALIDATION
   ============================================================ */

SELECT
    MIN(admission_date) AS min_admission_date,
    MAX(admission_date) AS max_admission_date,
    MIN(discharge_date) AS min_discharge_date,
    MAX(discharge_date) AS max_discharge_date,

    SUM(
        CASE
            WHEN STR_TO_DATE(admission_date, '%Y-%m-%d') IS NULL
            THEN 1 ELSE 0
        END
    ) AS invalid_admission_dates,

    SUM(
        CASE
            WHEN STR_TO_DATE(discharge_date, '%Y-%m-%d') IS NULL
            THEN 1 ELSE 0
        END
    ) AS invalid_discharge_dates

FROM admissions;


/* Admission Month Validation */

SELECT
    COUNT(*) AS mismatched_admission_months
FROM admissions
WHERE admission_month <>
      DATE_FORMAT(
          STR_TO_DATE(admission_date, '%Y-%m-%d'),
          '%Y-%m'
      );


/* ============================================================
   10. LENGTH OF STAY & ICU VALIDATION
   ============================================================ */

SELECT
    COUNT(*) AS mismatched_los
FROM admissions
WHERE length_of_stay_days <>
      DATEDIFF(
          STR_TO_DATE(discharge_date, '%Y-%m-%d'),
          STR_TO_DATE(admission_date, '%Y-%m-%d')
      );


SELECT
    COUNT(*) AS invalid_icu_days
FROM admissions
WHERE icu_days < 0
   OR icu_days > length_of_stay_days;


/* ============================================================
   11. ADMISSIONS FINANCIAL VALIDATION
   ============================================================ */


/* Negative Financial Values */

SELECT
    SUM(CASE WHEN room_charges_usd < 0 THEN 1 ELSE 0 END)
        AS negative_room,

    SUM(CASE WHEN procedure_charges_usd < 0 THEN 1 ELSE 0 END)
        AS negative_procedure,

    SUM(CASE WHEN pharmacy_charges_usd < 0 THEN 1 ELSE 0 END)
        AS negative_pharmacy,

    SUM(CASE WHEN total_charges_usd < 0 THEN 1 ELSE 0 END)
        AS negative_total,

    SUM(CASE WHEN insurance_covered_usd < 0 THEN 1 ELSE 0 END)
        AS negative_insurance,

    SUM(CASE WHEN patient_paid_usd < 0 THEN 1 ELSE 0 END)
        AS negative_patient_paid

FROM admissions;


/* Insurance + Patient Paid = Total Charges */

SELECT
    COUNT(*) AS financial_mismatches
FROM admissions
WHERE ABS(
    insurance_covered_usd
    + patient_paid_usd
    - total_charges_usd
) > 0.01;


/* Room + Procedure + Pharmacy = Total Charges */

SELECT
    COUNT(*) AS charge_mismatches
FROM admissions
WHERE ABS(
    room_charges_usd
    + procedure_charges_usd
    + pharmacy_charges_usd
    - total_charges_usd
) > 0.01;


/* ============================================================
   12. APPOINTMENT FINANCIAL VALIDATION
   ============================================================ */

SELECT
    COUNT(*) AS financial_mismatches
FROM appointments
WHERE ABS(
    CAST(insurance_covered_usd AS DECIMAL(15,2))
    +
    CAST(patient_paid_usd AS DECIMAL(15,2))
    -
    CAST(billed_amount_usd AS DECIMAL(15,2))
) > 0.01;


/* ============================================================
   13. ADMISSIONS CATEGORIES
   ============================================================ */

SELECT DISTINCT admission_type
FROM admissions
ORDER BY admission_type;

SELECT DISTINCT ward_type
FROM admissions
ORDER BY ward_type;

SELECT DISTINCT discharge_disposition
FROM admissions
ORDER BY discharge_disposition;

SELECT DISTINCT readmitted_within_30_days
FROM admissions
ORDER BY readmitted_within_30_days;

SELECT DISTINCT currency
FROM admissions
ORDER BY currency;


/* ============================================================
   14. PATIENT VALIDATION
   ============================================================ */

SELECT
    MIN(date_of_birth) AS earliest_dob,
    MAX(date_of_birth) AS latest_dob,

    SUM(
        CASE
            WHEN STR_TO_DATE(date_of_birth, '%Y-%m-%d') IS NULL
            THEN 1 ELSE 0
        END
    ) AS invalid_dob

FROM patients;


SELECT
    MIN(age_years) AS min_age,
    MAX(age_years) AS max_age,

    SUM(
        CASE
            WHEN age_years < 0
            THEN 1 ELSE 0
        END
    ) AS negative_age

FROM patients;


/* Patient Categories */

SELECT DISTINCT gender
FROM patients
ORDER BY gender;

SELECT DISTINCT blood_group
FROM patients
ORDER BY blood_group;

SELECT DISTINCT insurance_provider
FROM patients
ORDER BY insurance_provider;

SELECT DISTINCT insurance_type
FROM patients
ORDER BY insurance_type;

SELECT DISTINCT has_chronic_condition
FROM patients
ORDER BY has_chronic_condition;


/* ============================================================
   15. PHYSICIAN VALIDATION
   ============================================================ */

SELECT DISTINCT gender
FROM physicians
ORDER BY gender;

SELECT DISTINCT specialty
FROM physicians
ORDER BY specialty;

SELECT DISTINCT seniority
FROM physicians
ORDER BY seniority;

SELECT DISTINCT board_certified
FROM physicians
ORDER BY board_certified;

SELECT DISTINCT is_accepting_new_patients
FROM physicians
ORDER BY is_accepting_new_patients;


SELECT
    MIN(years_experience) AS min_experience,
    MAX(years_experience) AS max_experience,

    SUM(
        CASE
            WHEN years_experience < 0
            THEN 1 ELSE 0
        END
    ) AS negative_experience

FROM physicians;


/* ============================================================
   16. FACILITY VALIDATION
   ============================================================ */

SELECT DISTINCT facility_type
FROM facilities
ORDER BY facility_type;

SELECT DISTINCT country
FROM facilities
ORDER BY country;

SELECT DISTINCT region
FROM facilities
ORDER BY region;

SELECT DISTINCT accreditation
FROM facilities
ORDER BY accreditation;

SELECT DISTINCT operates_emergency_dept
FROM facilities
ORDER BY operates_emergency_dept;

SELECT DISTINCT provides_inpatient_care
FROM facilities
ORDER BY provides_inpatient_care;


SELECT
    MIN(beds_total) AS min_beds,
    MAX(beds_total) AS max_beds,
    MIN(opened_year) AS earliest_opened,
    MAX(opened_year) AS latest_opened,

    SUM(
        CASE
            WHEN beds_total <= 0
            THEN 1 ELSE 0
        END
    ) AS invalid_beds

FROM facilities;


/* ============================================================
   END OF DATA AUDIT
   ============================================================ */