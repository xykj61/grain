#!/bin/sh
# convergence_prove_control.sh -- the convergence prover proven on tools built to pass and to fail.
#
# A prover that only ever sees converging tools has proven nothing about its own teeth, so the pen
# here builds a DIVERGING tool on purpose and requires the prover to catch it.
#
#   sh tools/fixtures/c/convergence_prove_control.sh
#
# Prints `pass=N fail=N`. Bounded: 32 cases, one pen.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
prove="$root/tools/c/convergence_prove.sh"
pen=${TMPDIR:-/tmp}/conv-prove-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

# A CONVERGING tool: it replaces a marker with a settled form, and the settled form matches nothing.
# THE PLANTED TOOL WRITES PORTABLY, because `shell_dialect` gates the in-place flag at zero and a
# pen file is still a tracked line in this control. GNU and BSD spell that flag differently, which
# is why this tree writes a temporary and moves it through the original inode instead.
cat > "$pen/good.sh" <<'G'
#!/bin/sh
sed 's/DASH/--/g' "$1" > "$1.tmp" && cat "$1.tmp" > "$1" && rm -f "$1.tmp"
G
# A DIVERGING tool: every run appends, so the second run never equals the first.
cat > "$pen/bad.sh" <<'B'
#!/bin/sh
echo "another line" >> "$1"
B
# An INERT case is the same good tool given a sample holding nothing to change.
chmod +x "$pen/good.sh" "$pen/bad.sh"
printf 'a DASH here\n' > "$pen/work.md"
printf 'nothing to do here\n' > "$pen/quiet.md"
# A tool that REFUSES outright.
cat > "$pen/refuser.sh" <<'R'
#!/bin/sh
echo "refused: on purpose" >&2
exit 2
R
# TWO SECOND-RUN REFUSALS, one holding the file and one writing before it refuses. Until
# `20260909.163208` both read `refused_on_second -- the sharpest kind of divergence`, and only the
# second one is that: a tool refusing to overwrite its own immutable output corrupts nothing.
cat > "$pen/sour.sh" <<'S'
#!/bin/sh
if grep -q SOURED "$1"; then echo "refused: I will not read my own work" >&2; exit 1; fi
echo SOURED >> "$1"
S
cat > "$pen/sour_mutating.sh" <<'X'
#!/bin/sh
if grep -q SOURED "$1"; then echo "and another" >> "$1"; echo "refused: after I wrote again" >&2; exit 1; fi
echo SOURED >> "$1"
X
chmod +x "$pen/refuser.sh" "$pen/sour.sh" "$pen/sour_mutating.sh"

out=$(sh "$prove" "$pen/good.sh" "$pen/work.md" 2>&1) || true
check "a converging tool converges"    yes "$(has "$out" 'verdict=converges')"
check "and it names the tool"          yes "$(has "$out" "tool=$pen/good.sh")"

out=$(sh "$prove" "$pen/bad.sh" "$pen/work.md" 2>&1) || true
check "a diverging tool is caught"     yes "$(has "$out" 'verdict=diverges')"
check "and the diff is shown"          yes "$(has "$out" 'another line')"

out=$(sh "$prove" "$pen/good.sh" "$pen/quiet.md" 2>&1) || true
check "an inert sample is named inert" yes "$(has "$out" 'verdict=inert')"
check "rather than counted as a pass"  no  "$(has "$out" 'verdict=converges')"

out=$(sh "$prove" "$pen/refuser.sh" "$pen/work.md" 2>&1) || true
check "a refusing tool is not a pass"  yes "$(has "$out" 'verdict=refused')"

out=$(sh "$prove" "$pen/sour.sh" "$pen/work.md" 2>&1) || true
check "a refusal holding the file"     yes "$(has "$out" 'verdict=refused_on_second_file_held')"
check "is not called the sharpest"     no  "$(has "$out" 'verdict=refused_on_second
')"
check "and the refusal is shown"       yes "$(has "$out" 'I will not read my own work')"
check "nor read as a pass"             no  "$(has "$out" 'verdict=converges')"

out=$(sh "$prove" "$pen/sour_mutating.sh" "$pen/work.md" 2>&1) || true
check "writing then refusing is sharp" yes "$(has "$out" 'verdict=refused_on_second
')"
check "and its own line is shown"      yes "$(has "$out" 'and another')"

# THE SUBJECT IS A COPY: the sample on disk must be untouched by any of the runs above.
check "the sample is never mutated"    yes "$(has "$(cat "$pen/work.md")" 'a DASH here')"

if sh "$prove" "$pen/good.sh" 2>/dev/null; then
  check "a missing sample refuses" refused accepted
else
  check "a missing sample refuses" refused refused
fi
if sh "$prove" "$pen/nosuch.sh" "$pen/work.md" 2>/dev/null; then
  check "a missing tool refuses"   refused accepted
else
  check "a missing tool refuses"   refused refused
fi

# A REAL TRACKED WRITER ON A REAL SAMPLE, so the prover is exercised against the tree rather than
# only against tools this pen invented. An em dash is written as raw bytes here for the same reason
# the rule's own table exists.
printf 'an em dash \342\200\224 and an ellipsis \342\200\246 here\n' > "$pen/real.md"
out=$(sh "$prove" "$root/tools/fixtures/a/ascii_document_convert.sh" "$pen/real.md" 2>&1) || true
check "a tracked writer converges"     yes "$(has "$out" 'verdict=converges')"
check "and its sample was not inert"   no  "$(has "$out" 'verdict=inert')"
# SAID OUT LOUD, because `check` prints only on failure. A witness asserting on a check's message
# would be asserting on text that appears ONLY when the control is broken -- an assertion that
# passes when the thing it guards fails. Caught while writing this file's own witness.
echo "coverage: a tracked tree writer was exercised on a real sample, and both second-run refusals -- one holding the file, one writing before it refused -- were told apart"

