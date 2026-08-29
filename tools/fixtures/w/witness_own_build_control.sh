#!/bin/sh
# tools/fixtures/w/witness_own_build_control.sh -- prove the own-build reading by doing, on real
# repositories.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and a refusal proven only in the
# passing direction cannot be told from a bypass. This control builds git repositories in a
# temporary pen, plants one condition in each, runs tools/fixtures/w/witness_own_build_scan.sh
# inside them, and checks that the refusals bite and the honest readings stay free. Nothing here
# touches the tree it is run from.
#
# USAGE
#   sh tools/fixtures/w/witness_own_build_control.sh
#
# Driven by tools/w/witness_own_build_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/w/witness_own_build_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A repository with one witness under tools/, a gitignored bin room, and a tracked pkg room.
# `body` is the witness's whole body, so each case says exactly one thing.
build() {
  name=$1; body=$2
  d=$pen/$name
  mkdir -p "$d/tools" "$d/pkg"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf '/bin/\n' > .gitignore \
    && printf 'tracked binary stand-in\n' > pkg/tool \
    && printf '%s\n' "$body" > tools/thing_witness.rish \
    && git add -A \
    && git commit -qm 'pen: one witness and one bin room' ) >/dev/null 2>&1
  mkdir -p "$d/bin"
  echo "$d"
}

verdict_of() { ( cd "$1" && sh "$scan" 2>/dev/null; ) }

# 1. The good shape -- the witness builds the artifact it runs. Free, and credited.
d=$(build built 'let b = run ["sh" "-c" "rye build src/thing.rye -femit-bin=bin/thing"]
let r = run ["bin/thing" "selftest"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && echo "self_built_free=yes" || echo "self_built_free=no"
echo "$out" | grep -q 'self_built=1' && echo "self_built_credited=yes" || echo "self_built_credited=no"
echo "$out" | grep -q 'unbuilt_pairs=0 ' && echo "self_built_reads_zero=yes" || echo "self_built_reads_zero=no"

# 2. The defect -- an ignored artifact invoked, with no build anywhere in the witness.
d=$(build unbuilt 'let r = run ["bin/thing" "selftest"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "unbuilt_counted=yes" || echo "unbuilt_counted=no"
echo "$out" | grep -q 'unbuilt_witnesses=1' && echo "unbuilt_witness_counted=yes" || echo "unbuilt_witness_counted=no"
echo "$out" | grep -q 'invoked_ignored=1' && echo "invoked_seen=yes" || echo "invoked_seen=no"

# 3. The defect exactly as it stood in Comlink -- the build named only in a comment. Still refused.
d=$(build comment_only '# Build first:  rye build src/thing.rye -femit-bin=bin/thing
let r = run ["bin/thing" "selftest"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "comment_build_refused=yes" || echo "comment_build_refused=no"
echo "$out" | grep -q 'self_built=0' && echo "comment_build_uncredited=yes" || echo "comment_build_uncredited=no"

# 4. A TRACKED binary needs no build -- the clone carries it. Free.
d=$(build tracked 'let r = run ["pkg/tool" "selftest"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'invoked_ignored=0' && echo "tracked_binary_free=yes" || echo "tracked_binary_free=no"

# 5. The interpreter and the compiler pass by named rule -- if either is absent nothing runs at all.
d=$(build bootstrap 'let a = run ["rishi/bin/rishi" "run" "tools/other_witness.rish"]
let b = run ["rye/bin/rye" "build" "src/thing.rye"]
let c = run ["bin/thing" "selftest"]')
( cd "$d" && printf '/bin/\n/rishi/bin/\n/rye/bin/\n' > .gitignore && git add -A \
  && git commit -qm 'pen: the bootstrap rooms are ignored too' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'invoked_ignored=1' && echo "bootstrap_free=yes" || echo "bootstrap_free=no"

# 6. A vendored path is provisioned by `git submodule update`, never by a witness. Free.
d=$(build vendored 'let a = run ["vendor/zig-toolchain/zig" "version"]
let c = run ["bin/thing" "selftest"]')
( cd "$d" && printf '/bin/\n/vendor/\n' > .gitignore && git add -A \
  && git commit -qm 'pen: vendor is ignored' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'invoked_ignored=1' && echo "vendor_free=yes" || echo "vendor_free=no"

# 7. The honest limit, asserted rather than described: a binary reached through `sh -c` is invisible,
#    because only the FIRST quoted element of a `run [ ... ]` is read and that element is `sh`. The
#    pen carries a second, tracked invocation so the extraction is non-empty -- otherwise this case
#    would trip the empty-extraction refusal instead, which is what it did when first written.
d=$(build shell_c 'let r = run ["sh" "-c" "bin/thing selftest"]
let t = run ["pkg/tool" "check"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'invoked_ignored=0' && echo "shell_c_unread=yes" || echo "shell_c_unread=no"

# 8. absent_now is a fact about one machine, reported and never gating. The same pen reads 0 with
#    the artifact present and 1 without it, and its verdict never moves.
d=$(build presence 'let r = run ["bin/thing" "selftest"]')
printf 'built\n' > "$d/bin/thing"
out=$(verdict_of "$d")
echo "$out" | grep -q 'absent_now=0' && echo "present_reads_zero=yes" || echo "present_reads_zero=no"
rm -f "$d/bin/thing"
out=$(verdict_of "$d")
echo "$out" | grep -q 'absent_now=1' && echo "absent_counted=yes" || echo "absent_counted=no"
echo "$out" | grep -q 'verdict=ok' && echo "absent_never_gates=yes" || echo "absent_never_gates=no"

# 9. A comment naming a binary invokes nothing. Free, and the pen still reads a real invocation, so
#    the empty-extraction refusal below stays the only thing that can produce a zero.
d=$(build mention '# bin/thing is the artifact this family proves
let r = run ["pkg/tool" "selftest"]')
verdict_of "$d" | grep -q 'invoked_ignored=0' && echo "comment_mention_free=yes" || echo "comment_mention_free=no"

# 10. A witness invoking nothing at all -- the reading is broken rather than the tree clean.
d=$(build silent 'say "nothing runs here"')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=extraction_empty' && echo "empty_extraction_refused=yes" || echo "empty_extraction_refused=no"

# 11. The ratchet, from both sides. The planted counts track the LIVE ceiling: lower the ceiling and
#     these two move with it, or the control proves a ceiling the tree no longer holds.
d=$(build ratchet_under 'let r = run ["bin/thing" "selftest"]')
( cd "$d" && i=2; while [ "$i" -le 46 ]; do printf 'let r = run ["bin/thing%s" "selftest"]\n' "$i" > "tools/spare${i}_witness.rish"; i=$((i + 1)); done
  git add -A && git commit -qm 'pen: forty-six unbuilt pairs' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'unbuilt_pairs=46 ' && echo "ratchet_counted=yes" || echo "ratchet_counted=no"
echo "$out" | grep -q 'verdict=ok' && echo "ratchet_under_free=yes" || echo "ratchet_under_free=no"

( cd "$d" && printf 'let r = run ["bin/thing47" "selftest"]\n' > tools/spare47_witness.rish \
  && git add -A && git commit -qm 'pen: one over the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'unbuilt_pairs=47 ' && echo "ratchet_over_counted=yes" || echo "ratchet_over_counted=no"
echo "$out" | grep -q 'verdict=witness_without_build' && echo "ratchet_over_refused=yes" || echo "ratchet_over_refused=no"

echo "control_verdict=ok"
