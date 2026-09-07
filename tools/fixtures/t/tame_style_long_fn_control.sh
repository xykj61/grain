#!/bin/sh
# Proves tools/fixtures/t/tame_style_long_fn_one.sh on planted .rye sources in a throwaway pen --
# every refusal planted and then removed, and every welcome asserted as hard as every refusal, since
# a ledger proven only in the reporting direction cannot be told from one that reports everything.
#
# THE LEG THAT EARNS THE PEN is 4-5: the ELDER awk is run on the very same planted file, in the same
# pen, and shown reading CLEAN over a hundred-line function. The header's central claim -- that a
# closing-brace pattern ends a free function at its first `if` block -- is therefore proven by doing
# rather than asserted in prose, and a future edit that walks the fix back says so on its own lap.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/tame_style_long_fn_one.sh
[ -f "$src" ] || { echo "control: REFUSED -- $src is absent" >&2; exit 2; }
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ck() { if printf '%s' "$3" | grep -q -- "$2"; then pass=$((pass+1)); else
  fail=$((fail+1)); echo "  FAIL $1: wanted '$2'"; printf '%s\n' "$3" | sed 's/^/        /'; fi; }
nk() { if printf '%s' "$3" | grep -q -- "$2"; then
  fail=$((fail+1)); echo "  FAIL $1: did NOT want '$2'"; printf '%s\n' "$3" | sed 's/^/        /';
  else pass=$((pass+1)); fi; }
# empty -- silence is a reading too, and grep cannot tell "no lines" from "no match", so it is
# tested as a string rather than searched for.
mt() { if [ -z "$2" ]; then pass=$((pass+1)); else
  fail=$((fail+1)); echo "  FAIL $1: wanted no output"; printf '%s\n' "$2" | sed 's/^/        /'; fi; }

run() { sh "$src" "$1" 2>&1; }

# The elder awk, kept here and nowhere else, so leg 4-5 can show what it could not see.
elder() {
  awk -v F="$1" '
    /^( *)?(pub )?fn /{ if (infn && n > 70) printf "  %s: %s = %d lines\n", F, name, n;
        infn = 1; n = 0; name = $0; sub(/\(.*/, "", name); sub(/.*fn /, "", name) }
    infn { n++ }
    /^}$|^    }$/{ if (infn && n > 70) printf "  %s: %s = %d lines\n", F, name, n; infn = 0 }
  ' "$1" 2>/dev/null
}

# body_lines N -- N lines of ordinary statement, four spaces in.
body_lines() { i=0; while [ "$i" -lt "$1" ]; do echo "    var x$i: u32 = $i;"; i=$((i+1)); done; }

# 1-2. A short free function is not reported, and the scan still exits clean. A ledger that says
# nothing about a healthy file must be told from one that failed to read it, so both are asserted.
{ echo "pub fn small(a: u32) u32 {"; body_lines 10; echo "    return a;"; echo "}"; } > "$pen/small.rye"
out=$(run "$pen/small.rye")
nk "a 12-line function is not reported" "small" "$out"
mt "and the scan exits clean"           "$out"

# 3. The boundary, from the long side: 71 body lines past the head is reported.
{ echo "pub fn just_over() void {"; body_lines 70; echo "}"; } > "$pen/over.rye"
out=$(run "$pen/over.rye")
ck "72 lines is past the bound" "just_over = 72 lines" "$out"

# 4-5. THE SHARP EDGE. A hundred-line free function whose first `if` block closes at four spaces.
# The elder awk reads it CLEAN; the fix reads its true length. Same file, same pen, opposite answers.
{
  echo "pub fn holds_a_block(a: u32) u32 {"
  echo "    if (a > 0) {"
  echo "        return a;"
  echo "    }"
  body_lines 96
  echo "}"
} > "$pen/block.rye"
out=$(run "$pen/block.rye")
ck "a free function holding an if block is measured whole" "holds_a_block = 101 lines" "$out"
old=$(elder "$pen/block.rye")
nk "and the elder awk saw nothing of it"                   "holds_a_block"             "$old"

# 6. A struct method, indented at four, still ends at its own close rather than at a sibling's.
{
  echo "pub const Desk = struct {"
  echo "    pub fn measure(self: *Desk) u32 {"
  echo "        if (self.n > 0) {"
  echo "            return self.n;"
  echo "        }"
  i=0; while [ "$i" -lt 96 ]; do echo "        var x$i: u32 = $i;"; i=$((i+1)); done
  echo "    }"
  echo "};"
} > "$pen/method.rye"
out=$(run "$pen/method.rye")
ck "a struct method is measured whole" "measure = 101 lines" "$out"

