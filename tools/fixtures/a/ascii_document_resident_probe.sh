#!/bin/sh
# tools/fixtures/a/ascii_document_resident_probe.sh -- the same census, read by ONE process.
#
# WHAT THIS IS. A research probe, reported and never gated, standing beside
# `tools/fixtures/a/ascii_document_scan.sh` rather than replacing it. The guard is the guard; this
# is the experiment that prices it.
#
# WHY IT EXISTS. `external-research/20260910-072912_the-seconds-this-pier-actually-spends.md`
# projected that a resident reader -- one process that opens the tree once and answers many
# questions -- would remove the KERNEL half of this pier's assurance bill rather than the whole
# bill, and named its own falsifier: implement one representative guard as a single long-lived
# process and measure its CPU seconds against the shell form on the same tree, where a saving
# under a factor of two says the bill is not the shape claimed. This is that implementation.
#
# WHY THIS GUARD. `ascii_document_scan.sh` was the most expensive single scan on the roster read
# `20260910.065600` -- 26.1 CPU seconds -- and its shape is the family's shape: a shell loop over
# a tracked listing, spawning a process per item. It reads 6,221 tracked documents, asks a
# membership question of each with `grep -qxF`, and counts characters in the 447 that survive with
# one `awk` apiece.
#
# WHAT IS HELD IDENTICAL. The population rule, the skip rules, the two rosters, the octal high-byte
# class, and the named/unnamed table are transcribed from the scan without change, and the probe
# prints the same key lines so the two answers can be compared byte for byte. A probe that is
# cheaper because it does less measures nothing.
#
# WHAT DIFFERS, and it is the whole subject: every per-file process is gone. One `awk` reads the
# listing, builds both rosters, opens each counted file with `getline`, and prints the census.
#
# USAGE
#   sh tools/fixtures/a/ascii_document_resident_probe.sh          # the census, one process
#   sh tools/fixtures/a/ascii_document_resident_probe.sh --agree  # run both, diff the key lines
#
# Run from the repository root.
set -u

mode="${1:-census}"
root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "instrument=failed"
  echo "detail=not_a_git_tree"
  echo "verdict=misread"
  exit 1
}
cd "$root" || exit 1

CEILING="${ASCII_DOC_CEILING:-770}"
ENFORCE_GLOBS="${ASCII_DOC_ENFORCE_GLOBS:-.claude/rules/*.md .cursor/rules/*.mdc docs/*.md}"
DERIVE_GLOBS="${ASCII_DOC_DERIVE_GLOBS:-.claude/rules/*.md .cursor/rules/*.mdc}"

if [ "$mode" = "--agree" ]; then
  a=$(sh tools/fixtures/a/ascii_document_scan.sh 2>&1)
  b=$(sh tools/fixtures/a/ascii_document_resident_probe.sh 2>&1)
  if [ "$a" = "$b" ]; then
    echo "agree=yes"
    echo "verdict=ok"
    exit 0
  fi
  echo "agree=no"
  printf 'scan:\n%s\nprobe:\n%s\n' "$a" "$b"
  echo "verdict=disagree"
  exit 1
fi

listfile=$(mktemp "${TMPDIR:-/tmp}/ascii-resident.XXXXXX") || {
  echo "instrument=failed"
  echo "detail=mktemp_refused"
  echo "verdict=misread"
  exit 1
}
trap 'rm -f "$listfile"' EXIT INT TERM
if ! git ls-files -- '*.md' '*.mdc' > "$listfile" 2>/dev/null; then
  echo "instrument=failed"
  echo "detail=git_ls_files_refused"
  echo "verdict=misread"
  exit 1
fi

