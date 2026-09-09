#!/bin/sh
# tools/fixtures/s/shim_reason_control.sh -- the dropped reason, planted on purpose.
#
# WHAT THIS DOES. tools/fixtures/s/shim_reason_scan.sh holds one law in three shapes: a rostered
# pass-through shim forwards its target's stderr, a rostered witness forwards its control's, and a
# rostered binding says what its run wrote BEFORE the assert that would stop the run. Each shape
# keeps a gate at zero over the roster and a ratchet over the rest. This control builds REAL git repositories in a throwaway pen, plants one thing in each,
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
#   order_free           -- a witness saying its run BEFORE judging it: verdict=ok, count zero.
#   order_bitten         -- the same two lines the other way round, still rostered: refused by name.
#   order_lifted         -- the same pen with the move undone: green. One move, both sides.
#   order_ceiling        -- one unrostered late say, free at a ceiling of one and refused at zero.
#   order_silent         -- a witness that never says the run at all is a different fault and is
#                           not counted here, since this reading is about ORDER.
#   order_err            -- a late `say r.err` counts exactly as a late `say r.out` does.
#   order_other_var      -- a say belonging to a DIFFERENT run must not answer for this one; the
#                           blind reading is `is there a say below an assert`.
#   order_mention        -- a path named in a roster comment is still prose, in this shape too.
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
  mkdir -p "$d/tools/fixtures/s" "$d/tools/fixtures/p" "$d/tools/x" "$d/construction"
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

# The SECOND shape, written once so its plant and its repair also differ by one line: a control
# that names its failing behavior on stderr, and a witness above it that either carries that
# sentence to a reader or drops it.
stderr_control() {
  printf '%s\n' \
    '#!/bin/sh' \
    '# pen control' \
    'printf "FAIL a behavior -- wanted x, got y\\n" >&2' \
    'printf "pass=0 fail=1\\n"' \
    'exit 1'
}
losing_witness() {
  printf '%s\n' \
    '# pen witness' \
    'let ctl = run ["sh" "tools/fixtures/p/pen_control.sh"]' \
    'assert ctl.ok else "pen: the control refused --\\n${ctl.out}"'
}
carrying_witness() {
  printf '%s\n' \
    '# pen witness' \
    'let ctl = run ["sh" "tools/fixtures/p/pen_control.sh"]' \
    'assert ctl.ok else "pen: the control refused --\\n${ctl.out}\\n${ctl.err}"'
}

