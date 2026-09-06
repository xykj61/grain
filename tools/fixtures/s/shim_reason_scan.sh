#!/bin/sh
# tools/fixtures/s/shim_reason_scan.sh -- a pass-through shim that forwards the verdict and drops
# the reason.
#
# WHY. `tools/am/*.rish` and their kin are accrete shims: each one runs a target under
# `tools/gen/` and exits that target's code, so a caller may name either path and get the same
# answer. Rishi's `run` captures the target's stderr into `r.err`, and a shim that says only
# `r.out` never writes a byte to its own stderr. The exit code still travels. The sentence does
# not.
#
# MEASURED ON A REAL FILE, `20260906`, with no plant, because one shim refuses honestly on this
# pier -- `tools/am/amphora_device_wire.rish` drives a virtio lab and this host holds no qemu.
# Run the target directly and a reader gets `rishi: assertion failed -- Amphora vessel fetch
# device wire lab failed`, with the line number beside it. Run the shim and stderr is ZERO bytes;
# the whole of what a reader receives is `amphora-device-wire: virtio fetch-by-digest lab...`, a
# progress line printed before the failure. `tools/fixtures/s/standing_equipment_run.sh` files a
# guard's output with `> "$pen/out.$$" 2>&1`, so the merge is already there and catches nothing:
# the shim emitted nothing to merge.
#
# WHY A GATE AND A RATCHET RATHER THAN ONE NUMBER. No swallowing shim stands on the standing
# roster today, so the loss is real and unheard -- which makes it a trap rather than a fault. It
# springs on the lap that ROSTERS one, and `%360`'s standing pressure is to roster more. The
# amphora lane walked into it on `20260906.063124`: three shims went onto a lap clock and the
# swallow had to be found by planting a break and repaired in the same breath. The gate is what
# spares the next lane that discovery; the ratchet is the residue, falling on touch.
#
# WHAT IT READS. Tracked `*.rish` files that are pass-through shims by all three marks together:
# a `run ["rishi/bin/rishi" "run" ...]` call, a `say r.out` forward, and an `exit r.code` tail.
# All three, because each alone is ordinary -- witnesses run other witnesses, and plenty of
# scripts say a captured stdout without being a shim.
#
# THE EDGE IS PUBLISHED RATHER THAN HIDDEN. Two tracked files exit a captured run's code under a
# different variable name (`result`, `out`), and the three-mark reading cannot see them. Neither
# is a shim -- one is a Rishi argument fixture, one a chapter witness driving a shell scan -- yet
# a reading whose blind spot is uncounted is a floor with no number under it (`%466`). So
# `exit_alias_sites` names them, every pass.
#
#   shims               -- pass-through shims found. A reading of zero refuses (REDS %463).
#   forwards_reason     -- shims that say `r.err`
#   swallow_rostered    -- swallowing shims the standing roster names. HELD AT ZERO.
#   swallow_unrostered  -- swallowing shims off the roster. RATCHET, ceiling only falls.
#   exit_alias_sites    -- files exiting a run's code under another name. Reported.
#
# USAGE
#   sh tools/fixtures/s/shim_reason_scan.sh                 # census -- key=value lines
#   sh tools/fixtures/s/shim_reason_scan.sh list            # one line per shim, with both marks
#   CEILING=<n> sh tools/fixtures/s/shim_reason_scan.sh     # override the ratchet ceiling
#
# Driven by tools/s/shim_reason_witness.rish. Proven both ways by shim_reason_control.sh.
# Run from the repository root.
set -eu

MODE="${1:-census}"

# The residue this ratchet stood at once the amphora lane took its own five, measured
# `20260906.123000`: 52 shims, 9 forwarding, 43 swallowing, none of them rostered. It only falls --
# repair a shim and lower it in the same commit.
CEILING="${CEILING:-43}"

ROSTER="${SHIM_REASON_ROSTER:-construction/standing-equipment.kyri}"

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this reading walks the tracked tree, so it wants git" >&2; exit 2; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 2; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# `git ls-files` lists an unmerged path once per stage, so a tree standing mid-rebase would report
# one file three times without the `sort -u`.
git ls-files -- '*.rish' | sort -u > "$work/rish"
rish_files=$(grep -c . "$work/rish" || true)

# An instrument that has read nothing must not answer "nothing is wrong" (REDS %463). This tree
# holds thousands of `.rish` files; zero means the corpus never arrived.
if [ "$rish_files" -eq 0 ]; then
  echo "rish_files=0"
  echo "verdict=empty_corpus"
  echo "refused: no tracked .rish file was read, so this reading knows nothing about shims" >&2
  exit 2
fi

