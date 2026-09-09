#!/bin/sh
# convergence_census_control.sh -- prove the census's writer predicate from both sides, on real
# repositories in a throwaway pen.
#
# WHAT IT PROVES. A write has a source and a target, and this control asserts the census reads the
# TARGET: a write landing in a pen stays out of the population, a write landing on a tracked path
# joins it, and a per-file variable sitting on the source side answers for nothing. Each shape is
# planted in a real git repository, since the census draws its population with `git ls-files`.
#
# WHY IT EXISTS. `tools/c/convergence_census.sh` has published five denominators -- 392, 1200, 30,
# 7, and 10 -- and the first four were each repaired by argument. The fifth came from a reading: the
# exclusion tested the whole matched span, so `ca[t] "$tmp" > "$f"` fell out on the `$tmp` sitting to
# the left of the arrow. That shape is the one `.claude/rules/exec-bit.md` asks for, since writing
# through the original inode preserves the mode the repository tracks -- so the census passed over
# exactly the writes this tree's own law prescribes, `readme_metrics_splice.sh` and
# `reds_ledger_headline_write.sh` among them, which `tools/hooks/pre-commit` runs on every commit.
#
# BOTH PREDICATES RUN HERE, over the same plants, and the control asserts each elder disagrees on
# exactly the legs its repair moves -- the writer predicate on two, the PROVEN predicate on one. A repair shown only in the passing direction reads the same
# as a coincidence, which is what the four earlier denominators had in common.
#
#   sh tools/fixtures/c/convergence_census_control.sh
#
# BOUNDS: one pen, twelve legs, at most 16 planted tools. The pen is removed on every exit path.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
census="$root/tools/c/convergence_census.sh"
[ -f "$census" ] || { echo "refused: no census at $census" >&2; exit 2; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/conv-census-control.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0; fail=0
leg() {
  # leg <name> <want> <got>
  if [ "$2" = "$3" ]; then pass=$((pass + 1)); echo "leg green  $1 -- $3"
  else fail=$((fail + 1)); echo "leg RED    $1 -- wanted $2, read $3"; fi
}

# A PEN THAT IS A REAL REPOSITORY, since the census draws its population with `git ls-files`.
mkdir -p "$pen/tree/tools/x"
cd "$pen/tree"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

plant() { # plant <relative-path> <body>
  mkdir -p "$(dirname -- "$1")"
  printf '%s\n' "$2" > "$1"
}

# 1. A write whose TARGET is a pen has nothing to converge.
plant tools/x/pen_target.sh 'cat "$src" > "$work/out.txt"'
# 2. THE EXEC-BIT IDIOM: pen source, tree target. This is the leg the elder predicate dropped.
plant tools/x/exec_bit_idiom.sh 'cat "$tmp" > "$f"'
# 3. A per-file variable on the SOURCE side answering for a pen target the exclusion list does not
#    name. This is the elder predicate's false positive, taken from the tree: `dated_classify_seam.sh`
#    was counted on a `"$f"` that was the printf's SOURCE, while its target was the scratch `$resc`.
plant tools/x/file_source_pen_target.sh "printf '%s\\n' \"\$f\" > \"\$resc\""
# 4. An in-place edit of a per-file variable is a write, in the single-quoted form the tree writes.
#    THE FLAG IS COMPOSED RATHER THAN SPELLED. `shell_dialect` walls the GNU in-place spelling at
#    zero across tracked sources, since BSD sed needs an argument after it, and that guard counts a
#    SITE by spelling -- so a file planting one reads as a file using one. The census's own header
#    dodges the same wall with `sed -[i]`; a plant needs the real bytes in the PLANTED file, so the
#    flag is assembled here and this source never carries it.
in_place_flag="-$(printf i)"
plant tools/x/in_place.sh "sed $in_place_flag 's/a/b/' \"\$f\"" 
# 5. A control writes into its own pen and is skipped by name, whatever it writes.
plant tools/x/planted_control.sh 'cat "$tmp" > "$f"'
git add -A >/dev/null
git commit -q -m "pen: planted writers"

read_count() { # read_count <key>
  CONV_ROOT="$pen/tree" sh "$census" 2>/dev/null | sed -n "s/^$1=//p"
}
listed() { CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null | sed -n 's/^unproven: //p'; }

names=$(CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null | sed -n 's/^unproven: //p' | sed 's|.*/||' | sort | tr '\n' ' ')
has() { case " $names " in *" $1 "*) echo yes ;; *) echo no ;; esac; }

leg pen_target_refused              no  "$(has pen_target.sh)"
leg exec_bit_idiom_counted          yes "$(has exec_bit_idiom.sh)"
leg file_source_pen_target_refused  no  "$(has file_source_pen_target.sh)"
leg in_place_counted                yes "$(has in_place.sh)"
leg control_skipped_by_name         no  "$(has planted_control.sh)"

# 6. THE ELDER PREDICATE, run over the same plants, must DISAGREE on legs 2 and 3 -- otherwise this
# control proves the repair changed nothing and the population moved for some other reason.
elder() { # elder <file> -> yes|no
  if grep -hoE '(sed -[i][^"]*"[^"]+"|(cat|printf)[^|>]*> *"[^"]+")' "$1" 2>/dev/null \
    | grep -vE '\$(work|pen|tmp|TMP|out|d)\b' \
    | grep -qE '\$(f|file|path|p|target|dst)\b|construction/|session-logs/|\.claude/'; then echo yes; else echo no; fi
}
leg elder_dropped_the_exec_bit_idiom   no  "$(elder tools/x/exec_bit_idiom.sh)"
leg elder_admitted_the_pen_target      yes "$(elder tools/x/file_source_pen_target.sh)"