# The THIRD shape, written once so its plant and its repair differ only in the ORDER of two lines.
# A witness that says its run before judging it hands the reader everything the run wrote; the same
# two lines the other way round hand the reader nothing, because `assert` stops the run.
early_say_witness() {
  printf '%s\n' \
    '# pen witness' \
    'let scan = run ["sh" "tools/fixtures/p/pen_scan.sh"]' \
    'say scan.out' \
    'assert scan.ok else "pen: the scan refused"'
}
late_say_witness() {
  printf '%s\n' \
    '# pen witness' \
    'let scan = run ["sh" "tools/fixtures/p/pen_scan.sh"]' \
    'assert scan.ok else "pen: the scan refused"' \
    'say scan.out'
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
run_scan() { ( set +e; cd "$pen/$1" || exit 0; CEILING="${2:-99}" REASON_CEILING="${3:-99}" SCAN_ORDER_CEILING="${4:-99}" sh ./tools/fixtures/s/shim_reason_scan.sh 2>/dev/null; exit 0 ); }
run_code() { ( set +e; cd "$pen/$1" || { echo 99; exit 0; }; CEILING="${2:-99}" REASON_CEILING="${3:-99}" SCAN_ORDER_CEILING="${4:-99}" sh ./tools/fixtures/s/shim_reason_scan.sh >/dev/null 2>&1; echo $?; exit 0 ); }

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

# --- reason_lost, the second shape, both directions on one plant -----------------------------
# A control that names its failing behavior on STDERR, and a rostered witness that interpolates
# only `${ctl.out}`. This is the shape that reddened `fleet_watch` on `20260906.233111` and filed
# seven lines naming no behavior. Every pen here also carries one forwarding shim, so the first
# shape stays green and the refusal below can only belong to the second.
new_repo reason
forwarding_shim > "$pen/reason/tools/x/a.rish"
stderr_control  > "$pen/reason/tools/fixtures/p/pen_control.sh"
losing_witness  > "$pen/reason/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/reason/construction/standing-equipment.kyri"
seal reason
out=$(run_scan reason); code=$(run_code reason)
r "reason_exit=$code"
case "$out" in *"stderr_controls=1"*) r "reason_population_counted=yes" ;; *) r "reason_population_counted=no" ;; esac
case "$out" in *"verdict=rostered_reason_lost"*) r "reason_bitten=yes" ;; *) r "reason_bitten=no" ;; esac
case "$out" in *"reason_lost_rostered=1"*) r "reason_counted=yes" ;; *) r "reason_counted=no" ;; esac
case "$out" in *"reason_lost: rostered tools/x/pen_witness.rish"*) r "reason_named=yes" ;; *) r "reason_named=no" ;; esac
carrying_witness > "$pen/reason/tools/x/pen_witness.rish"
out=$(run_scan reason)
case "$out" in *"verdict=ok"*) r "reason_lifted=yes" ;; *) r "reason_lifted=no" ;; esac
case "$out" in *"reason_lost_rostered=0"*) r "reason_lifted_counted=yes" ;; *) r "reason_lifted_counted=no" ;; esac

# --- reason ceiling, both directions on one plant --------------------------------------------
new_repo reason_ceiling
forwarding_shim > "$pen/reason_ceiling/tools/x/a.rish"
stderr_control  > "$pen/reason_ceiling/tools/fixtures/p/pen_control.sh"
losing_witness  > "$pen/reason_ceiling/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n' > "$pen/reason_ceiling/construction/standing-equipment.kyri"
seal reason_ceiling
out=$(run_scan reason_ceiling 99 1); code=$(run_code reason_ceiling 99 1)
r "reason_ceiling_free_exit=$code"
case "$out" in *"verdict=ok"*) r "reason_ceiling_free=yes" ;; *) r "reason_ceiling_free=no" ;; esac
case "$out" in *"reason_lost_unrostered=1"*) r "reason_ceiling_counted=yes" ;; *) r "reason_ceiling_counted=no" ;; esac
out=$(run_scan reason_ceiling 99 0); code=$(run_code reason_ceiling 99 0)
r "reason_ceiling_bitten_exit=$code"
case "$out" in *"verdict=reason_lost_over_ceiling"*) r "reason_ceiling_bitten=yes" ;; *) r "reason_ceiling_bitten=no" ;; esac

# --- a control that keeps its FAIL line on stdout is not in the population --------------------
# The reading is about a sentence that CANNOT be seen through `.out`. A control printing FAIL to
# stdout hands its reason over whatever the witness interpolates, so counting it would red a
# witness that is already correct -- and a guard that reds on the ordinary is one somebody turns off.
new_repo reason_stdout
forwarding_shim > "$pen/reason_stdout/tools/x/a.rish"
printf '#!/bin/sh\nprintf "FAIL a behavior\\n"\nprintf "pass=0 fail=1\\n"\nexit 1\n' > "$pen/reason_stdout/tools/fixtures/p/pen_control.sh"
losing_witness > "$pen/reason_stdout/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/reason_stdout/construction/standing-equipment.kyri"
seal reason_stdout
out=$(run_scan reason_stdout); code=$(run_code reason_stdout)
r "reason_stdout_exit=$code"
case "$out" in *"stderr_controls=0"*) r "reason_stdout_unpopulated=yes" ;; *) r "reason_stdout_unpopulated=no" ;; esac
case "$out" in *"verdict=ok"*) r "reason_stdout_free=yes" ;; *) r "reason_stdout_free=no" ;; esac