# The roster decides which side of the line a swallowing shim falls on, so a roster that cannot be
# read is a refusal rather than a credit: every shim would silently count as unrostered and the
# gate would report zero while measuring nothing.
if [ ! -r "$ROSTER" ]; then
  echo "rish_files=$rish_files"
  echo "verdict=roster_unreadable"
  echo "refused: $ROSTER is not readable, so rostered and unrostered cannot be told apart" >&2
  exit 2
fi

# PRE-FILTERED WITH ONE `git grep`, and its status classified rather than swallowed. Three greps
# across every tracked `.rish` is roughly seven thousand processes and cost 22 seconds measured on
# this pier; one `git grep -l` for the rarest of the three marks brings the per-file work down to
# the handful that could possibly match. `git grep` exits 1 for *no match* and 2 or more for *could
# not run*, and a fallback that reads those two opposite answers alike would report an empty tree
# as a clean one -- REDS %473 and %484, one guard over.
set +e
git grep -lF -- 'run ["rishi/bin/rishi" "run" ' -- '*.rish' > "$work/candidates" 2>/dev/null
_st=$?
set -e
if [ "$_st" -gt 1 ]; then
  echo "rish_files=$rish_files"
  echo "verdict=instrument_refusal"
  echo "refused: git grep exited $_st, so its silence about shims means nothing" >&2
  exit 2
fi
[ -f "$work/candidates" ] || : > "$work/candidates"
sort -u "$work/candidates" -o "$work/candidates"

: > "$work/shims"
: > "$work/rows"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -q 'say r\.out' "$f" || continue
  grep -q '^exit r\.code$' "$f" || continue
  echo "$f" >> "$work/shims"
  if grep -q 'r\.err' "$f"; then reason=forwards; else reason=swallows; fi
  # Anchored to the roster's own grammar -- a `path` row stands alone at column zero. An
  # unanchored match would read a prose mention of a path inside a comment as a seat, which is a
  # door: a guard could be counted rostered because somebody wrote about it.
  if grep -qxF "path $f" "$ROSTER"; then seat=rostered; else seat=unrostered; fi
  echo "$reason $seat $f" >> "$work/rows"
done < "$work/candidates"

shims=$(grep -c . "$work/shims" || true)
if [ "$shims" -eq 0 ]; then
  echo "rish_files=$rish_files"
  echo "shims=0"
  echo "verdict=no_shims"
  echo "refused: no pass-through shim matched all three marks, so this reading proves nothing" >&2
  exit 2
fi

forwards=$(awk '$1 == "forwards"' "$work/rows" | grep -c . || true)
swallow_rostered=$(awk '$1 == "swallows" && $2 == "rostered"' "$work/rows" | grep -c . || true)
swallow_unrostered=$(awk '$1 == "swallows" && $2 == "unrostered"' "$work/rows" | grep -c . || true)

# The blind spot, counted. `exit r.code` is the spelling this tree writes; any other name for the
# captured run is invisible to the three-mark reading above, so it is named here rather than left
# to a future reader to rediscover.
set +e
git grep -lE -- '^exit [a-z_]+\.code$' -- '*.rish' > "$work/exiters" 2>/dev/null
_st=$?
set -e
if [ "$_st" -gt 1 ]; then
  echo "rish_files=$rish_files"
  echo "verdict=instrument_refusal"
  echo "refused: git grep exited $_st reading the exit spellings, so the blind-spot count is unknown" >&2
  exit 2
fi
[ -f "$work/exiters" ] || : > "$work/exiters"
: > "$work/alias"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -qE '^exit r\.code$' "$f" && continue
  echo "$f" >> "$work/alias"
done < "$work/exiters"
sort -u "$work/alias" -o "$work/alias"
alias_count=$(grep -c . "$work/alias" || true)

if [ "$MODE" = list ]; then
  sort "$work/rows"
  exit 0
fi

echo "rish_files=$rish_files"
echo "shims=$shims"
echo "forwards_reason=$forwards"
echo "swallow_rostered=$swallow_rostered"
echo "swallow_unrostered=$swallow_unrostered"
echo "unrostered_ceiling=$CEILING"
echo "exit_alias_sites=$alias_count"
while IFS= read -r f; do echo "alias: $f"; done < "$work/alias"
awk '$1 == "swallows" { print "swallows: " $2 " " $3 }' "$work/rows" | sort

if [ "$swallow_rostered" -gt 0 ]; then
  echo "verdict=rostered_swallow"
  echo "refused: $swallow_rostered shim(s) on the standing roster drop the target's reason -- the fleet runs them and files an evidence page with no sentence in it" >&2
  exit 1
fi

if [ "$swallow_unrostered" -gt "$CEILING" ]; then
  echo "verdict=unrostered_over_ceiling"
  echo "refused: $swallow_unrostered swallowing shims stand off the roster against a ceiling of $CEILING -- the ceiling only falls" >&2
  exit 1
fi

echo "verdict=ok"
exit 0
