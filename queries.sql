-- Documented SQL queries for Tasks 4-12.
-- Replace placeholder values (shown as ?) with actual IDs
-- when running manually in a SQLite shell.

-- ────────────────────────────────────────────────────────────
-- Task 4: Average, highest, and lowest score on an assignment
-- ────────────────────────────────────────────────────────────
-- Replace the final ? with the desired assignment_id.

SELECT
    a.assignment_name,
    cat.category_name,
    a.max_score,
    ROUND(AVG(g.score), 2) AS avg_score,
    MAX(g.score)           AS highest_score,
    MIN(g.score)           AS lowest_score,
    COUNT(g.score)         AS num_students
FROM Assignment a
JOIN Category cat ON a.category_id   = cat.category_id
JOIN Grade g      ON a.assignment_id = g.assignment_id
WHERE a.assignment_id = ?;

-- Example: stats for assignment_id 7 (CSCI 101, Test 1)
-- SELECT ... WHERE a.assignment_id = 7;


-- ────────────────────────────────────────────────────────────
-- Task 5: List all students in a given course
-- ────────────────────────────────────────────────────────────

SELECT s.student_id,
       s.first_name,
       s.last_name,
       s.email
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.course_id = ?
ORDER BY s.last_name, s.first_name;

-- Example: students in course_id 1 (CSCI 101)
-- SELECT ... WHERE e.course_id = 1;


-- ────────────────────────────────────────────────────────────
-- Task 6: List all students + all scores on every assignment
-- ────────────────────────────────────────────────────────────

SELECT s.last_name,
       s.first_name,
       cat.category_name,
       a.assignment_name,
       g.score,
       a.max_score,
       ROUND(g.score * 100.0 / a.max_score, 1) AS pct
FROM Student s
JOIN Enrollment e  ON s.student_id    = e.student_id
JOIN Grade g       ON e.enrollment_id = g.enrollment_id
JOIN Assignment a  ON g.assignment_id = a.assignment_id
JOIN Category cat  ON a.category_id   = cat.category_id
WHERE e.course_id = ?
ORDER BY s.last_name, s.first_name, cat.category_name, a.assignment_name;


-- ────────────────────────────────────────────────────────────
-- Task 7: Add an assignment to a course
-- ────────────────────────────────────────────────────────────
-- Step 1: insert the assignment into the appropriate category.
INSERT INTO Assignment (category_id, assignment_name, max_score)
VALUES (?, ?, ?);

-- Step 2: initialize a score of 0 for every enrolled student.
INSERT INTO Grade (enrollment_id, assignment_id, score)
SELECT e.enrollment_id, last_insert_rowid(), 0
FROM Enrollment e
WHERE e.course_id = ?;

-- Verify: confirm new assignment appears with default grades.
SELECT s.last_name, s.first_name, g.score
FROM Student s
JOIN Enrollment e ON s.student_id    = e.student_id
JOIN Grade g      ON e.enrollment_id = g.enrollment_id
WHERE g.assignment_id = last_insert_rowid();


-- ────────────────────────────────────────────────────────────
-- Task 8: Change category percentages for a course
-- ────────────────────────────────────────────────────────────
-- Run one UPDATE per category that needs to change.
UPDATE Category
SET percentage = ?
WHERE category_id = ? AND course_id = ?;

-- Verify the categories for that course still sum to 100%.
SELECT SUM(percentage) AS total_pct
FROM Category
WHERE course_id = ?;


-- ────────────────────────────────────────────────────────────
-- Task 9: Add 2 points to every student on an assignment
-- ────────────────────────────────────────────────────────────
-- Scores are capped at max_score so no student exceeds full marks.
UPDATE Grade
SET score = MIN(
    score + 2,
    (SELECT max_score FROM Assignment WHERE assignment_id = ?)
)
WHERE assignment_id = ?;

-- Verify after update:
SELECT s.last_name, s.first_name, g.score
FROM Student s
JOIN Enrollment e ON s.student_id    = e.student_id
JOIN Grade g      ON e.enrollment_id = g.enrollment_id
WHERE g.assignment_id = ?
ORDER BY s.last_name;


