# Events Portal - Cultural
### DBMS Lab Project 2025-26 (Semester 4) - Group 2

An interactive, psql-based management system for organizing cultural events, managing venues, and tracking participant performances.

## 👤 Team Member (Kundan Kumar)
- **Name:** Kundan Kumar
- **Roll No:** 06
- **Responsibilities:** Database Design (DDL), Sample Data (DML), Venue Management Module, and Interactive Menu Navigation System.

---

## 🛠️ Project Structure
The project is modularized into the following SQL scripts:
- `01_create_schema.sql`: Table structures and relational constraints.
- `02_create_indexes.sql`: Performance optimization for frequent queries.
- `03_insert_sample_data.sql`: Realistic test data for demonstration.
- `04_menu_functions.sql`: Backend logic for the interactive menu system.
- `05_venue_management.sql`: Core procedures for managing cultural venues.
- `menu.sql`: The main interactive psql interface for users.
- `master.sql`: A utility script to initialize the entire system in one command.
- `stubs.sql`: Placeholder functions for integration with other team modules.

---

## 📊 Relational Schema
The database consists of 9 normalized tables:
1. **Venues**: Stores venue details (ID, Name, Location, Capacity).
2. **Events**: Cultural events (Dance, Music, etc.) and their schedules.
3. **Participants**: Student details and registration info.
4. **Judges**: Expert judges and their areas of expertise.
5. **Registrations**: Links participants to specific events.
6. **Performances**: Performance entries for registered participants.
7. **Performance_Judges**: Scoring and feedback from judges.
8. **Awards**: Award categories and prize amounts for events.
9. **Award_Winners**: Tracks winners for each award category.

---

## 🚀 How to Run

### Prerequisites
- PostgreSQL (psql) client installed.
- Access to a PostgreSQL database.

### 1. Initialize the System
Run the `master.sql` script to create the schema, indexes, functions, and sample data:
```bash
psql -d your_db_name -U your_username -f master.sql
```

### 2. Start the Interactive Menu
Launch the menu system to manage the portal:
```bash
psql -d your_db_name -U your_username -f menu.sql
```

---

## ✨ Features Implemented
- **Automated Validation:** Constraints ensure valid event times and positive venue capacities.
- **Manual Integrity Checks:** Custom functions prevent deletion of venues that have active scheduled events.
- **Efficient Searching:** Optimized indexes for date-based and venue-based event lookups.
- **Interactive UI:** A text-based menu system using PostgreSQL `\prompt` and `\echo` for a seamless user experience.
- **No Cascade Policy:** Strictly follows the requirement to avoid `ON DELETE CASCADE`, using manual logic to maintain data integrity.

---

## 📄 Final Submission
For lab submission, use the consolidated file: **`kundan_work_final.sql`**, which contains the full documented code for this project phase.
# DBMS-Project
