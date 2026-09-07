#!/bin/sh
# tools/fixtures/r/readme_reach_scan.sh -- every link a newcomer can reach from the front door resolves.
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
# WHAT IS REPORTED, and deliberately NOT ratcheted. Broken links in dated testimony reachable from
# the front door. A ceiling here was tried and removed on the lap it was written (`20260823.201533`),
# because it measured the wrong thing: adding ONE index page reached five more documents and the
# testimony count rose with them, so the ratchet would have punished the tree for opening a door.
# The count is a function of REACH as much as of repair.
#
# The duty it looked like it was doing is already owned, and owned better.
# `tools/d/dated_path_witness.rish` gates the LOST count -- a basename that exists nowhere, or one at
# two paths where no answer is safe -- with no slack, and its own header explains why it gates that
# rather than the whole broken count: a recovered reference is the expected steady state and rises
# whenever a room folds. A second meter over the same quantity is the trap this tree already names
# (the three dated-path tools must agree on what a dated file is), so this one reports and stops.
# Testimony is resolved rather than rewritten:
# `rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>`.
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
# TWO STORES, ONE LAW (`--store`, added 20260907 for REDS %524). The law above -- what a link is,
# what living means, what passes free -- is spelled once and answered out of either of two stores:
#
#   worktree  the files on disk. The default, and what the roster reads: a hand's own tree.
#   index     the blobs `git cat-file -p :<path>` returns, and the paths `git ls-files` lists.
#             This is the tree a commit being made will actually carry, which is why the
#             pre-commit wall reads it. A crawl off disk at commit time answers about a tree
#             nobody is committing: it refuses for an unstaged edit and waves through a staged
#             deletion the worktree still holds.
#
# The store changes WHERE the bytes come from and nothing else. Writing a second link reader for
# the commit-time question would put one rule in two files, which is the fault REDS %382 booked.
#
# WHY THE INDEX STORE EXISTS AT ALL. REDS %524 fired four times: a fold that a rebase reshapes
# leaves every citation of its planned shelf name pointing at a file nobody wrote. Every firing
# arrived by rebase -- a commit landing by a path no hook sees -- and every one was caught by this
# scan at the NEXT cold roster pass, half an hour after the push made it public. The reading was
# never too expensive to pay at commit time; it was simply never asked there.
#
# USAGE
#   sh tools/fixtures/r/readme_reach_scan.sh
#   sh tools/fixtures/r/readme_reach_scan.sh <root-file>          # a pen's own tree
#   sh tools/fixtures/r/readme_reach_scan.sh --store index        # what this commit will carry
#
# Driven by tools/r/readme_reach_witness.rish. Run from the repository root.

set -u

store=worktree
root_file=

while [ $# -gt 0 ]; do
  case "$1" in
    --store)
      shift
      [ $# -gt 0 ] || { echo "verdict=no_store"; echo "refused: --store wants worktree or index" >&2; exit 1; }
      case "$1" in
        worktree|index) store=$1 ;;
        *) echo "verdict=no_store"; echo "refused: unknown store $1 -- worktree or index" >&2; exit 1 ;;
      esac ;;
    --store=*)
      case "${1#--store=}" in
        worktree|index) store=${1#--store=} ;;
        *) echo "verdict=no_store"; echo "refused: unknown store ${1#--store=} -- worktree or index" >&2; exit 1 ;;
      esac ;;
    -*) echo "verdict=no_argument"; echo "refused: unknown option $1" >&2; exit 1 ;;
    *) root_file=$1 ;;
  esac
  shift
done

root_file=${root_file:-README.md}
echo "store=$store"

# The root is asked of the store that will answer every other question, so the two can never
# disagree about which tree this reading is about.
if [ "$store" = index ]; then
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_index"; echo "refused: the index store wants a git repository" >&2; exit 1; }
  git cat-file -e ":$root_file" 2>/dev/null || { echo "verdict=no_root"; echo "refused: $root_file is the door this scan starts at, and the index does not carry it" >&2; exit 1; }
