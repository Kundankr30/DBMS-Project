BEGIN;

-- 1. CREATE AWARD
DROP FUNCTION IF EXISTS create_award(INTEGER, TEXT, INTEGER, DECIMAL);
CREATE OR REPLACE FUNCTION create_award(
    p_eid INTEGER,
    p_name TEXT,
    p_pos INTEGER,
    p_amt DECIMAL
)
RETURNS INTEGER AS $$
DECLARE
    new_id INTEGER;
    v_dup INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Events WHERE event_id = p_eid) THEN
        RAISE EXCEPTION 'Event not found';
    END IF;

    IF p_pos < 1 THEN
        RAISE EXCEPTION 'Position must be greater than 0';
    END IF;

    IF p_amt IS NOT NULL AND p_amt < 0 THEN
        RAISE EXCEPTION 'Prize amount cannot be negative';
    END IF;

    SELECT COUNT(*)
    INTO v_dup
    FROM Awards
    WHERE event_id = p_eid
    AND position = p_pos;

    IF v_dup > 0 THEN
        RAISE EXCEPTION 'This position already exists for the event';
    END IF;

    INSERT INTO Awards (award_name, event_id, position, prize_amount)
    VALUES (p_name, p_eid, p_pos, p_amt)
    RETURNING award_id INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEW AWARDS BY EVENT
DROP FUNCTION IF EXISTS view_awards_by_event(INTEGER);
CREATE OR REPLACE FUNCTION view_awards_by_event(
    p_eid INTEGER
)
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT a.award_id, a.award_name
    FROM Awards a
    WHERE a.event_id = p_eid
    ORDER BY a.position;
END;
$$ LANGUAGE plpgsql;


-- 3. ASSIGN AWARD WINNER
DROP FUNCTION IF EXISTS assign_award_winner(INTEGER, INTEGER);
DROP FUNCTION IF EXISTS assign_award_winner(INTEGER, TEXT);
CREATE OR REPLACE FUNCTION assign_award_winner(
    p_aid INTEGER,
    p_sic TEXT
)
RETURNS INTEGER AS $$
DECLARE
    v_event_id INTEGER;
    v_dup INTEGER;
BEGIN
    SELECT event_id
    INTO v_event_id
    FROM Awards
    WHERE award_id = p_aid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Award not found';
    END IF;

    -- Check if participant is registered for this event
    IF NOT EXISTS (
        SELECT 1 FROM Registrations 
        WHERE sic = p_sic AND event_id = v_event_id
    ) THEN
        RAISE EXCEPTION 'Participant is not registered for this event';
    END IF;

    SELECT COUNT(*)
    INTO v_dup
    FROM Award_Winners
    WHERE award_id = p_aid;

    IF v_dup > 0 THEN
        RAISE EXCEPTION 'Winner already assigned for this award';
    END IF;

    INSERT INTO Award_Winners (award_id, sic, won_date)
    VALUES (p_aid, p_sic, CURRENT_TIMESTAMP);

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 4. VIEW AWARD WINNERS
DROP FUNCTION IF EXISTS view_award_winners();
CREATE OR REPLACE FUNCTION view_award_winners()
RETURNS TABLE(a_name TEXT, sic TEXT, p_name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT a.award_name, aw.sic, p.name
    FROM Award_Winners aw
    JOIN Awards a ON a.award_id = aw.award_id
    JOIN Participants p ON p.sic = aw.sic
    ORDER BY a.event_id, a.position;
END;
$$ LANGUAGE plpgsql;


-- 5. UPDATE AWARD DETAILS
DROP FUNCTION IF EXISTS update_award_details(INTEGER, TEXT);
CREATE OR REPLACE FUNCTION update_award_details(
    p_id INTEGER,
    p_name TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Awards
    SET award_name = p_name
    WHERE award_id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Award not found';
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 6. GENERATE AWARD REPORT
DROP FUNCTION IF EXISTS generate_award_report(INTEGER);
CREATE OR REPLACE FUNCTION generate_award_report(
    p_eid INTEGER
)
RETURNS TEXT AS $$
DECLARE
    v_event_name TEXT;
    v_cursor CURSOR FOR
        SELECT
            a.position,
            a.award_name,
            p.name AS winner_name,
            a.prize_amount
        FROM Awards a
        LEFT JOIN Award_Winners aw ON aw.award_id = a.award_id
        LEFT JOIN Participants p ON p.sic = aw.sic
        WHERE a.event_id = p_eid
        ORDER BY a.position;

    v_row RECORD;
    v_result TEXT := '';
BEGIN
    SELECT event_name
    INTO v_event_name
    FROM Events
    WHERE event_id = p_eid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Event not found';
    END IF;

    v_result :=
        '========================================' || CHR(10) ||
        '           AWARD REPORT'                  || CHR(10) ||
        '========================================'  || CHR(10) ||
        '  Event : ' || v_event_name               || CHR(10) ||
        '----------------------------------------' || CHR(10);

    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_row;
        EXIT WHEN NOT FOUND;

        v_result := v_result ||
            '  Position : ' || v_row.position                                    || CHR(10) ||
            '  Award    : ' || v_row.award_name                                  || CHR(10) ||
            '  Winner   : ' || COALESCE(v_row.winner_name, 'Not yet assigned')   || CHR(10) ||
            '  Prize    : ' || COALESCE('Rs. ' || v_row.prize_amount::TEXT, 'None') || CHR(10) ||
            '----------------------------------------' || CHR(10);
    END LOOP;
    CLOSE v_cursor;

    v_result := v_result || '========================================';

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;
COMMIT;
