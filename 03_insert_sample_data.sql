BEGIN;

INSERT INTO Venues (venue_name, location, capacity, facilities) VALUES
('Main Auditorium', 'Academic Block, Ground Floor', 400, 'AC, Stage, AV System, Projector'),
('Open Air Theatre (OAT)', 'Campus Central Area', 800, 'Natural Setting, Stage, Sound System'),
('Lecture Theatre 1', 'Academic Block, 1st Floor', 120, 'Digital Board, AC, Sound System'),
('Lecture Theatre 2', 'Academic Block, 2nd Floor', 120, 'Digital Board, AC, Sound System'),
('Seminar Hall', 'Admin Block, 2nd Floor', 150, 'Projector, AC, Sound System'),
('Sky Lab', 'CSE Block, 3rd Floor', 100, 'Wi-Fi, Collaborative Space, AC'),
('SunDeck (Sports Complex)', 'Sports Arena', 500, 'Open Space, Floodlights, Seating'),
('Central Library', 'Library Block', 200, 'Reading Cabins, AC, Wi-Fi');

INSERT INTO Events (event_name, event_type, event_date, start_time, end_time, venue_id, max_participants, description, status) VALUES
('Singing', 'cultural', '2025-04-25', '10:00:00', '12:00:00', 1, 400, 'Opening ceremony of the annual cultural fest Zygon', 'active'),
('Walk of Elegance ', 'fashion', '2025-04-25', '18:00:00', '21:00:00', 1, 30, 'Flagship fashion show competition of Zygon', 'active'),
('Cultural Dance', 'dance', '2025-04-26', '14:00:00', '18:00:00', 1, 20, 'Inter-house group dance competition', 'active'),
('Cultural Nite Dance - Folk Dance', 'dance', '2025-04-26', '19:00:00', '22:00:00', 2, 500, 'Showcase of Indian folk and tribal dances', 'active'),
('Battle of Bands - Musical Compitition', 'music', '2025-04-27', '17:00:00', '22:00:00', 2, 15, 'Rock and pop band competition under the stars', 'active'),
('Nukkad Natak (Street Play)', 'drama', '2025-04-25', '16:00:00', '18:00:00', 2, 12, 'Street theatre competition by the Dramatic Club', 'active'),
('Poetry Slam (LIT Club)', 'literary', '2025-04-25', '14:00:00', '17:00:00', 3, 25, 'Original poetry recitation competition', 'active'),
('Cultural Painting Competition', 'fine_arts', '2025-04-26', '10:00:00', '13:00:00', 6, 50, 'Organized by the Creative Club', 'active'),
('Stand-up Comedy Night', 'comedy', '2025-04-26', '16:00:00', '19:00:00', 5, 12, 'Comedy competition for aspiring artists', 'active'),
('One Act Play Festival', 'drama', '2025-04-27', '14:00:00', '18:00:00', 1, 10, 'Short drama performances in the Auditorium', 'active'),
('Photography Contest(Cultural Theme) - Pixels', 'fine_arts', '2025-04-26', '09:00:00', '17:00:00', 6, 40, 'On-campus photography competition', 'active');

INSERT INTO Participants (sic, name, email, phone, college, department, year_of_study) VALUES
('24bcsg85', 'Kundan Kumar', 'kundan.kumar@email.com', '9876543210', 'Silicon University', 'Computer Science', 2),
('24bcsg84', 'Soumya Ranjan Pradhan', 'soumya.rp@email.com', '9876543211', 'Silicon University', 'Computer Science', 2),
('24bcsg83', 'Aneesh Das Gupta', 'aneesh.dg@email.com', '9876543212', 'Silicon University', 'Computer Science', 2),
('24bcsg78', 'Divya Mahato', 'Divya.mahato@email.com', '9876543213', 'Silicon University', 'Computer Science', 2),
('24beca23', 'Swastik Routray',  'swastik.routray@email.com', '9876543214', 'Silicon University', 'Computer Science', 2),
('24bcsa25', 'Ashutosh Mohanty', 'ashutosh.mohanty@email.com', '9876543215', 'Silicon University', 'Electrical', 2),
('25beca34', 'Rohan Mehta', 'rohan.mehta@email.com', '9876543216', 'Silicon University', 'Electrical', 1),
('25bcsg42', 'Jyoti Nair', 'divya.nair@email.com', '9876543217', 'Silicon University', 'Computer Science', 1),
('25bee45', 'Karan Gupta', 'karan.gupta@email.com', '9876543218', 'Silicon University', 'Electronics', 1),
('23bcsf32', 'Neha Sharma', 'neha.sharma@email.com', '9876543219', 'Silicon University', 'Computer Science', 3),
('24bcsg42', 'Shibani Mishra', 'shibani.m@email.com', '9876543220', 'Silicon University', 'Computer Science', 2),
('24bcsf23', 'Smruti Ranjan Nayak', 'smruti.n@email.com', '9876543221', 'Silicon University', 'Computer Science', 2),
('24bcsh51', 'Deepakshi Nayak', 'deepakshi.n@email.com', '9876543222', 'Silicon University', 'Computer Science', 2);

INSERT INTO Judges (judge_name, expertise, email) VALUES
('Dr. Jaideep Talukdar', 'Classical Dance, Bharatanatyam', 'jaideep@silicon.ac.in'),
('Dr. Gitisudha Giri', 'Indian Classical Music, Vocal', 'gitisudha.giri@silicon.ac.in'),
('Dr. Debabrata Kar', 'Theatre, Drama Direction', 'debabrata.kar@silicon.ac.in'),
('Dr. Aruna Dash', 'Poetry, Literature', 'aruna.dash@silicon.ac.in'),
('Dr. Sudhansu Kumar Pati', 'Fashion Design, Styling', 'sudhansu.pati@silicon.ac.in'),
('Dr. Priyanka Kar', 'Stand-up Comedy', 'priyanka.kar@silicon.ac.in'),
('Dr. Sanjeev Kumar Dash', 'Fine Arts, Painting', 'sanjeev.dash@silicon.ac.in'),
('Dr. Dharitri Moharatha', 'Debate, Public Speaking', 'dharitri.moharatha@silicon.ac.in'),
('Dr. Ajit Kumar Behera', 'Instrumental Music', 'ajit.behera@silicon.ac.in'),
('Ms. Alka Dash', 'Street Theatre', 'alka.dash@silicon.ac.in');

INSERT INTO Registrations (sic, event_id, attendance_status) VALUES
('24bcsg85', 1, 'present'),
('24bcsg84', 1, 'present'),
('24bcsg83', 1, 'registered'),
('24bcsg78', 2, 'present'),
('24beca23', 2, 'present'),
('24bcsa25', 2, 'registered'),
('25beca34', 3, 'present'),
('25bcsg42', 3, 'registered'),
('25bee45', 4, 'present'),
('23bcsf32', 4, 'present');

INSERT INTO Performances (sic, event_id, performance_date) VALUES
('24bcsg85', 1, '2025-04-25 14:30:00'),
('24bcsg84', 1, '2025-04-25 15:00:00'),
('24bcsg78', 2, '2025-04-26 17:30:00'),
('24beca23', 2, '2025-04-26 18:00:00'),
('25beca34', 3, '2025-04-27 15:30:00'),
('25bee45', 4, '2025-04-25 16:30:00'),
('23bcsf32', 4, '2025-04-25 17:00:00');

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
(1, '24bcsg84'),
(2, '24bcsg85'),
(3, '24bcsg78'),
(5, '25bee45');

COMMIT;

\echo 'Sample data inserted successfully with updated SIC keys and Silicon University Teachers!';
