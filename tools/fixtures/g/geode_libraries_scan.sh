#!/bin/sh
# tools/fixtures/g/geode_libraries_scan.sh -- the module index, read off the tree.
#
# WHY GENERATED. An index keeps its truth for exactly as long as it is counted off the tree rather
# than typed, and every module added or renamed moves the count. A reader trusts an index rather
# than checking it, so the count here is the tree's own, read off disk on every run -- the same
# discipline the README metrics block already keeps.
#
# THE RENDER REPLACES THE PAGE WHOLE. This comment claimed a splice between markers until
# 20260906; `render` below writes the whole file and the page carries no marker at all, so the
# claim was checked against the code beneath it and corrected rather than carried forward.
#
# WHAT COUNTS AS A LIBRARY. A top-level directory holding at least one `.rye` module AND its own
# README.md. Both halves matter: the README is the door a reader opens, the modules are what
# stands behind it, and a room becomes a library by holding both.
#
# USAGE
#   sh tools/fixtures/g/geode_libraries_scan.sh
#
# Driven by tools/g/geode_libraries.rish. Run from the repository root.

set -eu

# HOW THE WITNESSES ARE FOUND, and it is a `find` rather than a shell glob for a reason paid for
# once. Both counts here read `tools/*_witness.rish`, a glob that matched every witness while the
# room stood flat and matched NOTHING the moment `tools/` folded into letter rooms on
# `20260823.144100`. The page then regenerated with a witness count of zero for all thirty-eight
# rooms, and the freshness guard passed -- because the page and the fresh render were computed by
# the same broken glob and agreed perfectly (REDS %169). A recursive find carries no assumption
# about how deep the room is arranged.
witness_roster="$(mktemp)"
witness_tally="$(mktemp)"
room_census="$(mktemp)"
room_names="$(mktemp)"
trap 'rm -f "$witness_roster" "$witness_tally" "$room_census" "$room_names"' EXIT
find tools -type f -name '*_witness.rish' 2>/dev/null | sort > "$witness_roster"

# A ROSTER OF ZERO IS A RED, NEVER A READING. Every count below is taken against this one list, so
# an empty list would hand back a confident zero for all thirty-eight rooms -- which is exactly
# what happened when the flat glob this replaced stopped matching (REDS %169). The refusal is what
# turns a silent wrong number into a stopped line.
if [ ! -s "$witness_roster" ]; then
  echo "refused: no witnesses found under tools/ -- the roster this page counts against is empty" >&2
  exit 1
fi

# THE TOOLCHAIN PATH IS NOT A REFERENCE (REDS %423), and this is the half the reference rule still
# owed. Every Rishi witness invokes `rishi/bin/rishi` and every Rye witness builds with
# `rye/bin/rye`, so testing for the room's path counted the interpreter a witness RUNS UNDER as
# proof of the room it belongs to. The `rishi` row published 1,770 of this tree's 1,801 witnesses
# against a room holding two modules, and `rye` published 1,313 -- two rows naming more witnesses
# than the tree owns. Both entry paths are removed from a line before the room test reads it, so
# what remains was written to name a room rather than to run a program. Measured `20260905`:
# `rishi` 1,770 -> 6 and `rye` 1,313 -> 89, with the other thirty-six rooms unmoved, which is what
# makes the cut narrow enough to trust.
#
# ONE PASS, NOT ONE PER ROOM. The elder shape ran `xargs grep -l` once per room -- thirty-eight
# walks over eighteen hundred files. Reading each witness once and testing every room against each
# line reaches the same answer for a fraction of the work, and it is the only shape that can strip
# the entry path first, since that is a rewrite of the line rather than a filter on it. `awk` also
# spares this count an ERE portability trap: `\b` is absent from BSD grep, so the word boundary is
# spelled as an alternation (REDS %240), and `(^|...)` is read as a whole-pattern anchor by more
# matchers than one.
tally_witnesses() {
  # `-0` is in both xargs dialects; `-a` and `-d` are GNU-only and yield a silent zero on BSD --
  # REDS %169's confident wrong zero through a second door. A long roster is split into batches,
  # so each batch prints every room once and the second awk sums them: each witness counted once.
  #
  # THE LINE IS READ ONCE, NOT ONCE PER ROOM. Testing each of the thirty-eight rooms against every
  # line with a dynamic regex measured 33.9s against the elder's 2.3s -- a fifteenfold cost for a
  # correctness repair, which is a trade nobody should be asked to take. So each line is scanned
  # once for `<word>/` tokens and each token is looked up in a hash: one fixed pattern per line
  # rather than thirty-eight compiled ones, and the work stops depending on how many rooms exist.
  # A line with no `/` in it cannot name a room and is skipped before any matching at all.
  cut -d' ' -f1 "$room_census" > "$room_names"
  tr '\n' '\0' < "$witness_roster" \
    | xargs -0 awk -v roomfile="$room_names" '
        # A token is the run of name characters before a slash. A room matches the whole token, and
        # it also matches a suffix beginning just after a hyphen -- because the rule being kept is
        # that the character before the room name is not a letter, digit, or underscore, and a
        # hyphen is none of those. `caravan/` and `glow-caravan/` both name `caravan`.
        function note(tok,   i, n, sfx) {
          if (tok in roomidx) seen[roomidx[tok]] = 1
          n = length(tok)
          for (i = 1; i < n; i++)
            if (substr(tok, i, 1) == "-") { sfx = substr(tok, i + 1); if (sfx in roomidx) seen[roomidx[sfx]] = 1 }
        }
        function flush(  i) { for (i = 1; i <= nr; i++) { if (seen[i]) hits[i]++; seen[i] = 0 } }
        BEGIN { while ((getline r < roomfile) > 0) if (r != "") { rooms[++nr] = r; roomidx[r] = nr } }
        FNR == 1 && NR > 1 { flush() }
        {
          if (index($0, "/") == 0) next
          line = $0
          gsub(/rishi\/bin/, "", line)
          gsub(/rye\/bin/, "", line)
          while (match(line, /[A-Za-z0-9_-]+\//)) {
            note(substr(line, RSTART, RLENGTH - 1))
            line = substr(line, RSTART + RLENGTH)
          }
        }
        END { flush(); for (i = 1; i <= nr; i++) printf "%s %d\n", rooms[i], hits[i] + 0 }
      ' \
    | awk '{ total[$1] += $2 } END { for (r in total) printf "%s %d\n", r, total[r] }' \
    > "$witness_tally"
}

witness_count() {
  awk -v room="$1" '$1 == room { print $2; found = 1 } END { if (!found) print 0 }' "$witness_tally"
}

# HOW THE MODULES ARE COUNTED, and it asks git rather than the filesystem for a reason paid for
# once. A plain `find` reports every `.rye` on disk, and the `glow` room keeps a `.cache` of 108 generated
# modules the repository deliberately ignores. So the `glow` row published its 130 tracked
# modules plus whatever the last Glow compile had left behind -- 238 on `20260825` -- a number
# that moves when somebody builds and drifts with no commit behind it. The pre-commit hook can
# never catch that one, because it watches STAGED `.rye` changes and an ignored file is never
# staged, so the drift surfaced only at the next roster pass (REDS %216). `git check-ignore` is
# the system's own answer to whether this tree keeps a file, so the count asks it rather than
# guessing from a path. `--non-matching --verbose` prints `::` ahead of every path git does NOT
# ignore, which is exactly the population this page means by a module.
module_count() {
  find "$1" -maxdepth 2 -name '*.rye' -type f 2>/dev/null \
    | { git check-ignore --stdin --non-matching --verbose 2>/dev/null || true; } \
    | grep -c '^::' || true
}

verb="${1:-census}"

# The rooms this page names are decided once, ahead of any counting, so the witness pass reads
# every file a single time and the render and the census both speak from one list.
for dir in */; do
  room="${dir%/}"
  case "$room" in .*|seed|vendor|gratitude|old) continue ;; esac
  [ -f "$room/README.md" ] || continue
  n=$(module_count "$room")
  [ "$n" -gt 0 ] || continue
  printf '%s %s\n' "$room" "$n"
