#!/bin/sh
# tools/fixtures/r/rye_compile_reach_scan.sh -- which authored Rye does anything ever compile?
#
#   sh tools/fixtures/r/rye_compile_reach_scan.sh [--list never|asserted|specimen|dangling|roots]
#
# WHY THIS EXISTS. `mantra/src/weave.rye` had not compiled since the toolchain moved: `Weave.empty()`
# still returned the elder `.{}` ArrayList form where Zig 0.16 wants `.empty`, and building the HEAD
# blob in a pen answers *missing struct field: items*. Four guards stood at `tier lap` reading that
# module every lap and all four stayed green, because all four read it with `grep`. Its own test
# inlines a copy of it, and the copy reads `.empty` -- because the test is compiled and the module is
# not. A test that inlines its subject migrates with the toolchain while the subject rots, and every
# guard stays green (REDS %453, which booked this census).
#
# WHAT IT MEASURES. Every tracked `.rye` file, and whether anything in this tree ever hands it to the
# Rye compiler -- directly as a build root, or transitively through an `@import`. Four readings come
# out of that, and they are deliberately different weights:
#
#   never      a file no build reaches. Some of these are honest: a test a hand runs, a probe kept
#              for a day that has not come. Reported.
#   specimen   of those, the ones under a `fixtures/` path -- a planted violation a style guard reads
#              is SUPPOSED not to compile clean, so accusing it would be accusing the plant of being
#              planted. Named as its own class rather than counted against the tree.
#   asserted   of the rest, the ones a runner nonetheless makes a claim about while never compiling
#              them. This is %453's exact shape, and it is the reading held under a ceiling.
#   dangling   an `@import` naming a path this tree neither tracks nor holds.
#
# WHY A RUNNER IS CREDITED GENEROUSLY. A build root reaches the compiler by three routes here: a
# literal (`rye/bin/rye build encoding/pem.rye`), a variable (`let prog_src = "..."` then
# `rye "run" prog_src`), and a function parameter (`fn build_guest src elf:` called with a literal one
# line later). Deciding which literal in a file is the one being built means chasing all three across
# 1,500 runners, and a mis-tuned chase produces a CONFIDENT false claim -- exactly the failure %460
# just closed one lane over. So the rule is per-file and conservative: a runner that invokes the Rye
# compiler AT ALL credits every `.rye` path it names. That over-credits on purpose. Every count below
# is therefore a FLOOR: what it names is genuinely uncompiled, and there is more it cannot see.
#
# WHY SYMLINKS ARE RESOLVED FIRST. 227 of the corpus are symlinks -- a second name for one file, not a
# second file. Measured before resolution, 17 of them read as never-compiled and 16 of those point at
# a file that IS compiled: sixteen false accusations of healthy code from one missing step. Resolution
# reads `git ls-files -s` for mode 120000 and `git cat-file` for the link text, so it asks the
# repository rather than the filesystem and needs no `readlink`, which is not POSIX.
#
# Exit 0 when the asserted set is at or under its ceiling; 1 when it is over; 2 on misuse.
set -eu

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
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

# The ceiling only ever falls. Measured 20260906: exactly one distinct Rye file carries a runner's
# claim while no build ever reaches it -- `mantra/src/diff.rye`, five guards reading it and nothing
# compiling it. Whether it still COMPILES is a different question this census does not answer, and
# the cheap answer is a trap: Zig analyses lazily, so a build that merely imports a module passes
# over a planted type error in it (measured `20260906`, and independently by a peer against
# `%449`'s own broken bytes). Reaching that answer wants a comptime declaration walker, which is a
# peer's landing lap. This census answers only WHICH files no build ever reaches -- a graph
# question, which lazy analysis does not touch.
ceiling=1

# Bounds, each named because a census over a growing tree needs one. The corpus stood at 1,940 and
# the runners at 3,072 on 20260906; both ceilings are the next power of two above, so ordinary growth
# passes and a tenfold jump is a refusal rather than a silent truncation.
max_corpus=4096
max_runners=8192
max_link_hops=8

list=
while [ $# -gt 0 ]; do
  case "$1" in
    --list) [ $# -ge 2 ] || { echo "detail: --list wants a set name"; echo "verdict=no_set"; exit 2; }
            list=$2; shift 2 ;;
    *) echo "detail: unknown argument $1"; echo "verdict=bad_argument"; exit 2 ;;
  esac
