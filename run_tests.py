#!/usr/bin/env python3
"""Automated test runner — pipes inputs into gradebook.py and captures output."""
import subprocess, os, sys

os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Start fresh
if os.path.exists("gradebook.db"):
    os.remove("gradebook.db")

# ── Input sequence ────────────────────────────────────────────
# Each entry maps to one line of stdin.
# Task 3  → menu 1
# Task 4  → menu 2, course 1, assignment 7 (Test 1)
# Task 5  → menu 3, course 1
# Task 6  → menu 4, course 2
# Task 7  → menu 5, course 1, category 2 (Homework), name "HW 6", max 100
# Task 8  → menu 6, course 1,
#            Homework 20→25, Participation keep, Projects keep, Tests 50→45
# Task 9  → menu 7, course 1, assignment 7, default 2 pts
# Task 10 → menu 8, course 1, assignment 2 (HW 1), default 2 pts, default Q
# Task 11 → menu 9, course 1, student 1 (Alice Johnson)
# Task 12 → menu 10, course 1, student 1 (Alice Johnson)
# Exit    → 0

inputs = [
    "1",      # Task 3: show all tables
    "2",      # Task 4
    "1",      #   course 1
    "7",      #   assignment 7 (Test 1)
    "3",      # Task 5
    "1",      #   course 1
    "4",      # Task 6
    "2",      #   course 2
    "5",      # Task 7
    "1",      #   course 1
    "2",      #   category 2 (Homework)
    "HW 6",   #   name
    "100",    #   max score
    "6",      # Task 8
    "1",      #   course 1
    "25",     #   Homework → 25%
    "",       #   Participation → keep 10%
    "",       #   Projects → keep 20%
    "45",     #   Tests → 45%
    "7",      # Task 9
    "1",      #   course 1
    "7",      #   assignment 7
    "",       #   default +2 pts
    "8",      # Task 10
    "1",      #   course 1
    "2",      #   assignment 2 (HW 1)
    "",       #   default +2 pts
    "",       #   default letter Q
    "9",      # Task 11
    "1",      #   course 1
    "1",      #   student 1 (Alice Johnson)
    "10",     # Task 12
    "1",      #   course 1
    "1",      #   student 1 (Alice Johnson)
    "0",      # Exit
]

env = os.environ.copy()
env["PYTHONIOENCODING"] = "utf-8"
env["PYTHONUTF8"] = "1"

result = subprocess.run(
    [sys.executable, "gradebook.py"],
    input="\n".join(inputs) + "\n",
    capture_output=True,
    text=True,
    encoding="utf-8",
    env=env,
)

output = result.stdout
if result.stderr:
    output += "\n--- STDERR ---\n" + result.stderr

with open("test_output.txt", "w", encoding="utf-8") as f:
    f.write(output)

print("[Saved to test_output.txt]")
