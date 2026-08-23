#!/bin/sh
# tools/fixtures/fetch_toolchain_scan.sh -- fetch and verify the pinned Zig toolchain.
#
# WHY THIS EXISTS. `docs-geode/tutorials/the-first-hour.md` walked six steps, and five of them were
# commands a reader could copy. Step two was a download done by hand, named honestly as the
# roughest edge on the beginner path. This is that edge, smoothed: one command, verified before a
# byte is trusted.
#
# THE POLICY WAS ALREADY SEATED, only unimplemented. `context/specs/20260627-102012_one-clock-
# naming-law.md` names the release, the checksum discipline, and Zig's own minisign public key
# `RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U`. This writes down what that policy
# does rather than inventing a new one.
#
# WHY THE CHECKSUMS ARE PINNED HERE RATHER THAN FETCHED. Reading the expected hash from the same
# host that serves the tarball protects against a corrupted download and nothing else -- whoever
# controls the host controls both numbers. A hash pinned in this file comes from the repository's
# own signed history instead, so a reader is trusting the commit log rather than the weather on a
# web server. Every hash below was taken from Zig's published `index.json` and the x86_64-linux one
# was then CONFIRMED BY DOWNLOAD on `20260821.182000` rather than transcribed and hoped for.
#
# WHAT IS DELIBERATELY NOT CLAIMED. `minisign` is absent from this pier, so the signature leg of
# the seated policy is not run here. The pinned sha256 is the protection this tool actually
# provides, and saying so plainly is better than a comment implying two checks where one runs.
# When `minisign` is present, verifying the `.minisig` beside the tarball is strictly better and
# the policy spec tells you how.
#
# USAGE
#   sh tools/fixtures/fetch_toolchain_scan.sh              # fetch if absent, verify, extract
#   sh tools/fixtures/fetch_toolchain_scan.sh plan         # say what it would do; touch nothing
#   sh tools/fixtures/fetch_toolchain_scan.sh verify F H    # verify one file against one hash
#
# Driven by tools/f/fetch_toolchain.rish; proven by tools/f/fetch_toolchain_witness.rish.
# Run from the repository root.

set -eu

ZIG_VERSION=0.16.0
# Overridable so a real fetch can be proven into a throwaway directory without risking the
# toolchain this tree is currently compiling through.
DEST="${ZIG_TOOLCHAIN_DEST:-vendor/zig-toolchain}"

# platform-key  sha256  size
PINS="x86_64-linux  70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00  55478392
aarch64-linux ea4b09bfb22ec6f6c6ceac57ab63efb6b46e17ab08d21f69f3a48b38e1534f17  51211944
aarch64-macos b23d70deaa879b5c2d486ed3316f7eaa53e84acf6fc9cc747de152450d401489  52238004
x86_64-macos  0387557ed1877bc6a2e1802c8391953baddba76081876301c522f52977b52ba7  57396836"

verb="${1:-fetch}"

digest() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1
  else echo "no sha256 tool on this host" >&2; return 1
  fi
}

# verify <file> <expected-hash> -- the whole trust decision, in one place so it can be tested.
if [ "$verb" = verify ]; then
  file="${2:?name the file to verify}"
  expect="${3:?name the expected sha256}"
  [ -f "$file" ] || { echo "verify: no such file: $file" >&2; echo "verdict=missing"; exit 1; }
  got="$(digest "$file")"
  echo "expected=$expect"
  echo "computed=$got"
  if [ "$got" = "$expect" ]; then echo "verdict=verified"; exit 0; fi
  echo "verdict=REFUSED"
  echo "refused: the download does not match the pinned checksum -- it is NOT extracted" >&2
  exit 1
fi

case "$(uname -s)" in
  Linux)  os=linux ;;
  Darwin) os=macos ;;
  *) echo "platform=$(uname -s) verdict=unsupported"; echo "This tool pins four platforms; yours is not one. Add its hash from ziglang.org/download/index.json." >&2; exit 1 ;;
esac
case "$(uname -m)" in
  x86_64|amd64)  arch=x86_64 ;;
  aarch64|arm64) arch=aarch64 ;;
  *) echo "platform=$(uname -m) verdict=unsupported"; echo "This tool pins x86_64 and aarch64 only." >&2; exit 1 ;;
esac
key="${arch}-${os}"

line=$(printf '%s\n' "$PINS" | awk -v k="$key" '$1 == k {print; exit}')
[ -n "$line" ] || { echo "platform=$key verdict=unpinned"; echo "No pinned checksum for $key." >&2; exit 1; }
sha=$(printf '%s' "$line" | awk '{print $2}')
size=$(printf '%s' "$line" | awk '{print $3}')
url="https://ziglang.org/download/${ZIG_VERSION}/zig-${key}-${ZIG_VERSION}.tar.xz"

echo "platform=$key"
echo "version=$ZIG_VERSION"
echo "url=$url"
echo "sha256=$sha"
echo "size=$size"

# Already standing? Then this is a no-op, and a fresh run costs nothing.
if [ -x "$DEST/zig" ] && [ "$("$DEST/zig" version 2>/dev/null || true)" = "$ZIG_VERSION" ]; then
  echo "already=yes"
  echo "verdict=ok"
  exit 0
fi
echo "already=no"

if [ "$verb" = plan ]; then
  echo "planned=fetch_verify_extract"
  echo "verdict=ok"
  exit 0
fi

command -v curl >/dev/null 2>&1 || { echo "fetch: curl is required" >&2; exit 1; }
command -v tar  >/dev/null 2>&1 || { echo "fetch: tar is required" >&2; exit 1; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
tarball="$work/zig.tar.xz"

echo "fetching..."
curl -fL --retry 3 --retry-delay 2 -o "$tarball" "$url"

# Nothing is extracted until the bytes are the bytes we pinned.
got="$(digest "$tarball")"
echo "computed=$got"
if [ "$got" != "$sha" ]; then
  echo "verdict=REFUSED"
  echo "refused: downloaded bytes do not match the pinned checksum -- nothing was extracted" >&2
  exit 1
fi
echo "verified=yes"

# Extract into place. The release unpacks to one top directory; its contents become DEST, so the
# path this tree already names -- vendor/zig-toolchain/zig -- is what appears.
#
# THE ORDER HERE IS THE SAFETY. The new toolchain is extracted and asked its own version BEFORE
# the standing one is touched, so a truncated archive or a surprise layout leaves the compiler
# this tree is currently building through exactly where it was. An earlier shape removed the
# destination first and checked the version after, which meant the one failure mode that matters
# -- a fetch that half-works -- would have left a reader with no toolchain at all.
mkdir -p "$work/x"
tar -xJf "$tarball" -C "$work/x"
top="$(find "$work/x" -mindepth 1 -maxdepth 1 -type d | head -1)"
[ -n "$top" ] || { echo "fetch: the archive held no directory" >&2; exit 1; }

staged="$("$top/zig" version 2>/dev/null || true)"
echo "staged=$staged"
if [ "$staged" != "$ZIG_VERSION" ]; then
  echo "verdict=wrong_version"
  echo "refused: the extracted toolchain reports '$staged' -- nothing was replaced" >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
mv "$top" "$DEST"

installed="$("$DEST/zig" version 2>/dev/null || true)"
echo "installed=$installed"
[ "$installed" = "$ZIG_VERSION" ] || { echo "verdict=wrong_version"; exit 1; }
echo "verdict=ok"
