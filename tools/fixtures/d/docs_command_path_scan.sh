#!/bin/sh
# tools/fixtures/d/docs_command_path_scan.sh -- a path a page tells a reader to RUN is a path
# the tree carries.
#
# WHY. Two pages of the shipping shelf print
#   rishi/bin/rishi run tools/g/glow_run.rish edu/pleac/ch01/gate-say-u32.glow 21
# and that file has lived at docs-geode/edu/yonder/pleac/ch01/gate-say-u32.glow since the room
# folded. Copied as printed, the command exits 1 on FileNotFound. Both pages carry a rostered
# witness that runs every lap and reads GREEN, because the witness holds its own copy of the
# path and was repointed when the room moved. The page was not.
#
# Nothing in the tree could see it. tools/t/tracked_link_witness.rish reads Markdown LINKS, and
# a path typed as a command argument is no link. tools/p/phantom_path_witness.rish reads path
# literals inside tool SOURCES, and a page is not a tool. tools/d/dated_path_witness.rish reads
# references carrying a one-clock stamp, and `gate-say-u32.glow` carries none. The fault sat in
# the seam between three guards, and a reader running the command was the only instrument that
# could reach it.
#
# WHAT IS GATED, hard, at zero. A path a page tells a reader to RUN that resolves NOWHERE, and
# whose basename the tracked tree carries at exactly one other path. That pair of facts is what
# makes it a MOVED file rather than a missing one, so the scan can name the repair rather than
# only the complaint.
#
# A COMMAND WEARS BACKTICKS AS OFTEN AS A FENCE. The first-hour page of the OS user manual hands
# a newcomer two witnesses inside a table cell -- `Run `tools/kumara_tilak_witness.rish`, ...` --
# and both had moved with the tools letter fold. A fence-only reader cannot see a table cell, so
# the VERB is what marks it: an inline code span introduced by run, runs, or running is read as a
# command, and a bare backtick is read as a name. Measured over the whole tree, that widening
# finds 37 more printed paths and no new living fault -- narrow enough to be honest, and it is
# the shape that bit.
#
# A MANUAL INSTRUCTS, WHERE A LOG RECORDS. Every page under manual/ and nixos-guide/ carries a
# one-clock stamp, because the naming law names every file that way -- so a test reading the
# stamp read the OS user manual as a record of what was once true, and eleven printed commands
# stood broken there. Those two rooms are read as LIVING whatever their basename says. It is a
# roster of two rather than a rule, and the reason is a property of the rooms rather than of
# their names: a manual instructs a reader today, so its stamp is a birth date rather than a
# claim. A page on a date/ or archive/ shelf stays testimony wherever it sits.
#
# A PAGE IS JUDGED BY ITS OWN NAME, NEVER BY THE NAME IT PRINTS. The elder testimony test read
# the whole row, so a LIVING page printing a path whose basename carried a stamp excused itself
# with that other file's stamp -- which is how docs-geode/demos/README.md went unread. The test
# reads the page field alone now.
#
# A STALE PATH IS WHAT A RESOLVER TAKES. A page demonstrating dated_path_resolve or
# tool_path_resolve prints a path the tree deliberately no longer carries, since recovering one
# is the tool's whole subject. Such a line passes free, so the tree may keep teaching its own
# repair.
#
# WHAT PASSES FREE, by one rule rather than a table. A printed path the tree does not carry at
# all is a path the READER creates -- `tools/fixtures/my_first_witness.rish` in a tutorial that
# asks you to write it, `tools/l/launch-zed.sh` which a host copies from the tracked
# `.example` beside it, a submodule left uncloned. Thirteen such paths stand on living pages
# today and every one of them is honest, so the guard asks the tree what it carries rather than
# asking a maintainer to keep an exemption list true.
#
# Three rescues run before a path is called missing, each an ordinary way a page writes a
# command: the path resolves from the repository root; a `cd` earlier in the same fenced block
# makes it resolve; or it resolves from the page's own directory.
#
# DATED TESTIMONY IS REPORTED, NEVER GATED. Accrete-never-break: a log from June names
# `tools/tame_style_check.rish` because that is where the file stood in June. Every path in this
# class is exactly that, and rewriting them would edit testimony to tidy a meter. Read the count
# from the scan rather than from this comment -- it moves with every fold.
#
# USAGE
#   sh tools/fixtures/d/docs_command_path_scan.sh
#
# Driven by tools/d/docs_command_path_witness.rish. Run from the repository root.

set -eu

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

git ls-files > "$work/files"

# The pages this reads. gratitude/ and vendor/ are other people's words, and seed/ is the
# projection rather than the field.
grep -E '\.md$' "$work/files" | grep -vE '^(gratitude|vendor|seed)/' > "$work/pages" || : > "$work/pages"
pages=$(wc -l < "$work/pages" | tr -d ' ')

