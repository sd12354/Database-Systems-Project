-- Creates all tables for the Grade Book system.
-- Run this file first before inserting any data.

PRAGMA foreign_keys = ON;

-- -------------------------------------------------------------
-- Department: tracks academic departments
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Department (
    dept_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    dept_name TEXT    NOT NULL UNIQUE
);

-- -------------------------------------------------------------
-- Course: a single course offering tied to a department
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Course (
    course_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    dept_id       INTEGER NOT NULL,
    course_number TEXT    NOT NULL,
    course_name   TEXT    NOT NULL,
    semester      TEXT    NOT NULL CHECK(semester IN ('Spring', 'Summer', 'Fall')),
    year          INTEGER NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE RESTRICT
);

-- -------------------------------------------------------------
-- Student: a person enrolled in one or more courses
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Student (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    email      TEXT NOT NULL UNIQUE
);

-- -------------------------------------------------------------
-- Enrollment: many-to-many bridge between Student and Course
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Enrollment (
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id    INTEGER NOT NULL,
    course_id     INTEGER NOT NULL,
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)  ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES Course(course_id)    ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- Category: a grading category within a course
--           (e.g. Homework 20%, Tests 50%)
--           All categories for a course must sum to 100%.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Category (
    category_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id     INTEGER NOT NULL,
    category_name TEXT    NOT NULL,
    percentage    REAL    NOT NULL CHECK(percentage > 0 AND percentage <= 100),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- Assignment: a single graded item within a category
--             Weight per assignment = category.percentage / count(assignments in category)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Assignment (
    assignment_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id     INTEGER NOT NULL,
    assignment_name TEXT    NOT NULL,
    max_score       REAL    NOT NULL DEFAULT 100 CHECK(max_score > 0),
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- Grade: a single student's score on a single assignment
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Grade (
    grade_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER NOT NULL,
    assignment_id INTEGER NOT NULL,
    score         REAL    NOT NULL DEFAULT 0 CHECK(score >= 0),
    UNIQUE (enrollment_id, assignment_id),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollment(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id) ON DELETE CASCADE
);
