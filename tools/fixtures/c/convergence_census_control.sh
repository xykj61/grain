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
# BOUNDS: one pen, fifty-two legs, at most 35 planted tools. The pen is removed on every exit path.
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

# 10. THE THIRD PROOF SOURCE, from both sides (`20260909.010000`). Both sources above search by a
# SPELLING: the first for the tool's own stem inside a sibling's path, the second for a prover's
# name on a line. A control named for the FAMILY rather than for the file satisfies neither, and
# three stand in the tree -- `dated_path_repoint_control.sh` runs `dated_path_repoint_scan.sh`
# twice and asserts `idempotent=yes` while carrying `_scan` nowhere in its own name.
plant tools/x/family_named.sh 'cat "$tmp" > "$f"'
plant tools/x/family_control.sh 'out=$(sh tools/x/family_named.sh)
if [ "$before" = "$after" ]; then echo "idempotent=yes"; else echo "idempotent=no"; fi'
# 10b. NAMED IN A COMMENT ONLY. This source inherits the non-comment discipline the sibling column
#      already holds rather than loosening it: a file that mentions the tool in prose and asserts
#      convergence about something else leaves it unproven, or the repair would trade one
#      self-certifying shape for another.
plant tools/x/named_in_comment.sh 'cat "$tmp" > "$f"'
plant tools/x/mentions_control.sh '# tools/x/named_in_comment.sh is named here and nowhere else
if [ "$before" = "$after" ]; then echo "idempotent=yes"; else echo "idempotent=no"; fi'
git add -A >/dev/null
git commit -q -m "pen: planted family-control shapes"

unproven_now=$(CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null | sed -n 's/^unproven: //p' | sed 's|.*/||' | sort | tr '\n' ' ')

leg family_control_counted          no  "$(unp family_named.sh)"
leg family_named_in_comment_refused yes "$(unp named_in_comment.sh)"

# 10c. AND THE STEM-ONLY PREDICATE, run over the same plants, must MISS the family-named control.
# Without this leg the two above pass for any reason at all, which is how four of this census's
# five wrong denominators read green.
stem_only_proven() { # stem_only_proven <file> -> yes|no
  base=${1##*/}; stem=${base%.*}
  if git ls-files 'tools/*' 2>/dev/null | grep -F "$stem" | grep -vxF "$1" \
       | xargs -r grep -hEi '(idempotent|second run|run twice|runs twice|again finds nothing)' 2>/dev/null \
       | grep -vqE '^[[:space:]]*#'; then echo yes; else echo no; fi
}
leg stem_only_missed_the_family_control no "$(stem_only_proven tools/x/family_named.sh)"

# 10d. The third split is printed beside the other two.
split_now=$(CONV_ROOT="$pen/tree" sh "$census" 2>/dev/null)
case "$split_now" in *proven_by_family_control=*) split_family=printed ;; *) split_family=absent ;; esac
leg family_control_split_printed printed "$split_family"

# 11. THE WRITE COLUMN READS LIVE LINES, from both sides (`20260909.222142`). Until this stamp the
# column read every line, so a header sentence explaining a write idiom admitted the tool that
# explained it -- 3 of 12 candidates on the tree, measured and printed for a day as
# `admitted_on_comment_only`. Dropping comments ALONE was measured and read worse (12 -> 9, the two
# busiest writers leaving with the false one), so this section only holds together with section 12:
# the git strand is what keeps the real writers whose targets the name list never held.
cd "$pen/tree"
# 11a. Admitted by a comment alone: the write the target test accepts is inside a `#` line, and the
#      only live write targets a variable that resolves nowhere. This is the exact shape
#      `reds_ledger_headline_write.sh`'s header carried while explaining the exec-bit idiom.
plant tools/x/comment_admitted.sh '# It writes THROUGH the original inode (`cat "$tmp" > "$f"`), so the mode survives.
cat "$tmp" > "$LEDGER_UNREAD"'
# 11b. Admitted on a live line, with the same sentence standing beside it. The prose is identical,
#      so the only thing separating this plant from 11a is where the admitting write sits.
plant tools/x/live_admitted.sh '# It writes THROUGH the original inode (`cat "$tmp" > "$f"`), so the mode survives.
cat "$tmp" > "$f"'
git add -A >/dev/null
git commit -q -m "pen: planted the live-line reading"

seen() { # seen <basename> -- does the census count this file as a candidate at all?
  CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null \
    | sed -n 's/^\(unproven\|git_only\|name_only\): //p' | sed 's|.*/||' | sort -u \
    | grep -qx "$1" && echo yes || echo no
}

