-- ============================================================
-- Physician Analysis
-- ============================================================
-- This section looks at physician workload, appointment volume,
-- completion rates, specialties, and facility-level activity.
-- ============================================================


SELECT 
    p.specialty, COUNT(a.appointment_id) AS appointment_count
FROM
    physicians_clean AS p
        INNER JOIN
    appointments_clean AS a ON p.physician_id = a.physician_id
GROUP BY p.specialty
ORDER BY appointment_count DESC;



-- 2. Top Physicians by Appointment Volume
-- Find the 10 physicians who handled the most appointments.

SELECT 
    p.physician_id,
    p.physician_name,
    p.specialty,
    f.facility_name,
    COUNT(a.appointment_id) AS appointment_volume
FROM
    appointments_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.physician_id = p.physician_id
        INNER JOIN
    facilities_clean AS f ON p.facility_id = f.facility_id
GROUP BY p.physician_id , p.physician_name , p.specialty , f.facility_name
ORDER BY appointment_volume DESC
LIMIT 10;



-- 3. Physician Completion Rate
-- Compare appointment volume and completion rates by physician.

SELECT 
    p.physician_id,
    p.physician_name,
    p.specialty,
    COUNT(a.appointment_id) AS total_appointments,
    ROUND(100.0 * SUM(CASE
                WHEN a.appointment_status = 'Completed' THEN 1
                ELSE 0
            END) / COUNT(a.appointment_id),
            2) AS completion_rate
FROM
    appointments_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.physician_id = p.physician_id
GROUP BY p.physician_id , p.physician_name , p.specialty
ORDER BY total_appointments DESC;



-- 4. Specialty Activity by Facility
-- Show appointment volume for each specialty within each facility.

SELECT 
    f.facility_name,
    p.specialty,
    COUNT(a.appointment_id) AS appointment_count
FROM
    appointments_clean AS a
        INNER JOIN
    physicians_clean AS p ON a.physician_id = p.physician_id
        INNER JOIN
    facilities_clean AS f ON p.facility_id = f.facility_id
GROUP BY f.facility_id , f.facility_name , p.specialty
ORDER BY appointment_count DESC;


-- ============================================================
-- End of Physician Analysis
-- ============================================================