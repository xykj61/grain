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
# THE ROOM WRITES A SECOND SHAPE, and this read it as nothing for a day (20260910). A page may
# quote SOME of a longer report, and it says so in a sentence sitting between the two blocks --
# "Two lines from the full output:". The elder parser ended the candidate at that sentence, so the
# same 38 pages hold NINE pairs where six were being read. A selection declares itself the way a
# volatile block does, with a reason, and is checked by CONTAINMENT IN ORDER: every quoted line
# appears in what ran, in the order the page prints them.
#
#     <!-- selected: two lines of a longer report -->
#
# Order is part of the claim rather than a convenience. A page listing a verdict above the count
# that produced it teaches the output's shape wrongly even when both lines are present, and the pen
# proves that strand alone -- remove it and exactly one leg reds.
#
# CONTAINMENT IN ORDER SAYS NOTHING ABOUT WHAT STANDS BETWEEN. A page may quote four lines that all
# print, in the order it prints them, and pass over a refusal standing in the middle of the run --
# and every reading above would call that clean. So each selection is read a second time for its
# SHAPE: one unbroken run of the real output, or a gathering of lines that stand apart. The test
# tries every start position in what ran, so the answer is outright and no alignment has to be
# chosen between. `selected_contiguous` and `selected_scattered` carry the two counts, and the
# lines standing inside a gathering are named, six of them, so a reader can weigh what the page
# passes over.
#
# `selected_scattered` is a ceiling rather than a zero, because gathering is what a selection is
# FOR -- the demos room's announced-length pair quotes one `met:` line and the three summary lines
# beneath four further `met:` lines, and that is an honest thing for a page to do. It falls on
# repair and rises only when a hand adds a new declared selection, an edit standing in the same
# commit as the page. What it refuses in silence is the case the ceiling exists for: a selection
# reading as one run today with a line inserted into the middle of it tomorrow. A count of the
# skipped LINES would have been the wrong instrument, since `announced_length_scan` prints one more
# line for every ladder anybody announces, so that ceiling would red on a page nobody touched.
#
# PROSE WITH NOTHING DECLARING IT is counted as `undeclared_after_prose` and named, never checked
# and never gated, because the sentence between the blocks is load-bearing and says which of three
# different things the second block is: a subset of this output, the output of ANOTHER invocation,
# or an unrelated listing. Those want three different tests, and guessing among them would invent
# claims the writer never made. The first hour holds a real reattribution -- its "run it twice"
# block belongs to a different command -- so the caution is right and only its silence was wrong.
# A block nothing reads and a block nothing MAY read read alike from outside; one is a gap.
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
# WHAT A DANGLING COMMAND FENCE ATE, repaired `20260911`. The parser reads any ``` line arriving
# after a command fence as the end of a pair that produced no output -- and a ```sh line matches
# that rule. So a command promising nothing SWALLOWED the next command, whole output block and
# all, and the swallowed pair was counted nowhere. A command fence now opens its own pair from
# that state.
#
# THE PAGE IT COST, measured rather than supposed. `docs-geode/demos/README.md` check 3 quotes
# eight lines of `room_bound_scan.sh`, and stood in NO pair -- because check 2 closes with a
# witness invocation that quotes nothing after it, and that fence ate check 3. One of those eight
# lines had gone stale by 197, `flat=713` against a tree reading 910, on the shipping shelf's own
# demonstration page. The guard whose entire job is that reading had never seen the block.
#
# WHY SECTION 10 OF THE CONTROL DID NOT CATCH IT. It proves a lone command fence counts nothing,
# which is true and is the cheaper question. What it never asked is what that fence does to what
# FOLLOWS it -- presence standing in for effect, the shape this shelf has now met three times.
# Section 10a asks the second question from both sides: a dangling fence between two real pairs
# reads 2, and reads 2 with the dangling fence lifted, so the pen is proven innocent of the count.
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

# How far an output fence may sit from the command it belongs to. Twelve lines is about a screen
# of prose: past that a reader has stopped holding the command in their eye, so a block that far
# down is making its own claim rather than answering the one above.
MAX_GAP_LINES=${TUTORIAL_OUTPUT_MAX_GAP_LINES:-12}

