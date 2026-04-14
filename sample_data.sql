-- Sample data: 2 departments, 3 courses, 10 students.
-- Students David Quincy, Frank Quiroga, and Iris Qian have 'Q' in their last names (used for Task 10 testing).
-- CSCI 101 grade distribution: 10% Participation, 20% Homework
--                               (5 assignments), 50% Tests (2),
--                               20% Projects (1)
-- CSCI 350 grade distribution: 10% Participation, 30% Homework
--                               (3 assignments), 40% Tests (2),
--                               20% Projects (2)
-- MATH 201 grade distribution: 20% Homework (4, max 50 pts),
--                               40% Midterm (1), 40% Final (1)

-- ── Departments ────────────────────────────────────────────
INSERT INTO Department (dept_name) VALUES ('Computer Science');   -- dept_id 1
INSERT INTO Department (dept_name) VALUES ('Mathematics');         -- dept_id 2

-- ── Courses ────────────────────────────────────────────────
INSERT INTO Course (dept_id, course_number, course_name, semester, year)
    VALUES (1, 'CSCI 101', 'Introduction to Computer Science',    'Spring', 2026); -- course_id 1
INSERT INTO Course (dept_id, course_number, course_name, semester, year)
    VALUES (1, 'CSCI 350', 'Structure of Programming Languages',  'Spring', 2026); -- course_id 2
INSERT INTO Course (dept_id, course_number, course_name, semester, year)
    VALUES (2, 'MATH 201', 'Discrete Mathematics',                'Fall',   2025); -- course_id 3

-- ── Students ───────────────────────────────────────────────
INSERT INTO Student (first_name, last_name, email) VALUES ('Alice',  'Johnson',  'ajohnson@university.edu');  -- 1
INSERT INTO Student (first_name, last_name, email) VALUES ('Bob',    'Smith',    'bsmith@university.edu');    -- 2
INSERT INTO Student (first_name, last_name, email) VALUES ('Carol',  'Williams', 'cwilliams@university.edu');-- 3
INSERT INTO Student (first_name, last_name, email) VALUES ('David',  'Quincy',   'dquincy@university.edu');  -- 4  (Q)
INSERT INTO Student (first_name, last_name, email) VALUES ('Eva',    'Brown',    'ebrown@university.edu');   -- 5
INSERT INTO Student (first_name, last_name, email) VALUES ('Frank',  'Quiroga',  'fquiroga@university.edu'); -- 6  (Q)
INSERT INTO Student (first_name, last_name, email) VALUES ('Grace',  'Lee',      'glee@university.edu');     -- 7
INSERT INTO Student (first_name, last_name, email) VALUES ('Henry',  'Martinez', 'hmartinez@university.edu');-- 8
INSERT INTO Student (first_name, last_name, email) VALUES ('Iris',   'Qian',     'iqian@university.edu');    -- 9  (Q)
INSERT INTO Student (first_name, last_name, email) VALUES ('James',  'Taylor',   'jtaylor@university.edu'); -- 10

-- ── Enrollments ────────────────────────────────────────────
-- CSCI 101: students 1-7  → enrollment_ids 1-7
INSERT INTO Enrollment (student_id, course_id) VALUES (1, 1);
INSERT INTO Enrollment (student_id, course_id) VALUES (2, 1);
INSERT INTO Enrollment (student_id, course_id) VALUES (3, 1);
INSERT INTO Enrollment (student_id, course_id) VALUES (4, 1);
INSERT INTO Enrollment (student_id, course_id) VALUES (5, 1);
INSERT INTO Enrollment (student_id, course_id) VALUES (6, 1);
INSERT INTO Enrollment (student_id, course_id) VALUES (7, 1);
-- CSCI 350: students 4-10 → enrollment_ids 8-14
INSERT INTO Enrollment (student_id, course_id) VALUES (4,  2);
INSERT INTO Enrollment (student_id, course_id) VALUES (5,  2);
INSERT INTO Enrollment (student_id, course_id) VALUES (6,  2);
INSERT INTO Enrollment (student_id, course_id) VALUES (7,  2);
INSERT INTO Enrollment (student_id, course_id) VALUES (8,  2);
INSERT INTO Enrollment (student_id, course_id) VALUES (9,  2);
INSERT INTO Enrollment (student_id, course_id) VALUES (10, 2);
-- MATH 201: students 1,2,3,8,9,10 → enrollment_ids 15-20
INSERT INTO Enrollment (student_id, course_id) VALUES (1,  3);
INSERT INTO Enrollment (student_id, course_id) VALUES (2,  3);
INSERT INTO Enrollment (student_id, course_id) VALUES (3,  3);
INSERT INTO Enrollment (student_id, course_id) VALUES (8,  3);
INSERT INTO Enrollment (student_id, course_id) VALUES (9,  3);
INSERT INTO Enrollment (student_id, course_id) VALUES (10, 3);