# --- a MENTION of the shape is not an instance of it ------------------------------------------
# The reading caught itself on this: the pen helper above WRITES a stderr-reporting control, so its
# own source carries that line inside single quotes, and a first pattern counted this instrument as
# one of its own subjects. Both spellings of a mention are planted here -- quoted, and commented --
# and a witness above either must pass free, since neither control ever writes to stderr at all.
new_repo reason_mention
forwarding_shim > "$pen/reason_mention/tools/x/a.rish"
# The plant reproduces the REAL shape byte for byte: a `printf` argument list continued onto its
# own line, where that line holds nothing but the quoted string. A first draft put a live `printf`
# and the quoted mention on ONE line, which is genuinely ambiguous and is not the shape that was
# fixed -- a plant must be the fault, rather than something near it.
printf '%s\n' \
  '#!/bin/sh' \
  '# a control that only WRITES another control into a pen' \
  'emit_one() {' \
  "  printf '%s\\n' \\" \
  "    'printf \"FAIL planted\\\\n\" >&2'" \
  '}' \
  'printf "pass=1 fail=0\\n"' > "$pen/reason_mention/tools/fixtures/p/pen_control.sh"
losing_witness > "$pen/reason_mention/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/reason_mention/construction/standing-equipment.kyri"
seal reason_mention
out=$(run_scan reason_mention)
case "$out" in *"stderr_controls=0"*) r "reason_quoted_mention_unseen=yes" ;; *) r "reason_quoted_mention_unseen=no" ;; esac
case "$out" in *"verdict=ok"*) r "reason_quoted_mention_free=yes" ;; *) r "reason_quoted_mention_free=no" ;; esac

new_repo reason_comment
forwarding_shim > "$pen/reason_comment/tools/x/a.rish"
printf '%s\n' \
  '#!/bin/sh' \
  "# this control could printf 'FAIL %s' >&2 and does not" \
  'printf "pass=1 fail=0\\n"' > "$pen/reason_comment/tools/fixtures/p/pen_control.sh"
losing_witness > "$pen/reason_comment/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/reason_comment/construction/standing-equipment.kyri"
seal reason_comment
out=$(run_scan reason_comment)
case "$out" in *"stderr_controls=0"*) r "reason_comment_unseen=yes" ;; *) r "reason_comment_unseen=no" ;; esac
case "$out" in *"verdict=ok"*) r "reason_comment_free=yes" ;; *) r "reason_comment_free=no" ;; esac

# --- one variable's reason never credits another's --------------------------------------------
# A witness forwarding SOME OTHER run's stderr must not be read as forwarding the control's. The
# blindest possible version of this reading is `does the file mention .err anywhere`, and this is
# the case that tells the two apart.
new_repo reason_other_var
forwarding_shim > "$pen/reason_other_var/tools/x/a.rish"
stderr_control  > "$pen/reason_other_var/tools/fixtures/p/pen_control.sh"
printf '%s\n' \
  '# pen witness' \
  'let other = run ["sh" "-c" "true"]' \
  'say other.err' \
  'let ctl = run ["sh" "tools/fixtures/p/pen_control.sh"]' \
  'assert ctl.ok else "pen: refused --\\n${ctl.out}"' > "$pen/reason_other_var/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/reason_other_var/construction/standing-equipment.kyri"
seal reason_other_var
out=$(run_scan reason_other_var)
case "$out" in *"verdict=rostered_reason_lost"*) r "reason_other_var_bitten=yes" ;; *) r "reason_other_var_bitten=no" ;; esac
case "$out" in *"reason_lost_rostered=1"*) r "reason_other_var_counted=yes" ;; *) r "reason_other_var_counted=no" ;; esac

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


