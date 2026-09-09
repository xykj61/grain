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
# ONE LAW, THREE SHAPES, three readings in one instrument rather than three instruments. Whatever
# this tree runs for a reader, it hands that thing's own sentence back. A SHIM forwards the verdict
# and keeps the reason; a WITNESS interpolates its control's stdout and leaves the stderr behind;
# and a witness may say the right thing one line too late, after the assert has already stopped the
# run. Each shape holds a gate at zero over the rostered set and a ratchet over the rest.
#
#   shims               -- pass-through shims found. A reading of zero refuses (REDS %463).
#   forwards_reason     -- shims that say `r.err`
#   swallow_rostered    -- swallowing shims the standing roster names. HELD AT ZERO.
#   swallow_unrostered  -- swallowing shims off the roster. RATCHET, ceiling only falls.
#   exit_alias_sites    -- files exiting a run's code under another name. Reported.
#   stderr_controls        -- controls whose FAIL line goes to stderr. The population. Reported.
#   reason_lost_rostered   -- a rostered witness over one, saying `.out` alone. HELD AT ZERO.
#   reason_lost_unrostered -- the same shape off the roster. RATCHET, ceiling only falls.
#   late_say_rostered      -- a rostered binding printing its run BELOW the first assert on it,
#                             where the assert stops the run first. HELD AT ZERO.
#   late_say_unrostered    -- the same shape off the roster. RATCHET, ceiling only falls.
#
# USAGE
#   sh tools/fixtures/s/shim_reason_scan.sh                 # census -- key=value lines
#   sh tools/fixtures/s/shim_reason_scan.sh list            # one line per finding, with its marks
#   CEILING=<n> sh tools/fixtures/s/shim_reason_scan.sh     # override the shim ratchet ceiling
#   REASON_CEILING=<n> ...                                  # override the control ratchet ceiling
#   SCAN_ORDER_CEILING=<n> ...                              # override the ordering ratchet ceiling
#
# Driven by tools/s/shim_reason_witness.rish. Proven both ways by shim_reason_control.sh.
# Run from the repository root.
set -eu

MODE="${1:-census}"

# The residue this ratchet stood at once the amphora lane took its own five, measured
# `20260906.123000`: 52 shims, 9 forwarding, 43 swallowing, none of them rostered. It only falls --
# repair a shim and lower it in the same commit.
CEILING="${CEILING:-43}"

# The second shape's residue, measured `20260906.233111` after the five rostered witnesses took
# their own line: eight controls print FAIL to stderr, five have a witness, and all five were
# repaired in the same commit. Nothing remains off the roster, so the ceiling opens at zero and can
# only fall further by staying there. It only falls -- repair a witness and lower it in the same
# commit.
REASON_CEILING="${REASON_CEILING:-0}"

# The third shape's residue, measured `20260907.045330` after all 117 rostered bindings took their
# own move: 276 bindings across the tree printed a run below the first assert on it, 117 of them on
# the standing roster and 159 off it. Repairing the rostered 117 brought the remainder to 157
# rather than 159, because `pond/apps/corpora/one_clock.rish` is a SYMLINK to a rostered witness
# and healed with the body it points at. The reading counts by PATH, so a body reachable two ways
# is read twice and repaired once -- which is the honest arithmetic for a ratchet, since the fault
# and its repair both live in the body. The gate opens at zero; the ceiling only falls -- move a
# `say` up and lower it in the same commit.
SCAN_ORDER_CEILING="${SCAN_ORDER_CEILING:-157}"

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

