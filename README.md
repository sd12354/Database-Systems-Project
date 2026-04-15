# Grade Book Database

A command-line grade tracking application built with Python and SQLite.
Designed for a professor who teaches multiple courses and needs to track
student grades across flexible grading categories.

---

## Requirements

- Python 3.7 or higher
- No external packages needed (uses Python's built-in `sqlite3` module)

To check your Python version:
```bash
python3 --version
```

---

## Project Files

| File              | Purpose                                                  |
|-------------------|----------------------------------------------------------|
| `gradebook.py`    | Main application — run this to start the program         |
| `schema.sql`      | CREATE TABLE statements (DDL)                            |
| `sample_data.sql` | INSERT statements with sample data (DML)                 |
| `queries.sql`     | Documented SQL queries for Tasks 4–12                    |
| `README.md`       | This file                                                |

All five files must be in the same directory.

---

## How to Run

Open a terminal, navigate to the project folder, and run:

```bash
python3 gradebook.py
```

On Windows:
```bash
python gradebook.py
```

On first launch the application will:
1. Create `gradebook.db` (a local SQLite file)
2. Build all tables from `schema.sql`
3. Load sample data from `sample_data.sql`

Subsequent runs reuse the existing database file automatically.

---

## Resetting to a Clean State

Delete the database file and re-run:

```bash
rm gradebook.db        # macOS / Linux
del gradebook.db       # Windows Command Prompt
python3 gradebook.py
```

---

## Menu Reference

```
 1.  Show all tables                    (Task 3)
 2.  Assignment statistics              (Task 4)
 3.  List students in a course          (Task 5)
 4.  All students & scores in a course  (Task 6)
 5.  Add an assignment to a course      (Task 7)
 6.  Change category percentages        (Task 8)
 7.  Add points to all students         (Task 9)
 8.  Add points to students with 'Q'    (Task 10)
 9.  Compute a student's grade          (Task 11)
10.  Compute grade (drop lowest)        (Task 12)
 0.  Exit
```

---

## Sample Data Overview

### Departments
| ID | Name                |
|----|---------------------|
| 1  | Computer Science    |
| 2  | Mathematics         |

### Courses
| ID | Dept | Number   | Name                               | Semester | Year |
|----|------|----------|------------------------------------|----------|------|
| 1  | CS   | CSCI 101 | Introduction to Computer Science   | Spring   | 2026 |
| 2  | CS   | CSCI 350 | Structure of Programming Languages | Spring   | 2026 |
| 3  | Math | MATH 201 | Discrete Mathematics               | Fall     | 2025 |

### Grading Distributions

**CSCI 101:**  10% Participation | 20% Homework (5 assignments) | 50% Tests (2) | 20% Projects (1)

**CSCI 350:**  10% Participation | 30% Homework (3 assignments) | 40% Tests (2) | 20% Projects (2)

**MATH 201:**  20% Homework (4 assignments, max 50 pts each) | 40% Midterm | 40% Final

### Students with 'Q' in Last Name (used for Task 10)
- David **Q**uincy (student_id 4)
- Frank **Q**uiroga (student_id 6)
- Iris **Q**ian (student_id 9)

---

## How Grade Calculation Works

Each assignment's contribution to the final grade is:

```
contribution = (score / max_score) × (category_percentage / num_assignments_in_category)
```

**Example** — CSCI 101, Homework category (20%, 5 assignments):
Each homework is worth `20% / 5 = 4%` of the final grade.
A score of 85/100 on one homework contributes `0.85 × 4% = 3.4 points`.

**Drop-lowest variant (Task 12):** The assignment with the lowest
`score / max_score` ratio in each category is excluded before averaging.
If a category has only one assignment, nothing is dropped.

---

## Test Cases and Results

All tests were run on a fresh database using the inputs below.
Tasks 7–10 modify data; Tasks 11–12 reflect those modifications.

---

### Task 3 — Show All Tables

**Input:** Menu option `1`

**Result:**
```
TABLE: Department     — 2 rows   (Computer Science, Mathematics)
TABLE: Course         — 3 rows   (CSCI 101, CSCI 350, MATH 201)
TABLE: Student        — 10 rows
TABLE: Enrollment     — 20 rows
TABLE: Category       — 11 rows
TABLE: Assignment     — 23 rows
TABLE: Grade          — 155 rows
```

---

### Task 4 — Assignment Statistics

**Input:** Course ID `1` (CSCI 101) → Assignment ID `7` (Test 1)

**Result:**
```
+------------+----------+-------+---------+---------+--------+------------+
| Assignment | Category | Max   | Average | Highest | Lowest | # Students |
+------------+----------+-------+---------+---------+--------+------------+
| Test 1     | Tests    | 100.0 | 78.86   | 94.0    | 58.0   | 7          |
+------------+----------+-------+---------+---------+--------+------------+
```

---

### Task 5 — List Students in a Course

**Input:** Course ID `1` (CSCI 101)

**Result:**
```
+------------+------------+-----------+--------------------------+
| Student ID | First Name | Last Name | Email                    |
+------------+------------+-----------+--------------------------+
| 5          | Eva        | Brown     | ebrown@university.edu    |
| 1          | Alice      | Johnson   | ajohnson@university.edu  |
| 7          | Grace      | Lee       | glee@university.edu      |
| 4          | David      | Quincy    | dquincy@university.edu   |
| 6          | Frank      | Quiroga   | fquiroga@university.edu  |
| 2          | Bob        | Smith     | bsmith@university.edu    |
| 3          | Carol      | Williams  | cwilliams@university.edu |
+------------+------------+-----------+--------------------------+
(7 rows)
```

---

### Task 6 — All Students & Scores

**Input:** Course ID `2` (CSCI 350)

**Result:** 56 rows (7 students × 8 assignments each), ordered by last name then assignment. Sample:
```
+-----------+------------+---------------+------------+-------+-------+-------+
| Last Name | First Name | Category      | Assignment | Score | Max   | Pct%  |
+-----------+------------+---------------+------------+-------+-------+-------+
| Brown     | Eva        | Homework      | HW 1       | 98.0  | 100.0 | 98.0  |
| Brown     | Eva        | Homework      | HW 2       | 100.0 | 100.0 | 100.0 |
| Brown     | Eva        | Homework      | HW 3       | 96.0  | 100.0 | 96.0  |
| ...       | ...        | ...           | ...        | ...   | ...   | ...   |
+-----------+------------+---------------+------------+-------+-------+-------+
(56 rows total)
```

---

### Task 7 — Add an Assignment

**Input:** Course ID `1`, Category ID `2` (Homework), Name `HW 6`, Max score `100`

**Result:**
```
[OK] Assignment 'HW 6' added (ID=24).
     Grades initialized to 0 for all enrolled students.
```
7 grade rows created with score = 0, one per enrolled student.

---

### Task 8 — Change Category Percentages

**Input:** Course ID `1`; Homework 20% → 25%, Tests 50% → 45% (others unchanged)

**Result:**
```
[OK] Percentages updated.

+----+---------------+------------+
| ID | Category Name | Percentage |
+----+---------------+------------+
| 2  | Homework      | 25.0       |
| 1  | Participation | 10.0       |
| 4  | Projects      | 20.0       |
| 3  | Tests         | 45.0       |
+----+---------------+------------+
Total: 25 + 10 + 20 + 45 = 100%
```

---

### Task 9 — Add 2 Points to All Students

**Input:** Course ID `1`, Assignment ID `7` (Test 1), +2 points

**Result:**
```
[OK] Added 2.0 pt(s) to 7 student(s) (capped at max score).
```
All 7 CSCI 101 students gained 2 points on Test 1 (scores capped at 100).

---

### Task 10 — Add 2 Points to Students with 'Q' in Last Name

**Input:** Course ID `1`, Assignment ID `2` (HW 1), +2 points, letter `Q`

**Result:**
```
Students qualifying (last name contains 'Q'):
+------------+-----------+---------------+
| First Name | Last Name | Current Score |
+------------+-----------+---------------+
| David      | Quincy    | 60.0          |
| Frank      | Quiroga   | 78.0          |
+------------+-----------+---------------+
(2 rows)

[OK] Added 2.0 pt(s) to 2 qualifying student(s).
```
Quincy: 60 → 62, Quiroga: 78 → 80. All other students unchanged.

---

### Task 11 — Compute Student Grade

**Input:** Course ID `1` (CSCI 101), Student ID `1` (Alice Johnson)
*(Reflects updated percentages from Task 8 and +2 pts on Test 1 from Task 9)*

**Result:**
```
Score Breakdown for Alice Johnson:
+---------------+-----------------------+-------+-------+------+
| Category      | Assignment            | Score | Max   | Raw% |
+---------------+-----------------------+-------+-------+------+
| Homework      | HW 1                  | 88.0  | 100.0 | 88.0 |
| Homework      | HW 2                  | 92.0  | 100.0 | 92.0 |
| Homework      | HW 3                  | 85.0  | 100.0 | 85.0 |
| Homework      | HW 4                  | 90.0  | 100.0 | 90.0 |
| Homework      | HW 5                  | 78.0  | 100.0 | 78.0 |
| Homework      | HW 6                  | 0.0   | 100.0 | 0.0  |
| Participation | Participation Overall | 95.0  | 100.0 | 95.0 |
| Projects      | Project 1             | 90.0  | 100.0 | 90.0 |
| Tests         | Test 1                | 84.0  | 100.0 | 84.0 |
| Tests         | Test 2                | 87.0  | 100.0 | 87.0 |
+---------------+-----------------------+-------+-------+------+

Weighted Category Summary:
+---------------+---------+----------+--------------+
| Category      | Weight% | Cat Avg% | Weighted Pts |
+---------------+---------+----------+--------------+
| Homework      | 25.0    | 72.17    | 18.04        |
| Participation | 10.0    | 95.0     | 9.5          |
| Projects      | 20.0    | 90.0     | 18.0         |
| Tests         | 45.0    | 85.5     | 38.48        |
+---------------+---------+----------+--------------+

*** Final Grade: 84.02 / 100  (B) ***
```

---

### Task 12 — Compute Grade (Drop Lowest per Category)

**Input:** Course ID `1` (CSCI 101), Student ID `1` (Alice Johnson)

**Result:**
```
Drop-Lowest Grade for Alice Johnson:
-----------------------------------------------------------------------------------
Category              Weight         # Asgn  Dropped Assignment            Cat Avg%
-----------------------------------------------------------------------------------
Participation         10.0%               1  (only 1 — none dropped)         95.00%
Homework              25.0%               6  HW 6 (0.0%)                     86.60%
Tests                 45.0%               2  Test 1 (84.0%)                  87.00%
Projects              20.0%               1  (only 1 — none dropped)         90.00%
-----------------------------------------------------------------------------------

*** Final Grade (drop lowest): 88.30 / 100  (B) ***
```
HW 6 (0%) and Test 1 (84%) were dropped as the lowest scores in their categories.
Grade improved from 84.02 → 88.30 (+4.28 points).

---

## Running Queries Manually (SQLite Shell)

```bash
sqlite3 gradebook.db
```

Then paste any query from `queries.sql`, replacing `?` with real values.
To enable readable output:

```sql
.headers on
.mode column
```
