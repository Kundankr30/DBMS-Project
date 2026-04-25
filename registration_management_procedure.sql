-- 1. REGISTER FOR EVENT
CREATE OR REPLACE FUNCTION register_for_event(
    p_sic TEXT,
    p_eid INTEGER
)
RETURNS TEXT AS $$
BEGIN
    INSERT INTO Registrations (sic, event_id, registration_date)
    VALUES (p_sic, p_eid, NOW());
    
    RETURN 'Registered student ' || p_sic || ' for event ' || p_eid;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEW REGISTRATIONS
CREATE OR REPLACE FUNCTION view_registrations()
RETURNS TABLE(sic TEXT, p_name TEXT, e_name TEXT, status TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.sic, 
        p.name, 
        e.event_name,
        r.attendance_status
    FROM Registrations r
    JOIN Participants p ON r.sic = p.sic
    JOIN Events e ON r.event_id = e.event_id;
END;
$$ LANGUAGE plpgsql;


-- 3. VIEW REGISTRATIONS BY EVENT
CREATE OR REPLACE FUNCTION view_registrations_by_event(
    p_eid INTEGER
)
RETURNS TABLE(sic TEXT, p_name TEXT, status TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.sic, 
        p.name,
        r.attendance_status
    FROM Registrations r
    JOIN Participants p ON r.sic = p.sic
    WHERE r.event_id = p_eid;
END;
$$ LANGUAGE plpgsql;


-- 4. CANCEL REGISTRATION
CREATE OR REPLACE FUNCTION cancel_registration(
    p_sic TEXT,
    p_eid INTEGER
)
RETURNS INTEGER AS $$
BEGIN
    DELETE FROM Registrations
    WHERE sic = p_sic AND event_id = p_eid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Registration not found for student % in event %', p_sic, p_eid;
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 5. MARK ATTENDANCE
CREATE OR REPLACE FUNCTION mark_attendance(
    p_sic TEXT,
    p_eid INTEGER,
    p_status TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Registrations
    SET attendance_status = p_status
    WHERE sic = p_sic AND event_id = p_eid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Registration not found';
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 6. CHECK EVENT REGISTRATION COUNT
CREATE OR REPLACE FUNCTION check_event_registration_count(
    p_eid INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM Registrations
    WHERE event_id = p_eid;

    RETURN total;
END;
$$ LANGUAGE plpgsql;
