#!/bin/sh
# tools/fixtures/readme_reach_scan.sh -- every link a newcomer can reach from the front door resolves.
#
# WHY. Four guards already read links, and each asks a different question. `tracked_link` asks
# whether a SYMLINK lands inside the tracked tree. `seed_link` asks whether a link survives the
# PROJECTION into the public seed. `foundations_link` asks it of one room. `living_docs_lint`
# reports broken links tree-wide as an advisory nobody gates on.
#
# None of them asks the newcomer's question: **starting at README.md and following links, does
# every door open?** Measured for the first time on 20260823: the crawl reached 1,389 documents
# fifteen levels deep and found 1,209 broken links. Of those, 1,097 stood in dated testimony -- which
# the mark law resolves rather than rewrites -- and 112 stood in 42 LIVING files, where a broken
# link is simply a broken link. Those 112 are repaired, and this holds them at zero.
#
# WHAT IS GATED, hard, at zero. Every broken relative link inside a LIVING file reachable from
# README.md. A file is living when its own basename carries no one-clock stamp -- the same rule
# tools/d/dated_path_repoint.rish applies, so the two can never disagree about what testimony is.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. Broken links in dated
# testimony reachable from the front door. These are resolved rather than rewritten
# (`rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>`), so the count falls when a
# room folds correctly or a citation is recovered, and it never gates.
#
# WHAT PASSES FREE, by named rule.
#   http, https, and mailto targets -- this scan reads the tree, never the network.
#   A bare `#fragment`, which names a heading in the same document.
#   Any link inside a document NOT reachable from README.md. The claim here is about the front
#     door's own neighbourhood; the wider tree belongs to living_docs_lint.
#
# WHAT IS NOT PROVEN. That the document on the other side is worth reading, or that the link points
# at what the sentence says it points at. This proves the door opens.
#
# USAGE
#   sh tools/fixtures/readme_reach_scan.sh
#   sh tools/fixtures/readme_reach_scan.sh <root-file>   # a pen's own tree
#
# Driven by tools/r/readme_reach_witness.rish. Run from the repository root.

set -u

root_file=${1:-README.md}
ceiling=1108   # measured 20260823.184309 -- it only ever falls

if [ ! -f "$root_file" ]; then
  echo "verdict=no_root"
  echo "refused: $root_file is the door this scan starts at, and it is absent" >&2
  exit 1
fi

command -v python3 >/dev/null 2>&1 || { echo "verdict=no_python"; echo "refused: this crawl wants python3" >&2; exit 1; }

python3 - "$root_file" "$ceiling" <<'PY'
import os, re, sys, collections

root = os.getcwd()
start = sys.argv[1]
ceiling = int(sys.argv[2])
LINK = re.compile(r'\[[^\]]*\]\(([^)\s]+)')
STAMP = re.compile(r'^\d{8}-\d{6}_')

def rel(p):
    return os.path.relpath(os.path.normpath(p), root)

seen = {start: 0}
queue = collections.deque([start])
broken = []

while queue:
    f = queue.popleft()
    full = os.path.join(root, f)
    if not os.path.isfile(full):
        continue
    try:
        body = open(full, encoding='utf-8', errors='replace').read()
    except OSError:
        continue
    for m in LINK.finditer(body):
        target = m.group(1).split('#')[0]
        if not target or target.startswith(('http://', 'https://', 'mailto:')):
            continue
        landed = rel(os.path.join(os.path.dirname(full), target))
        if landed.startswith('..') or not os.path.exists(os.path.join(root, landed)):
            broken.append((f, target))
            continue
        if landed.endswith('.md') and landed not in seen:
            seen[landed] = seen[f] + 1
            queue.append(landed)

def testimony(path):
    return STAMP.match(os.path.basename(path)) is not None

living = [b for b in broken if not testimony(b[0])]
dated = len(broken) - len(living)

print("documents_reached=%d" % len(seen))
print("deepest_level=%d" % (max(seen.values()) if seen else 0))
print("broken_total=%d" % len(broken))
print("broken_in_living=%d" % len(living))
print("living_files_affected=%d" % len(set(b[0] for b in living)))
print("broken_in_testimony=%d" % dated)
print("testimony_ceiling=%d" % ceiling)

for f, t in living[:40]:
    print("living: %s -> %s" % (f, t))

if living:
    print("verdict=living_link_broken")
    sys.exit(2)
if dated > ceiling:
    print("verdict=testimony_over_ceiling")
    sys.exit(3)
print("verdict=ok")
PY