# --- the third shape: the reason is said, and said too late -------------------------------------
# `assert` stops the run, so a `say` on the next line never happens when the target refuses. This
# fired twice on the fleet's own metal in one cold pass on `20260907` -- `index_row_bound` with a
# real fault and `shipped_binary_claim` with a flake -- and neither evidence page could name its
# cause. Every pen here carries one forwarding shim, so the first shape stays out of the way and
# the refusal below can only belong to the third.
new_repo order
forwarding_shim  > "$pen/order/tools/x/a.rish"
early_say_witness > "$pen/order/tools/x/pen_order_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_order_witness.rish\ntier lap\n' > "$pen/order/construction/standing-equipment.kyri"
seal order
out=$(run_scan order); code=$(run_code order)
r "order_free_exit=$code"
case "$out" in *"verdict=ok"*) r "order_free=yes" ;; *) r "order_free=no" ;; esac
case "$out" in *"late_say_rostered=0"*) r "order_free_counted=yes" ;; *) r "order_free_counted=no" ;; esac
late_say_witness > "$pen/order/tools/x/pen_order_witness.rish"
out=$(run_scan order); code=$(run_code order)
r "order_bitten_exit=$code"
case "$out" in *"verdict=rostered_late_say"*) r "order_bitten=yes" ;; *) r "order_bitten=no" ;; esac
case "$out" in *"late_say_rostered=1"*) r "order_counted=yes" ;; *) r "order_counted=no" ;; esac
case "$out" in *"late_say: rostered tools/x/pen_order_witness.rish scan"*) r "order_named=yes" ;; *) r "order_named=no" ;; esac
early_say_witness > "$pen/order/tools/x/pen_order_witness.rish"
out=$(run_scan order)
case "$out" in *"verdict=ok"*) r "order_lifted=yes" ;; *) r "order_lifted=no" ;; esac

# --- the third ceiling, both directions on one plant ---------------------------------------------
new_repo order_ceiling
forwarding_shim > "$pen/order_ceiling/tools/x/a.rish"
late_say_witness > "$pen/order_ceiling/tools/x/pen_order_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n' > "$pen/order_ceiling/construction/standing-equipment.kyri"
seal order_ceiling
out=$(run_scan order_ceiling 99 99 1); code=$(run_code order_ceiling 99 99 1)
r "order_ceiling_free_exit=$code"
case "$out" in *"verdict=ok"*) r "order_ceiling_free=yes" ;; *) r "order_ceiling_free=no" ;; esac
case "$out" in *"late_say_unrostered=1"*) r "order_ceiling_counted=yes" ;; *) r "order_ceiling_counted=no" ;; esac
out=$(run_scan order_ceiling 99 99 0); code=$(run_code order_ceiling 99 99 0)
r "order_ceiling_bitten_exit=$code"
case "$out" in *"verdict=late_say_over_ceiling"*) r "order_ceiling_bitten=yes" ;; *) r "order_ceiling_bitten=no" ;; esac

# --- a witness that never says the run is a different fault --------------------------------------
# This reading is about ORDER. A witness saying nothing at all has nothing standing in the wrong
# place, and counting it here would blur two faults into one number that names neither.
new_repo order_silent
forwarding_shim > "$pen/order_silent/tools/x/a.rish"
printf '%s\n' \
  '# pen witness' \
  'let scan = run ["sh" "tools/fixtures/p/pen_scan.sh"]' \
  'assert scan.ok else "pen: the scan refused"' > "$pen/order_silent/tools/x/pen_order_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_order_witness.rish\ntier lap\n' > "$pen/order_silent/construction/standing-equipment.kyri"
seal order_silent
out=$(run_scan order_silent)
case "$out" in *"late_say_rostered=0"*) r "order_silent_unseen=yes" ;; *) r "order_silent_unseen=no" ;; esac
case "$out" in *"verdict=ok"*) r "order_silent_free=yes" ;; *) r "order_silent_free=no" ;; esac

