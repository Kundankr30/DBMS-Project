DROP TABLE IF EXISTS Award_Winners;
DROP TABLE IF EXISTS Performance_Judges;
DROP TABLE IF EXISTS Awards;
DROP TABLE IF EXISTS Performances;
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Judges;
DROP TABLE IF EXISTS Participants;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Venues;

CREATE TABLE Venues (
    venue_id SERIAL PRIMARY KEY,
    venue_name TEXT NOT NULL,
    location TEXT,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    facilities TEXT
);

CREATE TABLE Events (
    event_id SERIAL PRIMARY KEY,
    event_name TEXT NOT NULL,
    event_type TEXT NOT NULL,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    venue_id INTEGER NOT NULL REFERENCES Venues(venue_id),
    max_participants INTEGER NOT NULL DEFAULT 100
        CHECK (max_participants > 0),
    description TEXT,
    status TEXT NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_event_time CHECK (start_time < end_time)
);

CREATE TABLE Participants (
    participant_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    college TEXT,
    department TEXT,
    year_of_study INTEGER
        CHECK (year_of_study BETWEEN 1 AND 5),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Judges (
    judge_id SERIAL PRIMARY KEY,
    judge_name TEXT NOT NULL,
    expertise TEXT,
    email TEXT UNIQUE
);

CREATE TABLE Registrations (
    registration_id SERIAL PRIMARY KEY,
    participant_id INTEGER NOT NULL REFERENCES Participants(participant_id),
    event_id INTEGER NOT NULL REFERENCES Events(event_id),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attendance_status TEXT NOT NULL DEFAULT 'registered',
    UNIQUE(participant_id, event_id)
);

CREATE TABLE Performances (
    performance_id SERIAL PRIMARY KEY,
    registration_id INTEGER NOT NULL REFERENCES Registrations(registration_id),
    performance_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(registration_id)
);

CREATE TABLE Performance_Judges (
    id SERIAL PRIMARY KEY,
    performance_id INTEGER NOT NULL REFERENCES Performances(performance_id),
    judge_id INTEGER NOT NULL REFERENCES Judges(judge_id),
    score DECIMAL(5,2) NOT NULL
        CHECK (score BETWEEN 0 AND 100),
    comments TEXT,
    UNIQUE(performance_id, judge_id)
);

CREATE TABLE Awards (
    award_id SERIAL PRIMARY KEY,
    award_name TEXT NOT NULL,
    event_id INTEGER NOT NULL REFERENCES Events(event_id),
    position INTEGER NOT NULL
        CHECK (position > 0),
    prize_amount DECIMAL(10,2)
        CHECK (prize_amount IS NULL OR prize_amount >= 0),
    UNIQUE(event_id, position)
);

CREATE TABLE Award_Winners (
    winner_id SERIAL PRIMARY KEY,
    award_id INTEGER NOT NULL REFERENCES Awards(award_id),
    registration_id INTEGER NOT NULL REFERENCES Registrations(registration_id),
    won_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(award_id)
);

\echo 'Schema created successfully with TEXT types! No more casting needed.';
