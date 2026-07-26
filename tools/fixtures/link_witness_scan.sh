#!/bin/sh
# link_witness_scan.sh — walk relative markdown links; assert targets resolve.
# Blocking. Env LINK_WITNESS_FILES (newline paths) or walk the tree.
# Exit 1 on any dangling relative link (except when LINK_WITNESS_ALLOW_BASELINE=1,
# which prints the count and exits 0 for the first-run baseline).
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

python3 - <<'PY'
import os, re, sys
from pathlib import Path

root = Path(".").resolve()
files_env = os.environ.get("LINK_WITNESS_FILES", "").strip()
# Baseline allow only on full-tree walks — never when a fixture file list is set.
allow = (os.environ.get("LINK_WITNESS_ALLOW_BASELINE", "") == "1") and (not files_env)

if files_env:
    paths = [Path(p) for p in files_env.splitlines() if p.strip()]
else:
    paths = sorted(root.rglob("*.md"))
    # Skip heavy / third-party trees
    skip_parts = {".git", "vendor", "gratitude", "old", "vere", "node_modules", ".cursor-state"}
    # Negative fixtures must fail under LINK_WITNESS_FILES — never inflate the tree baseline.
    skip_files = {"link_witness_broken.md"}
    paths = [
        p
        for p in paths
        if not any(part in skip_parts for part in p.parts)
        and p.name not in skip_files
    ]

link_re = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
dangling = []
checked = 0

for path in paths:
    if not path.is_file():
        continue
    try:
        text = path.read_text(encoding="utf-8")
    except Exception as e:
        print(f"FAIL read {path}: {e}")
        sys.exit(1)
    for m in link_re.finditer(text):
        target = m.group(1).strip()
        if not target or target.startswith("#"):
            continue
        # strip title "..." and anchors
        target = target.split()[0].strip('"').strip("'")
        if target.startswith(("http://", "https://", "mailto:", "data:")):
            continue
        href, _, _frag = target.partition("#")
        if not href:
            continue
        checked += 1
        dest = (path.parent / href).resolve()
        try:
            dest.relative_to(root)
        except ValueError:
            # outside tree — treat as ok for now (absolute / escape)
            continue
        if not dest.exists():
            dangling.append(f"{path}:{href}")

print(f"link_witness: files={len(paths)} relative_links_checked={checked} dangling={len(dangling)}")
for d in dangling[:50]:
    print(f"FAIL dangling: {d}")
if len(dangling) > 50:
    print(f"... and {len(dangling) - 50} more")

if dangling and not allow:
    print(f"FAIL link_witness count={len(dangling)}")
    sys.exit(1)
if dangling and allow:
    print(f"BASELINE link_witness dangling={len(dangling)} — honest start; not a stop")
    sys.exit(0)
print("OK   link_witness clean — every relative target resolves")
sys.exit(0)
PY
