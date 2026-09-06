#!/bin/sh
# tools/fixtures/r/rye_witness_walker_scan.sh -- a witness proves what it CALLS, and claims the module.
#
#   sh tools/fixtures/r/rye_witness_walker_scan.sh [--list walked|unwalked|unreached|pairs]
#
# WHY THIS EXISTS. Zig analyses lazily. A witness that imports a module and calls two of its
# functions forces exactly those two bodies through semantic analysis and walks past everything
# else, so a public declaration carrying a flat type error rides through the build untouched and
# the witness prints GREEN. Measured `20260906` on metal rather than argued: a `pub fn` assigning
# a `u32` to a `[]const u8` was appended to `mantra/src/weave.rye`, nothing was changed anywhere
# else, and `tools/m/mantra_weave_merge_witness.rish` read GREEN -- its own five-break control
# included. That is REDS %470's fault in the file next door, found by the instrument %463 asked
# for.
#
# WHAT ANSWERS IT is four lines, and the tree already holds one. A comptime declaration walker
# references every declaration of the imported module, which forces each body through analysis:
#
#     comptime {
#         for (@typeInfo(subject).@"struct".decls) |decl| {
#             _ = &@field(subject, decl.name);
#         }
#     }
#
# `mantra/src/diff_witness.rye` carries the tree's first, and its own header names the missing
# piece plainly -- *the tree-wide instrument for this question is a peer's lap*. This is that lap.
#
# WHAT IT MEASURES, and why the subject is witnesses rather than modules. The tempting census is
# every tracked `.rye` against every walker, which would read *one covered, seventeen hundred
# uncovered* -- a big number that is confidently wrong in the one direction a big number is never
# questioned. Two reasons it would be wrong. A walker forces analysis TRANSITIVELY, since a body
# it resolves may call into a second module, so coverage is not the flat set it appears to be; and
# most modules never claimed to be proven by anything, so counting them as uncovered accuses files
# of failing a promise they never made.
#
# So the subject is the set of files that DO make the promise: a `*_witness.rye` importing a
# sibling module. Each such pair is a claim -- *this witness proves that module* -- and the walker
# is what backs it or leaves it resting on whichever functions the witness happened to call. That
# is REDS %487's rule one room over: count the believers rather than the carriers, and the
# predicate IS the finding.
#
#   pairs      a (witness, module) pair -- a tracked `*_witness.rye` importing a tracked sibling.
#              Reported for context; a witness imports its dependencies as well as its subject.
#   subjects   of those, the pairs where the module is the one the witness's own NAME promises --
#              `<dir>/X.rye` for `<dir>/X_witness.rye`, or the single tracked sibling a witness
#              imports when its stem names nothing. This is the promise, and the gated set.
#   ambiguous  a witness whose stem names nothing and which imports SEVERAL siblings, so it does
#              not say which it proves. Published and listed rather than guessed at or dropped.
#   walked     of the subjects, the ones whose witness walks that module's declarations.
#   unwalked   the remainder: a witness whose GREEN covers only what it calls. The ratchet.
#   unreached  of the walked, the ones whose WITNESS no build compiles -- a walker nobody runs.
#
# WHY THE GATE IS SUBJECTS RATHER THAN PAIRS. `mand_ring3_witness.rye` imports `mand_ring2.rye` the
# way any caller imports a dependency; it never promised to prove it. Gating every import would
# accuse ninety files of breaking a promise none of them made, and inflate the ratchet with work
# nobody should do -- a walker over the subject already forces analysis through whatever the subject
# actually calls. So both numbers are published and only the promise is held.
#
# WHY `unreached` IS PUBLISHED SEPARATELY, and not folded into `walked`. A walker only forces
# analysis when the file holding it is actually handed to the compiler; sitting in a file no build
# reaches it proves nothing at all. Crediting it anyway would carry a claim across a seam and drop
# its condition, which is exactly what REDS %488 booked one census over -- the credit crossed with
# its condition and the residue did not. The condition is asked of the resolver that already owns
# it, `rye_compile_reach_scan.sh --list never`, rather than learned here a second time: one
# resolver, two readers, because a rule written twice is a rule two files may quietly come to
# disagree about. When that scan is absent or cannot answer, `unreached` reads `-1` and says so --
# an unknown published as unknown, never as zero.
#
# WHY A COMMENT CANNOT CREDIT A PAIR. The walker is matched against the module's code with `//`
# comment bodies stripped first. A witness whose header SHOWS the walker shape to teach it -- as
# this scan's own header does, six lines up -- would otherwise be credited for a walker it does not
# run, and the teaching file is the likeliest place the shape appears. Proven from the failing side
# in the control.
#
# WHY THIS SCAN CANNOT READ ITSELF. REDS %463's sharpest lesson is that a census whose source
# carries its own detector patterns classifies itself the moment it becomes tracked, and reports the
# room empty. That fault cannot reach here for a structural reason rather than a careful one: the
# subject of this census is `*_witness.rye` files, and this scan is a `.sh`. `git ls-files '*.rye'`
# will never list it however many walker shapes its header spells. No exclusion list is needed, and
# one that was needed would be the weaker guard.
#
# WHY AN EMPTY READING REFUSES. A census that reads nothing answers *nothing is wrong*, which is
# indistinguishable from a healthy tree and was REDS %463's own first defect. Zero witnesses, zero
# tracked Rye, or a corpus over its bound all exit non-zero with a named verdict rather than a
# green.

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