# --- a late `say r.err` counts the same way ------------------------------------------------------
new_repo order_err
forwarding_shim > "$pen/order_err/tools/x/a.rish"
printf '%s\n' \
  '# pen witness' \
  'let scan = run ["sh" "tools/fixtures/p/pen_scan.sh"]' \
  'assert scan.ok else "pen: the scan refused"' \
  'say scan.err' > "$pen/order_err/tools/x/pen_order_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_order_witness.rish\ntier lap\n' > "$pen/order_err/construction/standing-equipment.kyri"
seal order_err
out=$(run_scan order_err)
case "$out" in *"verdict=rostered_late_say"*) r "order_err_bitten=yes" ;; *) r "order_err_bitten=no" ;; esac

# --- one variable's `say` never answers for another's --------------------------------------------
# The blindest version of this reading is `is there a say below an assert`, and this is the case
# that tells the two apart: the say belongs to a different run entirely.
new_repo order_other_var
forwarding_shim > "$pen/order_other_var/tools/x/a.rish"
printf '%s\n' \
  '# pen witness' \
  'let other = run ["sh" "-c" "true"]' \
  'let scan = run ["sh" "tools/fixtures/p/pen_scan.sh"]' \
  'say scan.out' \
  'assert scan.ok else "pen: the scan refused"' \
  'assert other.ok else "pen: the other run must pass"' \
  'say other.out' > "$pen/order_other_var/tools/x/pen_order_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_order_witness.rish\ntier lap\n' > "$pen/order_other_var/construction/standing-equipment.kyri"
seal order_other_var
out=$(run_scan order_other_var)
case "$out" in *"late_say_rostered=1"*) r "order_other_var_counted=yes" ;; *) r "order_other_var_counted=no" ;; esac
case "$out" in *"late_say: rostered tools/x/pen_order_witness.rish other"*) r "order_other_var_named=yes" ;; *) r "order_other_var_named=no" ;; esac

# --- a mention of the shape inside a roster comment is still not a seat ---------------------------
new_repo order_mention
forwarding_shim > "$pen/order_mention/tools/x/a.rish"
late_say_witness > "$pen/order_mention/tools/x/pen_order_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n# the pen witness at path tools/x/pen_order_witness.rish stays unrostered\n' > "$pen/order_mention/construction/standing-equipment.kyri"
seal order_mention
out=$(run_scan order_mention)
case "$out" in *"late_say_rostered=0"*) r "order_mention_not_a_seat=yes" ;; *) r "order_mention_not_a_seat=no" ;; esac
case "$out" in *"late_say_unrostered=1"*) r "order_mention_falls_to_ratchet=yes" ;; *) r "order_mention_falls_to_ratchet=no" ;; esac

# A syntax error in the ordering parser must stop the census before it reports counts.
# The same repository with the original parser proves that the plant caused the refusal.
new_repo order_instrument
forwarding_shim > "$pen/order_instrument/tools/x/a.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n' > "$pen/order_instrument/construction/standing-equipment.kyri"
seal order_instrument
sed 's/^function flush(  v) {/function flush(  v {/' "$pen/order_instrument/tools/fixtures/s/shim_reason_scan.sh" > "$pen/order_instrument/bad_scan.sh"
if cmp -s "$pen/order_instrument/tools/fixtures/s/shim_reason_scan.sh" "$pen/order_instrument/bad_scan.sh"; then
  r "order_instrument_planted=no"
else
  r "order_instrument_planted=yes"
fi
out=$( set +e; cd "$pen/order_instrument" || exit 0; sh bad_scan.sh 2>/dev/null; exit 0 )
code=$( set +e; cd "$pen/order_instrument" || { echo 99; exit 0; }; sh bad_scan.sh >/dev/null 2>&1; echo $?; exit 0 )
r "order_instrument_exit=$code"
case "$out" in *"verdict=instrument_refusal"*) r "order_instrument_named=yes" ;; *) r "order_instrument_named=no" ;; esac
case "$out" in *"late_say_rostered="*) r "order_instrument_count_withheld=no" ;; *) r "order_instrument_count_withheld=yes" ;; esac
out=$(run_scan order_instrument)
case "$out" in *"verdict=ok"*) r "order_instrument_lifted=yes" ;; *) r "order_instrument_lifted=no" ;; esac

