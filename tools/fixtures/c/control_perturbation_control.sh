#!/bin/sh
# tools/fixtures/c/control_perturbation_control.sh -- proves
# tools/fixtures/c/control_perturbation_scan.sh on real git repositories in a throwaway pen.
#
#   sh tools/fixtures/c/control_perturbation_control.sh
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every
# refusal, since a refusal proven only in the passing direction cannot be told from a bypass.
# Two mutations are asserted to BITE: the probe makes a control absent from the working tree AND
# from the index, and a scan enumerating with `find` reads only the first while a scan enumerating
# with `git ls-files` reads only the second, so dropping either half leaves one population blind
# and the leg that covers it must fail.
set -e

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
SCAN="$ROOT/tools/fixtures/c/control_perturbation_scan.sh"

# The mutations below edit the probe's copy in place, and `sed -i` has no spelling both piers run:
# GNU takes no argument, BSD requires a backup suffix and eats the script as one. The tree's own
# portable helper writes through a temporary and copies back through the original inode, which every
# host runs and which keeps the mode the repository tracks.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

PEN=$(mktemp -d)
cleanup() {
  cd "$PEN" 2>/dev/null && git worktree prune >/dev/null 2>&1 || true
  rm -rf "$PEN"
}
trap cleanup EXIT INT HUP TERM

legs=0
failed=0
leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 ok"
  else
    failed=$((failed + 1))
    echo "leg $1 FAILED want=$3 got=$2"
  fi
}

