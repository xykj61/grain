#!/bin/sh
# claim_preserve_extract.sh — emit sorted unique claim tokens from a file.
#
# Token classes:
#   NUM     — integers and decimals
#   HEX     — hex digests (≥8 hex chars, optional 0x)
#   FP      — OpenPGP-ish fingerprint clumps (4+ hex groups)
#   PATH    — repo-relative or rooted paths with a slash and extension-ish segment
#   STAMP   — YYYYMMDD.HHMMSS or YYYYMMDD-HHMMSS
#   PROPER  — Capitalized proper nouns (ASCII), length ≥2, not all-caps acronyms ≤3
#
# Usage: sh tools/fixtures/claim_preserve_extract.sh <path>
# stdout: one token per line, sorted unique, prefixed with CLASS:
set -eu

path=${1:?"usage: claim_preserve_extract.sh <path>"}
[ -f "$path" ] || { echo "missing $path" >&2; exit 1; }

python3 - "$path" <<'PY'
import re, sys
from pathlib import Path
text = Path(sys.argv[1]).read_text(encoding="utf-8", errors="replace")
# Strip fenced code lightly? Keep code — digests often live there.
tokens = set()

for m in re.finditer(r"\b\d{8}\.\d{6}\b", text):
    tokens.add(f"STAMP:{m.group(0)}")
for m in re.finditer(r"\b\d{8}-\d{6}\b", text):
    tokens.add(f"STAMP:{m.group(0)}")

for m in re.finditer(r"\b(?:0x)?[0-9a-fA-F]{8,}\b", text):
    g = m.group(0)
    # skip pure stamps already classified
    if re.fullmatch(r"\d{8}\d{6}", g.replace(".", "").replace("-", "")):
        continue
    tokens.add(f"HEX:{g.lower()}")

# fingerprint-like: groups of 4 hex separated by space
for m in re.finditer(r"\b(?:[0-9A-F]{4}\s+){3,}[0-9A-F]{4}\b", text):
    tokens.add(f"FP:{re.sub(r'\s+', ' ', m.group(0).upper())}")

for m in re.finditer(r"\b\d+(?:\.\d+)?\b", text):
    g = m.group(0)
    # skip stamp fragments
    if len(g) == 8 and g.isdigit():
        continue
    tokens.add(f"NUM:{g}")

# paths: word with / and a dot segment or known roots
for m in re.finditer(
    r"(?<![A-Za-z0-9_])(?:\.\./)?(?:context|tools|counsel|foundations|waymarks|linengrow|session-logs|work-in-progress|docs|glow|rye|rishi|keys|vendor|gratitude|active-designing|external-research)/[A-Za-z0-9_./+*-]+",
    text,
):
    tokens.add(f"PATH:{m.group(0)}")

# Capitalized proper nouns — sequences of Cap words
for m in re.finditer(r"\b[A-Z][a-z]{1,}(?:\s+[A-Z][a-z]{1,}){0,3}\b", text):
    g = m.group(0)
    # skip month-like noise and Language/Status labels alone
    if g in {
        "Language", "Status", "Stamp", "Voice", "Style", "Bound", "Room",
        "Counsel", "Related", "Ground", "May", "And", "The", "This", "That",
        "With", "From", "Into", "Over", "Under", "After", "Before", "Every",
        "Each", "When", "Where", "What", "How", "Why", "For", "Our", "Your",
    }:
        continue
    tokens.add(f"PROPER:{g}")

for t in sorted(tokens):
    print(t)
PY
