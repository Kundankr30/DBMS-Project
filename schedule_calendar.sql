-- 1. VIEW FULL CALENDAR
CREATE OR REPLACE FUNCTION view_full_calendar()
RETURNS TABLE(id INTEGER, name TEXT, date DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT e.event_id, e.event_name, e.event_date
    FROM Events e
    WHERE e.status != 'cancelled'
    ORDER BY e.event_date, e.start_time;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEW EVENTS BY MONTH
CREATE OR REPLACE FUNCTION view_events_by_month(
    p_m INTEGER,
    p_y INTEGER
)
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    IF p_m < 1 OR p_m > 12 THEN
        RAISE EXCEPTION 'Invalid month. Must be between 1 and 12';
    END IF;

    RETURN QUERY
    SELECT e.event_id, e.event_name
    FROM Events e
    WHERE EXTRACT(MONTH FROM e.event_date) = p_m
    AND EXTRACT(YEAR FROM e.event_date) = p_y
    AND e.status != 'cancelled'
    ORDER BY e.event_date, e.start_time;
END;
$$ LANGUAGE plpgsql;


-- 3. VIEW UPCOMING EVENTS
CREATE OR REPLACE FUNCTION view_upcoming_events()
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT e.event_id, e.event_name
    FROM Events e
    WHERE e.event_date >= CURRENT_DATE
    AND e.status != 'cancelled'
    ORDER BY e.event_date, e.start_time;
END;
$$ LANGUAGE plpgsql;


-- 4. CHECK VENUE AVAILABILITY
CREATE OR REPLACE FUNCTION check_venue_availability(
    p_vid INTEGER,
    p_date DATE
)
RETURNS TEXT AS $$
DECLARE
    v_venue_name TEXT;
    v_count INTEGER;
BEGIN
    SELECT venue_name
    INTO v_venue_name
    FROM Venues
    WHERE venue_id = p_vid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Venue not found';
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM Events
    WHERE venue_id = p_vid
    AND event_date = p_date
    AND status != 'cancelled';

    IF v_count = 0 THEN
        RETURN v_venue_name || ' is AVAILABLE on ' || p_date::TEXT;
    ELSE
        RETURN v_venue_name || ' is BOOKED on ' || p_date::TEXT ||
               ' (' || v_count || ' event(s) scheduled)';
    END IF;
END;
$$ LANGUAGE plpgsql;


-- 5. DETECT SCHEDULE CONFLICTS
CREATE OR REPLACE FUNCTION detect_schedule_conflicts()
RETURNS TEXT AS $$
DECLARE
    v_cursor CURSOR FOR
        SELECT
            e1.event_id AS id1,
            e1.event_name AS name1,
            e2.event_id AS id2,
            e2.event_name AS name2,
            e1.venue_id,
            e1.event_date,
            e1.start_time AS start1,
            e1.end_time AS end1,
            e2.start_time AS start2,
            e2.end_time AS end2
        FROM Events e1
        JOIN Events e2
            ON e1.venue_id = e2.venue_id
            AND e1.event_date = e2.event_date
            AND e1.event_id < e2.event_id
            AND e1.start_time < e2.end_time
            AND e1.end_time > e2.start_time
        WHERE e1.status != 'cancelled'
        AND e2.status != 'cancelled'
        ORDER BY e1.venue_id, e1.event_date, e1.start_time;

    v_row RECORD;
    v_result TEXT := '';
    v_count INTEGER := 0;
BEGIN
    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_row;
        EXIT WHEN NOT FOUND;

        v_count := v_count + 1;
        v_result := v_result ||
            'CONFLICT ' || v_count || ': ' ||
            v_row.name1 || ' (ID ' || v_row.id1 || ')' ||
            ' vs ' ||
            v_row.name2 || ' (ID ' || v_row.id2 || ')' || CHR(10) ||
            '  Venue ID : ' || v_row.venue_id   || CHR(10) ||
            '  Date     : ' || v_row.event_date  || CHR(10) ||
            '  Times    : ' || v_row.start1 || ' - ' || v_row.end1 ||
            '  vs  '        || v_row.start2 || ' - ' || v_row.end2 ||
            CHR(10) || CHR(10);
    END LOOP;
    CLOSE v_cursor;

    IF v_count = 0 THEN
        RETURN 'No schedule conflicts detected';
    ELSE
        RETURN v_count || ' conflict(s) found:' || CHR(10) || CHR(10) || v_result;
    END IF;
END;
$$ LANGUAGE plpgsql;
