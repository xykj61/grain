#!/bin/bash
# make_key_card_macos.sh — render identity "key cards" (landscape + portrait)
# on macOS, in a plain white-on-black-safe palette, from public key fingerprints.
#
# The macOS sibling of tools/make-key-card.sh (which is Linux-centric: it builds
# libqrencode from vendored source and assumes apt/fonts-firacode). This one uses
# the system/Homebrew `qrencode` and `magick`, and a monospace font fallback
# chain, so it runs on a stock Mac with two Homebrew packages and nothing else.
#
# Dependencies (install once, Homebrew):
#   brew install qrencode imagemagick
# A monospace font is resolved automatically (Fira Code if installed, else Menlo,
# else the first monospace fontconfig offers).
#
# Personal details are read from a config file (default: tools/key-card.conf), so
# this works for anyone who clones the repository:
#   cp tools/key-card.conf.example tools/key-card.conf   # then fill in your details
#   ./tools/make_key_card_macos.sh
# The real config is gitignored; only the .example template is committed.
#
# Palette: defaults to PLAIN — white background, black text and QR — which prints
# cleanly, scans reliably, and reads the same on any screen. Override BG/FG in the
# config for a themed card.
#
# TAME horizon: both halves — QR encoding and card composition — are marked for
# eventual reimplementation in Glow, like the Linux script's own note.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="${1:-$REPO/tools/key-card.conf}"

[ -f "$CONF" ] || { echo "No config at $CONF — copy tools/key-card.conf.example to it and fill it in."; exit 1; }
# shellcheck source=/dev/null
. "$CONF"

: "${NAME:?set NAME in the config}"
: "${HANDLE:?set HANDLE in the config}"
: "${EMAIL:?set EMAIL in the config}"
: "${FP_SSH_CODEBERG:?set FP_SSH_CODEBERG in the config}"
: "${FP_SSH_GITHUB:?set FP_SSH_GITHUB in the config}"
: "${FP_OPENPGP:?set FP_OPENPGP in the config}"

# Plain palette by default: white background, black foreground.
BG="${BG:-#FFFFFF}"; FG="${FG:-#000000}"
L1="${LABEL_1:-SSH · Codeberg}"; L2="${LABEL_2:-SSH · GitHub}"; L3="${LABEL_3:-OpenPGP · sign}"
FOOTER="${FOOTER:-three public keys · ed25519 ssh + openpgp}"

# Tooling: require qrencode and an ImageMagick command, name the fix if missing.
command -v qrencode >/dev/null 2>&1 || { echo "qrencode not found — install it: brew install qrencode"; exit 1; }
if command -v magick >/dev/null 2>&1; then IM="magick"; elif command -v convert >/dev/null 2>&1; then IM="convert"; else
  echo "ImageMagick not found — install it: brew install imagemagick"; exit 1; fi

# Resolve a monospace font, preferring Fira Code, then Menlo, then whatever
# fontconfig offers for "monospace". fc-match never fails — it returns its best
# guess — so a request for "Fira Code" on a Mac without it comes back as a
# proportional fallback (e.g. Verdana). Fingerprints must be monospace, so we
# accept a match only when its resolved family actually equals what we asked
# for; otherwise we fall through. Menlo ships on every Mac, so this succeeds.
FONT=""; FONT_FAMILY=""
resolve_font() {
  local want="$1" file family
  family="$(fc-match -f '%{family}' "$want" 2>/dev/null || true)"
  # fc-match never fails — it returns its best guess — so accept a match only
  # when the resolved family actually equals what we asked for (fingerprints
  # must be monospace, never a proportional fallback like Verdana).
  printf '%s' "$family" | grep -qi "$want" || return 1
  file="$(fc-match -f '%{file}' "$want" 2>/dev/null || true)"
  [ -n "$file" ] && [ -f "$file" ] || return 1
  FONT="$file"
  FONT_FAMILY="$(printf '%s' "$family" | tr 'A-Z ' 'a-z_' | tr -cd 'a-z0-9_')"
  return 0
}
resolve_font 'Fira Code' || resolve_font 'Menlo' || resolve_font 'Monaco' || true
if [ -z "$FONT" ]; then
  FONT="$(fc-match -f '%{file}' monospace 2>/dev/null || true)"
  FONT_FAMILY="$(fc-match -f '%{family}' monospace 2>/dev/null | tr 'A-Z ' 'a-z_' | tr -cd 'a-z0-9_')"
