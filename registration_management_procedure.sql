-- 1. REGISTER FOR EVENT
CREATE OR REPLACE FUNCTION register_for_event(
    p_pid INTEGER,
    p_eid INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    INSERT INTO Registrations (
        participant_id,
        event_id,
        registration_date,
        attendance_status
    )
    VALUES (
        p_pid,
        p_eid,
        NOW(),
        'registered'
    )
    RETURNING registration_id INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEW REGISTRATIONS
CREATE OR REPLACE FUNCTION view_registrations()
RETURNS TABLE(id INTEGER, p_name TEXT, e_name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.registration_id, 
        p.name, 
        e.event_name
    FROM Registrations r
    JOIN Participants p ON r.participant_id = p.participant_id
    JOIN Events e ON r.event_id = e.event_id;
END;
$$ LANGUAGE plpgsql;


-- 3. VIEW REGISTRATIONS BY EVENT
CREATE OR REPLACE FUNCTION view_registrations_by_event(
    p_eid INTEGER
)
RETURNS TABLE(id INTEGER, p_name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.registration_id, 
        p.name
    FROM Registrations r
    JOIN Participants p ON r.participant_id = p.participant_id
    WHERE r.event_id = p_eid;
END;
$$ LANGUAGE plpgsql;


-- 4. CANCEL REGISTRATION
CREATE OR REPLACE FUNCTION cancel_registration(
    p_id INTEGER
)
RETURNS INTEGER AS $$
BEGIN
    DELETE FROM Registrations
    WHERE registration_id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Registration not found';
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 5. MARK ATTENDANCE
CREATE OR REPLACE FUNCTION mark_attendance(
    p_id INTEGER,
    p_status TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Registrations
    SET attendance_status = p_status
    WHERE registration_id = p_id;

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