-- ── Categories ─────────────────────────────────────────────
-- CSCI 101 (course_id 1) → category_ids 1-4
INSERT INTO Category (course_id, category_name, percentage) VALUES (1, 'Participation', 10);
INSERT INTO Category (course_id, category_name, percentage) VALUES (1, 'Homework',      20);
INSERT INTO Category (course_id, category_name, percentage) VALUES (1, 'Tests',         50);
INSERT INTO Category (course_id, category_name, percentage) VALUES (1, 'Projects',      20);
-- CSCI 350 (course_id 2) → category_ids 5-8
INSERT INTO Category (course_id, category_name, percentage) VALUES (2, 'Participation', 10);
INSERT INTO Category (course_id, category_name, percentage) VALUES (2, 'Homework',      30);
INSERT INTO Category (course_id, category_name, percentage) VALUES (2, 'Tests',         40);
INSERT INTO Category (course_id, category_name, percentage) VALUES (2, 'Projects',      20);
-- MATH 201 (course_id 3) → category_ids 9-11
INSERT INTO Category (course_id, category_name, percentage) VALUES (3, 'Homework', 20);
INSERT INTO Category (course_id, category_name, percentage) VALUES (3, 'Midterm',  40);
INSERT INTO Category (course_id, category_name, percentage) VALUES (3, 'Final',    40);

-- ── Assignments ────────────────────────────────────────────
-- CSCI 101 → assignment_ids 1-9
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (1, 'Participation Overall', 100); -- 1
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (2, 'HW 1',                  100); -- 2
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (2, 'HW 2',                  100); -- 3
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (2, 'HW 3',                  100); -- 4
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (2, 'HW 4',                  100); -- 5
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (2, 'HW 5',                  100); -- 6
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (3, 'Test 1',                100); -- 7
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (3, 'Test 2',                100); -- 8
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (4, 'Project 1',             100); -- 9
-- CSCI 350 → assignment_ids 10-17
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (5, 'Participation Overall', 100); -- 10
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (6, 'HW 1',                  100); -- 11
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (6, 'HW 2',                  100); -- 12
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (6, 'HW 3',                  100); -- 13
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (7, 'Midterm',               100); -- 14
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (7, 'Final Exam',            100); -- 15
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (8, 'Project 1',             100); -- 16
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (8, 'Project 2',             100); -- 17
-- MATH 201 → assignment_ids 18-23
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (9,  'HW 1',        50);  -- 18
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (9,  'HW 2',        50);  -- 19
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (9,  'HW 3',        50);  -- 20
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (9,  'HW 4',        50);  -- 21
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (10, 'Midterm Exam', 100); -- 22
INSERT INTO Assignment (category_id, assignment_name, max_score) VALUES (11, 'Final Exam',   100); -- 23

-- ── Grades for CSCI 101 ────────────────────────────────────
-- enrollment_id: 1=Alice, 2=Bob, 3=Carol, 4=David(Q), 5=Eva, 6=Frank(Q), 7=Grace
-- assignment_id: 1=Participation, 2-6=HW1-5, 7-8=Tests, 9=Project

