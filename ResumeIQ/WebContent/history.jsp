<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    int pageSize = 10, pageNum = 1;
    try { pageNum = Integer.parseInt(request.getParameter("page")); } catch(Exception e) {}
    if (pageNum < 1) pageNum = 1;
    int offset = (pageNum - 1) * pageSize;

    String filterRole = request.getParameter("filterRole");
    if (filterRole != null && filterRole.trim().isEmpty()) filterRole = null;

    List<Map<String,String>> records = new ArrayList<>();
    List<String> roleList = new ArrayList<>();
    int totalCount = 0;
    String dbErr = "";

    try (Connection conn = getConn()) {
        ResultSet rr = conn.createStatement().executeQuery(
            "SELECT DISTINCT role_name FROM analysis_history ORDER BY role_name");
        while (rr.next()) roleList.add(rr.getString("role_name"));

        String cSql = filterRole != null
            ? "SELECT COUNT(*) FROM analysis_history WHERE role_name = ?"
            : "SELECT COUNT(*) FROM analysis_history";
        PreparedStatement cps = conn.prepareStatement(cSql);
        if (filterRole != null) cps.setString(1, filterRole);
        ResultSet cr = cps.executeQuery();
        if (cr.next()) totalCount = cr.getInt(1);

        String qSql = filterRole != null
            ? "SELECT id, role_name, score, matched_skills, missing_skills, analyzed_at FROM analysis_history WHERE role_name = ? ORDER BY analyzed_at DESC LIMIT ? OFFSET ?"
            : "SELECT id, role_name, score, matched_skills, missing_skills, analyzed_at FROM analysis_history ORDER BY analyzed_at DESC LIMIT ? OFFSET ?";
        PreparedStatement qps = conn.prepareStatement(qSql);
        if (filterRole != null) { qps.setString(1,filterRole); qps.setInt(2,pageSize); qps.setInt(3,offset); }
        else { qps.setInt(1,pageSize); qps.setInt(2,offset); }
        ResultSet rs = qps.executeQuery();

        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, HH:mm");
        while (rs.next()) {
            Map<String,String> row = new LinkedHashMap<>();
            row.put("id",      rs.getString("id"));
            row.put("role",    rs.getString("role_name"));
            row.put("score",   rs.getString("score"));
            row.put("matched", rs.getString("matched_skills") != null ? rs.getString("matched_skills") : "");
            row.put("missing", rs.getString("missing_skills") != null ? rs.getString("missing_skills") : "");
            Timestamp ts = rs.getTimestamp("analyzed_at");
            row.put("date", ts != null ? sdf.format(ts) : "—");
            records.add(row);
        }
    } catch (Exception e) { dbErr = e.getMessage(); }

    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

    /* Emoji map */
    Map<String,String> emojiMap = new HashMap<>();
    emojiMap.put("Machine Learning Engineer","🤖"); emojiMap.put("Full Stack Developer","🌐");
    emojiMap.put("Data Analyst","📊"); emojiMap.put("DevOps Engineer","⚙️");
    emojiMap.put("Android Developer","📱"); emojiMap.put("Cybersecurity Analyst","🔒");
    emojiMap.put("Backend Developer","🖥️"); emojiMap.put("Frontend Developer","🎨");
    emojiMap.put("Data Scientist","🔬"); emojiMap.put("Cloud Architect","☁️");
    emojiMap.put("UI/UX Designer","✏️"); emojiMap.put("iOS Developer","🍎");
    emojiMap.put("Database Administrator","🗄️"); emojiMap.put("Blockchain Developer","⛓️");
    emojiMap.put("Embedded Systems Engineer","🔧"); emojiMap.put("Game Developer","🎮");
    emojiMap.put("Business Intelligence Analyst","📈"); emojiMap.put("QA Automation Engineer","🧪");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>History — ResumeIQ</title>
  <link rel="stylesheet" href="css/style.css"/>
</head>
<body>

<nav class="navbar">
  <div class="nav-inner">
    <a href="index.jsp" class="logo">
      <div class="logo-box">IQ</div>
      <span class="logo-name">Resume<span>IQ</span></span>
    </a>
    <div class="nav-links">
      <div class="nav-live"><span class="live-dot"></span> Live DB</div>
      <a href="index.jsp"   class="nav-link">🏠 Home</a>
      <a href="history.jsp" class="nav-link active">📋 History</a>
      <a href="admin.jsp"   class="nav-cta">⚙️ Admin</a>
    </div>
  </div>
</nav>

