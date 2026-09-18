#!/bin/sh
# sow_project.sh -- project the clean public seed from the private field.
#
# POSIX seam (cp / sed / git-ls-files) per ORGANIZING's .sh boundary; driven by
# tools/s/sow.rish, which reads template-manifest.bron. The mechanism named in
# external-research/20260808-045124 (Movement I), pinned to the seed/ target by
# 20260808-062500 (field + seed layout).
#
# Discipline (safety first, TAME order):
#   - `template` and `scrub` paths are candidates; `personal` is never iterated
#     and `sub_exclude` whole-paths are skipped, so neither can leak.
#   - The two submodules (gratitude, vendor) are withheld from the copy; the
#     seed re-adds them via .gitmodules rather than vendoring gigabytes.
#   - A file with no maintainer identity is copied verbatim.
#   - A file that names the maintainer is run through the name->role scrub
#     (tools/fixtures/s/sow_scrub.sed). If it comes out identity-clean it is
#     kept scrubbed; if it still carries a functional handle or a code literal
#     (xykj61, debrided, bandun, pacpet-solreb) it is WITHHELD for human
#     judgment. So the seed is clean by construction, not by trust.
#   - Only git-tracked files move (git ls-files), so build output under
#     gitignored bin/.cache dirs never reaches the seed.
#
# NOTE: the witness this feeds proves no identity STRING and no personal PATH
# survive. It does not prove a full editorial privacy review -- that is the
# human read that gates M4 (publish), never this mechanism alone.
#
# ONE PROJECTION AT A TIME (seated 20260824.104946, REDS %193). This script clears
# seed/ and rebuilds it, so while it runs the directory is a partial tree. Anything
# else reading seed/ in that window reads a half-answer: on 20260824 a projection run
# beside the standing roster -- whose own `sow` guard re-projects -- reported
# `copied=1644` against the 6,948 the same tree gives alone, a 76% shortfall that
# reads exactly like an allowlist that stopped matching. The measurement was the only
# thing wrong, and it took knowing the expected number to notice.
#
# The reading is the cheap half of the cost. The expensive half is that seed/ is the
# PUBLIC face: sow_leak_scan.sh, sow_witness.rish, and publish-seed.sh all gate on
# what stands in that directory, and a gate that reads a tree still being written has
# examined a set nobody chose. IDENT_CLEAN over a partial projection is a true
# statement about the wrong corpus.
#
# So the lock is a refusal rather than a wait: a second projection exits non-zero and
# says who holds it, because a queued run would still hand the reader a number from a
# tree that changed under them. Held in a directory rather than a file, since mkdir is
# atomic on every POSIX filesystem where a two-step test-then-create is not. Released
# on EXIT, INT, and TERM, and a lock left by a killed run names its dead pid so the
# next run can clear it rather than wedge forever.
set -eu

LOCK="${SEED_LOCK_DIR:-seed.projection.lock}"
if ! mkdir "$LOCK" 2>/dev/null; then
  holder=$(cat "$LOCK/pid" 2>/dev/null || echo unknown)
  if [ "$holder" != unknown ] && ! kill -0 "$holder" 2>/dev/null; then
    # The holder is gone -- a killed run left the lock behind. Clear it and take it.
    echo "sow: clearing a lock left by dead pid $holder" >&2
    rm -rf "$LOCK"
    mkdir "$LOCK" 2>/dev/null || { echo "sow: cannot take the projection lock" >&2; exit 3; }
  else
    echo "sow: a projection is already running (pid $holder) -- refusing to build seed/ twice at once" >&2
    echo "sow: seed/ is rebuilt in place, so a second run would hand both readers a partial tree" >&2
    exit 3
  fi
fi
printf '%s\n' "$$" > "$LOCK/pid"
trap 'rm -rf "$LOCK"' EXIT INT TERM