-- Participation Overall (assignment 1)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 1, 95);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 1, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 1, 92);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 1, 75);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 1, 98);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 1, 85);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 1, 90);
-- HW 1 (assignment 2)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 2, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 2, 75);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 2, 95);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 2, 60);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 2, 100);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 2, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 2, 85);
-- HW 2 (assignment 3)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 3, 92);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 3, 80);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 3, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 3, 65);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 3, 97);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 3, 72);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 3, 91);
-- HW 3 (assignment 4)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 4, 85);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 4, 70);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 4, 90);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 4, 55);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 4, 100);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 4, 80);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 4, 88);
-- HW 4 (assignment 5)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 5, 90);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 5, 65);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 5, 87);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 5, 70);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 5, 95);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 5, 82);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 5, 93);
-- HW 5 (assignment 6)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 6, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 6, 82);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 6, 91);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 6, 68);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 6, 96);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 6, 75);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 6, 87);
-- Test 1 (assignment 7)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 7, 82);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 7, 68);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 7, 91);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 7, 58);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 7, 94);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 7, 73);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 7, 86);
-- Test 2 (assignment 8)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 8, 87);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 8, 72);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 8, 94);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 8, 63);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 8, 98);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 8, 77);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 8, 89);
-- Project 1 (assignment 9)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (1, 9, 90);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (2, 9, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (3, 9, 95);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (4, 9, 72);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (5, 9, 97);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (6, 9, 85);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (7, 9, 92);

-- ── Grades for CSCI 350 ────────────────────────────────────
-- enrollment_id: 8=David(Q), 9=Eva, 10=Frank(Q), 11=Grace,
--                12=Henry, 13=Iris(Q), 14=James
-- assignment_ids: 10-17

-- Participation Overall (assignment 10)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  10, 80);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  10, 95);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 10, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 10, 92);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 10, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 10, 90);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 10, 85);
-- HW 1 (assignment 11)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  11, 72);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  11, 98);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 11, 84);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 11, 89);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 11, 76);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 11, 91);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 11, 82);
-- HW 2 (assignment 12)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  12, 68);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  12, 100);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 12, 79);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 12, 85);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 12, 73);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 12, 93);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 12, 78);
-- HW 3 (assignment 13)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  13, 75);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  13, 96);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 13, 81);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 13, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 13, 70);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 13, 87);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 13, 80);
-- Midterm (assignment 14)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  14, 65);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  14, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 14, 76);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 14, 82);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 14, 71);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 14, 90);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 14, 77);
-- Final Exam (assignment 15)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  15, 70);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  15, 91);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 15, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 15, 86);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 15, 74);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 15, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 15, 82);
-- Project 1 (assignment 16)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  16, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  16, 94);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 16, 85);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 16, 91);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 16, 80);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 16, 96);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 16, 88);
-- Project 2 (assignment 17)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (8,  17, 82);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (9,  17, 97);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (10, 17, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (11, 17, 93);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (12, 17, 83);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (13, 17, 98);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (14, 17, 90);

-- ── Grades for MATH 201 ────────────────────────────────────
-- enrollment_id: 15=Alice, 16=Bob, 17=Carol, 18=Henry, 19=Iris(Q), 20=James
-- assignment_ids: 18-23 (HW max=50, exams max=100)

-- HW 1 (assignment 18, max 50)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (15, 18, 45);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (16, 18, 38);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (17, 18, 48);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (18, 18, 42);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (19, 18, 50);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (20, 18, 40);
-- HW 2 (assignment 19, max 50)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (15, 19, 42);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (16, 19, 35);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (17, 19, 46);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (18, 19, 40);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (19, 19, 48);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (20, 19, 37);
-- HW 3 (assignment 20, max 50)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (15, 20, 47);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (16, 20, 40);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (17, 20, 49);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (18, 20, 38);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (19, 20, 50);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (20, 20, 43);
-- HW 4 (assignment 21, max 50)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (15, 21, 44);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (16, 21, 33);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (17, 21, 47);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (18, 21, 41);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (19, 21, 49);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (20, 21, 36);
-- Midterm Exam (assignment 22, max 100)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (15, 22, 80);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (16, 22, 65);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (17, 22, 88);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (18, 22, 74);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (19, 22, 92);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (20, 22, 70);
-- Final Exam (assignment 23, max 100)
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (15, 23, 85);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (16, 23, 70);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (17, 23, 91);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (18, 23, 78);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (19, 23, 94);
INSERT INTO Grade (enrollment_id, assignment_id, score) VALUES (20, 23, 75);