elif [ ! -f "$root_file" ]; then
  echo "verdict=no_root"
  echo "refused: $root_file is the door this scan starts at, and it is absent" >&2
  exit 1
fi

command -v python3 >/dev/null 2>&1 || { echo "verdict=no_python"; echo "refused: this crawl wants python3" >&2; exit 1; }

python3 - "$root_file" "$store" <<'PY'
import os, re, sys, collections, subprocess

root = os.getcwd()
start = sys.argv[1]
store = sys.argv[2]
LINK = re.compile(r'\[[^\]]*\]\(([^)\s]+)')
STAMP = re.compile(r'^\d{8}-\d{6}[_.]')   # the sprig is optional (REDS %175)

# A collection names its maximum (TAME). The tree carries 16,136 index entries and 5,669 tracked
# `.md` files at 20260907; 65,536 is the next power of two well above a fourfold growth, and it
# bounds the crawl rather than the tree.
MAX_DOCS = 65536


def rel(p):
    return os.path.relpath(os.path.normpath(p), root)


if store == 'index':
    # One subprocess for the path set and one long-lived `cat-file --batch` for the bodies. A
    # `git cat-file -p` per document would be 1,884 processes where this is two.
    listed = subprocess.run(['git', 'ls-files', '-z'], stdout=subprocess.PIPE, check=True)
    paths = set(p for p in listed.stdout.decode('utf-8', 'replace').split('\0') if p)
    if len(paths) > MAX_DOCS:
        print("detail=RED_index_past_bound")
        print("detail_max=%d" % MAX_DOCS)
        print("verdict=misread")
        sys.exit(1)
    # A link may name a directory, which the index carries only as the prefix of its files.
    dirs = set()
    for p in paths:
        d = os.path.dirname(p)
        while d:
            dirs.add(d)
            d = os.path.dirname(d)
    batch = subprocess.Popen(['git', 'cat-file', '--batch'],
                             stdin=subprocess.PIPE, stdout=subprocess.PIPE)

    def exists(p):
        return p in paths or p in dirs

    def body_of(p):
        # A path holding a newline cannot be asked of `--batch`, and the link pattern above
        # excludes whitespace, so no reachable target can carry one.
        batch.stdin.write((':' + p + '\n').encode('utf-8'))
        batch.stdin.flush()
        header = batch.stdout.readline().decode('utf-8', 'replace').strip()
        if not header or header.endswith(' missing'):
            return None
        size = int(header.split()[2])
        data = batch.stdout.read(size + 1)[:size]
        return data.decode('utf-8', 'replace')
else:
    def exists(p):
        return os.path.exists(os.path.join(root, p))

    def body_of(p):
        full = os.path.join(root, p)
        if not os.path.isfile(full):
            return None
        try:
            return open(full, encoding='utf-8', errors='replace').read()
        except OSError:
            return None

seen = {start: 0}
queue = collections.deque([start])
broken = []

while queue:
    f = queue.popleft()
    body = body_of(f)
    if body is None:
        continue
    for m in LINK.finditer(body):
        target = m.group(1).split('#')[0]
        if not target or target.startswith(('http://', 'https://', 'mailto:')):
            continue
        landed = rel(os.path.join(root, os.path.dirname(f), target))
        if landed.startswith('..') or not exists(landed):
            broken.append((f, target))
            continue
        if landed.endswith('.md') and landed not in seen:
            if len(seen) >= MAX_DOCS:
                print("detail=RED_crawl_past_bound")
                print("detail_max=%d" % MAX_DOCS)
                print("verdict=misread")
                sys.exit(1)
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

for f, t in living[:40]:
    print("living: %s -> %s" % (f, t))

if living:
    print("verdict=living_link_broken")
    sys.exit(2)
print("verdict=ok")
PY
