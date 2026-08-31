#!/bin/sh
# kumara_tilak_bind_control.sh -- prove either half of a mutual bind is insufficient.
#
# Each plant removes one verification direction from a throwaway copy. The
# module's opposite-signature tamper must then fail the selftest, so a verifier
# that accepts a one-directional bind cannot pass the standing witness.

set -eu

root=$(pwd)
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT HUP INT TERM

mkdir -p "$pen/kumara" "$pen/tally" "$pen/comlink" "$pen/vendor/zig-toolchain"
cp kumara/tilak.rye "$pen/kumara/tilak.rye"
cp tally/kumara.rye "$pen/kumara/kumara.rye"
cp comlink/topology.rye "$pen/kumara/topology.rye"
ln -s "$root/vendor/zig-toolchain/zig" "$pen/vendor/zig-toolchain/zig"

plant_and_expect_red() {
    name=$1
    line=$2
    planted="$pen/kumara/tilak-$name.rye"
    binary="$pen/tilak-$name"

    sed "/$line/d" "$pen/kumara/tilak.rye" > "$planted"
    if env RYE_ZIG="$pen/vendor/zig-toolchain/zig" "$root/rye/bin/rye" build "$planted" -femit-bin="$binary" >/dev/null 2>&1 &&
       "$binary" selftest >/dev/null 2>&1; then
        echo "RED: $name one-directional bind plant passed"
        return 1
    fi
}

plant_and_expect_red key_only 'verify_bytes(&b.kumara_pubkey, &b.sig_by_keeper, keeper_pub)'
plant_and_expect_red keeper_only 'verify_bytes(&b.keeper_pubkey, &b.sig_by_key, key_pub)'

echo "GREEN: kumara bind control -- plants=2 reds=2; neither signature direction stands alone."
