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
# THE STATED SEAM, welcomed by the RATCHET and refused by the GATE (20260917.100717).
#   TAME asks two things of a seam at once: cast at the edge, and SAY WHY. The elder filter
#   welcomed only the first. So a line reading `var i: usize = 0; // seam: slice index over a std
#   source buffer` -- which does exactly what the say-why rule asks -- was counted as the very debt
#   the sentence exists to explain, and the tree's own stated-seam discipline read as drift.
#
#   Measured 20260917.100717 over 1,983 sources: of the 1,258 flagged lines, 91 carry a trailing
#   comment, and ALL 91 name a seam -- not one flagged line carries a bare trailing comment. So the
#   welcome and the wider reading `a trailing comment of any kind` coincide exactly today, which is
#   what makes the narrower one free to take: it costs nothing now and refuses `// loop counter`
#   tomorrow. Welcoming drops 45 files to zero and both ceilings a long way, 327 to 282 files and
#   1,258 to 1,167 lines -- strictly tighter on the population nobody explained.
#
#   A STATED SEAM IS A CLAIM WHERE `@intCast` IS A MECHANISM, and that difference decides where it
#   is welcomed. A cast is checkable: the compiler carries it. A sentence is a person's word, so no
#   sentence a hand writes may open the wall that REFUSES. The welcome is therefore confined to the
#   DISCOVERED corpus ratchet, and the DECLARED roster gate above reads every file strictly -- the
#   same file, two readings, on purpose. The two are independent today: the roster reads zero
#   flagged under the strict filter, so no rostered module is standing on a sentence.
#
#   AND THE HATCH IS MEASURED RATHER THAN SILENT. `corpus_seam_stated_lines` prints how many lines
#   the welcome forgave and `corpus_seam_cleared_files` how many files it cleared, on every run, so
#   the escape hatch has a size a reader can watch rather than a silence.
#
#   WHAT IT CANNOT SEE. The scan is line-based, so a `//` inside a string literal followed by the
#   word `seam` would read as a stated seam. None stands today; the reading undercounts on purpose
#   rather than parsing, exactly as the comment meters one room over do.
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
# over 1,899 sources, on a committed tree. Lowered again 20260917.100717 when the corpus reading
# began welcoming a STATED seam, below: 282 files and 1,167 lines over 1,983 sources. Lowered
# again 20260917 when the `max_arm_len` three -- `lower_conditional`, `lower_null`,
# `lower_switch` -- delegated their `zig_safe_ident` to `glow/zig_ident.rye` and answered `u32`
# rather than `usize`: 277 files and 1,133 lines over 1,985 sources. Lowered again 20260917
# when `glow/lower_alias.rye` delegated the same way, its two call sites' return type moving
# `usize` to `u32`: 277 files and 1,131 lines over 1,985 sources. Unmoved at 1,129 when
# `glow/lower_shop_nest.rye` delegated (its return type was already `u32`), and unmoved again
# when `glow/lower_face_lit.rye` delegated its own `zig_safe_ident` the same way -- its own
# hand-rolled loop indexed with seam `usize` casts already read past by the strict filter:
# 276 files and 1,129 lines over 1,986 sources.
corpus_files_ceiling=282
corpus_lines_ceiling=1129

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
# ONE PROCESS PER FILE, NOT SIX. The elder form was a six-stage grep pipeline, and this function is
# called once for each of 1,985 files -- 11,910 processes to answer a question one awk pass answers.
# Every rule is carried over line for line: a line must contain `usize`, must not carry `@intCast`,
# `@as(usize` or `extern fn`, must not be a `//` comment, and the `usize` must stand as a whole word,
# which is what `grep -w` means and what the character class below reproduces.
#
# Measured `20260907.053708` over the real corpus, twice each way: 36.4s and 40.1s before, 8.4s and
# 8.7s after -- a 78% cut. Proven equal rather than assumed: both forms were run over all 1,940
# discovered files and compared count for count, with ZERO disagreements, before the swap was made.
count_authored() {
  awk '
    /usize/ {
      if ($0 ~ /@intCast/) next
      if ($0 ~ /@as\(usize/) next
      if ($0 ~ /^[[:space:]]*\/\//) next
      if ($0 ~ /extern fn/) next
      if ($0 !~ /(^|[^A-Za-z0-9_])usize([^A-Za-z0-9_]|$)/) next
      n++
      i = index($0, "//")
      if (i > 0 && substr($0, i + 2) ~ /seam/) s++
    }
    END { print (n+0) " " (s+0) }
  ' "$1" 2>/dev/null
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
  # The GATE reads STRICTLY -- the whole authored count, stated seam and all. See the header.
  r=$(count_authored "$p"); n=${r% *}
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
corpus_seam_stated_lines=0
corpus_seam_cleared_files=0
: > "$work/corpus_flagged.txt"
while read -r p; do
  [ -f "$p" ] || continue
  r=$(count_authored "$p"); strict=${r% *}; stated=${r#* }
  [ "$strict" = "0" ] && continue
  # The RATCHET welcomes a stated seam: the line explains itself, and this is the population
  # nobody had explained. The gate above reads the same file strictly. See the header.
  corpus_seam_stated_lines=$((corpus_seam_stated_lines + stated))
  n=$((strict - stated))
  if [ "$n" -eq 0 ]; then corpus_seam_cleared_files=$((corpus_seam_cleared_files + 1)); continue; fi
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
echo "corpus_seam_stated_lines=$corpus_seam_stated_lines"
echo "corpus_seam_cleared_files=$corpus_seam_cleared_files"

[ "$roster_flagged" -eq 0 ] || sed 's/^/roster_flag: /' "$work/roster_flagged.txt"
[ "$exempt_declared" = "no" ] || [ "$exempt_read" -eq "$exempt_pinned" ] \
  || echo "exempt_moved: $exempt_path reads $exempt_read against a pin of $exempt_pinned"
if [ "$corpus_flagged_files" -gt "$corpus_files_ceiling" ]; then
  sort -rn "$work/corpus_flagged.txt" | head -10 | sed 's/^/corpus_top: /'
  corpus_top_shown=10
  [ "$corpus_flagged_files" -lt 10 ] && corpus_top_shown="$corpus_flagged_files"
  echo "corpus_top_shown=$corpus_top_shown"
  echo "corpus_top_hidden=$((corpus_flagged_files - corpus_top_shown))"
fi

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
