#!/bin/sh
# sow_project_control.sh -- prove the seed projection on a synthetic field.
#
#   sh tools/fixtures/s/sow_project_control.sh
#
# WHY A PEN RATHER THAN THE REAL TREE. `tools/fixtures/s/sow_project.sh` reads
# `git ls-files`, so it can only be exercised inside a git repository. The pen
# below IS one: a throwaway field carrying one file per branch the projection
# owns -- plain, name-bearing, unscrubbable, armored, key-named, sub-excluded,
# executable, ssh-key-bearing, nested, and outside the allowlist. Every refusal
# is planted and then lifted, because a refusal proven only in the passing
# direction cannot be told from a bypass.
#
# WHAT IT CANNOT REACH. Parity of the batched classification against the elder
# per-file loop over the REAL field of some nine thousand candidates is a
# whole-tree reading rather than a pen one. Take it by hand: project at the
# elder commit, keep that tree, project again at this one, and `diff -r` the two.
set -eu

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
# The pen lives in this tree's own `.lap/` room rather than in `/tmp`: eight
# checkouts share one `/tmp`, and a fixture two ships can reach is a fixture
# that reports one ship's field to the other. `.lap/` is gitignored and per
# tree, so a pen here is this ship's alone.
PEN="$ROOT/.lap/sow-project-control.$$"
SCRIPT="$ROOT/tools/fixtures/s/sow_project.sh"
S="$PEN/pen-seed"
LEGS=0
FAILED=0
REAL_XARGS="$(command -v xargs)"

leg() {  # leg NAME yes|no
  LEGS=$((LEGS + 1))
  echo "leg $1 verdict=$2"
  [ "$2" = yes ] || FAILED=$((FAILED + 1))
}

# A leg's condition runs inside `if`, where `set -e` stands down -- a failing
# check is a reading to report rather than a reason to stop the control.
say() { if [ "$1" -eq 0 ]; then echo yes; else echo no; fi; }

cleanup() { rm -rf "$PEN"; }
trap cleanup EXIT INT TERM

# ---------------------------------------------------------------------------
# The pen field.
# ---------------------------------------------------------------------------
mk_pen() {
  rm -rf "$PEN"
  mkdir -p "$PEN/tools/fixtures/s" "$PEN/room/sub" "$PEN/outside"
  cp "$ROOT/tools/fixtures/s/sow_reach_inputs.sh" "$PEN/tools/fixtures/s/"
  cp "$ROOT/tools/fixtures/s/sow_pubkey_stub.sh" "$PEN/tools/fixtures/s/"

  # The pen's own scrub: one name to one role, which is the shape of the real one.
  printf '%s\n' 's/Keaton/the maintainer/g' > "$PEN/pen-scrub.sed"

  # The pen's own manifest: one allowed room, one excluded file inside it.
  {
    echo 'allow room'
    echo 'sub_exclude room/excluded.md'
  } > "$PEN/pen-manifest.bron"

  printf 'a plain page with nobody in it\n'                    > "$PEN/room/plain.md"
  printf 'written by Keaton on a tuesday\n'                    > "$PEN/room/named.md"
  printf 'the forge handle xykj61 survives a name scrub\n'     > "$PEN/room/stubborn.md"
  printf 'BEGIN OPENSSH PRIVATE KEY\nblob\n'                   > "$PEN/room/armor.txt"
  printf 'fingerprint roster\n'                                > "$PEN/room/PUBKEYS.md"
  printf 'secret bytes\n'                                      > "$PEN/room/holder.key"
  printf 'excluded by the manifest, Keaton or not\n'           > "$PEN/room/excluded.md"
  printf '#!/bin/sh\n# Keaton wrote this runner\necho hi\n'    > "$PEN/room/run.sh"
  chmod +x "$PEN/room/run.sh"
  printf 'keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAANotAReal000 host" ];\n' \
                                                               > "$PEN/room/keys.nix"
  printf 'a nested plain page\n'                               > "$PEN/room/sub/deep.md"
  printf 'Keaton lives here and this room is not allowed\n'    > "$PEN/outside/hidden.md"

  # A stub `xargs` for the broken-instrument legs. It fails ONLY the calls that
  # carry grep -- the batched matches -- and hands every other call to the real
  # one, so the leg reads the refusal it names rather than some later failure.
  # It lives inside the pen, so every mk_pen leaves one standing.
  mkdir -p "$PEN/badbin"
  {
    echo '#!/bin/sh'
    echo 'for a in "$@"; do [ "$a" = grep ] && exit 5; done'
    printf 'exec %s "$@"\n' "$REAL_XARGS"
  } > "$PEN/badbin/xargs"
  chmod +x "$PEN/badbin/xargs"

  ( cd "$PEN"
    git init -q .
    git config user.email pen@example
    git config user.name pen
    git config commit.gpgsign false
    git add -A
    git commit -q -m 'pen field'
  )
}

