# ResumeIQ — AI Resume Analyzer
### JSP + PostgreSQL + Eclipse + Tomcat 10 (Method B — No Servlet)

---

## 📁 Project Structure

```
ResumeIQ/
├── WebContent/
│   ├── index.jsp           ← Main analyzer page (loads roles from DB at server time)
│   ├── admin.jsp           ← Admin panel (add/delete roles via HTML forms + scriptlets)
│   ├── history.jsp         ← Analysis history with pagination & filter
│   ├── saveAnalysis.jsp    ← Called via fetch() POST to save analysis to DB
│   ├── getRoles.jsp        ← Returns JSON of all roles (optional AJAX refresh)
│   ├── css/
│   │   └── style.css       ← Full dark-theme stylesheet
│   ├── js/
│   │   └── app.js          ← Analysis engine + UI logic
│   └── WEB-INF/
│       ├── web.xml         ← Servlet config (welcome page only)
│       └── lib/
│           └── postgresql-42.x.x.jar   ← PUT PostgreSQL JDBC JAR HERE
├── database_setup.sql      ← Run this in pgAdmin/psql first
└── README.md               ← This file
```

---

## 🗄️ Step 1 — PostgreSQL Setup

### Install PostgreSQL
1. Download from **postgresql.org → Downloads**
2. Install and set a password for the `postgres` user — **remember this password!**
3. Open **pgAdmin** (included in installer)

### Create Database & Tables
1. Open pgAdmin → expand Servers → right-click **Databases** → **Create → Database**
2. Name it: `resumeiq_db` → Save
3. Right-click `resumeiq_db` → **Query Tool**
4. Open `database_setup.sql` from this project folder
5. Paste/open it in the Query Tool → press **F5** (or click ▶ Run)
6. Verify: you should see 18 roles listed

### Get JDBC Driver
1. Go to **jdbc.postgresql.org/download**
2. Download the latest `postgresql-XX.X.X.jar`
3. Place it inside `WebContent/WEB-INF/lib/`

---

## 🔧 Step 2 — Change DB Password in All JSP Files

Open each of these files and replace `your_postgres_password` with your actual PostgreSQL password:

- `WebContent/index.jsp`        — line ~9
- `WebContent/admin.jsp`        — line ~9
- `WebContent/history.jsp`      — line ~9
- `WebContent/saveAnalysis.jsp` — line ~9
- `WebContent/getRoles.jsp`     — line ~9

**All 5 files must have the correct password.**

---

## 🏗️ Step 3 — Eclipse Setup

### Prerequisites
- **Eclipse IDE for Enterprise Java and Web Developers** (not the standard Eclipse)
- **Java 17+** (JDK, not just JRE)
- **Apache Tomcat 10.1** — download from tomcat.apache.org

### Create Project
1. Open Eclipse → **File → New → Dynamic Web Project**
2. Project name: `ResumeIQ` (exact case!)
3. Target runtime: click **New Runtime…** → Apache Tomcat v10.1
   - Browse to where you extracted Tomcat
4. Click **Finish**

### Copy Project Files
Copy the `WebContent/` folder contents into your Eclipse project's `WebContent/` folder.

### Add JDBC JAR to Build Path
1. In **Project Explorer**, right-click the project → **Properties**
2. **Java Build Path → Libraries → Add JARs…**
3. Navigate to `WebContent/WEB-INF/lib/postgresql-XX.X.X.jar` → **OK**
4. Click **Apply and Close**

---

## 🚀 Step 4 — Run the Project

1. Make sure **PostgreSQL is running** (check Services on Windows or `pg_isready` on Linux)
2. Right-click project in Project Explorer → **Run As → Run on Server**
3. Select **Tomcat v10.1 Server at localhost** → **Finish**
4. Eclipse opens the app at: **http://localhost:8080/ResumeIQ/**

### Test the App
| URL | What it does |
|-----|-------------|
| `http://localhost:8080/ResumeIQ/` | Main analyzer |
| `http://localhost:8080/ResumeIQ/admin.jsp` | Admin panel |
| `http://localhost:8080/ResumeIQ/history.jsp` | History |
| `http://localhost:8080/ResumeIQ/getRoles.jsp` | JSON of all roles |

---

## 📋 Final Checklist

- [ ] PostgreSQL installed and running
- [ ] `resumeiq_db` database created
- [ ] SQL script executed — 18 roles seeded
- [ ] `postgresql-XX.jar` placed in `WebContent/WEB-INF/lib/`
- [ ] JAR added to Build Path in Eclipse
- [ ] Password changed in **all 5 JSP files**
- [ ] Dynamic Web Project named exactly `ResumeIQ`
- [ ] Tomcat 10.1 configured in Eclipse
- [ ] Project runs on Tomcat without console errors

---

## 🐞 Common Errors

| Error | Fix |
|-------|-----|
| `ClassNotFoundException: org.postgresql.Driver` | JAR not in WEB-INF/lib or not on Build Path |
| `Connection refused` / `FATAL: password authentication failed` | Wrong password in JSP files |
| `FATAL: database "resumeiq_db" does not exist` | Run database_setup.sql first |
| `404 Not Found` | Project name mismatch — must be exactly `ResumeIQ` |
| `Role dropdown empty` | Check browser console; likely a DB connection error |
| `javax.servlet` cannot be resolved | You need Tomcat **10** not Tomcat 9 |

---

## 💡 How Method B Works (No Servlet)

```
Browser loads index.jsp
  → JSP scriptlet <% %> runs Java code on SERVER
  → Queries PostgreSQL for all roles + skills
  → Builds JavaScript object string
  → Injects it into HTML: const rolesDB = {<%= rolesJSString %>}
  → Browser receives complete HTML with data embedded
  → app.js uses rolesDB for analysis (no extra HTTP calls needed)

Admin operations (add/delete):
  → HTML <form action="admin.jsp" method="post">
  → POST to admin.jsp
  → JSP scriptlet handles INSERT/DELETE via JDBC
  → Page re-renders with updated data

Save analysis:
  → After analysis in browser, JS calls fetch('saveAnalysis.jsp', {...})
  → saveAnalysis.jsp inserts into analysis_history table
  → Returns JSON {saved: true}
```

---

## 🎓 For Students

This is **Method B — Without Servlet**. Key points for your viva:
- Java code lives inside `<% %>` scriptlet tags in JSP files
- No separate `.java` files needed in `src/`
- DB connection uses JDBC directly in JSP
- Forms POST back to the same JSP (self-submitting pattern)
- `saveAnalysis.jsp` demonstrates JSP used as a lightweight endpoint

Built for: **B.Tech Final Year Project · JSP + JDBC + PostgreSQL**