# The three inputs are named by environment so a pen can drive this same script
# against a synthetic field. Every default is the real one, so a bare run is the
# run it always was.
MANIFEST="${SOW_MANIFEST:-template-manifest.bron}"
SEED="${SOW_SEED:-seed}"
SCRUB="${SOW_SCRUB:-tools/fixtures/s/sow_scrub.sed}"
# The copy pass-through, named so it can be refused. Step 7 says why.
COPY_TOOL="${SOW_COPY_TOOL-cpio}"
# Maintainer identity: real names, the retired copyright name, the forge
# handles, and the real Azimuth points. One place; the witness reuses it.
IDENT='Keaton|Kaeden|Livermore|Reyklah|Dunsford|Mayacama|xykj61|debrided|bandun|pacpet-solreb|keatonsiya|xnkg30|veganreyklah|cherry996|415.?915.?6666|npub1[a-z0-9]{40}|6Rb5E|AHs34|siyafund|bitscape|thebittradingcompany|xykj61atgmail|xykld2|xy96gen-z|S[a]bin|H[e]rtz|groupproject36|grain_energy|grain.energy|Grain Energy|Siya Fund|Vultr|Wenatchee|Sabey|Washoe County|Daylight DC-1|Tlon Corporation|0646 2132 D3E6|DBF8 5343 7A93|keatondun|keatonlivermore|teamcarry11|xwb122m|b122mnet|xnflor3|kaexvx9|kj3x39|b122m|construction3x39|vegancpa|veganaccountant|veganarchitect|veganbookkeeper|@gmail.com|Sealy|Zendex|CC8BA671|06462132|DxE|Direct Action Everywhere|wayne-hsiung|helen-atthowe|sarah-guo|kyler-murray|ariana-grande|kamala-harris|Pacific Time|Pacific time|66041JEA306288|bhagavan851c05a|kae3g|Brooke|Alexandra Livermore|Smart Access|maicmalamurr|Siya'

[ -f "$MANIFEST" ] || { echo "sow: $MANIFEST missing" >&2; exit 1; }
[ -f "$SCRUB" ]    || { echo "sow: $SCRUB missing" >&2; exit 1; }

# The reach reader compares the manifest and tracked path inventory with this receipt.
# These two inputs decide which rooms can be counted. This is coverage provenance;
# content freshness and privacy still belong to the whole-projection witnesses.
. tools/fixtures/s/sow_reach_inputs.sh
reach_inputs=$(sow_reach_inputs "$MANIFEST")

mkdir -p "$SEED"
rm -f "$SEED/.sow-projection.log"
# Clear prior projection content; preserve the seed repo's own .git if present.
find "$SEED" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} + 2>/dev/null || true
: > "$SEED/.sow-withheld.log"
: > "$SEED/.sow-scrubbed.log"
: > "$SEED/.sow-excluded.log"

# sub_exclude entries: either a whole path (e.g. linengrow) or a single file
# inside a scrub directory (e.g. a foundations biography essay). A file is
# excluded when it equals a sub_exclude entry or lives under one.
SUBEX=$(grep -E '^sub_exclude ' "$MANIFEST" | awk '{print $2}' || true)
# ALLOWLIST posture (Keaton's word 20260810): ship ONLY explicitly-cleared `allow`
# paths; everything else in the tree is withheld by default. This flips the seed from
# a denylist (scrub-everything) to an allowlist after five audit passes each found new
# private data. Allowed paths are STILL scrubbed and IDENT-checked below (defense in
# depth), and sub_exclude still withholds files inside an allowed dir.
# THE SECOND FILTER, and why only `vendor` is left in it (REDS %472). This line used to read
# `grep -vxE 'gratitude|vendor'`, a hard exclusion by name that ran AFTER the allowlist and won
# silently: `allow gratitude` in the manifest read as effective, the projection shipped nothing,
# and sow_witness answered GREEN -- because a room that ships no bytes leaks no names. An
# allowlist with a second list quietly subtracting from it is the seat table written twice
# (%409), one room over, and here it could publish a lie by omission rather than by leak.
# `vendor` stays: it is unmodified third-party BUILD SOURCE held for compilation, not a thanks
# record, and shipping it would republish other people's code rather than cite it. `gratitude`
# is allowed on Keaton's word `20260906` and withheld file by file where a law asks -- a saved
# third-party article by copyright, every gitlink by license -- which is the manifest's own
# mechanism doing the work rather than a name in a grep.
PATHS=$(grep -E '^allow ' "$MANIFEST" | awk '{print $2}' | grep -vxE 'vendor' || true)