<div class="page-wrap">

  <div class="page-header">
    <h1>📋 Analysis History</h1>
    <p>All resume analyses saved to PostgreSQL — <strong style="color:var(--blue)"><%= totalCount %></strong> records total</p>
  </div>

  <% if (!dbErr.isEmpty()) { %>
  <div class="alert alert-err">❌ Database error: <%= dbErr %></div>
  <% } %>

  <!-- Filter -->
  <div class="card mb-24" style="padding:18px 24px;">
    <form action="history.jsp" method="get"
          style="display:flex; align-items:flex-end; gap:12px; flex-wrap:wrap;">
      <div style="flex:1; min-width:200px;">
        <label for="filterRole">Filter by Role</label>
        <select name="filterRole" id="filterRole" style="margin-bottom:0;">
          <option value="">— All Roles —</option>
          <% for (String r : roleList) { %>
            <option value="<%= r %>" <%= r.equals(filterRole) ? "selected" : "" %>><%= r %></option>
          <% } %>
        </select>
      </div>
      <button type="submit" class="btn btn-outline" style="width:auto; padding:11px 22px; margin-bottom:0;">
        Filter
      </button>
      <% if (filterRole != null) { %>
      <a href="history.jsp" class="btn btn-outline"
         style="width:auto; padding:11px 22px; text-decoration:none;">Clear</a>
      <% } %>
      <a href="index.jsp" class="btn btn-blue"
         style="width:auto; padding:11px 22px; text-decoration:none; margin-left:auto;">
        + New Analysis
      </a>
    </form>
  </div>

  <!-- Table -->
  <% if (records.isEmpty()) { %>
    <div class="empty">
      <div class="e-icon">📭</div>
      <h4>No history found</h4>
      <p>Analyze a resume on the <a href="index.jsp" style="color:var(--blue)">home page</a> first.</p>
    </div>
  <% } else { %>
  <div class="hist-table-wrap">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Role</th>
          <th>Score</th>
          <th>Matched Skills</th>
          <th>Missing Skills</th>
          <th>Date & Time</th>
        </tr>
      </thead>
      <tbody>
      <% for (Map<String,String> row : records) {
           int sc = 0;
           try { sc = Integer.parseInt(row.get("score")); } catch(Exception e2) {}
           String pillClass = sc >= 75 ? "high" : (sc >= 50 ? "medium" : (sc >= 25 ? "low" : "poor"));
           String roleEmo = emojiMap.getOrDefault(row.get("role"), "💼");
      %>
        <tr>
          <td style="color:var(--text3); font-family:'Courier New',monospace; font-size:0.75rem;">#<%= row.get("id") %></td>
          <td style="font-weight:600; color:var(--text);">
            <%= roleEmo %> <%= row.get("role") %>
          </td>
          <td><span class="score-pill <%= pillClass %>"><%= sc %>%</span></td>
          <td>
            <%
               String m = row.get("matched");
               if (m != null && !m.trim().isEmpty()) {
                 String[] ms = m.split(",");
                 int show = Math.min(ms.length, 3);
                 for (int i = 0; i < show; i++) {
                   if (!ms[i].trim().isEmpty()) { %>
                     <span class="chip chip-green" style="font-size:0.68rem;"><%= ms[i].trim() %></span>
             <%   }
                 }
                 if (ms.length > 3) { %>
                   <span style="font-size:0.73rem; color:var(--text3);">+<%= ms.length - 3 %></span>
             <% }
               } else { %>
                 <span style="color:var(--text3);">—</span>
             <% } %>
          </td>
          <td>
            <%
               String mi = row.get("missing");
               if (mi != null && !mi.trim().isEmpty()) {
                 String[] ms2 = mi.split(",");
                 int show2 = Math.min(ms2.length, 3);
                 for (int i = 0; i < show2; i++) {
                   if (!ms2[i].trim().isEmpty()) { %>
                     <span class="chip chip-red" style="font-size:0.68rem;"><%= ms2[i].trim() %></span>
             <%   }
                 }
                 if (ms2.length > 3) { %>
                   <span style="font-size:0.73rem; color:var(--text3);">+<%= ms2.length - 3 %></span>
             <% }
               } else { %>
                 <span style="color:var(--mint); font-size:0.78rem;">All matched ✓</span>
             <% } %>
          </td>
          <td style="font-size:0.78rem; color:var(--text3); white-space:nowrap;">
            <%= row.get("date") %>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>
  </div>

  <!-- Pagination -->
  <% if (totalPages > 1) { %>
  <div style="display:flex; justify-content:center; gap:8px; margin-top:20px; flex-wrap:wrap;">
    <% for (int p = 1; p <= totalPages; p++) { %>
    <a href="history.jsp?page=<%= p %><%= filterRole != null ? "&filterRole=" + filterRole : "" %>"
       style="padding:7px 14px; border-radius:var(--r2); text-decoration:none; font-size:0.82rem;
              background:<%= p == pageNum ? "var(--blue)" : "var(--card)" %>;
              color:<%= p == pageNum ? "#fff" : "var(--text2)" %>;
              border:1px solid <%= p == pageNum ? "var(--blue)" : "var(--border)" %>;">
      <%= p %>
    </a>
    <% } %>
  </div>
  <% } %>

  <% } %>

</div>

<footer class="footer">
  <p>ResumeIQ &nbsp;|&nbsp; <a href="index.jsp">← Back to Analyzer</a></p>
</footer>

</body>
</html>