# -- THE SECOND SHAPE OF THE SAME LOSS (`20260906.233111`) ----------------------------------------
#
# A witness is not a shim, and it drops its target's reason the same way. A control writes its
# `FAIL <behavior> -- wanted X, got Y` line to STDERR so a passing run stays quiet; the witness
# above it interpolates `${ctl.out}` into its assert message and never `${ctl.err}`. The exit code
# travels, the count `pass=15 fail=1` travels, and the one clause naming WHICH behavior failed does
# not. The evidence page reads: this guard is red, and nothing more.
#
# Found by a red rather than by a search. `fleet_watch` reddened a cold pass on `20260906.233111`,
# filed seven lines that could not name a behavior, and then passed sixteen of sixteen on six
# consecutive re-runs -- so the one reading that could have diagnosed a flake was the reading the
# witness threw away. Measured the same hour: EIGHT controls print FAIL to stderr, five of them are
# run by a witness, and all five of those witnesses were on the standing roster and all five
# interpolated `.out` alone.
#
# THE THREE-MARK READING ABOVE CANNOT SEE THIS. It requires `say r.out` and `exit r.code`, which is
# a pass-through shim; these are witnesses that assert. One law -- hand on your target's reason --
# and two shapes, so the instrument grows a second reading rather than the tree growing a second
# instrument.
#
#   stderr_controls        controls whose FAIL line goes to stderr. The population. Reported.
#   reason_lost_rostered   a rostered witness over one of them, interpolating .out and never .err.
#                          HELD AT ZERO.
#   reason_lost_unrostered the same shape off the roster. RATCHET, ceiling only falls.

set +e
# A MENTION IS NOT AN INSTANCE, and this reading caught itself on `20260906.233111`. The pen helper
# in this guard's own control WRITES a stderr-reporting control into a pen, so its source carries
# the line `'printf "FAIL ..." >&2'` inside single quotes -- and a first pattern read 9 where the
# tree holds 8, counting the instrument as one of its own subjects. That is the anchor lesson this
# guard already teaches about roster seats, met one reading over.
#
# The discriminator is what stands immediately before the command: a real call is preceded by
# start-of-line or whitespace (`fail=$((fail + 1)); printf 'FAIL ...' >&2`), and a quoted mention is
# preceded by the quote that opens its string. Comment lines are dropped in the same pass, since a
# control may perfectly well DESCRIBE the shape it uses.
git grep -lE -- 'FAIL[^#]*>&2' -- 'tools/fixtures/*_control.sh' > "$work/ctl_maybe" 2>/dev/null
_st=$?
set -e
if [ "$_st" -gt 1 ]; then
  echo "rish_files=$rish_files"
  echo "verdict=instrument_refusal"
  echo "refused: git grep exited $_st reading the controls, so the reason-forward count is unknown" >&2
  exit 2
fi
[ -f "$work/ctl_maybe" ] || : > "$work/ctl_maybe"
: > "$work/stderr_ctl"
while IFS= read -r c; do
  [ -f "$c" ] || continue
  awk '/^[[:space:]]*#/ { next }
       /(^|[[:space:]])(printf|echo)[[:space:]].*FAIL.*>&2/ { found = 1 }
       END { exit found ? 0 : 1 }' "$c" && echo "$c" >> "$work/stderr_ctl"
done < "$work/ctl_maybe"
sort -u "$work/stderr_ctl" -o "$work/stderr_ctl"
stderr_controls=$(grep -c . "$work/stderr_ctl" || true)

