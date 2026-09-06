#!/bin/sh
# tools/fixtures/s/shim_reason_control.sh -- the dropped reason, planted on purpose.
#
# WHAT THIS DOES. tools/fixtures/s/shim_reason_scan.sh claims that no pass-through shim on the
# standing roster drops its target's stderr, and that the residue off the roster stands under a
# ceiling. This control builds REAL git repositories in a throwaway pen, plants one thing in each,
# and watches the scan answer. Every refusal is shown from BOTH sides -- planted, then lifted --
# since a refusal proven only in the failing direction cannot be told from a scan that reds on
# everything. Every welcome is asserted as hard as every refusal, because a reading that quietly
# stopped counting looks exactly like a clean tree.
#
# WHY THE GATE MUST BE PLANTED. `swallow_rostered` reads ZERO on this field and has since the day
# it was written, so nothing in the tree could ever prove it able to bite. The pen supplies the
# case the field does not hold: one swallowing shim, named by a `path` row, which must refuse -- and
# the SAME shim with `if r.err != "" then say r.err` added, which must pass.
#
# THE PHASES.
#   clean_free           -- one rostered shim that forwards: verdict=ok, exit 0, counts named.
#   rostered_bitten      -- the same shim, reason dropped, still rostered: refused by name.
#   rostered_lifted      -- the same pen repaired: green. One move, both sides.
#   ceiling_free         -- two unrostered swallowers at a ceiling of two: green.
#   ceiling_bitten       -- the SAME plant at a ceiling of one: refused. Both directions, one plant.
#   three_marks          -- three near-misses, each missing exactly one mark, are not shims.
#   untracked_unseen     -- a swallowing shim git does not track is not counted.
#   mention_not_a_seat   -- a path named inside a roster COMMENT is not a seat, so its swallow
#                           falls to the ratchet rather than the gate. The anchor, proven.
#   roster_refusal       -- no readable roster: refused, never credited. Restored: green.
#   empty_corpus         -- no tracked .rish at all: refused rather than answered clean (%463).
#   no_shims             -- .rish files present, none a shim: refused, since a reading that
#                           matched nothing proves nothing about shims.
#   no_repo              -- outside a git repository: refused.
#   alias_counted        -- `exit result.code` is named as the reading's own blind spot; a file
#                           exiting `r.code` is not.
#   instrument_refusal   -- a `git grep` that could not run must refuse by name, never read as a
#                           tree with nothing in it (REDS %473). The same pen unmutated reads
#                           clean, so the refusal belongs to the plant.
#
# COUNT, NEVER NUMBER. A phase total typed into this header is falsified by the next phase somebody
# adds, so the control tallies its own `cases=` and `repos=` and prints them at its close.
#
# USAGE
#   sh tools/fixtures/s/shim_reason_control.sh
#
# Driven by tools/s/shim_reason_witness.rish. Run from the repository root.
set -eu

scan=$(CDPATH= cd -- "$(dirname "$0")" && pwd)/shim_reason_scan.sh
[ -f "$scan" ] || { echo "control_verdict=no_scan"; echo "refused: no shim_reason_scan.sh beside this control" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# A pen carries the scan at its own tracked path, which also proves the reading does not accuse
# its own instrument: the scan is shell and the corpus is `.rish`, so it can never match.
new_repo() {
  repos=$((repos + 1))
  d="$pen/$1"
  mkdir -p "$d/tools/fixtures/s" "$d/tools/x" "$d/construction"
  cp "$scan" "$d/tools/fixtures/s/shim_reason_scan.sh"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name  pen \
    && git config commit.gpgsign false )
}

# The two shapes under test, written once here so the plant and its repair differ by one line.
swallowing_shim() {
  printf '%s\n' \
    '# pen shim' \
    'if length args == 0 then let r = run ["rishi/bin/rishi" "run" "tools/gen/pen/t.rish"]' \
    'if r.out != "" then say r.out' \
    'exit r.code'
}
forwarding_shim() {
  printf '%s\n' \
    '# pen shim' \
    'if length args == 0 then let r = run ["rishi/bin/rishi" "run" "tools/gen/pen/t.rish"]' \
    'if r.out != "" then say r.out' \
    'if r.err != "" then say r.err' \
    'exit r.code'
}

