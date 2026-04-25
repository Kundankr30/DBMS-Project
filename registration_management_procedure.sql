-- 1. REGISTER FOR EVENT (PROCEDURE WITH TRANSACTION)
DROP PROCEDURE IF EXISTS register_for_event_proc(TEXT, INTEGER);
CREATE OR REPLACE PROCEDURE register_for_event_proc(
    p_sic TEXT,
    p_eid INTEGER
)
AS $$
DECLARE
    v_count INTEGER;
    v_max INTEGER;
BEGIN
    -- Check capacity
    SELECT COUNT(*) INTO v_count FROM Registrations WHERE event_id = p_eid;
    SELECT max_participants INTO v_max FROM Events WHERE event_id = p_eid;

    IF v_count >= v_max THEN
        RAISE NOTICE 'Event % is full (Max: %). Rolling back.', p_eid, v_max;
        ROLLBACK;
        RETURN;
    END IF;

    INSERT INTO Registrations (sic, event_id, registration_date)
    VALUES (p_sic, p_eid, NOW());
    
    COMMIT; -- Save registration
    RAISE NOTICE 'Registered student % for event % successfully.', p_sic, p_eid;
END;
$$ LANGUAGE plpgsql;

-- Wrapper
CREATE OR REPLACE FUNCTION register_for_event(
    p_sic TEXT,
    p_eid INTEGER
)
RETURNS TEXT AS $$
BEGIN
    CALL register_for_event_proc(p_sic, p_eid);
    RETURN 'Registration processed for student ' || p_sic;
EXCEPTION WHEN OTHERS THEN
    RETURN 'Registration failed for student ' || p_sic;
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


-- 4. CANCEL REGISTRATION (PROCEDURE WITH TRANSACTION)
DROP PROCEDURE IF EXISTS cancel_registration_proc(TEXT, INTEGER);
CREATE OR REPLACE PROCEDURE cancel_registration_proc(
    p_sic TEXT,
    p_eid INTEGER
)
AS $$
BEGIN
    DELETE FROM Registrations
    WHERE sic = p_sic AND event_id = p_eid;

    IF NOT FOUND THEN
        RAISE NOTICE 'Registration not found for student % in event %. Rolling back.', p_sic, p_eid;
        ROLLBACK;
    ELSE
        COMMIT;
        RAISE NOTICE 'Registration cancelled for student %.', p_sic;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Wrapper
CREATE OR REPLACE FUNCTION cancel_registration(
    p_sic TEXT,
    p_eid INTEGER
)
RETURNS INTEGER AS $$
BEGIN
    CALL cancel_registration_proc(p_sic, p_eid);
    RETURN 1;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
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
