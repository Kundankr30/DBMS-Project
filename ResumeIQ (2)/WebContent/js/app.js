/*
 * app.js — ResumeIQ
 * Home page logic: fill dropdown, build cards, run analysis, submit to results.jsp
 */

/* ── Init ── */
function initHome() {
  fillDropdown();
  buildCards();
  checkSessionPick();   /* auto-select if coming back from recommend.jsp */
}

/* Auto-select role if user clicked a recommend card */
function checkSessionPick() {
  var pick = sessionStorage.getItem('pickRole');
  if (pick) {
    sessionStorage.removeItem('pickRole');
    var sel = document.getElementById('roleSelect');
    if (sel) { sel.value = pick; onRolePick(pick); }
  }
}

/* ── Dropdown ── */
function fillDropdown() {
  var sel = document.getElementById('roleSelect');
  if (!sel) return;
  Object.keys(rolesDB).sort().forEach(function(name) {
    var o = document.createElement('option');
    o.value = name; o.textContent = name;
    sel.appendChild(o);
  });
}

/* ── When role is picked ── */
function onRolePick(role) {
  var row = document.getElementById('skillsRow');
  if (!row) return;
  row.innerHTML = '';

  if (!role || !rolesDB[role]) {
    row.innerHTML = '<span class="ph">Select a role above to see required skills</span>';
    highlightCard(null);
    return;
  }

  rolesDB[role].forEach(function(skill) {
    var s = document.createElement('span');
    s.className = 'chip chip-amber';
    s.textContent = skill;
    row.appendChild(s);
  });

  highlightCard(role);
}

/* ── Role cards ── */
var ICONS = {
  'Machine Learning Engineer':    '🤖',
  'Full Stack Developer':         '🌐',
  'Data Analyst':                 '📊',
  'DevOps Engineer':              '⚙️',
  'Android Developer':            '📱',
  'Cybersecurity Analyst':        '🔒',
  'Backend Developer':            '🖥️',
  'Frontend Developer':           '🎨',
  'Data Scientist':               '🔬',
  'Cloud Architect':              '☁️',
  'UI/UX Designer':               '✏️',
  'iOS Developer':                '🍎',
  'Database Administrator':       '🗄️',
  'Blockchain Developer':         '⛓️',
  'Embedded Systems Engineer':    '🔧',
  'Game Developer':               '🎮',
  'Business Intelligence Analyst':'📈',
  'QA Automation Engineer':       '🧪'
};

function buildCards() {
  var grid = document.getElementById('rolesGrid');
  if (!grid) return;

  var names = Object.keys(rolesDB).sort();
  if (names.length === 0) {
    grid.innerHTML = '<div class="empty-state"><div class="ei">📭</div><h4>No roles yet</h4><p>Add roles via <a href="admin.jsp">Admin</a></p></div>';
    return;
  }

  names.forEach(function(name) {
    var skills = rolesDB[name] || [];
    var card   = document.createElement('div');
    card.className    = 'role-card';
    card.dataset.role = name;
    card.innerHTML =
      '<div class="rc-icon">' + (ICONS[name] || '💼') + '</div>' +
      '<div class="rc-name">' + esc(name) + '</div>' +
      '<div class="rc-count">' + skills.length + ' skills required</div>';

    card.addEventListener('click', function() {
      var sel = document.getElementById('roleSelect');
      if (sel) sel.value = name;
      onRolePick(name);
      document.querySelector('.form-card').scrollIntoView({ behavior: 'smooth' });
    });

    grid.appendChild(card);
  });
}

function highlightCard(name) {
  document.querySelectorAll('.role-card').forEach(function(c) {
    c.classList.toggle('picked', c.dataset.role === name);
  });
}

/* ── Analyze ── */
function doAnalyze() {
  var role   = document.getElementById('roleSelect').value.trim();
  var resume = document.getElementById('resumeInput').value.trim();
  var btn    = document.getElementById('analyzeBtn');

  clearAlert();

  if (!role)           { showAlert('Please select a job role.', 'warn'); return; }
  if (resume.length < 30) { showAlert('Please paste your resume text (at least 30 characters).', 'warn'); return; }
  if (!rolesDB[role])  { showAlert('Role not found. Please refresh and try again.', 'err');  return; }

  btn.disabled    = true;
  btn.textContent = 'Analyzing...';

  /* Short delay so user sees the button state */
  setTimeout(function() {
    var result = matchSkills(role, resume);
    submitForm(role, result.score, result.matched, result.missing, resume);
  }, 500);
}

/* ── Skill matching ── */
function matchSkills(role, resumeText) {
  var required = rolesDB[role];
  var lower    = resumeText.toLowerCase();
  var matched  = [], missing = [];

  required.forEach(function(skill) {
    var sl    = skill.toLowerCase();
    var found = lower.indexOf(sl) !== -1;

    /* fallback: strip dots/plus so Node.js → nodejs, C++ → c */
    if (!found) {
      var clean = sl.replace(/[.\+#\s]/g, '');
      if (clean.length > 1) found = lower.indexOf(clean) !== -1;
    }

    if (found) matched.push(skill);
    else        missing.push(skill);
  });

  var score = required.length > 0
    ? Math.round((matched.length / required.length) * 100)
    : 0;

  return { score: score, matched: matched, missing: missing };
}

/* ── Submit hidden form to results.jsp ── */
function submitForm(role, score, matched, missing, resume) {
  document.getElementById('f_role').value    = role;
  document.getElementById('f_score').value   = score;
  document.getElementById('f_matched').value = matched.join(',');
  document.getElementById('f_missing').value = missing.join(',');
  document.getElementById('f_snippet').value = resume.substring(0, 1200);
  document.getElementById('resultForm').submit();
}

/* ── Alerts ── */
function showAlert(msg, type) {
  var box = document.getElementById('alertBox');
  if (!box) return;
  box.innerHTML = '<div class="inline-alert ia-' + type + '">' + esc(msg) + '</div>';
}

function clearAlert() {
  var box = document.getElementById('alertBox');
  if (box) box.innerHTML = '';
}

/* ── XSS safe ── */
function esc(str) {
  var d = document.createElement('div');
  d.textContent = str;
  return d.innerHTML;
}
