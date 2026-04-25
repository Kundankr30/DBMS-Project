INSERT INTO Venues (venue_name, location, capacity, facilities) VALUES
('Main Auditorium', 'Campus Block A, Ground Floor', 500, 'Stage, Sound System, Lighting, Projector'),
('Open Air Theatre', 'Campus Central Garden', 800, 'Natural Setting, Sound System, Stage'),
('Seminar Hall 1', 'Block B, 2nd Floor', 150, 'Projector, AC, Sound System'),
('Dance Studio', 'Cultural Block, Ground Floor', 100, 'Mirrors, Sound System, Wooden Floor'),
('Music Room', 'Cultural Block, 1st Floor', 80, 'Piano, Drums, Sound System'),
('Art Gallery', 'Library Block, Ground Floor', 200, 'Display Boards, Lighting, AC'),
('Conference Room', 'Admin Block, 3rd Floor', 50, 'Projector, AC, Video Conferencing'),
('Sports Complex Hall', 'Sports Block, Indoor Arena', 300, 'Flexible Seating, Sound System');

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

INSERT INTO Participants (sic, name, email, phone, college, department, year_of_study) VALUES
('24CSE001', 'Rahul Sharma', 'rahul.sharma@email.com', '9876543210', 'Silicon University', 'Computer Science', 2),
('24CSE002', 'Priya Patel', 'priya.patel@email.com', '9876543211', 'Silicon University', 'Electronics', 3),
('24CSE003', 'Amit Kumar', 'amit.kumar@email.com', '9876543212', 'Silicon University', 'Mechanical', 1),
('24CSE004', 'Sneha Reddy', 'sneha.reddy@email.com', '9876543213', 'Silicon University', 'Civil', 4),
('24CSE005', 'Vikram Singh', 'vikram.singh@email.com', '9876543214', 'Silicon University', 'Computer Science', 2),
('24CSE006', 'Ananya Das', 'ananya.das@email.com', '9876543215', 'Silicon University', 'Electrical', 3),
('24CSE007', 'Rohan Mehta', 'rohan.mehta@email.com', '9876543216', 'Silicon University', 'IT', 1),
('24CSE008', 'Divya Nair', 'divya.nair@email.com', '9876543217', 'Silicon University', 'Computer Science', 4),
('24CSE009', 'Karan Gupta', 'karan.gupta@email.com', '9876543218', 'Silicon University', 'ECE', 2),
('24CSE010', 'Neha Sharma', 'neha.sharma@email.com', '9876543219', 'Silicon University', 'MBA', 3);

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

INSERT INTO Registrations (sic, event_id, attendance_status) VALUES
('24CSE001', 1, 'present'),
('24CSE002', 1, 'present'),
('24CSE003', 1, 'registered'),
('24CSE004', 2, 'present'),
('24CSE005', 2, 'present'),
('24CSE006', 2, 'registered'),
('24CSE007', 3, 'present'),
('24CSE008', 3, 'registered'),
('24CSE009', 4, 'present'),
('24CSE010', 4, 'present');

INSERT INTO Performances (sic, event_id, performance_date) VALUES
('24CSE001', 1, '2025-04-25 14:30:00'),
('24CSE002', 1, '2025-04-25 15:00:00'),
('24CSE004', 2, '2025-04-26 17:30:00'),
('24CSE005', 2, '2025-04-26 18:00:00'),
('24CSE007', 3, '2025-04-27 15:30:00'),
('24CSE009', 4, '2025-04-25 16:30:00'),
('24CSE010', 4, '2025-04-25 17:00:00');

INSERT INTO Performance_Judges (performance_id, judge_id, score, comments) VALUES
(1, 1, 85.50, 'Excellent footwork and expressions'),
(1, 2, 82.00, 'Good synchronization with music'),
(2, 1, 88.00, 'Graceful movements, well choreographed'),
(2, 2, 90.00, 'Outstanding performance'),
(3, 2, 80.00, 'Nice song selection'),
(4, 2, 89.50, 'Great vocals and instrumentation'),
(6, 4, 91.00, 'Beautiful imagery in poetry'),
(7, 4, 79.00, 'Good content, work on delivery');

INSERT INTO Awards (award_name, event_id, position, prize_amount) VALUES
('Best Classical Dancer', 1, 1, 5000.00),
('Classical Dance Runner Up', 1, 2, 3000.00),
('Battle of Bands Winner', 2, 1, 10000.00),
('Battle of Bands Runner Up', 2, 2, 5000.00),
('Best Poet', 4, 1, 2500.00);

INSERT INTO Award_Winners (award_id, sic) VALUES
(1, '24CSE002'),
(2, '24CSE001'),
(3, '24CSE004'),
(5, '24CSE009');

\echo 'Sample data inserted successfully with SIC keys!';
