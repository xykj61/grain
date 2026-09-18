#!/bin/sh
# tools/fixtures/r/rye_compiled_reach_scan.sh -- a module no compiler reads is a module the
# language never checked.
#
# WHAT THIS IS FOR. This tree authors 1,940 tracked `.rye` paths (measured `20260906.010429`; the
# scan counts them fresh every run and never trusts this line). A `.rye` file is checked by the
# Zig compiler only when some tool builds it, or when a file that IS built reaches it through
# `@import`. Everything outside that closure is never handed to a compiler at all: it still reads
# like code, still passes review, still sits under a witness that greps it for a field name -- and
# the language has never once had an opinion about it. This reading names that population.
#
# WHAT IT COSTS WHEN IT IS MISSED. REDS %449, `20260906`: `mantra/src/weave.rye` had not compiled
# since the pinned toolchain moved to Zig 0.16, because `Weave.empty()` still returned the elder
# `.{ .lines = .{} }` where 0.16 wants `.empty`. FOUR guards stood over that file at `tier lap` --
# `mantra_gen_floor_a1_gate` and `mantra_glow_tend_limb1` through `limb3` -- and every one read it
# with `grep -q`, so all four were GREEN over a file the compiler refuses. The test beside it
# inlined its own copy of the module, so the test migrated with the toolchain while the subject
# rotted. Plainly: grep proves a file's shape; only a compiler proves a file. That row repaired the
# one instance by hand and booked this census, because a repair that fixes a class by hand leaves
# whichever member the hand did not reach.
#
#   sh tools/fixtures/r/rye_compiled_reach_scan.sh           # measure and gate
#   sh tools/fixtures/r/rye_compiled_reach_scan.sh list      # print every uncompiled body
#   sh tools/fixtures/r/rye_compiled_reach_scan.sh plants    # print the fixture plants held out
#   sh tools/fixtures/r/rye_compiled_reach_scan.sh roots     # print every root the reading found
#
# WHAT COMPILED MEANS, exactly. A body is compiled when it is a ROOT or when some already-reached
# body imports it. A root is found two ways:
#
#   LITERAL   -- a tracked non-`.rye` file that itself carries a Rye build verb (`rye build`,
#                `rye run`, `zig build-exe`, ...) names the path. The build verb is what makes the
#                file a builder; the path may then appear anywhere in it, since a builder commonly
#                binds it to a variable a line earlier.
#   COMPOSED  -- a builder whose path argument is assembled from a variable, as
#                `tools/p/parity_ch01.rish` writes `"${dir}/${s}.rye"` over a list of 112 names.
#                No literal path exists to read, so every directory that builder names as a plain
#                string is credited whole. Four such directories stand today: `amphora`,
#                `dimeroll`, `kumara`, and `rye/tests`, crediting 132 files between them.
#
# WHY A BODY RATHER THAN A PATH. 227 of the 1,940 tracked `.rye` paths are symlinks, and a symlink
# is not a copy -- the compiler reads the target's bytes. `tally/parse_int.rye` has ELEVEN symlinks
# pointing at it from Linengrow directories that ARE built, so counting paths reports it as never
# compiled while its bytes go through the compiler eleven times a lap. Every path is resolved to
# its target before the arithmetic, which is the difference between 1,940 paths and 1,713 bodies.
#
# WHY THE READING IS DELIBERATELY GENEROUS. Every rule above credits MORE than it can prove: a
# path merely mentioned inside a builder counts, and a composed directory credits members no loop
# may actually name. So `uncompiled` is a FLOOR under the real number -- this reading can miss a
# dead file and can never invent one. That direction is the only safe one here, because the
# refusal's answer is "build it or delete it," and a guard that wrongly calls live code dead earns
# exactly one deletion before nobody trusts it again.
#
# HOW MUCH THE GENEROSITY COSTS, measured rather than assumed (`20260906.010429`). Of the 1,484
# literal roots, 33 are named inside their builders only on lines carrying a `grep`, `sed`, `awk`,
# or `rg` -- never on a line holding a build verb. A stricter rule would move those 33 into the
# uncompiled set, and it would be WRONG about them: `glow/glow_run.rye` is one, and
# `tools/g/glow_run_worker.sh` builds it on every Glow run through its own local wrapper,
# `build_atomic glow/glow_run.rye glow/bin/glow_run` -- a line no verb pattern can recognize,
# because the verb is the tool's own function name. A tool free to wrap the compiler is a tool
# whose build line cannot be pattern-matched, which is the whole argument for reading the file
# rather than the line.
#
# WHAT IT DOES NOT REACH, named rather than implied.
#   - WHETHER A BODY COMPILES. This reads who hands a file to the compiler, never what the
#     compiler answers. Measured `20260906.010429`: `tools/rye/mantra_a1_weave_fields_eq_witness.rye`
#     stands in the uncompiled set AND builds and links clean on this toolchain. So the set is a
#     population where %449 can happen unseen, rather than a list of files already rotted.
#   - A ROOT NAMED ONLY IN A COMMENT. The four `mantra_a1_*` witnesses each carry their own run
#     line in their own `//!` header, and nothing else in the tree runs them. A file's comment is
#     not a caller, so they read uncompiled, which is the true answer.
#   - FIXTURE PLANTS. A `.rye` under a `fixtures/` directory is pen material a scan reads with
#     grep on purpose -- `tools/fixtures/t/tame_style_ban_violation.rye` exists to be REFUSED by a
#     style checker rather than built. Those are counted, printed under `plants`, and held out of
#     the gate.
#   - WHETHER A COMPILED BODY IS ALSO RUN. `unheard_guard_scan.sh` reads that question, one room
#     over, for the guards themselves.
#
# WHY A ZERO REFUSES RATHER THAN REPORTS. Each of the three passes below produces output, and a
# pipeline ending in `sort` exits zero over empty input however badly its first stage failed
# (REDS %447). An empty corpus, an empty builder set, and an empty root set each refuse by name,
# so a broken `git ls-files` and a genuinely clean tree can never print the same number.
set -eu

