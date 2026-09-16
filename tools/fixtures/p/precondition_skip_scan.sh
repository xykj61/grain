#!/bin/sh
# precondition_skip_scan.sh -- count the witnesses that REFUSE on an optional precondition
# rather than skipping honestly.
#
#   sh tools/fixtures/p/precondition_skip_scan.sh [--list]
#
# WHY THIS READING EXISTS (REDS %646, seated 20260908.202239, swept 20260916).
# A witness that hard-asserts on something a CORRECT clone may lack can never be rostered: a
# roster row would red every machine without it. An unrostered witness runs nowhere, so the
# assert buys a red nobody will ever hear -- which is strictly worse than no check at all,
# because the tree believes it is covered.
#
# TWO PRECONDITION KINDS ARE READ HERE, both proven live on this pier:
#   artifact -- `test -x <path>` where <path> is gitignored, so it is a build output a fresh
#               clone lacks by construction (asked of git itself, never guessed from a name).
#   display  -- a reading of WAYLAND_DISPLAY, absent on every headless pier in this fleet.
#
# WHAT IT CANNOT SEE, said plainly rather than left to be discovered:
#   A precondition reached through a nested witness, a shell function, or a path built at
#   runtime. Resolution here is one pass over one file: a `let <name> = "<literal>"` binding
#   and a `let <v> = run [...]` reading, matched by variable name. Anything indirect is
#   undercounted on purpose, the way the four ASCII siblings undercount theirs.
#   A submodule precondition -- `gratitude/tigerbeetle` and its kin -- is a THIRD kind, already
#   swept: 40 of 43 dependents skip honestly and the remainder is a retired witness. It is left
#   out of this reading rather than counted at zero, so the number here stays one subject.
set -eu

LIST=no
[ "${1:-}" = "--list" ] && LIST=yes

# The ceiling only falls, and it stands at what was measured the lap it was seated
# (20260916): seven hard sites across five files, none of them inside this sweep's claim.
# Two refuse on WAYLAND_DISPLAY -- tools/p/pond_enclosure_sixbar.rish and
# tools/s/slc2a_ring3_metal.rish. Three refuse on a pinned toolchain or a built module clock,
# and one file refuses on two paths at once. Each wants a lane that owns it; lower this
# number in the same commit that sweeps one.
CEILING=7

root=$(git rev-parse --show-toplevel)
cd "$root"

files=$(git ls-files '*.rish')

# Ask git which paths are ignored, once, rather than once per candidate.
tmp=".lap/precondition-scan.$$"
mkdir -p .lap
: > "$tmp"

hard=0
skip=0
sites=0

for f in $files; do
  out=$(awk '
    # A string binding a path: let seed_bin = "brushstroke/bin/brushstroke-wayland-seed"
    /^let [a-z_]+ = "[^"]*"$/ {
      name = $2
      v = $0; sub(/^[^"]*"/, "", v); sub(/"$/, "", v)
      path[name] = v
      next
    }
    # An artifact reading: let have = run ["test" "-x" seed_bin]
    /^let [a-z_]+ = run \["test" "-x" / {
      v = $2
      arg = $NF; sub(/\]$/, "", arg); gsub(/"/, "", arg)
      p = (arg in path) ? path[arg] : arg
      kind[v] = "artifact"; target[v] = p
      next
    }
    # A display reading: any run line naming WAYLAND_DISPLAY
    /^let [a-z_]+ = run \[.*WAYLAND_DISPLAY/ {
      kind[$2] = "display"; target[$2] = "WAYLAND_DISPLAY"
      next
    }
    # A refusal on one of them.
    /^assert [a-z_]+\.ok else / {
      v = $2; sub(/\.ok$/, "", v)
      if (v in kind) print kind[v] "\thard\t" target[v]
      next
    }
    # An honest skip on one of them: the exit 0 line is what makes it a skip.
    /^if \([a-z_]+\.ok == false\) then exit 0$/ {
      v = $0; sub(/^if \(/, "", v); sub(/\.ok.*$/, "", v)
      if (v in kind) print kind[v] "\tskip\t" target[v]
      next
    }
  ' "$f")
  [ -z "$out" ] && continue
  printf '%s\n' "$out" | while IFS='	' read -r k verdict tgt; do
    printf '%s\t%s\t%s\t%s\n' "$f" "$k" "$verdict" "$tgt"
  done >> "$tmp"
done

# An artifact site only counts when the target is a RESOLVED literal path that git itself
# calls ignored. Both halves are load-bearing, and the second alone is a false-positive
# machine: this tree's `.gitignore` denies the root with `/*` and allows project paths back
# one at a time, so `git check-ignore` answers YES to every bare word it has never heard of.
# An unresolved variable name -- `rishi_bin`, `f_gpg` -- would therefore read as a gitignored
# build output. So a target carrying no slash, or still carrying `${`, is dropped unread and
# counted as UNRESOLVED rather than guessed at.
: > "$tmp.unres"
: > "$tmp.keep"
while IFS='	' read -r f k verdict tgt; do
  if [ "$k" = artifact ]; then
    case "$tgt" in
      *'${'*) echo x >> "$tmp.unres"; continue ;;
      */*) : ;;
      *) echo x >> "$tmp.unres"; continue ;;
    esac
    git check-ignore -q "$tgt" 2>/dev/null || continue
  fi
  printf '%s\t%s\t%s\t%s\n' "$f" "$k" "$verdict" "$tgt" >> "$tmp.keep"
done < "$tmp"

unresolved=$(wc -l < "$tmp.unres" | tr -d ' ')
sites=$(wc -l < "$tmp.keep" | tr -d ' ')
hard=$(awk -F'\t' '$3=="hard"' "$tmp.keep" | wc -l | tr -d ' ')
skip=$(awk -F'\t' '$3=="skip"' "$tmp.keep" | wc -l | tr -d ' ')

if [ "$LIST" = yes ]; then
  awk -F'\t' '$3=="hard" {print "hard  " $1 "  " $2 "  " $4}' "$tmp.keep"
  awk -F'\t' '$3=="skip" {print "skip  " $1 "  " $2 "  " $4}' "$tmp.keep"
fi

rm -f "$tmp" "$tmp.keep" "$tmp.unres"

echo "precondition sites=$sites skip=$skip hard=$hard unresolved=$unresolved"
echo "precondition ceiling=$CEILING"
if [ "$hard" -le "$CEILING" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "detail: a witness refusing on an optional precondition can never be rostered, so its red is one nobody hears"
echo "verdict=over"
exit 1