: > "$work/reason_rows"
while IFS= read -r c; do
  [ -f "$c" ] || continue
  cb=$(basename "$c")
  set +e
  git grep -lF -- "$cb" -- '*.rish' > "$work/callers" 2>/dev/null
  _st=$?
  set -e
  [ "$_st" -gt 1 ] && continue
  [ -f "$work/callers" ] || : > "$work/callers"
  while IFS= read -r w; do
    [ -f "$w" ] || continue
    # The variable the control's run is bound to. Only that variable's spellings are read, so a
    # witness forwarding some OTHER run's stderr is never credited for this one.
    var=$(awk -v cb="$cb" '
      /^let [a-z_][a-z0-9_]* = run \[/ && index($0, cb) > 0 { print $2; exit }
    ' "$w")
    [ -n "$var" ] || continue
    if grep -qF "\${${var}.err}" "$w"; then continue; fi
    grep -qF "\${${var}.out}" "$w" || continue
    if grep -qxF "path $w" "$ROSTER"; then seat=rostered; else seat=unrostered; fi
    echo "$seat $w $cb" >> "$work/reason_rows"
  done < "$work/callers"
done < "$work/stderr_ctl"
sort -u "$work/reason_rows" -o "$work/reason_rows"

reason_lost_rostered=$(awk '$1 == "rostered"' "$work/reason_rows" | grep -c . || true)
reason_lost_unrostered=$(awk '$1 == "unrostered"' "$work/reason_rows" | grep -c . || true)

# -- THE THIRD SHAPE: THE REASON IS SAID, AND SAID TOO LATE (`20260907.045330`) --------------------
#
# A witness prints its target's stdout and then judges it:
#
#   let scan = run ["sh" "tools/fixtures/i/index_row_bound_scan.sh"]
#   assert scan.ok else "a living index row stands above the 192 bytes an index row is given"
#   say scan.out
#
# Rishi's `assert` stops the run, so when the scan refuses the `say` on the next line never
# happens. The reader receives the witness's own sentence and nothing the scan wrote -- and the
# message above literally asks a reader to read lines that were never printed. The exit code
# travels; the reading does not. Same law as the two shapes above, third mechanism: the reason is
# forwarded, and forwarded after the door has already closed.
#
# THIS FIRED TWICE ON ONE MORNING, on the fleet's own metal, in one cold pass. `20260907.042817`
# came back `guards_red=2`, and NEITHER evidence page could name its cause. `index_row_bound` had
# a real fault -- one row of the open day shelf standing above a newer one -- and reproduced when
# its scan was run by hand. `shipped_binary_claim` did not reproduce: its control passed on the
# next run and on every run after, which is a flake, and a flake is diagnosable only from what it
# wrote down the first time. Both witnesses print their target BELOW the assert that fires.
#
# PROVEN ON METAL BEFORE ANY OF THIS WAS WRITTEN, with that morning's own refusal in a pen. A
# fixture printing `rows=16`, `rows_misordered=1`, `verdict=rows_misordered` and exiting 1, under
# a witness saying `scan.out` after the assert, produced two lines and both were the witness's.
# The same fixture under the same witness with the `say` moved one line up produced all three
# readings, then the assertion. One line's position is the whole difference.
#
# THE REPAIR IS A MOVE, NEVER A REWRITE: the `say` goes immediately after the binding, so the
# target speaks before anything judges it. Say before you assert. Applied to all 117 rostered
# bindings on `20260907`, each one proven a pure reordering -- the sorted lines of every touched
# file are identical before and after.
#
#   late_say_rostered    a rostered binding printing its run below the first assert on that run.
#                        HELD AT ZERO.
#   late_say_unrostered  the same shape off the roster. RATCHET, ceiling only falls.
#
# ONE AWK PASS, not one per file. The reading walks every tracked `.rish` in a single invocation
# keyed on `FILENAME`, which reads 2,293 files in 0.2 seconds where a per-file loop cost 9.
# `shim_reason` stands at `tier lap` on 163 guards' clock, so its own cost is somebody's morning.

# This is a text reading of top-level let/run bindings, bare-variable assertions,
# and standalone say var.out/err lines. Parenthesized assertions and conditional
# output remain outside this reading; the scan reports only the forms it matches.
cat > "$work/order.awk" <<'AWK'
function flush(  v) {
  for (v in bind) {
    if (!(v in firstsay) || !(v in firstassert)) continue
    if (firstsay[v] > firstassert[v]) print cur, v, firstassert[v], firstsay[v]
  }
  for (v in bind) delete bind[v]
  for (v in firstsay) delete firstsay[v]
  for (v in firstassert) delete firstassert[v]
}
FILENAME != cur { if (cur != "") flush(); cur = FILENAME }
/^let [a-z_][a-z0-9_]* = run \[/ { bind[$2] = FNR; next }
/^assert [a-z_][a-z0-9_]*[. ]/ { v = $2; sub(/[.].*/, "", v); if ((v in bind) && !(v in firstassert)) firstassert[v] = FNR; next }
/^say [a-z_][a-z0-9_]*\.(out|err)$/ { v = $2; sub(/[.].*/, "", v); if ((v in bind) && !(v in firstsay)) firstsay[v] = FNR; next }
END { flush() }
AWK
: > "$work/order_rows"
# A failed parser has no count to report. Keep its diagnostic and refuse by name.
if ! xargs awk -f "$work/order.awk" < "$work/rish" > "$work/order_raw"; then
  echo "rish_files=$rish_files"
  echo "verdict=instrument_refusal"
  echo "refused: the ordering parser could not read the corpus" >&2
  exit 2
fi
# Seat each row on the roster the same anchored way the shapes above do: a `path` row standing
# alone at column zero, never a path mentioned inside a roster comment.
while IFS= read -r orow; do
  [ -n "$orow" ] || continue
  ofile=$(printf '%s\n' "$orow" | awk '{ print $1 }')
  if grep -qxF "path $ofile" "$ROSTER"; then oseat=rostered; else oseat=unrostered; fi
  printf '%s %s\n' "$oseat" "$orow" >> "$work/order_rows"
done < "$work/order_raw"
sort -u "$work/order_rows" -o "$work/order_rows"

late_say_rostered=$(awk '$1 == "rostered"' "$work/order_rows" | grep -c . || true)
late_say_unrostered=$(awk '$1 == "unrostered"' "$work/order_rows" | grep -c . || true)

if [ "$MODE" = list ]; then
  sort "$work/rows"
  awk '{ print "reason_lost " $1 " " $2 " (" $3 ")" }' "$work/reason_rows" | sort
  awk '{ print "late_say " $1 " " $2 " " $3 " (assert " $4 ", say " $5 ")" }' "$work/order_rows" | sort
  exit 0
fi

echo "rish_files=$rish_files"
echo "shims=$shims"
echo "forwards_reason=$forwards"
echo "swallow_rostered=$swallow_rostered"
echo "swallow_unrostered=$swallow_unrostered"
echo "unrostered_ceiling=$CEILING"
echo "exit_alias_sites=$alias_count"
echo "stderr_controls=$stderr_controls"
echo "reason_lost_rostered=$reason_lost_rostered"
echo "reason_lost_unrostered=$reason_lost_unrostered"
echo "reason_lost_ceiling=$REASON_CEILING"
echo "late_say_rostered=$late_say_rostered"
echo "late_say_unrostered=$late_say_unrostered"
echo "late_say_ceiling=$SCAN_ORDER_CEILING"
while IFS= read -r f; do echo "alias: $f"; done < "$work/alias"
awk '{ print "reason_lost: " $1 " " $2 " (" $3 ")" }' "$work/reason_rows" | sort
awk '{ print "late_say: " $1 " " $2 " " $3 " (assert " $4 ", say " $5 ")" }' "$work/order_rows" | sort
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

# The second shape gates after the first, so a tree carrying both hears the shim answer first and
# the two verdicts never race for one line.
if [ "$reason_lost_rostered" -gt 0 ]; then
  echo "verdict=rostered_reason_lost"
  echo "refused: $reason_lost_rostered rostered witness(es) run a control that names its failing behavior on stderr and forward only stdout -- the evidence page reads pass=N fail=1 and nothing a hand can act on" >&2
  exit 1
fi

if [ "$reason_lost_unrostered" -gt "$REASON_CEILING" ]; then
  echo "verdict=reason_lost_over_ceiling"
  echo "refused: $reason_lost_unrostered witnesses off the roster drop their control's reason against a ceiling of $REASON_CEILING -- the ceiling only falls" >&2
  exit 1
fi

# The third shape gates last, so a tree carrying all three hears them in the order they were seated
# and no two verdicts race for one line.
if [ "$late_say_rostered" -gt 0 ]; then
  echo "verdict=rostered_late_say"
  echo "refused: $late_say_rostered rostered binding(s) print their target BELOW the first assert on it -- assert stops the run, so when the target refuses the reader receives the witness's own sentence and nothing else" >&2
  exit 1
fi

if [ "$late_say_unrostered" -gt "$SCAN_ORDER_CEILING" ]; then
  echo "verdict=late_say_over_ceiling"
  echo "refused: $late_say_unrostered bindings off the roster print their target below the assert that judges it, against a ceiling of $SCAN_ORDER_CEILING -- the ceiling only falls" >&2
  exit 1
fi

echo "verdict=ok"
exit 0