# THE CEILING ONLY FALLS. 18 measured `20260906.010429` over 1,713 bodies -- 1% of the corpus, and
# every one of them named below the readings so a reader sees the population rather than a count.
# No slack: slack in a ratchet is a number nobody chose. A new `.rye` that no tool builds raises
# this and is refused, and the refusal names both lawful answers -- give it a builder, or file it
# under a `fixtures/` pen where a grep-reading scan is the point.
CEILING="${RYE_UNCOMPILED_CEILING:-18}"
mode="${1:-measure}"

# TWO ROOTS, on purpose. The tree being MEASURED is the one the caller stands in, so a control can
# `cd` into a pen and read the pen. The tree this script's own helper lives in is found by walking
# up from `$0` -- git-free, so a pen needs no copy of it (the depth-proof block seated `20260828`).
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
# One shell dialect for the guards, on both piers (REDS %240, %250).
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this reading walks tracked living sources" >&2
  exit 1
}
cd "$root"

# BOUNDS, named at construction. The import closure is a fixpoint over a finite tracked set, so it
# settles on its own; max_hops exists so a pathological import cycle cannot spin, and it sits far
# above the depth this tree converges in. max_edges bounds the edge table so a generated file
# cannot make this reading's memory grow with its input.
max_hops=64
max_edges=65536

work=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$work"' EXIT

# THE CORPUS: every tracked `.rye` path.
git ls-files '*.rye' 2>/dev/null | LC_ALL=C sort -u > "$work/paths.txt"
paths=$(grep -c . "$work/paths.txt" || true)
if [ "$paths" -eq 0 ]; then
  echo "verdict=no_rye_found"
  echo "refused: no tracked .rye path reached the reading -- a zero nobody planted is not an empty tree." >&2
  exit 1
fi

