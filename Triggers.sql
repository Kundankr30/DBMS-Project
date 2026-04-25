-- ==========================================
--           DATABASE TRIGGERS
-- ==========================================

-- 1. trigger_dlt_venue
CREATE OR REPLACE FUNCTION trg_delete_venue()
RETURNS TRIGGER AS $$
DECLARE
    event_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO event_count
    FROM Events
    WHERE venue_id = OLD.venue_id;

    IF event_count > 0 THEN
        RAISE EXCEPTION 'Cannot delete venue: events are scheduled here';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS delete_venue ON Venues;
CREATE TRIGGER delete_venue
BEFORE DELETE ON Venues
FOR EACH ROW
EXECUTE FUNCTION trg_delete_venue();


-- 2. trigger_cancel_event
CREATE OR REPLACE FUNCTION trg_cancel_event()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'cancelled' AND OLD.status != 'cancelled' THEN
        -- Mark all related registrations as cancelled
        UPDATE Registrations
        SET attendance_status = 'cancelled'
        WHERE event_id = NEW.event_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS cancel_event ON Events;
CREATE TRIGGER cancel_event
AFTER UPDATE ON Events
FOR EACH ROW
EXECUTE FUNCTION trg_cancel_event();


-- 3. trigger delete participant
CREATE OR REPLACE FUNCTION trg_delete_participant()
RETURNS TRIGGER AS $$
DECLARE
    reg_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO reg_count
    FROM Registrations
    WHERE sic = OLD.sic;

    IF reg_count > 0 THEN
        RAISE EXCEPTION 'Cannot delete participant: registrations exist';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS delete_participant ON Participants;
CREATE TRIGGER delete_participant
BEFORE DELETE ON Participants
FOR EACH ROW
EXECUTE FUNCTION trg_delete_participant();


-- 4. trigger register for event
CREATE OR REPLACE FUNCTION trg_register_for_event()
RETURNS TRIGGER AS $$
DECLARE
    exists_count INTEGER;
    current_count INTEGER;
    max_limit INTEGER;
BEGIN
    -- 1. Prevent duplicate registration
    SELECT COUNT(*) INTO exists_count
    FROM Registrations
    WHERE sic = NEW.sic
      AND event_id = NEW.event_id;

    IF exists_count > 0 THEN
        RAISE EXCEPTION 'Participant already registered for this event';
    END IF;

    -- 2. Check event capacity
    SELECT COUNT(*) INTO current_count
    FROM Registrations
    WHERE event_id = NEW.event_id;

    SELECT max_participants INTO max_limit
    FROM Events
    WHERE event_id = NEW.event_id;

    IF current_count >= max_limit THEN
        RAISE EXCEPTION 'Event is full';
    END IF;

    -- 3. Validate participant exists
    IF NOT EXISTS (
        SELECT 1 FROM Participants
        WHERE sic = NEW.sic
    ) THEN
        RAISE EXCEPTION 'Participant does not exist';
    END IF;

    -- 4. Validate event exists
    IF NOT EXISTS (
        SELECT 1 FROM Events
        WHERE event_id = NEW.event_id
    ) THEN
        RAISE EXCEPTION 'Event does not exist';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS register_for_event ON Registrations;
CREATE TRIGGER register_for_event
BEFORE INSERT ON Registrations
FOR EACH ROW
EXECUTE FUNCTION trg_register_for_event();


-- 5. trigger create performance
CREATE OR REPLACE FUNCTION trg_create_performance()
RETURNS TRIGGER AS $$
DECLARE
    reg_exists INTEGER;
    dup_count INTEGER;
BEGIN
    -- 1. Check participant is registered for the event
    SELECT COUNT(*) INTO reg_exists
    FROM Registrations
    WHERE sic = NEW.sic
      AND event_id = NEW.event_id;

    IF reg_exists = 0 THEN
        RAISE EXCEPTION 'Participant is not registered for this event';
    END IF;

    -- 2. Prevent duplicate performance entry
    SELECT COUNT(*) INTO dup_count
    FROM Performances
    WHERE sic = NEW.sic
      AND event_id = NEW.event_id;

    IF dup_count > 0 THEN
        RAISE EXCEPTION 'Performance already exists for this participant in this event';
    END IF;

    -- 3. Check event is active
    IF NOT EXISTS (
        SELECT 1 FROM Events
        WHERE event_id = NEW.event_id
          AND status != 'cancelled'
    ) THEN
        RAISE EXCEPTION 'Event is not active';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS create_performance ON Performances;
CREATE TRIGGER create_performance
BEFORE INSERT ON Performances
FOR EACH ROW
EXECUTE FUNCTION trg_create_performance();


-- 6. trigger assign judge score
CREATE OR REPLACE FUNCTION trg_assign_judge_score()
RETURNS TRIGGER AS $$
DECLARE
    dup_count INTEGER;
BEGIN
    -- 1. Validate score range (0-100)
    IF NEW.score < 0 OR NEW.score > 100 THEN
        RAISE EXCEPTION 'Score must be between 0 and 100';
    END IF;

    -- 2. Prevent duplicate judge scoring
    SELECT COUNT(*) INTO dup_count
    FROM Performance_Judges
    WHERE performance_id = NEW.performance_id
      AND judge_id = NEW.judge_id;

    IF dup_count > 0 THEN
        RAISE EXCEPTION 'Judge has already scored this performance';
    END IF;

    -- 3. Validate performance exists
    IF NOT EXISTS (
        SELECT 1 FROM Performances
        WHERE performance_id = NEW.performance_id
    ) THEN
        RAISE EXCEPTION 'Performance does not exist';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS assign_judge_score ON Performance_Judges;
CREATE TRIGGER assign_judge_score
BEFORE INSERT ON Performance_Judges
FOR EACH ROW
EXECUTE FUNCTION trg_assign_judge_score();


-- 7. trigger award winner
CREATE OR REPLACE FUNCTION trg_assign_award_winner()
RETURNS TRIGGER AS $$
DECLARE
    dup_count INTEGER;
    v_event_id INTEGER;
BEGIN
    -- 1. Ensure single winner per award
    SELECT COUNT(*) INTO dup_count
    FROM Award_Winners
    WHERE award_id = NEW.award_id;

    IF dup_count > 0 THEN
        RAISE EXCEPTION 'Winner already assigned for this award';
    END IF;

    -- 2. Get event_id for eligibility check
    SELECT event_id INTO v_event_id FROM Awards WHERE award_id = NEW.award_id;

    -- 3. Validate eligibility (participant must have performed)
    IF NOT EXISTS (
        SELECT 1 FROM Performances
        WHERE sic = NEW.sic
          AND event_id = v_event_id
    ) THEN
        RAISE EXCEPTION 'Participant has no performance in this event';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS assign_award_winner ON Award_Winners;
CREATE TRIGGER assign_award_winner
BEFORE INSERT ON Award_Winners
FOR EACH ROW
EXECUTE FUNCTION trg_assign_award_winner();