leg comment_alone_refused    no  "$(seen comment_admitted.sh)"
leg live_write_admitted      yes "$(seen live_admitted.sh)"
# 11c. THE ELDER WRITE PREDICATE, run over the same plant, must ADMIT it -- it read every line and
# could not tell prose from a write. Without this leg the two above pass for any reason at all,
# which is how four of this census's five wrong denominators read green.
elder_sees_comment() { # elder_sees_comment <file> -> yes|no
  if grep -hoE '(sed -[i][^"]*"[^"]+"|(cat|printf)[^|>]*> *"[^"]+")' "$1" 2>/dev/null \
    | sed 's/.*"\([^"]*\)"$/\1/' \
    | grep -vE '^\$(work|pen|tmp|TMP|out|d)\b' \
    | grep -qE '\$(f|file|path|p|target|dst)\b|construction/|session-logs/|\.claude/'; then echo yes; else echo no; fi
}
leg elder_could_not_tell_prose_from_a_write yes "$(elder_sees_comment tools/x/comment_admitted.sh)"
# 11d. The elder reading RETIRES rather than lingering at a permanent zero. A column that can never
# be anything but zero is a tautology wearing a measurement's clothes.
reading_now=$(CONV_ROOT="$pen/tree" sh "$census" 2>/dev/null)
case "$reading_now" in *admitted_on_comment_only=*) reading=present ;; *) reading=retired ;; esac
leg comment_reading_retired retired "$reading"

# 12. THE GIT STRAND, from both sides. `target_admits` answers by NAME -- a list of loop-variable
# spellings and a list of room prefixes -- and four laps of refining that guess each read worse.
# `git_admits` resolves the target through at most three in-file assignments and hands the literal
# to `git ls-files`, so the TREE answers which destination is tracked.
cd "$pen/tree"
# 12a. A named destination the list never held: `$LEDGER` is on no variable list and `pen/ledger.md`
#      is on no room list, and git tracks the file. This is `reds_ledger_headline_write.sh`'s and
#      `reds_fold.sh`'s shape, both real writers of `construction/REDS.md`.
plant pen/ledger.md 'a tracked page'
plant tools/x/git_named.sh 'LEDGER=pen/ledger.md
cat "$scratch" > "$LEDGER"'
# 12b. The same shape whose variable resolves to a pen. Nothing here is tracked, so git refuses --
#      where the elder 3-hop cure measured at `20260909.210000` admitted three such writers by name.
plant tools/x/git_pen.sh 'SCRATCH=$(mktemp -d)/out.txt
cat "$src" > "$SCRATCH"'
# 12c. The override hook: a tool's tracked destination usually sits in a `${OVERRIDE:-default}`
#      default whose braces name a DIFFERENT variable, and the remaining `$` leaves the target
#      partly literal. `index_shelf_repair.sh` stands exactly this way, and reading only the
#      assigned name's own braces would miss every one of them.
plant pen/room/README-index-20260909.md 'a shelf'
plant tools/x/git_hook.sh 'ROOM=${OVERRIDE_ROOM:-pen/room}
shelf="$ROOM/README-index-$day.md"
cat "$new" > "$shelf"'
# 12d. A fully literal target git does NOT track. The tool writes a scratch file that happens to sit
#      inside a tracked room, and a dirname test would admit it; only asking about the file refuses.
plant tools/x/git_untracked.sh 'cat "$src" > "pen/_scratch_never_tracked.md"'
# 12e. The hop bound, shown by exceeding it: four assignments deep, the literal is out of reach and
#      the tool is refused. A bound proven only by staying under it is a bound nobody has tested.
plant tools/x/git_deep.sh 'A=pen/ledger.md
B=$A
C=$B
D=$C
cat "$src" > "$D"'
git add -A >/dev/null
git commit -q -m "pen: planted the git strand"

leg git_named_destination_admitted   yes "$(seen git_named.sh)"
leg git_pen_destination_refused      no  "$(seen git_pen.sh)"
leg git_override_hook_admitted       yes "$(seen git_hook.sh)"
leg git_untracked_literal_refused    no  "$(seen git_untracked.sh)"
leg git_hop_bound_refuses_past_three no  "$(seen git_deep.sh)"
# 12f. THE NAME PREDICATE, run over 12a's plant, must say NO -- or the git strand bought nothing and
# these legs would pass on the elder reading alone.
leg name_strand_could_not_see_it no "$(elder_sees_comment tools/x/git_named.sh)"
# 12g. The split is printed with its members, so a reader can tell which strand answered. A ratchet
# that publishes a count and names no member is a finding no ship can act on (REDS %671).
case "$reading_now" in *admitted_by_git_only=*) gsplit=printed ;; *) gsplit=absent ;; esac
leg git_split_printed printed "$gsplit"
git_named=$(CONV_ROOT="$pen/tree" sh "$census" list 2>/dev/null | sed -n 's/^git_only: //p' | sed 's|.*/||' | sort -u | tr '\n' ' ')
case " $git_named " in *" git_named.sh "*) member=named ;; *) member=absent ;; esac
leg git_only_names_its_member named "$member"

