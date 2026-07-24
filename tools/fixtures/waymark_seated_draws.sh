#!/bin/sh
# Re-derive seated corpus-drawn waymarks against a sorted-unique corpus file.
# Usage: waymark_seated_draws.sh <corpus.txt>
# Expects one [A-Z]{4} word per line; exits non-zero on any mismatch.
set -eu
corpus="${1:?corpus path required}"
size="$(wc -l < "$corpus" | tr -d ' ')"
draw() {
  name="$1"
  expect="$2"
  hash8="$(printf '%s' "$name" | openssl dgst -sha3-512 | awk '{print $NF}' | cut -c1-8)"
  dec="$(printf '%d' "0x$hash8")"
  idx="$((dec % size + 1))"
  word="$(awk -v n="$idx" 'NR==n' "$corpus")"
  if [ "$word" != "$expect" ]; then
    echo "RED: $name -> $word (want $expect)" >&2
    exit 1
  fi
  echo "OK $name -> $word"
}
draw grapheneos-pixel-mobile-emulation HAWM
draw glow-application-framework-and-publishing TUBE
draw glow-english-qwerty-glass-keyboard-3 ZETA
draw sala-broadcast-live-session-fold JABS
draw glow-glass-hearth-display-and-wired-sync LULU
draw glow-language-rune-heads-nest-and-lowering-2 STOA
