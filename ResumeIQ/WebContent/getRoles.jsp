<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%!
    /* ── DB Config — CHANGE YOUR PASSWORD BELOW ── */
    static final String DB_URL  = "jdbc:postgresql://localhost:5432/resumeiq_db";
    static final String DB_USER = "postgres";
    static final String DB_PASS = "ashu5568";   /* ← CHANGE THIS */

    Connection getConn() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    String jsonSafe(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
%>
<%
    /*
     * getRoles.jsp
     * ────────────
     * Returns JSON object: { "RoleName": ["skill1", "skill2", ...], ... }
     * Used for optional AJAX refresh without full page reload.
     * Called from app.js refreshRolesFromServer() if needed.
     */

    response.setHeader("Cache-Control", "no-cache");

    StringBuilder json = new StringBuilder("{");
    boolean firstRole  = true;

    try (Connection conn = getConn()) {
        String sql = "SELECT r.role_name, s.skill_name " +
                     "FROM roles r JOIN role_skills s ON r.id = s.role_id " +
                     "ORDER BY r.role_name, s.skill_name";
        ResultSet rs = conn.createStatement().executeQuery(sql);

        String currentRole = "";
        boolean firstSkill = true;

        while (rs.next()) {
            String role  = rs.getString("role_name");
            String skill = rs.getString("skill_name");

            if (!role.equals(currentRole)) {
                if (!currentRole.isEmpty()) json.append("]");
                if (!firstRole) json.append(",");
                json.append("\"").append(jsonSafe(role)).append("\":[");
                currentRole = role;
                firstRole   = false;
                firstSkill  = true;
            }
            if (!firstSkill) json.append(",");
            json.append("\"").append(jsonSafe(skill)).append("\"");
            firstSkill = false;
        }
        if (!currentRole.isEmpty()) json.append("]");
    } catch (Exception e) {
        out.print("{\"error\":\"" + jsonSafe(e.getMessage()) + "\"}");
        return;
    }

    json.append("}");
    out.print(json.toString());
%>
