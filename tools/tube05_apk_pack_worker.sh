#!/usr/bin/env bash
# tube05_apk_pack_worker.sh — package the first Glow NativeActivity APK.
#
# Host-side worker for TUBE0.5 packaging. Builds:
#   1. AndroidManifest.xml via linengrow/tube_android_manifest_emit.rye
#   2. libglowapp.so (aarch64-linux-android) from glow_native_activity.rye
#   3. an unsigned-then-debug-signed APK via aapt + apksigner
#
# Run from the repository root (usually via tools/tube05_apk_pack_witness.rish):
#   ./tools/tube05_apk_pack_worker.sh
#
# Outputs under tools/.cache/tube05/ (gitignored via tools/.cache/).

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SDK="$ROOT/tools/.cache/hawm0/android-sdk"
JDK="$ROOT/tools/.cache/hawm0/jdk"
BT="$SDK/build-tools/36.0.0"
ANDROID_JAR="$SDK/platforms/android-36/android.jar"
ZIG="$ROOT/vendor/zig-toolchain/zig"
CACHE="$ROOT/tools/.cache/tube05"
STAGING="$CACHE/staging"
APK_UNSIGNED="$CACHE/sala-broadcaster-unsigned.apk"
APK_ALIGNED="$CACHE/sala-broadcaster-aligned.apk"
APK_SIGNED="$CACHE/sala-broadcaster.apk"
KEYSTORE="$CACHE/debug.keystore"
LIB_SO="$ROOT/linengrow/bin/libglowapp.so"

export JAVA_HOME="$JDK"
export PATH="$JDK/bin:$PATH"

die() { echo "tube05-pack: RED — $*" >&2; exit 1; }

test -x "$BT/aapt" || die "missing aapt — install build-tools;36.0.0 under $SDK"
test -x "$BT/apksigner" || die "missing apksigner"
test -x "$BT/zipalign" || die "missing zipalign"
test -f "$ANDROID_JAR" || die "missing android.jar at $ANDROID_JAR"
test -x "$ZIG" || die "missing zig toolchain"
test -x "$ROOT/rye/bin/rye" || die "missing rye/bin/rye"

rm -rf "$STAGING" "$APK_UNSIGNED" "$APK_ALIGNED" "$APK_SIGNED"
mkdir -p "$STAGING" "$CACHE" "$ROOT/linengrow/bin"

echo "tube05-pack: emitting AndroidManifest.xml from the TUBE0 mold…"
env RYE_ZIG="$ZIG" rye/bin/rye build \
  linengrow/tube_android_manifest_emit.rye \
  -femit-bin=linengrow/bin/tube_android_manifest_emit \
  || die "manifest emit binary failed to build"
linengrow/bin/tube_android_manifest_emit "$STAGING/AndroidManifest.xml" \
  || die "manifest emit failed"
grep -q 'android.app.NativeActivity' "$STAGING/AndroidManifest.xml" \
  || die "emitted manifest missing NativeActivity"
grep -q 'android.permission.INTERNET' "$STAGING/AndroidManifest.xml" \
  || die "emitted manifest missing INTERNET permission"

echo "tube05-pack: building libglowapp.so for aarch64-linux-android…"
# Rye's own bridge is for rye build → zig build-exe; shared libraries use
# zig build-lib directly on a bridge copy that only imports std.
cp linengrow/glow_native_activity.rye "$CACHE/glow_native_activity.zig"
"$ZIG" build-lib -dynamic -target aarch64-linux-android -fPIC -OReleaseSafe \
  -femit-bin="$LIB_SO" "$CACHE/glow_native_activity.zig" \
  || die "libglowapp.so failed to build"
file "$LIB_SO" | grep -q 'ARM aarch64' || die "libglowapp.so is not aarch64"
nm -D "$LIB_SO" | grep -q 'ANativeActivity_onCreate' \
  || die "libglowapp.so missing ANativeActivity_onCreate export"

mkdir -p "$STAGING/lib/arm64-v8a"
cp "$LIB_SO" "$STAGING/lib/arm64-v8a/libglowapp.so"

echo "tube05-pack: packaging APK with aapt…"
"$BT/aapt" package -f \
  -M "$STAGING/AndroidManifest.xml" \
  -I "$ANDROID_JAR" \
  -F "$APK_UNSIGNED" \
  || die "aapt package failed"

# aapt package does not always pull lib/ from -S; add the .so explicitly.
(
  cd "$STAGING"
  "$BT/aapt" add "$APK_UNSIGNED" "lib/arm64-v8a/libglowapp.so" \
    || die "aapt add libglowapp.so failed"
)

echo "tube05-pack: zipalign…"
"$BT/zipalign" -f 4 "$APK_UNSIGNED" "$APK_ALIGNED" || die "zipalign failed"

if [[ ! -f "$KEYSTORE" ]]; then
  echo "tube05-pack: generating a local debug keystore (dev-only, not for publish)…"
  keytool -genkeypair -v \
    -keystore "$KEYSTORE" \
    -storepass android \
    -keypass android \
    -alias glowdebug \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=Glow TUBE0.5 Debug, OU=Dev, O=Glow, L=Local, ST=NY, C=US" \
    || die "keytool failed"
fi

echo "tube05-pack: signing with the local debug keystore…"
"$BT/apksigner" sign \
  --ks "$KEYSTORE" \
  --ks-pass pass:android \
  --key-pass pass:android \
  --ks-key-alias glowdebug \
  --out "$APK_SIGNED" \
  "$APK_ALIGNED" \
  || die "apksigner failed"

"$BT/apksigner" verify "$APK_SIGNED" || die "apksigner verify failed"
"$BT/aapt" dump badging "$APK_SIGNED" | tee "$CACHE/badging.txt" \
  || die "aapt dump badging failed"

grep -q "package: name='org.glow.app.sala_broadcaster'" "$CACHE/badging.txt" \
  || die "badging missing expected package name"
grep -q "native-code: 'arm64-v8a'" "$CACHE/badging.txt" \
  || die "badging missing arm64-v8a native-code"

# Confirm the .so is inside the signed APK. Write the listing first so a
# short-circuiting grep cannot SIGPIPE unzip under `set -o pipefail`.
unzip -l "$APK_SIGNED" > "$CACHE/apk-list.txt"
grep -F 'lib/arm64-v8a/libglowapp.so' "$CACHE/apk-list.txt" >/dev/null \
  || die "signed APK missing lib/arm64-v8a/libglowapp.so"

echo "GREEN: TUBE0.5 APK packed — $APK_SIGNED"
echo "tube05-pack: package=org.glow.app.sala_broadcaster abi=arm64-v8a lib=libglowapp.so"
exit 0
