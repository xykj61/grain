#!/bin/sh
# markdown_structure_scan.sh — blocking structural integrity for Markdown passes.
# Seated 20260725.114400 · Quin relay repair.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

BASE=${MARKDOWN_STRUCTURE_BASE:-${CLAIM_PRESERVE_BASE:-HEAD}}
FILES=${MARKDOWN_STRUCTURE_FILES:-${CLAIM_PRESERVE_FILES:-}}

if [ -z "$FILES" ]; then
  echo "FAIL MARKDOWN_STRUCTURE_FILES empty — name every file the pass touches"
  exit 1
fi

TMP=$(mktemp -d "${TMPDIR:-/tmp}/md-structure.XXXXXX")
trap 'rm -rf "$TMP"' EXIT
printf '%s\n' "$FILES" | sed '/^$/d' >"$TMP/files"

export ROOT BASE TMP
python3 - <<'PY'
import os, re, subprocess, sys
from pathlib import Path

root = Path(os.environ["ROOT"])
base = os.environ["BASE"]
paths = [l.strip() for l in (Path(os.environ["TMP"]) / "files").read_text().splitlines() if l.strip()]
reds = 0

def pipe_count(line: str) -> int:
    s = line.strip()
    return s.count("|") if s.startswith("|") else 0

def is_separator(line: str) -> bool:
    s = line.strip()
    if not s.startswith("|"):
        return False
    inner = s.strip("|").strip()
    return bool(inner) and re.fullmatch(r"[|\s:\-]+", inner) is not None

def strip_pass(t: str) -> str:
    return re.sub(r"^Radiant pass `[^`]+`\n?", "", t, flags=re.M)

def check_tables(text: str, path: str) -> None:
    global reds
    lines = text.splitlines()
    for j, line in enumerate(lines):
        if not is_separator(line):
            continue
        # find previous non-blank line as header
        i = j - 1
        while i >= 0 and not lines[i].strip():
            i -= 1
        if i < 0 or not lines[i].strip().startswith("|"):
            print(f"FAIL table separator without header: {path}:{j+1}")
            reds += 1
            continue
        if is_separator(lines[i]):
            continue
        if pipe_count(lines[i]) != pipe_count(line):
            print(f"FAIL table pipe mismatch header={pipe_count(lines[i])} sep={pipe_count(line)}: {path}:{i+1}")
            reds += 1
            return
    print(f"OK   tables: {path}")

def check_fences(text: str, path: str) -> None:
    global reds
    count = len(re.findall(r"^```", text, re.M))
    if count % 2:
        print(f"FAIL unbalanced code fences ({count}): {path}")
        reds += 1
        return
    print(f"OK   fences: {path}")

def check_links(text: str, path: str) -> None:
    global reds
    for i, line in enumerate(text.splitlines(), 1):
        if re.search(r"\[[^\]]*\]\([^)\n]*$", line):
            print(f"FAIL unclosed link: {path}:{i}")
            reds += 1
            return
    print(f"OK   links: {path}")

def heading_signature(text: str):
    return [(len(m.group(1)), line.strip()) for line in text.splitlines()
            if (m := re.match(r"^(#{1,6})\s", line))]

for path in paths:
    p = root / path
    if not p.is_file():
        print(f"FAIL missing: {path}")
        reds += 1
        continue
    if not path.endswith(".md"):
        print(f"OK   skip non-md: {path}")
        continue
    text = p.read_text(encoding="utf-8")
    check_tables(text, path)
    check_fences(text, path)
    check_links(text, path)
    try:
        before = subprocess.run(["git", "show", f"{base}:{path}"], capture_output=True, text=True, check=True).stdout
        if heading_signature(strip_pass(before)) != heading_signature(strip_pass(text)):
            print(f"FAIL heading levels changed: {path}")
            reds += 1
        else:
            print(f"OK   headings: {path}")
    except subprocess.CalledProcessError:
        print(f"OK   headings (new file): {path}")

if reds:
    print(f"FAIL markdown_structure count={reds}")
    sys.exit(1)
print("OK   markdown_structure clean")
PY