# A failed caller search has no population to publish. Exit 1 remains no match.
new_repo caller_instrument
forwarding_shim > "$pen/caller_instrument/tools/x/a.rish"
stderr_control > "$pen/caller_instrument/tools/fixtures/p/pen_control.sh"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/caller_instrument/construction/standing-equipment.kyri"
seal caller_instrument
out=$(run_scan caller_instrument); code=$(run_code caller_instrument)
r "caller_absent_exit=$code"
case "$out" in *"verdict=ok"*) r "caller_absent_free=yes" ;; *) r "caller_absent_free=no" ;; esac
losing_witness > "$pen/caller_instrument/tools/x/pen_witness.rish"
seal caller_instrument
mkdir -p "$pen/caller-bin"
SHIM_TEST_REAL_GIT=$(command -v git)
export SHIM_TEST_REAL_GIT
cat > "$pen/caller-bin/git" <<'GIT'
#!/bin/sh
if [ "${1:-}" = grep ] && [ "${4:-}" = pen_control.sh ]; then
  printf '%s\n' 'tools/x/pen_witness.rish'
  printf '%s\n' 'caller-probe: git search refused' >&2
  exit "$SHIM_TEST_CALLER_STATUS"
fi
exec "$SHIM_TEST_REAL_GIT" "$@"
GIT
chmod +x "$pen/caller-bin/git"
for caller_status in 2 128; do
  out=$( set +e; cd "$pen/caller_instrument" || exit 0
    PATH="$pen/caller-bin:$PATH" SHIM_TEST_CALLER_STATUS="$caller_status" sh tools/fixtures/s/shim_reason_scan.sh 2> "$pen/caller-error"
    echo "probe_exit=$?" )
  case "$out" in *"probe_exit=2"*) r "caller_${caller_status}_exit=yes" ;; *) r "caller_${caller_status}_exit=no" ;; esac
  case "$out" in *"verdict=instrument_refusal"*) r "caller_${caller_status}_named=yes" ;; *) r "caller_${caller_status}_named=no" ;; esac
  case "$out" in *"reason_lost_rostered="*|*"verdict=ok"*) r "caller_${caller_status}_count_withheld=no" ;; *) r "caller_${caller_status}_count_withheld=yes" ;; esac
  if grep -qF 'caller-probe: git search refused' "$pen/caller-error"; then
    r "caller_${caller_status}_diagnostic=yes"
  else
    r "caller_${caller_status}_diagnostic=no"
  fi
done
out=$(run_scan caller_instrument)
case "$out" in *"verdict=rostered_reason_lost"*) r "caller_restored_bitten=yes" ;; *) r "caller_restored_bitten=no" ;; esac
carrying_witness > "$pen/caller_instrument/tools/x/pen_witness.rish"
out=$(run_scan caller_instrument)
case "$out" in *"verdict=ok"*) r "caller_repaired_free=yes" ;; *) r "caller_repaired_free=no" ;; esac

# Full-line comments cannot forward a result or supply a shim's required marks.
new_repo comment_shim
swallowing_shim > "$pen/comment_shim/tools/x/a.rish"
printf '%s\n' '  # if r.err != "" then say r.err' >> "$pen/comment_shim/tools/x/a.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n' > "$pen/comment_shim/construction/standing-equipment.kyri"
seal comment_shim
out=$(run_scan comment_shim); code=$(run_code comment_shim)
r "comment_shim_exit=$code"
case "$out" in *"swallow_rostered=1"*) r "comment_shim_counted=yes" ;; *) r "comment_shim_counted=no" ;; esac
forwarding_shim > "$pen/comment_shim/tools/x/a.rish"
printf '%s\n' '  # if r.err != "" then say r.err' >> "$pen/comment_shim/tools/x/a.rish"
out=$(run_scan comment_shim); code=$(run_code comment_shim)
r "comment_shim_lifted_exit=$code"
case "$out" in *"forwards_reason=1"*) r "comment_shim_lifted=yes" ;; *) r "comment_shim_lifted=no" ;; esac

