#!/bin/sh
# unshared_citation_scan.sh -- a row's number is a view, so a lap cites its own row by STAMP until
# the anointed spine has bound that number.
#
# WHY. `.claude/rules/derived-spine.md` rule 4 says it plainly: *cite by stamp until the row is
# shared*, because the `%N` beside a row is allocated by the anointed remote and a lap that loses
# the race gets a different one. The rule is right and the practice is not. Measured `20260906`
# across that day's session logs: **not one** cited a new row by its stamp; every one cited a
# number that did not yet exist upstream. The bill is 28 recorded errata, six rows renumbered more
# than once, one row renumbered FOUR times -- and each renumber is a citation sweep across the tree,
# one of which "ran as a blind `sed` that rewrote a peer's row and two upstream passages."
#
# The renumbering itself is lawful and free: the STAMP never moved in any of the 28. What costs is
# every OTHER file that spelled the number. A `%N` is cited in 20 to 36 files within a day of being
# written, so citing an unshared number is choosing a sweep the stamp would have avoided.
#
#   sh tools/fixtures/u/unshared_citation_scan.sh          # counts
#   sh tools/fixtures/u/unshared_citation_scan.sh list     # one line per unshared citation
#
# THE READING. Take `shared_max` from `reds_spine_derive_scan.sh` -- the highest number the anointed
# spine has bound. Any `%N` above it, cited anywhere in the working tree, names a row the spine has
# not allocated: a number this lap chose and may not keep.
#
# WHAT IS NOT COUNTED, and why each is excluded rather than waived:
#   - `construction/REDS.md` itself, and its fold archives. The ledger is where a number is
#     ASSIGNED; a row header naming its own number is the allocation, never a citation of one.
#   - dated testimony under `date/`, `archive/`, `yonder/`, and any file whose own basename carries
#     a one-clock stamp. A log records what the number was when it was written (accrete-never-break).
#   - anything the spine cannot reach: with no `xy` remote the reading refuses rather than passing.
#
# WHICH LEAVES exactly the living surfaces a renumber would have to sweep -- the operator card,
# the rules, the guards, the design rooms -- and holds them at zero.
#
# BOUNDS: one spine read; `git grep` over tracked files; at most 200 reported citations.
set -eu

root=${UNSHARED_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_REPORT=200

spine=tools/fixtures/r/reds_spine_derive_scan.sh
[ -x "$spine" ] || [ -f "$spine" ] || { echo "refused: no spine scan at $spine"; exit 2; }

shared=$(sh "$spine" 2>/dev/null | grep '^shared_max=' | cut -d= -f2)
case "${shared:-}" in
  ''|*[!0-9]*)
    # A READING THE SPINE CANNOT ANSWER IS A REFUSAL, NEVER A ZERO (REDS %170). With no anointed
    # remote reachable, every number looks unshared and every number looks shared depending on the
    # default chosen -- so no default is chosen.
    echo "refused: the anointed spine did not answer shared_max -- nothing can be called unshared" >&2
    exit 2 ;;
esac

work=$(mktemp -d "${TMPDIR:-/tmp}/unshared-cite.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# Living surfaces only: the ledger assigns, testimony records, and neither cites.
# THE FULL RUN OF DIGITS, or a hex literal reads as a row number. `%[0-9]{3,4}` matched a PREFIX
# of `%200000` in two image modules -- a colour, not a row -- so the pattern takes every digit
# and the length test happens after. A number is a row number when the whole run is 3 or 4 long.
git grep -noE '%[0-9]+' -- . 2>/dev/null \
  | grep -vE '^construction/REDS\.md:' \
  | grep -vE '^construction/archive/' \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  > "$work/cites.txt" || true

: > "$work/unshared.txt"
while IFS= read -r line; do
  n=$(printf '%s' "$line" | sed 's/.*%//')
  case "$n" in ''|*[!0-9]*) continue ;; esac
  # a run of 5+ digits is a colour, a byte count, or a stamp fragment -- never a ledger row
  case "${#n}" in 3|4) ;; *) continue ;; esac
  [ "$n" -gt "$shared" ] 2>/dev/null || continue
  printf '%s\n' "$line" >> "$work/unshared.txt"
done < "$work/cites.txt"

unshared=$(wc -l < "$work/unshared.txt" | tr -d ' ')
files=$(cut -d: -f1 "$work/unshared.txt" | sort -u | wc -l | tr -d ' ')

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/unshared.txt" | while IFS= read -r l; do
    printf 'unshared: %s -- the spine has bound only up to %%%s\n' "$l" "$shared"
  done
fi

echo "shared_max=$shared"
echo "unshared_citations=$unshared"
echo "files_affected=$files"
