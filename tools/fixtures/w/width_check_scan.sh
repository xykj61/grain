#!/bin/sh
# tools/fixtures/w/width_check_scan.sh -- the seam-aware authored-Rye width meter, with a body.
#
# WHY. `tools/w/width-check.rish` was fourteen lines for its whole life, from the root commit
# `ff870e7825` to `20260826`: a thirteen-line comment header and one binding, `let files = [...45
# paths...]`, and no code after it. It exited 0 in silence every time it ran. It sits on the
# standing roster, and `.claude/rules/tame-guidance.md`, `CLAUDE.md`, and the unattended loop's own
# seed all name it as the tree's live width lint, so every lap of its life reported a green that
# read nothing. Forty-five module names were added to that list one TAME-tidy round at a time, and
# nothing ever opened one of them (REDS %285).
#
# WHAT THE LINT IS. TAME Guidance: `usize` is a boundary type, not a design type. Prefer fixed
# widths in authored Rye; at the inherited-std seam, assert the bound and cast at the edge. So a
# line carrying `usize` beside `@intCast` or `@as(usize` is correct Tiger code rather than debt,
# and only a line carrying neither marker is flagged. That filter is not invented here -- it is the
# one `tools/w/width_check_th1.rish`, `th3`, and `th6` each already spell inline, lifted into one
# place so the four readings cannot drift apart. A lantern that fires three times becomes a loom.
#
# WHAT IS GATED, hard, at zero.
#   The DECLARED roster -- the forty-five modules `width-check.rish` has always named. Those names
#   are a promise the tree made module by module, and forty-four of them keep it. This is the
#   reading that refuses.
#
# THE ONE NAMED EXEMPTION, pinned rather than waived.
#   `rishi/src/main.rye` carries five `usize` locals -- `gi` and `start` at lines 1886 and 1887,
#   `i` at 1920, `total` at 1937, `pos` at 1945. Every one of them indexes a Zig slice or holds a
#   length against `.len`, and the line above the first reads `const size: usize = @intCast(size_i)`
#   -- the seam cast the filter already welcomes. They are the seam value carried onward, and the
#   filter is line-scoped, so it cannot see where a local came from. Converting them to `u32` would
#   add an `@intCast` at every slice site, which is more casts rather than fewer, against TAME's own
#   words that a seam cast is correct code and not debt. So the count is PINNED at five: these five
#   stand, and a sixth refuses. An exemption that names its lines cannot quietly grow.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls.
#   The DISCOVERED corpus -- every tracked `*.rye` outside `vendor/`, `aurora/`, and `gratitude/`,
#   and outside dated testimony. This is the reading that grows with the tree rather than when
#   somebody remembers, which is REDS %277's lesson applied to the roster that taught it. A file
#   born tomorrow is measured tomorrow.
#
# WHY aurora/ IS OUT. It is freestanding: `usize` is the machine word there -- addresses, CSRs,
# hardware masks -- governed by the freestanding width policy in TAME_GUIDANCE rather than by this
# hosted gate. The elder header said so, and it stays true.
#
# WHAT IS NOT PROVEN. That a fixed-width choice is the RIGHT width, and that a seam cast asserts
# its bound. Those are a reader's job. This proves that authored `usize` outside a seam is counted
# where the tree said it would be.
#
# USAGE
#   sh tools/fixtures/w/width_check_scan.sh [--root DIR]
#
# Driven by tools/w/width-check.rish. Run from the repository root.

set -u