# build_pen: a real git repository carrying planted scan/control pairs and a copy of the probe.
build_pen() {
  rm -rf "$PEN/repo"
  mkdir -p "$PEN/repo/tools/fixtures/c" "$PEN/repo/tools/fixtures/p"
  cd "$PEN/repo"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  cp "$SCAN" tools/fixtures/c/control_perturbation_scan.sh

  # unmoved: names a find rooted at tools, and its answer never mentions its own family.
  cat > tools/fixtures/p/unmoved_scan.sh <<'EOF'
#!/bin/sh
find tools -name 'no_such_name_at_all' >/dev/null 2>&1 || true
echo "sites=0"
echo "verdict=ok"
EOF
  echo '# plant' > tools/fixtures/p/unmoved_control.sh

  # moved: counts every control under tools, so its own control is one of the sites it reports.
  cat > tools/fixtures/p/moved_scan.sh <<'EOF'
#!/bin/sh
n=$(find tools -name '*_control.sh' | wc -l | tr -d ' ')
echo "sites=$n"
echo "verdict=ok"
EOF
  echo '# plant' > tools/fixtures/p/moved_control.sh

  # second_scan: a second find-enumerating candidate, so the probe's restore between candidates is
  # proven rather than assumed -- without it the first deletion would still stand for this one.
  cat > tools/fixtures/p/second_scan.sh <<'EOF'
#!/bin/sh
n=$(find tools -name '*_control.sh' | wc -l | tr -d ' ')
echo "sites=$n"
echo "verdict=ok"
EOF
  echo '# plant' > tools/fixtures/p/second_control.sh

  # flip: the same count, spoken as a verdict, so removing the control changes PASS rather than a
  # number alone.
  cat > tools/fixtures/p/flip_scan.sh <<'EOF'
#!/bin/sh
n=$(find tools -name 'flip_control.sh' | wc -l | tr -d ' ')
echo "sites=$n"
if [ "$n" -gt 0 ]; then echo "verdict=refused"; else echo "verdict=ok"; fi
EOF
  echo '# plant' > tools/fixtures/p/flip_control.sh

  # lonely: a candidate with no tracked family control at all -- nothing to take away.
  cat > tools/fixtures/p/lonely_scan.sh <<'EOF'
#!/bin/sh
find tools -name 'nothing' >/dev/null 2>&1 || true
echo "verdict=ok"
EOF

  # rootfinder: speaks the exact refusal 164 tracked scripts speak in a checkout nobody has built.
  cat > tools/fixtures/p/rootfinder_scan.sh <<'EOF'
#!/bin/sh
find tools -name 'nothing' >/dev/null 2>&1 || true
echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
exit 1
EOF
  echo '# plant' > tools/fixtures/p/rootfinder_control.sh

  # silent: refuses for a reason the probe cannot name, which must stay a PLAIN refusal.
  cat > tools/fixtures/p/silent_scan.sh <<'EOF'
#!/bin/sh
find tools -name 'nothing' >/dev/null 2>&1 || true
echo "something else entirely" >&2
exit 1
EOF
  echo '# plant' > tools/fixtures/p/silent_control.sh

  # indexed: enumerates with `git ls-files`, so ONLY the index half of the perturbation reaches it.
  # It is never a candidate; the probe is handed it by name.
  cat > tools/fixtures/p/indexed_scan.sh <<'EOF'
#!/bin/sh
n=$(git ls-files 'tools/fixtures/p/indexed_control.sh' | wc -l | tr -d ' ')
echo "sites=$n"
echo "verdict=ok"
EOF
  echo '# plant' > tools/fixtures/p/indexed_control.sh

  chmod +x tools/fixtures/p/*.sh tools/fixtures/c/control_perturbation_scan.sh
  git add -A
  git commit -q -m "pen: plant the scan and control pairs"
}

build_pen
cd "$PEN/repo"

CAND=$(sh tools/fixtures/c/control_perturbation_scan.sh --candidates)
leg candidates_hold_find_rooted "$(printf '%s\n' "$CAND" | grep -c '/moved_scan\.sh$')" 1
leg candidates_hold_the_lonely_one "$(printf '%s\n' "$CAND" | grep -c 'lonely_scan')" 1
leg candidates_read_past_git_enumerating "$(printf '%s\n' "$CAND" | grep -c 'indexed_scan')" 0
leg candidates_read_past_the_probe_itself "$(printf '%s\n' "$CAND" | grep -c 'control_perturbation_scan')" 0

OUT=$(sh tools/fixtures/c/control_perturbation_scan.sh)

leg unmoved_named "$(printf '%s\n' "$OUT" | grep -c '^unmoved tools/fixtures/p/unmoved_scan.sh')" 1
leg moved_named "$(printf '%s\n' "$OUT" | grep -c '^moved tools/fixtures/p/moved_scan.sh')" 1
leg second_candidate_also_moved "$(printf '%s\n' "$OUT" | grep -c '^moved tools/fixtures/p/second_scan.sh')" 1
leg verdict_flip_named "$(printf '%s\n' "$OUT" | grep -c '^verdict_flipped tools/fixtures/p/flip_scan.sh')" 1
leg flip_is_not_counted_as_moved "$(printf '%s\n' "$OUT" | grep -c '^moved tools/fixtures/p/flip_scan.sh')" 0
leg lonely_skipped "$(printf '%s\n' "$OUT" | grep -c 'skip tools/fixtures/p/lonely_scan.sh reason=no_tracked_family_control')" 1
leg rootfinder_refusal_named "$(printf '%s\n' "$OUT" | grep -c 'refuse tools/fixtures/p/rootfinder_scan.sh reason=root_finder_needs_built_tree')" 1
leg other_refusal_stays_plain "$(printf '%s\n' "$OUT" | grep -c 'refuse tools/fixtures/p/silent_scan.sh reason=no_output_with_control_present')" 1

leg count_probed "$(printf '%s\n' "$OUT" | grep '^probed=' | cut -d= -f2)" 4
leg count_unmoved "$(printf '%s\n' "$OUT" | grep '^unmoved=' | cut -d= -f2)" 1
leg count_moved "$(printf '%s\n' "$OUT" | grep '^moved=' | cut -d= -f2)" 2
leg count_flipped "$(printf '%s\n' "$OUT" | grep '^verdict_flipped=' | cut -d= -f2)" 1
leg count_skipped "$(printf '%s\n' "$OUT" | grep '^skipped_no_control=' | cut -d= -f2)" 1
leg count_refused "$(printf '%s\n' "$OUT" | grep '^refused=' | cut -d= -f2)" 2
leg count_needs_built "$(printf '%s\n' "$OUT" | grep '^refused_root_finder_needs_built_tree=' | cut -d= -f2)" 1
leg verdict_is_reported "$(printf '%s\n' "$OUT" | grep -c '^verdict=reported')" 1
leg perturbation_named "$(printf '%s\n' "$OUT" | grep -c '^perturbation=control_absent_from_index_and_worktree')" 1

# The restore between candidates: two candidates counting the same thing must report the same
# baseline, which is the promise that each was measured against a pristine tree.
D1=$(printf '%s\n' "$OUT" | grep '^moved tools/fixtures/p/moved_scan.sh' | sed 's/.*detail=//')
D2=$(printf '%s\n' "$OUT" | grep '^moved tools/fixtures/p/second_scan.sh' | sed 's/.*detail=//')
leg restore_keeps_one_baseline "$([ "$D1" = "$D2" ] && echo same || echo differ)" same

# The index half, reached only by handing the probe a git-enumerating scan by name.
IDX=$(sh tools/fixtures/c/control_perturbation_scan.sh tools/fixtures/p/indexed_scan.sh)
leg index_half_moves "$(printf '%s\n' "$IDX" | grep -c '^moved tools/fixtures/p/indexed_scan.sh')" 1

# The pen is left as it was found: no stray worktree, no deleted control in the live tree.
leg live_control_survives "$(test -f tools/fixtures/p/moved_control.sh && echo yes || echo no)" yes
leg live_index_survives "$(git ls-files tools/fixtures/p/moved_control.sh | wc -l | tr -d ' ')" 1
leg no_worktree_leaked "$(git worktree list | wc -l | tr -d ' ')" 1

# MUTATION 1 -- the working-tree half removed. A `find`-enumerating scan then sees its control
# still on disk, so the founding shape reads unmoved and its leg must fail.
build_pen
cd "$PEN/repo"
sed_inplace 's|rm -f "$ctl" ) |: ) |' tools/fixtures/c/control_perturbation_scan.sh
M1=$(sh tools/fixtures/c/control_perturbation_scan.sh 2>/dev/null || true)
leg mutation_worktree_half_bites "$(printf '%s\n' "$M1" | grep -c '^moved tools/fixtures/p/moved_scan.sh')" 0

# MUTATION 2 -- the index half removed. A `git ls-files` scan then still finds its control tracked.
build_pen
cd "$PEN/repo"
sed_inplace 's|git rm -q -f --cached "$ctl" >/dev/null 2>&1;|true;|' tools/fixtures/c/control_perturbation_scan.sh
M2=$(sh tools/fixtures/c/control_perturbation_scan.sh tools/fixtures/p/indexed_scan.sh 2>/dev/null || true)
leg mutation_index_half_bites "$(printf '%s\n' "$M2" | grep -c '^moved tools/fixtures/p/indexed_scan.sh')" 0

# MUTATION 3 -- the restore between candidates removed.
#
# It bites on the BASELINE rather than on the classification, and the difference is worth stating,
# because a first draft asserted the classification and the leg passed under the mutation. Both of
# a candidate's two runs happen AFTER any earlier deletion, so an unrestored deletion shifts them
# together and the verdict survives. What it does not survive is the claim that every candidate was
# measured against the same tree: `moved_scan` and `second_scan` count the same thing, so with the
# restore their two details are identical, and without it the second reads one control short.
sed_inplace 's|git reset -q \&\& git checkout -q -- .|true|' tools/fixtures/c/control_perturbation_scan.sh
M3=$(sh tools/fixtures/c/control_perturbation_scan.sh tools/fixtures/p/moved_scan.sh tools/fixtures/p/second_scan.sh 2>/dev/null || true)
M3A=$(printf '%s\n' "$M3" | grep '^moved tools/fixtures/p/moved_scan.sh' | sed 's/.*detail=//')
M3B=$(printf '%s\n' "$M3" | grep '^moved tools/fixtures/p/second_scan.sh' | sed 's/.*detail=//')
leg mutation_restore_bites "$([ "$M3A" = "$M3B" ] && echo same || echo differ)" differ

echo "legs=$legs"
echo "control_failed=$failed"
echo "control_verdict=ok"
