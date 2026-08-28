#!/bin/sh
# tools/fixtures/custody_gate_instruction_scan.sh -- an instruction file may name a custody-gated
# command only inside a clause that refuses it.
#
# WHY. construction/ITINERARY.md holds seven custody gates, and three of them name a COMMAND: the
# seed publisher, a force push, and a history rewrite. On 20260828 REDS %307 found
# recursion-prompts/seed/autonomous-loop.seed.md telling an unattended lap to run
# `bash ~/grain/publish-seed.sh` every fifth round -- a cadence the card cut on 20260826 and a gate
# Keaton holds by hand. That file was repaired by hand, and the SAME sentence stood on in
# tools/l/launch-claude-chapter.rish lines 66 and 86, which is the file a hand actually pastes to
# start a loop. One root, two files, and the repair reached one of them. A lantern that fires twice
# becomes a loom; this is the loom.
#
# WHAT IS GATED, hard, at zero. A gated command token standing in a clause that carries no refusal
# word, inside a file whose text becomes an agent's standing instructions.
#
# THE THREE TOKENS, read off the card's own gate list:
#   publish-seed.sh                       gate %1 -- the seed force-push
#   git push --force|-f|--force-with-lease  gate %1 and %5
#   git filter-repo|filter-branch          gate %5 -- history rewrite
#
# WHAT PASSES FREE. The same token inside a refusal clause -- `never run publish-seed.sh`, `custody
# gate %1 holds every refresh at Keatons own hand`. Prose ABOUT force-pushing that names no command
# is free too, since a token is a command and an English phrase is not.
#
# WHAT THIS DOES NOT REACH, said plainly rather than left to be discovered. Four of the seven gates
# name an ACT rather than a command -- provisioning, moving funds, generating a real Kumara, seating
# a module in a collaborator's domain -- and no grep finds those. And the check is CLAUSE PROXIMITY
# rather than comprehension: it reads whether a refusal word stands beside the token, not whether
# the sentence means it. Word presence is the check; a reader is the standard.
#
# WHY THIS ROOM AND NOT EVERY ROOM. The roster is the loop-prompt surface -- `recursion-prompts/`
# and `tools/l/launch-*`, whose text becomes a running agent's standing orders. Law files in
# `.claude/rules/` name these same commands in order to govern them, and
# `.claude/rules/git-signing.md` correctly carries `git push --force origin main` in a block that
# documents the publisher. A guard that reddened on that would be a guard someone turns off.
#
# USAGE
#   sh tools/fixtures/custody_gate_instruction_scan.sh                # the real loop-prompt surface
#   sh tools/fixtures/custody_gate_instruction_scan.sh report <file>  # one planted file, for the pen
#
# Driven by tools/cu/custody_gate_instruction_witness.rish. Run from the repository root.

set -u

mode=${1:-tree}
src=${2:-}

if [ ! -f construction/ITINERARY.md ]; then
  echo "verdict=not_at_root"
  echo "refused: construction/ITINERARY.md is missing, so this is not the tree this scan reads" >&2
  exit 1
fi

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

# THE READING, in one awk program so the clause rule lives in exactly one place. A clause ends at
# `; ` or `. ` -- the two separators this tree's own prompts are built from, since a seat prompt is
# one long semicolon-delimited line rather than many.
cat > "$work/read.awk" <<'AWK'
{
  n = split($0, part, /; |\. /)
  for (i = 1; i <= n; i++) {
    c = part[i]
    if (c !~ /publish-seed\.sh/ && c !~ /git +push +(--force|-f|--force-with-lease)/ && c !~ /git +filter-(repo|branch)/) continue
    token = (c ~ /publish-seed\.sh/) ? "publish-seed.sh" : ((c ~ /git +filter-/) ? "git filter-repo" : "git push --force")
    lc = tolower(c)
    refused = (lc ~ /never/ || lc ~ /refus/ || lc ~ /not yours/ || lc ~ /custody/ || lc ~ /keaton/ || lc ~ /manual gate/ || lc ~ /crossing a gate/ || lc ~ /stop/ || lc ~ /his hand/ || lc ~ /gate %/)
    printf "%s\t%s\t%d\t%s\t%s\n", (refused ? "free" : "bare"), FILENAME, FNR, token, substr(c, 1, 120)
  }
}
AWK

if [ "$mode" = report ]; then
  if [ -z "$src" ] || [ ! -f "$src" ]; then
    echo "verdict=no_such_file"
    echo "refused: ${src:-<none>} is the instruction file this scan reads, and it is absent" >&2
    exit 1
  fi
  set -- "$src"
else
  # DISCOVERED RATHER THAN NAMED. A roster typed by hand grows when somebody remembers, and this
  # file exists because nobody did (REDS %277's lesson, borrowed). Every tracked prompt template and
  # every launcher is read; the launchers are read as SOURCE, never run, so reading cannot start an
  # agent.
  set -- $(git ls-files 'recursion-prompts/*.md' 'tools/l/launch-*' 2>/dev/null)
  if [ "$#" -eq 0 ] || [ ! -f "$1" ]; then
    echo "verdict=no_instruction_files"
    echo "refused: neither recursion-prompts/ nor tools/l/launch-* was found, and those are the surface this scan reads" >&2
    exit 3
  fi
fi

files=0
: > "$work/hits.txt"
for f in "$@"; do
  [ -f "$f" ] || continue
  files=$((files + 1))
  awk -f "$work/read.awk" "$f" >> "$work/hits.txt"
done

mentions=$(wc -l < "$work/hits.txt" | tr -d ' ')
bare=$(grep -c '^bare	' "$work/hits.txt" 2>/dev/null || true)
[ -n "$bare" ] || bare=0
free=$((mentions - bare))

while IFS='	' read -r verdict file line token clause; do
  [ "$verdict" = bare ] || continue
  echo "detail: $file line $line instructs $token with no refusal in its clause -- $clause"
done < "$work/hits.txt"

echo "instruction_files=$files"
echo "gated_mentions=$mentions"
echo "refusal_framed=$free"
echo "bare_instructions=$bare"

if [ "$files" -eq 0 ]; then
  echo "verdict=no_instruction_files"
  echo "refused: no instruction file was read, so this run measured nothing" >&2
  exit 3
fi

if [ "$bare" -ne 0 ]; then
  echo "verdict=bare_gate_instruction"
  exit 4
fi

echo "verdict=every_gated_command_is_refused"
exit 0
