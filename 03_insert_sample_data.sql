-- Events Portal - Cultural
-- DBMS Lab Project 2025-26 (Semester 4) - Group 2
-- Roll 6: Kundan Kumar - Sample Data Insertion

-- Insert Venues (Sample Data)
INSERT INTO Venues (venue_name, location, capacity, facilities) VALUES
('Main Auditorium', 'Campus Block A, Ground Floor', 500, 'Stage, Sound System, Lighting, Projector'),
('Open Air Theatre', 'Campus Central Garden', 800, 'Natural Setting, Sound System, Stage'),
('Seminar Hall 1', 'Block B, 2nd Floor', 150, 'Projector, AC, Sound System'),
('Dance Studio', 'Cultural Block, Ground Floor', 100, 'Mirrors, Sound System, Wooden Floor'),
('Music Room', 'Cultural Block, 1st Floor', 80, 'Piano, Drums, Sound System'),
('Art Gallery', 'Library Block, Ground Floor', 200, 'Display Boards, Lighting, AC'),
('Conference Room', 'Admin Block, 3rd Floor', 50, 'Projector, AC, Video Conferencing'),
('Sports Complex Hall', 'Sports Block, Indoor Arena', 300, 'Flexible Seating, Sound System');

-- Insert Events (Cultural Categories: dance, music, drama, literary, fashion, comedy, fine_arts, celebration, other)
INSERT INTO Events (event_name, event_type, event_date, start_time, end_time, venue_id, max_participants, description, status) VALUES
('Classical Dance Competition', 'dance', '2025-04-25', '14:00:00', '18:00:00', 4, 20, 'Bharatanatyam, Kathak, Odissi classical dance forms', 'active'),
('Battle of Bands', 'music', '2025-04-26', '17:00:00', '22:00:00', 1, 15, 'Rock and pop band competition', 'active'),
('One Act Play Festival', 'drama', '2025-04-27', '15:00:00', '19:00:00', 2, 10, 'Short drama performances by college groups', 'active'),
('Poetry Slam', 'literary', '2025-04-25', '16:00:00', '19:00:00', 3, 25, 'Original poetry recitation competition', 'active'),
('Fashion Show - Ethnic Wear', 'fashion', '2025-04-28', '18:00:00', '21:00:00', 1, 30, 'Traditional and ethnic fashion showcase', 'active'),
('Stand-up Comedy Night', 'comedy', '2025-04-26', '19:00:00', '22:00:00', 2, 12, 'Comedy competition for aspiring stand-up artists', 'active'),
('Painting Exhibition', 'fine_arts', '2025-04-29', '10:00:00', '18:00:00', 6, 50, 'Canvas painting exhibition and competition', 'active'),
('Spring Festival Celebration', 'celebration', '2025-04-30', '11:00:00', '23:00:00', 2, 500, 'Annual spring cultural festival', 'active'),
('Debate Competition', 'literary', '2025-04-25', '10:00:00', '14:00:00', 3, 16, 'Inter-college debate tournament', 'active'),
('Instrumental Music Concert', 'music', '2025-04-27', '18:00:00', '21:00:00', 5, 8, 'Solo instrumental performances', 'active'),
('Street Play Competition', 'drama', '2025-04-28', '16:00:00', '20:00:00', 2, 12, 'Nukkad Natak street theatre', 'active'),
('Photography Contest', 'fine_arts', '2025-04-29', '09:00:00', '17:00:00', 6, 40, 'Digital and film photography competition', 'active');

-- Insert Participants (updated schema with first_name, last_name, phone, college, department)
INSERT INTO Participants (first_name, last_name, email, phone, college, department, year_of_study) VALUES
('Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210', 'KIIT University', 'Computer Science', 2),
('Priya', 'Patel', 'priya.patel@email.com', '9876543211', 'KIIT University', 'Electronics', 3),
('Amit', 'Kumar', 'amit.kumar@email.com', '9876543212', 'KIIT University', 'Mechanical', 1),
('Sneha', 'Reddy', 'sneha.reddy@email.com', '9876543213', 'KIIT University', 'Civil', 4),
('Vikram', 'Singh', 'vikram.singh@email.com', '9876543214', 'KIIT University', 'Computer Science', 2),
('Ananya', 'Das', 'ananya.das@email.com', '9876543215', 'KIIT University', 'Electrical', 3),
('Rohan', 'Mehta', 'rohan.mehta@email.com', '9876543216', 'KIIT University', 'IT', 1),
('Divya', 'Nair', 'divya.nair@email.com', '9876543217', 'KIIT University', 'Computer Science', 4),
('Karan', 'Gupta', 'karan.gupta@email.com', '9876543218', 'KIIT University', 'ECE', 2),
('Neha', 'Sharma', 'neha.sharma@email.com', '9876543219', 'KIIT University', 'MBA', 3),
('Siddharth', 'Verma', 'siddharth.verma@email.com', '9876543220', 'KIIT University', 'Mechanical', 1),
('Tanvi', 'Iyer', 'tanvi.iyer@email.com', '9876543221', 'KIIT University', 'Computer Science', 2),
('Arjun', 'Rao', 'arjun.rao@email.com', '9876543222', 'KIIT University', 'Chemical', 4),
('Pooja', 'Malhotra', 'pooja.malhotra@email.com', '9876543223', 'KIIT University', 'Biotechnology', 3),
('Aditya', 'Chopra', 'aditya.chopra@email.com', '9876543224', 'KIIT University', 'Physics', 1),
('Meera', 'Kapoor', 'meera.kapoor@email.com', '9876543225', 'KIIT University', 'Mathematics', 2),
('Nikhil', 'Jain', 'nikhil.jain@email.com', '9876543226', 'KIIT University', 'Chemistry', 3),
('Isha', 'Bose', 'isha.bose@email.com', '9876543227', 'KIIT University', 'English', 4),
('Tarun', 'Mishra', 'tarun.mishra@email.com', '9876543228', 'KIIT University', 'History', 2),
('Kavya', 'Krishnan', 'kavya.krishnan@email.com', '9876543229', 'KIIT University', 'Computer Science', 1);