is_subex() {
  for x in $SUBEX; do
    case "$1" in "$x"|"$x"/*) return 0;; esac
  done
  return 1
}
# ---------------------------------------------------------------------------
# THE CLASSIFICATION RUNS IN BATCHES, AND THE REASON IS PROCESS SPAWN (REDS %642).
#
# Elder shape: one `grep` per candidate for the armor blocks, one more for the
# identity list, one `basename`, one `mkdir -p`, one `cp`, and one `grep` on each
# copy for an ssh key -- so a 9,000-file projection paid tens of thousands of
# process starts. The timing paper priced those three greps at 56.69, 103.10 and
# 55.79 seconds (active-designing/date/20260916/20260916-121517_where-a-seed-publish-spends-its-minutes.md).
# Measured on a 500-path sample of the same set, a per-file grep loop runs 6,624 ms
# where ONE grep over the same 500 files runs 186 ms -- a factor of 35. The cost
# was starting grep, never reading the bytes.
#
# So each grep runs once over a whole list, `basename` becomes the shell's own
# ${f##*/}, and the destination directories are made in one pass. Every verdict,
# every withhold and every byte of every projected file is unchanged; the three
# logs are still written in candidate order, by a final pass that walks the
# candidate list rather than by appending as the loop goes.
#
# WHAT A BATCH MAY NOT DO: it may not decide a file's verdict from another file's
# bytes. Each list below is a membership set keyed by path, so a file's answer
# still depends on its own content alone.
# ---------------------------------------------------------------------------

# The work room holds the candidate lists. Outside seed/ on purpose: anything
# written under seed/ is a byte the publish would ship.
W="${SOW_WORK:-.sow-work}"
rm -rf "$W"; mkdir -p "$W"
trap 'rm -rf "$LOCK" "$W"' EXIT INT TERM

# A named ceiling on the candidate set. The list is materialized into one file and
# fed to xargs, which bounds each grep call by the system argument limit -- so the
# ceiling is about this instrument staying the right instrument rather than about
# any limit below it. A tree past this many tracked candidates wants a projection
# that streams rather than one that lists.
SOW_MAX_CANDIDATES=131072

# STEP TIMING, off unless asked. REDS %642's design names the reading to take before
# any cache is built -- how much of a publish is the per-file scrub -- and the answer
# stood as a table one hand timed once, which no reader could re-run. `mark` stamps the
# boundary between the numbered steps below into $W/time.txt when SOW_TIME is set, and
# the report at the close prints one `step_<name>_s=` line per step. Off, it costs one
# shell test per step and spawns nothing, so the default run is the run it always was.
SOW_TIME="${SOW_TIME:-}"
# invariant: the mark roster is bounded, so a step added past the ceiling refuses out
# loud rather than printing a report quietly missing its own tail.
SOW_MAX_MARKS=16
MARKS=0
mark() {
  [ -n "$SOW_TIME" ] || return 0
  MARKS=$((MARKS + 1))
  [ "$MARKS" -le "$SOW_MAX_MARKS" ] || { echo "sow: past $SOW_MAX_MARKS step marks" >&2; exit 2; }
  printf '%s\t%s\n' "$1" "$(date +%s%N)" >> "$W/time.txt"
}

