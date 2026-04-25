<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%!
    static final String DB_URL  = "jdbc:postgresql://localhost:5432/resumeiq_db";
    static final String DB_USER = "postgres";
    static final String DB_PASS = "ashu5568";

    Connection getConn() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
%>
<%
    /* Load roles + skills from DB */
    StringBuilder rolesJS = new StringBuilder("{");
    int totalRoles = 0;
    boolean fr = true;

    try (Connection conn = getConn()) {
        ResultSet rs = conn.createStatement().executeQuery(
            "SELECT r.role_name, s.skill_name " +
            "FROM roles r JOIN role_skills s ON r.id = s.role_id " +
            "ORDER BY r.role_name, s.skill_name");

        String cur = ""; boolean fs = true;
        while (rs.next()) {
            String role = rs.getString("role_name");
            String skill = rs.getString("skill_name");
            if (!role.equals(cur)) {
                if (!cur.isEmpty()) rolesJS.append("]");
                if (!fr) rolesJS.append(",");
                rolesJS.append("\"").append(role.replace("\"","\\\"")).append("\":[");
                cur = role; fr = false; fs = true; totalRoles++;
            }
            if (!fs) rolesJS.append(",");
            rolesJS.append("\"").append(skill.replace("\"","\\\"")).append("\"");
            fs = false;
        }
        if (!cur.isEmpty()) rolesJS.append("]");
    } catch (Exception e) {
        rolesJS = new StringBuilder("{}");
    }
    rolesJS.append("}");

    /* Rotating home quotes */
    String[] homeQuotes = {
        "Your career does not begin at the interview. It begins with your resume.",
        "A resume is not a history lesson — it is a sales pitch.",
        "The right skills in the right role is not luck. It is preparation.",
        "Know where you stand before you take the next step.",
        "Every missing skill is just a course away from being matched."
    };
    String hq = homeQuotes[(int)((System.currentTimeMillis()/120000) % homeQuotes.length)];
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ResumeIQ — Know Your Resume Score</title>
  <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
<div class="page">

<!-- NAV -->
<nav class="navbar">
  <div class="nav-inner">
    <a href="index.jsp" class="logo">
      <div class="logo-mark">IQ</div>
      <span class="logo-text">Resume<em>IQ</em></span>
    </a>
    <div class="nav-right">
      <a href="index.jsp" class="nav-pill active">Analyzer</a>
    </div>
  </div>
</nav>

<!-- HOME BODY -->
<div class="home-wrap">

  <!-- Banner -->
  <div class="banner">
    <div class="banner-tag">Resume Skill Matcher</div>
    <h1>See How Well Your Resume<br/>Fits a <span>Job Role</span></h1>
    <p class="banner-sub">
      Pick the role you are targeting, paste your resume, and get an honest
      match score along with what skills you are missing.
    </p>
    <div class="home-quote"><%= hq %></div>
  </div>

  <!-- Analyzer Card -->
  <div class="form-card">
    <div class="form-card-title">Analyze Your Resume</div>
    <div class="form-card-sub">Both fields are required</div>

    <div id="alertBox"></div>

    <div class="field">
      <label for="roleSelect">Target Job Role</label>
      <select id="roleSelect" onchange="onRolePick(this.value)">
        <option value="">— Select a role —</option>
      </select>
    </div>

    <div class="field">
      <label>Skills Required for This Role</label>
      <div class="skills-row" id="skillsRow">
        <span class="ph">Select a role above to see required skills</span>
      </div>
    </div>

    <div class="form-divider"></div>

    <div class="field">
      <label for="resumeInput">Your Resume Text</label>
      <textarea id="resumeInput"
        placeholder="Paste your resume content here — summary, skills, experience, projects...

Example:
Python developer, 2 years experience.
Skills: Python, TensorFlow, Pandas, NumPy, SQL, Scikit-learn.
Projects include NLP chatbot using PyTorch and data dashboards with Matplotlib..."></textarea>
    </div>

    <button class="analyze-btn" id="analyzeBtn" onclick="doAnalyze()">
      Analyze My Resume
    </button>
  </div>

  <!-- Role Cards -->
  <div class="roles-section">
    <div class="roles-section-title">Available Roles</div>
    <div class="roles-grid" id="rolesGrid"></div>
  </div>

</div><!-- end home-wrap -->

<footer class="footer">
  <p>ResumeIQ &copy; 2024 &nbsp;&nbsp;·&nbsp;&nbsp; <a href="admin.jsp">Manage Roles</a></p>
</footer>

</div><!-- end page -->

<!-- Hidden form that submits to results.jsp -->
<form id="resultForm" action="results.jsp" method="post" style="display:none;">
  <input type="hidden" id="f_role"    name="role"/>
  <input type="hidden" id="f_score"   name="score"/>
  <input type="hidden" id="f_matched" name="matched"/>
  <input type="hidden" id="f_missing" name="missing"/>
  <input type="hidden" id="f_snippet" name="snippet"/>
</form>

<script src="js/app.js"></script>
<script>
  const rolesDB = <%= rolesJS %>;
  document.addEventListener('DOMContentLoaded', initHome);
</script>
</body>
</html>
