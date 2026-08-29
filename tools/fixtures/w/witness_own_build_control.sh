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
#    the artifact present and 1 without it, and ITS VERDICT NEVER MOVES. The comparison is between
#    the two readings rather than against a literal `ok`, and the difference started to matter the
#    day the ceiling became a wall at zero: this pen carries one unbuilt pair on purpose -- it has
#    to, since absent_now only ever counts UNBUILT artifacts -- so both readings are refused now,
#    and a case pinned to `ok` reported the wall as a presence fault. What must hold is that
#    changing PRESENCE alone changed nothing, which is what is asserted.
d=$(build presence 'let r = run ["bin/thing" "selftest"]')
printf 'built\n' > "$d/bin/thing"
out=$(verdict_of "$d")
echo "$out" | grep -q 'absent_now=0' && echo "present_reads_zero=yes" || echo "present_reads_zero=no"
v_present=$(echo "$out" | grep '^verdict=')
rm -f "$d/bin/thing"
out=$(verdict_of "$d")
echo "$out" | grep -q 'absent_now=1' && echo "absent_counted=yes" || echo "absent_counted=no"
v_absent=$(echo "$out" | grep '^verdict=')
[ "$v_present" = "$v_absent" ] && echo "absent_never_gates=yes" || echo "absent_never_gates=no"

