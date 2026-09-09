#!/bin/sh
# convergence_census.sh -- how much of what this tree WRITES is proven to converge.
#
# WHY. `foundations/20260823-222019_what-brix-infuse-is.md` states the tree's own claim about change:
#
#     declaration + world  ->  infusion  ->  world'
#     infusion(world')     ->  world'          idempotent
#
# The second line is the whole promise: running a change twice does what running it once did. A tool
# that fails it corrupts on the second run, and the second run is exactly what an unattended loop
# does at three in the morning.
#
# Measured `20260908.005904` after the control exclusion: **4 tools transform a document handed to
# them**, and one of the four names idempotence
# inside a control's own assertion. Three hundred and twenty files mention the word in prose. So the
# promise is kept where a hand happened to remember, and nothing counts where it was not.
#
# A STATIC PATTERN FINDS CANDIDATES; ONLY THE PROVER CLASSIFIES (`20260908.010852`). This reading is
# named `candidates` rather than `writers` because four refinements in three laps proved a grep
# cannot tell a document writer from a library or a scan. The denominator ran 392 (every pen write),
# 1200 (the census reading its own bound), 30 (controls counted), 7 (controls excluded) -- and of
# that seven, THREE were still not writers: two shared libraries emitting lists and one scan that
# reads a remote. A fifth pattern was the wrong answer. `tools/c/convergence_prove.sh` classifies by
# RUNNING, and its `inert` verdict is what exposed each of these in turn.
#
# So read this number as an upper bound on what might need proving, and the prover's verdicts as the
# finding. Measured `20260908.010852`, exactly one candidate is a document writer and it converges.
#
# A FIFTH DENOMINATOR, AND THE FIRST TO RUN TOO SMALL (`20260908.154530`). The four above all
# over-counted; this one under-counted, because the exclusion was applied to the whole matched span
# rather than to the write's TARGET. `ca[t] ...` here for the same reason `sed -[i]` is spelled that
# way above, and it was learned by RUNNING rather than by reasoning: spelling the idiom whole made
# this file and its witness count THEMSELVES, 10 candidates reading 12 on a mention. A scan counting
# a mention as a use, arriving in the paragraph that warns about it.
# `ca[t] "$tmp" > "$f"` was dropped on the `$tmp` on its SOURCE
# side -- and that shape is prescribed by `.claude/rules/exec-bit.md`, since writing through the
# original inode preserves the mode the repository tracks, so the census was blind to exactly the
# writes this tree's own law requires. The same span reading ran the other way, admitting a write
# whose target was a scratch file on a `"$f"` that the printf was merely reading. Reading the target
# alone: 7 -> 10 candidates, 3 -> 5 proven, one false positive out and four false negatives in --
# two of them, `readme_metrics_splice.sh` and `reds_ledger_headline_write.sh`, run by
# `tools/hooks/pre-commit` on EVERY commit, which is the busiest writing this tree does.
#
# PROVEN FROM BOTH SIDES from that stamp, which four of the five wrong denominators never were:
# `tools/fixtures/c/convergence_census_control.sh` plants each shape in a real repository and
# asserts the elder predicate disagrees on exactly the two legs the repair moves.
#
#   sh tools/c/convergence_census.sh          # the counts
#   sh tools/c/convergence_census.sh list     # writing tools with no convergence assertion
#
# WHAT COUNTS AS PROVEN, deliberately narrow: a control or witness beside the tool that ASSERTS the
# second run's result -- `second run`, `idempotent`, `twice`, `again` -- inside a check rather than a
# comment. Prose about idempotence is a claim; an assertion is a proof, and this census exists
# because the tree had 35 times more of the first than the second.
#
# THAT SENTENCE STOOD IN WRITING FOR A DAY WHILE THE PREDICATE BENEATH IT READ THE OPPOSITE
# (`20260908.190452`). The search read every tracked path holding the stem, the tool under test
# among them, and matched the word on any line a comment included -- so a tool writing
# `Idempotent: ... a second run changes nothing` in its own header certified itself. Two of the five
# it called proven did exactly that, `dated_path_repoint_scan.sh` and `tool_path_repoint_scan.sh`,
# and for both the check that runs them twice is still owed. The rule stood in writing, read by
# nothing; the fault is the one `rune_assert_sweep` met one room over the same day, where a guard
# names the word the rule turns on and counts something else.
#
# The predicate drops the tool from its own sibling set and reads the match on a non-comment line.
# Proven falls 5 -> 3, both departures being that pair, and the three that stand are real: two
# controls asserting `verdict=nothing_to_do` on a second run, and one running an idempotence case.
#
# WHAT IS STILL OWED, and it reaches further than this repair. `tools/c/convergence_prove.sh`
# classifies by RUNNING, which is the reading that settles the question -- and it invokes a tool as
# `sh <tool> <one-path>`. Nine of the ten candidates answer to a flag rather than a path: they are
# whole-tree operators driven by `--apply`, `--check`, or a `dry|apply` mode, so answering for them
# wants a prover this tree has yet to build. The one that does fit, `ascii_document_convert.sh`,
# reads `verdict=converges` on a triggering sample and stands in the unproven column here, since a
# sibling assertion is what this column reads. So the column measures whether somebody WROTE the
# check, rather than whether the tool converges, and a
# pen-TREE prover -- one that copies a repository, runs the operator twice, and diffs -- is the
# instrument that would.
#
# THAT INSTRUMENT WAS BUILT THE SAME DAY, AND THIS COLUMN COULD NOT SEE IT (`20260908.215031`).
# `tools/c/convergence_tree_prove.sh` landed at `0cb297adb7` and is rostered `tier lap`: it takes a
# `--perturb` command, checks HEAD out into a `git worktree` pen, runs the whole-tree operator
# twice, and compares with `git write-tree`, so a mode-only change reads `diverges`. Its witness
# runs it on `tools/fixtures/r/reds_ledger_headline_write.sh` -- which `tools/hooks/pre-commit`
# runs on EVERY commit this tree makes -- and reads `verdict=converges` on every lap of every ship.
# And that tool stood in the UNPROVEN column here, because the numerator read a sibling assertion
# and nothing else. A proof that runs every twenty minutes was invisible to the census that asks
# whether the proof exists.
#
# So a tool is proven two ways from this stamp, and the split is printed rather than folded into
# one number, because the two are different evidence:
#
#   proven_by_sibling_assertion  a control or witness beside the tool ASSERTS the second run's
#                                result, on a non-comment line, in a file that is not the tool
#   proven_by_prover_run         a tracked runner names this tool on a non-comment line that also
#                                names a convergence prover -- somebody RAN the question
#
# The second is the stronger evidence, since a sibling assertion says a hand wrote a check and a
# prover run says the tool converged on metal. Both exclusions carry over unchanged: the tool is
# dropped from its own set, so a tool naming the prover in its own source certifies nothing, and a
# comment naming both is prose. `candidates_proven` counts a tool once however many ways it is
# proven, so the two splits may sum above it and the total is the one to read.
#
# REPORTED, NEVER GATED, and for a reason this tree has met four times now: a tool that legitimately
# runs once -- a one-shot projection, a publisher -- has nothing to converge, and a gate cannot tell
# it from a tool that simply never checked. The number is the finding; the ceiling is a later word.
#
# BOUNDS: at most 6000 tools read, at most 200 reported. The first bound was 1200 and the tree holds
# more than that, so the census reported `tools_read=1200` -- its own bound wearing the costume of a
# measurement, and one writer where thirty stand. A bound that silently truncates the population is
# worse than no bound, because the reading still looks like a reading. 6000 is above the corpus with
# room to grow, and the count is printed so the day it becomes a ceiling is visible.
set -eu