# THE LANGUAGE LEG. Every tool this pen plants is a shell script, so the prover's own `sh <tool>`
# invocation was never pressed -- and this tree writes 2,450 tracked `.rish` sources against 939
# `.sh`, with a standing law molting an operational shell script to Rishi on substantial touch. A
# stand-in population narrower in LANGUAGE than the answerers proves the asker against a world that
# does not exist, which is `%668`'s sentence one language over.
cat > "$pen/good.rish" <<'G'
let p = args[0]
let body = read-file p
if body contains "SETTLED" then exit exit-ok
let nl = (run ["printf" "\n"]).out
write-file p "${body}SETTLED${nl}"
G
printf 'a line here\n' > "$pen/rish_work.md"
out=$(sh "$prove" "$pen/good.rish" "$pen/rish_work.md" 2>&1) || true
check "a Rishi tool converges"         yes "$(has "$out" 'verdict=converges')"
check "rather than reading as refused" no  "$(has "$out" 'verdict=refused')"
check "and the sample is never mutated" no "$(has "$(cat "$pen/rish_work.md")" 'SETTLED')"

# BOTH DIRECTIONS. The elder prover is this one with the Rishi branch of `run_subject` deleted -- a
# single line -- so what the pair measures is the dispatch and nothing beside it.
sed '/\*\.rish) "\$RISHI_BIN" run/d' "$prove" > "$pen/shellonly_prove.sh"
out=$(sh "$pen/shellonly_prove.sh" "$pen/good.rish" "$pen/rish_work.md" 2>&1) || true
check "the shell-only prover cannot"   no  "$(has "$out" 'verdict=converges')"

# THE BESIDE LEGS. Until `20260910` the prover compared the subject and nothing else, and it
# invoked the tool at its path in the REAL tree -- so a tool resolving its own root from `$0` wrote
# into the checkout of whoever ran the prover, and the reading came back `inert`. Both halves are
# pressed here: the write must be SEEN, and it must land inside the pen.
mkdir -p "$pen/deep/tools/z"
cat > "$pen/deep/tools/z/rooted.sh" <<'E'
#!/bin/sh
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
printf 'escaped\n' > "$ROOT/escape_marker.txt"
E
chmod +x "$pen/deep/tools/z/rooted.sh"
rm -f "$pen/deep/escape_marker.txt"
out=$(sh "$prove" "$pen/deep/tools/z/rooted.sh" "$pen/quiet.md" 2>&1) || true
check "a beside-write is not inert"    no  "$(has "$out" 'verdict=inert')"
check "it is named wrote_beside"       yes "$(has "$out" 'verdict=wrote_beside')"
check "nor is it read as a pass"       no  "$(has "$out" 'verdict=converges')"
check "and the beside path is shown"   yes "$(has "$out" 'escape_marker.txt')"
check "the tool cannot leave the pen"  no  "$(has "$(ls "$pen/deep" 2>&1)" 'escape_marker.txt')"

# A SECOND-RUN beside-write: the subject converges and the tool does not, which the run-1 check
# alone would read as `converges`.
cat > "$pen/late.sh" <<'L'
#!/bin/sh
d=$(dirname "$1")
if grep -q LATE "$1"; then printf 'x\n' > "$d/late_marker.txt"; exit 0; fi
echo LATE >> "$1"
L
chmod +x "$pen/late.sh"
printf 'a line\n' > "$pen/late_work.md"
out=$(sh "$prove" "$pen/late.sh" "$pen/late_work.md" 2>&1) || true
check "a late beside-write is caught"  yes "$(has "$out" 'verdict=wrote_beside')"
check "rather than reading converges"  no  "$(has "$out" 'verdict=converges')"

# BOTH DIRECTIONS, on the elder shape. The elder prover is this one with the beside comparison
# defeated -- `beside_paths` made to answer empty -- so what the pair measures is that comparison
# and nothing beside it.
sed 's|^  diff -r "$pen/root_before" "$pen/root" 2>&1 . head -12|  :|' "$prove" > "$pen/blind_prove.sh"
out=$(sh "$pen/blind_prove.sh" "$pen/deep/tools/z/rooted.sh" "$pen/quiet.md" 2>&1) || true
check "the blind prover reads inert"   yes "$(has "$out" 'verdict=inert')"
check "and never says wrote_beside"    no  "$(has "$out" 'verdict=wrote_beside')"
# AND THE PEN COPY ITSELF, both ways. The elder prover ran the tool at its own path, so `$0`
# resolved into the caller's checkout. Defeating only the comparison above leaves that half unpressed,
# so a second mutation puts the real-tree invocation back and the escape is watched for.
rm -f "$pen/deep/escape_marker.txt"
sed 's|sh "$PEN_TOOL" "$pen/root/subject"|sh "$TOOL" "$pen/root/subject"|' "$prove" > "$pen/leaky_prove.sh"
out=$(sh "$pen/leaky_prove.sh" "$pen/deep/tools/z/rooted.sh" "$pen/quiet.md" 2>&1) || true
check "the elder shape does escape"    yes "$(has "$(ls "$pen/deep" 2>&1)" 'escape_marker.txt')"
rm -f "$pen/deep/escape_marker.txt"
echo "coverage: a beside-write was shown on the first run and on the second, the pen held a root-resolving tool where the elder shape let it out, and a prover with the comparison defeated fails four of these six"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
