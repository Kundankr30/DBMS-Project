-- 1. REGISTER PARTICIPANT
CREATE OR REPLACE FUNCTION register_participant(
    p_sic TEXT,
    p_name TEXT,
    p_email TEXT,
    p_year INTEGER
)
RETURNS TEXT AS $$
BEGIN
    INSERT INTO Participants (sic, name, email, year_of_study)
    VALUES (p_sic, p_name, p_email, p_year);

    RETURN 'Registered student ' || p_name || ' with SIC ' || p_sic;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEW PARTICIPANTS
CREATE OR REPLACE FUNCTION view_participants()
RETURNS TABLE(sic TEXT, name TEXT, email TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.sic, p.name, p.email
    FROM Participants p;
END;
$$ LANGUAGE plpgsql;


-- 3. UPDATE PARTICIPANT
CREATE OR REPLACE FUNCTION update_participant(
    p_sic TEXT,
    p_name TEXT
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE Participants
    SET name = p_name
    WHERE sic = p_sic;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Participant with SIC % not found', p_sic;
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;


-- 4. SEARCH PARTICIPANT BY EMAIL
CREATE OR REPLACE FUNCTION search_participant_by_email(
    p_email TEXT
)
RETURNS TABLE(sic TEXT, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.sic, p.name
    FROM Participants p
    WHERE p.email = p_email;
END;
$$ LANGUAGE plpgsql;


-- 5. DELETE PARTICIPANT
CREATE OR REPLACE FUNCTION delete_participant(
    p_sic TEXT
)
RETURNS INTEGER AS $$
BEGIN
    DELETE FROM Participants
    WHERE sic = p_sic;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Participant with SIC % not found', p_sic;
    END IF;

    RETURN 1;
END;
$$ LANGUAGE plpgsql;
