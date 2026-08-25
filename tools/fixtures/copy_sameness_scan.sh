#!/bin/sh
# tools/fixtures/copy_sameness_scan.sh -- every tally_copy.rye against the canon.
# Orchestrated by tools/gen/season/copy_sameness_witness.rish.
#
# Why this exists: the toolchain refuses cross-directory relative imports, so
# each module home needs tally_copy.rye reachable locally. The tree already
# solved this with SYMLINKS to the one canonical tally/copy.rye -- sameness as
# the macro, kept by the filesystem itself. Measured 20260729.204722: fourteen
# symlinks and ONE real file (mand/tally_copy.rye), which is the only path that
# can silently drift from the canon. This guard makes that drift loud, and
# reports the symlink/real split so the asymmetry stays visible.
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
n=0
drift=0
links=0
reals=0
for f in $(find . -name 'tally_copy.rye' -not -path './vendor/*' | sort); do
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
echo "paths=$n"
echo "symlinks=$links"
echo "real_files=$reals"
echo "drift=$drift"
if [ "$drift" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=drift"; exit 1; fi
