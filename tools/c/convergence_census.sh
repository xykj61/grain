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
# `<tool> <one-path>`. Nine of the ten candidates answer to a flag rather than a path: they are
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
# So a tool is proven three ways from `20260909.010000`, and the split is printed rather than folded
# into one number, because the three are different evidence:
#
#   proven_by_sibling_assertion  a control or witness beside the tool ASSERTS the second run's
#                                result, on a non-comment line, in a file that is not the tool
#   proven_by_prover_run         a tracked runner names this tool on a non-comment line that also
#                                names a convergence prover -- somebody RAN the question
#   proven_by_family_control     any other tracked tool writes this tool's own PATH on a non-comment
#                                line and asserts a second run's result on one -- the control named
#                                for the FAMILY, which neither spelling above can find
#
# THE THIRD SOURCE EXISTS BECAUSE THE FIRST TWO SEARCH BY A SPELLING. The sibling column looks for
# this tool's stem inside another path; the prover column looks for a prover's name on a line.
# `dated_path_repoint_control.sh` runs `dated_path_repoint_scan.sh` twice and asserts
# `idempotent=yes` while carrying `_scan` nowhere in its own name, and two more stand like it, so
# four candidates read unproven while their proof sat beside them. Naming its subject is what makes
# a prover a prover; the name is the honest key, and a path spelling was a guess about where that
# name would live. Measured on this tree: proven 4 -> 8 of 11.
#
# The second is the stronger evidence, since a sibling assertion says a hand wrote a check and a
# prover run says the tool converged on metal. Both exclusions carry over unchanged: the tool is
# dropped from its own set, so a tool naming the prover in its own source certifies nothing, and a
# comment naming both is prose. `candidates_proven` counts a tool once however many ways it is
# proven, so the two splits may sum above it and the total is the one to read.
#
# AND THE POPULATION WAS SHELL-SHAPED BY CONSTRUCTION, measured `20260909.185835`, named here for
# a lap of its own, and repaired `20260910.101500` by the fourth strand below. The write-detection above greps three
# shell idioms -- `sed -i`, `cat >`, `printf >` -- so a Rishi tool writing through `write-file` can
# never be a candidate however much of the tree it rewrites. On the day both provers learned to run
# a Rishi subject and `tools/r/readme_metrics.rish` and `tools/g/geode_libraries.rish` were each
# proven `verdict=converges` on a perturbed pen, this census read exactly what it read before: 12
# candidates, 9 proven, 3 unproven. Two of the three pages `tools/hooks/pre-commit` regenerates on
# EVERY commit had gone from unproven to proven and no number here moved, because neither was ever
# in the denominator. The tree holds 2,450 tracked `.rish` sources against 939 `.sh`, and
# `construction/ITINERARY.md` seats *an operational shell script molts to Rishi on substantial
# touch*, so this blindness widens on exactly the laps that follow the law. A reading whose
# population is picked by one language's syntax is a reading of that language.
#
# AND THE SECOND SOURCE MEASURES WHETHER SOMEBODY ASKED, WHICH IS A DIFFERENT FACT FROM WHETHER
# THE TOOL CONVERGES (`20260909.201050`). This header stood for a day saying the tree prover was
# invisible here; the repair made it visible and exactly ONE tool had ever been handed to it, so
# `proven_by_prover_run` read 1 -- a column reporting how many questions had been asked rather than
# how many tools converge. Asking a second cost one leg on
# `tools/c/convergence_tree_prove_witness.rish` and no change to any tool:
# `tools/fixtures/r/readme_metrics_splice.sh`, which `tools/hooks/pre-commit` runs on every commit
# this tree makes, reads `verdict=converges` on a pen whose metrics block has a line missing.
# Proven 9 -> 10 of 12, `proven_by_prover_run` 1 -> 2.
#
# WHY NO PROVER HAD REACHED IT, and it is a THIRD shape beside the flag and the single path. The
# splice takes TWO paths -- the target file and the file holding the rendered block -- so the
# sibling prover, which invokes `sh <tool> <one-path>`, hands it one argument and the splice exits
# at its own `${2:?}` guard. Measured on metal: that prover answers `verdict=refused`. The tree
# prover's argument list is variadic, so it reached the splice with no change to the instrument at
# all. The instrument was already able; the gap was subjects rather than spelling.
#
# A QUARTER OF THE NUMERATOR RESTS ON PROSE, AND FOUR CURES EACH MADE IT WORSE
# (`20260909.210000`). The two proof columns above each learned to read past a leading `#` -- the
# sibling column at `20260908.190452`, the prover column with it -- and the WRITE column never did.
# Measured on this tree: 3 of the 12 candidates are admitted by a write that sits inside a comment,
# and two of the three are the busiest writers the tree has. `reds_ledger_headline_write.sh` carries
# `ca[t] "$tmp" > "$f"` in a header sentence explaining the exec-bit idiom, and its real write is
# `ca[t] "$tmp" > "$LEDGER"` on line 114; `index_shelf_repair.sh` stands the same way with `$shelf`.
# `$LEDGER` and `$shelf` both fail the target filter's variable-name list, so the comment is
# carrying the admission for a write the filter cannot see.
#
# TWO FAULTS WHOSE ERRORS CANCEL, which is why four laps of refining this one pattern never
# converged: each moved one strand and measured the pair. All four cures were run on this tree
# before this paragraph was written, and every one read worse than the fault:
#
#   comments dropped alone          12 -> 9 candidates, and the two busiest writers LEAVE,
#                                   `reds_ledger_headline_write.sh` among them -- the one tool
#                                   `convergence_tree_prove_witness.rish` proves on every lap
#   variable targets admitted       12 -> 49, the fourth wrong denominator returning, because this
#     unless a named pen            tree writes scratch under a hundred local names
#   a bounded 3-hop resolution      12 -> 14: `reds_fold.sh` arrives, a real writer this card
#     of the target variable        mandates, beside three pen writers (`$SCRATCH`, the seed
#                                   projector, the roster runner's own receipt)
#   the room-literal list widened   a guess-list goes stale the day a room is born
#
# So the population is NOT repairable by refining the pattern. What separates a tracked-tree write
# from a pen write is what the path IS, and git answers that for a literal and nothing answers it
# for a variable -- which this census's own law already says: a static pattern finds candidates,
# only the prover classifies. The cure is to hand each candidate to
# `tools/c/convergence_tree_prove.sh`, which runs the operator in a worktree pen and compares
# `git write-tree`, so it reads what git tracks by diffing a real repository rather than by
# guessing at a name.
#
# THE SIXTH CURE MOVED BOTH STRANDS AT ONCE, AND IT IS THE FIRST WITH GIT IN IT
# (`20260909.222142`). The four cures above each moved ONE strand and measured the pair, which is
# why none converged: the comment fence and the target guess were cancelling each other's errors.
# Moving both together needs a target test that answers for `$LEDGER` and `$shelf` WITHOUT admitting
# `$SCRATCH`, and no list of names can do that -- which is what the four laps proved by hand. Git
# can, because the question was never what a variable is called; it is whether the path it holds is
# one the repository tracks. `resolve_target` walks at most three in-file assignments to a literal
# and `git_admits` hands that literal to `git ls-files`.
#
# Measured on this tree the same stamp: **12 -> 13 candidates**, and the membership is what moved.
# `dated_path_exclusions.sh` LEAVES -- a shared list library whose only matching write is a sentence
# describing the repointer's, so it never wrote anything. `reds_fold.sh` and `bootstrap_wasmtime.sh`
# ARRIVE, both real writers of tracked paths (`construction/REDS.md`, which this card's own fold
# rule mandates, and a tracked `.sha256` fixture), and both stand unproven. And
# `reds_ledger_headline_write.sh` and `index_shelf_repair.sh` STAY, now admitted on their real live
# writes rather than on prose. `admitted_by_git_only` reads 4, `admitted_by_name_only` 8, and one
# candidate answers to both -- neither strand subsumes the other, so the reading is their union.
#
# `admitted_on_comment_only` RETIRES rather than standing at a permanent zero. It measured a fence
# that is now closed, and a column that can only ever read zero is a tautology wearing a
# measurement's clothes. What it found is kept above, where a reader meets it as a finding.
#
# THAT FENCE POST WAS PAID (`20260909.233000`), and it took a THIRD strand rather than a better
# pattern. `upstream_shape_scan.sh` was admitted by the name strand on a `"$f"` written inside a
# `git filter-branch --tree-filter` string, in a `mktemp -d` pen -- a pen write wearing an
# enumerated destination's clothes. Neither strand could refuse it, because both read a matched
# SPAN and a span carries no position: `$f` there is filter-branch's own loop variable and resolves
# to no literal, while `"$f"` is exactly the shape the name list exists to admit. `live_lines`
# below walks the file as a shell lexer and reads a write only off a line standing outside every
# quoted region. Measured on this tree: **13 -> 12 candidates**, unproven 3 -> 2, `name_only`
# 8 -> 7, `candidates_proven` unchanged at 10, and the single departure is that file -- one strand
# moved, one member out, which is what the four cancelling cures above never managed.
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

