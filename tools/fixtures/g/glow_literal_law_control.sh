#!/bin/sh
# tools/fixtures/g/glow_literal_law_control.sh -- prove the literal-law reading by doing, in a pen.
#
# WHY. A guard that cannot red guards nothing. This builds small git repositories in a temporary
# pen, plants one condition in each, runs the real scan inside them, and checks that the readings
# bite where they should and stay free where they should. Nothing here touches the tree it runs in.
#
# THE TWO SHARPEST LEGS ARE ABOUT THE GATE'S DIRECTION. `agreed_all_strict` and
# `agreed_all_permissive` prove that BOTH rulings drive `disagreement` to zero, which is the whole
# reason the gate reads the minority rather than the permissive count: a guard that refuses one of
# the two lawful answers is a guard that would have to be turned off to take it.
#
# `emitted_free` is the leg that watches for the elder mistake's return. `glow/lower_shop_gate.rye`
# writes the TEXT `std.fmt.parseInt(u32, argv[1], 10)` into the Rye it generates, and reading those
# 79 lines as compiler calls is what an unfiltered grep did until 20260908.
#
# USAGE
#   sh tools/fixtures/g/glow_literal_law_control.sh
#
# Driven by tools/g/glow_literal_law_witness.rish. Run from the repository root.

set -u

root=$(pwd)
scan=tools/fixtures/g/glow_literal_law_scan.sh
sites=tools/fixtures/t/tame_style_app_sites.sh
for f in "$scan" "$sites"; do
  [ -f "$root/$f" ] || { echo "control_verdict=fixture_missing:$f" >&2; exit 1; }
done

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A fresh pen repository carrying the two fixtures, so the scan under test is the real one.
fresh() {
  d=$pen/$1
  rm -rf "$d"
  mkdir -p "$d/glow" "$d/tools/fixtures/g" "$d/tools/fixtures/t"
  cp "$root/$scan" "$d/$scan"
  cp "$root/$sites" "$d/$sites"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
}

# A permissive reader: a hand-rolled accumulator with no leading-zero refusal.
permissive() {
  cat > "$pen/$1/glow/$2" <<'EOF'
const std = @import("std");
fn read(t: []const u8) !u32 {
    var v: u32 = 0;
    for (t) |c| { const d: u32 = c - '0'; v = v * 10 + d; }
    return v;
}
EOF
}

# A strict reader: the same accumulator behind the leading-zero refusal.
strict() {
  cat > "$pen/$1/glow/$2" <<'EOF'
const std = @import("std");
fn read(t: []const u8) !u32 {
    if (t.len > 1 and t[0] == '0') return error.MalformedBody;
    var v: u32 = 0;
    for (t) |c| { const d: u32 = c - '0'; v = v * 10 + d; }
    return v;
}
EOF
}

stage() { ( cd "$pen/$1" && git add -A ); }
scan_in() { ( cd "$pen/$1" && sh "$scan" ${2:-} ); }
field() { printf '%s\n' "$1" | grep -E "^$2=" | cut -d= -f2; }

# 1-2. One permissive reader alone: counted, and the tree agrees with itself.
fresh a; permissive a a.rye; stage a
out=$(scan_in a)
[ "$(field "$out" permissive)" = 1 ] && echo "permissive_counted=yes" || echo "permissive_counted=no"
[ "$(field "$out" disagreement)" = 0 ] && [ "$(field "$out" verdict)" = agreed ] \
  && echo "agreed_all_permissive=yes" || echo "agreed_all_permissive=no"

# 3. One strict reader alone: also agreed, because either ruling is lawful.
fresh b; strict b b.rye; stage b
out=$(scan_in b)
[ "$(field "$out" strict)" = 1 ] && [ "$(field "$out" disagreement)" = 0 ] \
  && [ "$(field "$out" verdict)" = agreed ] && echo "agreed_all_strict=yes" || echo "agreed_all_strict=no"

# 4-5. A minority of one against three: the split is seen and it is the MINORITY that is read.
fresh c; strict c s.rye; permissive c p1.rye; permissive c p2.rye; permissive c p3.rye; stage c
out=$(scan_in c)
[ "$(field "$out" disagreement)" = 1 ] && [ "$(field "$out" verdict)" = split ] \
  && echo "split_counted=yes" || echo "split_counted=no"
[ "$(field "$out" permissive)" = 3 ] && [ "$(field "$out" strict)" = 1 ] \
  && echo "minority_is_the_reading=yes" || echo "minority_is_the_reading=no"

