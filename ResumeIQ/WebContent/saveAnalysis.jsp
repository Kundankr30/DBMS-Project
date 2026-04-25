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

    /* Helper: escape double quotes for JSON safety */
    String jsonSafe(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
%>
<%
    /*
     * saveAnalysis.jsp
     * ────────────────
     * Called via JavaScript fetch() POST after a resume is analyzed.
     * Receives: role, score, matched, missing, resumeText
     * Saves to: analysis_history table in PostgreSQL
     * Returns:  JSON { "saved": true } or { "saved": false, "error": "..." }
     */

    /* Prevent browser caching */
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");

    request.setCharacterEncoding("UTF-8");

    String role       = request.getParameter("role");
    String scoreStr   = request.getParameter("score");
    String matched    = request.getParameter("matched");
    String missing    = request.getParameter("missing");
    String resumeText = request.getParameter("resumeText");

    /* Parse score safely */
    int score = 0;
    try { score = Integer.parseInt(scoreStr != null ? scoreStr.trim() : "0"); }
    catch (Exception e) { score = 0; }

    /* Validate required fields */
    if (role == null || role.trim().isEmpty()) {
        out.print("{\"saved\":false,\"error\":\"Role name is required\"}");
        return;
    }

    /* Insert into PostgreSQL */
    String result;
    try (Connection conn = getConn()) {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO analysis_history (role_name, score, matched_skills, missing_skills, resume_text) " +
            "VALUES (?, ?, ?, ?, ?)"
        );
        ps.setString(1, role.trim());
        ps.setInt   (2, score);
        ps.setString(3, matched  != null ? matched  : "");
        ps.setString(4, missing  != null ? missing  : "");
        ps.setString(5, resumeText != null ? resumeText : "");
        ps.executeUpdate();
        result = "{\"saved\":true,\"role\":\"" + jsonSafe(role.trim()) + "\",\"score\":" + score + "}";
    } catch (Exception e) {
        result = "{\"saved\":false,\"error\":\"" + jsonSafe(e.getMessage()) + "\"}";
    }

    out.print(result);
%>
