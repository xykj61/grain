#!/bin/sh
# convergence_prove_control.sh -- the convergence prover proven on tools built to pass and to fail.
#
# A prover that only ever sees converging tools has proven nothing about its own teeth, so the pen
# here builds a DIVERGING tool on purpose and requires the prover to catch it.
#
#   sh tools/fixtures/c/convergence_prove_control.sh
#
# Prints `pass=N fail=N`. Bounded: 12 cases, one pen.
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
cat > "$pen/good.sh" <<'G'
#!/bin/sh
sed -i 's/DASH/--/g' "$1"
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
chmod +x "$pen/refuser.sh"

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
echo "coverage: a tracked tree writer was exercised on a real sample"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
