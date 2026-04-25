<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%!
	static final String DB_URL  = "jdbc:postgresql://localhost:5432/resumeiq_db";
	static final String DB_USER = "postgres";
	static final String DB_PASS = "ashu5568";
%>
<%
    request.setCharacterEncoding("UTF-8");

    String role       = request.getParameter("role");
    String scoreStr   = request.getParameter("score");
    String matchedStr = request.getParameter("matched");
    String missingStr = request.getParameter("missing");
    String snippet    = request.getParameter("snippet");

    /* Guard — redirect if someone lands here directly */
    if (role == null || role.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    int score = 0;
    try { score = Integer.parseInt(scoreStr.trim()); } catch (Exception e) {}

    String[] matchedArr = (matchedStr != null && !matchedStr.trim().isEmpty())
                          ? matchedStr.split(",") : new String[0];
    String[] missingArr = (missingStr != null && !missingStr.trim().isEmpty())
                          ? missingStr.split(",") : new String[0];

    int total = matchedArr.length + missingArr.length;

    /* ── Save to PostgreSQL ── */
    String saveMsg = "";
    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO analysis_history (role_name, score, matched_skills, missing_skills, resume_text) VALUES (?,?,?,?,?)");
        ps.setString(1, role.trim());
        ps.setInt   (2, score);
        ps.setString(3, matchedStr != null ? matchedStr : "");
        ps.setString(4, missingStr != null ? missingStr : "");
        ps.setString(5, snippet   != null ? snippet    : "");
        ps.executeUpdate();
        conn.close();
        saveMsg = "ok";
    } catch (Exception e) {
        saveMsg = e.getMessage();
    }

    /* ── Verdict ── */
    String level, verdictText, verdictDesc;
    if      (score >= 75) { level = "high";   verdictText = "Strong Match";    verdictDesc = "Your resume is well aligned with this role. You have most of the skills employers look for here."; }
    else if (score >= 50) { level = "medium"; verdictText = "Decent Match";    verdictDesc = "You have a solid base, but a few key skills are missing. Adding them could make a real difference."; }
    else if (score >= 25) { level = "low";    verdictText = "Partial Match";   verdictDesc = "Some relevant skills are present, but the gap is significant. Focus on the missing ones before applying."; }
    else                  { level = "poor";   verdictText = "Needs More Work"; verdictDesc = "Your resume currently has very few of the required skills for this role. Start building from the basics."; }

    /* ── Score-based quotes ── */
    String[][] quotes = {
        /* high */   { "Confidence is not they will like me. Confidence is I will be fine whether they do or not.",
                       "Preparation is the foundation of all achievement. You are ready.",
                       "Your skills speak before you even enter the room." },
        /* medium */ { "Success is where preparation and opportunity meet. Keep preparing.",
                       "You are closer than you think — the gap is a short sprint, not a marathon.",
                       "A little more polish and this resume will shine." },
        /* low */    { "Every expert was once a beginner. Start filling those gaps.",
                       "The best investment you can make is in yourself.",
                       "Skills are not born — they are built. Start building." },
        /* poor */   { "The journey of a thousand miles begins with a single step.",
                       "Do not be discouraged by where you are. Be motivated by where you can go.",
                       "Every skill you learn today is an interview you pass tomorrow." }
    };

    int lvlIdx = score >= 75 ? 0 : score >= 50 ? 1 : score >= 25 ? 2 : 3;
    String[] levelQuotes = quotes[lvlIdx];
    String pickedQuote = levelQuotes[(int)(System.currentTimeMillis()/60000) % levelQuotes.length];

    /* ── Tips ── */
    String[][] tipsBank = {
        /* high */   { "Tailor your resume headline to mention the exact role title",
                       "Quantify achievements — use numbers (improved speed by 30%, managed 5 projects)",
                       "Add a short profile summary at the top of your resume",
                       "Proofread twice — spelling errors cost candidates the interview" },
        /* medium */ { "Add the missing skills if you have even basic knowledge of them",
                       "Mention related projects that use the skills you already have",
                       "Take a short course (YouTube, Udemy, Coursera) on the top missing skill",
                       "A dedicated Skills section makes your resume easier to scan" },
        /* low */    { "Add the missing skills to a study plan and work through them one by one",
                       "Build small personal projects to gain practical experience",
                       "Look for internship or junior roles while upskilling",
                       "Update your resume after every new skill you learn" },
        /* poor */   { "Start with the most commonly required skill for this role",
                       "Free resources: freeCodeCamp, The Odin Project, Khan Academy, YouTube",
                       "Build 1 small project with the core skill — it gives you something to show",
                       "Set a 3-month goal with specific skills to learn each week" }
    };
    String[] tips = tipsBank[lvlIdx];

    /* ── Role emoji ── */
    java.util.Map<String,String> em = new java.util.HashMap<>();
    em.put("Machine Learning Engineer","🤖"); em.put("Full Stack Developer","🌐");
    em.put("Data Analyst","📊"); em.put("DevOps Engineer","⚙️");
    em.put("Android Developer","📱"); em.put("Cybersecurity Analyst","🔒");
    em.put("Backend Developer","🖥️"); em.put("Frontend Developer","🎨");
    em.put("Data Scientist","🔬"); em.put("Cloud Architect","☁️");
    em.put("UI/UX Designer","✏️"); em.put("iOS Developer","🍎");
    em.put("Database Administrator","🗄️"); em.put("Blockchain Developer","⛓️");
    em.put("Embedded Systems Engineer","🔧"); em.put("Game Developer","🎮");
    em.put("Business Intelligence Analyst","📈"); em.put("QA Automation Engineer","🧪");
    String emoji = em.getOrDefault(role.trim(), "💼");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Your Result — ResumeIQ</title>
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

