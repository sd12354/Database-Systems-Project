#!/usr/bin/env python3
"""
gradebook.py  |  Grade Book Database Application
=================================================
A command-line interface for managing course grades.
Uses SQLite via Python's built-in sqlite3 module — no
external packages required.

Run:  python3 gradebook.py
"""

import sqlite3
import os
from collections import defaultdict

DB_FILE     = "gradebook.db"
SCHEMA_FILE = "schema.sql"
DATA_FILE   = "sample_data.sql"


# ─── Database setup ──────────────────────────────────────────────────────────

def get_connection():
    """Return a connection with foreign-key enforcement enabled."""
    conn = sqlite3.connect(DB_FILE)
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


def initialize_database(conn):
    """Create tables from schema.sql (safe to call on an existing DB)."""
    with open(SCHEMA_FILE, "r") as f:
        conn.executescript(f.read())
    conn.commit()


def load_sample_data(conn):
    """Insert sample data from sample_data.sql."""
    with open(DATA_FILE, "r") as f:
        conn.executescript(f.read())
    conn.commit()
    print("  [OK] Sample data loaded.")


# ─── Display helpers ──────────────────────────────────────────────────────────

def print_table(rows, headers):
    """Pretty-print a list of rows as a formatted ASCII table."""
    if not rows:
        print("  (no results found)\n")
        return

    str_rows = []
    for row in rows:
        str_rows.append([str(v) if v is not None else "NULL" for v in row])

    col_widths = [len(str(h)) for h in headers]
    for row in str_rows:
        for i, val in enumerate(row):
            if i < len(col_widths):
                col_widths[i] = max(col_widths[i], len(val))

    separator = "  +" + "+".join("-" * (w + 2) for w in col_widths) + "+"
    row_fmt   = "  | " + " | ".join(f"{{:<{w}}}" for w in col_widths) + " |"

    print(separator)
    print(row_fmt.format(*[str(h) for h in headers]))
    print(separator)
    for row in str_rows:
        padded = row + [""] * (len(col_widths) - len(row))
        print(row_fmt.format(*padded))
    print(separator)
    n = len(str_rows)
    print(f"  ({n} row{'s' if n != 1 else ''})\n")


def letter_grade(score):
    """Convert a numeric score (0-100) to a letter grade."""
    if   score >= 90: return "A"
    elif score >= 80: return "B"
    elif score >= 70: return "C"
    elif score >= 60: return "D"
    else:             return "F"


# ─── Selection helpers ────────────────────────────────────────────────────────

def pick_int(prompt):
    """Read an integer from the user; return None on bad input."""
    try:
        return int(input(f"  {prompt}: ").strip())
    except ValueError:
        print("  [!] Invalid input — expected an integer.\n")
        return None


def pick_float(prompt, default):
    """Read a float from the user; fall back to default on empty/bad input."""
    raw = input(f"  {prompt} (default {default}): ").strip()
    if not raw:
        return default
    try:
        return float(raw)
    except ValueError:
        print(f"  [!] Invalid input, using default {default}.\n")
        return default


def show_courses(conn):
    cur = conn.execute("""
        SELECT c.course_id, d.dept_name, c.course_number,
               c.course_name, c.semester, c.year
        FROM Course c
        JOIN Department d ON c.dept_id = d.dept_id
        ORDER BY c.year DESC, c.semester, c.course_number
    """)
    rows = cur.fetchall()
    print()
    print_table(rows, ["ID", "Department", "Number", "Name", "Semester", "Year"])
    return rows


def show_students(conn):
    cur = conn.execute(
        "SELECT student_id, first_name, last_name, email "
        "FROM Student ORDER BY last_name, first_name"
    )
    rows = cur.fetchall()
    print()
    print_table(rows, ["ID", "First Name", "Last Name", "Email"])
    return rows


def show_assignments(conn, course_id):
    cur = conn.execute("""
        SELECT a.assignment_id, cat.category_name, a.assignment_name, a.max_score
        FROM Assignment a
        JOIN Category cat ON a.category_id = cat.category_id
        WHERE cat.course_id = ?
        ORDER BY cat.category_name, a.assignment_name
    """, (course_id,))
    rows = cur.fetchall()
    print()
    print_table(rows, ["ID", "Category", "Assignment", "Max Score"])
    return rows


