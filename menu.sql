\echo ''
\echo '============================================================'
\echo '              EVENTS PORTAL - CULTURAL'
\echo '============================================================'
\echo '  1. Venue Management'
\echo '  2. Event Management'
\echo '  3. Participant Management'
\echo '  4. Registration Management'
\echo '  5. Schedule & Calendar'
\echo '  6. Performance & Judging'
\echo '  7. Awards Management'
\echo '  8. Reports & Analytics'
\echo '  0. Exit'
\echo '============================================================'
\prompt 'Enter option: ' mainopt
SELECT
    CASE WHEN :'mainopt' = '1' THEN 'true' ELSE 'false' END AS mainopt_is_1,
    CASE WHEN :'mainopt' = '2' THEN 'true' ELSE 'false' END AS mainopt_is_2,
    CASE WHEN :'mainopt' = '3' THEN 'true' ELSE 'false' END AS mainopt_is_3,
    CASE WHEN :'mainopt' = '4' THEN 'true' ELSE 'false' END AS mainopt_is_4,
    CASE WHEN :'mainopt' = '5' THEN 'true' ELSE 'false' END AS mainopt_is_5,
    CASE WHEN :'mainopt' = '6' THEN 'true' ELSE 'false' END AS mainopt_is_6,
    CASE WHEN :'mainopt' = '7' THEN 'true' ELSE 'false' END AS mainopt_is_7,
    CASE WHEN :'mainopt' = '8' THEN 'true' ELSE 'false' END AS mainopt_is_8,
    CASE WHEN :'mainopt' = '0' THEN 'true' ELSE 'false' END AS mainopt_is_0
\gset
\if :mainopt_is_1
\echo ''
\echo '========== VENUE MANAGEMENT =========='
\echo '1. Add Venue'
\echo '2. View All Venues'
\echo '3. Update Venue'
\echo '4. Delete Venue'
\echo '5. Check Capacity'
\echo '0. Back'
\echo '====================================='
\prompt 'Enter choice: ' vopt
SELECT
    CASE WHEN :'vopt' = '1' THEN 'true' ELSE 'false' END AS vopt_is_1,
    CASE WHEN :'vopt' = '2' THEN 'true' ELSE 'false' END AS vopt_is_2,
    CASE WHEN :'vopt' = '3' THEN 'true' ELSE 'false' END AS vopt_is_3,
    CASE WHEN :'vopt' = '4' THEN 'true' ELSE 'false' END AS vopt_is_4,
    CASE WHEN :'vopt' = '5' THEN 'true' ELSE 'false' END AS vopt_is_5
\gset
\if :vopt_is_1
\prompt 'Name: ' name
\prompt 'Location: ' location
\prompt 'Capacity: ' capacity
\prompt 'Facilities: ' facilities
SELECT add_venue(:'name', :'location', CAST(:'capacity' AS INTEGER), :'facilities');
\endif
\if :vopt_is_2
SELECT * FROM view_venues();
\endif
\if :vopt_is_3
\prompt 'Venue ID to update: ' id
\prompt 'New Venue Name: ' name
SELECT update_venue(CAST(:'id' AS INTEGER), :'name');
\endif
\if :vopt_is_4
\prompt 'Venue ID to delete: ' id
SELECT delete_venue(CAST(:'id' AS INTEGER));
\endif
\if :vopt_is_5
\prompt 'Venue ID: ' id
SELECT * FROM check_venue_capacity(CAST(:'id' AS INTEGER));
\endif
\endif
\if :mainopt_is_2
\echo ''
\echo '========== EVENT MANAGEMENT =========='
\echo '1. Add Event'
\echo '2. View All Events'
\echo '3. Update Event'
\echo '4. Cancel Event'
\echo '5. Search by Type'
\echo '6. Search by Date'
\echo '7. View by Venue'
\echo '0. Back'
\echo '====================================='
\prompt 'Enter choice: ' eopt
SELECT
    CASE WHEN :'eopt' = '1' THEN 'true' ELSE 'false' END AS eopt_is_1,
    CASE WHEN :'eopt' = '2' THEN 'true' ELSE 'false' END AS eopt_is_2,
    CASE WHEN :'eopt' = '3' THEN 'true' ELSE 'false' END AS eopt_is_3,
    CASE WHEN :'eopt' = '4' THEN 'true' ELSE 'false' END AS eopt_is_4,
    CASE WHEN :'eopt' = '5' THEN 'true' ELSE 'false' END AS eopt_is_5,
    CASE WHEN :'eopt' = '6' THEN 'true' ELSE 'false' END AS eopt_is_6,
    CASE WHEN :'eopt' = '7' THEN 'true' ELSE 'false' END AS eopt_is_7
