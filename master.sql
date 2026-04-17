-- Master script for Events Portal - Cultural
-- Project Lead / Database Designer: Kundan Kumar (Roll 6)

-- 1. Setup Schema
\i 01_create_schema.sql

-- 2. Create Indexes
\i 02_create_indexes.sql

-- 3. Insert Sample Data
\i 03_insert_sample_data.sql

-- 4. Load Venue Management Functions
\i 05_venue_management.sql

-- 5. Load Menu Navigation Functions
\i 04_menu_functions.sql

-- 6. Load Stubs for other team members (for testing)
\i stubs.sql

\echo '------------------------------------------------------------'
\echo 'All modules loaded successfully!'
\echo 'Run \i menu.sql to start the interactive menu system.'
\echo '------------------------------------------------------------'
