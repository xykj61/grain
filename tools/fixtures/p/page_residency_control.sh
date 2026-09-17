#!/bin/sh
# tools/fixtures/p/page_residency_control.sh -- prove the residency sampler from both sides.
#
#   sh tools/fixtures/p/page_residency_control.sh
#
# WHAT IT PROVES, and why it runs on metal rather than against a stub. The sampler's whole job is
# to tell a path that STAYS in the page cache from one that FALLS out of it, so both sides are
# shown with real pages: a pen file is read to warm it, sampled, then dropped through
# `page-evict evict` -- which calls `posix_fadvise(POSIX_FADV_DONTNEED)` -- and sampled again. A
# stub census could only prove the arithmetic; this proves the reading.
#
# THE PEN LIVES INSIDE THIS TREE ON PURPOSE. `page-evict` refuses any path outside its own root,
# by reading `/proc/self/fd/<n>` after the open rather than trusting the spelling, so a pen under
# `/tmp` could never be evicted and the falling side could never be shown. `.lap/` is gitignored
# and per-ship, which is where a lap's scratch belongs.
#
# ONE KERNEL PROPERTY THIS CONTROL DEPENDS ON, named rather than assumed: a dirty page is not
# droppable, so the pen file is written and then `sync`ed before any eviction is asked for.
#
# MUTATIONS. Four planted breaks must each be caught: the percent arithmetic inverted, the
# threshold comparison flipped, the stderr merge removed (the census speaks through
# `std.debug.print`, so reading stdout alone returns a blank), and the zero-page guard removed.
set -eu

# The portable helper is sourced from the tree root, found by walking up to the first ancestor
# holding rishi/bin and tools/fixtures -- git-free so pen copies outside a repository still
# resolve -- bounded at 8 steps, loud past the bound. It supplies `sed_inplace`, because GNU
# `sed -i` takes no argument and BSD `sed -i` requires a backup suffix, and the two spellings
# have no overlap.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

ROOT=$_fd_root
cd "$ROOT"

SCAN=tools/fixtures/p/page_residency_sample.sh
CENSUS=tools/bin/page-evict
PEN=.lap/page-residency-pen
legs=0
fails=0

leg() {
  name=$1; want=$2; got=$3
  legs=$(( legs + 1 ))
  if [ "$want" = "$got" ]; then
    echo "leg $name ok"
  else
    echo "leg $name FAILED want=$want got=$got"
    fails=$(( fails + 1 ))
  fi
}

verdict_of() { printf '%s\n' "$1" | sed -n 's/^verdict=//p' | tail -1; }
field_of() { printf '%s\n' "$1" | tr ' ' '\n' | sed -n "s/^$2=//p" | tail -1; }

[ -x "$CENSUS" ] || { echo "detail: $CENSUS unbuilt -- this control needs it"; echo "control_verdict=no_census"; exit 2; }

rm -rf "$PEN"; mkdir -p "$PEN"
# One mebibyte of incompressible bytes: large enough to hold 256 pages, small enough that warming
# and dropping it costs a peer nothing.
dd if=/dev/urandom of="$PEN/warm.bin" bs=4096 count=256 2>/dev/null
# THE `sync` IS LOAD-BEARING AND WAS LEARNED BY LOSING A LEG. `POSIX_FADV_DONTNEED` drops clean
# pages and leaves DIRTY ones where they are, so a pen file written and immediately evicted stays
# fully resident and the falling side cannot be shown at all. The first run of this control read
# `resident_pages=256` after a successful evict call, which is the kernel keeping its promise
# rather than the tool failing: `posix_fadvise` answers success whether or not a page left.
sync
: > "$PEN/empty.bin"

