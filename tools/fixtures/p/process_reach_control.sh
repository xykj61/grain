#!/bin/sh
# process_reach_control.sh -- the process-table guard, proven on real git repositories in a pen.
#
#   sh tools/fixtures/p/process_reach_control.sh
#
# Every refusal is planted and then LIFTED, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a guard that refuses
# everything -- and a welcome nobody proved is how an exclusion quietly grows to swallow the fault.
#
# The corpus this guard reads is `git ls-files`, so the pen is a real repository with real commits
# rather than a directory of files: a scan that read the working tree would answer differently, and
# the difference is exactly what "tracked only" means.
#
# Prints `pass=N fail=N` and exits non-zero on any failure. Bounded: 24 cases, one pen.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P)
scan_src="$root/tools/fixtures/p/process_reach_scan.sh"

[ -f "$scan_src" ] || { echo "process_reach_control: REFUSED -- the scan is absent at $scan_src" >&2; exit 2; }

pen=$(mktemp -d) || { echo "process_reach_control: REFUSED -- no pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
check() {
  if [ "$3" = "$2" ]; then pass=$((pass + 1)); else
    fail=$((fail + 1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2
  fi
}
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

# -- the pen: a real repository holding the scan at its own relative path ------------------------
# invariant: the scan resolves its root from its OWN location, so it must sit three directories
# down in the pen exactly as it does in the tree, or it would read the real tree from the pen.
mkdir -p "$pen/tools/fixtures/p"
cp "$scan_src" "$pen/tools/fixtures/p/process_reach_scan.sh"
mkdir -p "$pen/tools/f"
printf '#!/bin/sh\necho helper\n' > "$pen/tools/f/fleet_call.sh"

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false

plant() { mkdir -p "$(dirname "$1")"; printf '%s' "$2" > "$1"; }
commit_all() { git add -A >/dev/null 2>&1; git commit -qm pen >/dev/null 2>&1 || true; }
run() { sh tools/fixtures/p/process_reach_scan.sh "$@" 2>&1 || true; }
field() { printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1; }

# The scan carries its own ceiling of 2 for the live tree. The pen plants against that same number,
# so the ceiling is proven at the value the tree actually ships rather than at a convenient one.

# -- 1-3: a clean corpus reads zero, verdicts, and names the helper ------------------------------
plant tools/f/quiet.sh '#!/bin/sh
echo nothing to see
'
commit_all
out=$(run)
check "clean bare"            0                       "$(field "$out" bare_sites)"
check "clean verdict"         under_ceiling           "$(field "$out" verdict)"
check "clean names helper"    yes                     "$(field "$out" safe_helper_present)"

# -- 4-6: the three bare forms are each counted --------------------------------------------------
plant tools/f/a.sh '#!/bin/sh
pkill -f "runner"
'
plant tools/f/b.sh '#!/bin/sh
killall runner
'
plant tools/f/c.sh '#!/bin/sh
pgrep -f "runner" >/dev/null
'
commit_all
out=$(run)
check "three bare forms counted" 3                    "$(field "$out" bare_sites)"
check "over the ceiling"         over_ceiling         "$(field "$out" verdict)"
check "the site is named"        yes                  "$(has "$(run --sites)" "tools/f/a.sh:2")"

# -- 7: LIFTED -- removing the plants returns the reading to zero --------------------------------
rm -f tools/f/a.sh tools/f/b.sh tools/f/c.sh
commit_all
out=$(run)
check "lifted returns to zero"   0                    "$(field "$out" bare_sites)"

# -- 8-9: the ceiling is proven from BOTH sides, at the value the tree ships ----------------------
plant tools/f/two_a.sh '#!/bin/sh
pkill -f "one"
'
plant tools/f/two_b.sh '#!/bin/sh
pkill -f "two"
'
commit_all
out=$(run)
check "at the ceiling passes free" under_ceiling      "$(field "$out" verdict)"
plant tools/f/two_c.sh '#!/bin/sh
pkill -f "three"
'
commit_all
out=$(run)
check "one past the ceiling refuses" over_ceiling     "$(field "$out" verdict)"
rm -f tools/f/two_a.sh tools/f/two_b.sh tools/f/two_c.sh
commit_all

# -- 10: `-P` is bounded by parent and is never counted ------------------------------------------
plant tools/f/parent.sh '#!/bin/sh
for kid in $(pgrep -P "$super" 2>/dev/null); do echo "$kid"; done
'
commit_all
check "pgrep -P free"            0                    "$(field "$(run)" bare_sites)"
rm -f tools/f/parent.sh; commit_all

# -- 11-12: a comment discusses, and prose naming ripgrep is not a command -----------------------
plant tools/f/talk.sh '#!/bin/sh
# a bare pkill -f reaches every ship on the pier, so use fleet_call.sh
# and killall is the same fault by a shorter name
echo fine
'
plant tools/f/rg.sh '#!/bin/sh
# this pier ships no ripgrep, so the scan names grep
command -v ripgrep >/dev/null || true
'
commit_all
out=$(run)
check "comments discuss, never call" 0                "$(field "$out" bare_sites)"
check "ripgrep never opens a fragment" no             "$(has "$(run --sites)" "rg.sh")"
rm -f tools/f/talk.sh tools/f/rg.sh; commit_all

# -- 13-14: a quoted mention on a CODE line is a search string, not a command --------------------
# invariant: this is the case that made the guard name the very witness proving the safe helper
# never reaches for a name-matching killer. A separator inside a quoted span is not a separator.
plant tools/f/quoted.sh '#!/bin/sh
n=$(grep -c "pkill \|killall " tools/f/fleet_call.sh || true)
m=$(grep -c '"'"'pkill \|killall '"'"' tools/f/fleet_call.sh || true)
echo "$n $m"
'
commit_all
out=$(run)
check "double-quoted mention free" 0                  "$(field "$out" bare_sites)"
check "single-quoted mention free" no                 "$(has "$(run --sites)" "quoted.sh")"
rm -f tools/f/quoted.sh; commit_all

# -- 15-17: the declaration, on the line, one above, and three above -----------------------------
plant tools/f/d_same.sh '#!/bin/sh
pkill -f "penseat" 2>/dev/null   # process-reach: bounded -- a pen-unique name
'
plant tools/f/d_above.sh '#!/bin/sh
# process-reach: bounded -- a pen-unique name
pkill -f "penseat" 2>/dev/null
'
plant tools/f/d_window.sh '#!/bin/sh
# process-reach: bounded -- the boundary is a seat name the roster makes unique
# across the whole fleet, so this pattern names one loop and can match no peer.
# The sentence wraps, which is why the window is three lines rather than one.
pkill -f "penseat" 2>/dev/null
'
commit_all
out=$(run)
check "three declarations counted" 3                  "$(field "$out" declared_sites)"
check "declared is not bare"       0                  "$(field "$out" bare_sites)"
check "declared verdict free"      under_ceiling      "$(field "$out" verdict)"

# -- 18: a declaration FOUR lines up is out of the window and stays bare -------------------------
plant tools/f/d_far.sh '#!/bin/sh
# process-reach: bounded -- too far above to be read as this site is reason
echo one
echo two
echo three
pkill -f "penseat" 2>/dev/null
'
commit_all
check "four lines up is bare"      1                  "$(field "$(run)" bare_sites)"
rm -f tools/f/d_same.sh tools/f/d_above.sh tools/f/d_window.sh tools/f/d_far.sh; commit_all

# -- 19: an UNTRACKED file is not read ------------------------------------------------------------
plant tools/f/untracked.sh '#!/bin/sh
pkill -f "runner"
'
check "untracked is not read"      0                  "$(field "$(run)" bare_sites)"
rm -f tools/f/untracked.sh

# -- 20: a tracked file of another extension is not read ------------------------------------------
plant tools/f/notes.md 'A note that says: pkill -f runner
'
commit_all
check "another extension free"     0                  "$(field "$(run)" bare_sites)"
rm -f tools/f/notes.md; commit_all

# -- 21-22: the scan excludes its OWN control by exact path, and says so out loud -----------------
# invariant: this control PLANTS bare reaches to prove the scan counts them, so the scan counted its
# own plants the moment the control was staged -- `bare_sites` 2 untracked, 10 tracked (REDS %578's
# shape, an instrument inside its own reading). The exclusion is by exact path rather than by a
# `*control*` pattern, which would blind this guard to a real reach in every control in the tree.
plant tools/fixtures/p/process_reach_control.sh '#!/bin/sh
pkill -f "a plant that proves the counting"
killall runner
'
commit_all
out=$(run)
check "own control excluded"       0                    "$(field "$out" bare_sites)"
check "the exclusion is printed"   1                    "$(field "$out" self_excluded_sources)"

# -- 23: another control at another path is NOT excluded, so the exclusion stays one file ---------
plant tools/fixtures/f/other_control.sh '#!/bin/sh
pkill -f "runner"
'
commit_all
check "another control still read" 1                    "$(field "$(run)" bare_sites)"
rm -f tools/fixtures/p/process_reach_control.sh tools/fixtures/f/other_control.sh; commit_all

# -- 24: an empty corpus REFUSES rather than reading a clean zero --------------------------------
# invariant: this is REDS %413 -- a scan whose corpus is unreadable must refuse loudly, because a
# zero out of nothing is byte-identical to a zero out of a clean tree.
empty=$(mktemp -d)
mkdir -p "$empty/tools/fixtures/p"
cp "$scan_src" "$empty/tools/fixtures/p/process_reach_scan.sh"
( cd "$empty" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
code=0
( cd "$empty" && sh tools/fixtures/p/process_reach_scan.sh >/dev/null 2>&1 ) || code=$?
check "empty corpus refuses"       2                  "$code"
rm -rf "$empty"

printf 'pass=%s fail=%s\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
