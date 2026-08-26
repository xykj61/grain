#!/bin/sh
# tools/fixtures/invariant_coverage_control.sh -- prove the proof/contract bin by doing.
#
# WHY. The reachability bin moved this tree's invariant reading by an order of magnitude -- a gap of
# 13,235 as first reported, 3,978 once three promises were separated, and 1,385 once a function
# reachable only from a proof entry stopped counting as a contract. A rule that moves a number that
# far is a rule to prove rather than to trust, and the arc behind it booked four corrections in four
# rounds (REDS %207, %208, %210, %211), every one caught by a hand opening a file.
#
# USAGE
#   sh tools/fixtures/invariant_coverage_control.sh
#
# Run from the repository root.

set -u

scan=tools/fixtures/invariant_coverage_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
abs=$(CDPATH= cd -- "$(dirname -- "$scan")" && pwd)/$(basename "$scan")

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures" "$pen/m"
# The scan sources shell_portable.sh beside it, so the helper travels into the pen with it --
# a copied guard that cannot find its own dialect helper refuses before it reads a line.
cp "$abs" "$(dirname "$abs")/shell_portable.sh" "$pen/tools/fixtures/"
( cd "$pen" && git init -q . ) >/dev/null 2>&1

put() { cat > "$pen/m/$1"; ( cd "$pen" && git add -A ) >/dev/null 2>&1; }
read_bins() { ( cd "$pen" && INVARIANT_ROOT=. sh tools/fixtures/invariant_coverage_scan.sh 2>&1 ); }
val() { echo "$1" | sed -n "s/^$2=\([0-9]*\).*/\1/p" | head -1; }
PASS=0; FAIL=0
check() { if [ "$2" = "$3" ]; then PASS=$((PASS+1)); echo "ok   $1"; else FAIL=$((FAIL+1)); echo "FAIL $1 (want $2, got $3)"; fi }

