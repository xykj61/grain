#!/bin/sh
# tools/fixtures/u/unheard_guard_control.sh -- prove the unheard-guard reading on real repositories.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every refusal
# below is shown from both sides: planted and then removed. Every welcome is asserted as hard as
# every refusal, because a reading that says `unheard` about a guard something plainly runs would
# cost a hand an hour before they stopped believing it.
#
#   sh tools/fixtures/u/unheard_guard_control.sh
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 1; }
scan="$root/tools/fixtures/u/unheard_guard_scan.sh"
[ -f "$scan" ] || { echo "refused: the scan under proof is missing -- $scan" >&2; exit 1; }

pen=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT

pass=0
fail=0
check() {
  want=$1; got=$2; what=$3
  if [ "$want" = "$got" ]; then
    pass=$((pass + 1)); echo "  ok   $what"
  else
    fail=$((fail + 1)); echo "  FAIL $what -- want $want, got $got"
  fi
}

# read one `key=value` line out of a scan run
field() { sed -n "s/^$2=//p" "$1" | head -1; }

# A pen is a miniature of this tree, so it carries the one file the scan sources: the shell
# dialect helper. A scan that reached OUTSIDE the repository it was pointed at for a helper would
# be reading this bench rather than the tree under proof, so the pen supplies its own.
newpen() {
  d="$pen/$1"; rm -rf "$d"; mkdir -p "$d/tools/a" "$d/tools/fixtures/a" "$d/tools/fixtures/s" "$d/construction"
  cp "$root/tools/fixtures/s/shell_portable.sh" "$d/tools/fixtures/s/shell_portable.sh"
  git -C "$d" init -q
  git -C "$d" config user.email pen@example.invalid
  git -C "$d" config user.name pen
  echo "$d"
}

run() { ( cd "$1" && shift && UNHEARD_GUARD_CEILING="$1" UNHEARD_CHOIR_CEILING="$2" sh "$scan" "$3" ); }

echo "unheard_guard_control: proving the reading on real repositories in a throwaway pen."

# --- Pen one: the shape of the whole law, in four files ------------------------------------
d=$(newpen one)
printf 'run ["rishi/bin/rishi" "run" "tools/a/beta_witness.rish"]\n' > "$d/tools/a/alpha_witness.rish"
printf '# Kin: tools/a/delta_witness.rish -- named in a COMMENT, never run\nsay "beta"\n' > "$d/tools/a/beta_witness.rish"
printf 'say "gamma -- named by nothing at all"\n' > "$d/tools/a/gamma_witness.rish"
printf 'say "delta"\n' > "$d/tools/a/delta_witness.rish"
printf 'say "pen material, not standing equipment"\n' > "$d/tools/fixtures/a/elder_witness.rish"
printf 'guard alpha\npath tools/a/alpha_witness.rish\nseated 20260830.000000\n' > "$d/construction/standing-equipment.kyri"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null

run "$d" 99 99 measure > "$pen/one.out" 2>"$pen/one.err" || true
check 4  "$(field "$pen/one.out" population)" "population counts the four tools/a guards"
check 1  "$(field "$pen/one.out" rostered)"   "rostered counts the one roster path"
check 2  "$(field "$pen/one.out" heard)"      "heard counts alpha (rostered) and beta (run by alpha)"
check 2  "$(field "$pen/one.out" unheard)"    "gamma and delta stand unheard"
check ok "$(field "$pen/one.out" verdict)"    "under both ceilings the reading is ok"

# the fixture pen file must be absent from the population entirely
check 0 "$(run "$d" 99 99 list | grep -c 'tools/fixtures/' || true)" "a witness under tools/fixtures/ is pen material, never population"
# a comment-only mention does not make a guard heard
check 1 "$(run "$d" 99 99 list | grep -c 'unheard tools/a/delta_witness.rish' || true)" "delta, named only in a comment, reads unheard"
check 1 "$(run "$d" 99 99 list | grep -c 'unheard tools/a/gamma_witness.rish' || true)" "gamma, named nowhere, reads unheard"
check 0 "$(run "$d" 99 99 list | grep -c 'unheard tools/a/beta_witness.rish' || true)" "beta, run by a rostered guard, is never called unheard"

# THE CEILING FROM BOTH SIDES, ON ONE PEN, so the readings differ only in the ceiling.
run "$d" 2 99 measure > "$pen/at.out" 2>/dev/null || true
check ok "$(field "$pen/at.out" verdict)" "a ceiling exactly at the reading passes"
if run "$d" 1 99 measure > "$pen/over.out" 2>/dev/null; then over_rc=0; else over_rc=1; fi
check 1 "$over_rc" "one under the reading refuses"
check over_ceiling "$(field "$pen/over.out" verdict)" "and refuses by name"