<div class="results-wrap">

  <a href="index.jsp" class="back-link">← Back to Analyzer</a>

  <!-- Score Card -->
  <div class="score-card">

    <div class="score-role-name"><%= emoji %> &nbsp;<%= role %></div>

    <div class="score-circle <%= level %>">
      <div class="score-num" id="scoreNum">0</div>
      <div class="score-pct">out of 100</div>
    </div>

    <div class="prog-wrap">
      <div class="prog-label">
        <span><%= matchedArr.length %> of <%= total %> skills matched</span>
        <span id="progPct">0%</span>
      </div>
      <div class="prog-track">
        <div class="prog-fill <%= level %>" id="progFill"></div>
      </div>
    </div>

    <div class="verdict <%= level %>"><%= verdictText %></div>
    <div class="verdict-desc"><%= verdictDesc %></div>

    <div class="result-quote">&ldquo;<%= pickedQuote %>&rdquo;</div>

  </div>

  <!-- Skills Grid -->
  <div class="skills-grid">
    <div class="skills-box">
      <div class="sb-title">
        <span class="sb-dot g"></span>
        Matched &nbsp;(<%= matchedArr.length %>)
      </div>
      <div class="chip-wrap">
        <% if (matchedArr.length == 0) { %>
          <span class="empty-msg">No skills matched</span>
        <% } else {
             for (String s : matchedArr) {
               if (!s.trim().isEmpty()) { %>
                 <span class="chip chip-green"><%= s.trim() %></span>
        <%     }
             }
           } %>
      </div>
    </div>

    <div class="skills-box">
      <div class="sb-title">
        <span class="sb-dot r"></span>
        Missing &nbsp;(<%= missingArr.length %>)
      </div>
      <div class="chip-wrap">
        <% if (missingArr.length == 0) { %>
          <span class="empty-msg" style="color:var(--green);">All skills found!</span>
        <% } else {
             for (String s : missingArr) {
               if (!s.trim().isEmpty()) { %>
                 <span class="chip chip-red"><%= s.trim() %></span>
        <%     }
             }
           } %>
      </div>
    </div>
  </div>

  <!-- Tips -->
  <div class="tips-card">
    <div class="tips-title">What You Can Do Next</div>
    <ul class="tips-list">
      <% for (String tip : tips) { %>
        <li><%= tip %></li>
      <% } %>
    </ul>
  </div>

  <!-- Action Buttons -->
  <div class="action-row">
    <a href="index.jsp" class="btn-primary">Analyze Another Resume</a>
    <a href="recommend.jsp?role=<%= java.net.URLEncoder.encode(role,"UTF-8") %>&score=<%= score %>&matched=<%= java.net.URLEncoder.encode(matchedStr!=null?matchedStr:"","UTF-8") %>&missing=<%= java.net.URLEncoder.encode(missingStr!=null?missingStr:"","UTF-8") %>"
       class="btn-secondary">See More Matching Roles →</a>
  </div>

</div>

<footer class="footer">
  <p>ResumeIQ &copy; 2024 &nbsp;&nbsp;·&nbsp;&nbsp; <a href="admin.jsp">Manage Roles</a></p>
</footer>

</div>

<script>
  /* Simple counter + progress bar — no heavy animation library */
  var target = <%= score %>;

  window.onload = function () {
    var numEl   = document.getElementById('scoreNum');
    var fillEl  = document.getElementById('progFill');
    var pctEl   = document.getElementById('progPct');
    var current = 0;
    var step    = Math.ceil(target / 40);   /* ~40 steps */

    var timer = setInterval(function () {
      current += step;
      if (current >= target) { current = target; clearInterval(timer); }
      numEl.textContent  = current;
      pctEl.textContent  = current + '%';
      fillEl.style.width = current + '%';
    }, 25);   /* runs every 25ms → ~1 second total */
  };
</script>

</body>
</html>
