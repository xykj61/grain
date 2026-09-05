#!/bin/sh
# A page may not name itself as its own elder.
#
# WHY THIS GUARD EXISTS. A molt seats a page at a fresh stamp and leaves the elder as a fossil, so
# the mutant's header carries a provenance line -- "a Gauge reimagining of [elder], which stays
# whole as the fossil". When the fossil is later shed, `tools/d/dated_path_repoint.rish` sweeps the
# living citers of that basename and points each at the mutant. That is right for a CITATION and
# wrong for a PROVENANCE CLAIM: the elder there is the subject of a historical sentence rather than
# a page being pointed at, so the repoint makes the page its own ancestor. It happened twice on
# `20260826` (`0877e2b5a`), to `foundations/20260823-204456_single-stranded.md` and
# `foundations/20260824-003828_every-climate-has-a-fiber.md`, and the elders were shed hours later.
#
# NOTHING STANDING COULD SEE IT, because a self-link RESOLVES. `tracked_link_scan.sh` and the
# broken-link duty of `tools/l/living_docs_lint.rish` both test a target with `[ -e ]`, which the
# file itself satisfies. `tools/fixtures/q/qa_report_card.sh` scores Truth by counting cited paths
# that fail to resolve, so single-stranded read `truth=100` and `A+/98` while its own first
# sentence was false. The lost-reference census went further and counted the falsification as a
# REPAIR, since a broken link had become a working one. Three instruments, one blind spot: they
# each ask whether the target exists, and none asks whether it is the page the sentence meant.
#
# WHAT IS READ, and what is deliberately left alone. A self-link is ordinary and useful in a
# sibling roster -- a Kin line listing four voices names the page you are standing on. Measured
# `20260905` over 5,455 tracked documents: 35 carry a self-link, and only the two above sit on a
# provenance line. So the reading is bounded to THIS TREE'S OWN provenance vocabulary, named below
# rather than guessed at, and the seven honest sibling rosters read zero.
#
# Testimony is reported, never gated: a session log or a dated shelf keeps every word it wrote
# (accrete-never-break), so a self-reference there is a fact about that day rather than a fault.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd) || exit 1
cd "$here" || exit 1

# THE INSTRUMENT IS PROVEN PRESENT BEFORE IT IS TRUSTED (REDS %413). A scan whose instrument fails
# prints an empty answer that is byte-identical to a clean collection.
git rev-parse --git-dir >/dev/null 2>&1 || {
  echo "provenance_self_reference: REFUSED -- not a git checkout at $here" >&2; exit 2; }

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

# ONE AWK PASS over every tracked document rather than a fork per line.
git ls-files -z '*.md' 2>/dev/null | xargs -0 awk '
FNR==1 {
  n=split(FILENAME,p,"/"); base=p[n]
  # A closed stack is testimony: every date/, archive/, yonder/ shelf, and every session log.
  living=1
  if (FILENAME ~ /(^|\/)(date|archive|yonder)\//) living=0
  if (FILENAME ~ /^session-logs\//) living=0
}
{
  if (index($0, "](" base ")") == 0 && index($0, "](./" base ")") == 0) next
  l=tolower($0)
  # This tree own provenance vocabulary, bounded and named -- the Class M molt shape writes it.
  if (l ~ /reimagining of/ || l ~ /molt of/ || l ~ /molted from/ || l ~ /as the fossil/ || l ~ /the elder/) {
    print (living ? "living" : "testimony") " " FILENAME " " FNR
  }
}' > "$work/hits" 2>/dev/null || {
  echo "provenance_self_reference: REFUSED -- the document pass would not run" >&2; exit 2; }

scanned=$(git ls-files '*.md' | wc -l | tr -d ' ')
[ "$scanned" -gt 0 ] || {
  echo "provenance_self_reference: REFUSED -- zero tracked documents read" >&2; exit 2; }

living=$(grep -c '^living ' "$work/hits" 2>/dev/null || true)
testimony=$(grep -c '^testimony ' "$work/hits" 2>/dev/null || true)
[ -n "$living" ] || living=0
[ -n "$testimony" ] || testimony=0

grep '^living ' "$work/hits" 2>/dev/null | while read -r _lane f line; do
  echo "self-provenance: $f:$line -- this page is named as its own elder"
done
grep '^testimony ' "$work/hits" 2>/dev/null | while read -r _lane f line; do
  echo "testimony: $f:$line -- reported, never gated (accrete-never-break)"
done

echo "documents_scanned=$scanned"
echo "living_self_provenance=$living"
echo "testimony_self_provenance=$testimony"
if [ "$living" -eq 0 ]; then
  echo "verdict=no_page_is_its_own_elder"
else
  echo "verdict=self_provenance"
fi
