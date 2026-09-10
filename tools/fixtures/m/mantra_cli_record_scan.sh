#!/bin/sh
# tools/fixtures/m/mantra_cli_record_scan.sh -- what the Mantra CLI actually writes to disk.
#
# WHAT THIS READS. Every guard in the weave family proves a function inside
# mantra/src/weave.rye. None of them reads a byte the CLI wrote, and the gap
# mattered: the module could build a `mantra-weave-v2` record from `20260909`
# and mantra/src/main.rye kept serializing the elder three-field one, so a
# merged history had a format and no writer. This scan drives the built binary
# in a throwaway pen and reads the blobs off disk.
#
# WHY A BINARY RATHER THAN A CALL. `serialize_weave` and `deserialize_weave`
# are private to main.rye, and the claim under test is about bytes in a store
# rather than about a function's return. A reader that dispatched correctly and
# a writer that emitted the wrong header would both pass a unit reading and
# both lose a user's history.
#
# THE ELDER STORE IS TESTIMONY RATHER THAN A FORGERY. A store written before
# `20260909` must keep opening, and proving that needs a real one: blobs whose
# content-addressed names are the SHA3-256 digests the elder binary computed.
# tools/fixtures/m/mantra_elder_v1_store/ is such a store, made by the binary
# built from the commit before the writer changed and frozen here. It can never
# drift, because nothing in the tree writes that record any more.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   built=yes|no                the CLI compiled
#   fresh_header=<line 0>       the header a brand-new store's weave blob carries
#   counter_fields=<n>          fields on the record's counters line
#   row_fields=<n>              fields on a record row
#   elder_opens=yes|no          the frozen v1 store reads back without error
#   elder_status=<words>        what `status` says about its untouched file
#   mixed_header=<line 0>       the header a commit onto that elder store writes
#   mixed_opens=yes|no          the mixed chain reads back through both records
#   tampered_blob_refused=yes|no  a blob edited under someone else's name refuses
#   verdict=ok|red
#
# ONE OPTIONAL ARGUMENT: a path to a `main.rye` to build instead of the tree's
# own. The control passes a mutated copy in a pen, so this scan reads the pen's
# CLI while the readings and the elder store stay the tree's. Without it the
# scan reads mantra/src/main.rye, which is what every ordinary run wants.
#
# Run from the repository root. Driven by tools/m/mantra_cli_record_witness.rish.

set -eu

# The portable-dialect helpers, imported rather than restated: `sed -i` is a GNU spelling that
# reads as an empty edit on the other pier, where an empty reading counts as a healthy zero.
# Root by upward walk (seated 20260828), so the letter fold's depth is never spelled here.
_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sp_steps=0
while [ ! -d "$_sp_root/rishi/bin" ] || [ ! -d "$_sp_root/tools/fixtures" ]; do
  _sp_steps=$((_sp_steps + 1))
  if [ "$_sp_steps" -gt 8 ] || [ "$_sp_root" = "/" ] || [ -z "$_sp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _sp_root=$(dirname "$_sp_root")
done
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
elder="$root/tools/fixtures/m/mantra_elder_v1_store"
main_src="${1:-$root/mantra/src/main.rye}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

bin="$work/mantra"
if env RYE_ZIG="$zig" "$rye" build "$main_src" -femit-bin="$bin" >/dev/null 2>&1; then
  echo "built=yes"
else
  echo "built=no"
  echo "verdict=red"
  exit 0
fi

verdict=ok
note_red() { verdict=red; }

# --- a brand-new store: which record does the CLI write today? ---
fresh="$work/fresh"
mkdir -p "$fresh"
printf 'alpha\nbeta\ngamma\n' > "$fresh/f.txt"
( cd "$fresh" && "$bin" init >/dev/null 2>&1 && "$bin" add f.txt >/dev/null 2>&1 ) || note_red

weave_blob=""
for b in "$fresh"/.mantra/blobs/*; do
  [ -f "$b" ] || continue
  case "$(head -1 "$b")" in mantra-weave-*) weave_blob="$b" ;; esac
done
if [ -z "$weave_blob" ]; then
  echo "fresh_header=none"
  note_red
else
  echo "fresh_header=$(head -1 "$weave_blob")"
  echo "counter_fields=$(sed -n '2p' "$weave_blob" | awk -F'\t' '{print NF}')"
  echo "row_fields=$(sed -n '3p' "$weave_blob" | awk -F'\t' '{print NF}')"
fi

# --- the frozen elder store: does a v1 blob still open? ---
old="$work/old"
mkdir -p "$old/.mantra"
cp -r "$elder/HEAD" "$elder/blobs" "$old/.mantra/"
cp "$elder/doc.txt" "$old/doc.txt"
if ( cd "$old" && "$bin" status doc.txt >"$work/old.out" 2>&1 ); then
  echo "elder_opens=yes"
else
  echo "elder_opens=no"
  note_red
fi
echo "elder_status=$(sed -n '1p' "$work/old.out" | sed 's/^mantra status: //')"

# --- a commit onto that elder store: the chain crosses records ---
printf 'the first line\nthe second line\nthe third line\nthe fourth line\n' > "$old/doc.txt"
( cd "$old" && "$bin" add doc.txt >/dev/null 2>&1 ) || note_red
newest=""
for b in "$old"/.mantra/blobs/*; do
  [ -f "$b" ] || continue
  case "$(head -1 "$b")" in
    mantra-weave-v2) newest="$b" ;;
  esac
done
if [ -z "$newest" ]; then
  echo "mixed_header=none"
  note_red
else
  echo "mixed_header=$(head -1 "$newest")"
fi
if ( cd "$old" && "$bin" status doc.txt >"$work/mixed.out" 2>&1 ); then
  echo "mixed_opens=yes"
else
  echo "mixed_opens=no"
  note_red
fi

# --- a blob edited in place: refused, and it is the STORE that refuses it ---
#
# This reading names the store rather than the reader on purpose, and the
# distinction was measured rather than assumed. A first draft called it
# `bad_header_refused` and read it as proof that `deserialize_weave`'s final
# `return error.InvalidFormat` answers an unknown header. It does not, and it
# cannot: a blob's name IS its SHA3-256 digest, so `Store.read_blob` recomputes
# that digest and refuses `BlobNameMismatch` before a header is ever read. The
# header dispatch's own refusal is unreachable from disk while that check
# stands, which is a fact about the layering worth printing. A reading that
# reports the right answer for the wrong mechanism would let the dispatch rot
# while showing green.
bad="$work/bad"
mkdir -p "$bad"
cp -r "$fresh/.mantra" "$bad/.mantra"
cp "$fresh/f.txt" "$bad/f.txt"
for b in "$bad"/.mantra/blobs/*; do
  [ -f "$b" ] || continue
  case "$(head -1 "$b")" in
    mantra-weave-v2) sed_inplace '1s/.*/mantra-weave-v9/' "$b" ;;
  esac
done
if ( cd "$bad" && "$bin" status f.txt >/dev/null 2>&1 ); then
  echo "tampered_blob_refused=no"
  note_red
else
  echo "tampered_blob_refused=yes"
fi

echo "verdict=$verdict"
