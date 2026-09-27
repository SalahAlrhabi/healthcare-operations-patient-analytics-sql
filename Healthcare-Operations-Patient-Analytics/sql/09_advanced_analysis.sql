-- ============================================================
-- Advanced SQL Analysis
-- ============================================================
-- This section uses CTEs and window functions to explore
-- appointment trends, growth, rankings, and patient activity.
-- ============================================================


-- 1. Monthly Appointment Trend
-- Track appointment volume by month.

SELECT
    DATE_FORMAT(appointment_date, '%Y-%m') AS month,
    COUNT(*) AS appointment_count
FROM appointments_clean
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY month;



-- 2. Month-over-Month Appointment Growth
-- Measure how appointment volume changes from one month to the next.

WITH monthly_appointments AS (
    SELECT
        DATE_FORMAT(appointment_date, '%Y-%m') AS month,
        COUNT(*) AS appointment_count
    FROM appointments_clean
    GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
),

monthly_comparison AS (
    SELECT
        month,
        appointment_count,
        LAG(appointment_count) OVER (
            ORDER BY month
        ) AS previous_month_appointments
    FROM monthly_appointments
)

SELECT
    month,
    appointment_count,
    previous_month_appointments,
    ROUND(
        100.0 * (appointment_count - previous_month_appointments)
        / NULLIF(previous_month_appointments, 0),
        2
    ) AS mom_growth_rate
FROM monthly_comparison
ORDER BY month;



-- 3. Facility Ranking by Appointment Volume
-- Rank facilities based on the number of appointments handled.

WITH facility_appointments AS (
    SELECT
        f.facility_id,
        f.facility_name,
        COUNT(a.appointment_id) AS appointment_count
    FROM appointments_clean AS a
    INNER JOIN facilities_clean AS f
        ON a.facility_id = f.facility_id
    GROUP BY
        f.facility_id,
        f.facility_name
)

SELECT
    facility_name,
    appointment_count,
    RANK() OVER (
        ORDER BY appointment_count DESC
    ) AS facility_rank
FROM facility_appointments
ORDER BY facility_rank;



-- 4. Physician Ranking Within Specialty
-- Rank physicians against others in the same specialty.

WITH physician_appointments AS (
    SELECT
        p.physician_id,
        p.physician_name,
        p.specialty,
        COUNT(a.appointment_id) AS appointment_count
    FROM physicians_clean AS p
    INNER JOIN appointments_clean AS a
        ON p.physician_id = a.physician_id
    GROUP BY
        p.physician_id,
        p.physician_name,
        p.specialty
)

SELECT
    specialty,
    physician_name,
    appointment_count,
    RANK() OVER (
        PARTITION BY specialty
        ORDER BY appointment_count DESC
    ) AS specialty_rank
FROM physician_appointments
ORDER BY
    specialty,
    specialty_rank;



-- 5. Monthly Completed Appointment Trend
-- Track completed appointment volume over time.

SELECT
    DATE_FORMAT(appointment_date, '%Y-%m') AS month,
    COUNT(*) AS completed_appointments
FROM appointments_clean
WHERE appointment_status = 'Completed'
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY month;



-- 6. Running Total of Appointments
-- Calculate the cumulative number of appointments over time.

WITH monthly_appointments AS (
    SELECT
        DATE_FORMAT(appointment_date, '%Y-%m') AS month,
        COUNT(*) AS appointment_count
    FROM appointments_clean
    GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
)

SELECT
    month,
    appointment_count,
    SUM(appointment_count) OVER (
        ORDER BY month
    ) AS running_total
FROM monthly_appointments
ORDER BY month;



-- 7. Three-Month Rolling Average
-- Smooth monthly appointment volume using a three-month average.

WITH monthly_appointments AS (
    SELECT
        DATE_FORMAT(appointment_date, '%Y-%m') AS month,
        COUNT(*) AS appointment_count
    FROM appointments_clean
    GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
)

SELECT
    month,
    appointment_count,
    ROUND(
        AVG(appointment_count) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_rolling_avg
FROM monthly_appointments
ORDER BY month;



-- 8. No-show Rate by Facility
-- Compare no-show rates across facilities.

SELECT
    f.facility_name,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(
        CASE
            WHEN a.appointment_status = 'No-show' THEN 1
            ELSE 0
        END
    ) AS no_show_appointments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN a.appointment_status = 'No-show' THEN 1
                ELSE 0
            END
        ) / COUNT(a.appointment_id),
        2
    ) AS no_show_rate
FROM appointments_clean AS a
INNER JOIN facilities_clean AS f
    ON a.facility_id = f.facility_id
GROUP BY
    f.facility_id,
    f.facility_name
ORDER BY no_show_rate DESC;



-- 9. Monthly No-show Trend
-- Track changes in the no-show rate over time.

SELECT
    DATE_FORMAT(appointment_date, '%Y-%m') AS month,
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN appointment_status = 'No-show' THEN 1
            ELSE 0
        END
    ) AS no_show_appointments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN appointment_status = 'No-show' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY month;



-- 10. Patient Appointment Frequency
-- Group patients based on how often they use appointment services.

WITH patient_activity AS (
    SELECT
        patient_id,
        COUNT(appointment_id) AS appointment_count
    FROM appointments_clean
    GROUP BY patient_id
),

patient_frequency AS (
    SELECT
        patient_id,
        appointment_count,
        CASE
            WHEN appointment_count = 1 THEN '1 Appointment'
            WHEN appointment_count BETWEEN 2 AND 3 THEN '2-3 Appointments'
            WHEN appointment_count BETWEEN 4 AND 5 THEN '4-5 Appointments'
            ELSE '6+ Appointments'
        END AS frequency_group
    FROM patient_activity
)

SELECT
    frequency_group,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS patient_percentage
FROM patient_frequency
GROUP BY frequency_group
ORDER BY
    CASE frequency_group
        WHEN '1 Appointment' THEN 1
        WHEN '2-3 Appointments' THEN 2
        WHEN '4-5 Appointments' THEN 3
        WHEN '6+ Appointments' THEN 4
    END;


-- ============================================================
-- End of Advanced SQL Analysis
-- ============================================================