done
case "$list" in
  ''|never|asserted|specimen|dangling|roots) ;;
  *) echo "detail: --list takes never, asserted, specimen, dangling, or roots"; echo "verdict=bad_set"; exit 2 ;;
esac

cd "$_fd_root"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# ---- the corpus, and the link text the repository holds -------------------------------------
git ls-files -s -- '*.rye' > "$work/staged.txt" 2>/dev/null || {
  echo "detail: git ls-files refused -- this is not a checkout"; echo "verdict=no_checkout"; exit 2; }

awk '{ sub(/^[^\t]*\t/, ""); print }' "$work/staged.txt" | sort -u > "$work/corpus.txt"
corpus=$(wc -l < "$work/corpus.txt" | tr -d ' ')
[ "$corpus" -gt 0 ] || { echo "detail: no tracked .rye files"; echo "verdict=empty_corpus"; exit 2; }
[ "$corpus" -le "$max_corpus" ] || {
  echo "detail: corpus $corpus over max_corpus $max_corpus -- raise the bound deliberately"
  echo "verdict=corpus_over_bound"; exit 2; }

# mode 120000 is a symlink; its blob IS the link text. One cat-file --batch reads them all.
awk '$1=="120000" { path=$0; sub(/^[^\t]*\t/, "", path); print $2 "\t" path }' "$work/staged.txt" > "$work/links.txt"
symlinks=$(wc -l < "$work/links.txt" | tr -d ' ')
: > "$work/linkmap.txt"
if [ "$symlinks" -gt 0 ]; then
  cut -f1 "$work/links.txt" | git cat-file --batch --buffer > "$work/linktext.txt" 2>/dev/null || {
    echo "detail: git cat-file refused the link blobs"; echo "verdict=no_link_text"; exit 2; }
  # `--batch` prints "<sha> blob <n>" then the bytes then a blank line. Pair each target with its
  # path in file order, which is the order cut fed the shas.
  awk '
    /^[0-9a-f]+ blob [0-9]+$/ { want=1; next }
    want == 1 { print; want=0 }
  ' "$work/linktext.txt" > "$work/targets.txt"
  paste "$work/links.txt" "$work/targets.txt" | awk -F'\t' '{ print $2 "\t" $3 }' > "$work/linkmap.txt"
fi

# ---- resolve a path through its link chain ---------------------------------------------------
# Pure path arithmetic over the link map: dirname(path) joined to the link text, then `.` and `..`
# collapsed. Bounded at max_link_hops so a cycle refuses rather than spins.
awk -F'\t' -v hops="$max_link_hops" -v linkfile="$work/linkmap.txt" '
  function norm(p,   n, i, out, seg) {
    n = split(p, seg, "/"); out = ""
    for (i = 1; i <= n; i++) {
      if (seg[i] == "" || seg[i] == ".") continue
      if (seg[i] == "..") { sub(/\/?[^\/]*$/, "", out); continue }
      out = (out == "") ? seg[i] : out "/" seg[i]
    }
    return out
  }
  FILENAME == linkfile { link[$1] = $2; next }
  {
    p = $0; h = 0
    while ((p in link) && h < hops) {
      d = p; if (!sub(/\/[^\/]*$/, "", d)) d = ""
      p = norm((d == "") ? link[p] : d "/" link[p])
      h++
    }
    print $0 "\t" p
  }
' "$work/linkmap.txt" "$work/corpus.txt" > "$work/resolved.txt"

cut -f2 "$work/resolved.txt" | sort -u > "$work/distinct.txt"
distinct=$(wc -l < "$work/distinct.txt" | tr -d ' ')

