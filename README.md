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

## Test Cases

### Task 4 — Assignment Statistics
- Input: Course ID `1` (CSCI 101), Assignment ID `7` (Test 1)
- Expected: avg ≈ 78.86, highest = 94, lowest = 58

### Task 5 — List Students in a Course
- Input: Course ID `1` (CSCI 101)
- Expected: 7 students listed (Alice Johnson through Grace Lee)

### Task 6 — Students and Scores
- Input: Course ID `2` (CSCI 350)
- Expected: 7 students × 8 assignments = 56 rows

### Task 7 — Add Assignment
- Input: Course ID `1`, Category ID `2` (Homework), Name `HW 6`, Max `100`
- Expected: new assignment_id created, 7 grade rows inserted with score = 0

### Task 8 — Change Percentages
- Input: Course ID `1`; change Homework from 20% → 25%, Tests from 50% → 45%
- Expected: categories updated; warning shown if total != 100%

### Task 9 — Add 2 Points to All
- Input: Course ID `1`, Assignment ID `7` (Test 1)
- Expected: all 7 students gain 2 points (capped at 100)

### Task 10 — Add 2 Points to 'Q' Students
- Input: Course ID `1`, Assignment ID `2` (HW 1)
- Qualifying students: David Quincy, Frank Quiroga (both enrolled in CSCI 101)
- Expected: 2 students' scores updated; others unchanged

### Task 11 — Compute Grade
- Input: Course ID `1`, Student ID `1` (Alice Johnson)
- Expected: breakdown by category, then a weighted final score

### Task 12 — Compute Grade Drop Lowest
- Input: Course ID `1`, Student ID `1` (Alice Johnson)
- Expected: lowest HW and lowest Test dropped, final score slightly higher than Task 11

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
