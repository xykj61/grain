#!/bin/sh
# tools/fixtures/t/tutorial_output_scan.sh -- a quoted output block is a claim about behavior,
# and this runs the command above it to see whether the claim still holds.
#
# WHY. A tutorial teaches by promising what a reader will see. `docs-geode/tutorials/the-first-hour.md`
# quoted a three-line ending for its toolchain fetch where the command prints four, and the page
# read Truth 100 the whole time (20260909.174000): qa_report_card scores Truth by whether cited
# PATHS resolve, document_mirror_scan proves two homes hold identical bytes, and a fenced block
# holds neither a path nor a mirror. So the one sentence a tutorial exists to make -- here is what
# you will see -- was the one sentence nothing in this tree read.
#
# THE CONVENTION IT READS, which the docs-geode room already writes. A fence opened `sh`, then its
# close, then an unlabelled fence: the second block is what the first block prints. Measured over
# the 38 tracked docs-geode pages at seating, 17 fences open `sh` and 6 of them carry an output
# fence, so the shape is the room's habit rather than a shape invented here.
#
# WHAT IS GATED, hard, at zero: `drift` -- a pair whose command ran and printed something other
# than what the page quotes. That is the fault this exists to catch.
#
# WHAT RUNS, and why the roster is this narrow. A pair is CHECKED only when every command line in
# its `sh` fence is one plain invocation of `rishi/bin/rishi` (with or without `run`) or `sh`,
# naming a TRACKED script, with no redirect, pipe, semicolon, ampersand, backtick, dollar sign, or
# glob anywhere on the line. The test is on what EXECUTES rather than on what it is handed: the
# resolver in `docs-geode/demos/README.md` is passed a deliberately stale address that no longer
# exists, and holding that pair back would drop the very case the page was written to show.
#
# WHAT IS HELD, counted and named rather than run: everything else. A fence that makes a directory,
# writes a file, exports a variable, or names a script the reader is about to write themselves --
# `first.rish` in step 6 of the first hour -- runs nothing here. Held is a ratchet under a ceiling
# that only falls, so the population is visible rather than silently uncovered.
#
# A BLOCK THAT HONESTLY MOVES DECLARES ITSELF. Put an HTML comment on the line before the output
# fence:
#
#     <!-- volatile: this count moves as the tree grows -->
#
# The pair still runs and still reports; it never gates. The reason is required, because the tree's
# own habit is to say why beside every exemption, and an undeclared moving block is exactly the
# drift this guard is for.
#
# WHAT THIS DOES NOT REACH, said plainly. It reads stdout alone. A page quotes what a reader sees
# on a good run, and interleaving two streams gives an order that depends on buffering rather than
# on the program -- so a command whose claim lives on stderr is invisible here. It reads only the
# pairs the room already writes: a command with no output fence promises nothing and is not
# counted. And it proves the OUTPUT of a command, never that the command is the right one to teach.
#
#
# NOT tools/d/docs_command_path_witness.rish, which stands beside it in the same room and does a
# different job: that one proves every path printed inside a fenced block RESOLVES for a reader who
# clones, after a folded room left two pages naming a file at its elder address. This one proves
# what a command PRINTS. A page can name paths that all resolve and still promise output no command
# produces -- which is exactly what the first hour did. Two jobs, two names.
# USAGE
#   sh tools/fixtures/t/tutorial_output_scan.sh          # report on this tree
#   sh tools/fixtures/t/tutorial_output_scan.sh list     # every pair, one per line, with verdict
#
# Driven by tools/t/tutorial_output_witness.rish. Pen: tools/fixtures/t/tutorial_output_control.sh.
# Run from the repository root.

set -u

verb=${1:-report}

# The ceiling only falls. Held pairs at seating 20260909: two -- the sha3 demo, which makes a
# directory and writes a file, and step 6 of the first hour, whose script the reader writes.
HELD_CEILING=${TUTORIAL_OUTPUT_HELD_CEILING:-2}

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "verdict=not_a_git_tree"
  echo "refused: this scan reads the tracked corpus and there is no git tree here" >&2
  exit 1
fi

# The corpus. docs-geode is the shipping shelf -- the pages a newcomer meets -- and the room whose
# fence convention this reads. A page elsewhere writing the same shape is out of reach on purpose:
# a guard widened past the habit it was built on starts guessing.
CORPUS=${TUTORIAL_OUTPUT_CORPUS:-docs-geode}
git ls-files "$CORPUS/*.md" 2>/dev/null > "$work/pages.txt" || : > "$work/pages.txt"
pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
echo "pages_considered=$pages"

