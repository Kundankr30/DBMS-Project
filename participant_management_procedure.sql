-- 1. REGISTER PARTICIPANT
CREATE OR REPLACE FUNCTION register_participant(
    p_name TEXT,
    p_email TEXT,
    p_year INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    INSERT INTO Participants (name, email, year_of_study)
    VALUES (p_name, p_email, p_year)
    RETURNING participant_id INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEW PARTICIPANTS
CREATE OR REPLACE FUNCTION view_participants()
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.participant_id, p.name
    FROM Participants p;
END;
$$ LANGUAGE plpgsql;


-- 3. UPDATE PARTICIPANT
CREATE OR REPLACE FUNCTION update_participant(
    p_id INTEGER,
    p_name TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Participants
    SET name = p_name
    WHERE participant_id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Participant not found';
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 4. SEARCH PARTICIPANT BY EMAIL
CREATE OR REPLACE FUNCTION search_participant_by_email(
    p_email TEXT
)
RETURNS TABLE(id INTEGER, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.participant_id, p.name
    FROM Participants p
    WHERE p.email = p_email;
END;
$$ LANGUAGE plpgsql;


-- 5. DELETE PARTICIPANT
CREATE OR REPLACE FUNCTION delete_participant(
    p_id INTEGER
)
RETURNS INTEGER AS $$
BEGIN
    DELETE FROM Participants
    WHERE participant_id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Participant not found';
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;
