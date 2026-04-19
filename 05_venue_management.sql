CREATE OR REPLACE FUNCTION add_venue(
    p_name TEXT,
    p_location TEXT,
    p_capacity INTEGER,
    p_facilities TEXT
)
RETURNS INTEGER AS $$
DECLARE 
    new_id INTEGER;
BEGIN
    INSERT INTO Venues (venue_name, location, capacity, facilities)
    VALUES (p_name, p_location, p_capacity, p_facilities)
    RETURNING venue_id INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_venues()
RETURNS TABLE(id INTEGER, name TEXT, loc TEXT, cap INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT venue_id, venue_name, location, capacity
    FROM Venues;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_venue(
    p_id INTEGER,
    p_name TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Venues
    SET venue_name = p_name
    WHERE venue_id = p_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Venue not found';
    END IF;
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_venue(p_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
    DELETE FROM Venues
    WHERE venue_id = p_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Venue not found';
    END IF;
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_venue_capacity(p_id INTEGER)
RETURNS TABLE(name TEXT, cap INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT venue_name, capacity
    FROM Venues
    WHERE venue_id = p_id;
END;
$$ LANGUAGE plpgsql;
