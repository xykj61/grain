#!/usr/bin/env bash
# tube05_apk_pack_worker.sh — package the Glow NativeActivity APK.
#
# Host-side worker for TUBE0.5 packaging. Builds:
#   1. AndroidManifest.xml via linengrow/tube_android_manifest_emit.rye
#   2. libglowapp.so for aarch64 (Pixel) and x86_64 (HAWM0 emulator):
#        rye build-lib -fsingle-threaded → static .a (Sala B0 fold)
#        NDK clang -shared → real .so with DT_NEEDED libc
#   3. an unsigned-then-debug-signed APK via aapt + apksigner
#
# Why this link path: Zig's plain -dynamic android .so has no DT_NEEDED and
# leaves libc symbols undefined; Android dlopen refuses it. Single-threaded
# archive + NDK link is the fix. glow_native_activity exports a no-op
# __zig_probe_stack so we do not depend on a PIC Zig compiler-rt in cache.
#
#   ./tools/tube05_apk_pack_worker.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SDK="$ROOT/tools/.cache/hawm0/android-sdk"
JDK="$ROOT/tools/.cache/hawm0/jdk"
BT="$SDK/build-tools/36.0.0"
ANDROID_JAR="$SDK/platforms/android-36/android.jar"
NDK="$SDK/ndk/28.2.13676358"
NDK_BIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
ZIG="$ROOT/vendor/zig-toolchain/zig"
CACHE="$ROOT/tools/.cache/tube05"
ZIG_CACHE="$CACHE/zig-cache"
STAGING="$CACHE/staging"
APK_UNSIGNED="$CACHE/sala-broadcaster-unsigned.apk"
APK_ALIGNED="$CACHE/sala-broadcaster-aligned.apk"
APK_SIGNED="$CACHE/sala-broadcaster.apk"
KEYSTORE="$CACHE/debug.keystore"

export JAVA_HOME="$JDK"
export PATH="$JDK/bin:$PATH"

die() { echo "tube05-pack: RED - $*" >&2; exit 1; }

build_android_so() {
  local zig_target="$1"
  local api_triple="$2"
  local abi_dir="$3"
  local archive="$ROOT/linengrow/bin/libglow_${abi_dir}.a"
  local so_out="$STAGING/lib/${abi_dir}/libglowapp.so"
  local clang="$NDK_BIN/${api_triple}-clang"

  echo "tube05-pack: rye build-lib -fsingle-threaded -> ${archive} (${zig_target})..."
  mkdir -p "$ZIG_CACHE"
  env RYE_ZIG="$ZIG" rye/bin/rye build-lib \
    linengrow/glow_native_activity.rye \
    -target "$zig_target" -fPIC -OReleaseSafe -fsingle-threaded \
    -femit-bin="$archive" \
    --cache-dir "$ZIG_CACHE" \
    || die "build-lib archive failed for ${zig_target}"

  test -x "$clang" || die "missing NDK clang at ${clang}"
  mkdir -p "$(dirname "$so_out")"

  # glow_native_activity.rye exports a no-op __zig_probe_stack so both ABIs
  # NDK-link without depending on a PIC Zig compiler-rt in the host cache.
  echo "tube05-pack: NDK clang -shared -> ${so_out}..."
  "$clang" -shared -o "$so_out" \
    -Wl,--whole-archive "$archive" -Wl,--no-whole-archive \
    -lc -ldl -lm -llog -landroid \
    -Wl,-soname,libglowapp.so \
    -Wl,--no-undefined \
    || die "NDK link failed for ${abi_dir}"

  file "$so_out" | grep -q 'shared object' || die "${so_out} is not a shared object"
  nm -D "$so_out" | grep -q 'ANativeActivity_onCreate' \
    || die "${so_out} missing ANativeActivity_onCreate"
  nm -D "$so_out" | grep -q 'glow_last_session_root_hex' \
    || die "${so_out} missing glow_last_session_root_hex"
  readelf -d "$so_out" | grep -q 'NEEDED.*libc.so' \
    || die "${so_out} missing DT_NEEDED libc.so"
  if nm -D "$so_out" | grep -q ' U __tls_get_addr$'; then
    die "${so_out} still has undefined __tls_get_addr - single-threaded build failed"
  fi
  if nm -D "$so_out" | grep -q ' U __zig_probe_stack$'; then
    die "${so_out} still has undefined __zig_probe_stack"
  fi
}

