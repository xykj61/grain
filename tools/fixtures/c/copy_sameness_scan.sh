#!/bin/sh
# tools/fixtures/c/copy_sameness_scan.sh -- every tally_copy.rye against the canon.
# Orchestrated by tools/gen/chapter/copy_sameness_witness.rish.
#
# Why this exists: the toolchain refuses cross-directory relative imports, so
# each module home needs tally_copy.rye reachable locally. The tree already
# solved this with SYMLINKS to the one canonical tally/copy.rye -- sameness as
# the macro, kept by the filesystem itself. Measured 20260729.204722: fourteen
# symlinks and ONE real file (mand/tally_copy.rye), which is the only path that
# can silently drift from the canon. This guard makes that drift loud, and
# reports the symlink/real split so the asymmetry stays visible.
#
# THAT ONE REAL FILE IS GONE, and the reading has moved: 20260908.075300 reads 23 paths, 23
# symlinks, 0 real files, 0 drift. The elder figure above stays as the testimony of the lap that
# measured it -- run the scan for the current one rather than reading either number here.
#
# AND THE NAME IN THE `find` BELOW IS THIS GUARD'S WHOLE POPULATION, which is narrower than the
# reason above. The header argues a CLASS -- each module home needs a shared mark reachable
# locally, and the tree keeps those same by symlink -- while the source line names ONE basename.
# `tools/fixtures/c/copy_lag_scan.sh` (seated 20260906.070240) carries that same rule to every
# basename held both ways, deriving each canon by resolving its own symlinks rather than spelling
# one. It found the last real-file copy this guard could never see: caravan/parse_int.rye, linked
# to ../tally/parse_int.rye on 20260908 and its ratchet now a wall at zero. This guard keeps its
# narrow seat, because a canon spelled in one line is the cheapest possible reading of the file
# every module home links, and cheap readings are what a per-lap tier can afford.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu
canon="tally/copy.rye"
# Optional second argument names one extra path to compare, used only by the
# negative fixture so the drift refusal is observed on every run rather than
# planted by hand. Ordinary runs pass nothing and scan the tree alone.
extra="${2:-}"
[ -f "$canon" ] || { echo "verdict=missing_canon"; exit 2; }
want=$(md5sum "$canon" | cut -d' ' -f1)
# A PATH GIT IGNORES IS A LAP'S OWN SCRATCH, NEVER TREE EVIDENCE. This walk asks the filesystem
# rather than the index, so anything standing under the root is read -- including the gitignored
# rooms this tree's own laws tell a lap to work in: `.lap/` for a lap's scratch, `session-output/`
# for a transcript, `loops/` for a launcher's state, and a `git worktree` parked under any of them.
# Proven on metal `20260911.211500`: copying `mantra/` into `.lap/probe/` took this scan from
# `verdict=ok` to `verdict=drift` and named `./.lap/probe/mantra/tally_copy.rye`. The reading was
# true about the bytes and false about the tree, which is the direction a guard must never be wrong
# in -- it reddens a rostered pass on every ship for a file no clone will ever hold.
#
# `git check-ignore` is asked rather than a path list being spelled here, because the elder line
# spelled one -- `-not -path './vendor/*'` -- and a spelled list is a claim about the names somebody
# remembered. The ignore rules already say which paths this tree disowns, in one place, kept current
# by the hand that adds a room. A pen with no git in it skips the filter and says so, since a silent
# fallback is the same fault this repair is closing.
ignored_filtered=0
if git rev-parse --git-dir >/dev/null 2>&1; then ignored_filtered=1; fi
keep() {
  [ "$ignored_filtered" -eq 1 ] || return 0
  git check-ignore -q "$1" 2>/dev/null && return 1
  return 0
}

n=0
drift=0
links=0
reals=0
for f in $(find . -name 'tally_copy.rye' -not -path './vendor/*' | sort); do
  keep "$f" || continue
  n=$((n + 1))
  if [ -L "$f" ]; then links=$((links + 1)); else reals=$((reals + 1)); fi
  got=$(md5sum "$f" | cut -d' ' -f1)
  if [ "$got" != "$want" ]; then
    echo "detail: drifted $f"
    drift=$((drift + 1))
  fi
done
if [ -n "$extra" ]; then
  n=$((n + 1))
  got=$(md5sum "$extra" | cut -d' ' -f1)
  if [ "$got" != "$want" ]; then echo "detail: drifted $extra"; drift=$((drift + 1)); fi
fi
echo "ignored_filtered=$ignored_filtered"
echo "paths=$n"
echo "symlinks=$links"
echo "real_files=$reals"
echo "drift=$drift"
if [ "$drift" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=drift"; exit 1; fi
