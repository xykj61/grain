#!/bin/sh
# markdown_structure_scan.sh -- blocking structural integrity for Markdown passes.
# Seated 20260725.114400 - Quin relay repair.
# Lesson 20260725.120701 -- compare COLUMN counts, not raw pipe counts; mask
# inline code and fenced blocks so pipes inside them never split table cells.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

BASE=${MARKDOWN_STRUCTURE_BASE:-${CLAIM_PRESERVE_BASE:-HEAD}}
FILES=${MARKDOWN_STRUCTURE_FILES:-${CLAIM_PRESERVE_FILES:-}}
LIST=${MARKDOWN_STRUCTURE_LIST:-}

if [ -n "$LIST" ] && [ -f "$LIST" ]; then
  FILES=$(sed '/^$/d' "$LIST")
fi

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

def mask_fenced_blocks(text: str) -> str:
    """Replace fenced code block interiors with spaces (keep fence lines)."""
    lines = text.splitlines(keepends=True)
    out = []
    in_fence = False
    for line in lines:
        if re.match(r"^\s*```", line):
            in_fence = not in_fence
            out.append(line)
        elif in_fence:
            out.append(" " * len(line))
        else:
            out.append(line)
    return "".join(out)

def mask_inline_code(line: str) -> str:
    return re.sub(r"`[^`\n]*`", lambda m: " " * len(m.group()), line)

def table_cells(line: str) -> list[str]:
    """Split on unescaped pipes; drop empty leading/trailing from outer pipes."""
    s = line.strip()
    if "|" not in s:
        return []
    parts = s.split("|")
    if parts and parts[0].strip() == "":
        parts = parts[1:]
    if parts and parts[-1].strip() == "":
        parts = parts[:-1]
    return parts

def column_count(line: str) -> int:
    return len(table_cells(line))

def is_separator(line: str) -> bool:
    cells = table_cells(line)
    if not cells:
        return False
    return all(re.fullmatch(r"\s*:?-+:?\s*", c) for c in cells)

def strip_pass(t: str) -> str:
    return re.sub(r"^Radiant pass `[^`]+`\n?", "", t, flags=re.M)

def check_tables(text: str, path: str) -> None:
    global reds
    masked = mask_fenced_blocks(text)
    lines = masked.splitlines()
    for j, line in enumerate(lines):
        work = mask_inline_code(line)
        if not is_separator(work):
            continue
        i = j - 1
        while i >= 0 and not lines[i].strip():
            i -= 1
        if i < 0:
            print(f"FAIL table separator without header: {path}:{j+1}")
            reds += 1
            continue
        hdr = mask_inline_code(lines[i])
        if is_separator(hdr):
            continue
        hdr_cols = column_count(hdr)
        sep_cols = column_count(work)
        if hdr_cols == 0:
            print(f"FAIL table header without pipes: {path}:{i+1}")
            reds += 1
            continue
        if hdr_cols != sep_cols:
            print(f"FAIL table column mismatch header={hdr_cols} sep={sep_cols}: {path}:{i+1}")
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
    masked = mask_fenced_blocks(text)
    for i, line in enumerate(masked.splitlines(), 1):
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