new_repo comment_marks
forwarding_shim > "$pen/comment_marks/tools/x/a.rish"
printf '%s\n' '  # let r = run ["rishi/bin/rishi" "run" "t.rish"]' 'say r.out' 'exit r.code' > "$pen/comment_marks/tools/x/comment_run.rish"
printf '%s\n' 'let r = run ["rishi/bin/rishi" "run" "t.rish"]' '  # say r.out' 'exit r.code' > "$pen/comment_marks/tools/x/comment_say.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\n' > "$pen/comment_marks/construction/standing-equipment.kyri"
seal comment_marks
out=$(run_scan comment_marks 0); code=$(run_code comment_marks 0)
r "comment_marks_exit=$code"
case "$out" in *"shims=1"*) r "comment_marks_unseen=yes" ;; *) r "comment_marks_unseen=no" ;; esac
swallowing_shim > "$pen/comment_marks/tools/x/comment_run.rish"
swallowing_shim > "$pen/comment_marks/tools/x/comment_say.rish"
out=$(run_scan comment_marks 0); code=$(run_code comment_marks 0)
r "comment_marks_restored_exit=$code"
case "$out" in *"shims=3"*) r "comment_marks_restored=yes" ;; *) r "comment_marks_restored=no" ;; esac

new_repo comment_reason
forwarding_shim > "$pen/comment_reason/tools/x/a.rish"
stderr_control > "$pen/comment_reason/tools/fixtures/p/pen_control.sh"
losing_witness > "$pen/comment_reason/tools/x/pen_witness.rish"
printf '%s\n' '  # carry ${ctl.err} to the reader' >> "$pen/comment_reason/tools/x/pen_witness.rish"
printf 'guard a\npath tools/x/a.rish\ntier lap\nguard pen\npath tools/x/pen_witness.rish\ntier lap\n' > "$pen/comment_reason/construction/standing-equipment.kyri"
seal comment_reason
out=$(run_scan comment_reason); code=$(run_code comment_reason)
r "comment_reason_exit=$code"
case "$out" in *"reason_lost_rostered=1"*) r "comment_reason_counted=yes" ;; *) r "comment_reason_counted=no" ;; esac
# A hash inside the quoted assertion stays data, with its interpolation intact.
carrying_witness | sed 's/pen: the control/pen # the control/' > "$pen/comment_reason/tools/x/pen_witness.rish"
printf '%s\n' '  # carry ${ctl.err} to the reader' >> "$pen/comment_reason/tools/x/pen_witness.rish"
out=$(run_scan comment_reason); code=$(run_code comment_reason)
r "comment_reason_lifted_exit=$code"
case "$out" in *"reason_lost_rostered=0"*) r "comment_reason_lifted=yes" ;; *) r "comment_reason_lifted=no" ;; esac

# A comment mentioning stdout cannot place a caller in the interpolation population.
printf '%s\n' 'let ctl = run ["sh" "tools/fixtures/p/pen_control.sh"]' 'assert ctl.ok else "pen control refused"' '# ${ctl.out}' > "$pen/comment_reason/tools/x/pen_witness.rish"
out=$(run_scan comment_reason); code=$(run_code comment_reason)
r "comment_out_exit=$code"
case "$out" in *"reason_lost_rostered=0"*) r "comment_out_unseen=yes" ;; *) r "comment_out_unseen=no" ;; esac

echo "cases=$readings"
echo "repos=$repos"
echo "control_verdict=ok"