-- ────────────────────────────────────────────────────────────
-- Task 10: Add 2 points only to students with 'Q' in last name
-- ────────────────────────────────────────────────────────────
UPDATE Grade
SET score = MIN(
    score + 2,
    (SELECT max_score FROM Assignment WHERE assignment_id = ?)
)
WHERE assignment_id = ?
  AND enrollment_id IN (
      SELECT e.enrollment_id
      FROM Enrollment e
      JOIN Student s ON e.student_id = s.student_id
      WHERE s.last_name LIKE '%Q%'
  );

-- Verify: see who was eligible and their new scores.
SELECT s.last_name, s.first_name, g.score
FROM Student s
JOIN Enrollment e ON s.student_id    = e.student_id
JOIN Grade g      ON e.enrollment_id = g.enrollment_id
WHERE g.assignment_id = ?
  AND s.last_name LIKE '%Q%'
ORDER BY s.last_name;


-- ────────────────────────────────────────────────────────────
-- Task 11: Compute the final grade for a student in a course
-- ────────────────────────────────────────────────────────────
-- Per-category breakdown first (useful for showing work).
SELECT
    cat.category_name,
    cat.percentage                                                AS weight_pct,
    ROUND(AVG(g.score * 100.0 / a.max_score), 2)                 AS category_avg,
    ROUND(cat.percentage * AVG(g.score * 100.0 / a.max_score)
          / 100.0, 2)                                             AS weighted_pts
FROM Student s
JOIN Enrollment e  ON s.student_id    = e.student_id
JOIN Grade g       ON e.enrollment_id = g.enrollment_id
JOIN Assignment a  ON g.assignment_id = a.assignment_id
JOIN Category cat  ON a.category_id   = cat.category_id
WHERE s.student_id = ? AND e.course_id = ?
GROUP BY cat.category_id
ORDER BY cat.category_name;

-- Single final grade value:
SELECT ROUND(SUM(weighted), 2) AS final_grade
FROM (
    SELECT cat.percentage * AVG(g.score * 100.0 / a.max_score) / 100.0 AS weighted
    FROM Student s
    JOIN Enrollment e  ON s.student_id    = e.student_id
    JOIN Grade g       ON e.enrollment_id = g.enrollment_id
    JOIN Assignment a  ON g.assignment_id = a.assignment_id
    JOIN Category cat  ON a.category_id   = cat.category_id
    WHERE s.student_id = ? AND e.course_id = ?
    GROUP BY cat.category_id
);


-- ────────────────────────────────────────────────────────────
-- Task 12: Final grade dropping the lowest score per category
-- ────────────────────────────────────────────────────────────
-- Uses a CTE to rank scores within each category (lowest = rank 1)
-- and excludes rank 1 unless the category has only one assignment.
WITH ranked AS (
    SELECT
        g.score,
        a.max_score,
        a.category_id,
        g.score * 100.0 / a.max_score AS raw_pct,
        ROW_NUMBER() OVER (
            PARTITION BY e.student_id, a.category_id
            ORDER BY g.score * 1.0 / a.max_score ASC
        ) AS rank_asc,
        COUNT(*) OVER (
            PARTITION BY e.student_id, a.category_id
        ) AS total_in_cat
    FROM Grade g
    JOIN Enrollment e ON g.enrollment_id = e.enrollment_id
    JOIN Assignment a ON g.assignment_id  = a.assignment_id
    WHERE e.student_id = ? AND e.course_id = ?
),
kept_grades AS (
    SELECT category_id, AVG(raw_pct) AS cat_avg
    FROM ranked
    WHERE rank_asc > 1 OR total_in_cat = 1
    GROUP BY category_id
)
SELECT ROUND(SUM(cat.percentage * kg.cat_avg / 100.0), 2) AS final_grade_drop_lowest
FROM kept_grades kg
JOIN Category cat ON kg.category_id = cat.category_id;
