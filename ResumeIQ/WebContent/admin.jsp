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
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String msg = "", msgType = "ok";

    if ("add".equals(action)) {
        String rn = request.getParameter("roleName");
        String sk = request.getParameter("skills");
        if (rn != null && !rn.trim().isEmpty() && sk != null && !sk.trim().isEmpty()) {
            try (Connection conn = getConn()) {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO roles (role_name) VALUES (?) RETURNING id");
                ps.setString(1, rn.trim());
                ResultSet rs = ps.executeQuery(); rs.next();
                int rid = rs.getInt(1);
                PreparedStatement ps2 = conn.prepareStatement("INSERT INTO role_skills (role_id, skill_name) VALUES (?,?)");
                for (String s : sk.split(",")) {
                    s = s.trim();
                    if (!s.isEmpty()) { ps2.setInt(1, rid); ps2.setString(2, s); ps2.addBatch(); }
                }
                ps2.executeBatch();
                msg = "Role added successfully."; msgType = "ok";
            } catch (Exception e) { msg = "Error: " + e.getMessage(); msgType = "err"; }
        } else { msg = "Both fields are required."; msgType = "warn"; }
    }

    if ("delete".equals(action)) {
        String rn = request.getParameter("roleName");
        if (rn != null && !rn.trim().isEmpty()) {
            try (Connection conn = getConn()) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM roles WHERE role_name = ?");
                ps.setString(1, rn);
                int d = ps.executeUpdate();
                msg = d > 0 ? "Role deleted." : "Role not found."; msgType = d > 0 ? "ok" : "warn";
            } catch (Exception e) { msg = "Error: " + e.getMessage(); msgType = "err"; }
        }
    }

    List<String[]> roles = new ArrayList<>();
    try (Connection conn = getConn()) {
        ResultSet rs = conn.createStatement().executeQuery(
            "SELECT r.role_name, STRING_AGG(s.skill_name, ', ' ORDER BY s.skill_name) AS skills, COUNT(s.id) AS cnt " +
            "FROM roles r LEFT JOIN role_skills s ON r.id = s.role_id GROUP BY r.id, r.role_name ORDER BY r.role_name");
        while (rs.next()) roles.add(new String[]{ rs.getString("role_name"), rs.getString("skills") != null ? rs.getString("skills") : "", rs.getString("cnt") });
    } catch (Exception e) { if (msg.isEmpty()) { msg = "DB error: " + e.getMessage(); msgType = "err"; } }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Manage Roles — ResumeIQ</title>
  <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
<div class="page">

<nav class="navbar">
  <div class="nav-inner">
    <a href="index.jsp" class="logo">
      <div class="logo-mark">IQ</div>
      <span class="logo-text">Resume<em>IQ</em></span>
    </a>
    <div class="nav-right">
      <a href="index.jsp" class="nav-pill">← Back to Analyzer</a>
    </div>
  </div>
</nav>

<div class="page-wrap" style="max-width:900px; margin:0 auto; padding:36px 24px 60px;">

  <div style="margin-bottom:28px;">
    <div style="font-size:1.1rem; font-weight:700; color:var(--white); margin-bottom:4px;">Manage Job Roles</div>
    <div style="font-size:0.8rem; color:var(--text2);">Add or remove roles and their required skills from the database</div>
  </div>

  <% if (!msg.isEmpty()) { %>
  <div class="inline-alert ia-<%= msgType %>" style="margin-bottom:20px;"><%= msg %></div>
  <% } %>

  <div style="display:grid; grid-template-columns:320px 1fr; gap:20px;">

    <!-- Add form -->
    <div class="form-card" style="height:fit-content; position:sticky; top:80px;">
      <div class="form-card-title">Add New Role</div>
      <div class="form-card-sub">Fields are saved to PostgreSQL</div>

      <form action="admin.jsp" method="post">
        <input type="hidden" name="action" value="add"/>
        <div class="field">
          <label>Role Name</label>
          <input type="text" name="roleName" placeholder="e.g. Backend Developer" required/>
        </div>
        <div class="field">
          <label>Required Skills (comma-separated)</label>
          <input type="text" name="skills" placeholder="Java, Spring Boot, MySQL, REST API" required/>
        </div>
        <button type="submit" class="analyze-btn">Add Role</button>
      </form>
    </div>

    <!-- Roles list -->
    <div class="form-card">
      <div class="form-card-title">Current Roles &nbsp;<span style="font-size:0.75rem; font-weight:400; color:var(--text2);">(<%= roles.size() %> total)</span></div>
      <div class="form-card-sub">Click Delete to remove a role and all its skills</div>

      <% if (roles.isEmpty()) { %>
        <div class="empty-state"><div class="ei">📭</div><h4>No roles yet</h4><p>Use the form to add the first one</p></div>
      <% } else {
           for (String[] r : roles) { %>
        <div style="display:flex; align-items:flex-start; justify-content:space-between; gap:12px; padding:14px 0; border-bottom:1px solid var(--border);">
          <div style="flex:1;">
            <div style="font-size:0.88rem; font-weight:600; color:var(--white); margin-bottom:5px;"><%= r[0] %></div>
            <div style="font-size:0.72rem; color:var(--text3); margin-bottom:7px;"><%= r[2] %> skills</div>
            <div style="display:flex; flex-wrap:wrap; gap:5px;">
              <% if (r[1] != null && !r[1].isEmpty()) {
                   String[] sks = r[1].split(", ");
                   int show = Math.min(sks.length, 5);
                   for (int i = 0; i < show; i++) { %>
                     <span class="chip chip-amber" style="font-size:0.67rem;"><%= sks[i].trim() %></span>
              <%   }
                   if (sks.length > 5) { %>
                     <span class="chip chip-dim" style="font-size:0.67rem;">+<%= sks.length-5 %> more</span>
              <%   }
                 } %>
            </div>
          </div>
          <form action="admin.jsp" method="post"
                onsubmit="return confirm('Delete \'<%= r[0].replace("'","\\'") %>\'?')">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="roleName" value="<%= r[0] %>"/>
            <button type="submit" class="btn btn-red" style="background:rgba(224,92,92,0.1); border:1px solid rgba(224,92,92,0.3); color:var(--red); padding:6px 13px; border-radius:6px; font-size:0.75rem; cursor:pointer; font-family:'Inter',sans-serif;">Delete</button>
          </form>
        </div>
      <%   }
         } %>
    </div>

  </div>
</div>

<footer class="footer">
  <p>ResumeIQ &copy; 2024 &nbsp;&nbsp;·&nbsp;&nbsp; <a href="index.jsp">Back to Analyzer</a></p>
</footer>

</div>
</body>
</html>