root=.
if [ $# -ge 2 ] && [ "$1" = "--root" ]; then root=$2; fi

cd "$root" || { echo "verdict=not_at_root" >&2; exit 1; }
[ -f tools/w/width-check.rish ] || { echo "verdict=no_declared_roster" >&2; exit 1; }

# The ratchet's ceilings only ever fall. First measured 20260826.210603 at 359 files and 1,365
# lines over 1,891 sources -- the honest opening reading of a population nobody had ever counted.
# Lowered 20260828 to the sharper filter below, which drops comment prose, the inherited-C
# `extern fn` seam, and identifiers merely containing the five letters: 329 files and 1,263 lines
# over 1,899 sources, on a committed tree.
corpus_files_ceiling=329
corpus_lines_ceiling=1263

# The named exemption, pinned. Five seam-derived locals in the Rishi interpreter; see the header.
exempt_path=rishi/src/main.rye
exempt_pinned=5

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The seam-aware reading, in one place. A line is flagged when it carries the WORD `usize` in
# authored code and names no seam. Five filters, and each earns its place by a line the meter
# read wrong on 20260828.
#
#   `@intCast`, `@as(usize`   the inherited-std seam TAME already welcomes -- the elder pair.
#   a comment line            `//`, `///`, `//!` is prose. The header of tools/rye/objc_seam.rye
#                             says the word `usize` while declaring nothing, and 48 such lines
#                             stood across the corpus, each counted as authored width.
#   `extern fn`               the inherited-C seam. `CGBitmapContextCreate` takes `size_t` in
#                             CoreGraphics, so a Rye declaration of it MUST read `usize` or the
#                             call is wrong at the ABI. Converting one would break the binding
#                             rather than tighten it, so it is a seam by the same argument that
#                             seats `@intCast` -- the width is not ours to choose. 6 lines.
#   the whole word            `grep -w`. `n_usize` is an identifier holding a value some earlier
#                             `@intCast` already widened, and the line carries no type at all.
#                             52 lines read as authored width for having those five letters
#                             inside a name.
#
# Measured 20260828 over the same 1,899 sources: 362 files and 1,369 lines under the elder pair,
# 329 and 1,263 under all five. The 33 files and 106 lines between them were never authored width,
# and the ceilings below fall to the sharper reading. The gated DECLARED roster reads zero under
# both filters, so nothing this sharpening does can loosen the wall that refuses.
count_authored() {
  grep 'usize' "$1" 2>/dev/null \
    | grep -v '@intCast' \
    | grep -v '@as(usize' \
    | grep -vE '^[[:space:]]*//' \
    | grep -v 'extern fn' \
    | grep -cw 'usize' | tr -d ' '
}

# The DECLARED roster, read out of width-check.rish itself, so the file that makes the promise is
# the file that names the modules. A roster spelled twice is a roster that comes to disagree.
awk '/^let files = \[/' tools/w/width-check.rish | grep -oE '"[^"]+\.rye"' | tr -d '"' | sort -u > "$work/roster.txt"
roster_files=$(wc -l < "$work/roster.txt" | tr -d ' ')

: > "$work/roster_flagged.txt"
roster_missing=0
exempt_read=0
exempt_declared=no
while read -r p; do
  [ -n "$p" ] || continue
  [ "$p" = "$exempt_path" ] && exempt_declared=yes
  if [ ! -f "$p" ]; then roster_missing=$((roster_missing + 1)); echo "missing: $p" >> "$work/roster_flagged.txt"; continue; fi
  n=$(count_authored "$p")
  [ "$n" = "0" ] && continue
  if [ "$p" = "$exempt_path" ]; then exempt_read=$n; continue; fi
  printf '%s\t%s\n' "$n" "$p" >> "$work/roster_flagged.txt"
done < "$work/roster.txt"
roster_flagged=$(wc -l < "$work/roster_flagged.txt" | tr -d ' ')

# The DISCOVERED corpus. Dated testimony keeps every width it ever wrote (accrete-never-break),
# and the same line the fold, the resolver and the repointer draw is the line drawn here.
git ls-files '*.rye' 2>/dev/null \
  | grep -vE '^(vendor/|aurora/|gratitude/)' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' > "$work/corpus.txt"
corpus_files=$(wc -l < "$work/corpus.txt" | tr -d ' ')

corpus_flagged_files=0
corpus_flagged_lines=0
: > "$work/corpus_flagged.txt"
while read -r p; do
  [ -f "$p" ] || continue
  n=$(count_authored "$p")
  [ "$n" = "0" ] && continue
  corpus_flagged_files=$((corpus_flagged_files + 1))
  corpus_flagged_lines=$((corpus_flagged_lines + n))
  printf '%s\t%s\n' "$n" "$p" >> "$work/corpus_flagged.txt"
done < "$work/corpus.txt"

echo "declared_roster_files=$roster_files"
echo "declared_roster_missing=$roster_missing"
echo "declared_roster_flagged=$roster_flagged"
echo "exempt_path=$exempt_path"
echo "exempt_pinned=$exempt_pinned"
echo "exempt_declared=$exempt_declared"
echo "exempt_read=$exempt_read"
echo "corpus_files=$corpus_files"
echo "corpus_flagged_files=$corpus_flagged_files"
echo "corpus_files_ceiling=$corpus_files_ceiling"
echo "corpus_flagged_lines=$corpus_flagged_lines"
echo "corpus_lines_ceiling=$corpus_lines_ceiling"

[ "$roster_flagged" -eq 0 ] || sed 's/^/roster_flag: /' "$work/roster_flagged.txt"
[ "$exempt_declared" = "no" ] || [ "$exempt_read" -eq "$exempt_pinned" ] \
  || echo "exempt_moved: $exempt_path reads $exempt_read against a pin of $exempt_pinned"
[ "$corpus_flagged_files" -le "$corpus_files_ceiling" ] || sort -rn "$work/corpus_flagged.txt" | head -10 | sed 's/^/corpus_top: /'

if [ "$roster_flagged" -eq 0 ] \
  && [ "$roster_missing" -eq 0 ] \
  && { [ "$exempt_declared" = "no" ] || [ "$exempt_read" -eq "$exempt_pinned" ]; } \
  && [ "$corpus_flagged_files" -le "$corpus_files_ceiling" ] \
  && [ "$corpus_flagged_lines" -le "$corpus_lines_ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=authored_width_drift"
echo "refused: authored usize stands where the tree promised a fixed width -- read the lines above" >&2
exit 1