# batch_match LIST OUT FLAGS PATTERN -- names every file in LIST whose own bytes
# match PATTERN, one grep process per argument-list chunk rather than one per file.
batch_match() {
  _list=$1; _out=$2; _flags=$3; _pat=$4
  : > "$_out"
  [ -s "$_list" ] || return 0
  set +e
  # shellcheck disable=SC2086 -- _flags is our own literal, split on purpose.
  tr '\n' '\0' < "$_list" | xargs -0 grep $_flags -l -e "$_pat" -- >> "$_out" 2>/dev/null
  _rc=$?
  set -e
  # xargs answers 123 when some grep found nothing in its chunk, which is the
  # ordinary case. Anything else is a broken instrument and refuses out loud,
  # because a silent empty answer here reads exactly like a clean tree.
  case "$_rc" in
    0|1|123) return 0;;
    *) echo "sow: batched match failed (rc=$_rc) on $_list" >&2; exit 2;;
  esac
}

mark candidates
# 1. The candidate list, in the elder's own order and by the elder's own reading.
: > "$W/cand.txt"
for p in $PATHS; do
  is_subex "$p" && continue   # whole-path exclusion (e.g. linengrow)
  for f in $(git ls-files -- "$p"); do
    [ -f "$f" ] || continue
    printf '%s\n' "$f" >> "$W/cand.txt"
  done
done
# `wc -l` rather than `grep -c ''`: an empty candidate list is a lawful zero, and a `grep` that
# exits 1 on it would need a fallback value standing in for an answer.
CAND_N=$(wc -l < "$W/cand.txt" | tr -d ' ')
[ "$CAND_N" -le "$SOW_MAX_CANDIDATES" ] || {
  echo "sow: $CAND_N candidates past the ceiling of $SOW_MAX_CANDIDATES" >&2; exit 2;
}