fi
[ -n "$FONT" ] || { echo "No monospace font resolvable via fontconfig."; exit 1; }
[ -n "$FONT_FAMILY" ] || FONT_FAMILY="mono"
FONTB="$(fc-match -f '%{file}' 'Fira Code:weight=bold' 2>/dev/null || echo "$FONT")"
[ -f "$FONTB" ] || FONTB="$FONT"
FONTM="$FONT"

W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
qr() { qrencode -o "$W/$1.png" -m 2 -s 12 -l M --foreground="${FG#\#}" --background="${BG#\#}" "$2"; }
qr cb  "$FP_SSH_CODEBERG"
qr gh  "$FP_SSH_GITHUB"
qr pgp "$FP_OPENPGP"

S=1024; QSZ=220; CW=290
DIAMOND="polyline 512,46 864,236 512,426 160,236 512,46"
NY=160
FOOT=956
SQ="$W/square.png"

for k in cb gh pgp; do "$IM" "$W/$k.png" -filter point -resize ${QSZ}x${QSZ} "$W/${k}_r.png"; done
"$IM" -background "$BG" -fill "$FG" -font "$FONT" -pointsize 15 -size ${CW}x caption:"$FP_SSH_CODEBERG" "$W/cap_cb.png"
"$IM" -background "$BG" -fill "$FG" -font "$FONT" -pointsize 15 -size ${CW}x caption:"$FP_SSH_GITHUB"  "$W/cap_gh.png"
"$IM" -background "$BG" -fill "$FG" -font "$FONT" -pointsize 15 -size ${CW}x caption:"$FP_OPENPGP"     "$W/cap_pgp.png"

"$IM" -size ${S}x${S} xc:"$BG" \
  -fill none -stroke "$FG" -strokewidth 3 -draw "$DIAMOND" \
  -stroke none -gravity North -fill "$FG" \
  -font "$FONTB" -pointsize 44 -annotate +0+$((NY)) "$NAME" \
  -font "$FONT" -pointsize 22 -annotate +0+$((NY+66)) "@$HANDLE" \
  -annotate +0+$((NY+102)) "$EMAIL" \
  "$SQ"

place() {
  local label="$1" qr="$2" cap="$3" lx="$4" ly="$5" qx="$6" qy="$7" cx="$8" cy="$9"
  "$IM" "$SQ" -gravity North -fill "$FG" -font "$FONTM" -pointsize 21 -annotate +${lx}+${ly} "$label" "$SQ"
  "$IM" "$SQ" -gravity North "$W/${qr}_r.png"    -geometry +${qx}+${qy} -composite "$SQ"
  "$IM" "$SQ" -gravity North "$W/cap_${cap}.png" -geometry +${cx}+${cy} -composite "$SQ"
}
place "$L1" cb  cb  -312 488 -312 530 -312 770
place "$L2" gh  gh     0 488    0 530    0 770
place "$L3" pgp pgp  312 488  312 530  312 770
"$IM" "$SQ" -gravity North -fill "$FG" -font "$FONT" -pointsize 18 -annotate +0+${FOOT} "$FOOTER" "$SQ"

LAND="$REPO/keys_${FONT_FAMILY}_${HANDLE}_landscape.png"
PORT="$REPO/keys_${FONT_FAMILY}_${HANDLE}_portrait.png"
"$IM" "$SQ" -background "$BG" -gravity center -extent 1365x1024 "$LAND"
"$IM" "$SQ" -background "$BG" -gravity center -extent 1024x1365 "$PORT"
echo "wrote:"
"$IM" identify -format '  %f  %wx%h  %[colorspace]\n' "$LAND" "$PORT"
