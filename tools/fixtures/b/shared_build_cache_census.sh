#!/bin/sh
# shared_build_cache_census.sh -- does identical Zig source hit one shared compile cache from any checkout?
#
# WHY THIS EXISTS. The bakery fruit (`20261001`) asked for one build cache across the eight checkouts.
# Before building one, measure whether the compile layer already shares. Each checkout ships its own
# vendor/zig-toolchain/zig; all eight are byte-identical, so the question is only the cache key.
#
# WHAT IT PROVES. In a PRIVATE global cache (so no peer's concurrent writes pollute the count):
#   miss   -- a unique source built at path A writes new cache files
#   hit    -- the same bytes built at path B add zero new files
#   again  -- path A rebuilt adds zero new files
# If `hit` adds files, the key carries the directory and a shared cache would not dedupe across
# checkouts. Measured 20261009 on this pier: miss 819 files / 5.0s, hit 0 files / 0.8s.
#
# THE COUNT IS PRIVATE ON PURPOSE. The shared ~/.cache/zig holds 552,124 entries under z/ and eight
# ships write into it at once, so a count taken there reads peers' work. This fixture never touches it.
#
# Usage: sh tools/fixtures/b/shared_build_cache_census.sh
# Output: key=value lines and a final verdict. Exits 0 on path_independent=yes, 1 otherwise, 2 on setup failure.

ROOT=$(cd "$(dirname "$0")/../../.." && pwd -P) || exit 2
ZIG="$ROOT/vendor/zig-toolchain/zig"
[ -x "$ZIG" ] || { echo "verdict=no_toolchain zig=$ZIG"; exit 2; }

PEN="$ROOT/.lap/cache-census.$$"
PRIV="$PEN/global-cache"
mkdir -p "$PEN/a" "$PEN/b" "$PRIV" || { echo "verdict=no_pen"; exit 2; }
trap 'rm -rf "$PEN"' EXIT

# A unique body per run, so a previous run's cache entry can never answer for this one.
UNIQ=$(date +%s%N)
printf 'const std = @import("std");\npub fn main() void { std.debug.print("census %s {d}\\n", .{42}); }\n' "$UNIQ" > "$PEN/a/x.zig"
cp "$PEN/a/x.zig" "$PEN/b/x.zig"

count() { find "$PRIV" -type f | wc -l; }

build() {
    # $1 directory, $2 output name. Private global cache; local cache beside the source.
    (cd "$1" && ZIG_GLOBAL_CACHE_DIR="$PRIV" ZIG_LOCAL_CACHE_DIR="$1/.zc" "$ZIG" build-exe x.zig "-femit-bin=$2" >/dev/null 2>&1)
}

c0=$(count); build "$PEN/a" x_a; c1=$(count)
build "$PEN/b" x_b; c2=$(count)
build "$PEN/a" x_again; c3=$(count)

miss=$((c1 - c0)); hit=$((c2 - c1)); again=$((c3 - c2))
echo "miss_new_files=$miss"
echo "same_src_other_path_new_files=$hit"
echo "same_path_again_new_files=$again"

if [ "$miss" -le 0 ]; then
    echo "verdict=no_miss_observed -- the first build wrote nothing, so the reading cannot be trusted"
    exit 2
fi
if [ "$hit" -eq 0 ]; then
    echo "path_independent=yes -- identical source at another checkout path reuses the compile cache"
    exit 0
fi
echo "path_independent=no -- the cache key carries the directory; a shared cache would not dedupe across checkouts"
exit 1
