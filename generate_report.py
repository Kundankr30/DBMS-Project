#!/usr/bin/env python3
"""
Cultural Event Management System - PDF Report Generator
Generates a comprehensive project report in PDF format
"""

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, cm
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_JUSTIFY
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Image
from reportlab.lib.colors import HexColor, black, darkblue, darkgreen
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from datetime import datetime

def create_report():
    # Create the PDF document
    doc = SimpleDocTemplate(
        "Cultural_Event_Management_System_Report.pdf",
        pagesize=A4,
        rightMargin=0.75*inch,
        leftMargin=0.75*inch,
        topMargin=0.7*inch,
        bottomMargin=0.5*inch
    )

    # Container for the 'Flowable' objects
    elements = []

    # Define styles
    styles = getSampleStyleSheet()

    # Custom styles
    title_style = ParagraphStyle(
        'CustomTitle',
        parent=styles['Heading1'],
        fontSize=24,
        textColor=darkblue,
        spaceAfter=30,
        alignment=TA_CENTER,
        fontName='Helvetica-Bold'
    )

    subtitle_style = ParagraphStyle(
        'Subtitle',
        parent=styles['Heading2'],
        fontSize=14,
        textColor=black,
        spaceAfter=20,
        alignment=TA_CENTER,
        fontName='Helvetica-Oblique'
    )

    heading1_style = ParagraphStyle(
        'Heading1Custom',
        parent=styles['Heading1'],
        fontSize=18,
        textColor=darkblue,
        spaceAfter=12,
        spaceBefore=12,
        fontName='Helvetica-Bold'
    )

    heading2_style = ParagraphStyle(
        'Heading2Custom',
        parent=styles['Heading2'],
        fontSize=14,
        textColor=darkblue,
        spaceAfter=10,
        spaceBefore=10,
        fontName='Helvetica-Bold'
    )

    heading3_style = ParagraphStyle(
        'Heading3Custom',
        parent=styles['Heading3'],
        fontSize=12,
        textColor=black,
        spaceAfter=8,
        spaceBefore=8,
        fontName='Helvetica-Bold'
    )

    body_style = ParagraphStyle(
        'BodyCustom',
        parent=styles['BodyText'],
        fontSize=10,
        textColor=black,
        spaceAfter=6,
        alignment=TA_JUSTIFY,
        fontName='Helvetica'
    )

    code_style = ParagraphStyle(
        'CodeCustom',
        parent=styles['BodyText'],
        fontSize=9,
        textColor=darkgreen,
        spaceAfter=4,
        fontName='Courier'
    )

    table_header_style = ParagraphStyle(
        'TableHeader',
        parent=styles['BodyText'],
        fontSize=10,
        textColor=colors.whitesmoke,
        fontName='Helvetica-Bold'
    )

    # ==================== TITLE PAGE ====================
    elements.append(Paragraph("CULTURAL EVENT MANAGEMENT SYSTEM", title_style))
    elements.append(Paragraph("Comprehensive Project Report", subtitle_style))
    elements.append(Spacer(1, 0.5*inch))

    # Project info table
    info_data = [
        ["Project Type", ":", "PostgreSQL-based DBMS Project"],
        ["Database System", ":", "PostgreSQL with PL/pgSQL"],
        ["Key Features", ":", "Stored Procedures, Triggers, Constraints, Interactive Menu"],
        ["Generated On", ":", datetime.now().strftime("%Y-%m-%d %H:%M:%S")],
    ]

    info_table = Table(info_data, colWidths=[1.5*inch, 0.3*inch, 4*inch])
    info_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.lightgrey),
        ('TEXTCOLOR', (0, 0), (-1, -1), black),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('TOPPADDING', (0, 0), (-1, -1), 8),
        ('BACKGROUND', (0, 0), (0, -1), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (0, -1), colors.whitesmoke),
        ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
    ]))
    elements.append(info_table)
    elements.append(Spacer(1, 2*inch))

    elements.append(Paragraph("Department of Computer Science & Engineering", body_style))
    elements.append(Paragraph("College of Engineering, Bhubaneswar", body_style))
    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("KIIT University", body_style))

    elements.append(PageBreak())

    # ==================== TABLE OF CONTENTS ====================
    elements.append(Paragraph("TABLE OF CONTENTS", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    toc_data = [
        ["A.", "Project Overview", "1"],
        ["B.", "Database Schema & Constraints", "2"],
        ["C.", "ER Relationship Diagram", "5"],
        ["D.", "SQL Files Explanation", "6"],
        ["E.", "Concepts Summary by Category", "15"],
        ["F.", "Complete Workflow: Registration to Award", "18"],
        ["G.", "Summary Statistics", "21"],
        ["H.", "Key Takeaways", "22"],
    ]

    toc_table = Table(toc_data, colWidths=[0.5*inch, 5*inch, 0.5*inch])
    toc_table.setStyle(TableStyle([
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 0), (-1, -1), 11),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('TOPPADDING', (0, 0), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.25, colors.lightgrey),
        ('BACKGROUND', (0, 0), (0, -1), colors.lightblue),
        ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
    ]))
    elements.append(toc_table)

    elements.append(PageBreak())

    # ==================== SECTION A: PROJECT OVERVIEW ====================
    elements.append(Paragraph("A. PROJECT OVERVIEW", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    overview_text = """
    This is a <b>PostgreSQL-based Cultural Event Management System</b> designed to manage college cultural events,
    participant registrations, performances, judging, and award distributions. The system uses stored procedures,
    triggers, constraints, and an interactive menu-driven interface.
    """
    elements.append(Paragraph(overview_text, body_style))

    elements.append(Spacer(1, 0.3*inch))
    elements.append(Paragraph("Key Capabilities:", heading3_style))

    capabilities = [
        "Venue management with capacity validation",
        "Event scheduling with conflict detection",
        "Participant registration and tracking",
        "Judge assignment and scoring system",
        "Performance recording and evaluation",
        "Award creation and winner assignment",
        "Comprehensive reporting and analytics",
        "Interactive terminal-based menu system"
    ]

    for i, cap in enumerate(capabilities, 1):
        elements.append(Paragraph(f"{i}. {cap}", body_style))

    elements.append(PageBreak())

    # ==================== SECTION B: DATABASE SCHEMA ====================
    elements.append(Paragraph("B. DATABASE SCHEMA & CONSTRAINTS", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    elements.append(Paragraph("Tables Created (9 Tables)", heading2_style))

    schema_data = [
        ["#", "Table", "Primary Key", "Foreign Keys", "Purpose"],
        ["1", "Venues", "venue_id (SERIAL)", "None", "Stores venue information"],
        ["2", "Events", "event_id (SERIAL)", "venue_id → Venues", "Stores event details"],
        ["3", "Participants", "sic (TEXT)", "None", "Stores participant details"],
        ["4", "Judges", "judge_id (SERIAL)", "None", "Stores judge information"],
        ["5", "Registrations", "(sic, event_id)", "sic → Participants,\nevent_id → Events", "Links participants to events"],
        ["6", "Performances", "performance_id (SERIAL)", "(sic, event_id) → Registrations", "Records actual performances"],
        ["7", "Performance_Judges", "id (SERIAL)", "performance_id → Performances,\njudge_id → Judges", "Stores scores by judges"],
        ["8", "Awards", "award_id (SERIAL)", "event_id → Events", "Defines awards for events"],
        ["9", "Award_Winners", "winner_id (SERIAL)", "award_id → Awards,\n(sic, event_id) → Registrations", "Records award winners"],
    ]

    schema_table = Table(schema_data, colWidths=[0.3*inch, 1.2*inch, 1.3*inch, 1.8*inch, 1.4*inch])
    schema_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 10),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
        ('TOPPADDING', (0, 0), (-1, 0), 10),
        ('BACKGROUND', (0, 1), (-1, -1), colors.white),
        ('TEXTCOLOR', (0, 1), (-1, -1), black),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 9),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(schema_table)

    elements.append(Spacer(1, 0.3*inch))
    elements.append(Paragraph("Constraints Used", heading2_style))

    constraints_data = [
        ["Constraint Type", "Table", "Column", "Definition"],
        ["NOT NULL", "All tables", "Various", "Ensures mandatory fields"],
        ["PRIMARY KEY", "All tables", "ID columns", "Unique row identification"],
        ["FOREIGN KEY", "Multiple tables", "Reference columns", "Referential integrity"],
        ["UNIQUE", "Participants", "email", "No duplicate emails"],
        ["UNIQUE", "Judges", "email", "No duplicate judge emails"],
        ["CHECK", "Venues", "capacity", "capacity > 0"],
        ["CHECK", "Events", "max_participants", "max_participants > 0"],
        ["CHECK", "Events", "start_time, end_time", "start_time < end_time"],
        ["CHECK", "Participants", "year_of_study", "BETWEEN 1 AND 5"],
        ["CHECK", "Performance_Judges", "score", "BETWEEN 0 AND 100"],
        ["CHECK", "Awards", "position", "position > 0"],
        ["CHECK", "Awards", "prize_amount", ">= 0 OR NULL"],
        ["DEFAULT", "Events", "status", "'active'"],
        ["DEFAULT", "Registrations", "attendance_status", "'registered'"],
        ["DEFAULT", "Various", "timestamp fields", "CURRENT_TIMESTAMP"],
    ]

    constraints_table = Table(constraints_data, colWidths=[1.2*inch, 1.2*inch, 1.5*inch, 2.1*inch])
    constraints_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 10),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
        ('TOPPADDING', (0, 0), (-1, 0), 10),
        ('BACKGROUND', (0, 1), (-1, -1), colors.white),
        ('TEXTCOLOR', (0, 1), (-1, -1), black),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 9),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(constraints_table)

    elements.append(PageBreak())

    # ==================== SECTION C: ER DIAGRAM ====================
    elements.append(Paragraph("C. ER RELATIONSHIP DIAGRAM", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    er_text = """
    <b>Entity Relationships:</b><br/><br/>
    <b>Venues (1) → (N) Events</b> - One venue can host multiple events<br/>
    <b>Events (1) → (N) Registrations</b> - One event has multiple registrations<br/>
    <b>Participants (1) → (N) Registrations</b> - One participant can register for multiple events<br/>
    <b>Registrations (1) → (1) Performances</b> - Each registration can have one performance record<br/>
    <b>Performances (1) → (N) Performance_Judges</b> - One performance can be scored by multiple judges<br/>
    <b>Judges (1) → (N) Performance_Judges</b> - One judge can score multiple performances<br/>
    <b>Events (1) → (N) Awards</b> - One event can have multiple awards<br/>
    <b>Awards (1) → (1) Award_Winners</b> - Each award is given to one winner<br/>
    <b>Registrations (1) → (N) Award_Winners</b> - Winners must be registered participants
    """
    elements.append(Paragraph(er_text, body_style))

    elements.append(Spacer(1, 0.3*inch))

    # ASCII ER Diagram
    er_diagram = """
    ┌─────────────┐
    │   Venues    │
    │  venue_id   │
    │  venue_name │
    │  location   │
    │  capacity   │
    └──────┬──────┘
           │ 1:N
           ▼
    ┌─────────────┐         ┌─────────────┐
    │   Events    │         │   Judges    │
    │  event_id   │         │  judge_id   │
    │  event_name │         │  judge_name │
    │  event_date │         │  expertise  │
    │  venue_id───┼────►FK  │  email      │
    └──────┬──────┘         └──────┬──────┘
           │ 1:N                  │ 1:N
           ▼                      ▼
    ┌─────────────┐         ┌─────────────────┐
    │Participants │         │Performance_Judges│
    │     sic     │         │      id         │
    │    name     │         │  performance_id─┼──►FK
    │    email    │         │    judge_id─────┼──►FK
    └──────┬──────┘         │     score       │
           │ 1:N            │    comments     │
           ▼                └─────────────────┘
    ┌─────────────┐                 ▲
    │Registrations│                 │
    │  sic ───────┼────►FK          │ 1:N
    │  event_id ──┼────►FK          │
    │   status    │                 │
    └──────┬──────┘                 │
           │ 1:1                    │
           ▼                        │
    ┌─────────────┐                 │
    │Performances │─────────────────┘
    │performance_id
    │     sic     │
    │  event_id   │
    └─────────────┘

    ┌─────────────┐
    │   Awards    │
    │  award_id   │
    │  award_name │
    │  event_id ──┼──►FK
    │  position   │
    │prize_amount │
    └──────┬──────┘
           │ 1:1
           ▼
    ┌─────────────┐
    │Award_Winners│
    │  winner_id  │
    │  award_id ──┼──►FK
    │     sic     │
    │  event_id   │
    └─────────────┘
    """

    er_style = ParagraphStyle(
        'ERDiagram',
        parent=styles['BodyText'],
        fontSize=8,
        textColor=black,
        fontName='Courier',
        spaceAfter=10,
        leading=10
    )
    elements.append(Paragraph(er_diagram, er_style))

    elements.append(PageBreak())

    # ==================== SECTION D: SQL FILES EXPLANATION ====================
    elements.append(Paragraph("D. SQL FILES EXPLANATION", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    # File 1
    elements.append(Paragraph("1. 01_create_schema.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Creates the complete database schema with all 9 tables and constraints.", body_style))
    elements.append(Paragraph("<b>Concepts Used:</b>", heading3_style))
    concepts1 = [
        "DROP TABLE IF EXISTS - Idempotent table creation",
        "SERIAL PRIMARY KEY - Auto-incrementing primary keys",
        "CHECK constraints - Data validation at column and table level",
        "REFERENCES - Foreign key relationships",
        "Composite primary key (sic, event_id) in Registrations",
        "Composite foreign key referencing parent composite key"
    ]
    for c in concepts1:
        elements.append(Paragraph(f"• {c}", body_style))

    elements.append(Spacer(1, 0.2*inch))

    # File 2
    elements.append(Paragraph("2. 02_create_indexes.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Creates 11 indexes for query optimization.", body_style))

    index_data = [
        ["Index Name", "Table", "Column(s)", "Purpose"],
        ["idx_events_date", "Events", "event_date", "Fast date-based event searches"],
        ["idx_events_venue", "Events", "venue_id", "Fast venue-to-events lookup"],
        ["idx_registrations_event", "Registrations", "event_id", "Fast event participant lists"],
        ["idx_registrations_participant", "Registrations", "sic", "Fast participant's events"],
        ["idx_perf_judges_performance", "Performance_Judges", "performance_id", "Fast score lookup"],
        ["idx_perf_judges_judge", "Performance_Judges", "judge_id", "Scores by judge"],
        ["idx_performances_sic_event", "Performances", "(sic, event_id)", "Composite lookup"],
        ["idx_participants_email", "Participants", "email", "Email-based searches"],
        ["idx_events_type", "Events", "event_type", "Filter by event category"],
        ["idx_award_winners_sic_event", "Award_Winners", "(sic, event_id)", "Winner lookup"],
        ["idx_awards_event", "Awards", "event_id", "Awards by event"],
    ]

    index_table = Table(index_data, colWidths=[1.8*inch, 1.2*inch, 1.2*inch, 1.8*inch])
    index_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(index_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Concepts Used:</b> B-Tree indexing, Single-column and composite indexes, Query performance optimization", body_style))

    elements.append(Spacer(1, 0.2*inch))

    # File 3
    elements.append(Paragraph("3. 03_insert_sample_data.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Populates all tables with test data.", body_style))
    elements.append(Paragraph("<b>Concepts Used:</b>", heading3_style))
    concepts3 = [
        "Multi-row INSERT statements",
        "Referential integrity (data inserted in dependency order)",
        "DEFAULT values for timestamps and statuses",
        "Sample data: 8 venues, 12 events, 20 participants, 10 judges, 20 registrations, 12 performances, 22 judge scores, 8 awards, 7 winners"
    ]
    for c in concepts3:
        elements.append(Paragraph(f"• {c}", body_style))

    elements.append(PageBreak())

    # File 4
    elements.append(Paragraph("4. 05_venue_management.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> CRUD operations for venue management.", body_style))

    venue_funcs = [
        ["Function", "Parameters", "Return", "Concepts Used"],
        ["add_venue", "name, location, capacity, facilities", "venue_id", "RETURNING clause, variable declaration"],
        ["view_venues", "None", "TABLE", "RETURN QUERY, column aliases"],
        ["update_venue", "id, name", "INTEGER", "IF NOT FOUND, exception handling"],
        ["delete_venue", "id", "INTEGER", "IF NOT FOUND, exception handling"],
        ["check_venue_capacity", "id", "TABLE", "Simple SELECT query"],
    ]

    venue_table = Table(venue_funcs, colWidths=[1.2*inch, 1.5*inch, 1*inch, 2.3*inch])
    venue_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(venue_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b> DECLARE section for variables, RETURNING INTO for capturing inserted values, IF NOT FOUND for checking affected rows, RAISE EXCEPTION for error handling", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 5
    elements.append(Paragraph("5. event_management_procedure.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Event CRUD and search operations.", body_style))

    event_funcs = [
        ["Function", "Key Concepts"],
        ["add_event", "Validation (start_time < end_time), RETURNING INTO, time comparison check"],
        ["view_all_events", "Simple RETURN QUERY"],
        ["update_event", "IF NOT FOUND, exception handling"],
        ["cancel_event", "Soft delete (status = 'cancelled'), IF NOT FOUND"],
        ["search_events_by_type", "Filter with status != 'cancelled'"],
        ["search_events_by_date", "BETWEEN operator for date range"],
        ["view_events_by_venue", "Venue-based filtering"],
    ]

    event_table = Table(event_funcs, colWidths=[1.5*inch, 4.5*inch])
    event_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(event_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b> Input validation, Soft delete pattern, Date range queries with BETWEEN", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 6
    elements.append(Paragraph("6. participant_management_procedure.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Participant registration and management.", body_style))

    part_funcs = [
        ["Function", "Parameters", "Return", "Concepts Used"],
        ["register_participant", "sic, name, email, year", "sic", "Simple INSERT"],
        ["view_participants", "None", "TABLE(sic, name)", "RETURN QUERY with column subset"],
        ["update_participant", "sic, name", "INTEGER", "IF NOT FOUND, exception handling"],
        ["search_participant_by_email", "email", "TABLE", "Email-based search"],
        ["delete_participant", "sic", "INTEGER", "IF NOT FOUND, exception handling"],
    ]

    part_table = Table(part_funcs, colWidths=[1.3*inch, 1.3*inch, 1*inch, 2.4*inch])
    part_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(part_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b> Primary key-based participant identification (SIC), Partial data exposure, Exception handling for non-existent records", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 7
    elements.append(Paragraph("7. registration_management_procedure.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Event registration and attendance tracking.", body_style))

    reg_funcs = [
        ["Function", "Key Concepts"],
        ["register_for_event", "INSERT with NOW(), string concatenation"],
        ["view_registrations", "3-table JOIN (Registrations, Participants, Events)"],
        ["view_registrations_by_event", "Filtered JOIN with event_id parameter"],
        ["cancel_registration", "Composite key DELETE, IF NOT FOUND"],
        ["mark_attendance", "Status UPDATE (registered → present/absent), IF NOT FOUND"],
        ["check_event_registration_count", "SELECT INTO for COUNT aggregation"],
    ]

    reg_table = Table(reg_funcs, colWidths=[1.8*inch, 4.2*inch])
    reg_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(reg_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b> Composite primary key handling, Multi-table JOINs, SELECT INTO for aggregates, Attendance status workflow", body_style))

    elements.append(PageBreak())

    # File 8
    elements.append(Paragraph("8. performance_judging.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Performance creation and judge scoring system.", body_style))

    perf_funcs = [
        ["Function", "Key Concepts"],
        ["create_performance", "Validation chain: registration exists, attendance='present', no duplicate performance"],
        ["assign_judge_score", "4 validations: performance exists, judge exists, score 0-100, no duplicate scoring"],
        ["update_judge_score", "Score range validation (0-100), IF NOT FOUND"],
        ["view_scores_by_performance", "JOIN with Judges, ORDER BY score DESC"],
        ["view_scores_by_event", "Aggregation AVG(), GROUP BY participant, ROUND()"],
        ["show_leaderboard", "Window function DENSE_RANK() OVER, AVG() aggregation, ranking"],
        ["performance_statistics", "Multiple aggregates (COUNT, MAX, MIN, AVG), formatted text report"],
    ]

    perf_table = Table(perf_funcs, colWidths=[1.8*inch, 4.2*inch])
    perf_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(perf_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b>", heading3_style))
    concepts_perf = [
        "Exception Handling: Multiple RAISE EXCEPTION for business rule validation",
        "Aggregation: AVG(), COUNT(), MAX(), MIN(), GROUP BY",
        "Window Functions: DENSE_RANK() OVER (ORDER BY) for ranking participants",
        "Variable Declarations: Multiple DECLARE variables for statistics",
        "String Formatting: CHR(10) for newlines, concatenation for reports",
        "Business Logic: Attendance verification before performance creation",
        "Duplicate Prevention: Count checks before inserts"
    ]
    for c in concepts_perf:
        elements.append(Paragraph(f"• {c}", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 9
    elements.append(Paragraph("9. awards_management.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Award creation and winner assignment.", body_style))

    award_funcs = [
        ["Function", "Key Concepts"],
        ["create_award", "4 validations: event exists, position>0, prize>=0, no duplicate position"],
        ["view_awards_by_event", "Filtered SELECT with ORDER BY position"],
        ["assign_award_winner", "Award lookup, registration verification, duplicate winner check"],
        ["view_award_winners", "3-table JOIN (Award_Winners, Awards, Participants)"],
        ["update_award_details", "IF NOT FOUND, exception handling"],
        ["generate_award_report", "Explicit CURSOR for row-by-row processing, COALESCE, formatted report"],
    ]

    award_table = Table(award_funcs, colWidths=[1.8*inch, 4.2*inch])
    award_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(award_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b>", heading3_style))
    concepts_award = [
        "Exception Handling: Multiple validation points with RAISE EXCEPTION",
        "Cursor Processing: OPEN, FETCH, LOOP, EXIT WHEN NOT FOUND, CLOSE",
        "LEFT JOIN: For awards without assigned winners",
        "NULL Handling: COALESCE for optional prize amounts and unassigned winners",
        "Report Generation: Multi-line formatted text output"
    ]
    for c in concepts_award:
        elements.append(Paragraph(f"• {c}", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 10
    elements.append(Paragraph("10. schedule_calendar.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Calendar views and schedule conflict detection.", body_style))

    sched_funcs = [
        ["Function", "Key Concepts"],
        ["view_full_calendar", "Filter cancelled events, ORDER BY date/time"],
        ["view_events_by_month", "Month validation (1-12), EXTRACT(MONTH/YEAR FROM date)"],
        ["view_upcoming_events", "CURRENT_DATE comparison for future events"],
        ["check_venue_availability", "Count-based availability check, returns formatted text"],
        ["detect_schedule_conflicts", "SELF-JOIN for conflict detection, cursor processing"],
    ]

    sched_table = Table(sched_funcs, colWidths=[1.8*inch, 4.2*inch])
    sched_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(sched_table)

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Key Concepts:</b>", heading3_style))
    concepts_sched = [
        "Date Functions: EXTRACT(MONTH FROM date), EXTRACT(YEAR FROM date), CURRENT_DATE",
        "Input Validation: Month range check (1-12)",
        "Self-JOIN: e1 JOIN e2 ON same_venue AND same_date AND overlapping_times",
        "Time Overlap Logic: e1.start < e2.end AND e1.end > e2.start",
        "Cursor Processing: For iterating through conflicts"
    ]
    for c in concepts_sched:
        elements.append(Paragraph(f"• {c}", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 11
    elements.append(Paragraph("11. menu.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Interactive terminal menu system.", body_style))
    elements.append(Paragraph("<b>Features:</b>", heading3_style))
    elements.append(Paragraph("8 main modules (Venue, Event, Participant, Registration, Schedule, Performance, Awards, Reports)", body_style))
    elements.append(Paragraph("Nested sub-menus for each module", body_style))
    elements.append(Paragraph("Dynamic option handling using SELECT CASE and \\gset", body_style))
    elements.append(Paragraph("Conditional execution with \\if :variable_is_value", body_style))
    elements.append(Paragraph("User prompts with \\prompt", body_style))

    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("<b>Concepts Used:</b> psql meta-commands (\\i, \\echo, \\prompt, \\gset), Conditional script execution, Variable interpolation, Modular menu design", body_style))

    elements.append(Spacer(1, 0.3*inch))

    # File 12
    elements.append(Paragraph("12. master.sql", heading2_style))
    elements.append(Paragraph("<b>Purpose:</b> Master script to load all modules in correct order.", body_style))
    elements.append(Paragraph("<b>Execution Order:</b> schema → indexes → data → procedures → menu", body_style))
    elements.append(Paragraph("<b>Concepts Used:</b> \\i include directive for modular SQL files", body_style))

    elements.append(PageBreak())

    # ==================== SECTION E: CONCEPTS SUMMARY ====================
    elements.append(Paragraph("E. CONCEPTS SUMMARY BY CATEGORY", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    # Exception Handling
    elements.append(Paragraph("1. Exception Handling (RAISE EXCEPTION)", heading3_style))
    exc_data = [
        ["File", "Functions"],
        ["participant_management_procedure.sql", "update_participant, delete_participant"],
        ["registration_management_procedure.sql", "cancel_registration, mark_attendance"],
        ["event_management_procedure.sql", "add_event, update_event, cancel_event"],
        ["performance_judging.sql", "create_performance, assign_judge_score, update_judge_score, performance_statistics"],
        ["awards_management.sql", "create_award, assign_award_winner, update_award_details, generate_award_report"],
        ["schedule_calendar.sql", "view_events_by_month, check_venue_availability"],
        ["venue_management.sql", "update_venue, delete_venue"],
    ]
    exc_table = Table(exc_data, colWidths=[2.5*inch, 3.5*inch])
    exc_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(exc_table)

    elements.append(Spacer(1, 0.2*inch))

    # Aggregation
    elements.append(Paragraph("2. Aggregation Functions (AVG, COUNT, MAX, MIN)", heading3_style))
    agg_data = [
        ["File", "Functions"],
        ["registration_management_procedure.sql", "check_event_registration_count (COUNT)"],
        ["performance_judging.sql", "view_scores_by_event (AVG), show_leaderboard (AVG), performance_statistics (COUNT, AVG, MAX, MIN)"],
    ]
    agg_table = Table(agg_data, colWidths=[2.5*inch, 3.5*inch])
    agg_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(agg_table)

    elements.append(Spacer(1, 0.2*inch))

    # Window Functions
    elements.append(Paragraph("3. Window Functions", heading3_style))
    win_data = [
        ["File", "Functions"],
        ["performance_judging.sql", "show_leaderboard - DENSE_RANK() OVER (ORDER BY)"],
    ]
    win_table = Table(win_data, colWidths=[2.5*inch, 3.5*inch])
    win_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(win_table)

    elements.append(Spacer(1, 0.2*inch))

    # Cursors
    elements.append(Paragraph("4. Cursors (Explicit Row-by-Row Processing)", heading3_style))
    cur_data = [
        ["File", "Functions"],
        ["awards_management.sql", "generate_award_report"],
        ["schedule_calendar.sql", "detect_schedule_conflicts"],
    ]
    cur_table = Table(cur_data, colWidths=[2.5*inch, 3.5*inch])
    cur_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(cur_table)

    elements.append(Spacer(1, 0.2*inch))

    # RETURNING Clause
    elements.append(Paragraph("5. RETURNING Clause", heading3_style))
    ret_data = [
        ["File", "Functions"],
        ["venue_management.sql", "add_venue"],
        ["event_management_procedure.sql", "add_event"],
        ["performance_judging.sql", "create_performance"],
        ["awards_management.sql", "create_award"],
    ]
    ret_table = Table(ret_data, colWidths=[2.5*inch, 3.5*inch])
    ret_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(ret_table)

    elements.append(Spacer(1, 0.2*inch))

    # IF NOT FOUND
    elements.append(Paragraph("6. IF NOT FOUND Pattern", heading3_style))
    iff_data = [
        ["File", "Functions"],
        ["venue_management.sql", "update_venue, delete_venue"],
        ["participant_management_procedure.sql", "update_participant, delete_participant"],
        ["registration_management_procedure.sql", "cancel_registration, mark_attendance"],
        ["event_management_procedure.sql", "update_event, cancel_event"],
        ["performance_judging.sql", "update_judge_score"],
        ["awards_management.sql", "assign_award_winner, update_award_details"],
    ]
    iff_table = Table(iff_data, colWidths=[2.5*inch, 3.5*inch])
    iff_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(iff_table)

    elements.append(Spacer(1, 0.2*inch))

    # JOINs
    elements.append(Paragraph("7. JOINs", heading3_style))
    join_data = [
        ["Type", "File", "Functions"],
        ["INNER JOIN", "registration_management_procedure.sql", "view_registrations, view_registrations_by_event"],
        ["INNER JOIN", "performance_judging.sql", "view_scores_by_performance, show_leaderboard"],
        ["INNER JOIN", "awards_management.sql", "view_award_winners"],
        ["LEFT JOIN", "awards_management.sql", "generate_award_report (awards without winners)"],
        ["SELF JOIN", "schedule_calendar.sql", "detect_schedule_conflicts"],
    ]
    join_table = Table(join_data, colWidths=[1*inch, 2.5*inch, 2.5*inch])
    join_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(join_table)

    elements.append(PageBreak())

    # ==================== SECTION F: COMPLETE WORKFLOW ====================
    elements.append(Paragraph("F. COMPLETE WORKFLOW: FROM PARTICIPANT REGISTRATION TO AWARD", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    workflow_intro = """
    This section describes the complete end-to-end workflow of the system, from initial setup through award distribution.
    """
    elements.append(Paragraph(workflow_intro, body_style))

    # Phase 1
    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("PHASE 1: PRE-EVENT SETUP", heading2_style))

    phase1_data = [
        ["Step", "Operation", "Function", "Details"],
        ["1", "Add Venues", "add_venue()", "Returns venue_id, validates capacity > 0"],
        ["2", "Create Events", "add_event()", "Returns event_id, validates start < end time"],
        ["3", "Add Judges", "INSERT INTO Judges", "Email must be UNIQUE"],
        ["4", "Define Awards", "create_award()", "Validates position > 0, prize >= 0"],
    ]

    phase1_table = Table(phase1_data, colWidths=[0.5*inch, 1.2*inch, 1.5*inch, 2.8*inch])
    phase1_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgreen),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(phase1_table)

    # Phase 2
    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("PHASE 2: PARTICIPANT REGISTRATION", heading2_style))

    phase2_data = [
        ["Step", "Operation", "Function", "Details"],
        ["5", "Register Participant", "register_participant()", "Returns sic, validates email UNIQUE, year 1-5"],
        ["6", "Register for Event", "register_for_event()", "Creates Registration with status='registered'"],
        ["7", "Check Registrations", "view_registrations_by_event()", "Shows all participants for an event"],
    ]

    phase2_table = Table(phase2_data, colWidths=[0.5*inch, 1.5*inch, 1.5*inch, 2.5*inch])
    phase2_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgreen),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(phase2_table)

    # Phase 3
    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("PHASE 3: EVENT DAY OPERATIONS", heading2_style))

    phase3_data = [
        ["Step", "Operation", "Function", "Details"],
        ["8", "Mark Attendance", "mark_attendance()", "Updates status from 'registered' to 'present'"],
        ["9", "Create Performance", "create_performance()", "Validates: registration exists, participant present, no duplicate"],
    ]

    phase3_table = Table(phase3_data, colWidths=[0.5*inch, 1.5*inch, 1.5*inch, 2.5*inch])
    phase3_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgreen),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(phase3_table)

    # Phase 4
    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("PHASE 4: JUDGING & SCORING", heading2_style))

    phase4_data = [
        ["Step", "Operation", "Function", "Details"],
        ["10", "Assign Judge Scores", "assign_judge_score()", "4 validations: performance, judge, score 0-100, no duplicate"],
        ["11", "Update Scores", "update_judge_score()", "Validates new_score 0-100"],
        ["12", "View Leaderboard", "show_leaderboard()", "Uses DENSE_RANK(), AVG() for ranking"],
        ["13", "View Statistics", "performance_statistics()", "Formatted report: total, highest, lowest, avg, top performer"],
    ]

    phase4_table = Table(phase4_data, colWidths=[0.5*inch, 1.5*inch, 1.5*inch, 2.5*inch])
    phase4_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgreen),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(phase4_table)

    # Phase 5
    elements.append(Spacer(1, 0.2*inch))
    elements.append(Paragraph("PHASE 5: AWARD DISTRIBUTION", heading2_style))

    phase5_data = [
        ["Step", "Operation", "Function", "Details"],
        ["14", "Assign Award Winners", "assign_award_winner()", "Validates: award exists, participant registered, no duplicate winner"],
        ["15", "View Award Winners", "view_award_winners()", "3-table JOIN: award_name, sic, winner_name"],
        ["16", "Generate Award Report", "generate_award_report()", "Cursor-based, shows position, award, winner, prize"],
    ]

    phase5_table = Table(phase5_data, colWidths=[0.5*inch, 1.5*inch, 1.5*inch, 2.5*inch])
    phase5_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgreen),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('TOPPADDING', (0, 0), (-1, 0), 8),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 8),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(phase5_table)

    elements.append(Spacer(1, 0.3*inch))
    elements.append(Paragraph("Supporting Operations (Available Throughout):", heading3_style))
    supporting = [
        "Schedule Management: view_full_calendar(), view_events_by_month(), view_upcoming_events(), check_venue_availability(), detect_schedule_conflicts()",
        "Event Management: update_event(), cancel_event(), search_events_by_type(), search_events_by_date()",
        "Participant Management: update_participant(), delete_participant(), search_participant_by_email()",
        "Reports: event_participation_report(), registration_summary(), attendance_report(), venue_utilization_report()"
    ]
    for s in supporting:
        elements.append(Paragraph(f"• {s}", body_style))

    elements.append(PageBreak())

    # ==================== SECTION G: SUMMARY STATISTICS ====================
    elements.append(Paragraph("G. SUMMARY STATISTICS", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    stats_data = [
        ["Metric", "Count"],
        ["Tables", "9"],
        ["Indexes", "11"],
        ["Stored Functions", "47+"],
        ["Check Constraints", "8"],
        ["Foreign Key Relationships", "10"],
        ["Unique Constraints", "3"],
        ["Functions with Exception Handling", "20+"],
        ["Functions with Aggregation", "5"],
        ["Functions with Cursors", "2"],
        ["Functions with Window Functions", "1"],
    ]

    stats_table = Table(stats_data, colWidths=[3*inch, 3*inch])
    stats_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 11),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
        ('TOPPADDING', (0, 0), (-1, 0), 10),
        ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 1), (-1, -1), 10),
        ('GRID', (0, 0), (-1, -1), 1, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
    ]))
    elements.append(stats_table)

    elements.append(PageBreak())

    # ==================== SECTION H: KEY TAKEAWAYS ====================
    elements.append(Paragraph("H. KEY TAKEAWAYS", heading1_style))
    elements.append(Spacer(1, 0.2*inch))

    takeaways = [
        ("1. Modular Design", "Each SQL file handles a specific domain (venue, event, participant, registration, performance, awards, schedule)"),
        ("2. Data Integrity", "Extensive use of CHECK constraints, FOREIGN KEYs, and UNIQUE constraints ensure data quality"),
        ("3. Business Logic in Database", "Validation rules implemented as stored procedures rather than application code"),
        ("4. Exception Handling", "Consistent use of IF NOT FOUND and RAISE EXCEPTION for robust error handling"),
        ("5. Advanced SQL Features", "Cursors, window functions, aggregation, self-joins, composite keys demonstrate PostgreSQL capabilities"),
        ("6. Report Generation", "Formatted text reports using string concatenation and cursor loops"),
        ("7. Interactive Interface", "Terminal-based menu system using psql meta-commands for user interaction"),
    ]

    for title, desc in takeaways:
        elements.append(Paragraph(title, heading3_style))
        elements.append(Paragraph(desc, body_style))
        elements.append(Spacer(1, 0.1*inch))

    elements.append(Spacer(1, 0.5*inch))

    # Footer
    footer_style = ParagraphStyle(
        'Footer',
        parent=body_style,
        alignment=TA_CENTER,
        spaceBefore=0.5*inch
    )
    footer_text = "<b>--- End of Report ---</b><br/>Cultural Event Management System - DBMS Project<br/>Generated on: {}<br/>Database: PostgreSQL with PL/pgSQL".format(datetime.now().strftime("%Y-%m-%d"))

    elements.append(Paragraph(footer_text, footer_style))

    # Build the PDF
    doc.build(elements)
    print("PDF report generated successfully: Cultural_Event_Management_System_Report.pdf")

if __name__ == "__main__":
    create_report()
