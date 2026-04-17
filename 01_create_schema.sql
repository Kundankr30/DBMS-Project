-- Events Portal - Cultural
-- DBMS Lab Project 2025-26 (Semester 4) - Group 2
-- Roll 6: Kundan Kumar - Database Schema Creation
-- This script creates all 9 tables with proper constraints

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS Award_Winners;
DROP TABLE IF EXISTS Performance_Judges;
DROP TABLE IF EXISTS Awards;
DROP TABLE IF EXISTS Performances;
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Judges;
DROP TABLE IF EXISTS Participants;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Venues;

-- Table 1: Venues
CREATE TABLE Venues (
    venue_id SERIAL PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    facilities TEXT
);

-- Table 2: Events
CREATE TABLE Events (
    event_id SERIAL PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,

    event_type VARCHAR(50) NOT NULL
        CHECK (event_type IN (
            'dance',
            'music',
            'drama',
            'literary',
            'fashion',
            'comedy',
            'fine_arts',
            'celebration',
            'other'
        )),

    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,

    venue_id INTEGER NOT NULL REFERENCES Venues(venue_id),

    max_participants INTEGER NOT NULL DEFAULT 100
        CHECK (max_participants > 0),

    description TEXT,

    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'completed', 'cancelled')),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_event_time CHECK (start_time < end_time)
);

-- Table 3: Participants
CREATE TABLE Participants (
    participant_id SERIAL PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    phone VARCHAR(15),
    college VARCHAR(100),
    department VARCHAR(50),

    year_of_study INTEGER
        CHECK (year_of_study BETWEEN 1 AND 5),

    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 4: Judges
CREATE TABLE Judges (
    judge_id SERIAL PRIMARY KEY,
    judge_name VARCHAR(100) NOT NULL,
    expertise VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- Table 5: Registrations
CREATE TABLE Registrations (
    registration_id SERIAL PRIMARY KEY,

    participant_id INTEGER NOT NULL REFERENCES Participants(participant_id),

    event_id INTEGER NOT NULL REFERENCES Events(event_id),

    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    attendance_status VARCHAR(20) NOT NULL DEFAULT 'registered'
        CHECK (attendance_status IN ('registered', 'present', 'absent')),

    UNIQUE(participant_id, event_id)
);

-- Table 6: Performances
CREATE TABLE Performances (
    performance_id SERIAL PRIMARY KEY,

    registration_id INTEGER NOT NULL REFERENCES Registrations(registration_id),

    performance_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(registration_id)
);

-- Table 7: Performance_Judges
CREATE TABLE Performance_Judges (
    id SERIAL PRIMARY KEY,

    performance_id INTEGER NOT NULL REFERENCES Performances(performance_id),

    judge_id INTEGER NOT NULL REFERENCES Judges(judge_id),

    score DECIMAL(5,2) NOT NULL
        CHECK (score BETWEEN 0 AND 100),

    comments TEXT,

    UNIQUE(performance_id, judge_id)
);

-- Table 8: Awards
CREATE TABLE Awards (
    award_id SERIAL PRIMARY KEY,

    award_name VARCHAR(100) NOT NULL,

    event_id INTEGER NOT NULL REFERENCES Events(event_id),

    position INTEGER NOT NULL
        CHECK (position > 0),

    prize_amount DECIMAL(10,2)
        CHECK (prize_amount IS NULL OR prize_amount >= 0),

    UNIQUE(event_id, position)
);

-- Table 9: Award_Winners
CREATE TABLE Award_Winners (
    winner_id SERIAL PRIMARY KEY,

    award_id INTEGER NOT NULL REFERENCES Awards(award_id),

    registration_id INTEGER NOT NULL REFERENCES Registrations(registration_id),

    won_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(award_id)
);

-- Add comments to tables for documentation
COMMENT ON TABLE Venues IS 'Stores venue name, location, capacity > 0 and facilities';
COMMENT ON TABLE Events IS 'Stores cultural event details with event_type categories and venue_id foreign key';
COMMENT ON TABLE Participants IS 'Stores participant details with unique email and year_of_study check';
COMMENT ON TABLE Judges IS 'Stores judges and their expertise with optional unique email';
COMMENT ON TABLE Registrations IS 'Links participants to events, stores attendance status and prevents duplicate registration';
COMMENT ON TABLE Performances IS 'Creates one performance entry per registration';
COMMENT ON TABLE Performance_Judges IS 'Stores judge-wise score and comments for each performance';
COMMENT ON TABLE Awards IS 'Stores event awards, positions, and prize amounts with one position per event';
COMMENT ON TABLE Award_Winners IS 'Links each award to a registration_id, proving the winner registered for that event';

\echo 'Schema created successfully! All 9 tables created with constraints.';
