-- ============================================================
--         PostgreSQL Stored Functions
--         Event Management System
-- ============================================================


-- ------------------------------------------------------------
-- 1. Event Participation Report
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION event_participation_report()
RETURNS TABLE(e_name TEXT, count INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.event_name::TEXT,
        COUNT(r.sic)::INTEGER
    FROM Events e
    LEFT JOIN Registrations r ON e.event_id = r.event_id
    GROUP BY e.event_id, e.event_name;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 2. Registration Summary
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION registration_summary()
RETURNS TABLE(total INTEGER, present INTEGER, absent INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER,
        COUNT(*) FILTER (WHERE attendance_status = 'present')::INTEGER,
        COUNT(*) FILTER (WHERE attendance_status = 'absent')::INTEGER
    FROM Registrations;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 3. Attendance Report
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION attendance_report()
RETURNS TABLE(p_name TEXT, status TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.name::TEXT,
        r.attendance_status::TEXT
    FROM Participants p
    JOIN Registrations r ON p.sic = r.sic;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 4. Venue Utilization Report
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION venue_utilization_report()
RETURNS TABLE(v_name TEXT, utilization TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.venue_name::TEXT,
        COALESCE(
            ROUND(
                (COUNT(e.event_id)::NUMERIC / NULLIF(v.capacity, 0)) * 100, 2
            )::TEXT || '%',
            '0%'
        )
    FROM Venues v
    LEFT JOIN Events e ON v.venue_id = e.venue_id
    GROUP BY v.venue_id, v.venue_name, v.capacity;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 5. Top Performers Report
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION top_performers_report()
RETURNS TABLE(p_name TEXT, score DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.name::TEXT,
        MAX(pj.score)
    FROM Participants p
    JOIN Performances pf ON p.sic = pf.sic
    JOIN Performance_Judges pj ON pf.performance_id = pj.performance_id
    GROUP BY p.sic, p.name
    ORDER BY MAX(pj.score) DESC;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 6. Event Statistics
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION event_statistics()
RETURNS TABLE(e_name TEXT, avg_score DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.event_name::TEXT,
        ROUND(AVG(pj.score), 2)
    FROM Events e
    JOIN Performances pf ON e.event_id = pf.event_id
    JOIN Performance_Judges pj ON pf.performance_id = pj.performance_id
    GROUP BY e.event_id, e.event_name;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 7. Participant Statistics
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION participant_statistics()
RETURNS TABLE(p_name TEXT, participation_count INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.name::TEXT,
        COUNT(r.event_id)::INTEGER
    FROM Participants p
    LEFT JOIN Registrations r ON p.sic = r.sic
    GROUP BY p.sic, p.name;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- 8. Awards Summary
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION awards_summary()
RETURNS TABLE(a_name TEXT, winner_count INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.award_name::TEXT,
        COUNT(aw.winner_id)::INTEGER
    FROM Awards a
    LEFT JOIN Award_Winners aw ON a.award_id = aw.award_id
    GROUP BY a.award_id, a.award_name;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
--   END OF REPORT FUNCTIONS
-- ============================================================