# How many declared selections may be gathered from lines that stand apart rather than quoted as
# one unbroken run. One at seating 20260910: the announced-length pair in the demos room quotes a
# single `met:` line and then the three summary lines, with four further `met:` lines between them.
# The fascia pair beside it quotes two adjacent lines and reads contiguous.
#
# It falls on repair -- a page that quotes a whole run instead of a gathering lowers it -- and it
# rises only when a hand adds a new declared selection, which is an edit standing in the same
# commit as the page. What it refuses in silence is the case worth refusing: a selection that reads
# as one run today and has a line inserted into the middle of it tomorrow.
SCATTERED_CEILING=${TUTORIAL_OUTPUT_SCATTERED_CEILING:-1}

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
# invariant: a pair is a `sh` fence, its close, then within MAX_GAP_LINES an unlabelled fence.
# Blank lines and declaration comments always carry across the gap. PROSE carries across it only
# when the page declares what the prose is doing, because prose between the two blocks is
# load-bearing and says which of three different things the second block is -- see the header.
: > "$work/index.txt"
n=0
while IFS= read -r page; do
  [ -f "$page" ] || continue
  n=$(awk -v pen="$work" -v page="$page" -v start="$n" -v maxgap="$MAX_GAP_LINES" '
    BEGIN { n = start; state = 0; vol = ""; sel = ""; prose = 0; gap = 0 }
    state == 0 && $0 == "```sh" { state = 1; cmd = ""; cmdline = NR; next }
    state == 1 && $0 == "```"   { state = 2; vol = ""; sel = ""; prose = 0; gap = 0; next }
    state == 1                  { cmd = cmd $0 "\n"; next }
    state == 2 && $0 == ""      { gap++; if (gap > maxgap) state = 0; next }
    state == 2 && $0 ~ /^<!-- volatile:.*-->$/ {
      v = $0
      sub(/^<!-- volatile:[ \t]*/, "", v); sub(/[ \t]*-->$/, "", v)
      if (v != "") vol = v
      gap++; if (gap > maxgap) state = 0
      next
    }
    state == 2 && $0 ~ /^<!-- selected:.*-->$/ {
      v = $0
      sub(/^<!-- selected:[ \t]*/, "", v); sub(/[ \t]*-->$/, "", v)
      if (v != "") sel = v
      gap++; if (gap > maxgap) state = 0
      next
    }
    # A COMMAND FENCE ARRIVING HERE OPENS ITS OWN PAIR rather than closing the dangling one.
    # The generic fence rule below reads any ``` line as the end of a pair that produced no
    # output, and a ```sh line matches it -- so a command promising no output SWALLOWED the next
    # command, whole output block and all. See the header, WHAT A DANGLING COMMAND FENCE ATE.
    state == 2 && $0 == "```sh" { state = 1; cmd = ""; cmdline = NR; next }
    state == 2 && $0 == "```"   { state = 3; out = ""; next }
    state == 2 && $0 ~ /^```/   { state = 0; next }
    state == 2                  { prose++; gap++; if (gap > maxgap) state = 0; next }
    state == 3 && $0 == "```"   {
      n++
      printf "%s", cmd > (pen "/pair." n ".cmd")
      printf "%s", out > (pen "/pair." n ".out")
      printf "%s\t%s\t%s\t%s\t%s\n", page, cmdline, vol, sel, prose >> (pen "/index.txt")
      state = 0; next
    }
    state == 3                  { out = out $0 "\n"; next }
    END { print n }
  ' "$page")
done < "$work/pages.txt"

pairs=$n
echo "pairs=$pairs"

# ---- classify and run --------------------------------------------------------------------------
checked=0; exact=0; drift=0; volatile=0; held=0; selected=0; undeclared=0
contiguous=0; scattered=0
: > "$work/lines.txt"

