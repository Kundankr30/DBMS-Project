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

## 🚀 How to Run

### 1. Connect and Initialize
Run this command to connect to the database and initialize all tables, data, and functions:
```bash
psql "postgresql://postgres.lokciwccurorpeolozez:dbmsgroup2%40123@aws-1-ap-south-1.pooler.supabase.com:6543/postgres" -f master.sql
```

### 2. Start the Interactive Menu
Once the tables are created, launch the menu system to interact with the database:
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