# ---- the runners, split by whether they ever drive the Rye compiler ---------------------------
# THE CENSUS MUST NOT READ ITSELF. This scan's own source carries the compiler-detector patterns
# as literal strings AND names example Rye paths in its comments, so the moment it became tracked it
# classified itself as a compiling runner and credited every path it mentions -- silently clearing
# the one accusation it had been built to hold. Measured `20260906`: `asserted` fell 1 -> 0 on the
# commit that added this file, with nothing in the tree changed about the accused module. The gate
# disarmed itself by being committed, which is the sharpest form of the fault this whole census is
# about: an instrument reading its own reflection and reporting the room is empty. Its control is
# excluded for the same reason and by the same rule -- these two files, by name, and nothing else.
git ls-files -- '*.rish' '*.sh' \
  | grep -v -e '^tools/fixtures/r/rye_compile_reach_scan\.sh$' \
            -e '^tools/fixtures/r/rye_compile_reach_control\.sh$' \
  | sort -u > "$work/runners.txt"
runners=$(wc -l < "$work/runners.txt" | tr -d ' ')
[ "$runners" -le "$max_runners" ] || {
  echo "detail: runners $runners over max_runners $max_runners -- raise the bound deliberately"
  echo "verdict=runners_over_bound"; exit 2; }

# Four spellings reach the compiler, and the fourth is why this is a pattern rather than a word:
# `rye build X` and `rye run X` adjacent; Rishi's list form, where "run" is its own quoted element
# and the path arrives as a variable; and RYE_ZIG= / RYE_LIB=, which are set for nothing else.
compiles='(^|[^A-Za-z0-9_/-])(rye/bin/rye|\./bin/rye|bin/rye|rye)[[:space:]]+(build|run)([[:space:]]|$)|RYE_ZIG=|RYE_LIB=|"(build|run)"[[:space:]]+[A-Za-z_]'
xargs_lines "$work/runners.txt" grep -lE "$compiles" > "$work/compiling.txt" 2>/dev/null || true
sort -u "$work/compiling.txt" -o "$work/compiling.txt"
comm -23 "$work/runners.txt" "$work/compiling.txt" > "$work/reading.txt"
compiling_runners=$(wc -l < "$work/compiling.txt" | tr -d ' ')
reading_runners=$(wc -l < "$work/reading.txt" | tr -d ' ')

rye_literal='[A-Za-z0-9_][A-Za-z0-9_./-]*\.rye'
xargs_lines "$work/compiling.txt" grep -hoE "$rye_literal" 2>/dev/null | sort -u > "$work/named_compiling.txt" || true
xargs_lines "$work/reading.txt"   grep -hoE "$rye_literal" 2>/dev/null | sort -u > "$work/named_reading.txt" || true

# A named literal is credited against the file it really is, so a runner naming the symlink credits
# the target -- the same resolution the corpus took.
resolve_names() { # namefile -> real paths on stdout
  awk -F'\t' -v realfile="$work/resolved.txt" '
    FILENAME == realfile { real[$1] = $2; next }
    { print ($0 in real) ? real[$0] : $0 }
  ' "$work/resolved.txt" "$1" | sort -u
}
resolve_names "$work/named_compiling.txt" > "$work/named_compiling_real.txt"
resolve_names "$work/named_reading.txt"   > "$work/named_reading_real.txt"

comm -12 "$work/distinct.txt" "$work/named_compiling_real.txt" > "$work/roots.txt"
roots=$(wc -l < "$work/roots.txt" | tr -d ' ')