\gset
\if :eopt_is_1
\prompt 'Event Name: ' ename
\prompt 'Event Type: ' etype
\prompt 'Date (YYYY-MM-DD): ' edate
\prompt 'Start Time (HH:MM): ' estart
\prompt 'End Time (HH:MM): ' eend
\prompt 'Venue ID: ' evenue
\prompt 'Max Participants: ' emax
\prompt 'Description: ' edesc
SELECT add_event(:'ename', :'etype', CAST(:'edate' AS DATE), CAST(:'estart' AS TIME), CAST(:'eend' AS TIME), CAST(:'evenue' AS INTEGER), CAST(:'emax' AS INTEGER), :'edesc');
\endif
\if :eopt_is_2
SELECT * FROM view_all_events();
\endif
\if :eopt_is_3
\prompt 'Event ID to update: ' eid
\prompt 'New Event Name: ' ename
SELECT update_event(CAST(:'eid' AS INTEGER), :'ename');
\endif
\if :eopt_is_4
\prompt 'Event ID to cancel: ' eid
SELECT cancel_event(CAST(:'eid' AS INTEGER));
\endif
\if :eopt_is_5
\prompt 'Enter Event Type: ' etype
SELECT * FROM search_events_by_type(:'etype');
\endif
\if :eopt_is_6
\prompt 'Start Date (YYYY-MM-DD): ' sdate
\prompt 'End Date (YYYY-MM-DD): ' edate
SELECT * FROM search_events_by_date(CAST(:'sdate' AS DATE), CAST(:'edate' AS DATE));
\endif
\if :eopt_is_7
\prompt 'Venue ID: ' vid
SELECT * FROM view_events_by_venue(CAST(:'vid' AS INTEGER));
\endif
\endif
\if :mainopt_is_3
\echo ''
\echo '====== PARTICIPANT MANAGEMENT ======'
\echo '1. Register Participant'
\echo '2. View Participants'
\echo '3. Update Participant'
\echo '4. Search by Email'
\echo '5. Delete Participant'
\echo '0. Back'
\echo '==================================='
\prompt 'Enter choice: ' popt
SELECT
    CASE WHEN :'popt' = '1' THEN 'true' ELSE 'false' END AS popt_is_1,
    CASE WHEN :'popt' = '2' THEN 'true' ELSE 'false' END AS popt_is_2,
    CASE WHEN :'popt' = '3' THEN 'true' ELSE 'false' END AS popt_is_3,
    CASE WHEN :'popt' = '4' THEN 'true' ELSE 'false' END AS popt_is_4,
    CASE WHEN :'popt' = '5' THEN 'true' ELSE 'false' END AS popt_is_5
\gset
\if :popt_is_1
\prompt 'Name: ' pname
\prompt 'Email: ' pemail
\prompt 'Year (1-5): ' pyear
SELECT register_participant(:'pname', :'pemail', CAST(:'pyear' AS INTEGER));
\endif
\if :popt_is_2
SELECT * FROM view_participants();
\endif
\if :popt_is_3
\prompt 'Participant ID: ' pid
\prompt 'New Name: ' pname
SELECT update_participant(CAST(:'pid' AS INTEGER), :'pname');
\endif
\if :popt_is_4
\prompt 'Enter Email: ' pemail
SELECT * FROM search_participant_by_email(:'pemail');
\endif
\if :popt_is_5
\prompt 'Participant ID: ' pid
SELECT delete_participant(CAST(:'pid' AS INTEGER));
\endif
\endif
\if :mainopt_is_4
\echo ''
\echo '====== REGISTRATION MANAGEMENT ======'
\echo '1. Register for Event'
\echo '2. View Registrations'
\echo '3. View by Event'
\echo '4. Mark Attendance'
\echo '5. Cancel Registration'
\echo '6. Registration Count'
\echo '0. Back'
\echo '===================================='
\prompt 'Enter choice: ' ropt
SELECT
    CASE WHEN :'ropt' = '1' THEN 'true' ELSE 'false' END AS ropt_is_1,
    CASE WHEN :'ropt' = '2' THEN 'true' ELSE 'false' END AS ropt_is_2,
    CASE WHEN :'ropt' = '3' THEN 'true' ELSE 'false' END AS ropt_is_3,
    CASE WHEN :'ropt' = '4' THEN 'true' ELSE 'false' END AS ropt_is_4,
    CASE WHEN :'ropt' = '5' THEN 'true' ELSE 'false' END AS ropt_is_5,
    CASE WHEN :'ropt' = '6' THEN 'true' ELSE 'false' END AS ropt_is_6