# 1 -- a private function reached only from run_selftest is a proof, whatever it is named.
rm -f "$pen"/m/*.rye
put a.rye <<'EOF'
fn run_hue_turn() void { assert(x == 1); }
fn run_selftest() void { run_hue_turn(); }
EOF
o=$(read_bins)
check "1 a private fn reached only from run_selftest bins as proof" "0" "$(val "$o" contract_asserts)"
check "1 and it lands in the selftest bin" "1" "$(val "$o" selftest_asserts)"

# 2 -- a `pub` function is never reached into, whatever calls it. A selftest exercising the real API
#      is what a selftest is FOR, and the first draft of this rule swallowed the API because of it.
rm -f "$pen"/m/*.rye
put b.rye <<'EOF'
pub fn crop() u32 { assert(w > 0); return 1; }
fn run_selftest() void { _ = crop(); }
EOF
o=$(read_bins)
check "2 a pub fn called from a selftest stays a contract" "1" "$(val "$o" contract_asserts)"

# 2b -- a `pub fn` returning void that NO other module calls is a proof harness; one another module
#       calls, or one that returns a value, stays a contract. Both conditions err toward contract.
rm -f "$pen"/m/*.rye
put p1.rye <<'EOF'
pub fn check_reads() void { assert(r == 1); }
fn run_selftest() void { check_reads(); }
EOF
o=$(read_bins)
check "2b a void pub fn no other module calls bins as proof" "0" "$(val "$o" contract_asserts)"

put p2.rye <<'EOF'
const other = @import("p1.rye");
pub fn use_it() void { other.check_reads(); }
EOF
o=$(read_bins)
check "2b the same fn, once another module calls it, stays a contract" "1" "$(val "$o" contract_asserts)"

rm -f "$pen"/m/*.rye
put p3.rye <<'EOF'
pub fn measure() u32 { assert(m == 1); return 1; }
fn run_selftest() void { _ = measure(); }
EOF
o=$(read_bins)
check "2b a pub fn returning a value stays a contract, uncalled or not" "1" "$(val "$o" contract_asserts)"
rm -f "$pen"/m/*.rye

# 3 -- a private helper a pub function ALSO calls is shared code, so it withdraws to contract.
rm -f "$pen"/m/*.rye
put c.rye <<'EOF'
fn helper() void { assert(n > 0); }
pub fn api() void { helper(); }
fn run_selftest() void { helper(); }
EOF
o=$(read_bins)
check "3 a helper a pub fn also calls withdraws to contract" "1" "$(val "$o" contract_asserts)"

# 4 -- reachability is transitive: a proof calling a proof calling a helper.
rm -f "$pen"/m/*.rye
put d.rye <<'EOF'
fn deep() void { assert(z == 3); }
fn mid() void { deep(); }
fn run_selftest() void { mid(); }
EOF
o=$(read_bins)
check "4 reachability reaches through one proof into the next" "0" "$(val "$o" contract_asserts)"

# 5 -- an ordinary private function nothing proof-like calls is a contract.
rm -f "$pen"/m/*.rye
put e.rye <<'EOF'
fn quiet() void { assert(q > 0); }
pub fn api() void { quiet(); }
EOF
o=$(read_bins)
check "5 a private fn no proof calls stays a contract" "1" "$(val "$o" contract_asserts)"

# 6 -- the role words still stand on their own, with no call graph at all.
rm -f "$pen"/m/*.rye
put f.rye <<'EOF'
fn run_thing_witness() void { assert(a == 1); }
fn main() void { assert(b == 2); }
fn run_selftest() void { assert(c == 3); }
EOF
o=$(read_bins)
check "6 main, selftest and witness names bin as proof unaided" "0" "$(val "$o" contract_asserts)"
check "6 and all three land in the selftest bin" "3" "$(val "$o" selftest_asserts)"

# 7 -- a file declaring itself a selftest bins whole, whatever its functions are named.
rm -f "$pen"/m/*.rye
put g.rye <<'EOF'
//! m/g.rye -- a Lattice selftest.
pub fn welcome_add() void { assert(s == 1); }
EOF
o=$(read_bins)
check "7 a file declaring itself a selftest bins whole, pub fns included" "0" "$(val "$o" contract_asserts)"

# 7b -- a file under a tests/ directory is a test, whatever its header says or its functions are
#       named. Structural rather than lexical: `rye/tests/` holds 116 files declaring themselves
#       `Rye test:`, a phrase the selftest header rule cannot see.
rm -rf "$pen/m"; mkdir -p "$pen/m/tests"
cat > "$pen/m/tests/a_test.rye" <<'EOF'
pub fn check() void { assert(t == 1); }
EOF
cat > "$pen/m/ordinary.rye" <<'EOF'
pub fn api() void { assert(o == 1); }
EOF
( cd "$pen" && git add -A ) >/dev/null 2>&1
o=$(read_bins)
check "7b a file under tests/ bins as proof" "1" "$(val "$o" contract_asserts)"
check "7b and its assert lands in the selftest bin" "1" "$(val "$o" selftest_asserts)"
rm -rf "$pen/m"; mkdir -p "$pen/m"

# 7c -- a file under fixtures/ is a planted artifact, and an assert named inside a string is prose.
rm -rf "$pen/m"; mkdir -p "$pen/m/fixtures"
cat > "$pen/m/fixtures/planted.rye" <<'EOF'
pub fn demo() void { assert(false); }
EOF
cat > "$pen/m/printer.rye" <<'EOF'
pub fn tell() void {
    // invariant: the one real call
    assert(k == 1);
    print("needs assert(x <= max) before the cast");
}
EOF
( cd "$pen" && git add -A ) >/dev/null 2>&1
o=$(read_bins)
check "7c a fixtures/ file is a planted artifact, not a contract" "1" "$(val "$o" contract_asserts)"
check "7c an assert named inside a string is prose, not a call" "0" "$(val "$o" contract_with_no_reason)"
rm -rf "$pen/m"; mkdir -p "$pen/m"

# 8 -- a witness FILE is its own bin, separate from selftest.
rm -f "$pen"/m/*.rye
put h_witness.rye <<'EOF'
pub fn prove() void { assert(p == 1); }
EOF
o=$(read_bins)
check "8 a *_witness.rye file lands in the witness bin" "1" "$(val "$o" witness_asserts)"
check "8 and not in the contract bin" "0" "$(val "$o" contract_asserts)"

# 9 -- coverage itself: a run of asserts under one invariant block is covered by it.
rm -f "$pen"/m/*.rye
put i.rye <<'EOF'
pub fn api() void {
    // invariant: the reason, written once above a run
    assert(a == 1);
    assert(b == 2);
    assert(c == 3);
}
EOF
o=$(read_bins)
check "9 three asserts under one block read as three covered" "3" "$(val "$o" contract_with_a_reason)"
check "9 and the gap is zero" "0" "$(val "$o" contract_with_no_reason)"

# 9b -- every spelling of the label this tree writes is read, and prose that merely says the word
#       is not. 483 lines carried a qualified spelling the first pattern could not see.
rm -f "$pen"/m/*.rye
put l.rye <<'EOF'
pub fn a() void {
    // invariant (precondition): the qualified form TAME's own three moments produce
    assert(a == 1);
}
pub fn b() void {
    // invariant (bound): why this number is this number
    assert(b == 2);
}
pub fn c() void {
    // postcondition: the bare category word
    assert(c == 3);
}
pub fn d() void {
    // precondition: the other bare category word
    assert(d == 4);
}
pub fn e() void {
    // this comment merely mentions an invariant in passing with no colon
    assert(e == 5);
}
EOF
o=$(read_bins)
check "9b four label spellings all read as covered" "4" "$(val "$o" contract_with_a_reason)"
check "9b and prose naming the word without a colon does not" "1" "$(val "$o" contract_with_no_reason)"

# 10 -- a comment quoting an assert is prose, never a call site.
rm -f "$pen"/m/*.rye
put j.rye <<'EOF'
pub fn api() void {
    // assert(ghost == 1);
    // invariant: the one real reason
    assert(real == 1);
}
EOF
o=$(read_bins)
check "10 a commented assert is not counted" "1" "$(val "$o" contract_asserts)"

# 10b -- a function DECLARATION named assert is not a call to one. comlink/virtio_net.rye declares
#        its own `fn assert(ok: bool)` for a freestanding target with no std behind it, and six such
#        declarations stand in this tree.
rm -f "$pen"/m/*.rye
put n.rye <<'EOF'
fn assert(ok: bool) void {
    _ = ok;
}
pub fn api() void {
    // invariant: the one real call
    assert(a == 1);
}
EOF
o=$(read_bins)
check "10b a fn declaration named assert is not counted" "1" "$(val "$o" contract_asserts)"
check "10b and the real call inside it still is covered" "1" "$(val "$o" contract_with_a_reason)"

# 11 -- a symlink is not a second module.
rm -f "$pen"/m/*.rye
put k.rye <<'EOF'
pub fn api() void { assert(a == 1); }
EOF
( cd "$pen/m" && ln -sf k.rye k_link.rye && cd "$pen" && git add -A ) >/dev/null 2>&1
o=$(read_bins)
check "11 a symlinked module is counted once" "1" "$(val "$o" contract_asserts)"

echo ""
echo "control_pass=$PASS"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=fail"; exit 1; fi
