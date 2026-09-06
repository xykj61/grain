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

# The fourth argument is the second reading's ceiling and defaults to 99, so every elder call site
# below reads exactly as it did before this argument existed. Spelled positionally rather than as
# an environment prefix on the call: `VAR=x somefunc` leaks into the calling shell in some POSIX
# shells and not others, and a pen that behaves differently per shell proves nothing.
run() { ( cd "$1" && shift && UNHEARD_GUARD_CEILING="$1" UNHEARD_CHOIR_CEILING="$2" UNNAMED_CHOIR_CEILING="${4:-99}" sh "$scan" "$3" ); }

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

# --- Pen seven: the runners the convention cannot see (REDS %465) ---------------------------
# Every leg here is about the SECOND reading, and the last one is the sharpest: the elder numbers
# must not move at all, or the widening would have quietly rewritten a fleet-wide ratchet.
d=$(newpen seven)
printf 'assert 1 == 1 else "a claim, in a file wearing neither word"\n' > "$d/tools/a/plain_runner.rish"
printf 'assert(1 == 1); // the Rye spelling, which the elder pattern could not see\n' > "$d/tools/a/rye_runner.rye"
printf 'say "no claim here at all"\n' > "$d/tools/a/quiet_runner.rish"
printf 'assert 1 == 1 else "pen material, never population"\n' > "$d/tools/fixtures/a/penned_runner.rish"
printf 'run ["sh" "tools/a/reached_runner.rish"]\n' > "$d/tools/a/rostered_witness.rish"
printf 'assert 1 == 1 else "named by a rostered guard, so heard"\n' > "$d/tools/a/reached_runner.rish"
printf '# tools/a/mentioned_runner.rish -- named only in a comment\nassert 1 == 1 else "x"\n' > "$d/tools/a/commenter_witness.rish"
printf 'assert 1 == 1 else "named in a comment only, so unreached"\n' > "$d/tools/a/mentioned_runner.rish"
printf 'path tools/a/rostered_witness.rish\npath tools/a/commenter_witness.rish\n' > "$d/construction/standing-equipment.kyri"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null

run "$d" 99 99 measure > "$pen/seven.out" 2>/dev/null || true
check 4 "$(field "$pen/seven.out" unnamed_population)" "the second population counts the four asserting runners wearing neither word"
check 1 "$(run "$d" 99 99 unnamed | grep -c 'unnamed tools/a/rye_runner.rye' || true)" "the Rye spelling assert( joins the population, where the elder pattern read none"
check 0 "$(run "$d" 99 99 unnamed | grep -c 'quiet_runner' || true)" "a runner making no claim is not standing equipment and never joins"
check 0 "$(run "$d" 99 99 unnamed | grep -c 'tools/fixtures/' || true)" "a claiming runner under tools/fixtures/ is pen material, never population"
check 1 "$(field "$pen/seven.out" unnamed_heard)" "reached_runner, named by a rostered guard, is heard"
check 3 "$(field "$pen/seven.out" unnamed_runners)" "the other three stand unreached"
check 1 "$(run "$d" 99 99 unnamed | grep -c 'unnamed tools/a/mentioned_runner.rish' || true)" "a runner named only in a comment stays unreached, in the wide rule as in the narrow"
check 0 "$(run "$d" 99 99 unnamed | grep -c 'unnamed tools/a/reached_runner.rish' || true)" "and one a rostered guard actually runs is never called unreached"
# THE ELDER READING, UNMOVED. Two witnesses, both rostered, so heard=2 and unheard=0 whatever the
# second reading found beside them.
check 2 "$(field "$pen/seven.out" population)" "the elder population still counts only the guards wearing the word"
check 0 "$(field "$pen/seven.out" unheard)" "and the elder reading is unmoved by everything the second one found"

# --- Pen eight: the silent choir nothing names as a guard, and the guard-universe floor -------
d=$(newpen eight)
printf 'run ["sh" "tools/a/r1_witness.rish"]\nrun ["sh" "tools/a/r2_witness.rish"]\nrun ["sh" "tools/a/r3_witness.rish"]\nassert 1 == 1 else "a suite by behaviour, not by name"\n' > "$d/tools/a/parity_pen.rish"
for r in r1 r2 r3; do printf 'assert 1 == 1 else "%s"\n' "$r" > "$d/tools/a/${r}_witness.rish"; done
# a runner naming three HELPERS is not a choir: helpers make no claim, so they are not guards
printf 'run ["sh" "tools/a/h1.rish"]\nrun ["sh" "tools/a/h2.rish"]\nrun ["sh" "tools/a/h3.rish"]\nassert 1 == 1 else "three helpers is not a family"\n' > "$d/tools/a/helper_caller.rish"
for h in h1 h2 h3; do printf 'say "%s -- a helper, claiming nothing"\n' "$h" > "$d/tools/a/${h}.rish"; done
printf 'path tools/a/nothing_witness.rish\n' > "$d/construction/standing-equipment.kyri"
printf 'say "rostered, and it names nobody"\n' > "$d/tools/a/nothing_witness.rish"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null