run_projection() {  # run_projection SCRIPT-PATH [PATH-PREFIX]
  ( cd "$PEN"
    PATH="${2:-}${2:+:}$PATH" \
    SOW_MANIFEST=pen-manifest.bron \
    SOW_SEED=pen-seed \
    SOW_SCRUB=pen-scrub.sed \
    SEED_LOCK_DIR=pen.lock \
    SOW_WORK=.pen-work \
    sh "$1" > pen-run.txt 2>pen-err.txt
  )
}

mk_pen
rc=0; run_projection "$SCRIPT" || rc=$?
leg projection_exits_zero "$(say $rc)"

# --- what ships, and what it says ------------------------------------------
if [ -f "$S/room/plain.md" ] &&
   [ "$(cat "$S/room/plain.md")" = "a plain page with nobody in it" ]
then r=0; else r=1; fi
leg plain_page_copied_verbatim "$(say $r)"

if grep -q 'the maintainer' "$S/room/named.md" 2>/dev/null &&
   ! grep -q 'Keaton' "$S/room/named.md" 2>/dev/null
then r=0; else r=1; fi
leg named_page_scrubbed_to_role "$(say $r)"

if [ -f "$S/room/sub/deep.md" ]; then r=0; else r=1; fi
leg nested_directory_made "$(say $r)"

if [ -x "$S/room/run.sh" ]; then r=0; else r=1; fi
leg scrubbed_runner_keeps_exec_bit "$(say $r)"

if grep -q 'REPLACE_WITH_YOUR_PUBLIC_KEY' "$S/room/keys.nix" 2>/dev/null &&
   ! grep -q 'AAAAC3' "$S/room/keys.nix" 2>/dev/null
then r=0; else r=1; fi
leg ssh_blob_swapped_for_stub "$(say $r)"

# --- what never ships ------------------------------------------------------
if [ ! -e "$S/room/stubborn.md" ]; then r=0; else r=1; fi
leg unscrubbable_handle_withheld "$(say $r)"

if [ ! -e "$S/room/armor.txt" ]; then r=0; else r=1; fi
leg armor_block_withheld "$(say $r)"

if [ ! -e "$S/room/PUBKEYS.md" ]; then r=0; else r=1; fi
leg fingerprint_roster_withheld "$(say $r)"

if [ ! -e "$S/room/holder.key" ]; then r=0; else r=1; fi
leg key_named_file_withheld "$(say $r)"

if [ ! -e "$S/room/excluded.md" ]; then r=0; else r=1; fi
leg sub_excluded_file_absent "$(say $r)"

if [ ! -e "$S/outside/hidden.md" ]; then r=0; else r=1; fi
leg unallowed_room_never_reached "$(say $r)"

# --- the three logs, and the line each one owns ----------------------------
if grep -qx 'room/excluded.md' "$S/.sow-excluded.log" 2>/dev/null
then r=0; else r=1; fi
leg excluded_log_names_the_exclusion "$(say $r)"

if grep -qx 'room/excluded.md' "$S/.sow-withheld.log" 2>/dev/null
then r=1; else r=0; fi
leg exclusion_stays_out_of_withheld_log "$(say $r)"

if grep -qx 'room/stubborn.md' "$S/.sow-withheld.log" 2>/dev/null &&
   grep -qx 'room/armor.txt' "$S/.sow-withheld.log" 2>/dev/null &&
   grep -qx 'room/PUBKEYS.md' "$S/.sow-withheld.log" 2>/dev/null &&
   grep -qx 'room/holder.key' "$S/.sow-withheld.log" 2>/dev/null
then r=0; else r=1; fi
leg withheld_log_names_all_four "$(say $r)"