seal() { ( cd "$pen/$1" && git add -A && git commit -q -m "pen: seed" ); }

# Count, never number. A total typed into a header is falsified by the next phase somebody adds, so
# the control tallies its own readings and repositories and prints them at the close.
readings=0
repos=0
r() { readings=$((readings + 1)); echo "$1"; }

# `set +e` inside both: most phases run a scan that REFUSES, and under `set -e` a command
# substitution assigned to a variable carries that exit outward and kills the script at its first
# successful refusal -- which reads exactly like a control that ran out of phases.
run_scan() { ( set +e; cd "$pen/$1" || exit 0; CEILING="${2:-99}" sh ./tools/fixtures/s/shim_reason_scan.sh 2>/dev/null; exit 0 ); }
run_code() { ( set +e; cd "$pen/$1" || { echo 99; exit 0; }; CEILING="${2:-99}" sh ./tools/fixtures/s/shim_reason_scan.sh >/dev/null 2>&1; echo $?; exit 0 ); }

# --- clean_free ---------------------------------------------------------------------------
new_repo clean
forwarding_shim > "$pen/clean/tools/x/a.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n' > "$pen/clean/construction/standing-equipment.kyri"
seal clean
out=$(run_scan clean); code=$(run_code clean)
r "clean_exit=$code"
case "$out" in *"verdict=ok"*) r "clean_free=yes" ;; *) r "clean_free=no" ;; esac
case "$out" in *"shims=1"*) r "clean_shim_counted=yes" ;; *) r "clean_shim_counted=no" ;; esac
case "$out" in *"forwards_reason=1"*) r "clean_forward_counted=yes" ;; *) r "clean_forward_counted=no" ;; esac
case "$out" in *"swallow_rostered=0"*) r "clean_gate_zero=yes" ;; *) r "clean_gate_zero=no" ;; esac

# --- rostered_bitten, then lifted -----------------------------------------------------------
# The gate the field cannot supply. One line removed and the same shim must refuse; one line back
# and it must pass, so the refusal belongs to the plant rather than to the pen.
swallowing_shim > "$pen/clean/tools/x/a.rish"
out=$(run_scan clean); code=$(run_code clean)
r "rostered_exit=$code"
case "$out" in *"verdict=rostered_swallow"*) r "rostered_bitten=yes" ;; *) r "rostered_bitten=no" ;; esac
case "$out" in *"swallow_rostered=1"*) r "rostered_counted=yes" ;; *) r "rostered_counted=no" ;; esac
case "$out" in *"swallows: rostered tools/x/a.rish"*) r "rostered_named=yes" ;; *) r "rostered_named=no" ;; esac
forwarding_shim > "$pen/clean/tools/x/a.rish"
out=$(run_scan clean)
case "$out" in *"verdict=ok"*) r "rostered_lifted=yes" ;; *) r "rostered_lifted=no" ;; esac

# --- ceiling, both directions on one plant --------------------------------------------------
new_repo ceiling
swallowing_shim > "$pen/ceiling/tools/x/b.rish"
swallowing_shim > "$pen/ceiling/tools/x/c.rish"
printf '# no rows\n' > "$pen/ceiling/construction/standing-equipment.kyri"
seal ceiling
out=$(run_scan ceiling 2); code=$(run_code ceiling 2)
r "ceiling_free_exit=$code"
case "$out" in *"verdict=ok"*) r "ceiling_free=yes" ;; *) r "ceiling_free=no" ;; esac
case "$out" in *"swallow_unrostered=2"*) r "ceiling_counted=yes" ;; *) r "ceiling_counted=no" ;; esac
out=$(run_scan ceiling 1); code=$(run_code ceiling 1)
r "ceiling_bitten_exit=$code"
case "$out" in *"verdict=unrostered_over_ceiling"*) r "ceiling_bitten=yes" ;; *) r "ceiling_bitten=no" ;; esac

