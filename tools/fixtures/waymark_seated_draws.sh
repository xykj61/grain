#!/bin/sh
# Re-derive seated corpus-drawn waymarks against a sorted-unique corpus file.
# Usage: waymark_seated_draws.sh <corpus.txt>
# Expects one [A-Z]{4} word per line; exits non-zero on any mismatch.
set -eu
corpus="${1:?corpus path required}"
size="$(wc -l < "$corpus" | tr -d ' ')"
# SHA3-512 from this tree's own Keccak (crypto/sha3_digest.rye), not from an openssl the host may
# or may not carry. Same algorithm, so every seated draw below is unchanged -- and the registry
# witness re-derives all of them, so a drift of one digit would red on the lap it entered.
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
SHA3="$_fd_root/tools/fixtures/s/sha3.sh"
draw() {
  name="$1"
  expect="$2"
  hash8="$(printf '%s' "$name" | sh "$SHA3" 512 - | cut -c1-8)"
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
draw source-pier-papers-identity-refresh SUNN
# POLE is hand-seated since the 20260825 debride; its input is not re-derived.
