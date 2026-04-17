-- Events Portal - Cultural
-- DBMS Lab Project 2025-26 (Semester 4) - Group 2
-- Roll 6: Kundan Kumar - Indexes Creation

-- Index on Events(event_date) - For calendar view and date-based searches
CREATE INDEX idx_events_date ON Events(event_date);

-- Index on Events(venue_id) - For venue-based queries and joins
CREATE INDEX idx_events_venue ON Events(venue_id);

-- Index on Registrations(event_id) - For event registration counts and lookups
CREATE INDEX idx_registrations_event ON Registrations(event_id);

-- Index on Performance_Judges(performance_id) - For score lookups by performance
CREATE INDEX idx_performance_judges_performance ON Performance_Judges(performance_id);

-- Additional indexes for performance optimization

-- Index on Registrations(participant_id) - For participant registration lookups
CREATE INDEX idx_registrations_participant ON Registrations(participant_id);

-- Index on Performances(registration_id) - For performance lookups by registration
CREATE INDEX idx_performances_registration ON Performances(registration_id);

-- Index on Participants(email) - For email-based searches
CREATE INDEX idx_participants_email ON Participants(email);

-- Index on Events(event_type) - For event type searches
CREATE INDEX idx_events_type ON Events(event_type);

-- Index on Award_Winners(registration_id) - For winner lookups
CREATE INDEX idx_award_winners_registration ON Award_Winners(registration_id);

-- Index on Awards(event_id) - For award lookups by event
CREATE INDEX idx_awards_event ON Awards(event_id);

-- Index on Performance_Judges(judge_id) - For judge score lookups
CREATE INDEX idx_performance_judges_judge ON Performance_Judges(judge_id);

\echo 'All indexes created successfully!';
