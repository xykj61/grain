#!/bin/sh
# tools/fixtures/empty_document_scan.sh -- a tracked document says something, or it is not a document.
#
# WHY. An empty file passes every guard this tree owns, by construction. A link guard is satisfied
# because the path exists. A prose guard reads nothing and finds nothing wrong. A banner guard
# finds no banner to disagree with. **Vacuous truth is the shape of the whole class**: a check
# phrased as "nothing in this file is wrong" is answered perfectly by a file with nothing in it.
#
# Found on 20260823 by an audit for classes no rostered guard reads (REDS %161). Two tracked files
# stood at zero bytes -- a session log INDEXED in session-logs/README.md, so the index promised a
# reasoning record that did not exist, and a recursion prompt cited by name in two later prompts.
# Both were born empty in commit 758d64e639 and stood so for twenty-three days with every guard
# green. Neither was corrupted; both are now filled with an honest pointer to where the record
# actually lives, which is accretion rather than a rewrite, since there was nothing to preserve.
#
# WHAT IS GATED, hard. No tracked document is empty. A document is a tracked regular file whose
# extension carries prose or a record -- `.md`, `.bron`, `.kyri`, `.txt` -- and empty means zero
# bytes or nothing but whitespace, because a file holding one newline says exactly as much as a
# file holding none.
#
# WHAT PASSES FREE, by named rule.
#   `tools/fixtures/**` and `context/fixtures/**` -- instrument, never field. A control that plants
#   an empty file to prove a refusal is doing its job, and a meter that reddened on its own proof
#   is the lesson REDS %157 and %158 already paid for twice. Written as a rule rather than
#   remembered, because a lantern that fires twice becomes a loom.
#   `.gitkeep` and `.keep` -- a placeholder whose entire purpose is to be empty, by convention
#   older than this tree.
#   Every extension not named above. A zero-byte `.svg` or `.tsv` is a different question with a
#   different owner, and one duty per guard is why two can never disagree.
#
# WHAT IS NOT PROVEN. That a document says anything USEFUL -- only that it says something. A file
# holding one honest sentence passes here, and rightly: the fix for a thin document is a reader,
# not a byte count.
#
# USAGE
#   sh tools/fixtures/empty_document_scan.sh
#
# Driven by tools/empty_document_witness.rish. Run from the repository root.

set -u

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The index is the authority, not the filesystem -- a fresh clone reads the index.
# `git ls-files -s` prints: mode SP sha SP stage TAB path
git ls-files -s > "$work/index.tsv"

# Candidates, filtered in one awk so no shell-regex escaping stands between the rule and the
# reading. Exemptions are named here and nowhere else.
awk -F'\t' '
  {
    split($1, meta, " ")
    mode = meta[1]; sha = meta[2]
    if (mode != "100644" && mode != "100755") next
    path = $2
    if (path !~ /\.(md|bron|kyri|txt)$/) next
    if (path ~ /^tools\/fixtures\//) next          # instrument, never field
    if (path ~ /^context\/fixtures\//) next        # instrument, never field
    if (path ~ /(^|\/)\.gitkeep$/) next            # a placeholder meant to be empty
    if (path ~ /(^|\/)\.keep$/) next
    print sha "\t" path
  }' "$work/index.tsv" > "$work/candidates.tsv"

docs=$(wc -l < "$work/candidates.tsv" | tr -d ' ')

# Sizes for every candidate in ONE `git cat-file --batch-check`, rather than one process per file:
# the first shape spawned 8,486 of them and took 33 seconds, and a guard nobody waits for is a
# guard nobody runs. Only files small enough to be whitespace-only are then read.
cut -f1 "$work/candidates.tsv" | git cat-file --batch-check='%(objectname) %(objectsize)' 2>/dev/null \
  | awk '$2 + 0 <= 64 { print $1 }' | sort -u > "$work/small.txt"

: > "$work/empty.txt"
if [ -s "$work/small.txt" ]; then
  awk -F'\t' 'NR == FNR { small[$0] = 1; next } ($1 in small) { print $1 "\t" $2 }' \
      "$work/small.txt" "$work/candidates.tsv" > "$work/tocheck.tsv"
  while IFS="$(printf '\t')" read -r sha path; do
    if [ -z "$(git cat-file blob "$sha" 2>/dev/null | tr -d ' \t\n\r')" ]; then
      printf '%s\n' "$path" >> "$work/empty.txt"
    fi
  done < "$work/tocheck.tsv"
fi
empty=$(wc -l < "$work/empty.txt" | tr -d ' ')

echo "tracked_documents=$docs"
echo "empty_documents=$empty"

[ "$empty" -eq 0 ] || sed 's/^/empty: /' "$work/empty.txt"

if [ "$empty" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=empty_document"
echo "refused: a tracked document above holds nothing -- fill it or remove it" >&2
exit 1
