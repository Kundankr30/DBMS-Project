-- Events Portal - Cultural
-- DBMS Lab Project 2025-26 (Semester 4) - Group 2
-- Roll 6: Kundan Kumar - Venue Management Procedures

-- Function: Add a new venue
-- Returns the new venue_id on success, -1 on failure
CREATE OR REPLACE FUNCTION add_venue(
    p_venue_name VARCHAR(100),
    p_location VARCHAR(200),
    p_capacity INTEGER,
    p_facilities TEXT
) RETURNS INTEGER AS $$
DECLARE
    v_venue_id INTEGER;
BEGIN
    -- Validate capacity
    IF p_capacity <= 0 THEN
        RAISE EXCEPTION 'Capacity must be greater than 0';
    END IF;

    -- Insert the new venue
    INSERT INTO Venues (venue_name, location, capacity, facilities)
    VALUES (p_venue_name, p_location, p_capacity, p_facilities)
    RETURNING venue_id INTO v_venue_id;

    RAISE NOTICE 'Venue added successfully with ID: %', v_venue_id;
    RETURN v_venue_id;

EXCEPTION
    WHEN not_null_violation THEN
        RAISE NOTICE 'Error: All required fields must be provided';
        RETURN -1;
    WHEN others THEN
        RAISE NOTICE 'Error adding venue: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Function: View all venues
-- Returns a table of all venues
CREATE OR REPLACE FUNCTION view_venues()
RETURNS TABLE (
    venue_id INTEGER,
    venue_name VARCHAR(100),
    location VARCHAR(200),
    capacity INTEGER,
    facilities TEXT,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT v.venue_id, v.venue_name, v.location, v.capacity, v.facilities, v.created_at
    FROM Venues v
    ORDER BY v.venue_name;
END;
$$ LANGUAGE plpgsql;

-- Function: Update venue details
-- Returns 1 on success, -1 on failure
CREATE OR REPLACE FUNCTION update_venue(
    p_venue_id INTEGER,
    p_venue_name VARCHAR(100),
    p_location VARCHAR(200),
    p_capacity INTEGER,
    p_facilities TEXT
) RETURNS INTEGER AS $$
DECLARE
    v_affected INTEGER;
BEGIN
    -- Validate capacity
    IF p_capacity <= 0 THEN
        RAISE EXCEPTION 'Capacity must be greater than 0';
    END IF;

    UPDATE Venues
    SET venue_name = p_venue_name,
        location = p_location,
        capacity = p_capacity,
        facilities = p_facilities
    WHERE venue_id = p_venue_id;

    GET DIAGNOSTICS v_affected = ROW_COUNT;

    IF v_affected = 0 THEN
        RAISE NOTICE 'No venue found with ID: %', p_venue_id;
        RETURN -1;
    END IF;

    RAISE NOTICE 'Venue % updated successfully', p_venue_id;
    RETURN 1;

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Error updating venue: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Function: Delete a venue
-- Returns 1 on success, -1 on failure (venue in use)
CREATE OR REPLACE FUNCTION delete_venue(p_venue_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_affected INTEGER;
    v_event_count INTEGER;
BEGIN
    -- Check if venue has associated events (foreign key constraint will prevent delete)
    SELECT COUNT(*) INTO v_event_count
    FROM Events
    WHERE venue_id = p_venue_id;

    IF v_event_count > 0 THEN
        RAISE NOTICE 'Cannot delete venue %: % event(s) are scheduled here', p_venue_id, v_event_count;
        RETURN -1;
    END IF;

    DELETE FROM Venues WHERE venue_id = p_venue_id;
    GET DIAGNOSTICS v_affected = ROW_COUNT;

    IF v_affected = 0 THEN
        RAISE NOTICE 'No venue found with ID: %', p_venue_id;
        RETURN -1;
    END IF;

    RAISE NOTICE 'Venue % deleted successfully', p_venue_id;
    RETURN 1;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Cannot delete venue: Foreign key constraint violation';
        RETURN -1;
    WHEN others THEN
        RAISE NOTICE 'Error deleting venue: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Function: Check venue capacity and current utilization
-- Returns a formatted string with capacity information
CREATE OR REPLACE FUNCTION check_venue_capacity(p_venue_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    v_venue_record RECORD;
    v_event_count INTEGER;
    v_registered_count INTEGER;
    v_result TEXT;
BEGIN
    -- Get venue details
    SELECT * INTO v_venue_record
    FROM Venues
    WHERE venue_id = p_venue_id;

    IF NOT FOUND THEN
        RETURN 'Venue ID ' || p_venue_id || ' not found';
    END IF;

    -- Count scheduled events at this venue
    SELECT COUNT(*) INTO v_event_count
    FROM Events
    WHERE venue_id = p_venue_id
    AND event_date >= CURRENT_DATE
    AND status != 'Cancelled';

    -- Count total registered participants for events at this venue
    SELECT COALESCE(SUM(r_count), 0) INTO v_registered_count
    FROM (
        SELECT COUNT(r.registration_id) AS r_count
        FROM Events e
        JOIN Registrations r ON e.event_id = r.event_id
        WHERE e.venue_id = p_venue_id
        GROUP BY e.event_id
    ) AS registration_counts;

    v_result := E'\n=== Venue Capacity Check ===' || E'\n';
    v_result := v_result || 'Venue ID: ' || v_venue_record.venue_id || E'\n';
    v_result := v_result || 'Name: ' || v_venue_record.venue_name || E'\n';
    v_result := v_result || 'Location: ' || v_venue_record.location || E'\n';
    v_result := v_result || 'Maximum Capacity: ' || v_venue_record.capacity || E'\n';
    v_result := v_result || 'Facilities: ' || COALESCE(v_venue_record.facilities, 'N/A') || E'\n';
    v_result := v_result || 'Upcoming Events: ' || v_event_count || E'\n';
    v_result := v_result || 'Total Registrations: ' || v_registered_count || E'\n';
    v_result := v_result || '========================';

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Additional helpful function: Get venue by ID
CREATE OR REPLACE FUNCTION get_venue_by_id(p_venue_id INTEGER)
RETURNS TABLE (
    venue_id INTEGER,
    venue_name VARCHAR(100),
    location VARCHAR(200),
    capacity INTEGER,
    facilities TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT v.venue_id, v.venue_name, v.location, v.capacity, v.facilities
    FROM Venues v
    WHERE v.venue_id = p_venue_id;
END;
$$ LANGUAGE plpgsql;

-- Additional function: Search venues by name pattern
CREATE OR REPLACE FUNCTION search_venues_by_name(p_pattern VARCHAR)
RETURNS TABLE (
    venue_id INTEGER,
    venue_name VARCHAR(100),
    location VARCHAR(200),
    capacity INTEGER,
    facilities TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT v.venue_id, v.venue_name, v.location, v.capacity, v.facilities
    FROM Venues v
    WHERE v.venue_name ILIKE '%' || p_pattern || '%'
    ORDER BY v.venue_name;
END;
$$ LANGUAGE plpgsql;

\echo 'Venue management functions created successfully!';
\echo 'Functions created:';
\echo '  - add_venue(venue_name, location, capacity, facilities) : INTEGER';
\echo '  - view_venues() : TABLE';
\echo '  - update_venue(venue_id, venue_name, location, capacity, facilities) : INTEGER';
\echo '  - delete_venue(venue_id) : INTEGER';
\echo '  - check_venue_capacity(venue_id) : TEXT';
\echo '  - get_venue_by_id(venue_id) : TABLE';
\echo '  - search_venues_by_name(pattern) : TABLE';