# 7-8. An inline comparator. The enclosing function keeps its count; the elder awk restarted on the
# indented `fn` and reported the inner one's few lines instead, which is the second hole.
{
  echo "pub fn sorts_a_list(items: []u32) void {"
  echo "    const by_value = struct {"
  echo "        fn less(_: void, a: u32, b: u32) bool {"
  echo "            return a < b;"
  echo "        }"
  echo "    }.less;"
  body_lines 90
  echo "    _ = by_value;"
  echo "}"
} > "$pen/inline.rye"
out=$(run "$pen/inline.rye")
ck "an inline comparator does not zero its parent" "sorts_a_list = 98 lines" "$out"
old=$(elder "$pen/inline.rye")
nk "where the elder awk lost the parent"           "sorts_a_list"            "$old"

# 9. A brace inside a format string never moves the depth. `print("{d}\n", .{n})` is on nearly every
# page in this tree, so a counter that read those braces would end a function at its first print.
{
  echo "pub fn prints(n: u32) void {"
  echo "    print(\"a count of {d} and a close }\", .{n});"
  body_lines 96
  echo "}"
} > "$pen/str.rye"
out=$(run "$pen/str.rye")
ck "braces inside a string are not code" "prints = 99 lines" "$out"

# 10. A brace inside a char literal, which five roster files carry.
{
  echo "pub fn scans(c: u8) bool {"
  echo "    if (c == '}') return true;"
  body_lines 96
  echo "    return false;"
  echo "}"
} > "$pen/chr.rye"
out=$(run "$pen/chr.rye")
ck "braces inside a char literal are not code" "scans = 100 lines" "$out"

# 11. A Zig multiline-string line is string content whole -- twelve roster files hold 119 such lines
# carrying a brace.
{
  echo "pub fn writes() void {"
  echo "    const t ="
  echo "        \\\\a template holding } and { unbalanced"
  echo "    ;"
  body_lines 96
  echo "}"
} > "$pen/multi.rye"
out=$(run "$pen/multi.rye")
ck "a multiline-string line is not code" "writes = 101 lines" "$out"

# 12. A brace inside a line comment.
{
  echo "pub fn commented() void {"
  echo "    // a comment holding } on its own"
  body_lines 96
  echo "}"
} > "$pen/cmt.rye"
out=$(run "$pen/cmt.rye")
ck "braces inside a comment are not code" "commented = 99 lines" "$out"

# 13. A declaration with no body opens no count, so the lines after it belong to whoever owns them.
{
  echo "extern fn read_raw(fd: i32, buf: [*]u8, n: usize) isize;"
  echo "pub fn after_a_prototype() void {"
  body_lines 96
  echo "}"
} > "$pen/proto.rye"
out=$(run "$pen/proto.rye")
nk "a prototype opens no count"        "read_raw"                      "$out"
ck "and the function after it is whole" "after_a_prototype = 98 lines" "$out"

# 14. Two long functions in one file are both reported -- a ledger that stops at the first would
# read like a short file.
{ echo "pub fn first() void {"; body_lines 96; echo "}";
  echo "pub fn second() void {"; body_lines 96; echo "}"; } > "$pen/two.rye"
out=$(run "$pen/two.rye")
ck "the first of two is reported"  "first = 98 lines"  "$out"
ck "the second of two is reported" "second = 98 lines" "$out"

# 15. An absent path and an empty file each read clean rather than complaining, since the roster
# hands this scan whatever `find` returned and a race is ordinary.
out=$(run "$pen/nowhere.rye")
mt "an absent path reads clean" "$out"
: > "$pen/empty.rye"
out=$(run "$pen/empty.rye")
mt "an empty file reads clean"  "$out"

# 16. The output format the ranker depends on. `tame_style_long_fn.rish` sorts with
# `sort -t= -k2 -rn`, so the ` = N lines` tail is load-bearing rather than cosmetic.
out=$(run "$pen/two.rye")
ranked=$(printf '%s\n' "$out" | sort -t= -k2 -rn | head -1)
ck "the ledger still ranks by count" "= 98 lines" "$ranked"

# 17. An unbalanced file names its own bound rather than counting to the end of the world.
{ echo "pub fn never_closes() void {"; body_lines 5000; } > "$pen/runaway.rye"
out=$(run "$pen/runaway.rye")
ck "a runaway names the bound" "OVER-BOUND" "$out"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