# --- three_marks --------------------------------------------------------------------------
# Each mark alone is ordinary: a witness runs another witness, a script says a captured stdout, a
# wrapper exits a code. Only all three together name a pass-through shim.
new_repo marks
forwarding_shim > "$pen/marks/tools/x/real.rish"
printf '%s\n' 'if r.out != "" then say r.out' 'exit r.code' > "$pen/marks/tools/x/no_run.rish"
printf '%s\n' 'let r = run ["rishi/bin/rishi" "run" "t.rish"]' 'exit r.code' > "$pen/marks/tools/x/no_say.rish"
printf '%s\n' 'let r = run ["rishi/bin/rishi" "run" "t.rish"]' 'if r.out != "" then say r.out' 'assert r.ok else "no"' > "$pen/marks/tools/x/no_exit.rish"
printf 'guard real\npath tools/x/real.rish\n' > "$pen/marks/construction/standing-equipment.kyri"
seal marks
out=$(run_scan marks)
case "$out" in *"shims=1"*) r "three_marks_needed=yes" ;; *) r "three_marks_needed=no" ;; esac
case "$out" in *"rish_files=4"*) r "three_marks_corpus_read=yes" ;; *) r "three_marks_corpus_read=no" ;; esac
case "$out" in *"verdict=ok"*) r "three_marks_free=yes" ;; *) r "three_marks_free=no" ;; esac

# --- untracked_unseen ----------------------------------------------------------------------
swallowing_shim > "$pen/marks/tools/x/loose.rish"
out=$(run_scan marks)
case "$out" in *"shims=1"*) r "untracked_unseen=yes" ;; *) r "untracked_unseen=no" ;; esac
( cd "$pen/marks" && git add -A && git commit -q -m "pen: track the loose shim" )
out=$(run_scan marks)
case "$out" in *"shims=2"*) r "tracked_then_seen=yes" ;; *) r "tracked_then_seen=no" ;; esac
case "$out" in *"swallow_unrostered=1"*) r "tracked_then_counted=yes" ;; *) r "tracked_then_counted=no" ;; esac

# --- mention_not_a_seat --------------------------------------------------------------------
# A roster comment naming a path is prose, not a seat. Unanchored, the scan would read this shim as
# rostered and refuse -- a guard counted rostered because somebody wrote about it.
new_repo mention
swallowing_shim > "$pen/mention/tools/x/d.rish"
printf '%s\n' '# the elder shape is described at path tools/x/d.rish and stays unrostered' > "$pen/mention/construction/standing-equipment.kyri"
seal mention
out=$(run_scan mention)
case "$out" in *"swallow_rostered=0"*) r "mention_not_a_seat=yes" ;; *) r "mention_not_a_seat=no" ;; esac
case "$out" in *"swallow_unrostered=1"*) r "mention_falls_to_ratchet=yes" ;; *) r "mention_falls_to_ratchet=no" ;; esac
printf 'guard d\npath tools/x/d.rish\n' >> "$pen/mention/construction/standing-equipment.kyri"
out=$(run_scan mention)
case "$out" in *"verdict=rostered_swallow"*) r "real_row_is_a_seat=yes" ;; *) r "real_row_is_a_seat=no" ;; esac

# --- roster_refusal ------------------------------------------------------------------------
# Without a roster every shim would silently read unrostered and the gate would report zero while
# measuring nothing, which is a green for the wrong reason.
mv "$pen/mention/construction/standing-equipment.kyri" "$pen/mention/construction/held-aside"
out=$(run_scan mention); code=$(run_code mention)
r "roster_refusal_exit=$code"
case "$out" in *"verdict=roster_unreadable"*) r "roster_refusal=yes" ;; *) r "roster_refusal=no" ;; esac
case "$out" in *"verdict=ok"*) r "roster_never_reads_ok=no" ;; *) r "roster_never_reads_ok=yes" ;; esac
mv "$pen/mention/construction/held-aside" "$pen/mention/construction/standing-equipment.kyri"
out=$(run_scan mention)
case "$out" in *"verdict=rostered_swallow"*) r "roster_restored=yes" ;; *) r "roster_restored=no" ;; esac