test -x "$BT/aapt" || die "missing aapt"
test -x "$BT/apksigner" || die "missing apksigner"
test -x "$BT/zipalign" || die "missing zipalign"
test -f "$ANDROID_JAR" || die "missing android.jar"
test -d "$NDK" || die "missing NDK at $NDK - sdkmanager 'ndk;28.2.13676358'"
test -x "$ZIG" || die "missing zig"
test -x "$ROOT/rye/bin/rye" || die "missing rye"
rye/bin/rye help 2>&1 | grep -q 'build-lib' || die "rye lacks build-lib"

rm -rf "$STAGING" "$APK_UNSIGNED" "$APK_ALIGNED" "$APK_SIGNED"
mkdir -p "$STAGING" "$CACHE" "$ROOT/linengrow/bin"

echo "tube05-pack: emitting AndroidManifest.xml..."
env RYE_ZIG="$ZIG" rye/bin/rye build \
  linengrow/tube_android_manifest_emit.rye \
  -femit-bin=linengrow/bin/tube_android_manifest_emit \
  || die "manifest emit build failed"
linengrow/bin/tube_android_manifest_emit "$STAGING/AndroidManifest.xml" \
  || die "manifest emit failed"
grep -q 'android.app.NativeActivity' "$STAGING/AndroidManifest.xml" \
  || die "manifest missing NativeActivity"

build_android_so "aarch64-linux-android" "aarch64-linux-android28" "arm64-v8a"
build_android_so "x86_64-linux-android" "x86_64-linux-android28" "x86_64"

echo "tube05-pack: packaging APK..."
"$BT/aapt" package -f \
  -M "$STAGING/AndroidManifest.xml" \
  -I "$ANDROID_JAR" \
  -F "$APK_UNSIGNED" \
  || die "aapt package failed"
(
  cd "$STAGING"
  "$BT/aapt" add "$APK_UNSIGNED" "lib/arm64-v8a/libglowapp.so"
  "$BT/aapt" add "$APK_UNSIGNED" "lib/x86_64/libglowapp.so"
)

"$BT/zipalign" -f 4 "$APK_UNSIGNED" "$APK_ALIGNED" || die "zipalign failed"

if [[ ! -f "$KEYSTORE" ]]; then
  keytool -genkeypair -v \
    -keystore "$KEYSTORE" -storepass android -keypass android \
    -alias glowdebug -keyalg RSA -keysize 2048 -validity 10000 \
    -dname "CN=Glow TUBE0.5 Debug, OU=Dev, O=Glow, L=Local, ST=NY, C=US"
fi

"$BT/apksigner" sign \
  --ks "$KEYSTORE" --ks-pass pass:android --key-pass pass:android \
  --ks-key-alias glowdebug --out "$APK_SIGNED" "$APK_ALIGNED" \
  || die "apksigner failed"
"$BT/apksigner" verify "$APK_SIGNED" || die "verify failed"
"$BT/aapt" dump badging "$APK_SIGNED" | tee "$CACHE/badging.txt"
grep -q "package: name='org.glow.app.sala_broadcaster'" "$CACHE/badging.txt"
grep -q "arm64-v8a" "$CACHE/badging.txt"
grep -q "x86_64" "$CACHE/badging.txt"

unzip -l "$APK_SIGNED" > "$CACHE/apk-list.txt"
grep -F 'lib/arm64-v8a/libglowapp.so' "$CACHE/apk-list.txt" >/dev/null
grep -F 'lib/x86_64/libglowapp.so' "$CACHE/apk-list.txt" >/dev/null

echo "GREEN: TUBE0.5 APK packed - $APK_SIGNED"
echo "tube05-pack: package=org.glow.app.sala_broadcaster abi=arm64-v8a,x86_64 fold=sala-b0 ndk-linked"
exit 0
