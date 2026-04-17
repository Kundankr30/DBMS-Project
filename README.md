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

### 2. Event Management
- `add_event(...)`, `view_all_events()`, `cancel_event(id)`.

### 3. Participant & Registration
- `register_participant(...)`, `register_for_event(pid, eid)`, `mark_attendance(rid, status)`.

### 4. Performance & Awards
- `create_performance(rid)`, `assign_judge_score(...)`, `show_leaderboard(eid)`.

---

## 🚀 How to Run (Direct Command)

### 1. Connect and Initialize
```bash
psql "postgresql://postgres.lokciwccurorpeolozez:dbmsgroup2%40123@aws-1-ap-south-1.pooler.supabase.com:6543/postgres" -f master.sql
```

### 2. Start the Interactive Menu
```bash
psql "postgresql://postgres.lokciwccurorpeolozez:dbmsgroup2%40123@aws-1-ap-south-1.pooler.supabase.com:6543/postgres" -f menu.sql
```

---

## 📖 Full Testing Tutorial (Inside psql)

If you are already inside the `psql` console, follow these steps for a complete test:

### Step 1: Initialize the Database
Load the master script to set up all tables and functions:
```sql
\i master.sql
```

### Step 2: Launch the Menu
Start the interactive portal:
```sql
\i menu.sql
```

### Step 3: Test Venue Management
1.  When prompted `Enter option:`, type **`1`** and press Enter.
2.  You are now in the **Venue Management** submenu.
3.  Type **`2`** to **View All Venues**. You should see the sample data (e.g., Main Auditorium).
4.  Type **`1`** to **Add Venue**. Follow the prompts:
    *   `Name:` Music Hall
    *   `Location:` Block B
    *   `Capacity:` 150
    *   `Facilities:` AC, Sound System
5.  Type **`5`** to **Check Capacity**. Enter the ID of the venue you just created to see its status.
6.  Type **`0`** to return to the **Main Menu**.

### Step 4: Test Integration (Stubs)
1.  From the Main Menu, type **`2`** for **Event Management**.
2.  Type **`2`** to **View All Events**.
3.  *Note:* This calls a stub function to demonstrate that the menu navigation logic is correctly linked.

### Step 5: Exit the System
1.  Type **`0`** in the Main Menu.
2.  The system will display: `Thank you for using Events Portal - Cultural.`

---

## ✨ Features Implemented
- **Automated Validation:** Constraints ensure valid event times and positive venue capacities.
- **Manual Integrity Checks:** Custom functions prevent deletion of venues with active scheduled events.
- **Interactive UI:** Text-based menu system using `\prompt` and `\echo`.
- **No Cascade Policy:** Strictly avoids `ON DELETE CASCADE` per requirements.