if grep -qx 'room/named.md' "$S/.sow-scrubbed.log" 2>/dev/null &&
   grep -qx 'room/run.sh' "$S/.sow-scrubbed.log" 2>/dev/null
then r=0; else r=1; fi
leg scrubbed_log_names_both_scrubs "$(say $r)"

if grep -qx 'room/stubborn.md' "$S/.sow-scrubbed.log" 2>/dev/null
then r=1; else r=0; fi
leg withheld_scrub_stays_out_of_scrubbed_log "$(say $r)"

# The logs read in CANDIDATE order rather than in verdict order, which is the
# order the elder's own appends produced. `git ls-files` sorts by byte, so
# `room/PUBKEYS.md` stands ahead of `room/armor.txt` and the withheld log's
# first line is the fingerprint roster rather than the armored blob.
if [ "$(head -1 "$S/.sow-withheld.log")" = 'room/PUBKEYS.md' ]
then r=0; else r=1; fi
leg withheld_log_reads_in_candidate_order "$(say $r)"

# --- the receipt line ------------------------------------------------------
# The copied count is a `find` over the projected tree, so it names the five
# projected files and the excluded log beside them -- the elder's own arithmetic,
# preserved rather than tidied.
if grep -q 'SOW_OK copied=6 scrubbed=2 withheld=4' "$PEN/pen-run.txt" 2>/dev/null
then r=0; else r=1; fi
leg receipt_counts_every_class "$(say $r)"

# --- a second run answers the same, and clears what left the field ---------
rm -rf "$PEN/first-seed"; cp -a "$S" "$PEN/first-seed"
printf 'a page from an elder projection\n' > "$S/room/stale.md"
rc=0; run_projection "$SCRIPT" || rc=$?
if [ "$rc" -eq 0 ] && [ ! -e "$S/room/stale.md" ]; then r=0; else r=1; fi
leg stale_projection_file_cleared "$(say $r)"

if diff -r "$PEN/first-seed" "$S" >/dev/null 2>&1; then r=0; else r=1; fi
leg second_run_projects_identical_bytes "$(say $r)"

# --- the candidate ceiling refuses, and is not merely absent ---------------
mut="$PEN/ceiling.sh"
sed 's/^SOW_MAX_CANDIDATES=.*/SOW_MAX_CANDIDATES=3/' "$SCRIPT" > "$mut"
rc=0; run_projection "$mut" || rc=$?
if [ "$rc" -ne 0 ] && grep -q 'past the ceiling' "$PEN/pen-err.txt" 2>/dev/null
then r=0; else r=1; fi
leg candidate_ceiling_refuses "$(say $r)"

# 64 rather than the real default: rewriting the line to the value it already
# carries leaves the file unmutated, and a phase that tests the unmutated file
# proves only what the first leg proved.
sed 's/^SOW_MAX_CANDIDATES=.*/SOW_MAX_CANDIDATES=64/' "$SCRIPT" > "$mut"
rc=0; run_projection "$mut" || rc=$?
leg candidate_ceiling_lifts "$(say $rc)"

# --- a broken batch refuses out loud rather than reading clean -------------
# A batched match that cannot run must never answer "nothing matched", because a
# silent empty answer reads exactly like a field with no maintainer in it.
rc=0; run_projection "$SCRIPT" "$PEN/badbin" || rc=$?
if [ "$rc" -ne 0 ] && grep -q 'batched match failed' "$PEN/pen-err.txt" 2>/dev/null
then r=0; else r=1; fi
leg broken_batch_refuses_loudly "$(say $r)"

# --- the step timing, and the reading it must not disturb -------------------
# `SOW_TIME` makes the projection report where its own seconds went (REDS %642).
# A measurement instrument earns its place by changing nothing it measures, so
# the parity leg below compares the two projected trees byte for byte.
mk_pen
rc=0; run_projection "$SCRIPT" || rc=$?
cp -a "$S" "$PEN/tree-silent"
if [ "$rc" -eq 0 ] && ! grep -q '^step_' "$PEN/pen-run.txt"; then r=0; else r=1; fi
leg timing_silent_by_default "$(say $r)"

export SOW_TIME=1
rc=0; run_projection "$SCRIPT" || rc=$?
cp -a "$S" "$PEN/tree-timed"
unset SOW_TIME

