-- Events Portal - Cultural
-- DBMS Lab Project 2025-26 (Semester 4) - Group 2
-- Roll 6: Kundan Kumar - Menu Navigation System
-- This file creates functions to display menus and handle navigation

-- Function to reset menu selection
CREATE OR REPLACE FUNCTION reset_menu() RETURNS VOID AS $$
BEGIN
    -- This function resets any menu state variables
    -- Used before displaying menus
    PERFORM pg_sleep(0);
END;
$$ LANGUAGE plpgsql;

-- Function to show main menu (returns text description)
CREATE OR REPLACE FUNCTION show_main_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n====================================\n';
    menu_text := menu_text || E'EVENTS PORTAL - CULTURAL\n';
    menu_text := menu_text || E'====================================\n';
    menu_text := menu_text || E'1. Venue Management\n';
    menu_text := menu_text || E'2. Event Management\n';
    menu_text := menu_text || E'3. Participant Management\n';
    menu_text := menu_text || E'4. Registration Management\n';
    menu_text := menu_text || E'5. Schedule \u0026 Calendar\n';
    menu_text := menu_text || E'6. Performance \u0026 Judging\n';
    menu_text := menu_text || E'7. Awards Management\n';
    menu_text := menu_text || E'8. Reports \u0026 Analytics\n';
    menu_text := menu_text || E'0. Exit\n';
    menu_text := menu_text || E'====================================';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show venue management submenu
CREATE OR REPLACE FUNCTION show_venue_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Venue Management ---\n';
    menu_text := menu_text || E'1. Add Venue\n';
    menu_text := menu_text || E'2. View All Venues\n';
    menu_text := menu_text || E'3. Update Venue Details\n';
    menu_text := menu_text || E'4. Delete Venue\n';
    menu_text := menu_text || E'5. Check Venue Capacity\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show event management submenu
CREATE OR REPLACE FUNCTION show_event_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Event Management ---\n';
    menu_text := menu_text || E'1. Add New Event\n';
    menu_text := menu_text || E'2. View All Events\n';
    menu_text := menu_text || E'3. Update Event Details\n';
    menu_text := menu_text || E'4. Cancel Event\n';
    menu_text := menu_text || E'5. Search Events by Type\n';
    menu_text := menu_text || E'6. Search Events by Date\n';
    menu_text := menu_text || E'7. View Events by Venue\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show participant management submenu
CREATE OR REPLACE FUNCTION show_participant_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Participant Management ---\n';
    menu_text := menu_text || E'1. Register New Participant\n';
    menu_text := menu_text || E'2. View All Participants\n';
    menu_text := menu_text || E'3. Update Participant Details\n';
    menu_text := menu_text || E'4. Search Participant by Email\n';
    menu_text := menu_text || E'5. Delete Participant\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'------------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show registration management submenu
CREATE OR REPLACE FUNCTION show_registration_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Registration Management ---\n';
    menu_text := menu_text || E'1. Register Participant for Event\n';
    menu_text := menu_text || E'2. View All Registrations\n';
    menu_text := menu_text || E'3. View Registrations by Event\n';
    menu_text := menu_text || E'4. Mark Attendance\n';
    menu_text := menu_text || E'5. Cancel Registration\n';
    menu_text := menu_text || E'6. Check Event Registration Count\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'-------------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show schedule and calendar submenu
CREATE OR REPLACE FUNCTION show_schedule_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Schedule \u0026 Calendar ---\n';
    menu_text := menu_text || E'1. View Full Event Calendar\n';
    menu_text := menu_text || E'2. View Events by Month\n';
    menu_text := menu_text || E'3. View Today/Upcoming Events\n';
    menu_text := menu_text || E'4. Check Venue Availability\n';
    menu_text := menu_text || E'5. Detect Schedule Conflicts\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'---------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show performance and judging submenu
CREATE OR REPLACE FUNCTION show_performance_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Performance \u0026 Judging ---\n';
    menu_text := menu_text || E'1. Create Performance Entry\n';
    menu_text := menu_text || E'2. Assign Judge Score\n';
    menu_text := menu_text || E'3. Update Judge Score\n';
    menu_text := menu_text || E'4. View Scores by Performance\n';
    menu_text := menu_text || E'5. View Scores by Event\n';
    menu_text := menu_text || E'6. Show Leaderboard\n';
    menu_text := menu_text || E'7. Performance Statistics\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'------------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show awards management submenu
CREATE OR REPLACE FUNCTION show_awards_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Awards Management ---\n';
    menu_text := menu_text || E'1. Create Award\n';
    menu_text := menu_text || E'2. View Awards by Event\n';
    menu_text := menu_text || E'3. Assign Award Winner\n';
    menu_text := menu_text || E'4. View Award Winners\n';
    menu_text := menu_text || E'5. Update Award Details\n';
    menu_text := menu_text || E'6. Generate Award Report\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to show reports and analytics submenu
CREATE OR REPLACE FUNCTION show_reports_menu() RETURNS TEXT AS $$
DECLARE
    menu_text TEXT;
BEGIN
    menu_text := E'\n--- Reports \u0026 Analytics ---\n';
    menu_text := menu_text || E'1. Event Participation Report\n';
    menu_text := menu_text || E'2. Registration Summary\n';
    menu_text := menu_text || E'3. Attendance Report\n';
    menu_text := menu_text || E'4. Venue Utilization Report\n';
    menu_text := menu_text || E'5. Top Performers Report\n';
    menu_text := menu_text || E'6. Event Statistics\n';
    menu_text := menu_text || E'7. Participant Statistics\n';
    menu_text := menu_text || E'8. Awards Summary\n';
    menu_text := menu_text || E'0. Back to Main Menu\n';
    menu_text := menu_text || E'--------------------------';
    RETURN menu_text;
END;
$$ LANGUAGE plpgsql;

-- Function to navigate menu based on option
CREATE OR REPLACE FUNCTION navigate_menu(p_main_option INTEGER, p_sub_option INTEGER)
RETURNS TEXT AS $$
DECLARE
    result TEXT;
BEGIN
    CASE p_main_option
        WHEN 1 THEN -- Venue Management
            CASE p_sub_option
                WHEN 1 THEN result := 'Call add_venue procedure';
                WHEN 2 THEN result := 'Call view_venues function';
                WHEN 3 THEN result := 'Call update_venue procedure';
                WHEN 4 THEN result := 'Call delete_venue procedure';
                WHEN 5 THEN result := 'Call check_venue_capacity function';
                ELSE result := 'Invalid option';
            END CASE;
        WHEN 2 THEN -- Event Management
            result := 'Event management functions (Roll 10: Shibani)';
        WHEN 3 THEN -- Participant Management
            result := 'Participant management functions (Roll 14: Ashutosh)';
        WHEN 4 THEN -- Registration Management
            result := 'Registration management functions (Roll 14: Ashutosh)';
        WHEN 5 THEN -- Schedule \u0026 Calendar
            result := 'Schedule functions (Roll 16: Smruti)';
        WHEN 6 THEN -- Performance \u0026 Judging
            result := 'Performance functions (Roll 16: Smruti)';
        WHEN 7 THEN -- Awards Management
            result := 'Awards functions (Roll 16: Smruti)';
        WHEN 8 THEN -- Reports \u0026 Analytics
            result := 'Report functions (Roll 25: Deepakshi)';
        ELSE
            result := 'Invalid main menu option';
    END CASE;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

\echo 'Menu navigation functions created successfully!';