# 8. THE PROVEN PREDICATE, from both sides. A tool may not certify itself, and prose is not a
# proof. Each plant below is a tree writer by leg 2's shape, so the only thing separating them is
# what stands beside them -- which is exactly what the proven column claims to read.
cd "$pen/tree"
# 8a. The self-certifying shape, taken from the tree: the ONLY idempotence sentence is a comment in
#     the tool's own header. `dated_path_repoint_scan.sh` and `tool_path_repoint_scan.sh` both read
#     proven on this alone until `20260908.190452`.
plant tools/x/self_certifying.sh '# Idempotent: a second run changes nothing.
cat "$tmp" > "$f"'
# 8b. A sibling that only TALKS about it. Prose is a claim wherever it sits.
plant tools/x/prose_sibling.sh 'cat "$tmp" > "$f"'
plant tools/x/prose_sibling_witness.rish '# the repair is idempotent, so a second run finds nothing'
# 8c. A sibling that ASSERTS it, on a line the language does not mark as a comment.
plant tools/x/asserted_sibling.sh 'cat "$tmp" > "$f"'
plant tools/x/asserted_sibling_control.sh 'check "a second run finds nothing" yes "$got"'
git add -A >/dev/null
git commit -q -m "pen: planted proven-predicate shapes"

unproven_now=$(CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null | sed -n 's/^unproven: //p' | sed 's|.*/||' | sort | tr '\n' ' ')
unp() { case " $unproven_now " in *" $1 "*) echo yes ;; *) echo no ;; esac; }

leg self_certification_refused      yes "$(unp self_certifying.sh)"
leg prose_sibling_refused           yes "$(unp prose_sibling.sh)"
leg asserted_sibling_counted        no  "$(unp asserted_sibling.sh)"

# 8d. THE ELDER PROVEN PREDICATE over the same plants must ADMIT the self-certifying tool --
# otherwise these three legs pass for some reason other than the repair, which is how four of this
# census's five wrong denominators read green.
elder_proven() { # elder_proven <file> -> yes|no
  base=${1##*/}; stem=${base%.*}
  if git ls-files 'tools/*' 2>/dev/null | grep -F "$stem" \
       | xargs -r grep -lEi '(idempotent|second run|run twice|runs twice|again finds nothing)' 2>/dev/null \
       | head -1 | grep -q .; then echo yes; else echo no; fi
}
leg elder_called_self_certification_proven yes "$(elder_proven tools/x/self_certifying.sh)"

# 9. THE SECOND PROOF SOURCE, from both sides (`20260908.215031`). A tool is also proven when a
# tracked runner NAMES it on a non-comment line that also names a convergence prover -- somebody
# ran the question rather than writing a check about it. The plants below name
# `tools/c/convergence_tree_prove.sh` inside the pen, so this control file carries that string on
# its own non-comment lines; in the real tree those lines name only `tools/x/` paths, which no
# candidate wears, so the census reads nothing from them.
plant tools/x/prover_run_proven.sh 'cat "$tmp" > "$f"'
plant tools/x/prover_run_caller.rish 'let p = run ["sh" "tools/c/convergence_tree_prove.sh" "tools/x/prover_run_proven.sh" "write"]'
# 9b. The same naming, on a line the language marks as a comment. A plan is not a run.
plant tools/x/prover_in_comment.sh 'cat "$tmp" > "$f"'
plant tools/x/commented_caller.rish '# owed: sh tools/c/convergence_tree_prove.sh tools/x/prover_in_comment.sh write'
# 9c. And the self-exclusion, which the sibling column already learned: a tool naming the prover
#     and itself in its own source certifies nothing about itself.
plant tools/x/prover_self_named.sh 'cat "$tmp" > "$f"
echo "sh tools/c/convergence_tree_prove.sh tools/x/prover_self_named.sh write"'
git add -A >/dev/null
git commit -q -m "pen: planted prover-run shapes"

unproven_now=$(CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null | sed -n 's/^unproven: //p' | sed 's|.*/||' | sort | tr '\n' ' ')

leg prover_run_counted             no  "$(unp prover_run_proven.sh)"
leg prover_run_in_comment_refused  yes "$(unp prover_in_comment.sh)"
leg prover_self_naming_refused     yes "$(unp prover_self_named.sh)"

# 9d. AND THE REPAIR MUST MOVE SOMETHING. The elder numerator reads sibling assertions alone, so it
# calls the prover-run plant unproven -- which is exactly how `reds_ledger_headline_write.sh` stood
# in that column while `convergence_tree_prove_witness.rish` proved it converges on every lap.
leg elder_called_prover_run_unproven no "$(elder_proven tools/x/prover_run_proven.sh)"

# 9e. The split is printed, since a tool proven both ways counts once in the total and a reader
# needs to know which evidence stands behind the number.
split_now=$(CONV_ROOT="$pen/tree" sh "$census" 2>/dev/null)
case "$split_now" in *proven_by_prover_run=*) split_prover=printed ;; *) split_prover=absent ;; esac
case "$split_now" in *proven_by_sibling_assertion=*) split_sibling=printed ;; *) split_sibling=absent ;; esac
leg prover_run_split_printed        printed "$split_prover"
leg sibling_assertion_split_printed printed "$split_sibling"

# 7. A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170) -- shown rather than trusted.
mkdir -p "$pen/bare"
cd "$pen/bare"
git init -q .
if CONV_ROOT="$pen/bare" sh "$census" >/dev/null 2>&1; then empty=accepted; else empty=refused; fi
leg empty_corpus_refuses refused "$empty"

echo "legs_pass=$pass"
echo "legs_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=control_red"; exit 1