if grep -q '^step_scrub_s=' "$PEN/pen-run.txt" &&
   grep -q '^step_copy_s=' "$PEN/pen-run.txt" &&
   grep -q '^step_candidates_s=' "$PEN/pen-run.txt"
then r=0; else r=1; fi
leg timing_named_reports_each_step "$(say $r)"

if grep -q '^step_total_s=' "$PEN/pen-run.txt"; then r=0; else r=1; fi
leg timing_reports_a_total "$(say $r)"

# Eleven numbered steps and one total. A step added without a mark would read
# eleven here while the projection had twelve, so the count is the roster.
if [ "$(grep -c '^step_' "$PEN/pen-run.txt")" = 12 ]; then r=0; else r=1; fi
leg timing_step_roster_is_whole "$(say $r)"

# The witness asserts SOW_OK, so a timed run that lost it would turn the whole
# publish gate red while measuring it.
if grep -q '^SOW_OK ' "$PEN/pen-run.txt"; then r=0; else r=1; fi
leg timing_keeps_the_sow_ok_line "$(say $r)"

if diff -r "$PEN/tree-silent" "$PEN/tree-timed" >/dev/null 2>&1
then r=0; else r=1; fi
leg timing_moves_no_projected_byte "$(say $r)"

# --- mutations: each must bite a named leg above ---------------------------
# 1. Drop the armor pass. The armored blob must then ship.
mk_pen
mut="$PEN/mut_armor.sh"
sed 's|^batch_match "$W/keep.txt" "$W/armor.txt".*|: > "$W/armor.txt"|' "$SCRIPT" > "$mut"
rc=0; run_projection "$mut" || rc=$?
if [ -e "$S/room/armor.txt" ]; then r=0; else r=1; fi
leg mutation_armor_pass_dropped_bites "$(say $r)"

# 2. Drop the post-scrub identity re-read. The unscrubbable handle must then ship.
mk_pen
mut="$PEN/mut_recheck.sh"
sed 's|^batch_match "$W/scrubbed_dest.txt".*|: > "$W/still_dirty.txt"|' "$SCRIPT" > "$mut"
rc=0; run_projection "$mut" || rc=$?
if grep -q 'xykj61' "$S/room/stubborn.md" 2>/dev/null; then r=0; else r=1; fi
leg mutation_scrub_recheck_dropped_bites "$(say $r)"

# 3. Let the ssh pass read nothing. The raw key blob must then ship.
mk_pen
mut="$PEN/mut_ssh.sh"
sed 's|^batch_match "$W/dest_live.txt".*|: > "$W/sshkeyed.txt"|' "$SCRIPT" > "$mut"
rc=0; run_projection "$mut" || rc=$?
if grep -q 'AAAAC3' "$S/room/keys.nix" 2>/dev/null; then r=0; else r=1; fi
leg mutation_ssh_pass_dropped_bites "$(say $r)"

# 4. Let a chunk failure pass silently. The run then finishes green over a field
#    it never classified, and the armored blob ships -- which is why the refusal
#    in `batch_match` is a refusal rather than a return.
mk_pen
mut="$PEN/mut_silent.sh"
sed 's|^    \*) echo "sow: batched match failed.*|    *) return 0;;|' "$SCRIPT" > "$mut"
rc=0; run_projection "$mut" "$PEN/badbin" || rc=$?
if [ "$rc" -eq 0 ] && [ -e "$S/room/armor.txt" ]; then r=0; else r=1; fi
leg mutation_silent_batch_failure_bites "$(say $r)"


# 5. Lower the mark ceiling below the roster. The timed run must refuse out loud
#    rather than print a report quietly missing its own tail.
mk_pen
mut="$PEN/mut_marks.sh"
sed 's|^SOW_MAX_MARKS=16$|SOW_MAX_MARKS=2|' "$SCRIPT" > "$mut"
export SOW_TIME=1
rc=0; run_projection "$mut" || rc=$?
unset SOW_TIME
if [ "$rc" -ne 0 ] && grep -q 'past 2 step marks' "$PEN/pen-err.txt" 2>/dev/null
then r=0; else r=1; fi
leg mutation_mark_ceiling_refuses "$(say $r)"

echo "control_legs=$LEGS"
echo "control_failed=$FAILED"
if [ "$FAILED" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