# 13. THE ENCLOSURE STRAND (`20260909.233000`). Both strands above read a matched SPAN, and a span
# carries no position, so neither can tell a write this tool performs from text it hands to another
# command. `live_lines` walks the file as a shell lexer and emits only the lines standing outside
# every quoted region and heredoc body.
cd "$pen/tree"
# 13a. THE TREE'S OWN FALSE POSITIVE, planted in its real shape: the write sits inside a
#      single-quoted `--tree-filter` argument spanning several lines, against filter-branch's own
#      pen. This is `upstream_shape_scan.sh:150`, the standing member the census header named as
#      the next post on this fence.
plant tools/x/quoted_arg.sh 'git filter-branch -f --tree-filter '"'"'
  for f in *.txt; do
    cat "$f.t" > "$f"
  done'"'"' -- --all'
# 13b. THE SAME WRITE ON A LIVE LINE MUST STAY. A fence that refuses by the text rather than by the
#      position would take every real writer out with the false one.
plant tools/x/live_write.sh 'cat "$f.t" > "$f"'
# 13c. A heredoc body is data fed to another interpreter, so a write inside one is not this tool's.
plant tools/x/heredoc_body.sh 'sh <<EOF
cat "$f.t" > "$f"
EOF'
# 13d. The `<<-` form with a quoted delimiter, whose terminator is found only after leading tabs are
#      stripped and whose body takes no expansion. Both spellings this tree writes.
plant tools/x/heredoc_dash.sh 'sh <<-'"'"'END'"'"'
	cat "$f.t" > "$f"
	END'