# --- Pen two: transitive reach, and reach flows only FROM heard -----------------------------
d=$(newpen two)
printf 'run ["sh" "tools/a/b_witness.rish"]\n' > "$d/tools/a/a_witness.rish"
printf 'run ["sh" "tools/a/c_witness.rish"]\n' > "$d/tools/a/b_witness.rish"
printf 'say "c"\n' > "$d/tools/a/c_witness.rish"
printf 'run ["sh" "tools/a/z_witness.rish"]\n' > "$d/tools/a/y_witness.rish"
printf 'say "z"\n' > "$d/tools/a/z_witness.rish"
printf 'path tools/a/a_witness.rish\n' > "$d/construction/standing-equipment.kyri"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
run "$d" 99 99 measure > "$pen/two.out" 2>/dev/null || true
check 3 "$(field "$pen/two.out" heard)"   "reach is transitive -- a, b, and c are all heard"
check 2 "$(field "$pen/two.out" unheard)" "y and z stay unheard: reach flows only out of what is heard"
check 1 "$(run "$d" 99 99 list | grep -c 'unheard tools/a/z_witness.rish' || true)" "z, run only by an unheard guard, is itself unheard"

# --- Pen three: the choir reading, from both sides ------------------------------------------
d=$(newpen three)
printf 'run ["sh" "tools/a/r1_witness.rish"]\nrun ["sh" "tools/a/r2_witness.rish"]\nrun ["sh" "tools/a/r3_witness.rish"]\n' > "$d/tools/a/silent_suite.rish"
for r in r1 r2 r3; do printf 'say "%s"\n' "$r" > "$d/tools/a/${r}_witness.rish"; done
printf 'path tools/a/nothing_witness.rish\n' > "$d/construction/standing-equipment.kyri"
printf 'say "rostered, and it names nobody"\n' > "$d/tools/a/nothing_witness.rish"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
run "$d" 99 99 measure > "$pen/three.out" 2>/dev/null || true
check 1 "$(field "$pen/three.out" unheard_choirs)" "a silent suite naming three rungs counts as one unheard choir"
check 1 "$(run "$d" 99 99 choirs | grep -c 'choir tools/a/silent_suite.rish sings 3' || true)" "the choir line names the guard and how many it sings"
if run "$d" 99 0 measure > "$pen/ch.out" 2>/dev/null; then ch_rc=0; else ch_rc=1; fi
check 1 "$ch_rc" "a choir ceiling of zero refuses"
check over_choir_ceiling "$(field "$pen/ch.out" verdict)" "and refuses by its own name, not the wide one"
check ok "$(run "$d" 99 1 measure | sed -n 's/^verdict=//p')" "a choir ceiling of one passes on the same pen"

# --- Pen four: the vacuums, each refused ----------------------------------------------------
d=$(newpen four)
printf 'path tools/a/absent_witness.rish\n' > "$d/construction/standing-equipment.kyri"
printf 'nothing here\n' > "$d/tools/a/README.md"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
if run "$d" 99 99 measure > "$pen/four.out" 2>/dev/null; then rc=0; else rc=1; fi
check 1 "$rc" "a tree holding no guards refuses rather than printing a green zero"
check no_population "$(field "$pen/four.out" verdict)" "and names the vacuum it found"

d=$(newpen five)
printf 'say "alone"\n' > "$d/tools/a/lonely_witness.rish"
printf '# a roster with no path lines at all\n' > "$d/construction/standing-equipment.kyri"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
if run "$d" 99 99 measure > "$pen/five.out" 2>/dev/null; then rc=0; else rc=1; fi
check 1 "$rc" "an empty roster refuses -- every guard would read unheard for the wrong reason"
check no_roster "$(field "$pen/five.out" verdict)" "and names that vacuum apart from the other"

# a roster file that is missing entirely reads the same way
d=$(newpen six)
printf 'say "alone"\n' > "$d/tools/a/lonely_witness.rish"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
if run "$d" 99 99 measure > "$pen/six.out" 2>/dev/null; then rc=0; else rc=1; fi
check 1 "$rc" "a missing roster file refuses too"
check no_roster "$(field "$pen/six.out" verdict)" "under the same name"

# --- Outside a repository ---------------------------------------------------------------------
bare="$pen/bare"; mkdir -p "$bare"
if ( cd "$bare" && GIT_CEILING_DIRECTORIES="$pen" sh "$scan" >/dev/null 2>&1 ); then rc=0; else rc=1; fi
check 1 "$rc" "outside a git repository the scan refuses rather than reading the filesystem"

echo "unheard_guard_control: pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=control_green"; else echo "verdict=control_red"; fi
[ "$fail" -eq 0 ] || exit 1
