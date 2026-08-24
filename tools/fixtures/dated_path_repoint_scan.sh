#!/bin/sh
# tools/fixtures/dated_path_repoint_scan.sh -- repoint LIVING files at a folded room's new paths.
#
# WHY THIS EXISTS AND WHY IT IS NARROW. The mark law says a stale reference is resolved rather
# than rewritten, and that is right for dated testimony: repointing thousands of session logs and
# counsel notes would breach accrete-never-break at scale, for tidiness. It is NOT right for
# living code. A witness that runs `grep -q ... counsel/20260729-134259_x.md` resolves nothing --
# it simply fails. Folding `counsel`, `active-designing`, `expanding-prompts`, and `waymarks`
# breaks roughly a thousand such functional references across `tools/` alone.
#
# So the rule the tree already implied is written down: LIVING THINGS ARE REPOINTED, DATED
# TESTIMONY IS RESOLVED. The line between them needs no roster, because the tree already draws
# it -- a file whose OWN basename carries a one-clock stamp is testimony and is never opened for
# writing here; every other file is living and may be repointed.
#
# WHAT IT CHANGES, AND NOTHING ELSE. Where a reference names a file that has moved into
# `<room>/date/<day>/`, the matched text becomes that path. Any `../` prefix is carried through
# untouched. A reference that still resolves is left alone, and a file that moved anywhere other
# than into a date fold is left alone -- this repoints the fold and makes no other judgement.
#
# Idempotent: a repointed path holds no bare `<room>/<basename>`, so a second run changes nothing.
#
# THE SHAPE OF A DATED REFERENCE IS DEFINED ONCE, and it ends in a KNOWN EXTENSION. An earlier
# shape here ended in a greedy character class, so a reference written mid-sentence as
# `.../a-doc.md.` matched with the sentence period attached, the key missed the map, and 49 real
# references went silently unrepointed while `tools/fixtures/dated_path_scan.sh` -- whose regex
# anchors the extension -- reported them broken. Three tools disagreeing about what a dated path
# IS was the recurring fault of this whole arc; the anchored extension is how they agree.
#
# ONE PASS, ON PURPOSE. The first shape of this script tested every mapped path against every
# living file -- O(files x map), the same quadratic shape booked as REDS %113 an hour earlier,
# and it was killed after two minutes without finishing. This scans each line once with a regex
# and looks the match up in a hash, so the cost is the size of the tree rather than its square.
#
# USAGE
#   sh tools/fixtures/dated_path_repoint_scan.sh          # dry run -- reports, touches nothing
#   sh tools/fixtures/dated_path_repoint_scan.sh apply    # rewrite the living files
#
# Driven by tools/d/dated_path_repoint.rish; proven by tools/d/dated_path_repoint_witness.rish.
# Run from the repository root.

set -eu

mode="${1:-dry}"
# What is not the field -- read from ONE list that this tool and the census both source. The two
# kept private copies for a day, diverged twice, and the second divergence let this tool rewrite
# the witness fixture that proves it is needed (REDS %121).
# Sourced from THIS script's own directory rather than from the working directory. The control
# corpus runs this scan from a throwaway tree, and a tool that can only find its own parts
# when someone is standing in the repository fails exactly where it is used.
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/dated_path_exclusions.sh"
set -f
DP_FIND_PRUNE="$(dp_find_prune | tr '\n' ' ')"
DP_FIND_EXCLUDES="$(dp_find_excludes | tr '\n' ' ')"
DP_FIND_PATHS="$(dp_find_paths | tr '\n' ' ')"
set +f

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The map is built from the tree as it now stands: every file under a date fold names the flat
# path it used to answer to. Measurement, not memory.
find . -type d \( $DP_FIND_PRUNE \) -prune -o \
  -type f -path '*/date/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/*' -print 2>/dev/null \
  | sed 's|^\./||' \
  | awk -F/ '{
      base = $NF
      if (base !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/) next
      room = ""
      for (i = 1; i <= NF - 3; i++) room = room (i > 1 ? "/" : "") $i
      if (room == "") next
      print room "/" base "\t" $0
    }' | sort -u > "$work/map.tsv"

echo "folded_files_mapped=$(wc -l < "$work/map.tsv" | tr -d ' ')"

