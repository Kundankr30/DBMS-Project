# Events Portal - Cultural
### DBMS Lab Project 2025-26 (Semester 4) - Group 2

An interactive, psql-based management system for organizing cultural events, managing venues, and tracking participant performances.

---

## 🛠️ Project Structure
The project is modularized into the following SQL scripts:
- `01_create_schema.sql`: Table structures and relational constraints.
- `02_create_indexes.sql`: Performance optimization.
- `03_insert_sample_data.sql`: Realistic test data for demonstration.
- `04_menu_functions.sql`: Backend logic for the menu system.
- `05_venue_management.sql`: Procedures for managing cultural venues.
- `06_stubs.sql`: Integration placeholders for all project functions.
- `menu.sql`: The main interactive psql interface.
- `master.sql`: Utility script to initialize the entire system.

---

## 📊 Relational Schema
1. **Venues**: ID, Name, Location, Capacity.
2. **Events**: Cultural events and schedules.
3. **Participants**: Student and registration info.
4. **Judges**: Expert judges and expertise.
5. **Registrations**: Participant-Event links.
6. **Performances**: Performance entries.
7. **Performance_Judges**: Scoring and feedback.
8. **Awards**: Categories and prize amounts.
9. **Award_Winners**: Winners for each award.

---

## 📜 Functions & Procedures

### 1. Venue Management
- `add_venue(name, location, cap, fac)`: Register a new venue.
- `view_venues()`: List all available venues.
- `update_venue(id, name, loc, cap, fac)`: Modify venue details.
- `delete_venue(id)`: Safely remove a venue (checks for active events).
- `check_venue_capacity(id)`: Analyze venue utilization and capacity.
- `search_venues_by_name(pattern)`: Search for venues using text patterns.

### 2. Event Management
- `add_event(...)`: Create a new cultural event.
- `view_all_events()`: List all events.
- `update_event(id, ...)`: Update event details.
- `cancel_event(id)`: Mark an event as cancelled.
- `search_events_by_type(type)`: Filter events by category (dance, music, etc.).
- `search_events_by_date(start, end)`: Find events within a date range.
- `view_events_by_venue(vid)`: List all events scheduled at a specific venue.

### 3. Participant & Registration
- `register_participant(...)`: Add a new participant.
- `view_participants()`: View all student profiles.
- `register_for_event(pid, eid)`: Link a participant to an event.
- `view_registrations()`: Show all event sign-ups.
- `mark_attendance(rid, status)`: Update participant attendance (Present/Absent).
- `check_event_registration_count(eid)`: Monitor event popularity.

### 4. Performance & Awards
- `create_performance(rid)`: Create a performance entry for a participant.
- `assign_judge_score(pid, jid, score, comment)`: Record judge evaluations.
- `show_leaderboard(eid)`: Calculate rankings for a specific event.
- `create_award(...)`: Setup award categories for an event.
- `assign_award_winner(aid, rid)`: Officially link a winner to an award.
- `view_award_winners()`: Show the list of all winners across categories.

### 5. Reports & Analytics
- `event_participation_report()`: Summary of participants per event.
- `registration_summary()`: Statistics on total sign-ups and attendance.
- `venue_utilization_report()`: Efficiency analysis of all venues.
- `top_performers_report()`: List of highest-scoring participants.
- `awards_summary()`: Overview of all distributed prizes and awards.

---

## 🚀 How to Run

### 1. Connect and Initialize
Run this command to connect to the database and initialize all tables, data, and functions:
```bash
psql "postgresql://postgres.lokciwccurorpeolozez:dbmsgroup2%40123@aws-1-ap-south-1.pooler.supabase.com:6543/postgres" -f master.sql
```

### 2. Start the Interactive Menu
Once the tables are created, launch the menu system:
```bash
psql "postgresql://postgres.lokciwccurorpeolozez:dbmsgroup2%40123@aws-1-ap-south-1.pooler.supabase.com:6543/postgres" -f menu.sql
```

---

## ✨ Features Implemented
- **Automated Validation:** Constraints ensure valid event times and positive venue capacities.
- **Manual Integrity Checks:** Custom functions prevent deletion of venues that have active scheduled events.
- **Efficient Searching:** Optimized indexes for date-based and venue-based lookups.
- **Interactive UI:** Text-based menu system using `\prompt` and `\echo`.
- **No Cascade Policy:** Follows requirements to avoid `ON DELETE CASCADE` using manual data integrity logic.