run "$d" 99 99 measure > "$pen/eight.out" 2>/dev/null || true
check 1 "$(field "$pen/eight.out" unnamed_choirs)" "a suite wearing neither word, singing three guards, counts as one silent choir"
check 1 "$(run "$d" 99 99 choirs | grep -c 'unnamed_choir tools/a/parity_pen.rish sings 3' || true)" "the line names the runner and how many guards it sings"
check 0 "$(run "$d" 99 99 choirs | grep -c 'unnamed_choir tools/a/helper_caller.rish' || true)" "naming three helpers that claim nothing is not a choir -- the floor counts guards"
check 0 "$(field "$pen/eight.out" unheard_choirs)" "and the elder choir reading, which knows a choir by its filename, sees none of this"
# THE SECOND CEILING FROM BOTH SIDES, ON ONE PEN.
check ok "$(run "$d" 99 99 measure 1 | sed -n 's/^verdict=//p')" "a second-reading ceiling exactly at the count passes"
if run "$d" 99 99 measure 0 > "$pen/uc.out" 2>/dev/null; then uc_rc=0; else uc_rc=1; fi
check 1 "$uc_rc" "one under the count refuses"
check over_unnamed_choir_ceiling "$(field "$pen/uc.out" verdict)" "and refuses under its own name, apart from both elder ceilings"

# --- Pen nine: the elder rule's blind spot, given a size ------------------------------------
# A guard wearing the word, reached only THROUGH a runner that does not. The narrow closure cannot
# follow that hop and calls it unheard; the wide one reaches it, and the gap is printed.
d=$(newpen nine)
printf 'run ["sh" "tools/a/bridge_runner.rish"]\n' > "$d/tools/a/head_witness.rish"
printf 'run ["sh" "tools/a/far_witness.rish"]\nassert 1 == 1 else "a bridge wearing neither word"\n' > "$d/tools/a/bridge_runner.rish"
printf 'say "far -- reached only through the bridge"\n' > "$d/tools/a/far_witness.rish"
printf 'path tools/a/head_witness.rish\n' > "$d/construction/standing-equipment.kyri"
git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
run "$d" 99 99 measure > "$pen/nine.out" 2>/dev/null || true
check 1 "$(field "$pen/nine.out" elder_reach_gap)" "a guard reached only through an unnamed runner is counted in the elder rule's blind spot"
check 1 "$(run "$d" 99 99 unnamed | grep -c 'reach_gap tools/a/far_witness.rish' || true)" "and the gap names it rather than describing it"
check 1 "$(field "$pen/nine.out" unheard)" "the elder reading still calls it unheard -- reported, never silently corrected"
check 0 "$(field "$pen/nine.out" unnamed_runners)" "while the bridge itself, run by a rostered guard, is heard"

# --- Pen ten: the guard does not read its own findings (REDS %486) ---------------------------
# A census whose whole job is to NAME what nothing runs will, if it reads itself, mark everything it
# names as run. Both pens below are identical but for the accuser's PATH, so the exclusion is what
# separates them and nothing else can be credited for the difference.
mkpen_self() {
  d=$(newpen "$1"); mkdir -p "$d/tools/u" "$d/tools/p"
  printf 'run ["sh" "tools/p/silent_pen.rish"]\nassert 1 == 1 else "x"\n' > "$d/tools/p/silent_pen.rish.tmp"
  printf 'run ["sh" "tools/p/g1_witness.rish"]\nrun ["sh" "tools/p/g2_witness.rish"]\nrun ["sh" "tools/p/g3_witness.rish"]\nassert 1 == 1 else "a silent choir wearing neither word"\n' > "$d/tools/p/silent_pen.rish"
  rm -f "$d/tools/p/silent_pen.rish.tmp"
  for g in g1 g2 g3; do printf 'say "%s"\n' "$g" > "$d/tools/p/${g}_witness.rish"; done
  # the accuser: a rostered guard that NAMES the silent choir in an assert string, exactly as this
  # tree's own witness does
  printf 'assert out contains "unnamed_choir tools/p/silent_pen.rish sings" else "name the choir"\n' > "$d/$2"
  printf 'path %s\n' "$2" > "$d/construction/standing-equipment.kyri"
  git -C "$d" add -A >/dev/null; git -C "$d" commit -qm pen >/dev/null
  echo "$d"
}
d=$(mkpen_self ten tools/u/unheard_guard_witness.rish)
run "$d" 99 99 measure > "$pen/ten.out" 2>/dev/null || true
check 1 "$(field "$pen/ten.out" unnamed_choirs)" "the excluded witness naming a silent choir does not make it heard"
check 0 "$(field "$pen/ten.out" unnamed_heard)" "and none of what it names is credited as run"

d=$(mkpen_self eleven tools/u/other_witness.rish)
run "$d" 99 99 measure > "$pen/eleven.out" 2>/dev/null || true
check 0 "$(field "$pen/eleven.out" unnamed_choirs)" "the SAME pen with the accuser renamed reads the choir heard -- the exclusion is what did the work"
check 1 "$(field "$pen/eleven.out" unnamed_heard)" "and a mention by any other rostered guard is credited, as the generous reading says"

# --- Outside a repository ---------------------------------------------------------------------
bare="$pen/bare"; mkdir -p "$bare"
if ( cd "$bare" && GIT_CEILING_DIRECTORIES="$pen" sh "$scan" >/dev/null 2>&1 ); then rc=0; else rc=1; fi
check 1 "$rc" "outside a git repository the scan refuses rather than reading the filesystem"

echo "unheard_guard_control: pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=control_green"; else echo "verdict=control_red"; fi
[ "$fail" -eq 0 ] || exit 1