\gset
\if :ropt_is_1
\prompt 'Participant ID: ' pid
\prompt 'Event ID: ' eid
SELECT register_for_event(CAST(:'pid' AS INTEGER), CAST(:'eid' AS INTEGER));
\endif
\if :ropt_is_2
SELECT * FROM view_registrations();
\endif
\if :ropt_is_3
\prompt 'Event ID: ' eid
SELECT * FROM view_registrations_by_event(CAST(:'eid' AS INTEGER));
\endif
\if :ropt_is_4
\prompt 'Registration ID: ' rid
\prompt 'Status (present/absent): ' rstatus
SELECT mark_attendance(CAST(:'rid' AS INTEGER), :'rstatus');
\endif
\if :ropt_is_5
\prompt 'Registration ID: ' rid
SELECT cancel_registration(CAST(:'rid' AS INTEGER));
\endif
\if :ropt_is_6
\prompt 'Event ID: ' eid
SELECT check_event_registration_count(CAST(:'eid' AS INTEGER));
\endif
\endif
\if :mainopt_is_5
\echo ''
\echo '====== SCHEDULE & CALENDAR ======'
\echo '1. Full Calendar'
\echo '2. Events by Month'
\echo '3. Upcoming Events'
\echo '4. Venue Availability'
\echo '5. Detect Conflicts'
\echo '0. Back'
\echo '================================'
\prompt 'Enter choice: ' sopt
SELECT
    CASE WHEN :'sopt' = '1' THEN 'true' ELSE 'false' END AS sopt_is_1,
    CASE WHEN :'sopt' = '2' THEN 'true' ELSE 'false' END AS sopt_is_2,
    CASE WHEN :'sopt' = '3' THEN 'true' ELSE 'false' END AS sopt_is_3,
    CASE WHEN :'sopt' = '4' THEN 'true' ELSE 'false' END AS sopt_is_4,
    CASE WHEN :'sopt' = '5' THEN 'true' ELSE 'false' END AS sopt_is_5
\gset
\if :sopt_is_1
SELECT * FROM view_full_calendar();
\endif
\if :sopt_is_2
\prompt 'Month (1-12): ' smonth
\prompt 'Year (YYYY): ' syear
SELECT * FROM view_events_by_month(CAST(:'smonth' AS INTEGER), CAST(:'syear' AS INTEGER));
\endif
\if :sopt_is_3
SELECT * FROM view_upcoming_events();
\endif
\if :sopt_is_4
\prompt 'Venue ID: ' vid
\prompt 'Date (YYYY-MM-DD): ' sdate
SELECT check_venue_availability(CAST(:'vid' AS INTEGER), CAST(:'sdate' AS DATE));
\endif
\if :sopt_is_5
SELECT detect_schedule_conflicts();
\endif
\endif
\if :mainopt_is_6
\echo ''
\echo '====== PERFORMANCE ======'
\echo '1. Create Performance'
\echo '2. Assign Score'
\echo '3. Update Score'
\echo '4. View Scores'
\echo '5. Leaderboard'
\echo '6. Statistics'
\echo '0. Back'
\prompt 'Enter choice: ' pfopt
SELECT
    CASE WHEN :'pfopt' = '1' THEN 'true' ELSE 'false' END AS pfopt_is_1,
    CASE WHEN :'pfopt' = '2' THEN 'true' ELSE 'false' END AS pfopt_is_2,
    CASE WHEN :'pfopt' = '3' THEN 'true' ELSE 'false' END AS pfopt_is_3,
    CASE WHEN :'pfopt' = '4' THEN 'true' ELSE 'false' END AS pfopt_is_4,
    CASE WHEN :'pfopt' = '5' THEN 'true' ELSE 'false' END AS pfopt_is_5,
    CASE WHEN :'pfopt' = '6' THEN 'true' ELSE 'false' END AS pfopt_is_6
