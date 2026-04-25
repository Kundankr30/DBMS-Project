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
    /*
     * recommend.jsp
     * ─────────────
     * Receives from results.jsp: role, score, matched, missing
     * Loads all OTHER roles from DB.
     * Counts overlap between the user's MATCHED skills and each other role's required skills.
     * Shows roles where user has at least some match — sorted by match %.
     */
    request.setCharacterEncoding("UTF-8");

    String currentRole = request.getParameter("role");
    String scoreStr    = request.getParameter("score");
    String matchedStr  = request.getParameter("matched");
    String missingStr  = request.getParameter("missing");

    if (currentRole == null || currentRole.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    int currentScore = 0;
    try { currentScore = Integer.parseInt(scoreStr); } catch (Exception e) {}

    /* Build set of skills the user HAS (from matched skills) */
    Set<String> userSkills = new HashSet<>();
    if (matchedStr != null && !matchedStr.trim().isEmpty()) {
        for (String s : matchedStr.split(",")) {
            if (!s.trim().isEmpty()) userSkills.add(s.trim().toLowerCase());
        }
    }

    /* Load all roles + skills from DB */
    Map<String, List<String>> allRoles = new LinkedHashMap<>();
    try (Connection conn = getConn()) {
        ResultSet rs = conn.createStatement().executeQuery(
            "SELECT r.role_name, s.skill_name " +
            "FROM roles r JOIN role_skills s ON r.id = s.role_id " +
            "ORDER BY r.role_name, s.skill_name");

        String cur = "";
        while (rs.next()) {
            String rname = rs.getString("role_name");
            String skill = rs.getString("skill_name");
            if (!allRoles.containsKey(rname)) allRoles.put(rname, new ArrayList<>());
            allRoles.get(rname).add(skill);
        }
    } catch (Exception e) { /* show empty */ }

    /* Score each OTHER role against user's matched skills */
    List<Object[]> scored = new ArrayList<>();
    /* Object[]: [roleName, matchPct, matchedCount, totalCount, List<String> reqSkills] */

    for (Map.Entry<String, List<String>> entry : allRoles.entrySet()) {
        String rname = entry.getKey();
        if (rname.equals(currentRole)) continue;   /* skip current role */

        List<String> req = entry.getValue();
        int hits = 0;
        for (String skill : req) {
            if (userSkills.contains(skill.toLowerCase())) hits++;
        }
        int pct = req.size() > 0 ? (hits * 100 / req.size()) : 0;
        scored.add(new Object[]{ rname, pct, hits, req.size(), req });
    }

    /* Sort by match % descending */
    scored.sort((a, b) -> (Integer)b[1] - (Integer)a[1]);

    /* Split: good matches (>=30%) and explore (< 30%) */
    List<Object[]> goodMatches = new ArrayList<>();
    List<Object[]> explore     = new ArrayList<>();
    for (Object[] row : scored) {
        if ((Integer)row[1] >= 30) goodMatches.add(row);
        else                        explore.add(row);
    }

    /* Emoji map */
    Map<String,String> em = new HashMap<>();
    em.put("Machine Learning Engineer","🤖"); em.put("Full Stack Developer","🌐");
    em.put("Data Analyst","📊"); em.put("DevOps Engineer","⚙️");
    em.put("Android Developer","📱"); em.put("Cybersecurity Analyst","🔒");
    em.put("Backend Developer","🖥️"); em.put("Frontend Developer","🎨");
    em.put("Data Scientist","🔬"); em.put("Cloud Architect","☁️");
    em.put("UI/UX Designer","✏️"); em.put("iOS Developer","🍎");
    em.put("Database Administrator","🗄️"); em.put("Blockchain Developer","⛓️");
    em.put("Embedded Systems Engineer","🔧"); em.put("Game Developer","🎮");
    em.put("Business Intelligence Analyst","📈"); em.put("QA Automation Engineer","🧪");

    /* Safe encode for URL params */
    String encMatched = java.net.URLEncoder.encode(matchedStr != null ? matchedStr : "", "UTF-8");
    String encMissing = java.net.URLEncoder.encode(missingStr != null ? missingStr : "", "UTF-8");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>More Roles — ResumeIQ</title>
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
      <a href="index.jsp" class="nav-pill">Analyzer</a>
    </div>
  </div>
</nav>

<div class="rec-wrap">

  <a href="index.jsp" class="back-link">← Back to Analyzer</a>

  <!-- Header -->
  <div class="rec-header">
    <h2>Other Roles You Might Fit</h2>
    <p>Based on the skills found in your resume, here is how you compare to other roles in our database.</p>
  </div>

  <!-- Current score strip -->
  <div class="score-strip">
    <div class="strip-score"><%= currentScore %>%</div>
    <div>
      <div class="strip-role"><%= currentRole %></div>
      <div class="strip-sub">Your current role score &nbsp;·&nbsp; <%= userSkills.size() %> skills found in your resume</div>
    </div>
  </div>

  <!-- Good matches -->
  <% if (!goodMatches.isEmpty()) { %>
  <div class="roles-section-title" style="font-size:0.78rem; font-weight:600; color:var(--text2); text-transform:uppercase; letter-spacing:1px; margin-bottom:14px; display:flex; align-items:center; gap:8px;">
    Roles Where You Already Have Skills
    <span style="flex:1; height:1px; background:var(--border); display:block;"></span>
  </div>

  <div class="rec-grid">
    <% for (Object[] row : goodMatches) {
         String rname = (String)row[0];
         int    pct   = (Integer)row[1];
         int    hits  = (Integer)row[2];
         int    tot   = (Integer)row[3];
         List<String> reqSkills = (List<String>)row[4];

         String matchClass = pct >= 60 ? "match-high" : pct >= 30 ? "match-medium" : "match-low";
         String icon = em.getOrDefault(rname, "💼");

         /* Show first 4 required skills */
         int show = Math.min(reqSkills.size(), 4);
    %>
    <a href="index.jsp" class="rec-card"
       onclick="pickAndGo('<%= rname.replace("'","\\'") %>'); return false;">
      <div class="rec-card-icon"><%= icon %></div>
      <div class="rec-card-name"><%= rname %></div>
      <div class="rec-card-match <%= matchClass %>"><%= pct %>% match &nbsp;·&nbsp; <%= hits %>/<%= tot %> skills</div>
      <div class="rec-card-skills">
        <% for (int i = 0; i < show; i++) { %>
          <span class="chip chip-amber" style="font-size:0.67rem;"><%= reqSkills.get(i) %></span>
        <% } %>
        <% if (reqSkills.size() > show) { %>
          <span class="chip chip-dim" style="font-size:0.67rem;">+<%= reqSkills.size()-show %></span>
        <% } %>
      </div>
    </a>
    <% } %>
  </div>
  <% } %>

  <!-- Explore more -->
  <% if (!explore.isEmpty()) { %>
  <div class="roles-section-title" style="font-size:0.78rem; font-weight:600; color:var(--text2); text-transform:uppercase; letter-spacing:1px; margin:28px 0 14px; display:flex; align-items:center; gap:8px;">
    Roles to Explore &amp; Grow Into
    <span style="flex:1; height:1px; background:var(--border); display:block;"></span>
  </div>

  <div class="rec-grid">
    <% for (Object[] row : explore) {
         String rname = (String)row[0];
         int    pct   = (Integer)row[1];
         int    hits  = (Integer)row[2];
         int    tot   = (Integer)row[3];
         List<String> reqSkills = (List<String>)row[4];
         String icon = em.getOrDefault(rname, "💼");
         int show = Math.min(reqSkills.size(), 3);
    %>
    <a href="index.jsp" class="rec-card"
       onclick="pickAndGo('<%= rname.replace("'","\\'") %>'); return false;"
       style="opacity:0.75;">
      <div class="rec-card-icon"><%= icon %></div>
      <div class="rec-card-name"><%= rname %></div>
      <div class="rec-card-match match-low"><%= pct %>% match &nbsp;·&nbsp; <%= hits %>/<%= tot %> skills</div>
      <div class="rec-card-skills">
        <% for (int i = 0; i < show; i++) { %>
          <span class="chip chip-dim" style="font-size:0.67rem;"><%= reqSkills.get(i) %></span>
        <% } %>
        <% if (reqSkills.size() > show) { %>
          <span class="chip chip-dim" style="font-size:0.67rem;">+<%= reqSkills.size()-show %></span>
        <% } %>
      </div>
    </a>
    <% } %>
  </div>
  <% } %>

  <!-- Try another role -->
  <div class="try-again-box" style="margin-top:32px;">
    <h3>Want to check a different role?</h3>
    <p>Go back to the analyzer, select any role, and paste your resume again.</p>
    <a href="index.jsp" class="btn-primary" style="display:inline-flex; width:auto; padding:12px 28px; text-decoration:none;">
      Go to Analyzer
    </a>
  </div>

</div>

<footer class="footer">
  <p>ResumeIQ &copy; 2024 &nbsp;&nbsp;·&nbsp;&nbsp; <a href="admin.jsp">Manage Roles</a></p>
</footer>

</div>

<script>
  /* Clicking a recommend card takes user to index.jsp and pre-selects that role */
  function pickAndGo(roleName) {
    sessionStorage.setItem('pickRole', roleName);
    window.location.href = 'index.jsp';
  }
</script>

</body>
</html>