-- Insert Judges (simplified schema)
INSERT INTO Judges (judge_name, expertise, email) VALUES
('Dr. Rajesh Iyer', 'Classical Dance, Bharatanatyam', 'rajesh.iyer@arts.com'),
('Prof. Meena Krishnan', 'Indian Classical Music, Vocal', 'meena.krishnan@arts.com'),
('Shri Anand Sharma', 'Theatre, Drama Direction', 'anand.sharma@theatre.com'),
('Dr. Priya Sundaram', 'Poetry, Literature', 'priya.sundaram@lit.com'),
('Ms. Ritu Verma', 'Fashion Design, Styling', 'ritu.verma@fashion.com'),
('Mr. Karthik Menon', 'Stand-up Comedy', 'karthik.menon@comedy.com'),
('Prof. Arun Banerjee', 'Fine Arts, Painting', 'arun.banerjee@arts.com'),
('Dr. Lakshmi Nair', 'Debate, Public Speaking', 'lakshmi.nair@debate.com'),
('Shri Vikram Seth', 'Instrumental Music', 'vikram.seth@music.com'),
('Ms. Deepa Rajan', 'Street Theatre', 'deepa.rajan@theatre.com');

-- Insert Registrations (attendance_status: registered, present, absent)
INSERT INTO Registrations (participant_id, event_id, attendance_status) VALUES
(1, 1, 'present'),
(2, 1, 'present'),
(3, 1, 'registered'),
(4, 2, 'present'),
(5, 2, 'present'),
(6, 2, 'registered'),
(7, 3, 'present'),
(8, 3, 'registered'),
(9, 4, 'present'),
(10, 4, 'present'),
(11, 5, 'registered'),
(12, 5, 'registered'),
(13, 6, 'present'),
(14, 6, 'registered'),
(15, 7, 'present'),
(16, 7, 'present'),
(17, 8, 'registered'),
(18, 9, 'present'),
(19, 9, 'present'),
(20, 10, 'registered');

-- Insert Performances (simplified schema with UNIQUE on registration_id)
INSERT INTO Performances (registration_id, performance_date) VALUES
(1, '2025-04-25 14:30:00'),
(2, '2025-04-25 15:00:00'),
(4, '2025-04-26 17:30:00'),
(5, '2025-04-26 18:00:00'),
(7, '2025-04-27 15:30:00'),
(9, '2025-04-25 16:30:00'),
(10, '2025-04-25 17:00:00'),
(13, '2025-04-26 19:30:00'),
(15, '2025-04-29 11:00:00'),
(16, '2025-04-29 12:00:00'),
(18, '2025-04-25 10:30:00'),
(19, '2025-04-25 11:30:00');

-- Insert Performance_Judges (score between 0 and 100)
INSERT INTO Performance_Judges (performance_id, judge_id, score, comments) VALUES
(1, 1, 85.50, 'Excellent footwork and expressions'),
(1, 2, 82.00, 'Good synchronization with music'),
(2, 1, 88.00, 'Graceful movements, well choreographed'),
(2, 2, 90.00, 'Outstanding performance'),
(3, 9, 78.50, 'Good energy, needs tighter coordination'),
(3, 2, 80.00, 'Nice song selection'),
(4, 9, 92.00, 'Excellent performance, crowd favorite'),
(4, 2, 89.50, 'Great vocals and instrumentation'),
(5, 3, 86.00, 'Strong acting, good script'),
(5, 10, 84.00, 'Relevant social message'),
(6, 4, 91.00, 'Beautiful imagery in poetry'),
(6, 3, 88.50, 'Good delivery and presence'),
(7, 4, 79.00, 'Good content, work on delivery'),
(8, 6, 87.00, 'Funny content, good timing'),
(8, 3, 85.50, 'Engaged the audience well'),
(9, 7, 93.00, 'Exceptional technique and creativity'),
(10, 7, 89.00, 'Lovely color palette and composition'),
(11, 8, 90.00, 'Strong arguments, good rebuttal'),
(12, 8, 88.00, 'Excellent research and presentation');

-- Insert Awards (position is now INTEGER > 0)
INSERT INTO Awards (award_name, event_id, position, prize_amount) VALUES
('Best Classical Dancer', 1, 1, 5000.00),
('Classical Dance Runner Up', 1, 2, 3000.00),
('Battle of Bands Winner', 2, 1, 10000.00),
('Battle of Bands Runner Up', 2, 2, 5000.00),
('Best Poet', 4, 1, 2500.00),
('Best Comedian', 6, 1, 3000.00),
('Best Painter', 7, 1, 4000.00),
('Best Debater', 9, 1, 3500.00);

-- Insert Award_Winners (winner_id instead of award_winner_id)
INSERT INTO Award_Winners (award_id, registration_id) VALUES
(1, 2),
(2, 1),
(3, 4),
(5, 9),
(6, 13),
(7, 15),
(8, 18);

\echo 'Sample data inserted successfully!';
\echo '8 Venues, 12 Events, 20 Participants, 10 Judges, 20 Registrations, 12 Performances, 18 Scores, 8 Awards, 7 Award Winners inserted.';
