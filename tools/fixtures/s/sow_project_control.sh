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
# The streamed tree is compared against a LATER mk_pen generation, and mk_pen
# clears the whole pen -- so this one keeps its own room beside it.
STREAM="$ROOT/.lap/sow-project-stream.$$"
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

cleanup() { rm -rf "$PEN" "$STREAM"; }
trap cleanup EXIT INT TERM

# ---------------------------------------------------------------------------
# The pen field.
# ---------------------------------------------------------------------------
mk_pen() {
  rm -rf "$PEN"
  mkdir -p "$PEN/tools/fixtures/s" "$PEN/room/sub" "$PEN/room/shut/a/b" "$PEN/outside"
  cp "$ROOT/tools/fixtures/s/sow_reach_inputs.sh" "$PEN/tools/fixtures/s/"
  cp "$ROOT/tools/fixtures/s/sow_pubkey_stub.sh" "$PEN/tools/fixtures/s/"

  # The pen's own scrub: one name to one role, which is the shape of the real one.
  printf '%s\n' 's/Keaton/the maintainer/g' > "$PEN/pen-scrub.sed"

  # The pen's own manifest: one allowed room, one excluded file inside it.
  {
    echo 'allow room'
    echo 'sub_exclude room/excluded.md'
    echo 'sub_exclude room/shut'
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
  # A PLAIN runner and a SYMLINK, both plain copies: the elder exec-bit leg reads
  # the scrub path only, and a symlink is the one shape a copy can silently
  # dereference into a second full file.
  printf '#!/bin/sh\necho a runner nobody is named in\n'      > "$PEN/room/tool.sh"
  chmod +x "$PEN/room/tool.sh"
  ( cd "$PEN/room" && ln -sf plain.md link.md )
  # THREE LEVELS UNDER A DIRECTORY ENTRY. The elder tested `"$x"/*`, whose `*`
  # crosses slashes, so depth never mattered; the awk walks the path's own
  # ancestors instead, and a walk that stops at the first parent would ship this.
  printf 'a page three rooms under a shut door\n'              > "$PEN/room/shut/a/b/deep.md"
  # One file per basename glob the elder spelled, since the fold rewrote all ten
  # into anchored regex and each rewrite is a place a transcription can slip.
  printf 'lowercase in the middle of a name\n'                 > "$PEN/room/notes-siya-draft.md"
  printf 'uppercase, and identity-bearing besides\n'           > "$PEN/room/Siya-Fund.md"
  printf 'a roster whose name begins with the prefix\n'        > "$PEN/room/keys_roster.md"
  printf 'pem bytes\n'                                         > "$PEN/room/deploy.pem"
  printf 'armored ascii\n'                                     > "$PEN/room/trust.asc"
  printf 'ring bytes\n'                                        > "$PEN/room/ring.gpg"
  printf 'sec bytes\n'                                         > "$PEN/room/token.sec"
  printf 'secret bytes\n'                                      > "$PEN/room/vault.secret"
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

  # A pass-through that refuses. Named rather than reached through PATH, since
  # `SOW_COPY_TOOL` is how an operator names their own copy tool anyway.
  {
    echo '#!/bin/sh'
    echo 'echo "failcopy: refusing on purpose" >&2'
    echo 'exit 5'
  } > "$PEN/badbin/failcopy"
  chmod +x "$PEN/badbin/failcopy"

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

# A DIRECTORY candidate, planted the only way one can exist: `git ls-files`
# answers with a directory path for a gitlink and for nothing else. The real
# manifest withholds both submodules, so this class reads zero on the field --
# which is exactly why it is planted here rather than assumed away.
plant_gitlink() {
  ( cd "$PEN"
    mkdir -p room/mod
    printf 'a page inside a submodule\n' > room/mod/inner.md
    sha=$(git hash-object -w room/mod/inner.md)
    git update-index --add --cacheinfo 160000,"$sha",room/mod
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

# A directory entry reaches every depth beneath it. `room/shut` is the entry and
# the file stands three directories down, so an exclusion test reading only the
# path itself, or only its immediate parent, ships it.
if [ ! -e "$S/room/shut/a/b/deep.md" ]; then r=0; else r=1; fi
leg deep_path_under_excluded_dir_absent "$(say $r)"

# Every basename glob the elder spelled, each proven by its own file. The two
# `siya` spellings are case-SENSITIVE on purpose: the elder wrote two globs
# rather than one case-insensitive match, so `SIYA` was never covered and this
# fold may not quietly widen it.
r=0
for b in notes-siya-draft.md Siya-Fund.md keys_roster.md deploy.pem \
         trust.asc ring.gpg token.sec vault.secret; do
  [ -e "$S/room/$b" ] && r=1
done
leg every_key_shaped_basename_withheld "$(say $r)"

# The basename refusal is read BEFORE the identity pass, so an identity-bearing
# name withheld by shape never reaches the scrubbed log.
if grep -qx 'room/Siya-Fund.md' "$S/.sow-scrubbed.log" 2>/dev/null
then r=1; else r=0; fi
leg shape_withheld_name_never_scrubbed "$(say $r)"

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

# The excluded log owns the deep path, and the withheld log does not: an
# exclusion and a shape refusal are two verdicts with two rooms.
if grep -qx 'room/shut/a/b/deep.md' "$S/.sow-excluded.log" 2>/dev/null &&
   ! grep -qx 'room/shut/a/b/deep.md' "$S/.sow-withheld.log" 2>/dev/null
then r=0; else r=1; fi
leg excluded_log_owns_the_deep_path "$(say $r)"

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
# preserved rather than tidied. The withheld count reads 12 rather than the elder
# 4 because the pen now carries one file per basename glob: four refused by the
# elder's own four fixtures, eight more by the shapes it spelled and never proved.
# It reads copied=7 rather than 6 since the pen gained a plain runner for the copy
# path's own exec bit; `find -type f` passes over the symlink beside it.
if grep -q 'SOW_OK copied=7 scrubbed=2 withheld=12' "$PEN/pen-run.txt" 2>/dev/null
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

# --- the copy step: what it carries, and what it refuses -------------------
# Step 7 streams every plain copy through one `cpio` pass-through rather than one
# `cp -a` process per file (REDS %642). Three properties `diff -r` alone would
# miss get their own legs, and the fallback loop -- the elder step, unchanged --
# is proven to project the same tree rather than merely to run.
mk_pen
rc=0; run_projection "$SCRIPT" || rc=$?
rm -rf "$STREAM"; cp -a "$S" "$STREAM"

if [ -x "$S/room/tool.sh" ]; then r=0; else r=1; fi
leg plain_runner_keeps_exec_bit "$(say $r)"

if [ -L "$S/room/link.md" ] && [ "$(readlink "$S/room/link.md")" = plain.md ]
then r=0; else r=1; fi
leg symlink_arrives_as_symlink "$(say $r)"

mk_pen
export SOW_COPY_TOOL=
rc=0; run_projection "$SCRIPT" || rc=$?
unset SOW_COPY_TOOL
if [ "$rc" -eq 0 ] && diff -r --no-dereference "$STREAM" "$S" >/dev/null 2>&1
then r=0; else r=1; fi
leg copy_fallback_projects_identical_bytes "$(say $r)"

# A named tool this host lacks is an answer rather than a fault: the loop runs.
mk_pen
export SOW_COPY_TOOL=sow-no-such-copy-tool
rc=0; run_projection "$SCRIPT" || rc=$?
unset SOW_COPY_TOOL
if [ "$rc" -eq 0 ] && diff -r --no-dereference "$STREAM" "$S" >/dev/null 2>&1
then r=0; else r=1; fi
leg absent_copy_tool_falls_back "$(say $r)"

# A pass-through that FAILS refuses out loud. Falling back here would hide a
# broken copy tool behind a projection that merely took longer and looked fine.
mk_pen
export SOW_COPY_TOOL="$PEN/badbin/failcopy"
rc=0; run_projection "$SCRIPT" || rc=$?
unset SOW_COPY_TOOL
if [ "$rc" -ne 0 ] && grep -q 'copy pass-through' "$PEN/pen-err.txt" 2>/dev/null
then r=0; else r=1; fi
leg broken_copy_tool_refuses_loudly "$(say $r)"

# THE ONE INPUT THE TWO COPY PATHS DISAGREE ABOUT is a directory: `cp -a`
# recurses it, the pass-through writes the node alone. Step 1's `[ -f "$f" ]`
# filter is what keeps it away, and nothing proved that until now. A gitlink is
# the only directory `git ls-files` answers with, so it is the whole class.
mk_pen
plant_gitlink
rc=0; run_projection "$SCRIPT" || rc=$?
if [ "$rc" -eq 0 ] && [ ! -e "$S/room/mod" ]; then r=0; else r=1; fi
leg gitlink_never_becomes_a_candidate "$(say $r)"

# ... and the projection still ships the rest of the field, or the leg above
# reads a run that simply refused everything.
if [ -f "$S/room/plain.md" ]; then r=0; else r=1; fi
leg gitlink_plant_leaves_the_field_whole "$(say $r)"

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

# 6. Stop the exclusion test at the path itself, dropping the ancestor walk. A
#    file-equal entry still refuses, so the elder's own leg stays green and only
#    the deep path moves -- which is why depth earns a leg of its own.
mk_pen
mut="$PEN/mut_ancestors.sh"
sed 's|^      if (!sub(/\\/\[^\\/\]\*\$/, "", p)) break$|      break|' "$SCRIPT" > "$mut"
if ! grep -q '^      break$' "$mut"; then echo "control: mutation 6 changed nothing" >&2; exit 2; fi
rc=0; run_projection "$mut" || rc=$?
if [ -e "$S/room/shut/a/b/deep.md" ] && [ ! -e "$S/room/excluded.md" ]
then r=0; else r=1; fi
leg mutation_ancestor_walk_dropped_bites "$(say $r)"

# 7. Drop one basename glob from the shape refusal. That one file must then ship
#    while the other seven stay withheld, so the leg reads a transcription slip
#    rather than a collapsed pass.
mk_pen
mut="$PEN/mut_glob.sh"
sed 's|b ~ /\\.secret\$/|b == "\\000never"|' "$SCRIPT" > "$mut"
if ! grep -q '000never' "$mut"; then echo "control: mutation 7 changed nothing" >&2; exit 2; fi
rc=0; run_projection "$mut" || rc=$?
if [ -e "$S/room/vault.secret" ] && [ ! -e "$S/room/token.sec" ]
then r=0; else r=1; fi
leg mutation_one_basename_glob_dropped_bites "$(say $r)"

# 8. Drop step 1's regular-file filter. The gitlink must then reach the seed as
#    an EMPTY room -- the node without its contents -- while the projection
#    finishes green. This is the mutation that makes step 7's comment true: the
#    pass-through is safe BECAUSE of that one test, and no content diff of a
#    healthy projection would ever say so.
mk_pen
plant_gitlink
mut="$PEN/mut_regfile.sh"
sed 's@^    \[ -f "\$f" \] || continue$@    :@' "$SCRIPT" > "$mut"
if grep -q '^    \[ -f "\$f" \]' "$mut"; then echo "control: mutation 8 changed nothing" >&2; exit 2; fi
rc=0; run_projection "$mut" || rc=$?
if [ "$rc" -eq 0 ] && [ -d "$S/room/mod" ] && [ ! -e "$S/room/mod/inner.md" ]
then r=0; else r=1; fi
leg mutation_regular_file_filter_dropped_bites "$(say $r)"

# 9. Let a failed pass-through pass silently. The projection then finishes green
#    having copied nothing at all, which is the `batch_match` fault one step
#    over: a copy that moved nothing reads exactly like a field with nothing in it.
mk_pen
mut="$PEN/mut_copyfail.sh"
sed 's|^  if \[ "\$_rc" -ne 0 \]; then$|  if false; then|' "$SCRIPT" > "$mut"
if ! grep -q '^  if false; then$' "$mut"; then echo "control: mutation 9 changed nothing" >&2; exit 2; fi
export SOW_COPY_TOOL="$PEN/badbin/failcopy"
rc=0; run_projection "$mut" || rc=$?
unset SOW_COPY_TOOL
if [ "$rc" -eq 0 ] && [ ! -e "$S/room/plain.md" ]; then r=0; else r=1; fi
leg mutation_copy_failure_silenced_bites "$(say $r)"

echo "control_legs=$LEGS"
echo "control_failed=$FAILED"
if [ "$FAILED" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