\gset
\if :pfopt_is_1
\prompt 'Registration ID: ' rid
SELECT create_performance(CAST(:'rid' AS INTEGER));
\endif
\if :pfopt_is_2
\prompt 'Performance ID: ' pid
\prompt 'Judge ID: ' jid
\prompt 'Score (0-100): ' pscore
\prompt 'Comment: ' pcomment
SELECT assign_judge_score(CAST(:'pid' AS INTEGER), CAST(:'jid' AS INTEGER), CAST(:'pscore' AS DECIMAL), :'pcomment');
\endif
\if :pfopt_is_3
\prompt 'Score ID (Performance_Judge ID): ' pjid
\prompt 'New Score: ' pscore
SELECT update_judge_score(CAST(:'pjid' AS INTEGER), CAST(:'pscore' AS DECIMAL));
\endif
\if :pfopt_is_4
\prompt 'Event ID: ' eid
SELECT * FROM view_scores_by_event(CAST(:'eid' AS INTEGER));
\endif
\if :pfopt_is_5
\prompt 'Event ID: ' eid
SELECT * FROM show_leaderboard(CAST(:'eid' AS INTEGER));
\endif
\if :pfopt_is_6
\prompt 'Event ID: ' eid
SELECT performance_statistics(CAST(:'eid' AS INTEGER));
\endif
\endif
\if :mainopt_is_7
\echo ''
\echo '====== AWARDS ======'
\echo '1. Create Award'
\echo '2. View Awards'
\echo '3. Assign Winner'
\echo '4. Update Award'
\echo '5. Report'
\echo '0. Back'
\prompt 'Enter choice: ' aopt
SELECT
    CASE WHEN :'aopt' = '1' THEN 'true' ELSE 'false' END AS aopt_is_1,
    CASE WHEN :'aopt' = '2' THEN 'true' ELSE 'false' END AS aopt_is_2,
    CASE WHEN :'aopt' = '3' THEN 'true' ELSE 'false' END AS aopt_is_3,
    CASE WHEN :'aopt' = '4' THEN 'true' ELSE 'false' END AS aopt_is_4,
    CASE WHEN :'aopt' = '5' THEN 'true' ELSE 'false' END AS aopt_is_5
\gset
\if :aopt_is_1
\prompt 'Event ID: ' eid
\prompt 'Award Name: ' aname
\prompt 'Position: ' apos
\prompt 'Prize Amount: ' aamt
SELECT create_award(CAST(:'eid' AS INTEGER), :'aname', CAST(:'apos' AS INTEGER), CAST(:'aamt' AS DECIMAL));
\endif
\if :aopt_is_2
\prompt 'Event ID: ' eid
SELECT * FROM view_awards_by_event(CAST(:'eid' AS INTEGER));
\endif
\if :aopt_is_3
\prompt 'Award ID: ' aid
\prompt 'Registration ID: ' rid
SELECT assign_award_winner(CAST(:'aid' AS INTEGER), CAST(:'rid' AS INTEGER));
\endif
\if :aopt_is_4
\prompt 'Award ID: ' aid
\prompt 'New Name: ' aname
SELECT update_award_details(CAST(:'aid' AS INTEGER), :'aname');
\endif
\if :aopt_is_5
\prompt 'Event ID: ' eid
SELECT generate_award_report(CAST(:'eid' AS INTEGER));
\endif
\endif
\if :mainopt_is_8
\echo ''
\echo '====== REPORTS ======'
\echo '1. Participation Report'
\echo '2. Registration Summary'
\echo '3. Attendance Report'
\echo '4. Venue Utilization Report'
\echo '5. Top Performers Report'
\echo '6. Event Statistics'
\echo '7. Participant Statistics'
\echo '8. Awards Summary'
\echo '0. Back'
\prompt 'Enter choice: ' rptopt
SELECT
    CASE WHEN :'rptopt' = '1' THEN 'true' ELSE 'false' END AS rptopt_is_1,
    CASE WHEN :'rptopt' = '2' THEN 'true' ELSE 'false' END AS rptopt_is_2,
    CASE WHEN :'rptopt' = '3' THEN 'true' ELSE 'false' END AS rptopt_is_3,
    CASE WHEN :'rptopt' = '4' THEN 'true' ELSE 'false' END AS rptopt_is_4,
    CASE WHEN :'rptopt' = '5' THEN 'true' ELSE 'false' END AS rptopt_is_5,
    CASE WHEN :'rptopt' = '6' THEN 'true' ELSE 'false' END AS rptopt_is_6,
    CASE WHEN :'rptopt' = '7' THEN 'true' ELSE 'false' END AS rptopt_is_7,
    CASE WHEN :'rptopt' = '8' THEN 'true' ELSE 'false' END AS rptopt_is_8
\gset
\if :rptopt_is_1
SELECT * FROM event_participation_report();
\endif
\if :rptopt_is_2
SELECT * FROM registration_summary();
\endif
\if :rptopt_is_3
SELECT * FROM attendance_report();
\endif
\if :rptopt_is_4
SELECT * FROM venue_utilization_report();
\endif
\if :rptopt_is_5
SELECT * FROM top_performers_report();
\endif
\if :rptopt_is_6
SELECT * FROM event_statistics();
\endif
\if :rptopt_is_7
SELECT * FROM participant_statistics();
\endif
\if :rptopt_is_8
SELECT * FROM awards_summary();
\endif
\endif
\if :mainopt_is_0
\echo 'Thank you for using Events Portal - Cultural.'
\endif