i=0
while [ "$i" -lt "$pairs" ]; do
  i=$((i + 1))
  meta=$(sed -n "${i}p" "$work/index.txt")
  page=$(printf '%s' "$meta" | cut -f1)
  line=$(printf '%s' "$meta" | cut -f2)
  vol=$(printf '%s' "$meta" | cut -f3)
  sel=$(printf '%s' "$meta" | cut -f4)
  prose=$(printf '%s' "$meta" | cut -f5)

  # Prose between the blocks, with nothing declaring what it does. The page may be reattributing
  # the output to another invocation, quoting a subset, or setting two unrelated blocks side by
  # side, and those want three different tests. Reported and named rather than checked or held,
  # so the population is visible: a block nothing reads and a block nothing MAY read read alike
  # from outside, and only one of them is a gap.
  if [ "${prose:-0}" -gt 0 ] && [ -z "$sel" ] && [ -z "$vol" ]; then
    undeclared=$((undeclared + 1))
    printf '%s:%s\tundeclared_after_prose\t%s\n' "$page" "$line" \
      "$prose line(s) of prose sit between the command and the block; declare selected or volatile to have it read" \
      >> "$work/lines.txt"
    continue
  fi

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

  # A declared selection quotes SOME of the output, so equality is the wrong test and containment
  # is the right one: every quoted line must appear in what ran, in the order the page prints
  # them. Order matters -- a page that lists a verdict above the count that produced it is
  # teaching the output's shape wrongly even when both lines are present.
  if [ -n "$sel" ]; then
    selected=$((selected + 1))
    if awk '
      NR == FNR { want[++w] = $0; next }
      k < w && $0 == want[k + 1] { k++ }
      END { exit(k == w ? 0 : 1) }
    ' "$work/pair.$i.out" "$work/pair.$i.got"; then
      exact=$((exact + 1))

      # SHAPE. Containment in order says every quoted line printed; it says nothing about what
      # stands BETWEEN them. A page may quote four lines that all print, in the order it prints
      # them, and pass over a refusal standing in the middle of the run. So each selection is read
      # a second time for its shape: is the quoted block one unbroken run of the real output, or
      # is it gathered from lines that stand apart? The test tries every start position in what
      # ran, which answers the question outright and leaves no alignment to choose between.
      if awk '
        NR == FNR { want[++w] = $0; next }
        { got[++g] = $0 }
        END {
          for (s = 1; s + w - 1 <= g; s++) {
            hit = 1
            for (j = 1; j <= w; j++) if (got[s + j - 1] != want[j]) { hit = 0; break }
            if (hit) exit 0
          }
          exit 1
        }
      ' "$work/pair.$i.out" "$work/pair.$i.got"; then
        contiguous=$((contiguous + 1))
        printf '%s:%s\texact\tselected (one unbroken run): %s\n' "$page" "$line" "$sel" \
          >> "$work/lines.txt"
      else
        scattered=$((scattered + 1))
        printf '%s:%s\texact\tselected (gathered from lines that stand apart): %s\n' \
          "$page" "$line" "$sel" >> "$work/lines.txt"
        # What stands between them, named so a reader can weigh it. The positions come from the
        # first alignment reading left to right, which is one alignment among the several a
        # repeated line could allow -- so this block informs and the shape reading above gates.
        # Six is enough to show a reader what kind of line they are passing over.
        awk '
          NR == FNR { want[++w] = $0; next }
          { got[++g] = $0 }
          END {
            k = 0
            for (i = 1; i <= g && k < w; i++) if (got[i] == want[k + 1]) pos[++k] = i
            if (k < w) exit 0
            n = 0
            for (i = pos[1]; i <= pos[w]; i++) {
              q = 0
              for (j = 1; j <= w; j++) if (pos[j] == i) { q = 1; break }
              if (q) continue
              n++
              if (n <= 6) print "-- stands between the quoted lines: " got[i]
            }
            if (n > 6) print "-- and " (n - 6) " further line(s) between them"
          }
        ' "$work/pair.$i.out" "$work/pair.$i.got" > "$work/shape.txt"
        sed "s|^|shape: $page:$line |" "$work/shape.txt" >> "$work/shapes.txt"
      fi
    else
      drift=$((drift + 1))
      printf '%s:%s\tdrift\t%s\n' "$page" "$line" \
        "declared a selection of $(wc -l < "$work/pair.$i.out" | tr -d ' ') lines; not all of them printed, in order" \
        >> "$work/lines.txt"
      # This awk PRODUCES OUTPUT rather than answering by its exit, so any non-zero is a failure
      # and saying so beats printing a detail block nobody can tell from an empty one.
      if awk '
        NR == FNR { seen[$0] = 1; next }
        !($0 in seen) { print "-- never printed: " $0 }
      ' "$work/pair.$i.got" "$work/pair.$i.out" > "$work/detail.txt"; then
        sed "s|^|detail: $page:$line |" "$work/detail.txt" >> "$work/diffs.txt"
      else
        echo "detail: $page:$line -- the line-comparison pass could not run; its reason is above" \
          >> "$work/diffs.txt"
      fi
    fi
    continue
  fi

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
    # diff answers by exiting: 0 the same, 1 they differ -- which is why we are here -- and 2 or
    # more is trouble. Tolerating 1 is reading the instrument; tolerating 2 would discard it.
    diff "$work/pair.$i.out" "$work/pair.$i.got" > "$work/detail.txt" 2>/dev/null
    diff_status=$?
    if [ "$diff_status" -le 1 ]; then
      sed "s|^|detail: $page:$line |" "$work/detail.txt" >> "$work/diffs.txt"
    else
      echo "detail: $page:$line -- diff could not compare the two blocks (exit $diff_status)" \
        >> "$work/diffs.txt"
    fi
  fi
done

if [ "$verb" = "list" ]; then
  cat "$work/lines.txt"
  exit 0
fi

echo "checked=$checked"
echo "exact=$exact"
echo "selected=$selected"
echo "selected_contiguous=$contiguous"
echo "selected_scattered=$scattered"
echo "scattered_ceiling=$SCATTERED_CEILING"
echo "volatile=$volatile"
echo "drift=$drift"
echo "held=$held"
echo "held_ceiling=$HELD_CEILING"
echo "undeclared_after_prose=$undeclared"

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

if [ "$scattered" -gt "$SCATTERED_CEILING" ]; then
  [ -f "$work/shapes.txt" ] && cat "$work/shapes.txt"
  echo "verdict=a_selection_broke_its_run"
  exit 6
fi

[ -f "$work/shapes.txt" ] && cat "$work/shapes.txt"

echo "verdict=every_quoted_block_still_prints"
exit 0
