-- Master script to load all modules in order
\set ON_ERROR_STOP on
BEGIN;

\i 01_create_schema.sql
\i 02_create_indexes.sql

-- Load all management procedures
\i 05_venue_management.sql
\i event_management_procedure.sql
\i participant_management_procedure.sql
\i registration_management_procedure.sql
\i performance_judging.sql
\i awards_management.sql
\i schedule_calendar.sql
\i report.sql
\i Triggers.sql

-- Load sample data
\i 03_insert_sample_data.sql

COMMIT;

\echo '------------------------------------------------------------'
\echo '       CULTURAL EVENT MANAGEMENT SYSTEM LOADED'
\echo '------------------------------------------------------------'
\echo 'All modules and sample data loaded successfully!'
\echo 'Run \i menu.sql to start the interactive menu system.'
\echo '------------------------------------------------------------'