# The ratchet, with no slack: it is the reading, so the next unwalked witness reds on the lap it
# arrives. Measured `20260906` -- 134 witnesses, 130 importing a tracked sibling, 121 of those
# naming a subject and 9 ambiguous. Of the 121, `walked` stood at 1 that morning and at 2 by the
# evening: `mantra/src/diff_witness.rye`, which was the tree's first walker, and
# `mantra/src/weave_merge_witness.rye`, which is the file whose blindness was proven on metal and
# is the reason this census exists. The ceiling only ever falls; lower it when a walker lands.
#
# Lowered 119 -> 56 on `20260906.144217`, when the Glow lane took its 63 subjects at once: every
# `glow/` and `glow/nock/` witness that named a subject now walks it. All 63 built GREEN with the
# walker in place, so the Glow modules carry no body-level type error the lazy analysis was
# hiding -- a reading, rather than an assumption. The remaining 56 are `linengrow/` (51),
# `mand/` (3), `mantra/` (1), and `tools/rye/` (1).
ceiling=56

# Bounds, each named. Witnesses stood at 134 and tracked Rye at 1,943 on `20260906`; both ceilings
# are the next power of two above, so ordinary growth passes and a tenfold jump refuses rather than
# truncating in silence.
max_corpus=4096
max_witnesses=512
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
  ''|walked|unwalked|unreached|pairs|ambiguous) ;;
  *) echo "detail: --list takes walked, unwalked, unreached, pairs, or ambiguous"; echo "verdict=bad_set"; exit 2 ;;
esac

cd "$_fd_root" || { echo "detail: cannot enter the tree root"; echo "verdict=no_root"; exit 2; }
work=$(mktemp -d) || { echo "detail: mktemp refused a scratch directory"; echo "verdict=no_scratch"; exit 2; }
# The handler EXITS. A trap that cleans up and returns lets POSIX resume the script where the
# signal landed, so the rest runs against a directory it just deleted and publishes a total from
# nothing -- REDS %487, booked the same day this scan was written.
trap 'rm -rf "$work"; exit 130' INT
trap 'rm -rf "$work"; exit 143' TERM
trap 'rm -rf "$work"' EXIT

# ---- the corpus, and the link text the repository holds ---------------------------------------
git ls-files -s -- '*.rye' > "$work/staged.txt" 2>/dev/null || {
  echo "detail: git ls-files refused -- this is not a checkout"; echo "verdict=no_checkout"; exit 2; }

awk '{ sub(/^[^\t]*\t/, ""); print }' "$work/staged.txt" | sort -u > "$work/corpus.txt"
corpus=$(wc -l < "$work/corpus.txt" | tr -d ' ')
[ "$corpus" -gt 0 ] || { echo "detail: no tracked .rye files"; echo "verdict=empty_corpus"; exit 2; }
[ "$corpus" -le "$max_corpus" ] || {
  echo "detail: corpus $corpus over max_corpus $max_corpus -- raise the bound deliberately"
  echo "verdict=corpus_over_bound"; exit 2; }