# 9. A comment naming a binary invokes nothing. Free, and the pen still reads a real invocation, so
#    the empty-extraction refusal below stays the only thing that can produce a zero.
d=$(build mention '# bin/thing is the artifact this family proves
let r = run ["pkg/tool" "selftest"]')
verdict_of "$d" | grep -q 'invoked_ignored=0' && echo "comment_mention_free=yes" || echo "comment_mention_free=no"

# 10. A witness invoking nothing at all -- the reading is broken rather than the tree clean.
d=$(build silent 'say "nothing runs here"')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=extraction_empty' && echo "empty_extraction_refused=yes" || echo "empty_extraction_refused=no"

# 12. A DELEGATED build -- the witness RUNS a tracked script that builds the artifact. Credited as
#     delegated, counted apart from self_built, and freed. This is the Pond ring shape on this pier:
#     five witnesses share one build fixture rather than carrying five copies of one build line.
d=$(build delegated 'let b = run ["sh" "tools/build_thing.sh"]
let r = run ["bin/thing" "selftest"]')
( cd "$d" && printf 'BIN="bin/thing"\nrye build src/thing.rye -femit-bin="$BIN"\n' > tools/build_thing.sh \
  && git add -A && git commit -qm 'pen: the build lives in a tracked fixture' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'delegated_built=1' && echo "delegated_credited=yes" || echo "delegated_credited=no"
echo "$out" | grep -q 'unbuilt_pairs=0 ' && echo "delegated_freed=yes" || echo "delegated_freed=no"
echo "$out" | grep -q 'self_built=0' && echo "delegated_apart_from_self=yes" || echo "delegated_apart_from_self=no"
echo "$out" | grep -q 'verdict=ok' && echo "delegated_verdict_ok=yes" || echo "delegated_verdict_ok=no"

# 13. A MENTION IS NOT A BUILD, one hop out as well as zero. The helper the witness runs names the
#     artifact and builds nothing, so the pair stays counted -- the rule case 3 holds inside the
#     witness, held one file further away.
d=$(build delegate_no_build 'let b = run ["sh" "tools/check_thing.sh"]
let r = run ["bin/thing" "selftest"]')
( cd "$d" && printf 'echo "bin/thing is the artifact this family proves"\n' > tools/check_thing.sh \
  && git add -A && git commit -qm 'pen: the helper only mentions the artifact' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'delegated_built=0' && echo "mention_not_delegated=yes" || echo "mention_not_delegated=no"
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "mention_still_counted=yes" || echo "mention_still_counted=no"

# 14. A BUILDER THAT NAMES SOMETHING ELSE is not this artifact's builder. The helper builds, and
#     builds a stranger, so the pair stays counted -- the third of the three strict conditions,
#     proven alone.
d=$(build delegate_other_target 'let b = run ["sh" "tools/build_other.sh"]
let r = run ["bin/thing" "selftest"]')
( cd "$d" && printf 'rye build src/gizmo.rye -femit-bin=bin/gizmo\n' > tools/build_other.sh \
  && git add -A && git commit -qm 'pen: the helper builds a stranger' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'delegated_built=0' && echo "other_target_uncredited=yes" || echo "other_target_uncredited=no"
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "other_target_counted=yes" || echo "other_target_counted=no"

# 15. AN UNTRACKED BUILDER IS NOT A PROMISE A CLONE CAN KEEP. The helper builds the artifact exactly
#     and git ignores the helper, so a clone carries neither. Counted, and it must be.
d=$(build delegate_untracked 'let b = run ["sh" "tools/scratch_build.sh"]
let r = run ["bin/thing" "selftest"]')
( cd "$d" && printf '/bin/\n/tools/scratch_build.sh\n' > .gitignore \
  && printf 'rye build src/thing.rye -femit-bin=bin/thing\n' > tools/scratch_build.sh \
  && git add -A && git commit -qm 'pen: the builder is untracked' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'delegated_built=0' && echo "untracked_delegate_uncredited=yes" || echo "untracked_delegate_uncredited=no"
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "untracked_delegate_counted=yes" || echo "untracked_delegate_counted=no"

# 16. ONE HOP, AND ONLY ONE -- asserted rather than described. The build sits two scripts deep, the
#     witness runs only the outer one, and the pair stays counted. A limit nobody proves is a limit
#     nobody can rely on.
d=$(build delegate_two_hops 'let b = run ["sh" "tools/outer.sh"]
let r = run ["bin/gizmo" "selftest"]')
( cd "$d" && printf 'sh tools/inner.sh\n' > tools/outer.sh \
  && printf 'rye build src/gizmo.rye -femit-bin=bin/gizmo\n' > tools/inner.sh \
  && git add -A && git commit -qm 'pen: the build is two scripts deep' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'delegated_built=0' && echo "two_hops_uncredited=yes" || echo "two_hops_uncredited=no"
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "two_hops_counted=yes" || echo "two_hops_counted=no"

# 17. A WITNESS IS NEVER ITS OWN DELEGATE. This one names its own path in a run line and carries a
#     build for a stranger, so following the self-hop would credit it for an artifact it never
#     builds. The skip is what keeps one build line from excusing every other invocation in a file.
d=$(build self_hop 'let a = run ["rishi/bin/rishi" "run" "tools/thing_witness.rish"]
let b = run ["sh" "-c" "rye build src/other.rye -femit-bin=bin/other"]
let r = run ["bin/thing" "selftest"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'delegated_built=0' && echo "self_hop_uncredited=yes" || echo "self_hop_uncredited=no"
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "self_hop_counted=yes" || echo "self_hop_counted=no"

# 11. The ratchet, from both sides -- and it is a WALL now, so the two plants sit at 0 and 1. The
#     planted counts track the LIVE ceiling: change the ceiling and these two move with it, or the
#     control proves a ceiling the tree no longer holds. Under is a witness that builds what it
#     runs, which is the only shape that reads zero once the ceiling is zero.
d=$(build ratchet_under 'let b = run ["sh" "-c" "rye build src/thing.rye -femit-bin=bin/thing"]
let r = run ["bin/thing" "selftest"]')
out=$(verdict_of "$d")
echo "$out" | grep -q 'unbuilt_pairs=0 ' && echo "ratchet_counted=yes" || echo "ratchet_counted=no"
echo "$out" | grep -q 'verdict=ok' && echo "ratchet_under_free=yes" || echo "ratchet_under_free=no"

( cd "$d" && printf 'let r = run ["bin/thing2" "selftest"]\n' > tools/spare2_witness.rish \
  && git add -A && git commit -qm 'pen: one over the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'unbuilt_pairs=1 ' && echo "ratchet_over_counted=yes" || echo "ratchet_over_counted=no"
echo "$out" | grep -q 'verdict=witness_without_build' && echo "ratchet_over_refused=yes" || echo "ratchet_over_refused=no"

echo "control_verdict=ok"
