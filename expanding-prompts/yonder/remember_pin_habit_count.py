#!/usr/bin/env python3
"""Count pure REMEMBER nib follow-up commits in f291d96a74..HEAD."""
from __future__ import annotations

import re
import subprocess
import sys

BASE = "f291d96a74"


def is_habit(subj: str, files: list[str]) -> bool:
    core = [
        f
        for f in files
        if f
        not in ("work-in-progress/REMEMBER.md", "session-logs/README.md")
        and not f.startswith("session-logs/")
    ]
    if core:
        return False
    brons = [
        f for f in files if f.startswith("session-logs/") and f.endswith(".bron")
    ]
    if any("remember-git-nib" not in f for f in brons):
        return False
    if "pin REMEMBER" in subj:
        return True
    s = subj.lower()
    if re.match(
        r"^(wip|work-in-progress):\s+(refresh|align|repair|fix)\s+remember", s
    ):
        return True
    if re.match(r"^(wip|work-in-progress):\s+pin\s+", s) and "remember" in s:
        return True
    if files and "remember" in s and ("nib" in s or "git nib" in s):
        return True
    return False


def main() -> int:
    commits = subprocess.check_output(
        ["git", "rev-list", f"{BASE}..HEAD"], text=True
    ).split()
    n = 0
    for c in commits:
        subj = subprocess.check_output(
            ["git", "log", "-1", "--format=%s", c], text=True
        ).strip()
        files = subprocess.check_output(
            ["git", "diff-tree", "--no-commit-id", "--name-only", "-r", c],
            text=True,
        ).split()
        if is_habit(subj, files):
            n += 1
    print(n)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
