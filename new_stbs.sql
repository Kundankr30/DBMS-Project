--completed
-- Kundan (Event Management)
CREATE OR REPLACE FUNCTION add_event(p_name TEXT, p_type TEXT, p_date DATE, p_start TIME, p_end TIME, p_venue INTEGER, p_max INTEGER, p_desc TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_all_events() RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name FROM Events; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_event(p_id INTEGER, p_name TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION cancel_event(p_id INTEGER) RETURNS INTEGER AS $$ BEGIN UPDATE Events SET status = 'cancelled' WHERE event_id = p_id; RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION search_events_by_type(p_type TEXT) RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name FROM Events WHERE event_type = p_type; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION search_events_by_date(p_start DATE, p_end DATE) RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name FROM Events WHERE event_date BETWEEN p_start AND p_end; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_events_by_venue(p_venue INTEGER) RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name FROM Events WHERE venue_id = p_venue; END; $$ LANGUAGE plpgsql;

-- Shibani(Participant & Registration) - UPDATED TO SIC
CREATE OR REPLACE FUNCTION register_participant(p_sic TEXT, p_name TEXT, p_email TEXT, p_year INTEGER) RETURNS TEXT AS $$ BEGIN RETURN 'OK'; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_participants() RETURNS TABLE(sic TEXT, name TEXT, email TEXT) AS $$ BEGIN RETURN QUERY SELECT p.sic, p.name, p.email FROM Participants p; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_participant(p_sic TEXT, p_name TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION search_participant_by_email(p_email TEXT) RETURNS TABLE(sic TEXT, name TEXT) AS $$ BEGIN RETURN QUERY SELECT p.sic, p.name FROM Participants p WHERE email = p_email; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION delete_participant(p_sic TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION register_for_event(p_sic TEXT, p_eid INTEGER) RETURNS TEXT AS $$ BEGIN RETURN 'OK'; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_registrations() RETURNS TABLE(sic TEXT, p_name TEXT, e_name TEXT, status TEXT) AS $$ BEGIN RETURN QUERY SELECT r.sic, p.name, e.event_name, r.attendance_status FROM Registrations r JOIN Participants p ON r.sic = p.sic JOIN Events e ON r.event_id = e.event_id; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_registrations_by_event(p_eid INTEGER) RETURNS TABLE(sic TEXT, p_name TEXT, status TEXT) AS $$ BEGIN RETURN QUERY SELECT r.sic, p.name, r.attendance_status FROM Registrations r JOIN Participants p ON r.sic = p.sic WHERE r.event_id = p_eid; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION cancel_registration(p_sic TEXT, p_eid INTEGER) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION mark_attendance(p_sic TEXT, p_eid INTEGER, p_status TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION check_event_registration_count(p_eid INTEGER) RETURNS INTEGER AS $$ BEGIN RETURN 0; END; $$ LANGUAGE plpgsql;

-- Smruti Ranjan Nayak
CREATE OR REPLACE FUNCTION view_full_calendar() RETURNS TABLE(id INTEGER, name TEXT, date DATE) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name, event_date FROM Events; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_events_by_month(p_m INTEGER, p_y INTEGER) RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name FROM Events; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_upcoming_events() RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT event_id, event_name FROM Events WHERE event_date >= CURRENT_DATE; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION check_venue_availability(p_vid INTEGER, p_date DATE) RETURNS TEXT AS $$ BEGIN RETURN 'Available'; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION detect_schedule_conflicts() RETURNS TEXT AS $$ BEGIN RETURN 'No conflicts'; END; $$ LANGUAGE plpgsql;

-- Ashutosh Mohanty - UPDATED TO SIC
CREATE OR REPLACE FUNCTION create_performance(p_sic TEXT, p_eid INTEGER) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION assign_judge_score(p_pid INTEGER, p_jid INTEGER, p_score DECIMAL, p_comment TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_judge_score(p_id INTEGER, p_score DECIMAL) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_scores_by_performance(p_pid INTEGER) RETURNS TABLE(j_name TEXT, score DECIMAL) AS $$ BEGIN RETURN QUERY SELECT 'Judge'::TEXT, 0.0::DECIMAL; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_scores_by_event(p_eid INTEGER) RETURNS TABLE(sic TEXT, score DECIMAL) AS $$ BEGIN RETURN QUERY SELECT 'SIC'::TEXT, 0.0::DECIMAL; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION show_leaderboard(p_eid INTEGER) RETURNS TABLE(rank INTEGER, p_name TEXT, score DECIMAL) AS $$ BEGIN RETURN QUERY SELECT 1, 'Participant'::TEXT, 0.0::DECIMAL; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION performance_statistics(p_eid INTEGER) RETURNS TEXT AS $$ BEGIN RETURN 'Stats here'; END; $$ LANGUAGE plpgsql;

-- Deepakshi Nayak - UPDATED TO SIC
CREATE OR REPLACE FUNCTION create_award(p_eid INTEGER, p_name TEXT, p_pos INTEGER, p_amt DECIMAL) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_awards_by_event(p_eid INTEGER) RETURNS TABLE(id INTEGER, name TEXT) AS $$ BEGIN RETURN QUERY SELECT award_id, award_name FROM Awards WHERE event_id = p_eid; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION assign_award_winner(p_aid INTEGER, p_sic TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION view_award_winners() RETURNS TABLE(a_name TEXT, sic TEXT, p_name TEXT) AS $$ BEGIN RETURN QUERY SELECT a.award_name, p.sic, p.name FROM Award_Winners aw JOIN Awards a ON aw.award_id = a.award_id JOIN Participants p ON aw.sic = p.sic; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_award_details(p_id INTEGER, p_name TEXT) RETURNS INTEGER AS $$ BEGIN RETURN 1; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION generate_award_report(p_eid INTEGER) RETURNS TEXT AS $$ BEGIN RETURN 'Award Report'; END; $$ LANGUAGE plpgsql;

-- Reports
CREATE OR REPLACE FUNCTION event_participation_report() RETURNS TABLE(e_name TEXT, count INTEGER) AS $$ BEGIN RETURN QUERY SELECT 'Event'::TEXT, 0; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION registration_summary() RETURNS TABLE(total INTEGER, present INTEGER, absent INTEGER) AS $$ BEGIN RETURN QUERY SELECT 0,0,0; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION attendance_report() RETURNS TABLE(p_name TEXT, status TEXT) AS $$ BEGIN RETURN QUERY SELECT 'Participant'::TEXT, 'Registered'::TEXT; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION venue_utilization_report() RETURNS TABLE(v_name TEXT, utilization TEXT) AS $$ BEGIN RETURN QUERY SELECT 'Venue'::TEXT, '0%'::TEXT; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION top_performers_report() RETURNS TABLE(p_name TEXT, score DECIMAL) AS $$ BEGIN RETURN QUERY SELECT 'Top'::TEXT, 100.0::DECIMAL; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION event_statistics() RETURNS TABLE(e_name TEXT, avg_score DECIMAL) AS $$ BEGIN RETURN QUERY SELECT 'Event'::TEXT, 0.0::DECIMAL; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION participant_statistics() RETURNS TABLE(p_name TEXT, participation_count INTEGER) AS $$ BEGIN RETURN QUERY SELECT 'Participant'::TEXT, 0; END; $$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION awards_summary() RETURNS TABLE(a_name TEXT, winner_count INTEGER) AS $$ BEGIN RETURN QUERY SELECT 'Award'::TEXT, 0; END; $$ LANGUAGE plpgsql;

\echo 'Function stubs updated for SIC-based schema.';
