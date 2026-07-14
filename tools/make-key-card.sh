#!/bin/bash
# make-key-card.sh — render Fira Code identity "key cards" (landscape + portrait).
#
# All content sits in a centered 1024x1024 square; that square is then padded to
# 4:3 (1365x1024 landscape, 1024x1365 portrait) in the configured palette, so the
# same square core reads identically in either orientation.
#
# Personal details are read from a config file (default: tools/key-card.conf), so
# this works for anyone who clones the repo:
#
#   cp tools/key-card.conf.example tools/key-card.conf   # then fill in your details
#   ./tools/make-key-card.sh
#
# The real config is gitignored; only the .example template is committed.
#
# Dependencies (see SOURCE.md): gcc, make, libpng-dev, pkg-config, ImageMagick,
# and the Fira Code font. QR codes come from libqrencode, vendored at
# gratitude/libqrencode and built here with gcc into tools/.build (gitignored).
#
# TAME Rye horizon: both halves of this tool — the QR encoding (libqrencode) and
# the card composition (ImageMagick) — are marked for reimplementation in Rye.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="${1:-$REPO/tools/key-card.conf}"
BUILD="$REPO/tools/.build"
SRC="$REPO/gratitude/libqrencode"

[ -f "$CONF" ] || { echo "No config at $CONF — copy tools/key-card.conf.example to it and fill it in."; exit 1; }
# shellcheck source=/dev/null
. "$CONF"

: "${NAME:?set NAME in the config}"
: "${HANDLE:?set HANDLE in the config}"
: "${EMAIL:?set EMAIL in the config}"
: "${FP_SSH_CODEBERG:?set FP_SSH_CODEBERG in the config}"
: "${FP_SSH_GITHUB:?set FP_SSH_GITHUB in the config}"
: "${FP_OPENPGP:?set FP_OPENPGP in the config}"
BG="${BG:-#FF7F00}"; FG="${FG:-#444400}"
L1="${LABEL_1:-SSH · Codeberg}"; L2="${LABEL_2:-SSH · GitHub}"; L3="${LABEL_3:-OpenPGP · sign}"
FOOTER="${FOOTER:-three public keys · ed25519 ssh + openpgp}"

# Resolve Fira Code (system-installed or otherwise discoverable via fontconfig).
FONT="$(fc-match -f '%{file}' 'Fira Code' 2>/dev/null || true)"
FONTB="$(fc-match -f '%{file}' 'Fira Code:weight=bold' 2>/dev/null || echo "$FONT")"
FONTM="$(fc-match -f '%{file}' 'Fira Code:weight=medium' 2>/dev/null || echo "$FONT")"
[ -n "$FONT" ] || { echo "Fira Code not found. Install it (e.g. apt install fonts-firacode)."; exit 1; }

# Build qrencode from the vendored source on first run (no system qrencode needed).
QR="$BUILD/qrencode"
if [ ! -x "$QR" ]; then
  echo "Building qrencode from $SRC ..."
  [ -f "$SRC/qrenc.c" ] || { echo "libqrencode source missing — run: git submodule update --init gratitude/libqrencode"; exit 1; }
  mkdir -p "$BUILD"
  cat > "$BUILD/config.h" <<'EOF'
/* Minimal config.h generated for a direct gcc build (no autotools/cmake). */
#define MAJOR_VERSION 4
#define MINOR_VERSION 1
#define MICRO_VERSION 1
#define VERSION "4.1.1"
#define STATIC_IN_RELEASE static
#define HAVE_PNG 1
#define HAVE_LIBPTHREAD 1
EOF
  gcc -DHAVE_CONFIG_H -I"$BUILD" -I"$SRC" -O2 \
    "$SRC"/bitstream.c "$SRC"/mask.c "$SRC"/mmask.c "$SRC"/mqrspec.c \
    "$SRC"/qrencode.c "$SRC"/qrinput.c "$SRC"/qrspec.c "$SRC"/rsecc.c \
    "$SRC"/split.c "$SRC"/qrenc.c \
    $(pkg-config --cflags --libs libpng) -lpthread -lm -o "$QR"
fi

W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT
qr() { "$QR" -o "$W/$1.png" -m 2 -s 12 -l M --foreground="${FG#\#}" --background="${BG#\#}" "$2"; }
qr cb  "$FP_SSH_CODEBERG"
qr gh  "$FP_SSH_GITHUB"
qr pgp "$FP_OPENPGP"

S=1024; QSZ=220; CW=290
DIAMOND="polyline 512,46 864,236 512,426 160,236 512,46"
NY=160
P_CB="-312 488 -312 530 -312 770"; P_GH="0 488 0 530 0 770"; P_PGP="312 488 312 530 312 770"; FOOT=956
SQ="$W/square.png"

for k in cb gh pgp; do convert "$W/$k.png" -filter point -resize ${QSZ}x${QSZ} "$W/${k}_r.png"; done
convert -background "$BG" -fill "$FG" -font "$FONT" -pointsize 15 -size ${CW}x caption:"$FP_SSH_CODEBERG" "$W/cap_cb.png"
convert -background "$BG" -fill "$FG" -font "$FONT" -pointsize 15 -size ${CW}x caption:"$FP_SSH_GITHUB"  "$W/cap_gh.png"
convert -background "$BG" -fill "$FG" -font "$FONT" -pointsize 15 -size ${CW}x caption:"$FP_OPENPGP"     "$W/cap_pgp.png"

convert -size ${S}x${S} xc:"$BG" \
  -fill none -stroke "$FG" -strokewidth 3 -draw "$DIAMOND" \
  -stroke none -gravity North -fill "$FG" \
  -font "$FONTB" -pointsize 44 -annotate +0+$((NY)) "$NAME" \
  -font "$FONT" -pointsize 22 -annotate +0+$((NY+66)) "@$HANDLE" \
  -annotate +0+$((NY+102)) "$EMAIL" \
  "$SQ"

place() {
  set -- "$1" "$2" "$3" $4
  local label="$1" qr="$2" cap="$3" lx="$4" ly="$5" qx="$6" qy="$7" cx="$8" cy="$9"
  convert "$SQ" -gravity North -fill "$FG" -font "$FONTM" -pointsize 21 -annotate +${lx}+${ly} "$label" "$SQ"
  convert "$SQ" -gravity North "$W/${qr}_r.png"   -geometry +${qx}+${qy} -composite "$SQ"
  convert "$SQ" -gravity North "$W/cap_${cap}.png" -geometry +${cx}+${cy} -composite "$SQ"
}
place "$L1" cb  cb  "$P_CB"
place "$L2" gh  gh  "$P_GH"
place "$L3" pgp pgp "$P_PGP"
convert "$SQ" -gravity North -fill "$FG" -font "$FONT" -pointsize 18 -annotate +0+${FOOT} "$FOOTER" "$SQ"

LAND="$REPO/keys_firacode_${HANDLE}_landscape.png"
PORT="$REPO/keys_firacode_${HANDLE}_portrait.png"
convert "$SQ" -background "$BG" -gravity center -extent 1365x1024 "$LAND"
convert "$SQ" -background "$BG" -gravity center -extent 1024x1365 "$PORT"
echo "wrote:"
identify -format '  %f  %wx%h\n' "$LAND" "$PORT"