# mode 120000 is a symlink and its blob IS the link text, so one `cat-file --batch` reads them all.
# A second name for one file is not a second file: a pair naming the symlink and a pair naming its
# target are the same claim, and resolving first is what keeps them from being counted twice.
awk '$1=="120000" { path=$0; sub(/^[^\t]*\t/, "", path); print $2 "\t" path }' "$work/staged.txt" > "$work/links.txt"
symlinks=$(wc -l < "$work/links.txt" | tr -d ' ')
: > "$work/linkmap.txt"
if [ "$symlinks" -gt 0 ]; then
  cut -f1 "$work/links.txt" | git cat-file --batch --buffer > "$work/linktext.txt" 2>/dev/null || {
    echo "detail: git cat-file refused the link blobs"; echo "verdict=no_link_text"; exit 2; }
  awk '
    /^[0-9a-f]+ blob [0-9]+$/ { want=1; next }
    want == 1 { print; want=0 }
  ' "$work/linktext.txt" > "$work/targets.txt"
  paste "$work/links.txt" "$work/targets.txt" | awk -F'\t' '{ print $2 "\t" $3 }' > "$work/linkmap.txt"
fi

# ---- the witnesses that make a claim -----------------------------------------------------------
# A `*_witness.rye` is the file shape this tree gives to *an instrument proving a module*. Named by
# suffix rather than by content, because the promise is in the name a reader trusts at a glance.
grep '_witness\.rye$' "$work/corpus.txt" > "$work/witnesses.txt" || :
witnesses=$(wc -l < "$work/witnesses.txt" | tr -d ' ')
[ "$witnesses" -gt 0 ] || { echo "detail: no tracked *_witness.rye"; echo "verdict=no_witnesses"; exit 2; }
[ "$witnesses" -le "$max_witnesses" ] || {
  echo "detail: witnesses $witnesses over max_witnesses $max_witnesses -- raise the bound deliberately"
  echo "verdict=witnesses_over_bound"; exit 2; }

# ---- each witness: its sibling imports, and which of them it walks ------------------------------
# Zig refuses an import escaping the root file's directory, so a bare-name `@import("x.rye")`
# resolves against the importing file's own directory and nowhere else -- pure path arithmetic with
# no filesystem question to ask.
#
# THE COMMENT STRIP is the load-bearing line. Matching the walker against raw bytes credits a
# witness whose header merely SHOWS the shape, and a teaching header is exactly where the shape
# turns up. Bodies of `//` comments go before either pattern is read.
# One resolver, used for both the subject and every import, so the two can never be compared across
# a difference in how they were resolved.
resolve() {
  awk -F'\t' -v p="$1" -v hops="$max_link_hops" '
    function norm(q,   n, i, out, seg) {
      n = split(q, seg, "/"); out = ""
      for (i = 1; i <= n; i++) {
        if (seg[i] == "" || seg[i] == ".") continue
        if (seg[i] == "..") { sub(/\/?[^\/]*$/, "", out); continue }
        out = (out == "") ? seg[i] : out "/" seg[i]
      }
      return out
    }
    { link[$1] = $2 }
    END {
      h = 0
      while ((p in link) && h < hops) {
        d = p; if (!sub(/\/[^\/]*$/, "", d)) d = ""
        p = norm((d == "") ? link[p] : d "/" link[p]); h++
      }
      print p
    }
  ' "$work/linkmap.txt" < /dev/null
}

