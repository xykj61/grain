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
# 55.79 seconds (active-designing/20260916-121517_where-a-seed-publish-spends-its-minutes.md).
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

# 2. The two path-only refusals, decided by the shell alone -- no basename process.
#    File-granular exclusion is a deliberate personal withhold inside a shared dir
#    (a foundations biography essay); the doctrine beside it still ships.
#    The key-material guard refuses anything shaped like a key or a fingerprint
#    roster, whatever its verdict. context/PUBKEYS.md is the canonical committed
#    fingerprint file and lives inside a scrub dir; a name-scrub cannot catch a
#    fingerprint, so this basename guard is what withholds it. PUBKEYS.template.md
#    (placeholders) does NOT match the exact `PUBKEYS.md` glob and ships.
: > "$W/excluded.txt"; : > "$W/namewithheld.txt"; : > "$W/keep.txt"
while IFS= read -r f; do
  if is_subex "$f"; then printf '%s\n' "$f" >> "$W/excluded.txt"; continue; fi
  case "${f##*/}" in
    *siya*|*Siya*|PUBKEYS.md|keys_*|*.pem|*.key|*.asc|*.gpg|*.sec|*.secret)
      printf '%s\n' "$f" >> "$W/namewithheld.txt"; continue;;
  esac
  printf '%s\n' "$f" >> "$W/keep.txt"
done < "$W/cand.txt"

# 3. Armor blocks stay withheld -- a private or PGP blob is not a stub.
batch_match "$W/keep.txt" "$W/armor.txt" "-IE" 'BEGIN (OPENSSH|PGP|RSA|EC) (PRIVATE|PUBLIC) KEY'
# 4. A file naming the maintainer is scrubbed; a plain one is copied verbatim.
batch_match "$W/keep.txt" "$W/ident.txt" "-IiE" "$IDENT"

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

# 6. Every destination directory in one pass rather than one mkdir per file.
#    awk writes the seed prefix itself rather than piping through `sed`: the only
#    `sed` this script runs is the scrub, so a broken one fails where the scrub is
#    rather than where a directory would have been made.
awk -F'\t' -v seed="$SEED" '$1!="armor" { p=$2; sub(/\/[^\/]*$/, "", p); if (p != $2) print seed "/" p }' \
  "$W/class.txt" | sort -u | tr '\n' '\0' | xargs -0 -r mkdir -p

# 7. The plain copies.
while IFS= read -r f; do
  cp -a "$f" "$SEED/$f"
done < "$W/copy.txt"

# 8. The scrub itself -- the one per-file process this projection genuinely owes,
#    and four percent of its cost.
: > "$W/scrubbed_dest.txt"
while IFS= read -r f; do
  sed -f "$SCRUB" "$f" > "$SEED/$f"
  # invariant: a scrubbed copy keeps the mode the tree tracks -- the seed's own
  # commit-msg hook is one of these files, and a dropped exec bit disarms it.
  [ -x "$f" ] && chmod +x "$SEED/$f"
  printf '%s\n' "$SEED/$f" >> "$W/scrubbed_dest.txt"
done < "$W/scrub.txt"

# 9. A scrubbed copy still naming the maintainer is WITHHELD for human judgment,
#    so the seed is clean by construction rather than by trust.
batch_match "$W/scrubbed_dest.txt" "$W/still_dirty.txt" "-IiE" "$IDENT"
: > "$W/scrub_withheld.txt"
while IFS= read -r d; do
  rm -f "$d"
  printf '%s\n' "${d#"$SEED"/}" >> "$W/scrub_withheld.txt"
done < "$W/still_dirty.txt"

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