# THE TOOL'S OWN HOME, apart from the tree it READS. `CONV_ROOT` points the census at another
# repository -- which is how `tools/fixtures/c/convergence_census_control.sh` proves this
# predicate on planted pens -- so a library sourced from `$root` would be looked for inside the
# pen and the census would die under `set -eu` on every control leg.
self_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=${CONV_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_TOOLS=6000
MAX_REPORT=200
# invariant: a bound on how many naming siblings one tool may open, so the family-control source
# below stays finite however widely a path is cited. The widest name in this tree today is written
# by 3 other tools, so the bound has never bitten.
MAX_SIBLINGS=200

# THE THIRD STRAND: A WRITE INSIDE SOMEBODY ELSE'S QUOTED ARGUMENT IS NOT THIS TOOL'S WRITE
# (`20260909.233000`). Both strands above read a MATCHED SPAN off a line, and neither asks where
# that line SITS. A shell script may carry a hundred lines inside one quoted argument -- an embedded
# `awk` program, a `git filter-branch --tree-filter` body, a heredoc fed to another interpreter --
# and text inside such an argument is data this tool hands to another command rather than a write
# this tool performs.
#
# `upstream_shape_scan.sh` was the standing false positive the header named as the next post: its
# only admitting write is `ca[t] "$f.t" > "$f"` on line 150, inside a single-quoted
# `--tree-filter` string opened on line 146, run by `git filter-branch` against its own
# `mktemp -d` pen. The git strand cannot refuse it, since `$f` there is filter-branch's loop
# variable and resolves to no literal at all; the name strand admits it precisely because `"$f"` is
# the enumerated-destination shape. Neither can see the enclosure, because a span carries no
# position.
#
# `live_lines` walks the file as a shell lexer -- single quotes, double quotes with backslash
# escapes, unquoted `#` comments, and heredocs including the `<<-` and quoted-delimiter forms --
# and emits only the lines a write may honestly be read from: outside every quoted region, and not
# a whole-line comment. Measured on this tree the same stamp: **406 of 3,322 tracked tool sources
# carry at least one held line**, most of them embedded `awk` programs, and exactly **one**
# candidate's admission rested on one.
#
# PROVEN BY ITS OWN EXIT STATE, which is the check that says the lexer tracks rather than drifts: a
# well-formed shell script ends outside every quote, so the walker's final state is the reading.
# Across the same 3,322 sources it ends OUT on **3,321**. The one exception is
# `tools/l/launch-claude-chapter.rish:83`, a Rishi `say` line carrying three double quotes, and it
# is an honest limit rather than a lexer fault: **Rishi is not shell**, and this walker is a shell
# lexer applied to a corpus the write-detection above already picks by shell syntax. A `.rish`
# source whose quoting differs desyncs the walk from that line to the file's end, which can only
# ever WITHHOLD lines from the write reading -- so the failure direction is a missed candidate
# rather than a false one, and the census reports rather than gates.
MAX_LINES=20000
# THE WALKER MOVED TO A LIBRARY (`20260910.035630`), because the lantern fired a second time in
# another room: `tools/fixtures/e/elf_machine_census_scan.sh` counted thirteen `file` calls that
# stood inside the heredoc PLANTS of a control, by the same span-carries-no-position fault this
# strand was built to close. `tools/fixtures/l/live_lines.sh` holds the reading now, and this
# census reads it rather than keeping a second copy -- one reading, one home, so a repair to the
# lexer reaches both callers. The function name, its bound, and its answer are unchanged.
. "$self_dir/../fixtures/l/live_lines.sh"

# THE WRITE SHAPES, AND THE TARGET TEST, EACH WRITTEN ONCE. Two readings ask the same question of
# the same file -- every line, and non-comment lines only -- so one spelling serves both and they
# cannot drift apart. `sed -[i]` keeps its character class for the reason the header gives: a scan
# that SEARCHES for the idiom would otherwise count as a site that uses it.
WRITE_SHAPES='(sed -[i][^"]*"[^"]+"|(cat|printf)[^|>]*> *"[^"]+")'
target_admits() {
  # target_admits <matched-writes> -- true when one match's TARGET is a tree path rather than a pen.
  # The target is the last quoted run of the match, which both shapes share.
  printf '%s\n' "$1" | sed 's/.*"\([^"]*\)"$/\1/' \
    | grep -vE '^\$(work|pen|tmp|TMP|out|d)\b' \
    | grep -qE '\$(f|file|path|p|target|dst)\b|construction/|session-logs/|\.claude/'
}

# THE SECOND STRAND: RESOLVE THE TARGET TO A LITERAL, THEN ASK GIT (`20260909.222142`).
#
# `target_admits` above answers by NAME -- a list of loop-variable spellings and a list of room
# prefixes -- and a name is a guess about a destination. Four laps refined that guess and each read
# worse, because a target written `$LEDGER` or `$shelf` is a real tracked-tree write whose name is
# on no list, while a target written `$SCRATCH` is a pen whose name could have been anything.
#
# What separates the two is what the path IS, and exactly one thing in this tree knows: git.
# `resolve_target` walks the variable back through at most 3 in-file assignments to a literal --
# following `${OVERRIDE:-default}`, since a tool's tracked destination usually sits in an override
# hook's default -- and `git_admits` hands that literal to `git ls-files`. A fully literal target
# must itself be tracked; a target still carrying a `$` is tested on its longest literal prefix, so
# `session-logs/date/README-index-$open_shelf.md` is admitted on the room git tracks and
# `$(mktemp -d)/over.txt` is refused for having no literal prefix at all.
#
# THE TWO STRANDS ARE A UNION AND NEITHER SUBSUMES THE OTHER. The name strand sees an enumerated
# destination -- `"$f"` inside a loop over paths the caller supplied -- where no literal exists to
# resolve. The git strand sees a named destination the list never held. Measured on this tree at
# `20260909.222142`: the name strand alone reads 12, the git strand alone reads 5, and their union
# reads 13.
MAX_HOPS=3
resolve_target() {
  # resolve_target <file> <target> -- at most MAX_HOPS in-file assignments, then whatever is left.
  # invariant: bounded, so a pair of variables defined in terms of each other cannot spin here.
  rt_src=$1; rt_t=$2; rt_hop=0
  while [ "$rt_hop" -lt "$MAX_HOPS" ]; do
    case "$rt_t" in *'$'*) : ;; *) break ;; esac
    rt_v=$(printf '%s' "$rt_t" | sed -n 's/^\${\{0,1\}\([A-Za-z_][A-Za-z0-9_]*\).*/\1/p')
    [ -n "$rt_v" ] || break
    rt_rhs=$(grep -hE "^[[:space:]]*(readonly[[:space:]]+)?$rt_v=" "$rt_src" 2>/dev/null | head -1 \
             | sed "s/^[[:space:]]*//; s/^readonly[[:space:]]*//; s/^$rt_v=//")
    # `${ANY:-default}` and `${ANY:=default}` carry the literal in the default, and the name inside
    # the braces is usually a DIFFERENT variable -- an override hook, as in
    # `SHELF_ROOM=${INDEX_ROW_SHELF_ROOM:-session-logs/date}`. Reading only the assigned name's own
    # braces would miss every one of them.
    case "$rt_rhs" in
      '${'*:[-=]*) rt_rhs=$(printf '%s' "$rt_rhs" | sed 's/^\${[A-Za-z_][A-Za-z0-9_]*:[-=]//; s/}.*$//') ;;
    esac
    rt_rhs=$(printf '%s' "$rt_rhs" | sed "s/^[\"']//; s/[\"'].*$//")
    [ -n "$rt_rhs" ] || break
    rt_rest=$(printf '%s' "$rt_t" | sed -n 's/^\${\{0,1\}[A-Za-z_][A-Za-z0-9_]*}\{0,1\}//p')
    rt_new="$rt_rhs$rt_rest"
    [ "$rt_new" != "$rt_t" ] || break
    rt_t=$rt_new; rt_hop=$((rt_hop + 1))
  done
  printf '%s\n' "$rt_t"
}
git_admits() {
  # git_admits <file> <matched-writes> -- true when one match's target resolves to a path git tracks.
  printf '%s\n' "$2" | sed 's/.*"\([^"]*\)"$/\1/' | sort -u | while IFS= read -r ga_tgt; do
    [ -n "$ga_tgt" ] || continue
    ga_lit=$(resolve_target "$1" "$ga_tgt")
    case "$ga_lit" in
      *'$'*)
        ga_pre=${ga_lit%%\$*}
        case "$ga_pre" in */*) : ;; *) continue ;; esac
        ga_dir=${ga_pre%/*}
        [ -n "$ga_dir" ] || continue
        [ -n "$(git ls-files -- "$ga_dir" 2>/dev/null | head -1)" ] || continue
        ;;
      *)
        git ls-files --error-unmatch -- "$ga_lit" >/dev/null 2>&1 || continue
        ;;
    esac
    echo yes
    break
  done | grep -q yes
}


# THE FOURTH STRAND: RISHI WRITES, BECAUSE A POPULATION PICKED BY ONE LANGUAGE'S SYNTAX IS A
# READING OF THAT LANGUAGE (`20260910.101500`). The header above named this blindness on
# `20260909.185835` and left the repair for its own lap; this is that lap, and measuring moved the
# finding. The paragraph guessed the gap was `write-file`, Rishi's own write statement. Measured
# over all 2,450 tracked `.rish` sources: **three tools call `write-file` with a literal target and
# git tracks none of them** -- a `/tmp` diff, a jail config, an untracked fixture. The gap was at a
# spelling nobody had named: a redirect inside `run ["sh" "-c" ...]`, where the path is a bare
# literal in a Rishi string, and it has exactly ONE member -- `tools/g/geode_libraries.rish`, which
# `tools/hooks/pre-commit` runs on EVERY commit this tree makes, and which the header two
# paragraphs up already names as proven-and-invisible.
#
# `"sh" "-c"` IS THE READING, RATHER THAN THE REDIRECT ALONE, and it is this strand's whole fence.
# `sh -c` executes in this tool's own working directory, so its redirect is this tool's write. A
# redirect inside any other quoted argument is text handed to another command, which is the
# distinction `live_lines` draws for shell -- and a shell lexer cannot draw it here, since Rishi is
# not shell and this census's own header records that walker desyncing on a Rishi `say` line.
# Measured both ways on this tree: dropping the `"sh" "-c"` fence admits
# `tools/c/convergence_tree_prove_witness.rish` on the `> construction/REDS.md` inside its
# `--perturb` string, which runs against a `git worktree` pen -- the same false positive the third
# strand was built to refuse, arriving in a language the third strand cannot read.
#
# A TARGET NEEDS A SLASH, since `>` is also Rishi's comparison operator: without it the strand reads
# `> "5"`, `> "cap"`, and `> "me.max_mark_len"` as destinations. THAT RULE IS A COST READING RATHER
# THAN A FENCE, measured rather than assumed: dropping it leaves candidates, members, and both
# strand splits unchanged, because the target tests already refuse those three -- what it changes is
# the run, **189s to 208s**, since every noise span costs a `git ls-files`. The control plants the
# shape and asserts nothing on it, since a leg that cannot fail proves nothing. And the emitted span
# is normalized to `> "<target>"` so the two strands above extract it unchanged -- one extraction,
# three shapes.
#
# BOUNDS: one lookup per bare `write-file` operand, and the redirect is read per line, so a
# `run [...]` list broken across lines withholds rather than invents. Both failure directions are a
# missed candidate, which is the direction this census reports rather than gates.
MAX_LET_LOOKUPS=1
rish_writes() {
  # rish_writes <file> -- normalized `> "<target>"` spans for the two Rishi write shapes.
  # invariant: comment lines are dropped before any match, so a header sentence explaining an
  # idiom can never admit the tool that explains it -- the fence the write column paid for at
  # `20260909.222142`, kept here rather than relearned.
  rw_f=$1
  rw_live=$(grep -vE '^[[:space:]]*#' "$rw_f" 2>/dev/null || true)
  printf '%s\n' "$rw_live" | grep -E '"sh"[[:space:]]+"-c"' 2>/dev/null \
    | grep -hoE '> *[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)+' 2>/dev/null \
    | sed 's/^> *//' | while IFS= read -r rw_t; do
        if [ -n "$rw_t" ]; then printf '> "%s"\n' "$rw_t"; fi
      done
  printf '%s\n' "$rw_live" | grep -hoE 'write-file +("[^"]+"|[A-Za-z_][A-Za-z0-9_]*)' 2>/dev/null \
    | sed 's/^write-file  *//' | while IFS= read -r rw_o; do
        case "$rw_o" in
          '"'*) printf '> %s\n' "$rw_o" ;;
          *)
            # A bare operand is a Rishi binding; one `let` lookup reaches the literal form, and an
            # operand bound to an expression resolves to nothing and is withheld.
            rw_lit=$(grep -hE "^[[:space:]]*let[[:space:]]+$rw_o[[:space:]]*=[[:space:]]*\"" "$rw_f" 2>/dev/null \
                     | head -"$MAX_LET_LOOKUPS" | sed 's/.*=[[:space:]]*"//; s/".*$//')
            if [ -n "$rw_lit" ]; then printf '> "%s"\n' "$rw_lit"; fi
            ;;
        esac
      done
  # invariant: a defined status of its own. A `while` loop returns its last body command's status,
  # so a final iteration finding nothing to emit made this function return 1 -- and under `set -e`
  # that killed the census at `rish=$(rish_writes "$f")`. Caught by running it, on the first Rishi
  # source whose last `write-file` operand resolved to no literal.
  return 0
}
work=$(mktemp -d "${TMPDIR:-/tmp}/conv-census.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files 'tools/*' 2>/dev/null | grep -E '\.(sh|rish)$' | grep -v '/date/' | head -"$MAX_TOOLS" > "$work/all.txt"
# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ -s "$work/all.txt" ] || { echo "refused: no tracked tools -- every count below would read zero" >&2; exit 2; }

writers=0; proven=0; unproven=0; by_assertion_n=0; by_prover_n=0; by_family_n=0
git_only=0; name_only=0
: > "$work/unproven.txt"
: > "$work/git_only.txt"
: > "$work/name_only.txt"

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
  #
  # AND THE WRITE IS READ OFF LIVE LINES, NEVER OFF A COMMENT (`20260909.222142`). Both proof
  # columns learned to read past a leading `#` and this column never did, so a header sentence
  # explaining a write idiom admitted the tool that explained it. The reading that measured the
  # cost -- `admitted_on_comment_only`, 3 of 12 -- is retired by this line, since a comment can no
  # longer admit anything. What it counted is preserved as the finding it was: of the three,
  # `dated_path_exclusions.sh` writes nothing at all and LEAVES, while `reds_ledger_headline_write.sh`
  # and `index_shelf_repair.sh` are real writers who STAY, now admitted on their live `$LEDGER` and
  # `$shelf` writes by the git strand below. That is why this could only move together with it:
  # dropping comments alone took the two busiest writers out with the false one, which is the shape
  # the header calls two faults whose errors cancel.
  writes=$(live_lines "$f" "$MAX_LINES" | grep -hoE "$WRITE_SHAPES" 2>/dev/null || true)
  # AND A RISHI SOURCE IS ASKED IN ITS OWN LANGUAGE (`20260910.101500`). The three shapes above are
  # shell idioms, so a `.rish` tool could stand in this population and never be readable by it. The
  # spans `rish_writes` emits are normalized to `> "<target>"`, so both strands below extract the
  # target with the one spelling they already share.
  case "$f" in
    *.rish)
      rish=$(rish_writes "$f")
      # `if` rather than a `&&` chain: an empty result would exit non-zero as the branch's last
      # command, and `set -e` would take the census down on every Rishi source that writes nothing.
      if [ -n "$rish" ]; then writes=$(printf '%s\n%s\n' "$writes" "$rish"); fi
      ;;
  esac
  [ -n "$writes" ] || continue
  by_name=no; by_git=no
  target_admits "$writes" && by_name=yes
  git_admits "$f" "$writes" && by_git=yes
  [ "$by_name" = yes ] || [ "$by_git" = yes ] || continue
  # A CONTROL WRITES INTO ITS OWN PEN AND HAS NOTHING TO CONVERGE, and counting them was this
  # census's third wrong denominator (`20260908.005904`). 23 of the 27 it first called unproven were
  # `*_control.sh` files whose writes target a throwaway directory they created and delete. The
  # prover found this empirically rather than by argument: handed a document sample, all 23 answered
  # `inert` -- the sample exercised no path, because a control is not a document writer. The real
  # population is FOUR. A denominator wrong by a factor of seven makes a fraction that reads like a
  # finding and is a description of the naming convention instead.
  case "$f" in *_control.sh) continue ;; esac
  writers=$((writers + 1))
  # WHICH STRAND ADMITTED IT, printed with its members, because the two are different evidence and
  # a reader deciding whether to trust the population needs to know which answered. `by_git_only`
  # is the reading that says what git bought: a destination the name list could never have held.
  if [ "$by_git" = yes ] && [ "$by_name" = no ]; then
    git_only=$((git_only + 1))
    printf '%s\n' "$f" >> "$work/git_only.txt"
  fi
  if [ "$by_name" = yes ] && [ "$by_git" = no ]; then
    name_only=$((name_only + 1))
    printf '%s\n' "$f" >> "$work/name_only.txt"
  fi
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
  # THE THIRD PROOF SOURCE: A CONTROL NAMED FOR THE FAMILY (`20260909.010000`). Both sources above
  # search by a SPELLING -- the first for this tool's own stem in a sibling's path, the second for a
  # prover's name on a line. A control named for the family rather than for the file satisfies
  # neither, and three stand in this tree: `dated_path_repoint_control.sh` runs
  # `dated_path_repoint_scan.sh` twice and asserts `idempotent=yes` while carrying `_scan` nowhere
  # in its own name, `tool_path_repoint_control.sh` does the same one room over, and
  # `ascii_document_control.sh` runs the converter a second time and holds `unchanged=1`.
  #
  # So this source asks the question the stem was a proxy for: does another tracked tool write this
  # tool's own PATH on a non-comment line, and assert a second run's result on one? Naming its
  # subject is what makes a prover a prover, and the name is the honest key where the path spelling
  # was a guess about where that name would live.
  #
  # THE PROXY IS FILE-WIDE AND SAYS SO. `ascii_document_control.sh` names the converter once and
  # asserts `convert_is_idempotent` forty lines away through a shell variable, so a proximity window
  # drops a genuine proof -- measured at twenty lines, which refused exactly that one. What the
  # file-wide reading buys instead is a sibling naming this tool for one reason and asserting
  # convergence about another. The column is REPORTED and never gated, and `convergence_prove`
  # settles by RUNNING, so the softer proxy costs a number rather than a wall.
  by_family=no
  if [ "$by_assertion" = no ] && [ "$by_prover" = no ]; then
    for s in $(git ls-files 'tools/*' 2>/dev/null | grep -vxF "$f" \
                 | xargs -r grep -lF "$f" 2>/dev/null | head -"$MAX_SIBLINGS"); do
      body=$(grep -vE '^[[:space:]]*#' "$s" 2>/dev/null || true)
      printf '%s\n' "$body" | grep -qF "$f" || continue
      printf '%s\n' "$body" | grep -qEi '(idempotent|second run|run twice|runs twice|again finds nothing)' || continue
      by_family=yes
      break
    done
  fi
  if [ "$by_assertion" = yes ] || [ "$by_prover" = yes ] || [ "$by_family" = yes ]; then
    proven=$((proven + 1))
    if [ "$by_assertion" = yes ]; then by_assertion_n=$((by_assertion_n + 1)); fi
    if [ "$by_prover" = yes ]; then by_prover_n=$((by_prover_n + 1)); fi
    if [ "$by_family" = yes ]; then by_family_n=$((by_family_n + 1)); fi
  else
    unproven=$((unproven + 1))
    printf '%s\n' "$f" >> "$work/unproven.txt"
  fi
done < "$work/all.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/unproven.txt" | sed 's/^/unproven: /'
  head -"$MAX_REPORT" "$work/git_only.txt" | sed 's/^/git_only: /'
  head -"$MAX_REPORT" "$work/name_only.txt" | sed 's/^/name_only: /'
fi

echo "tools_read=$(grep -c . "$work/all.txt")"
echo "candidates=$writers"
echo "candidates_proven=$proven"
echo "proven_by_sibling_assertion=$by_assertion_n"
echo "proven_by_prover_run=$by_prover_n"
echo "proven_by_family_control=$by_family_n"
echo "candidates_unproven=$unproven"
# A COUNT NOBODY CAN FOLLOW IS A COUNT NOBODY ACTS ON. The names sit behind `sh
# tools/c/convergence_census.sh list`, and until `20260910` the count mode never said so -- a reader
# was told two candidates stand unproven and given no way to learn which two.
if [ "$MODE" != list ] && [ "$unproven" -gt 0 ]; then
  echo "unproven_names=run 'sh tools/c/convergence_census.sh list' to see them"
fi
echo "admitted_by_git_only=$git_only"
echo "admitted_by_name_only=$name_only"