# 6. Two strict among three permissive reads two, so the gate measures size and not mere presence.
fresh d; strict d s1.rye; strict d s2.rye; permissive d p1.rye; permissive d p2.rye; permissive d p3.rye; stage d
out=$(scan_in d)
[ "$(field "$out" disagreement)" = 2 ] && echo "minority_size_read=yes" || echo "minority_size_read=no"

# 7. A program-position parseInt is a reader too.
fresh e
printf 'const std = @import("std");\nfn read(t: []const u8) !u32 {\n    return std.fmt.parseInt(u32, t, 10) catch return error.Overflow;\n}\n' > "$pen/e/glow/e.rye"
stage e
out=$(scan_in e)
[ "$(field "$out" readers)" = 1 ] && echo "parseint_counted=yes" || echo "parseint_counted=no"

# 8. EMITTED text is not a call. A compiler writing Rye holds the pattern inside a `\\` string.
fresh f
printf 'const std = @import("std");\nfn emit(out: []u8) void {\n    _ = out;\n    const s =\n        \\\\    const a = std.fmt.parseInt(u32, argv[1], 10) catch return 2;\n    ;\n    _ = s;\n}\n' > "$pen/f/glow/f.rye"
stage f
out=$(scan_in f)
[ "$(field "$out" readers)" = 0 ] && echo "emitted_free=yes" || echo "emitted_free=no"

# 9. A comment naming the pattern is prose.
fresh g
printf 'const std = @import("std");\n// this file once called std.fmt.parseInt(u32, t, 10) and no longer does\nfn read() u32 { return 0; }\n' > "$pen/g/glow/g.rye"
stage g
out=$(scan_in g)
[ "$(field "$out" readers)" = 0 ] && echo "comment_free=yes" || echo "comment_free=no"

# 10. A witness proves a reader; it is not one.
fresh h; permissive h h_witness.rye; stage h
out=$(scan_in h)
[ "$(field "$out" readers)" = 0 ] && echo "witness_excluded=yes" || echo "witness_excluded=no"

# 11. An untracked file is outside the reading, the way git ls-files decides everywhere here.
fresh i; permissive i i.rye
out=$(scan_in i)
[ "$(field "$out" readers)" = 0 ] && echo "untracked_free=yes" || echo "untracked_free=no"

# 12. Two readers in one file: the file is one classification, and the scan says so out loud.
fresh j
cat > "$pen/j/glow/j.rye" <<'EOF'
const std = @import("std");
fn one(t: []const u8) !u32 {
    var v: u32 = 0;
    for (t) |c| { const d: u32 = c - '0'; v = v * 10 + d; }
    return v;
}
fn two(t: []const u8) !u32 {
    return std.fmt.parseInt(u32, t, 10) catch return error.Overflow;
}
EOF
stage j
out=$(scan_in j)
[ "$(field "$out" readers_max_per_file)" = 2 ] && [ "$(field "$out" reader_files)" = 1 ] \
  && echo "two_in_one_file_reported=yes" || echo "two_in_one_file_reported=no"

# 13. Losing the program-position reading refuses, rather than reading every tree as clean.
fresh k; permissive k k.rye; stage k
rm -f "$pen/k/$sites"
if ( cd "$pen/k" && sh "$scan" >/dev/null 2>&1 ); then
  echo "missing_sites_refused=no"
else
  echo "missing_sites_refused=yes"
fi

# 14. --detail names each reader, so a split is one line from being read.
fresh l; strict l s.rye; permissive l p.rye; stage l
out=$(scan_in l --detail)
printf '%s' "$out" | grep -q '^reader glow/s.rye strict' && printf '%s' "$out" | grep -q '^reader glow/p.rye permissive' \
  && echo "detail_names_each=yes" || echo "detail_names_each=no"

# 15. The program-position reading is load-bearing, proven by putting a naive count back. The
# elder rule was `grep -c`, and under it the compiler's own emitted text reads as a call.
fresh m
printf 'const std = @import("std");\nfn emit(out: []u8) void {\n    _ = out;\n    const s =\n        \\\\    const a = std.fmt.parseInt(u32, argv[1], 10) catch return 2;\n    ;\n    _ = s;\n}\n' > "$pen/m/glow/m.rye"
stage m
printf '#!/bin/sh\nset -u\nwhile [ "${1:-}" = "--detail" ] || [ "${1:-}" = "--exclude" ]; do [ "$1" = "--exclude" ] && shift; shift; done\npattern="$1"; shift\ngrep -Fc -- "$pattern" "$@" 2>/dev/null | head -1 || echo 0\n' > "$pen/m/$sites"
out=$(scan_in m)
[ "$(field "$out" readers)" = 1 ] && echo "naive_count_reads_emitted=yes" || echo "naive_count_reads_emitted=no"

echo "control_verdict=ok"