: > "$work/pairs.txt"
: > "$work/walked.txt"
: > "$work/unwalked.txt"
: > "$work/ambiguous.txt"
while IFS= read -r w; do
  [ -f "$w" ] || continue
  dir=$(dirname "$w")
  # The module this witness's own name promises: `<dir>/<stem>.rye` for `<dir>/<stem>_witness.rye`.
  # Resolved through the link map below like any other target, so a witness beside a symlinked
  # subject is judged against the file the subject really is.
  stem=$(basename "$w" | sed 's/_witness\.rye$//')
  subject=$(resolve "$dir/$stem.rye")
  grep -qxF "$subject" "$work/corpus.txt" || subject=
  sed 's://.*::' "$w" > "$work/code.txt"

  # Every identifier bound to a bare-name sibling import: `const NAME = @import("mod.rye");`
  awk '
    match($0, /const[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]*=[ \t]*@import\("[A-Za-z0-9_]+\.rye"\)/) {
      s = substr($0, RSTART, RLENGTH)
      ident = s; sub(/^const[ \t]+/, "", ident); sub(/[ \t]*=.*$/, "", ident)
      mod = s; sub(/^.*@import\("/, "", mod); sub(/"\).*$/, "", mod)
      print ident "\t" mod
    }
  ' "$work/code.txt" | sort -u > "$work/imports.txt"

  # Every identifier this witness actually walks: a decls loop over it AND a field read from it.
  # Both halves are required. The loop alone names the type; `@field` is what forces each body
  # through analysis, and a loop whose body does nothing would be a walker in shape only.
  #
  # The loop half is read as `@typeInfo(IDENT)` on a line that also says `decls`, rather than as one
  # pattern spanning both. The text between them is `.@"struct".` -- a quoted field name whose own
  # letters defeat any character class trying to skip it, which the first draft learned by reading
  # the tree's only real walker as absent.
  awk '
    /decls/ {
      s = $0
      while (match(s, /@typeInfo\([ \t]*[A-Za-z_][A-Za-z0-9_]*[ \t]*\)/)) {
        t = substr(s, RSTART, RLENGTH)
        sub(/^@typeInfo\([ \t]*/, "", t); sub(/[ \t]*\)$/, "", t)
        print "L\t" t
        s = substr(s, RSTART + RLENGTH)
      }
    }
    /@field\(/ {
      s = $0
      while (match(s, /@field\([ \t]*[A-Za-z_][A-Za-z0-9_]*/)) {
        t = substr(s, RSTART, RLENGTH)
        sub(/^@field\([ \t]*/, "", t)
        print "F\t" t
        s = substr(s, RSTART + RLENGTH)
      }
    }
  ' "$work/code.txt" | sort -u > "$work/walkmarks.txt"

  # Every import resolved and kept only if this tree tracks it. An import naming nothing tracked is
  # a different fault, and `rye_compile_reach_scan.sh` already counts it as `dangling`.
  : > "$work/sibs.txt"
  while IFS="$(printf '\t')" read -r ident mod; do
    [ -n "$ident" ] || continue
    real=$(resolve "$dir/$mod")
    grep -qxF "$real" "$work/corpus.txt" || continue
    printf '%s\t%s\n' "$ident" "$real" >> "$work/sibs.txt"
    printf '%s\t%s\n' "$w" "$real" >> "$work/pairs.txt"
  done < "$work/imports.txt"

  # THE PROMISE IS IN THE NAME, and it is read two ways before it is given up on.
  #
  # First the stem: `X_witness.rye` says *I prove X*, and its other sibling imports are the
  # dependencies that claim carries rather than claims of their own -- `mand_ring3_witness` imports
  # ring2 the way any caller does. Gating every import would accuse ninety files of breaking a
  # promise none of them made.
  #
  # Then the fallback, because the stem rule alone was measurably too strict: fourteen witnesses
  # name no `<stem>.rye` at all, and `mantra/src/weave_merge_witness.rye` -- which proves
  # `weave.rye`, and is the file whose blindness this whole census was built from -- was one of
  # them. A witness importing EXACTLY ONE tracked sibling is unambiguous whatever it is called, so
  # that one is its subject. Five of the fourteen resolve this way.
  #
  # The other nine import between two and nine siblings and genuinely do not say which they prove.
  # They are published as `ambiguous` and listed, never quietly dropped and never guessed at: a
  # residue nobody can see is a residue nobody can question (REDS %488).
  if [ -z "$subject" ]; then
    distinct_sibs=$(cut -f2 "$work/sibs.txt" | sort -u | wc -l | tr -d ' ')
    if [ "$distinct_sibs" -eq 1 ]; then
      subject=$(cut -f2 "$work/sibs.txt" | sort -u)
    elif [ "$distinct_sibs" -gt 1 ]; then
      echo "$w" >> "$work/ambiguous.txt"
    fi
  fi
  [ -n "$subject" ] || continue

  # Any identifier bound to the subject counts; a witness may import one module under two names.
  while IFS="$(printf '\t')" read -r ident real; do
    [ "$real" = "$subject" ] || continue
    if grep -qxF "$(printf 'L\t%s' "$ident")" "$work/walkmarks.txt" \
       && grep -qxF "$(printf 'F\t%s' "$ident")" "$work/walkmarks.txt"; then
      printf '%s\t%s\n' "$w" "$real" >> "$work/walked.txt"
    else
      printf '%s\t%s\n' "$w" "$real" >> "$work/unwalked.txt"
    fi
  done < "$work/sibs.txt"
done < "$work/witnesses.txt"

# A witness naming its subject under two identifiers, one walked and one not, is walked: the
# declarations went through analysis. Drop the unwalked twin so the two sets never overlap.
sort -u "$work/walked.txt" -o "$work/walked.txt"
if [ -s "$work/walked.txt" ]; then
  grep -vxF -f "$work/walked.txt" "$work/unwalked.txt" > "$work/unwalked.trim" 2>/dev/null || :
  mv "$work/unwalked.trim" "$work/unwalked.txt"
fi

sort -u "$work/pairs.txt" -o "$work/pairs.txt"
sort -u "$work/unwalked.txt" -o "$work/unwalked.txt"
sort -u "$work/ambiguous.txt" -o "$work/ambiguous.txt"

pairs=$(wc -l < "$work/pairs.txt" | tr -d ' ')
walked=$(wc -l < "$work/walked.txt" | tr -d ' ')
unwalked=$(wc -l < "$work/unwalked.txt" | tr -d ' ')
subjects=$((walked + unwalked))
ambiguous=$(wc -l < "$work/ambiguous.txt" | tr -d ' ')
# EVERY REFUSAL BELOW PRINTS ITS READINGS FIRST. A guard that refuses without publishing what it
# read sends a reader to lines it never printed, so `no_pairs` and `no_subjects` are decided here
# and acted on after the readings, rather than exiting where they are found.
refusal=
refusal_detail=
if [ "$pairs" -eq 0 ]; then
  refusal=no_pairs
  refusal_detail="no witness imports a tracked sibling module"
elif [ "$subjects" -eq 0 ]; then
  refusal=no_subjects
  refusal_detail="no witness names a subject -- every one of the $ambiguous that import siblings is ambiguous"
fi

# ---- the condition the credit rides on ---------------------------------------------------------
# A walker in a file no build compiles forces nothing. The resolver that already answers *which
# Rye does anything ever compile* is asked, rather than a second reader of the same question being
# grown here. Absent or refusing, the answer is published as `-1` -- unknown -- and never as zero.
: > "$work/unreached.txt"
unreached=-1
reach_scan="tools/fixtures/r/rye_compile_reach_scan.sh"
if [ "$walked" -gt 0 ] && [ -f "$reach_scan" ]; then
  if sh "$reach_scan" --list never > "$work/never_raw.txt" 2>/dev/null; then
    grep -v '=' "$work/never_raw.txt" > "$work/never.txt" 2>/dev/null || :
    cut -f1 "$work/walked.txt" | sort -u > "$work/walkers.txt"
    unreached=0
    while IFS= read -r carrier; do
      [ -n "$carrier" ] || continue
      if grep -qxF "$carrier" "$work/never.txt" 2>/dev/null; then
        echo "$carrier" >> "$work/unreached.txt"
        unreached=$((unreached + 1))
      fi
    done < "$work/walkers.txt"
  fi
fi

if [ -n "$list" ]; then
  case "$list" in
    walked)    cat "$work/walked.txt" ;;
    unwalked)  cat "$work/unwalked.txt" ;;
    unreached) cat "$work/unreached.txt" ;;
    pairs)     cat "$work/pairs.txt" ;;
    ambiguous) cat "$work/ambiguous.txt" ;;
  esac
fi

echo "corpus=$corpus"
echo "symlinks=$symlinks"
echo "witnesses=$witnesses"
echo "pairs=$pairs"
echo "subjects=$subjects"
echo "ambiguous=$ambiguous"
echo "walked=$walked"
echo "unwalked=$unwalked"
echo "unreached=$unreached"
echo "ceiling=$ceiling"

if [ -n "$refusal" ]; then
  echo "detail: $refusal_detail"
  echo "verdict=$refusal"
  exit 2
fi

if [ "$unreached" -gt 0 ]; then
  echo "detail: $unreached walker-carrying witnesses are compiled by no build -- the walker forces nothing"
  sed 's/^/detail: unreached -- /' "$work/unreached.txt"
  echo "verdict=walker_unreached"
  exit 1
fi

if [ "$unwalked" -gt "$ceiling" ]; then
  echo "detail: $unwalked witness-module pairs prove only what the witness calls, over a ceiling of $ceiling"
  sed 's/^/detail: unwalked -- /' "$work/unwalked.txt"
  echo "verdict=unwalked_over_ceiling"
  exit 1
fi

echo "verdict=ok"