# --- empty_corpus --------------------------------------------------------------------------
new_repo empty
printf 'guard none\n' > "$pen/empty/construction/standing-equipment.kyri"
seal empty
out=$(run_scan empty); code=$(run_code empty)
r "empty_corpus_exit=$code"
case "$out" in *"verdict=empty_corpus"*) r "empty_corpus_refused=yes" ;; *) r "empty_corpus_refused=no" ;; esac

# --- no_shims ------------------------------------------------------------------------------
new_repo noshim
printf '%s\n' 'say "ordinary rishi"' > "$pen/noshim/tools/x/plain.rish"
printf 'guard none\n' > "$pen/noshim/construction/standing-equipment.kyri"
seal noshim
out=$(run_scan noshim); code=$(run_code noshim)
r "no_shims_exit=$code"
case "$out" in *"verdict=no_shims"*) r "no_shims_refused=yes" ;; *) r "no_shims_refused=no" ;; esac
case "$out" in *"rish_files=1"*) r "no_shims_corpus_named=yes" ;; *) r "no_shims_corpus_named=no" ;; esac

# --- no_repo -------------------------------------------------------------------------------
mkdir -p "$pen/bare/tools/fixtures/s"
cp "$scan" "$pen/bare/tools/fixtures/s/shim_reason_scan.sh"
out=$( set +e; cd "$pen/bare" || exit 0; GIT_CEILING_DIRECTORIES="$pen" sh ./tools/fixtures/s/shim_reason_scan.sh 2>/dev/null; exit 0 )
case "$out" in *"verdict=no_repo"*) r "no_repo_refused=yes" ;; *) r "no_repo_refused=no" ;; esac

# --- alias_counted -------------------------------------------------------------------------
# The reading's own blind spot, published rather than left for a later reader to rediscover.
new_repo alias
forwarding_shim > "$pen/alias/tools/x/e.rish"
printf '%s\n' 'let result = run ["sh" "x.sh"]' 'say result.out' 'exit result.code' > "$pen/alias/tools/x/other.rish"
printf 'guard e\npath tools/x/e.rish\n' > "$pen/alias/construction/standing-equipment.kyri"
seal alias
out=$(run_scan alias)
case "$out" in *"exit_alias_sites=1"*) r "alias_counted=yes" ;; *) r "alias_counted=no" ;; esac
case "$out" in *"alias: tools/x/other.rish"*) r "alias_named=yes" ;; *) r "alias_named=no" ;; esac
case "$out" in *"alias: tools/x/e.rish"*) r "alias_excludes_r=no" ;; *) r "alias_excludes_r=yes" ;; esac

# --- instrument_refusal ---------------------------------------------------------------------
# REDS %473's fault, planted rather than asserted. `git grep` exits 1 for "no match" and 2 or more
# when it could not run, and a truthy fallback reads those two opposite answers the same way. The
# plant is one unterminated bracket in the alias pattern; git grep exits 128 and the scan must
# refuse by name rather than report a tree with no blind spot in it.
new_repo instrument
forwarding_shim > "$pen/instrument/tools/x/f.rish"
printf 'guard f\npath tools/x/f.rish\n' > "$pen/instrument/construction/standing-equipment.kyri"
seal instrument
( cd "$pen/instrument" \
  && sed "s/\[a-z_\]+\\\\.code/[a-z_+\\\\.code/" tools/fixtures/s/shim_reason_scan.sh > bad_scan.sh )
out=$( set +e; cd "$pen/instrument" || exit 0; sh bad_scan.sh 2>/dev/null; exit 0 )
r "$(case "$out" in *"verdict=instrument_refusal"*) echo "instrument_refusal_bitten=yes" ;; *) echo "instrument_refusal_bitten=no" ;; esac)"
r "$(case "$out" in *"verdict=ok"*) echo "instrument_never_reads_ok=no" ;; *) echo "instrument_never_reads_ok=yes" ;; esac)"
# the same pen, unmutated, still reads clean -- so the refusal belongs to the plant.
out=$(run_scan instrument)
r "$(case "$out" in *"verdict=ok"*) echo "instrument_pen_innocent=yes" ;; *) echo "instrument_pen_innocent=no" ;; esac)"

echo "cases=$readings"
echo "repos=$repos"
echo "control_verdict=ok"
