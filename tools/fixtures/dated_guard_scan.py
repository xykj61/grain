#!/usr/bin/env python3
"""dated_guard_scan.py — staged dated MODIFIED paths on main must declare living."""
import re
import subprocess
import sys
from pathlib import Path


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True)


def on_main(path):
    for ref in ("main", "origin/main"):
        if run(["git", "cat-file", "-e", f"{ref}:{path}"]).returncode == 0:
            return True
    return False


def declares_living(text):
    head = "\n".join(text.splitlines()[:40]).lower()
    return "living ledger" in head


def is_freeze_pointer(text):
    low = text.lower()
    return "living twin" in low and "immutable after merge" in low and len(text) < 1200


def main():
    staged = run(["git", "diff", "--cached", "--name-only", "--diff-filter=M"])
    if staged.returncode != 0:
        print("FAIL git diff --cached failed")
        return 1
    paths = [p for p in staged.stdout.splitlines() if p.strip()]
    pat = re.compile(r"(^|/)2026\d{4}-\d{6}_[^/]+$")
    candidates = [p for p in paths if pat.search(p)]
    if not candidates:
        print("OK   no staged MODIFIED dated paths")
        return 0

    reds = []
    for path in candidates:
        if not on_main(path):
            print(f"OK   {path} (new to main — dated birth allowed)")
            continue
        p = Path(path)
        if not p.is_file():
            reds.append(f"{path}: missing working tree")
            continue
        text = p.read_text(encoding="utf-8", errors="replace")
        if declares_living(text):
            print(f"OK   {path} (living header)")
        elif is_freeze_pointer(text):
            print(f"OK   {path} (freeze pointer stub)")
        else:
            reds.append(path)
            print(
                f"FAIL {path}: dated on main without living ledger header — edit TASKS or a living twin"
            )

    if reds:
        print(f"FAIL count={len(reds)}")
        return 1
    print("OK   dated-guard clean")
    return 0


if __name__ == "__main__":
    sys.exit(main())