mark pathrefuse
# 2. The two path-only refusals, in ONE awk pass over the candidate list.
#    File-granular exclusion is a deliberate personal withhold inside a shared dir
#    (a foundations biography essay); the doctrine beside it still ships.
#    The key-material guard refuses anything shaped like a key or a fingerprint
#    roster, whatever its verdict. context/PUBKEYS.md is the canonical committed
#    fingerprint file and lives inside a scrub dir; a name-scrub cannot catch a
#    fingerprint, so this basename guard is what withholds it. PUBKEYS.template.md
#    (placeholders) does NOT match the exact `PUBKEYS.md` glob and ships.
#
#    WHY THE SHELL LOOP LEFT (REDS %642). The elder read both refusals with the
#    shell alone and spawned nothing, so it looked free -- and it was the third
#    most expensive step in the projection, at 8.85 and 9.42 seconds across two
#    timed runs. The cost was `is_subex`, which walks EVERY sub_exclude entry for
#    every candidate: 146 entries against 9,114 candidates is about 1.3 million
#    `case` evaluations, all of them in the shell's own interpreter. So a step
#    that starts no process can still be dear, and the tell is a loop inside a
#    loop rather than a process inside one.
#
#    THE EXCLUSION TEST IS THE SAME READING, WALKED THE OTHER WAY. `is_subex`
#    asks, of each entry, whether the path EQUALS it or lives under it. A path
#    lives under an entry exactly when one of its own slash-bounded ancestors IS
#    that entry, so the awk walks the path up from itself -- ROOM/SUB/PAGE.md,
#    then ROOM/SUB, then ROOM -- against a hash of the entries. The segments are
#    placeholders rather than a real-looking path, since an illustration spelled
#    like a citation IS one to every reader and every meter (stamp-and-name).
#    Same answer, at the
#    path's depth rather than at the roster's length, and the roster may grow
#    without the step growing with it.
#
#    THE ENTRY SET IS READ EXACTLY AS THE ELDER READ IT. `printf '%s\n' $SUBEX`
#    is unquoted on purpose: it word-splits the same way `for x in $SUBEX` did,
#    so the one entry carrying a space still arrives as two fragments. That is
#    REDS %804, which stands OPEN and wants Keaton's eye beside custody gate 1 --
#    repairing it here would change what ships, and this lap moves no withhold.
: > "$W/excluded.txt"; : > "$W/namewithheld.txt"; : > "$W/keep.txt"
# shellcheck disable=SC2086 -- unquoted on purpose; the word split IS the elder reading.
printf '%s\n' $SUBEX > "$W/subex.txt"
awk -v subex="$W/subex.txt" -v ex="$W/excluded.txt" \
    -v nw="$W/namewithheld.txt" -v kp="$W/keep.txt" '
  BEGIN { while ((getline l < subex) > 0) if (l != "") X[l] = 1 }
  {
    # The ancestor walk: the path itself, then each slash-bounded parent.
    p = $0
    while (1) {
      if (p in X) { print > ex; next }
      if (!sub(/\/[^\/]*$/, "", p)) break
    }
    # The greedy sub to the LAST slash is exactly what the shell ${f##*/} takes.
    b = $0; sub(/^.*\//, "", b)
    if (b ~ /siya/ || b ~ /Siya/ || b == "PUBKEYS.md" || b ~ /^keys_/ ||
        b ~ /\.pem$/ || b ~ /\.key$/ || b ~ /\.asc$/ || b ~ /\.gpg$/ ||
        b ~ /\.sec$/ || b ~ /\.secret$/) { print > nw; next }
    print > kp
  }
' "$W/cand.txt"

mark armor
# 3. Armor blocks stay withheld -- a private or PGP blob is not a stub.
batch_match "$W/keep.txt" "$W/armor.txt" "-IE" 'BEGIN (OPENSSH|PGP|RSA|EC) (PRIVATE|PUBLIC) KEY'
mark identity
# 4. A file naming the maintainer is scrubbed; a plain one is copied verbatim.
batch_match "$W/keep.txt" "$W/ident.txt" "-IiE" "$IDENT"

mark verdict
# 5. One verdict per kept candidate, armor winning over identity exactly as the
#    elder's early `continue` did.
awk -v armor="$W/armor.txt" -v ident="$W/ident.txt" '
  BEGIN {
    while ((getline l < armor) > 0) A[l] = 1
    while ((getline l < ident) > 0) I[l] = 1
  }
  { if ($0 in A) print "armor\t" $0; else if ($0 in I) print "scrub\t" $0; else print "copy\t" $0 }
' "$W/keep.txt" > "$W/class.txt"
awk -F'\t' '$1=="copy"  {print $2}' "$W/class.txt" > "$W/copy.txt"
awk -F'\t' '$1=="scrub" {print $2}' "$W/class.txt" > "$W/scrub.txt"

mark makedirs
# 6. Every destination directory in one pass rather than one mkdir per file.
#    awk writes the seed prefix itself rather than piping through `sed`: the only
#    `sed` this script runs is the scrub, so a broken one fails where the scrub is
#    rather than where a directory would have been made.
awk -F'\t' -v seed="$SEED" '$1!="armor" { p=$2; sub(/\/[^\/]*$/, "", p); if (p != $2) print seed "/" p }' \
  "$W/class.txt" | sort -u | tr '\n' '\0' | xargs -0 -r mkdir -p

mark copy
# 7. The plain copies, in ONE pass-through rather than one `cp` process per file.
#    Measured on this field `20260917`: the elder `while read` loop spent
#    `step_copy_s=28.43` of a 49.39-second projection -- 58 percent of a whole
#    publish -- starting 8,633 `cp -a` processes, and one `cpio` pass-through over
#    the same list runs in 1.54s. The cost was starting `cp`, exactly as this
#    step's sibling classification found the cost was starting `grep` (REDS %642).
#    `-p` is pass-through copy, `-d` makes each destination directory, `-u`
#    replaces unconditionally so a file left by an elder projection is overwritten
#    rather than skipped for being newer, and `-m` keeps the source mtime --
#    together the `cp -a` this replaces, proven byte for byte AND stat for stat
#    (mode, size, mtime, file type, symlink target) over 18,672 paths including
#    285 symlinks.
#
#    THE ONE PROPERTY THIS DEPENDS ON, AND WHERE IT IS HELD. `cp -a` recurses a
#    directory; `cpio -p -d` writes the node alone. So the two disagree on exactly
#    one input -- a directory -- and `git ls-files` answers with one for every
#    gitlink. That input never arrives: step 1 above drops it with `[ -f "$f" ] ||
#    continue`, three hundred lines from here, and the copy list therefore holds
#    regular files and symlinks alone. A second test beside this one would be a
#    fence in a field with no gate, so the invariant is PROVEN where it lives --
#    the pen plants a gitlink, watches it reach neither the candidate list nor the
#    seed, and then drops that one filter and watches an empty room ship. A
#    symlink pointing at a directory is not this class: both tools copy the link.
#
#    `cpio` left POSIX with the 2001 edition, so a host without it is answering
#    rather than broken: the elder per-file loop stays as the fallback, and
#    `SOW_COPY_TOOL` names the pass-through so an operator whose `cpio` is absent
#    or untrusted sets it empty and gets the loop. Same shape as the four `SOW_*`
#    inputs above -- the default is the real one, so a bare run is the run it
#    always was. A pass-through that FAILS refuses out loud rather than falling
#    back, since a copy that moved nothing reads exactly like a field with nothing
#    to copy -- the same fault `batch_match` above guards in its own `case`, and
#    a quiet second attempt would hide a host whose copy tool is broken.
if [ ! -s "$W/copy.txt" ]; then
  :
elif [ -n "$COPY_TOOL" ] && command -v "$COPY_TOOL" >/dev/null 2>&1; then
  set +e
  "$COPY_TOOL" -pdum "$SEED" < "$W/copy.txt" 2> "$W/copy.err"
  _rc=$?
  set -e
  if [ "$_rc" -ne 0 ]; then
    echo "sow: the copy pass-through $COPY_TOOL failed (rc=$_rc) over $W/copy.txt" >&2
    sed 's/^/sow:   /' "$W/copy.err" >&2
    exit 2
  fi
else
  while IFS= read -r f; do
    cp -a "$f" "$SEED/$f"
  done < "$W/copy.txt"
fi

mark scrub
# 8. The scrub itself -- the one per-file process this projection genuinely owes,
#    because each `sed` writes its own destination path. It read four percent of
#    the cost while the classification ran per file; measured `20260917` it is
#    `step_scrub_s=17.81` of 49.39, and with the copy above batched it becomes the
#    projection's largest step. Folding it would mean copying unscrubbed bytes
#    into `seed/` and rewriting them in place -- clean by trust rather than by
#    construction -- so it stays as written and the choice is named on the card.
: > "$W/scrubbed_dest.txt"
while IFS= read -r f; do
  sed -f "$SCRUB" "$f" > "$SEED/$f"
  # invariant: a scrubbed copy keeps the mode the tree tracks -- the seed's own
  # commit-msg hook is one of these files, and a dropped exec bit disarms it.
  [ -x "$f" ] && chmod +x "$SEED/$f"
  printf '%s\n' "$SEED/$f" >> "$W/scrubbed_dest.txt"
done < "$W/scrub.txt"

mark rescan
# 9. A scrubbed copy still naming the maintainer is WITHHELD for human judgment,
#    so the seed is clean by construction rather than by trust.
batch_match "$W/scrubbed_dest.txt" "$W/still_dirty.txt" "-IiE" "$IDENT"
: > "$W/scrub_withheld.txt"
while IFS= read -r d; do
  rm -f "$d"
  printf '%s\n' "${d#"$SEED"/}" >> "$W/scrub_withheld.txt"
done < "$W/still_dirty.txt"

mark sshkey
# 10. Public SSH blobs: keep the file, swap the key for a placeholder so a
#     NixOS config can ship in grain-os / grain-ww without authorizedKeys.
awk -F'\t' -v seed="$SEED" '$1!="armor" {print seed "/" $2}' "$W/class.txt" > "$W/dest_all.txt"
: > "$W/dest_live.txt"
while IFS= read -r d; do
  [ -f "$d" ] && printf '%s\n' "$d" >> "$W/dest_live.txt"
done < "$W/dest_all.txt"
batch_match "$W/dest_live.txt" "$W/sshkeyed.txt" "-IE" 'ssh-(ed25519|rsa) AAAA[A-Za-z0-9+/]'
while IFS= read -r d; do
  f=${d#"$SEED"/}
  stub_tmp="$d.sow-stub"
  sh tools/fixtures/s/sow_pubkey_stub.sh < "$d" > "$stub_tmp"
  cat "$stub_tmp" > "$d"
  rm -f "$stub_tmp"
  [ -x "$f" ] && chmod +x "$d"
done < "$W/sshkeyed.txt"

mark logs
# 11. The three logs, written in CANDIDATE order -- the order the elder's own
#     appends produced, rebuilt here from the verdicts rather than as it went,
#     since a post-scrub withhold is only known after its file is written.
awk -v exc="$W/excluded.txt" -v nw="$W/namewithheld.txt" -v arm="$W/armor.txt" \
    -v sw="$W/scrub_withheld.txt" -v scr="$W/scrub.txt" \
    -v fexc="$SEED/.sow-excluded.log" -v fwh="$SEED/.sow-withheld.log" \
    -v fsc="$SEED/.sow-scrubbed.log" '
  BEGIN {
    while ((getline l < exc) > 0) E[l] = 1
    while ((getline l < nw)  > 0) N[l] = 1
    while ((getline l < arm) > 0) A[l] = 1
    while ((getline l < sw)  > 0) D[l] = 1
    while ((getline l < scr) > 0) S[l] = 1
  }
  {
    if      ($0 in E)            print $0 > fexc
    else if ($0 in N || $0 in A) print $0 > fwh
    else if ($0 in D)            print $0 > fwh
    else if ($0 in S)            print $0 > fsc
  }
' "$W/cand.txt"

mark close

# The step report, printed before the work room is swept on EXIT. Each line is the
# wall time between one mark and the next, so the steps sum to the whole projection
# and a reader can see which one owns the minutes.
if [ -n "$SOW_TIME" ]; then
  awk -F'\t' '
    NR == 1 { prev = $2; first = $2; name = $1; next }
    { printf "step_%s_s=%.2f\n", name, ($2 - prev) / 1e9; prev = $2; name = $1; last = $2 }
    END { if (NR > 1) printf "step_total_s=%.2f\n", (last - first) / 1e9 }
  ' "$W/time.txt"
fi

COPIED=$(find "$SEED" -type f ! -name '.sow-withheld.log' ! -name '.sow-scrubbed.log' | wc -l | tr -d ' ')
SCRUBBED=$(grep -c '' "$SEED/.sow-scrubbed.log" 2>/dev/null || echo 0)
WITHHELD=$(grep -c '' "$SEED/.sow-withheld.log" 2>/dev/null || echo 0)
# Write the receipt after copying, and refuse if its coverage inputs moved.
reach_close=$(sow_reach_inputs "$MANIFEST")
[ "$reach_inputs" = "$reach_close" ] || {
  echo "sow: coverage inputs changed during projection" >&2; exit 2;
}
printf '%s\n' "$reach_inputs" > "$SEED/.sow-projection.log"
echo "SOW_OK copied=$COPIED scrubbed=$SCRUBBED withheld=$WITHHELD"