done > "$room_census"
tally_witnesses

# render writes the whole page. The prose lives here rather than in the page, so there is exactly
# one source for it and a hand-edit of the page is simply overwritten on the next run -- which is
# the point: an index keeps its truth by being regenerated, so the regeneration is what the
# witness guards.
if [ "$verb" = render ]; then
  cat <<'HEAD'
# The Libraries

*Every room in this tree that holds Rye modules and opens a door to them -- counted off the tree itself, fresh on every run.*

**Language:** EN - **Style:** Radiant - **Voice:** Kyri
**Status:** Living - **Kind:** crushed index, generated by `tools/g/geode_libraries.rish write`
**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

---

**This page is generated.** An index keeps its truth for exactly as long as it is counted off the tree rather than typed, and every module added moves the count. A reader trusts an index rather than checking it, so the count here is the tree's own: each run renders the whole page from disk, and `tools/g/geode_libraries_witness.rish` reds the moment the shelf and a fresh render disagree. A hand-edit lasts until the next run renders over it.

**What counts as a library here:** a top-level room holding at least one `.rye` module *and* its own `README.md`. Both halves matter -- the README is the door a reader opens, the modules are what stands behind it, and a room becomes a library by holding both.

**How the witness count is taken:** a witness belongs to a room when it *references* that room -- not when its filename happens to contain the room name, and not when it merely invokes the toolchain that lives there. Globbing `tools/*<room>*_witness.rish` reported **zero** for `image` and `lotus`, which hold 463 modules between them, because their proofs are named for what they prove rather than for where it lives. Testing for the room's path instead then reported **1,770** witnesses for `rishi` -- 98 percent of every witness in the tree, against a room of two modules -- because each one runs under `rishi/bin/rishi`, and **1,313** for `rye`, because each one builds with `rye/bin/rye`. So both entry paths are removed from a line before the room test reads it, and what remains was written to name a room rather than to run a program. Only a number a reader can trust is worth printing, and that holds in either direction.

| Room | Rye modules | Witnesses that reference it |
|---|---:|---:|
HEAD
  while read -r room n; do
    w=$(witness_count "$room")
    printf '| [`%s/`](../../%s/README.md) | %s | %s |\n' "$room" "$room" "$n" "$w"
  done < "$room_census"
  cat <<'TAIL'

---

*A library is a promise that someone can use what you built. May each room above keep its door open, and may this page stay true by being read rather than remembered.*
TAIL
  exit 0
fi

echo "generated_from=the tree itself"

count=0
while read -r room n; do
  # A witness BELONGS to a room when it references that room -- not when its filename happens to
  # contain the room name, and not when it merely invokes the toolchain that lives there. The
  # name-glob reported zero for `image` (225 modules) and `lotus` (238), because their proofs are
  # named for what they prove; the reference test that replaced it then reported 1,770 for
  # `rishi`, because every witness in this tree runs under `rishi/bin/rishi`. A confident wrong
  # number is worse than none in either direction (REDS %169, REDS %423).
  w=$(witness_count "$room")
  echo "lib=$room modules=$n witnesses=$w"
  count=$((count + 1))
done < "$room_census"

echo "libraries=$count"
if [ "$count" -gt 0 ]; then echo "verdict=ok"; else echo "verdict=empty"; exit 1; fi