# ONE AWK OVER EVERY PAGE (the lesson of REDS %413, one room over): an awk per file across
# 5,776 pages costs a fork apiece for a pass that reads each of them once either way.
tr '\n' '\0' < "$work/pages" | LC_ALL=C xargs -0 awk '
  function emit(text, page, dirv, cdv,    n, w, i, t) {
    n = split(text, w, /[ \t"'"'"']+/)
    for (i = 1; i <= n; i++) {
      t = w[i]
      sub(/[),;:]+$/, "", t)
      sub(/^\.\//, "", t)
      if (t !~ /^[A-Za-z0-9_.][A-Za-z0-9_.\/-]*\/[A-Za-z0-9_.-]+\.(rye|rish|sh|glow|md|kyri|bron|brix|brush|myc|txt|awk|zig)$/) continue
      print page "\t" dirv "\t" cdv "\t" t
    }
  }
  FNR == 1 { fence = 0; cd = ""; dir = FILENAME; sub(/\/[^\/]*$/, "", dir); if (dir == FILENAME) dir = "." }
  /^[[:space:]]*```/ { fence = !fence; if (!fence) cd = ""; next }
  !fence {
    line = $0
    while (match(line, /[Rr]un(ning|s)? +`[^`]+`/)) {
      s = RSTART; l = RLENGTH
      seg = substr(line, s, l)
      if (match(seg, /`[^`]+`/)) emit(substr(seg, RSTART + 1, RLENGTH - 2), FILENAME, dir, "")
      line = substr(line, s + l)
    }
    next
  }
  $1 == "cd" { cd = $2; next }
  # A stale path is what a RESOLVER takes. tools/d/dated_path_resolve.rish and
  # tools/t/tool_path_resolve.rish exist to recover a reference written at an old path, so a
  # page demonstrating one prints a path the tree deliberately no longer carries -- the input
  # IS the point. Reading that as a fault would ask the tree to stop teaching its own repair.
  /_path_resolve\.rish/ { next }
  { emit($0, FILENAME, dir, cd) }
' > "$work/printed"
printed=$(wc -l < "$work/printed" | tr -d ' ')

# A path resolves for a reader who clones when the repository carries it, so the tracked list is
# the authority rather than this filesystem -- the same reading tools/p/phantom_path_scan.sh
# takes, and for the same reason: a guard reading nothing passes as readily as one reading
# everything.
sort -u "$work/files" > "$work/known"

# The basename lookup reads past the same three rooms the page list does, and for the same
# reason. gratitude/ is a reading library of other people's code rather than a dependency
# (.claude/rules/gratitude-licenses.md), so a page quoting `docs/TIGER_STYLE.md` inside a
# commit body is naming TIGERBEETLE's path -- our tree merely happens to carry a file of that
# basename. vendor/ is the same, and seed/ is this tree's own projection rather than the field.
grep -vE '^(gratitude|vendor|seed)/' "$work/known" > "$work/ours" || : > "$work/ours"

awk -F'\t' '
  NR == FNR { known[$0] = 1; next }
  {
    page = $1; dir = $2; cd = $3; p = $4
    if (p in known) next
    if (cd != "" && (cd "/" p) in known) next
    if ((dir "/" p) in known) next
    print page "\t" p
  }
' "$work/known" "$work/printed" | sort -u > "$work/missing"
missing=$(wc -l < "$work/missing" | tr -d ' ')

# The one question that tells a moved file from a file the reader creates: does the tree carry
# this basename somewhere else, and at exactly one place, so the repair has one answer?
awk -F'\t' '
  NR == FNR { b = $0; sub(/.*\//, "", b); count[b]++; at[b] = $0; next }
  { b = $2; sub(/.*\//, "", b); if (count[b] == 1) print $1 "\t" $2 "\t" at[b] }
' "$work/ours" "$work/missing" > "$work/moved"
moved=$(wc -l < "$work/moved" | tr -d ' ')

# Dated testimony keeps every word it wrote: a page whose own basename carries a one-clock
# stamp, and every page on a date/ or archive/ shelf.
awk -F'\t' '
  {
    shelf   = ($1 ~ /(^|\/)(date|archive)\//)
    stamped = ($1 ~ /\/[0-9]{8}-[0-9]{6}[_.]/)
    manual  = ($1 ~ /^(manual|nixos-guide)\//)
    if (shelf) next
    if (stamped && !manual) next
    print
  }
' "$work/moved" > "$work/living" || : > "$work/living"
living=$(wc -l < "$work/living" | tr -d ' ')
testimony=$((moved - living))

echo "pages=$pages"
echo "printed_paths=$printed"
echo "unresolved=$missing"
echo "moved_files=$moved"
echo "moved_testimony=$testimony"
echo "moved_living=$living"

if [ "$living" -gt 0 ]; then
  while IFS="$(printf '\t')" read -r page p at; do
    echo "detail: $page prints $p -- the tree carries it at $at"
  done < "$work/living"
  echo "verdict=moved_path_printed"
  exit 1
fi

echo "verdict=ok"
