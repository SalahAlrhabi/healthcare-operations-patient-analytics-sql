-- ============================================================
-- Appointment Analysis
-- ============================================================
-- This section looks at appointment volume, status, waiting time,
-- facility activity, specialties, and patient satisfaction.
-- ============================================================


SELECT 
    COUNT(*) AS total_appointments
FROM
    appointments_clean;



-- 2. Appointment Status Distribution
-- Show how appointments are distributed across each status.

SELECT
    appointment_status,
    COUNT(*) AS appointment_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS appointment_percentage
FROM appointments_clean
GROUP BY appointment_status
ORDER BY appointment_count DESC;



-- 3. Completion Rate
-- Calculate the percentage of appointments that were completed.

SELECT 
    ROUND(100.0 * SUM(CASE
                WHEN appointment_status = 'Completed' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS completion_rate
FROM
    appointments_clean;



-- 4. Cancellation, No-show, and Rescheduled Rates
-- Measure the share of appointments that were not completed as planned.

SELECT 
    ROUND(100.0 * SUM(CASE
                WHEN appointment_status = 'Cancelled' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS cancellation_rate,
    ROUND(100.0 * SUM(CASE
                WHEN appointment_status = 'No-show' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS no_show_rate,
    ROUND(100.0 * SUM(CASE
                WHEN appointment_status = 'Rescheduled' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS rescheduled_rate
FROM
    appointments_clean;



-- 5. Appointments by Facility
-- Compare appointment volume across facilities and regions.

SELECT 
    f.facility_name,
    f.region,
    COUNT(a.appointment_id) AS appointment_count
FROM
    appointments_clean AS a
        INNER JOIN
    facilities_clean AS f ON a.facility_id = f.facility_id
GROUP BY f.facility_id , f.facility_name , f.region
ORDER BY appointment_count DESC;



-- 6. Appointments by Specialty
-- Compare appointment volume across medical specialties.

SELECT 
    p.specialty, COUNT(a.appointment_id) AS appointment_count
FROM
    appointments_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.physician_id = p.physician_id
GROUP BY p.specialty
ORDER BY appointment_count DESC;



-- 7. Average Waiting Time
-- Calculate the average waiting time for completed appointments.

SELECT 
    ROUND(AVG(wait_time_minutes), 2) AS avg_wait_minutes
FROM
    appointments_clean
WHERE
    appointment_status = 'Completed';



-- 8. Waiting Time by Facility
-- Compare average waiting time for completed appointments by facility.

SELECT 
    f.facility_name,
    COUNT(a.appointment_id) AS completed_appointments,
    ROUND(AVG(a.wait_time_minutes), 2) AS avg_wait_minutes
FROM
    appointments_clean AS a
        INNER JOIN
    facilities_clean AS f ON a.facility_id = f.facility_id
WHERE
    a.appointment_status = 'Completed'
GROUP BY f.facility_id , f.facility_name
ORDER BY avg_wait_minutes DESC;



-- 9. Waiting Time by Specialty
-- Compare average waiting time for completed appointments by specialty.

SELECT 
    p.specialty,
    COUNT(a.appointment_id) AS completed_appointments,
    ROUND(AVG(a.wait_time_minutes), 2) AS avg_wait_minutes
FROM
    appointments_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.physician_id = p.physician_id
WHERE
    a.appointment_status = 'Completed'
GROUP BY p.specialty
ORDER BY avg_wait_minutes DESC;



-- 10. Satisfaction by Appointment Type
-- Compare patient satisfaction across different appointment types.

SELECT 
    appointment_type,
    COUNT(satisfaction_score) AS rated_appointments,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM
    appointments_clean
WHERE
    satisfaction_score IS NOT NULL
GROUP BY appointment_type
ORDER BY avg_satisfaction DESC;


-- ============================================================
-- End of Appointment Analysis
-- ============================================================