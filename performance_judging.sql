-- 1. CREATE PERFORMANCE
DROP FUNCTION IF EXISTS create_performance(INTEGER);
DROP FUNCTION IF EXISTS create_performance(TEXT, INTEGER);
CREATE OR REPLACE FUNCTION create_performance(
    p_sic TEXT,
    p_eid INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_status TEXT;
    new_id INTEGER;
    v_dup INTEGER;
BEGIN
    SELECT attendance_status
    INTO v_status
    FROM Registrations
    WHERE sic = p_sic AND event_id = p_eid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Registration not found';
    END IF;

    IF v_status <> 'present' THEN
        RAISE EXCEPTION 'Participant is not marked present';
    END IF;

    SELECT COUNT(*)
    INTO v_dup
    FROM Performances
    WHERE sic = p_sic AND event_id = p_eid;

    IF v_dup > 0 THEN
        RAISE EXCEPTION 'Performance entry already exists for this registration';
    END IF;

    INSERT INTO Performances (sic, event_id, performance_date)
    VALUES (p_sic, p_eid, CURRENT_TIMESTAMP)
    RETURNING performance_id INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;


-- 2. ASSIGN JUDGE SCORE (PROCEDURE WITH TRANSACTION)
DROP PROCEDURE IF EXISTS assign_judge_score_proc(INTEGER, INTEGER, DECIMAL, TEXT);
CREATE OR REPLACE PROCEDURE assign_judge_score_proc(
    p_pid INTEGER,
    p_jid INTEGER,
    p_score DECIMAL,
    p_comment TEXT
)
AS $$
DECLARE
    v_perf_exists INTEGER;
    v_judge_exists INTEGER;
    v_dup INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_perf_exists FROM Performances WHERE performance_id = p_pid;
    IF v_perf_exists = 0 THEN
        RAISE NOTICE 'Performance not found';
        ROLLBACK;
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_judge_exists FROM Judges WHERE judge_id = p_jid;
    IF v_judge_exists = 0 THEN
        RAISE NOTICE 'Judge not found';
        ROLLBACK;
        RETURN;
    END IF;

    -- Transactional Logic: Validate score
    IF p_score < 0 OR p_score > 100 THEN
        RAISE NOTICE 'Invalid score: %. Score must be between 0 and 100. Rolling back.', p_score;
        ROLLBACK;
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_dup FROM Performance_Judges WHERE performance_id = p_pid AND judge_id = p_jid;
    IF v_dup > 0 THEN
        RAISE NOTICE 'Judge has already scored this performance';
        ROLLBACK;
        RETURN;
    END IF;

    INSERT INTO Performance_Judges (performance_id, judge_id, score, comments)
    VALUES (p_pid, p_jid, p_score, p_comment);

    COMMIT; -- Explicitly commit the score assignment
    RAISE NOTICE 'Score assigned and committed successfully.';
END;
$$ LANGUAGE plpgsql;

-- Original function as a wrapper for backward compatibility
CREATE OR REPLACE FUNCTION assign_judge_score(
    p_pid INTEGER,
    p_jid INTEGER,
    p_score DECIMAL,
    p_comment TEXT
)
RETURNS INTEGER AS $$
BEGIN
    CALL assign_judge_score_proc(p_pid, p_jid, p_score, p_comment);
    RETURN 1;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
$$ LANGUAGE plpgsql;


-- 3. UPDATE JUDGE SCORE (PROCEDURE WITH TRANSACTION)
DROP PROCEDURE IF EXISTS update_judge_score_proc(INTEGER, DECIMAL);
CREATE OR REPLACE PROCEDURE update_judge_score_proc(
    p_id INTEGER,
    p_score DECIMAL
)
AS $$
BEGIN
    IF p_score < 0 OR p_score > 100 THEN
        RAISE NOTICE 'Score % is out of range. Rolling back.', p_score;
        ROLLBACK;
        RETURN;
    END IF;

    UPDATE Performance_Judges
    SET score = p_score
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Score record % not found.', p_id;
        ROLLBACK;
    ELSE
        COMMIT; -- Save change
        RAISE NOTICE 'Score updated and committed.';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Wrapper
CREATE OR REPLACE FUNCTION update_judge_score(
    p_id INTEGER,
    p_score DECIMAL
)
RETURNS INTEGER AS $$
BEGIN
    CALL update_judge_score_proc(p_id, p_score);
    RETURN 1;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
$$ LANGUAGE plpgsql;


-- 4. VIEW SCORES BY PERFORMANCE
DROP FUNCTION IF EXISTS view_scores_by_performance(INTEGER);
CREATE OR REPLACE FUNCTION view_scores_by_performance(
    p_pid INTEGER
)
RETURNS TABLE(j_name TEXT, score DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT j.judge_name, pj.score
    FROM Performance_Judges pj
    JOIN Judges j ON j.judge_id = pj.judge_id
    WHERE pj.performance_id = p_pid
    ORDER BY pj.score DESC;
END;
$$ LANGUAGE plpgsql;


-- 5. VIEW SCORES BY EVENT
DROP FUNCTION IF EXISTS view_scores_by_event(INTEGER);
CREATE OR REPLACE FUNCTION view_scores_by_event(
    p_eid INTEGER
)
RETURNS TABLE(sic TEXT, score DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pf.sic,
        ROUND(AVG(pj.score)::DECIMAL, 2)
    FROM Performances pf
    JOIN Performance_Judges pj ON pj.performance_id = pf.performance_id
    WHERE pf.event_id = p_eid
    GROUP BY pf.sic
    ORDER BY ROUND(AVG(pj.score)::DECIMAL, 2) DESC;
END;
$$ LANGUAGE plpgsql;


-- 6. SHOW LEADERBOARD
DROP FUNCTION IF EXISTS show_leaderboard(INTEGER);
CREATE OR REPLACE FUNCTION show_leaderboard(
    p_eid INTEGER
)
RETURNS TABLE(rank INTEGER, p_name TEXT, score DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT
        DENSE_RANK() OVER (
            ORDER BY ROUND(AVG(pj.score)::DECIMAL, 2) DESC
        )::INTEGER,
        p.name,
        ROUND(AVG(pj.score)::DECIMAL, 2)
    FROM Performances pf
    JOIN Participants p ON p.sic = pf.sic
    JOIN Performance_Judges pj ON pj.performance_id = pf.performance_id
    WHERE pf.event_id = p_eid
    GROUP BY pf.sic, p.name
    ORDER BY ROUND(AVG(pj.score)::DECIMAL, 2) DESC;
END;
$$ LANGUAGE plpgsql;


-- 7. PERFORMANCE STATISTICS
DROP FUNCTION IF EXISTS performance_statistics(INTEGER);
CREATE OR REPLACE FUNCTION performance_statistics(
    p_eid INTEGER
)
RETURNS TEXT AS $$
DECLARE
    v_event_name TEXT;
    v_total INTEGER;
    v_highest DECIMAL;
    v_lowest DECIMAL;
    v_average DECIMAL;
    v_top_name TEXT;
    v_top_score DECIMAL;
    v_result TEXT;
BEGIN
    SELECT event_name
    INTO v_event_name
    FROM Events
    WHERE event_id = p_eid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Event not found';
    END IF;

    SELECT
        COUNT(DISTINCT pf.performance_id),
        MAX(pj.score),
        MIN(pj.score),
        ROUND(AVG(pj.score)::DECIMAL, 2)
    INTO v_total, v_highest, v_lowest, v_average
    FROM Performances pf
    JOIN Performance_Judges pj ON pj.performance_id = pf.performance_id
    WHERE pf.event_id = p_eid;

    IF v_total IS NULL OR v_total = 0 THEN
        RETURN 'No scored performances found for this event';
    END IF;

    SELECT p.name, ROUND(AVG(pj.score)::DECIMAL, 2)
    INTO v_top_name, v_top_score
    FROM Performances pf
    JOIN Participants p ON p.sic = pf.sic
    JOIN Performance_Judges pj ON pj.performance_id = pf.performance_id
    WHERE pf.event_id = p_eid
    GROUP BY pf.sic, p.name
    ORDER BY AVG(pj.score) DESC
    LIMIT 1;

    v_result :=
        '========================================' || CHR(10) ||
        '     PERFORMANCE STATISTICS'              || CHR(10) ||
        '========================================'  || CHR(10) ||
        '  Event         : ' || v_event_name        || CHR(10) ||
        '----------------------------------------' || CHR(10) ||
        '  Total Scored  : ' || v_total              || CHR(10) ||
        '  Highest Score : ' || v_highest            || CHR(10) ||
        '  Lowest Score  : ' || v_lowest             || CHR(10) ||
        '  Average Score : ' || v_average            || CHR(10) ||
        '----------------------------------------' || CHR(10) ||
        '  Top Performer : ' || v_top_name           || CHR(10) ||
        '  Top Avg Score : ' || v_top_score          || CHR(10) ||
        '========================================';

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;