def show_categories(conn, course_id):
    cur = conn.execute("""
        SELECT category_id, category_name, percentage
        FROM Category WHERE course_id = ?
        ORDER BY category_name
    """, (course_id,))
    rows = cur.fetchall()
    print()
    print_table(rows, ["ID", "Category Name", "Percentage"])
    return rows


# ─── Task implementations ─────────────────────────────────────────────────────

def task3_show_all_tables(conn):
    """Task 3 — Display every table with its full contents."""
    tables = [
        ("Department", ["dept_id", "dept_name"]),
        ("Course",     ["course_id", "dept_id", "course_number",
                        "course_name", "semester", "year"]),
        ("Student",    ["student_id", "first_name", "last_name", "email"]),
        ("Enrollment", ["enrollment_id", "student_id", "course_id"]),
        ("Category",   ["category_id", "course_id", "category_name", "percentage"]),
        ("Assignment", ["assignment_id", "category_id", "assignment_name", "max_score"]),
        ("Grade",      ["grade_id", "enrollment_id", "assignment_id", "score"]),
    ]
    for tbl, hdrs in tables:
        print(f"\n  TABLE: {tbl}")
        rows = conn.execute(f"SELECT * FROM {tbl}").fetchall()
        print_table(rows, hdrs)


def task4_assignment_stats(conn):
    """Task 4 — Average, highest, and lowest score on a chosen assignment."""
    print("\n  -- Task 4: Assignment Statistics --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    print("  Select an assignment:")
    show_assignments(conn, course_id)
    assignment_id = pick_int("Assignment ID")
    if assignment_id is None:
        return

    cur = conn.execute("""
        SELECT a.assignment_name,
               cat.category_name,
               a.max_score,
               ROUND(AVG(g.score), 2)  AS avg_score,
               MAX(g.score)            AS highest,
               MIN(g.score)            AS lowest,
               COUNT(g.score)          AS num_students
        FROM Assignment a
        JOIN Category cat ON a.category_id   = cat.category_id
        JOIN Grade g      ON a.assignment_id = g.assignment_id
        WHERE a.assignment_id = ?
    """, (assignment_id,))
    rows = cur.fetchall()
    print("\n  Assignment Statistics:")
    print_table(rows, ["Assignment", "Category", "Max", "Average",
                       "Highest", "Lowest", "# Students"])


def task5_list_students(conn):
    """Task 5 — List every student enrolled in a course."""
    print("\n  -- Task 5: Students in a Course --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return

    cur = conn.execute("""
        SELECT s.student_id, s.first_name, s.last_name, s.email
        FROM Student s
        JOIN Enrollment e ON s.student_id = e.student_id
        WHERE e.course_id = ?
        ORDER BY s.last_name, s.first_name
    """, (course_id,))
    rows = cur.fetchall()
    print("\n  Enrolled Students:")
    print_table(rows, ["Student ID", "First Name", "Last Name", "Email"])


def task6_students_and_scores(conn):
    """Task 6 — All students and every score on every assignment."""
    print("\n  -- Task 6: All Students & Scores --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return

    cur = conn.execute("""
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
        ORDER BY s.last_name, s.first_name, cat.category_name, a.assignment_name
    """, (course_id,))
    rows = cur.fetchall()
    print("\n  All Scores:")
    print_table(rows, ["Last Name", "First Name", "Category",
                       "Assignment", "Score", "Max", "Pct%"])


def task7_add_assignment(conn):
    """Task 7 — Add a new assignment to a course category."""
    print("\n  -- Task 7: Add an Assignment --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    print("  Select a category:")
    cats = show_categories(conn, course_id)
    if not cats:
        print("  [!] No categories found for this course.\n")
        return
    category_id = pick_int("Category ID")
    if category_id is None:
        return

    name = input("  Assignment name: ").strip()
    if not name:
        print("  [!] Name cannot be empty.\n")
        return
    max_score = pick_float("Max score", 100.0)

    cur = conn.execute(
        "INSERT INTO Assignment (category_id, assignment_name, max_score) "
        "VALUES (?, ?, ?)",
        (category_id, name, max_score)
    )
    new_id = cur.lastrowid

    conn.execute("""
        INSERT INTO Grade (enrollment_id, assignment_id, score)
        SELECT e.enrollment_id, ?, 0
        FROM Enrollment e WHERE e.course_id = ?
    """, (new_id, course_id))
    conn.commit()
    print(f"\n  [OK] Assignment '{name}' added (ID={new_id}).")
    print(f"       Grades initialized to 0 for all enrolled students.\n")


def task8_change_percentages(conn):
    """Task 8 — Update the weight percentages for a course's categories."""
    print("\n  -- Task 8: Change Category Percentages --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    cats = show_categories(conn, course_id)
    if not cats:
        print("  [!] No categories found.\n")
        return

    updates = {}
    print("  Enter new percentages (press Enter to keep the current value):")
    for row in cats:
        cat_id, cat_name, cur_pct = row[0], row[1], row[2]
        raw = input(f"    {cat_name} (currently {cur_pct}%): ").strip()
        if raw:
            try:
                updates[cat_id] = float(raw)
            except ValueError:
                print(f"    [!] Invalid value for {cat_name}, keeping {cur_pct}%.")

    if not updates:
        print("  No changes made.\n")
        return

    # Check that the resulting total is still 100
    existing = {row[0]: row[2] for row in cats}
    existing.update(updates)
    total = sum(existing.values())
    if abs(total - 100.0) > 0.01:
        print(f"  [!] Warning: percentages now sum to {total:.2f}% (should be 100%).")

    for cat_id, pct in updates.items():
        conn.execute(
            "UPDATE Category SET percentage = ? WHERE category_id = ?",
            (pct, cat_id)
        )
    conn.commit()
    print("\n  [OK] Percentages updated.")
    show_categories(conn, course_id)


def task9_add_points_all(conn):
    """Task 9 — Add bonus points to every student on an assignment."""
    print("\n  -- Task 9: Add Points to All Students --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    print("  Select an assignment:")
    show_assignments(conn, course_id)
    assignment_id = pick_int("Assignment ID")
    if assignment_id is None:
        return
    points = pick_float("Points to add", 2.0)

    conn.execute("""
        UPDATE Grade
        SET score = MIN(
            score + ?,
            (SELECT max_score FROM Assignment WHERE assignment_id = ?)
        )
        WHERE assignment_id = ?
    """, (points, assignment_id, assignment_id))
    conn.commit()
    changed = conn.execute("SELECT changes()").fetchone()[0]
    print(f"\n  [OK] Added {points} pt(s) to {changed} student(s) (capped at max score).\n")


def task10_add_points_q(conn):
    """Task 10 — Add points only to students whose last name contains 'Q'."""
    print("\n  -- Task 10: Add Points to Students with 'Q' in Last Name --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    print("  Select an assignment:")
    show_assignments(conn, course_id)
    assignment_id = pick_int("Assignment ID")
    if assignment_id is None:
        return
    points = pick_float("Points to add", 2.0)
    letter = input("  Match letter in last name (default Q): ").strip() or "Q"
    pattern = f"%{letter}%"

    # Preview who qualifies
    cur = conn.execute("""
        SELECT s.first_name, s.last_name, g.score
        FROM Student s
        JOIN Enrollment e ON s.student_id    = e.student_id
        JOIN Grade g      ON e.enrollment_id = g.enrollment_id
        WHERE g.assignment_id = ?
          AND e.course_id     = ?
          AND s.last_name LIKE ?
        ORDER BY s.last_name
    """, (assignment_id, course_id, pattern))
    qualifying = cur.fetchall()

    if not qualifying:
        print(f"\n  No students with '{letter}' in last name found in this course/assignment.\n")
        return

    print(f"\n  Students qualifying (last name contains '{letter}'):")
    print_table(qualifying, ["First Name", "Last Name", "Current Score"])

    conn.execute("""
        UPDATE Grade
        SET score = MIN(
            score + ?,
            (SELECT max_score FROM Assignment WHERE assignment_id = ?)
        )
        WHERE assignment_id = ?
          AND enrollment_id IN (
              SELECT e.enrollment_id
              FROM Enrollment e
              JOIN Student s ON e.student_id = s.student_id
              WHERE e.course_id   = ?
                AND s.last_name LIKE ?
          )
    """, (points, assignment_id, assignment_id, course_id, pattern))
    conn.commit()
    changed = conn.execute("SELECT changes()").fetchone()[0]
    print(f"  [OK] Added {points} pt(s) to {changed} qualifying student(s).\n")


def task11_compute_grade(conn):
    """Task 11 — Compute a student's weighted final grade in a course."""
    print("\n  -- Task 11: Compute Student Grade --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    print("  Select a student:")
    show_students(conn)
    student_id = pick_int("Student ID")
    if student_id is None:
        return

    # Per-assignment detail
    cur = conn.execute("""
        SELECT cat.category_name,
               a.assignment_name,
               g.score,
               a.max_score,
               ROUND(g.score * 100.0 / a.max_score, 1) AS raw_pct
        FROM Student s
        JOIN Enrollment e  ON s.student_id    = e.student_id
        JOIN Grade g       ON e.enrollment_id = g.enrollment_id
        JOIN Assignment a  ON g.assignment_id = a.assignment_id
        JOIN Category cat  ON a.category_id   = cat.category_id
        WHERE s.student_id = ? AND e.course_id = ?
        ORDER BY cat.category_name, a.assignment_name
    """, (student_id, course_id))
    detail = cur.fetchall()

    if not detail:
        print("  [!] No grades found for this student in this course.\n")
        return

    name_row = conn.execute(
        "SELECT first_name || ' ' || last_name FROM Student WHERE student_id = ?",
        (student_id,)
    ).fetchone()
    student_name = name_row[0] if name_row else "Unknown"

    print(f"\n  Score Breakdown for {student_name}:")
    print_table(detail, ["Category", "Assignment", "Score", "Max", "Raw%"])

    # Per-category weighted contributions
    cur2 = conn.execute("""
        SELECT cat.category_name,
               cat.percentage,
               ROUND(AVG(g.score * 100.0 / a.max_score), 2) AS cat_avg,
               ROUND(cat.percentage * AVG(g.score * 100.0 / a.max_score) / 100.0, 2)
                   AS weighted_pts
        FROM Student s
        JOIN Enrollment e  ON s.student_id    = e.student_id
        JOIN Grade g       ON e.enrollment_id = g.enrollment_id
        JOIN Assignment a  ON g.assignment_id = a.assignment_id
        JOIN Category cat  ON a.category_id   = cat.category_id
        WHERE s.student_id = ? AND e.course_id = ?
        GROUP BY cat.category_id
        ORDER BY cat.category_name
    """, (student_id, course_id))
    cat_rows = cur2.fetchall()

    print(f"  Weighted Category Summary:")
    print_table(cat_rows, ["Category", "Weight%", "Cat Avg%", "Weighted Pts"])

    final = sum(row[3] for row in cat_rows)
    print(f"  *** Final Grade: {final:.2f} / 100  ({letter_grade(final)}) ***\n")


def task12_compute_grade_drop_lowest(conn):
    """Task 12 — Final grade after dropping the lowest score in each category."""
    print("\n  -- Task 12: Compute Grade (Drop Lowest per Category) --")
    print("  Select a course:")
    show_courses(conn)
    course_id = pick_int("Course ID")
    if course_id is None:
        return
    print("  Select a student:")
    show_students(conn)
    student_id = pick_int("Student ID")
    if student_id is None:
        return

    # Pull all grades with category info, ordered lowest pct first
    cur = conn.execute("""
        SELECT cat.category_id,
               cat.category_name,
               cat.percentage,
               a.assignment_name,
               g.score,
               a.max_score,
               ROUND(g.score * 100.0 / a.max_score, 4) AS raw_pct
        FROM Student s
        JOIN Enrollment e  ON s.student_id    = e.student_id
        JOIN Grade g       ON e.enrollment_id = g.enrollment_id
        JOIN Assignment a  ON g.assignment_id = a.assignment_id
        JOIN Category cat  ON a.category_id   = cat.category_id
        WHERE s.student_id = ? AND e.course_id = ?
        ORDER BY cat.category_id, raw_pct ASC
    """, (student_id, course_id))
    rows = cur.fetchall()

    if not rows:
        print("  [!] No grades found for this student in this course.\n")
        return

    name_row = conn.execute(
        "SELECT first_name || ' ' || last_name FROM Student WHERE student_id = ?",
        (student_id,)
    ).fetchone()
    student_name = name_row[0] if name_row else "Unknown"

    # Group by category
    categories = defaultdict(list)
    cat_meta   = {}
    for row in rows:
        cat_id = row[0]
        cat_meta[cat_id] = (row[1], row[2])   # (name, percentage)
        categories[cat_id].append({
            "name":      row[3],
            "score":     row[4],
            "max_score": row[5],
            "raw_pct":   row[6],
        })

    print(f"\n  Drop-Lowest Grade for {student_name}:")
    w1, w2, w3, w4, w5 = 18, 8, 13, 26, 10
    header = (f"  {'Category':<{w1}}  {'Weight':>{w2}}  "
              f"{'# Asgn':>{w3}}  {'Dropped Assignment':<{w4}}  "
              f"{'Cat Avg%':>{w5}}")
    sep = "  " + "-" * (w1 + w2 + w3 + w4 + w5 + 8)
    print(sep)
    print(header)
    print(sep)

    final = 0.0
    summary_rows = []
    for cat_id, assignments in categories.items():
        cat_name, cat_pct = cat_meta[cat_id]
        if len(assignments) > 1:
            dropped  = assignments[0]          
            kept     = assignments[1:]
            drop_str = f"{dropped['name']} ({dropped['raw_pct']:.1f}%)"
        else:
            kept     = assignments
            drop_str = "(only 1 — none dropped)"

        cat_avg      = sum(a["raw_pct"] for a in kept) / len(kept)
        contribution = cat_pct * cat_avg / 100.0
        final       += contribution
        print(f"  {cat_name:<{w1}}  {cat_pct:>{w2}.1f}%  "
              f"{len(assignments):>{w3}}  {drop_str:<{w4}}  "
              f"{cat_avg:>{w5}.2f}%")
        summary_rows.append((cat_name, cat_pct, len(assignments),
                              drop_str, round(cat_avg, 2)))

    print(sep)
    print(f"\n  *** Final Grade (drop lowest): {final:.2f} / 100"
          f"  ({letter_grade(final)}) ***\n")


# ─── Main menu ────────────────────────────────────────────────────────────────

MENU = """
  ╔═══════════════════════════════════════════════════════╗
  ║           GRADE BOOK DATABASE  —  Main Menu           ║
  ╠═══════════════════════════════════════════════════════╣
  ║  1.  Show all tables                    (Task 3)      ║
  ║  2.  Assignment statistics              (Task 4)      ║
  ║  3.  List students in a course          (Task 5)      ║
  ║  4.  All students & scores in a course  (Task 6)      ║
  ║  5.  Add an assignment to a course      (Task 7)      ║
  ║  6.  Change category percentages        (Task 8)      ║
  ║  7.  Add points to all students         (Task 9)      ║
  ║  8.  Add points to students with 'Q'    (Task 10)     ║
  ║  9.  Compute a student's grade          (Task 11)     ║
  ║ 10.  Compute grade (drop lowest)        (Task 12)     ║
  ║  0.  Exit                                             ║
  ╚═══════════════════════════════════════════════════════╝"""

DISPATCH = {
    "1":  task3_show_all_tables,
    "2":  task4_assignment_stats,
    "3":  task5_list_students,
    "4":  task6_students_and_scores,
    "5":  task7_add_assignment,
    "6":  task8_change_percentages,
    "7":  task9_add_points_all,
    "8":  task10_add_points_q,
    "9":  task11_compute_grade,
    "10": task12_compute_grade_drop_lowest,
}


def main():
    print("\n  Grade Book Database — Initializing...")

    conn = get_connection()
    initialize_database(conn)

    # Load sample data only on a fresh database
    count = conn.execute("SELECT COUNT(*) FROM Student").fetchone()[0]
    if count == 0:
        load_sample_data(conn)

    while True:
        print(MENU)
        choice = input("  Select an option: ").strip()
        if choice == "0":
            print("\n  Goodbye!\n")
            break
        if choice in DISPATCH:
            try:
                DISPATCH[choice](conn)
            except sqlite3.Error as e:
                print(f"\n  [DB ERROR] {e}\n")
            except Exception as e:
                print(f"\n  [ERROR] {e}\n")
        else:
            print("  [!] Invalid option — please try again.\n")

    conn.close()


if __name__ == "__main__":
    main()