# PATH -> BODY. Only the symlinks need resolving, and there are 227 of them against 1,940 paths,
# so the loop reads `git ls-files -s` for mode 120000 rather than stat-ing the whole corpus.
: > "$work/canon.tsv"
git ls-files -s '*.rye' 2>/dev/null | awk '$1=="120000"{ $1="";$2="";$3=""; sub(/^[ \t]+/,""); print }' > "$work/links.txt"
while IFS= read -r link; do
  [ -n "$link" ] || continue
  target=$(resolve_path "$link" 2>/dev/null) || continue
  case "$target" in
    "$root"/*) printf '%s\t%s\n' "$link" "${target#"$root"/}" >> "$work/canon.tsv" ;;
  esac
done < "$work/links.txt"
symlinks=$(grep -c . "$work/canon.tsv" || true)

awk -F'\t' 'FILENAME==ARGV[1]{c[$1]=$2;next}{print ($0 in c)?c[$0]:$0}' \
  "$work/canon.tsv" "$work/paths.txt" | LC_ALL=C sort -u > "$work/bodies.txt"
bodies=$(grep -c . "$work/bodies.txt" || true)

# THE BUILDERS: tracked non-`.rye` files carrying a Rye build verb. A file that never builds
# anything is not a caller however often it names a path -- which is the whole of %449, where four
# guards named `weave.rye` between two and four times each and not one of them held a build verb.
git ls-files 2>/dev/null | grep -v '\.rye$' > "$work/nonrye.txt"
xargs_lines_batched 400 "$work/nonrye.txt" grep -lE '(rye|zig)[[:space:]"]+(build-exe|build|run|test)' \
  2>/dev/null | LC_ALL=C sort -u > "$work/builders.txt" || true
builders=$(grep -c . "$work/builders.txt" || true)
if [ "$builders" -eq 0 ]; then
  echo "verdict=no_builders_found"
  echo "refused: no tracked file named a Rye build verb -- every body would read uncompiled for the wrong reason." >&2
  exit 1
fi

# LITERAL ROOTS: a `.rye` path spelled inside a builder.
xargs_lines_batched 400 "$work/builders.txt" grep -hoE '[A-Za-z0-9_./-]+\.rye' 2>/dev/null \
  | LC_ALL=C sort -u > "$work/literals.txt" || true
grep -Fxf "$work/paths.txt" "$work/literals.txt" 2>/dev/null | LC_ALL=C sort -u > "$work/roots_literal.txt" || true
roots_literal=$(grep -c . "$work/roots_literal.txt" || true)

# COMPOSED ROOTS: a builder whose `.rye` argument carries a variable reference has no literal path
# to read, so every directory it names as a plain string is credited whole.
xargs_lines_batched 400 "$work/builders.txt" \
  grep -lE '\$(\{[^}]*\}|[A-Za-z_][A-Za-z0-9_]*)[A-Za-z0-9_./${}-]*\.rye' 2>/dev/null \
  | LC_ALL=C sort -u > "$work/composers.txt" || true
composers=$(grep -c . "$work/composers.txt" || true)
sed -E 's#/[^/]*$##' "$work/paths.txt" | LC_ALL=C sort -u > "$work/ryedirs.txt"
: > "$work/composed_dirs.txt"
if [ "$composers" -gt 0 ]; then
  xargs_lines_batched 400 "$work/composers.txt" grep -hoE '"[A-Za-z0-9_./-]+"' 2>/dev/null \
    | tr -d '"' | LC_ALL=C sort -u > "$work/composer_strings.txt" || true
  grep -Fxf "$work/ryedirs.txt" "$work/composer_strings.txt" 2>/dev/null \
    | LC_ALL=C sort -u > "$work/composed_dirs.txt" || true
fi
composed_dirs=$(grep -c . "$work/composed_dirs.txt" || true)
: > "$work/roots_composed.txt"
while IFS= read -r d; do
  [ -n "$d" ] || continue
  grep -E "^$(printf '%s' "$d" | sed 's/[.[\*^$]/\\&/g')/[^/]*\.rye$" "$work/paths.txt" >> "$work/roots_composed.txt" || true
done < "$work/composed_dirs.txt"

cat "$work/roots_literal.txt" "$work/roots_composed.txt" | LC_ALL=C sort -u > "$work/roots.txt"
roots=$(grep -c . "$work/roots.txt" || true)
if [ "$roots" -eq 0 ]; then
  echo "verdict=no_roots_found"
  echo "refused: no builder named a tracked .rye path -- the closure would start from nothing." >&2
  exit 1
fi

# THE EDGES: one grep over the whole corpus, resolved to bodies on both ends. `@import("x.rye")`
# from `d/f.rye` names `d/x.rye`, which is the directory relationship Zig itself enforces.
xargs_lines_batched 400 "$work/paths.txt" grep -HoE '@import\("[^"]+\.rye"\)' 2>/dev/null \
  | sed -E 's/@import\("//; s/"\)$//' | head -n "$max_edges" > "$work/edges_raw.txt" || true
awk -F'\t' -v OFS='\t' '
  FILENAME == ARGV[1] { canon[$1] = $2; next }
  {
    i = index($0, ":"); if (i == 0) next
    src = substr($0, 1, i - 1); imp = substr($0, i + 1)
    d = src; sub(/\/[^\/]*$/, "", d); if (d == src) d = "."
    p = (substr(imp, 1, 1) == "/") ? imp : d "/" imp
    gsub(/\/\.\//, "/", p)
    while (match(p, /[^\/]+\/\.\.\//)) sub(/[^\/]+\/\.\.\//, "", p)
    print (src in canon ? canon[src] : src), (p in canon ? canon[p] : p)
  }' "$work/canon.tsv" "$work/edges_raw.txt" | LC_ALL=C sort -u > "$work/edges.tsv"
edges=$(grep -c . "$work/edges.tsv" || true)

# THE CLOSURE, breadth-first from the roots, hop-counted so a cycle cannot spin.
awk -F'\t' -v maxhops="$max_hops" '
  FILENAME == ARGV[1] { canon[$1] = $2; next }
  { print (($0 in canon) ? canon[$0] : $0) }' "$work/canon.tsv" "$work/roots.txt" \
  | LC_ALL=C sort -u > "$work/roots_body.txt"
awk -F'\t' -v maxhops="$max_hops" '
  FILENAME == ARGV[1] { adj[$1] = adj[$1] " " $2; next }
  { if (!($0 in seen)) { seen[$0] = 1; q[++n] = $0; depth[$0] = 0 } }
  END {
    hops = 0
    for (i = 1; i <= n; i++) {
      c = q[i]
      if (depth[c] > hops) hops = depth[c]
      if (depth[c] >= maxhops) { print "HOPS\t" maxhops > "/dev/stderr"; exit 3 }
      m = split(adj[c], t, " ")
      for (j = 1; j <= m; j++) {
        if (t[j] != "" && !(t[j] in seen)) {
          seen[t[j]] = 1; q[++n] = t[j]; depth[t[j]] = depth[c] + 1
        }
      }
    }
    for (k in seen) print k
    print "HOPS\t" hops > "/dev/stderr"
  }' "$work/edges.tsv" "$work/roots_body.txt" 2> "$work/hops.txt" | LC_ALL=C sort -u > "$work/reach.txt"
hops=$(awk -F'\t' '/^HOPS/{print $2}' "$work/hops.txt" | tail -1)
[ -n "${hops:-}" ] || hops=0

reached=$(grep -Fxf "$work/bodies.txt" "$work/reach.txt" 2>/dev/null | grep -c . || true)
grep -Fxvf "$work/reach.txt" "$work/bodies.txt" 2>/dev/null | LC_ALL=C sort > "$work/unreached.txt" || true

# PLANTS held out of the gate, LIVE bodies gated.
grep -E '(^|/)fixtures/' "$work/unreached.txt" > "$work/plants.txt" || true
grep -Ev '(^|/)fixtures/' "$work/unreached.txt" > "$work/uncompiled.txt" || true
plants=$(grep -c . "$work/plants.txt" || true)
uncompiled=$(grep -c . "$work/uncompiled.txt" || true)

echo "paths=$paths"
echo "symlinks=$symlinks"
echo "bodies=$bodies"
echo "builders=$builders"
echo "roots_literal=$roots_literal"
echo "composers=$composers"
echo "composed_dirs=$composed_dirs"
echo "roots=$roots"
echo "edges=$edges"
echo "hops=$hops"
echo "reached=$reached"
echo "plants=$plants"
echo "uncompiled=$uncompiled"
echo "ceiling=$CEILING"

if [ "$mode" = list ] || [ "$uncompiled" -gt "$CEILING" ]; then
  while IFS= read -r b; do
    [ -n "$b" ] || continue
    echo "uncompiled $b"
  done < "$work/uncompiled.txt"
fi

if [ "$mode" = plants ]; then
  while IFS= read -r b; do
    [ -n "$b" ] || continue
    echo "plant $b"
  done < "$work/plants.txt"
fi

if [ "$mode" = roots ]; then
  while IFS= read -r b; do
    [ -n "$b" ] || continue
    echo "root $b"
  done < "$work/roots.txt"
fi

if [ "$edges" -eq 0 ]; then
  echo "verdict=no_imports_found"
  echo "refused: not one @import reached the reading -- the closure would stop at its roots." >&2
  exit 1
fi

if [ "$hops" -ge "$max_hops" ]; then
  echo "verdict=no_fixpoint"
  echo "refused: the closure did not settle within max_hops=$max_hops -- the reading is incomplete." >&2
  exit 1
fi

if [ "$uncompiled" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  echo "refused: $uncompiled bodies stand outside every compiler's reach against a ceiling of $CEILING. Name the new file in a tool that builds it, or file it under a fixtures/ pen where a grep-reading scan is the point." >&2
  exit 1
fi

echo "verdict=ok"
