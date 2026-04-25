BEGIN;

CREATE OR REPLACE FUNCTION add_event(
    p_name TEXT,
    p_type TEXT,
    p_date DATE,
    p_start TIME,
    p_end TIME,
    p_venue INTEGER,
    p_max INTEGER,
    p_desc TEXT
)
RETURNS INTEGER AS $$
DECLARE 
    new_id INTEGER;
BEGIN
    IF p_start >= p_end THEN
        RAISE EXCEPTION 'Start time must be before end time';
    END IF;
    INSERT INTO Events (
        event_name,
        event_type,
        event_date,
        start_time,
        end_time,
        venue_id,
        max_participants,
        description,
        status
    )
    VALUES (
        p_name,
        p_type,
        p_date,
        p_start,
        p_end,
        p_venue,
        p_max,
        p_desc,
        'active'
    )
    RETURNING event_id INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_all_events()
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT event_id, event_name
    FROM Events
    WHERE status != 'cancelled';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_event(
    p_id INTEGER,
    p_name TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Events
    SET event_name = p_name
    WHERE event_id = p_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Event not found';
    END IF;
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cancel_event(p_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Events
    SET status = 'cancelled'
    WHERE event_id = p_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Event not found';
    END IF;
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_events_by_type(p_type TEXT)
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT event_id, event_name
    FROM Events
    WHERE event_type = p_type
    AND status != 'cancelled';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_events_by_date(
    p_start DATE,
    p_end DATE
)
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT event_id, event_name
    FROM Events
    WHERE event_date BETWEEN p_start AND p_end
    AND status != 'cancelled';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_events_by_venue(p_venue INTEGER)
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT event_id, event_name
    FROM Events
    WHERE venue_id = p_venue
    AND status != 'cancelled';
END;
$$ LANGUAGE plpgsql;
COMMIT;
