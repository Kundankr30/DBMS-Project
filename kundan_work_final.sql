-- ============================================================
-- DBMS Lab Project 2025-26 (Semester 4) - Group 2
-- Project Title: Events Portal - Cultural
-- Member: Kundan Kumar (Roll 6)
-- Responsibility: Database design, DDL, Sample Data,
--                 Venue Management & Menu Navigation
-- ============================================================

/*
RELATIONAL SCHEMA:
1. Venues (venue_id (PK), venue_name, location, capacity, facilities, created_at)
2. Events (event_id (PK), event_name, event_type, event_date, start_time, end_time,
           venue_id (FK), max_participants, description, status, created_at)
3. Participants (participant_id (PK), name, email, phone, year_of_study, registration_date)
4. Judges (judge_id (PK), judge_name, expertise, email)
5. Registrations (registration_id (PK), participant_id (FK), event_id (FK), registration_date, attendance_status)
6. Performances (performance_id (PK), registration_id (FK), performance_date)
7. Performance_Judges (id (PK), performance_id (FK), judge_id (FK), score, comments)
8. Awards (award_id (PK), award_name, event_id (FK), position, prize_amount)
9. Award_Winners (winner_id (PK), award_id (FK), registration_id (FK), won_date)
*/

\i 01_create_schema.sql
\i 02_create_indexes.sql
\i 03_insert_sample_data.sql
\i 05_venue_management.sql
\i 04_menu_functions.sql
\i 06_stubs.sql

\echo '------------------------------------------------------------'
\echo 'Kundan Kumar (Roll 6) - Modules loaded successfully!'
\echo 'Relational Schema and DDL are ready.'
\echo 'To start the menu, run: \i menu.sql'
\echo '------------------------------------------------------------'