# Living files only -- a dated basename is testimony and is never opened for writing here.
# The stamp alone marks it: the sprig is OPTIONAL (session-logs adds one only when two logs share
# a second), so 237 logs are named `YYYYMMDD-HHMMSS.ext`. Requiring an underscore read every one
# of them as living and open for writing -- REDS %175, found when a hand-written sweep with the
# same too-narrow pattern rewrote two of them. The
# candidate list is narrowed by one grep first, so awk is spawned only for files that could
# possibly hold a dated reference.
# THE INSTRUMENT'S OWN FIXTURES ARE NOT THE FIELD, and this cost a real red to learn (%121).
# tools/d/dated_path_witness.rish holds a deliberately STALE reference -- the flat path a file
# answered to before its room folded -- because proving the resolver recovers such a path requires
# having one. An earlier apply run repointed it to the folded path, which left the assert checking
# that an already-correct path resolves: true, and worthless. The census already excluded these by
# name; the repointer did not, and a tool that edits its own test fixtures quietly disarms them.
# Globbing stays off: `dated_path_*` is a pattern for find, not one the shell should resolve
# against whatever directory a caller happens to be standing in.
set -f
find . -type d \( $DP_FIND_PRUNE \) -prune -o -type f \
  $DP_FIND_EXCLUDES $DP_FIND_PATHS \
  \( -name '*.md' -o -name '*.mdc' -o -name '*.rish' -o -name '*.rye' -o -name '*.sh' \
     -o -name '*.bron' -o -name '*.kyri' -o -name '*.brix' -o -name '*.txt' \) -print 2>/dev/null \
  | sed 's|^\./||' \
  | awk -F/ '$NF !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/' \
  > "$work/living.txt"
set +f

echo "living_files_considered=$(wc -l < "$work/living.txt" | tr -d ' ')"

xargs -a "$work/living.txt" -d '\n' grep -lIE '[0-9]{8}-[0-9]{6}[_.]' 2>/dev/null \
  > "$work/candidates.txt" || true
echo "candidates_holding_a_dated_path=$(wc -l < "$work/candidates.txt" | tr -d ' ')"

# ONE awk per chunk of files, reading the map once -- not once per file. The first shape read
# the 4,204-line map inside every one of 3,172 invocations and did not finish; the cost of a
# lookup table is paid once or it is paid forever.
: > "$work/hits.tsv"
if [ -s "$work/candidates.txt" ]; then
  xargs -a "$work/candidates.txt" -d '\n' -n 400 \
    awk -v mapfile="$work/map.tsv" -v mode="$mode" '
      BEGIN {
        while ((getline line < mapfile) > 0) { split(line, p, "\t"); map[p[1]] = p[2] }
        close(mapfile)
        prev = ""; hits = 0
      }
      FNR == 1 {
        if (prev != "") { close(prev ".dpr"); if (hits > 0) print prev "\t" hits > "/dev/stderr" }
        prev = FILENAME; hits = 0
      }
      {
        line = $0; out = ""
        while (match(line, /(\.\.\/)*([A-Za-z0-9_.-]+\/)+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9](_[A-Za-z0-9._-]+)?\.(md|bron|kyri|rye|rish|tsv|brix|glow|sh|txt)/)) {
          pre = substr(line, 1, RSTART - 1)
          m = substr(line, RSTART, RLENGTH)
          line = substr(line, RSTART + RLENGTH)
          key = m
          while (sub(/^\.\.\//, "", key)) ;
          prefix = substr(m, 1, length(m) - length(key))
          # A path can be reached through a leading segment the map never holds -- a shell variable
          # written as $ROOT/room/file.md matches from ROOT/ onward, since $ is not a path character.
          # So leading segments move into the prefix one at a time until the remainder is a key the
          # map knows. The prefix is carried through untouched, so nothing is lost.
          tries = 0
          while (!(key in map) && index(key, "/") > 0 && tries < 4) {
            cut = index(key, "/")
            prefix = prefix substr(key, 1, cut)
            key = substr(key, cut + 1)
            tries++
          }
          if (key in map) { m = prefix map[key]; hits++ }
          out = out pre m
        }
        print out line > (FILENAME ".dpr")
      }
      END {
        if (prev != "") { close(prev ".dpr"); if (hits > 0) print prev "\t" hits > "/dev/stderr" }
      }
    ' 2>> "$work/hits.tsv"
fi

if [ -s "$work/hits.tsv" ]; then sed 's/^/would_repoint: /' "$work/hits.tsv"; fi
changed=$(wc -l < "$work/hits.tsv" | tr -d ' ')
edits=$(awk -F'\t' '{n += $2} END {print n + 0}' "$work/hits.tsv")

# The rewritten copies land beside their originals and are swept either way, so a dry run leaves
# the tree byte-identical and an apply moves only the files that actually changed.
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if [ "$mode" = apply ] && [ -f "$f.dpr" ]; then
    cat "$f.dpr" > "$f"
  fi
done < "$work/candidates.txt"
while IFS= read -r f; do
  rm -f "$f.dpr"
done < "$work/candidates.txt"

echo "living_files_touched=$changed"
echo "references_repointed=$edits"
echo "mode=$mode"
echo "verdict=ok"