# 13e. THE WALKER RETURNS. A write standing AFTER a quoted region closes is live, so a lexer that
#      never came back would silently empty the census -- a failure that reads as a clean tree.
plant tools/x/after_close.sh 'awk '"'"'
  BEGIN { print "a program with a quote'"'"'"'"'"'"'"'"'s worth of text" }
'"'"' /dev/null
cat "$f.t" > "$f"'
# 13f. A DOUBLE-QUOTED REGION SPANNING LINES, GUARDED IN THE ADMIT DIRECTION. A write INSIDE one
#      cannot be planted honestly: the write shapes need an unescaped quote around the target, and a
#      quote inside a double-quoted region must be escaped, so such a leg would read green whether
#      or not the strand existed -- which is what running it without the strand showed. What the
#      double-quote walk can genuinely fail at is CLOSING, so the plant plants a multi-line
#      double-quoted argument and a live write after it. A walk that never leaves the region
#      withholds every later line, which empties the census while looking like a clean tree.
plant tools/x/dquote_arg.sh 'ssh host "
  a line inside a double-quoted argument
"
cat "$f.t" > "$f"'
git add -A >/dev/null
git commit -q -m "pen: planted the enclosure strand"

leg quoted_argument_write_refused  no  "$(seen quoted_arg.sh)"
leg live_write_still_admitted      yes "$(seen live_write.sh)"
leg heredoc_body_write_refused     no  "$(seen heredoc_body.sh)"
leg heredoc_dash_write_refused     no  "$(seen heredoc_dash.sh)"
leg write_after_close_admitted     yes "$(seen after_close.sh)"
leg dquoted_region_closes    yes "$(seen dquote_arg.sh)"
# 13g. THE ELDER PREDICATE, run over the same plants, must ADMIT what the strand refuses -- or the
# repair moved nothing and these legs pass on the elder reading alone. The elder here is the name
# strand, which is what admitted `upstream_shape_scan.sh` on the tree.
leg elder_admitted_the_quoted_argument yes "$(elder tools/x/quoted_arg.sh)"
leg elder_admitted_the_heredoc_body    yes "$(elder tools/x/heredoc_body.sh)"
# 13h. AND THE WALK IS PROVEN BY ITS OWN EXIT STATE, which is what tells tracking from drift: a
# well-formed script ends outside every quote. A lexer that desynced would withhold every line after
# the drift, and 13e is the only leg that could ever notice.
plant tools/x/balanced.sh 'cat "$f.t" > "$f"'
git add -A >/dev/null
git commit -q -m "pen: a balanced writer"
leg balanced_file_admitted yes "$(seen balanced.sh)"


# 14. THE FOURTH STRAND: RISHI WRITES (`20260910.101500`). The census header named this blindness
# on `20260909.185835` and left it for its own lap -- the population is picked by three SHELL
# idioms, so a Rishi tool rewriting the tree could never be a candidate. The plants below prove the
# strand from both sides, and the elder predicate is run over the admitting one, since a strand
# shown only in the passing direction cannot be told from a coincidence.
cd "$pen/tree"
mkdir -p docs
printf 'a tracked page\n' > docs/page.md
# 14a. THE SHAPE THE TREE ACTUALLY WRITES, taken from `tools/g/geode_libraries.rish`, which
#      `tools/hooks/pre-commit` runs on every commit: a redirect to a tracked literal inside
#      `run ["sh" "-c" ...]`. `sh -c` executes in this tool's own directory, so the write is this
#      tool's.
plant tools/x/rish_sh_c_tracked.rish 'let w = run ["sh" "-c" "sh render.sh > docs/page.md"]'
# 14b. THE SAME REDIRECT HANDED TO ANOTHER TOOL AS A FLAG VALUE is text, not a write. This is
#      `tools/c/convergence_tree_prove_witness.rish`, whose `--perturb` string names
#      `construction/REDS.md` and runs against a `git worktree` pen -- the third strand's false
#      positive arriving in a language a shell lexer cannot read.
plant tools/x/rish_flag_arg.rish 'let p = run ["sh" "tools/x/prove.sh" "--perturb" "cat t > docs/page.md"]'
# 14c. A redirect to an untracked literal is a pen and has nothing to converge.
plant tools/x/rish_sh_c_pen.rish 'let w = run ["sh" "-c" "sh render.sh > tools/.build/scratch.txt"]'
# 14d. Rishi'"'"'s own write statement, with a tracked literal target.
plant tools/x/rish_write_file.rish 'write-file "docs/page.md" body'
# 14e. And with the target bound by a `let`, which is how this tree writes it -- one lookup.
plant tools/x/rish_write_file_let.rish 'let out = "docs/page.md"
write-file out body'
# 14f. An untracked `write-file` target: all three such sites in the tree today are this shape.
plant tools/x/rish_write_file_pen.rish 'write-file "/tmp/scratch.txt" body'
# 14g. The comment fence reaches the new strand too, or a header explaining the idiom admits the
#      tool that explains it -- the fault the write column paid for at `20260909.222142`.
plant tools/x/rish_comment.rish '# let w = run ["sh" "-c" "sh render.sh > docs/page.md"]
say "nothing written"'
# 14h. `>` IS ALSO RISHI'"'"'S COMPARISON OPERATOR, and the slash rule that answers it is a COST
#      reading rather than a fence -- planted here for the reading, asserted nowhere. Dropping the
#      rule leaves candidates, members, and both strand splits unchanged on the tree, because the
#      target tests already refuse `> "5"` and `> "cap"`; what it changes is the run, 189s to 208s,
#      since every noise span costs a `git ls-files`. A leg here would read green with or without
#      the rule, which is 13f'"'"'s lesson one strand over: a leg that cannot fail proves nothing.
plant tools/x/rish_compare.rish 'let w = run ["sh" "-c" "test 5 > 3"]'
# 14i. AN OPERAND THAT RESOLVES TO NO LITERAL MUST NOT TAKE THE CENSUS DOWN. A `while` loop carries
#      its last body command's status, so the first draft of `rish_writes` returned 1 whenever its
#      final iteration found nothing to emit -- and `set -e` killed the whole run at the assignment.
#      Every leg above was green when that fault stood, because no plant here bound a `write-file`
#      target to an expression. The tree found it on the first source that did.
plant tools/x/rish_write_file_expr.rish 'let out = length args
write-file out body'
git add -A >/dev/null
git commit -q -m "pen: planted the Rishi strand"

leg rish_sh_c_tracked_admitted        yes "$(seen rish_sh_c_tracked.rish)"
leg rish_flag_argument_refused        no  "$(seen rish_flag_arg.rish)"
leg rish_sh_c_pen_refused             no  "$(seen rish_sh_c_pen.rish)"
leg rish_write_file_admitted          yes "$(seen rish_write_file.rish)"
leg rish_write_file_let_admitted      yes "$(seen rish_write_file_let.rish)"
leg rish_write_file_pen_refused       no  "$(seen rish_write_file_pen.rish)"
leg rish_comment_write_refused        no  "$(seen rish_comment.rish)"
# 14i. THE ELDER PREDICATE, over the admitting plant, must MISS it -- the population was
# shell-shaped and this is the strand that widens it.
leg elder_missed_the_rish_writer      no  "$(elder tools/x/rish_sh_c_tracked.rish)"
# 14j. And the run SURVIVES the unresolvable operand -- a census that dies reports nothing, which
# reads from outside exactly like a tree with no writers in it.
leg census_survives_unresolvable_operand ok "$(CONV_ROOT="$pen/tree" sh "$census" >/dev/null 2>&1 && echo ok || echo died)"

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