root=${CONV_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_TOOLS=6000
MAX_REPORT=200

work=$(mktemp -d "${TMPDIR:-/tmp}/conv-census.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files 'tools/*' 2>/dev/null | grep -E '\.(sh|rish)$' | grep -v '/date/' | head -"$MAX_TOOLS" > "$work/all.txt"
# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ -s "$work/all.txt" ] || { echo "refused: no tracked tools -- every count below would read zero" >&2; exit 2; }

writers=0; proven=0; unproven=0; by_assertion_n=0; by_prover_n=0
: > "$work/unproven.txt"

# EVERY LINE IN THE TREE THAT RUNS A CONVERGENCE PROVER, gathered once rather than per candidate.
# Each row is `<file>\t<line body>`, and only non-comment lines survive: a comment naming both a
# prover and a tool is a plan, and this census has already paid once for reading prose as proof.
# The file is kept beside the count so the self-exclusion below can drop a tool that names the
# prover in its own source -- the same rule the sibling search learned at `20260908.190452`.
git ls-files 'tools/*' 2>/dev/null | grep -E '\.(sh|rish)$' | grep -v '/date/' \
  | xargs -r grep -HE 'convergence_(tree_)?prove\.sh' 2>/dev/null \
  | awk -F: '{ src = $1; sub(/^[^:]*:/, ""); body = $0; sub(/^[[:space:]]+/, "", body);
               if (body !~ /^#/) print src "\t" body }' > "$work/prover_lines.txt" || true
[ -f "$work/prover_lines.txt" ] || : > "$work/prover_lines.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  # A WRITER HERE MUTATES THE TRACKED TREE, not its own pen. Nearly every tool redirects into a
  # temporary directory, and a pen has nothing to converge -- it is thrown away. Counting those gave
  # 392 files and a meaningless denominator; counting only writes whose target is a tree path or a
  # per-file variable gives 30, which is a population a reader can check by hand. The exclusion list
  # names the temp variables this tree actually uses.
  # `sed -[i]` rather than the literal two tokens: `shell_dialect` counts an in-place-edit SITE by
  # spelling, and a pattern that SEARCHES for one reads as one. The character class matches the same
  # text and mentions nothing (`20260908.011935`) -- a scan counting a mention as a use is the
  # family this whole session has been finding, arriving here in my own file.
  #
  # THE EXCLUSION READS THE TARGET, NEVER THE WHOLE MATCHED SPAN (`20260908.154530`). A write has a
  # source and a target, and testing the span lets either one answer for both. `cat "$tmp" > "$LEDGER"`
  # was DROPPED, because `$tmp` sits in the span and the pen list is checked against the span -- yet
  # that shape is not a stylistic accident, it is what `.claude/rules/exec-bit.md` PRESCRIBES, since
  # writing through the original inode preserves the mode the repository tracks. So the census was
  # systematically blind to the writes this tree's own law requires: `readme_metrics_splice.sh` (the
  # front door's metrics block) and `reds_ledger_headline_write.sh` (the ledger's headline), both run
  # by `tools/hooks/pre-commit` on EVERY commit, plus `index_shelf_repair.sh` and
  # `fold_shelf_link_repoint.sh`. The same span reading ran the other way too:
  # `dated_classify_seam.sh` was ADMITTED on a `"$f"` sitting on the printf's SOURCE side while its
  # target was the pen `$resc`. One fault, two directions, and the fifth wrong denominator.
  #
  # Both shapes end with their target as the last quoted run in the match -- `> *"[^"]+"` for a
  # redirect, and the path argument for `sed -[i]` -- so one extraction serves both.
  writes=$(grep -hoE '(sed -[i][^"]*"[^"]+"|(cat|printf)[^|>]*> *"[^"]+")' "$f" 2>/dev/null || true)
  [ -n "$writes" ] || continue
  printf '%s\n' "$writes" | sed 's/.*"\([^"]*\)"$/\1/' \
    | grep -vE '^\$(work|pen|tmp|TMP|out|d)\b' \
    | grep -qE '\$(f|file|path|p|target|dst)\b|construction/|session-logs/|\.claude/' || continue
  # A CONTROL WRITES INTO ITS OWN PEN AND HAS NOTHING TO CONVERGE, and counting them was this
  # census's third wrong denominator (`20260908.005904`). 23 of the 27 it first called unproven were
  # `*_control.sh` files whose writes target a throwaway directory they created and delete. The
  # prover found this empirically rather than by argument: handed a document sample, all 23 answered
  # `inert` -- the sample exercised no path, because a control is not a document writer. The real
  # population is FOUR. A denominator wrong by a factor of seven makes a fraction that reads like a
  # finding and is a description of the naming convention instead.
  case "$f" in *_control.sh) continue ;; esac
  writers=$((writers + 1))
  base=${f##*/}; stem=${base%.*}
  # Its own siblings: the control and witness that stand beside it by name.
  #
  # A TOOL MAY NOT CERTIFY ITSELF, AND PROSE IS NOT A PROOF (`20260908.190452`). This search read
  # every tracked path holding the stem -- INCLUDING the tool the census was asking about -- and
  # matched the word anywhere in it, comment lines and all. Two of the five it called proven were
  # proven by one sentence in their own header: `dated_path_repoint_scan.sh` and
  # `tool_path_repoint_scan.sh` each open with `Idempotent: ... a second run changes nothing`, and
  # that comment was the whole of the evidence. The header of this file states the rule correctly --
  # *inside a check rather than a comment* -- and the predicate beneath it counted exactly the thing
  # that sentence excludes, in the file under test.
  #
  # Two corrections, one per fault. `grep -vxF "$f"` drops the tool from its own sibling set, so a
  # claim and its proof can no longer be the same line. `grep -vqE` past a leading `#` reads the
  # match on a non-comment line, which is the checkable proxy for *inside a check*: a shell comment
  # is the one form the language itself marks, where an assertion wears a hundred spellings across
  # sh and Rishi. Measured on this tree, proven falls 5 -> 3 and both departures are the
  # self-certifying pair; the three that stand are real -- two controls asserting
  # `verdict=nothing_to_do` on a second run, and one naming an idempotence case it then runs.
  by_assertion=no
  if git ls-files 'tools/*' 2>/dev/null | grep -F "$stem" | grep -vxF "$f" \
       | xargs -r grep -hEi '(idempotent|second run|run twice|runs twice|again finds nothing)' 2>/dev/null \
       | grep -vqE '^[[:space:]]*#'; then
    by_assertion=yes
  fi
  # THE SECOND PROOF SOURCE: somebody RAN the question. A runner that is not this tool names both a
  # convergence prover and this tool's path on one non-comment line, which is what
  # `convergence_tree_prove_witness.rish` does for the headline writer on every lap.
  by_prover=no
  if awk -F'\t' -v t="$f" '$1 != t && index($2, t) > 0 { found = 1 }
                           END { exit (found ? 0 : 1) }' "$work/prover_lines.txt"; then
    by_prover=yes
  fi
  if [ "$by_assertion" = yes ] || [ "$by_prover" = yes ]; then
    proven=$((proven + 1))
    if [ "$by_assertion" = yes ]; then by_assertion_n=$((by_assertion_n + 1)); fi
    if [ "$by_prover" = yes ]; then by_prover_n=$((by_prover_n + 1)); fi
  else
    unproven=$((unproven + 1))
    printf '%s\n' "$f" >> "$work/unproven.txt"
  fi
done < "$work/all.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/unproven.txt" | sed 's/^/unproven: /'
fi

echo "tools_read=$(grep -c . "$work/all.txt")"
echo "candidates=$writers"
echo "candidates_proven=$proven"
echo "proven_by_sibling_assertion=$by_assertion_n"
echo "proven_by_prover_run=$by_prover_n"
echo "candidates_unproven=$unproven"