# --- refusals, each planted and then lifted ------------------------------------------------
out=$(sh "$SCAN" 2>&1 || true);                          leg refuses_no_path      no_path    "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/warm.bin" --bogus 2>&1 || true);  leg refuses_bad_flag     bad_flag   "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/warm.bin" --samples 0 2>&1||true);leg refuses_samples_low  bad_bound  "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/warm.bin" --samples 97 2>&1||true);leg refuses_samples_high bad_bound  "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/warm.bin" --samples two 2>&1||true);leg refuses_samples_word bad_bound "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/warm.bin" --interval 3601 2>&1||true);leg refuses_interval_high bad_bound "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/no-such-file" 2>&1 || true);      leg refuses_absent_path  no_path    "$(verdict_of "$out")"
out=$(PAGE_EVICT_BIN=tools/bin/no-such-census sh "$SCAN" "$PEN/warm.bin" 2>&1 || true)
leg refuses_missing_census no_census "$(verdict_of "$out")"
out=$(sh "$SCAN" "$PEN/empty.bin" --samples 1 --interval 0 2>&1 || true)
leg refuses_zero_pages   empty_path "$(verdict_of "$out")"

# --- the welcome, asserted as hard as every refusal ------------------------------------------
cat "$PEN/warm.bin" > /dev/null
warm=$(sh "$SCAN" "$PEN/warm.bin" --samples 2 --interval 0 2>&1 || true)
leg warm_file_stays        stays_resident "$(verdict_of "$warm")"
leg warm_reads_full        100            "$(field_of "$warm" min_pct)"
leg warm_counts_its_pages  256            "$(printf '%s\n' "$warm" | sed -n '2p' | tr ' ' '\n' | sed -n 's/^pages=//p')"
leg warm_takes_both        2              "$(field_of "$warm" samples_taken)"

# --- the falling side, on real metal -----------------------------------------------------------
"$CENSUS" evict "$PEN/warm.bin" >/dev/null 2>&1 || true
cold=$(sh "$SCAN" "$PEN/warm.bin" --samples 1 --interval 0 2>&1 || true)
leg evicted_file_falls     falls_cold     "$(verdict_of "$cold")"
cold_pct=$(field_of "$cold" min_pct)
if [ "${cold_pct:-100}" -lt 90 ]; then leg evicted_reads_below_bar yes yes; else leg evicted_reads_below_bar yes "no($cold_pct)"; fi

# --- mutations, each asserted to bite ---------------------------------------------------------
mut() {
  name=$1; sedexpr=$2; want=$3
  cp "$SCAN" "$PEN/mutant.sh"
  sed_inplace "$sedexpr" "$PEN/mutant.sh"
  cmp -s "$SCAN" "$PEN/mutant.sh" && { leg "$name" bitten "unplanted(no_change)"; return; }
  cat "$PEN/warm.bin" > /dev/null
  got=$(sh "$PEN/mutant.sh" "$PEN/warm.bin" --samples 1 --interval 0 2>&1 || true)
  gv=$(verdict_of "$got")
  if [ "$gv" = "$want" ]; then leg "$name" bitten "unbitten($gv)"; else leg "$name" bitten bitten; fi
}
# Inverting the percent makes a fully resident file read as empty.
mut mutation_percent    's|pct=$(( res \* 100 / pages ))|pct=$(( 100 - res * 100 / pages ))|' stays_resident
# Flipping the threshold calls a warm file cold.
mut mutation_threshold  's|if \[ "$min_pct" -ge 90 \]|if [ "$min_pct" -le 90 ]|'              stays_resident
# Dropping the stderr merge returns a blank line and every field parse fails.
mut mutation_stream     's|census "$TARGET" 2>&1|census "$TARGET" 2>/dev/null|'               stays_resident
# Removing the zero-page guard lets an empty path divide by zero instead of refusing.
cp "$SCAN" "$PEN/mutant.sh"
sed_inplace 's|\[ "$pages" -gt 0 \] |[ "$pages" -ge 0 ] |' "$PEN/mutant.sh"
if cmp -s "$SCAN" "$PEN/mutant.sh"; then leg mutation_zero_guard bitten "unplanted(no_change)"; else
  got=$(sh "$PEN/mutant.sh" "$PEN/empty.bin" --samples 1 --interval 0 2>&1 || true)
  if [ "$(verdict_of "$got")" = empty_path ]; then leg mutation_zero_guard bitten "unbitten(empty_path)"; else leg mutation_zero_guard bitten bitten; fi
fi

rm -rf "$PEN"
echo "legs=$legs control_failed=$fails"
[ "$fails" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=failed"