LC_ALL=C awk -v enforce_globs="$ENFORCE_GLOBS" -v derive_globs="$DERIVE_GLOBS" -v ceiling="$CEILING" '
# --- the skip rules, transcribed from the scan -------------------------------------------------
function skip(p,   b) {
  if (p ~ /^(gratitude|vendor|seed)\//) return 1
  if (p ~ /(^|\/)fixtures?\//) return 1
  if (p ~ /(^|\/)(date|archive|yonder)\//) return 1
  b = p; sub(/^.*\//, "", b)
  if (b ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/) return 1
  return 0
}
# A shell glob compared the way the scan compares one: the directory by equality, the basename by pattern, so a
# `*` can never cross a slash because no slash is left for it to cross.
function globmatch(path, g,   pdir, pbase, gdir, gbase, rx) {
  pdir = path; if (pdir ~ /\//) sub(/\/[^\/]*$/, "", pdir); else pdir = "."
  gdir = g;    if (gdir ~ /\//) sub(/\/[^\/]*$/, "", gdir); else gdir = "."
  if (pdir != gdir) return 0
  pbase = path; sub(/^.*\//, "", pbase)
  gbase = g;    sub(/^.*\//, "", gbase)
  rx = gbase
  gsub(/\./, "\\.", rx)
  gsub(/\*/, ".*", rx)
  return (pbase ~ ("^" rx "$"))
}
# One file, counted: total high-byte characters, and how many wear a form the rule table spells.
function count(path,   line, i, n, c, tot, named, two, three, got) {
  tot = 0; named = 0; got = 0
  while ((getline line < path) > 0) {
    got = 1
    n = length(line)
    for (i = 1; i <= n; i++) {
      c = substr(line, i, 1)
      if (c !~ /[\300-\377]/) continue
      tot++
      two = substr(line, i, 2)
      if (two in T2) { named++; continue }
      three = substr(line, i, 3)
      if (three in T3) named++
    }
  }
  close(path)
  CTOT = tot; CNAMED = named
  return got
}
BEGIN {
  T3["\342\200\224"] = 1   # em dash
  T3["\342\200\223"] = 1   # en dash
  T3["\342\200\230"] = 1   # left single quote
  T3["\342\200\231"] = 1   # right single quote
  T3["\342\200\234"] = 1   # left double quote
  T3["\342\200\235"] = 1   # right double quote
  T3["\342\200\246"] = 1   # ellipsis
  T3["\342\206\222"] = 1   # right arrow
  T3["\342\206\220"] = 1   # left arrow
  T3["\342\206\224"] = 1   # left-right arrow
  T3["\342\207\222"] = 1   # rightwards double arrow
  T3["\342\211\240"] = 1   # not equal
  T3["\342\211\244"] = 1   # less-than or equal
  T3["\342\211\245"] = 1   # greater-than or equal
  T3["\342\210\222"] = 1   # typographic minus
  T2["\302\267"] = 1       # middle dot
  ng = split(enforce_globs, EG, " ")
  nd = split(derive_globs, DG, " ")
}
# stage one: the tracked listing
{
  path = $0
  if (path == "") next
  if (substr(path, 1, 1) == "\"") { quoted++; next }
  N++
  ORDER[N] = path
  TRACK[path] = 1
  if (skip(path)) next
  for (i = 1; i <= ng; i++) if (globmatch(path, EG[i])) { WALLED[path] = 1; break }
  for (i = 1; i <= nd; i++) if (globmatch(path, DG[i])) { RULEPAGE[path] = 1; break }
}
END {
  # stage two: the derived canon, read out of the rule rooms the same two ways the law writes it
  for (p in RULEPAGE) {
    while ((getline line < p) > 0) {
      s = line
      while (match(s, /\]\([^)]+\.(md|mdc)\)/)) {
        c = substr(s, RSTART + 2, RLENGTH - 3)
        s = substr(s, RSTART + RLENGTH)
        sub(/#.*/, "", c)
        CAND[c] = 1
      }
      s = line
      while (match(s, /`[A-Za-z0-9_.\/-]+\.(md|mdc)`/)) {
        c = substr(s, RSTART + 1, RLENGTH - 2)
        s = substr(s, RSTART + RLENGTH)
        CAND[c] = 1
      }
    }
    close(p)
  }
  for (c in CAND) {
    d = c
    while (substr(d, 1, 3) == "../") d = substr(d, 4)
    if (substr(d, 1, 2) == "./") d = substr(d, 3)
    if (d == "") continue
    if (skip(d)) continue
    if (!(d in TRACK)) continue
    if (d in WALLED) continue
    DERIVED[d] = 1
  }
  # stage three: the two counts
  enforce_files = 0; enforce_globbed = 0; enforce_derived = 0
  enforce_dirty = 0; enforce_chars = 0
  ratchet_files = 0; ratchet_absent = 0; ratchet_dirty = 0
  ratchet_total = 0; ratchet_named = 0; ratchet_unnamed = 0
  for (i = 1; i <= N; i++) {
    p = ORDER[i]
    if (p in WALLED) {
      if (!count(p)) continue
      enforce_files++; enforce_globbed++
      if (CTOT > 0) { enforce_dirty++; enforce_chars += CTOT; DIRTY[p] = CTOT }
      continue
    }
    if (p in DERIVED) {
      if (!count(p)) continue
      enforce_files++; enforce_derived++
      if (CTOT > 0) { enforce_dirty++; enforce_chars += CTOT; DIRTY[p] = CTOT }
      continue
    }
    if (skip(p)) continue
    ratchet_files++
    if (!count(p)) { ratchet_files--; ratchet_absent++; continue }
    if (CTOT > 0) {
      ratchet_dirty++
      ratchet_total += CTOT
      ratchet_named += CNAMED
      ratchet_unnamed += CTOT - CNAMED
    }
  }
  printf "enforce_files=%d\n", enforce_files
  printf "enforce_globbed=%d\n", enforce_globbed
  printf "enforce_derived=%d\n", enforce_derived
  printf "enforce_dirty_files=%d\n", enforce_dirty
  printf "enforce_chars=%d\n", enforce_chars
  printf "ratchet_files=%d\n", ratchet_files
  printf "ratchet_absent=%d\n", ratchet_absent
  printf "ratchet_unreadable_paths=%d\n", quoted + 0
  printf "ratchet_dirty_files=%d\n", ratchet_dirty
  printf "ratchet_named=%d\n", ratchet_named
  printf "ratchet_unnamed=%d\n", ratchet_unnamed
  printf "ASCII_DOCUMENT files=%d chars=%d ceiling=%d under_ceiling=%s\n", \
    ratchet_files, ratchet_total, ceiling, (ratchet_total <= ceiling ? "yes" : "no")
  # THE REFUSAL PATH IS TRANSCRIBED TOO, and the pen is why. Both readers agreed to the character
  # on the living tree and parted the moment a planted page broke the wall: the probe answered
  # `enforce=broken` where the scan answers `enforce=failed`, printed no `detail=` lines, and
  # exited 0. Agreement on a clean tree proves nothing about a refusal.
  if (enforce_chars != 0) {
    n = 0
    for (p in DIRTY) { n++; RC[n] = DIRTY[p]; RP[n] = p }
    for (a = 1; a <= n; a++) for (b = a + 1; b <= n; b++) \
      if (RC[b] > RC[a]) { t = RC[a]; RC[a] = RC[b]; RC[b] = t; u = RP[a]; RP[a] = RP[b]; RP[b] = u }
    for (a = 1; a <= n; a++) {
      print "detail=non_ascii_in_enforced_document"
      printf "detail_path=%s\n", RP[a]
      printf "detail_chars=%d\n", RC[a]
    }
    print "enforce=failed"
    print "verdict=misread"
    exit 1
  }
  print "enforce=honored"
  if (ratchet_total > ceiling) {
    print "detail=ratchet_rose_above_ceiling"
    print "verdict=misread"
    exit 1
  }
  print "story=rule_rooms_at_zero>living_documents_ratcheted>testimony_and_fixtures_read_past"
  print "verdict=ok"
}
' "$listfile"