# ---- parse: pull every (command, output) pair into the pen ------------------------------------
# invariant: a pair is a `sh` fence, its close, blank lines only, then an unlabelled fence. Any
# other line between them ends the candidate, because prose between the two blocks means the page
# is saying something the parser cannot read.
: > "$work/index.txt"
n=0
while IFS= read -r page; do
  [ -f "$page" ] || continue
  n=$(awk -v pen="$work" -v page="$page" -v start="$n" '
    BEGIN { n = start; state = 0; vol = "" }
    state == 0 && $0 == "```sh" { state = 1; cmd = ""; cmdline = NR; next }
    state == 1 && $0 == "```"   { state = 2; vol = ""; next }
    state == 1                  { cmd = cmd $0 "\n"; next }
    state == 2 && $0 == ""      { next }
    state == 2 && $0 ~ /^<!-- volatile:.*-->$/ {
      v = $0
      sub(/^<!-- volatile:[ \t]*/, "", v); sub(/[ \t]*-->$/, "", v)
      if (v != "") vol = v
      next
    }
    state == 2 && $0 == "```"   { state = 3; out = ""; next }
    state == 2                  { state = 0; next }
    state == 3 && $0 == "```"   {
      n++
      printf "%s", cmd > (pen "/pair." n ".cmd")
      printf "%s", out > (pen "/pair." n ".out")
      printf "%s\t%s\t%s\n", page, cmdline, vol >> (pen "/index.txt")
      state = 0; next
    }
    state == 3                  { out = out $0 "\n"; next }
    END { print n }
  ' "$page")
done < "$work/pages.txt"

pairs=$n
echo "pairs=$pairs"

# ---- classify and run --------------------------------------------------------------------------
checked=0; exact=0; drift=0; volatile=0; held=0
: > "$work/lines.txt"

i=0
while [ "$i" -lt "$pairs" ]; do
  i=$((i + 1))
  meta=$(sed -n "${i}p" "$work/index.txt")
  page=$(printf '%s' "$meta" | cut -f1)
  line=$(printf '%s' "$meta" | cut -f2)
  vol=$(printf '%s' "$meta" | cut -f3)

  # Is every command line on the safe roster?
  safe=yes
  while IFS= read -r c; do
    [ -n "$c" ] || continue
    c=${c%%#*}                                   # a trailing comment is a reader's aside
    case "$c" in *[\|\&\;\<\>\`\$\*\?]*) safe=no; break ;; esac
    set -- $c
    [ "$#" -ge 1 ] || continue
    prog=$1; shift
    case "$prog" in
      rishi/bin/rishi) [ "${1:-}" = "run" ] && shift ;;
      sh) : ;;
      *) safe=no; break ;;
    esac
    script=${1:-}
    if [ -z "$script" ] || ! git ls-files --error-unmatch "$script" >/dev/null 2>&1; then
      safe=no; break
    fi
  done < "$work/pair.$i.cmd"

  if [ "$safe" = no ]; then
    held=$((held + 1))
    printf '%s:%s\theld\t%s\n' "$page" "$line" "the fence is outside the run roster" >> "$work/lines.txt"
    continue
  fi

  : > "$work/pair.$i.got"
  while IFS= read -r c; do
    [ -n "$c" ] || continue
    c=${c%%#*}
    # shellcheck disable=SC2086
    timeout 120 sh -c "exec $c" >> "$work/pair.$i.got" 2>/dev/null
  done < "$work/pair.$i.cmd"

  checked=$((checked + 1))
  if cmp -s "$work/pair.$i.got" "$work/pair.$i.out"; then
    exact=$((exact + 1))
    printf '%s:%s\texact\t\n' "$page" "$line" >> "$work/lines.txt"
  elif [ -n "$vol" ]; then
    volatile=$((volatile + 1))
    printf '%s:%s\tvolatile\t%s\n' "$page" "$line" "$vol" >> "$work/lines.txt"
  else
    drift=$((drift + 1))
    printf '%s:%s\tdrift\t%s\n' "$page" "$line" \
      "quoted $(wc -l < "$work/pair.$i.out" | tr -d ' ') lines, printed $(wc -l < "$work/pair.$i.got" | tr -d ' ')" \
      >> "$work/lines.txt"
    diff "$work/pair.$i.out" "$work/pair.$i.got" 2>/dev/null \
      | sed "s|^|detail: $page:$line |" >> "$work/diffs.txt" || true
  fi
done

if [ "$verb" = "list" ]; then
  cat "$work/lines.txt"
  exit 0
fi

echo "checked=$checked"
echo "exact=$exact"
echo "volatile=$volatile"
echo "drift=$drift"
echo "held=$held"
echo "held_ceiling=$HELD_CEILING"

if [ "$pairs" -eq 0 ]; then
  echo "verdict=no_pairs_read"
  echo "refused: a meter reading an empty corpus reports clean while proving nothing" >&2
  exit 3
fi

if [ "$drift" -ne 0 ]; then
  awk -F'\t' '$2 == "drift" { print "detail: " $1 " -- " $3 }' "$work/lines.txt"
  [ -f "$work/diffs.txt" ] && cat "$work/diffs.txt"
  echo "verdict=a_quoted_block_no_longer_matches"
  exit 4
fi

if [ "$held" -gt "$HELD_CEILING" ]; then
  echo "verdict=held_above_ceiling"
  exit 5
fi

echo "verdict=every_quoted_block_still_prints"
exit 0