# ---- the import graph -------------------------------------------------------------------------
# Zig resolves a bare `@import` against the importing file's own directory, so an edge is pure path
# arithmetic. Targets are resolved through the link map too, so an import of a symlink is an edge to
# the file behind it.
xargs_lines "$work/distinct.txt" awk '
  function norm(p,   n, i, out, seg) {
    n = split(p, seg, "/"); out = ""
    for (i = 1; i <= n; i++) {
      if (seg[i] == "" || seg[i] == ".") continue
      if (seg[i] == "..") { sub(/\/?[^\/]*$/, "", out); continue }
      out = (out == "") ? seg[i] : out "/" seg[i]
    }
    return out
  }
  FNR == 1 { dir = FILENAME; if (!sub(/\/[^\/]*$/, "", dir)) dir = "" }
  {
    line = $0
    while (match(line, /@import\("[^"]*\.rye"\)/)) {
      s = substr(line, RSTART, RLENGTH)
      line = substr(line, RSTART + RLENGTH)
      sub(/^@import\("/, "", s); sub(/"\)$/, "", s)
      print FILENAME "\t" norm((dir == "") ? s : dir "/" s)
    }
  }
' > "$work/edges_raw.txt" 2>/dev/null || true

awk -F'\t' -v realfile="$work/resolved.txt" '
  FILENAME == realfile { real[$1] = $2; next }
  { t = $2; if (t in real) t = real[t]; print $1 "\t" t }
' "$work/resolved.txt" "$work/edges_raw.txt" | sort -u > "$work/edges.txt"
edges=$(wc -l < "$work/edges.txt" | tr -d ' ')

# An import naming a path this tree neither tracks nor holds on disk. Reported rather than gated: an
# untracked-but-present file is somebody's working copy, and only the absent one is a broken promise.
awk -F'\t' -v havefile="$work/distinct.txt" '
  FILENAME == havefile { have[$0] = 1; next }
  !($2 in have) { print $2 }
' "$work/distinct.txt" "$work/edges.txt" | sort -u > "$work/unknown_targets.txt"
: > "$work/dangling.txt"
while IFS= read -r t; do
  [ -e "$t" ] || echo "$t" >> "$work/dangling.txt"
done < "$work/unknown_targets.txt"
dangling=$(wc -l < "$work/dangling.txt" | tr -d ' ')
untracked_targets=$(( $(wc -l < "$work/unknown_targets.txt" | tr -d ' ') - dangling ))

# ---- reach ------------------------------------------------------------------------------------
awk -F'\t' -v edgefile="$work/edges.txt" '
  FILENAME == edgefile { edge[$1] = edge[$1] "\t" $2; next }
  { if (!($0 in seen)) { seen[$0] = 1; q[++n] = $0 } }
  END {
    for (i = 1; i <= n; i++) {
      f = q[i]
      if (!(f in edge)) continue
      m = split(edge[f], t, "\t")
      for (j = 1; j <= m; j++) if (t[j] != "" && !(t[j] in seen)) { seen[t[j]] = 1; q[++n] = t[j] }
    }
    for (s in seen) print s
  }
' "$work/edges.txt" "$work/roots.txt" | sort -u > "$work/reached.txt"

comm -12 "$work/distinct.txt" "$work/reached.txt" > "$work/built.txt"
comm -23 "$work/distinct.txt" "$work/built.txt" > "$work/never.txt"
built=$(wc -l < "$work/built.txt" | tr -d ' ')
never=$(wc -l < "$work/never.txt" | tr -d ' ')

# A plant under fixtures/ is supposed to fail its checker; compiling it clean would be the fault.
grep -E '(^|/)fixtures/' "$work/never.txt" > "$work/specimen.txt" || true
specimen=$(wc -l < "$work/specimen.txt" | tr -d ' ')
comm -23 "$work/never.txt" "$work/specimen.txt" > "$work/never_real.txt"
comm -12 "$work/never_real.txt" "$work/named_reading_real.txt" > "$work/asserted.txt"
asserted=$(wc -l < "$work/asserted.txt" | tr -d ' ')

if [ -n "$list" ]; then
  case "$list" in
    never)     cat "$work/never.txt" ;;
    asserted)  cat "$work/asserted.txt" ;;
    specimen)  cat "$work/specimen.txt" ;;
    dangling)  cat "$work/dangling.txt" ;;
    roots)     cat "$work/roots.txt" ;;
  esac
fi

echo "corpus=$corpus"
echo "symlinks=$symlinks"
echo "distinct=$distinct"
echo "runners=$runners"
echo "compiling_runners=$compiling_runners"
echo "reading_runners=$reading_runners"
echo "roots=$roots"
echo "edges=$edges"
echo "built=$built"
echo "never=$never"
echo "specimen=$specimen"
echo "asserted=$asserted"
echo "ceiling=$ceiling"
echo "dangling=$dangling"
echo "untracked_targets=$untracked_targets"

if [ "$asserted" -gt "$ceiling" ]; then
  echo "detail: $asserted tracked .rye files carry a runner's claim while no build ever reaches them, over a ceiling of $ceiling"
  sed 's/^/detail: asserted -- /' "$work/asserted.txt"
  echo "verdict=asserted_over_ceiling"
  exit 1
fi

echo "detail: every one of $distinct distinct Rye files is compiled by something, or is a specimen, or carries no claim"
echo "verdict=ok"
exit 0
