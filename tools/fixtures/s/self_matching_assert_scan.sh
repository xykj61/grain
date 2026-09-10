#!/bin/sh
# Read Rishi substring assertions for evidence supplied by the command operand itself.
# Gate simple stdout reads from file, stat, du, wc, and checksum commands with one
# literal path and no options. Their default output includes that operand. Other
# path matches stay reported, including stderr, options, compounds, and unresolved
# arguments. A report is a review lead; it does not establish a faulty assertion.
#
# Usage: sh tools/fixtures/s/self_matching_assert_scan.sh [--list gated|reported|unresolved]
# The recovered draft classified utilities by name alone. A size-only stat format
# disproved that rule. The control checks command forms and actual output separately.
# This is a bounded text scan: one-line runs and one-level literal bindings only.
# It does not parse Rishi scope or prove runtime control flow. A gate identifies a
# successful command whose stdout can satisfy the needle from its operand alone.
# Exit 0 within the gated ceiling, 1 over it, or 2 for misuse or an unreadable corpus.
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

# invariant: the demonstrated self-supplied evidence class is held at zero.
ceiling=0

# Bounds, each named because a census over a growing tree needs one. Measured `20260906`: 2,459
# tracked `.rish` runners carrying 14,919 `contains` asserts. Both ceilings are the next power of
# two above, so ordinary growth passes and a tenfold jump refuses rather than truncating in silence.
max_runners=8192
max_asserts=32768
min_needle=3

list=
while [ $# -gt 0 ]; do
  case "$1" in
    --list) [ $# -ge 2 ] || { echo "detail: --list wants a set name"; echo "verdict=no_set"; exit 2; }
            list=$2; shift 2 ;;
    *) echo "detail: unknown argument $1"; echo "verdict=bad_argument"; exit 2 ;;
  esac
done
case "$list" in
  ''|gated|reported|unresolved) ;;
  *) echo "detail: --list takes gated, reported, or unresolved"; echo "verdict=bad_set"; exit 2 ;;
esac

cd "$_fd_root"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
trap 'rm -rf "$work"; exit 130' INT
trap 'rm -rf "$work"; exit 143' TERM

git ls-files -- '*.rish' > "$work/runners.txt" 2>/dev/null || {
  echo "detail: git ls-files refused -- this is not a checkout"; echo "verdict=no_checkout"; exit 2; }
runners=$(wc -l < "$work/runners.txt" | tr -d ' ')
[ "$runners" -gt 0 ] || { echo "detail: no tracked .rish runners"; echo "verdict=empty_corpus"; exit 2; }
[ "$runners" -le "$max_runners" ] || {
  echo "detail: runners $runners over max_runners $max_runners -- raise the bound deliberately"
  echo "verdict=runners_over_bound"; exit 2; }

# THE READING. One awk pass per file, in source order, because a `let` binds before the `assert`
# that reads it and order is the whole of the resolution rule.
xargs_lines "$work/runners.txt" awk -v minlen="$min_needle" '
  FNR == 1 { delete binds; delete runargs; delete runline }

  # Full-line comments supply no executable evidence.
  /^[ \t]*#/ { next }

  # A new binding invalidates any earlier literal or command under the same name.
  /^[ \t]*let[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]*=/ {
    n = $0; sub(/^[ \t]*let[ \t]+/, "", n); sub(/[ \t]*=.*$/, "", n)
    delete binds[n]; delete runargs[n]; delete runline[n]
  }

  # A one-level literal binding: let name = "literal", with no interpolation of its own. One level
  # on purpose -- a chain of substitutions is a parser, and a parser that guesses wrong here makes a
  # CONFIDENT false accusation, which is the failure this whole family exists to refuse.
  /^[ \t]*let[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]*=[ \t]*"[^"]*"[ \t]*$/ {
    n = $0; sub(/^[ \t]*let[ \t]+/, "", n); sub(/[ \t]*=.*$/, "", n)
    v = $0; sub(/^[^=]*=[ \t]*"/, "", v); sub(/"[ \t]*$/, "", v)
    if (v !~ /\$\{/) binds[n] = v
    next
  }

  # Read a one-line literal run array.
  /^[ \t]*let[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]*=[ \t]*run[ \t]*\[/ {
    n = $0; sub(/^[ \t]*let[ \t]+/, "", n); sub(/[ \t]*=.*$/, "", n)
    a = $0; sub(/^[^[]*\[/, "", a); sub(/\][ \t]*$/, "", a)
    unres = 0
    while (match(a, /\$\{[A-Za-z_][A-Za-z0-9_]*\}/)) {
      k = substr(a, RSTART + 2, RLENGTH - 3)
      if (k in binds) { r = binds[k] } else { r = "\001"; unres = 1 }
      a = substr(a, 1, RSTART - 1) r substr(a, RSTART + RLENGTH)
    }
    runargs[n] = a; runline[n] = unres
    if (unres) printf "unresolved\t%s:%d\t%s\n", FILENAME, FNR, n
    next
  }

  # assert [(]var.out|err contains "needle"
  match($0, /^[ \t]*assert[ \t]+\(?[A-Za-z_][A-Za-z0-9_]*\.(out|err)[ \t]+contains[ \t]+"[^"]*"/) {
    s = substr($0, RSTART, RLENGTH); sub(/^[ \t]*/, "", s)
    channel = s; sub(/^assert[ \t]+\(?[A-Za-z_][A-Za-z0-9_]*\./, "", channel); sub(/[ \t].*$/, "", channel)
    v = s; sub(/^assert[ \t]+\(?/, "", v); sub(/\..*$/, "", v)
    nd = s; sub(/^.*contains[ \t]+"/, "", nd); sub(/"$/, "", nd)
    print "assert"
    if (!(v in runargs) || length(nd) < minlen) next
    a = runargs[v]

    # The needle must stand inside a PATH TOKEN of the arguments -- a whitespace- or quote-delimited
    # word carrying a slash. A needle matching loose prose in the command line proves nothing.
    m = split(a, tok, /[ \t"]+/); inpath = 0
    for (i = 1; i <= m; i++) if (tok[i] ~ /\// && index(tok[i], nd) > 0) { inpath = 1; break }
    if (!inpath) next

    # Admit exactly one plain operand. Options and shell syntax remain diagnostic.
    # Keeping the whole invocation here prevents a command name from proving output.
    cmd = ""; operand = ""
    if (a ~ /^[ \t]*"sh"[ \t]+"-c"[ \t]+"[A-Za-z0-9_./-]+[ \t]+[A-Za-z0-9_./-]+"[ \t]*$/) {
      body = a; sub(/^[ \t]*"sh"[ \t]+"-c"[ \t]+"/, "", body)
      sub(/"[ \t]*$/, "", body)
      split(body, parts, /[ \t]+/); cmd = parts[1]; operand = parts[2]
    } else if (a ~ /^[ \t]*"[A-Za-z0-9_./-]+"[ \t]+"[A-Za-z0-9_./-]+"[ \t]*$/) {
      body = a; gsub(/"/, "", body); sub(/^[ \t]*/, "", body)
      split(body, parts, /[ \t]+/); cmd = parts[1]; operand = parts[2]
    }
    sub(/^.*\//, "", cmd)
    echoing = (channel == "out" && !runline[v] && operand !~ /^-/ &&
      operand ~ /\// && index(operand, nd) > 0 &&
      cmd ~ /^(file|stat|du|wc|sha256sum|sha1sum|sha512sum|md5sum|cksum)$/)
    printf "%s\t%s:%d\t%s\n", (echoing ? "gated" : "reported"), FILENAME, FNR, nd
  }
' > "$work/hits.txt" || {
  echo "detail: corpus reader failed"; echo "verdict=reader_failed"; exit 2; }

asserts=$(grep -c '^assert$' "$work/hits.txt" || true)
[ "$asserts" -le "$max_asserts" ] || {
  echo "detail: asserts $asserts over max_asserts $max_asserts -- raise the bound deliberately"
  echo "verdict=asserts_over_bound"; exit 2; }

grep '^gated	' "$work/hits.txt" | cut -f2,3 | sort -u > "$work/gated.txt" || true
grep '^reported	' "$work/hits.txt" | cut -f2,3 | sort -u > "$work/reported.txt" || true
grep '^unresolved	' "$work/hits.txt" | cut -f2,3 | sort -u > "$work/unresolved.txt" || true
gated=$(wc -l < "$work/gated.txt" | tr -d ' ')
reported=$(wc -l < "$work/reported.txt" | tr -d ' ')
unresolved=$(wc -l < "$work/unresolved.txt" | tr -d ' ')

if [ -n "$list" ]; then
  case "$list" in
    gated)      cat "$work/gated.txt" ;;
    reported)   cat "$work/reported.txt" ;;
    unresolved) cat "$work/unresolved.txt" ;;
  esac
fi

echo "runners=$runners"
echo "asserts=$asserts"
echo "min_needle=$min_needle"
echo "gated=$gated"
echo "ceiling=$ceiling"
echo "reported=$reported"
echo "unresolved=$unresolved"

if [ "$gated" -gt "$ceiling" ]; then
  echo "detail: $gated asserts read a needle their own command line handed the tool, over a ceiling of $ceiling"
  sed 's/^/detail: self-matching -- /' "$work/gated.txt"
  echo "verdict=gated_over_ceiling"
  exit 1
fi
echo "detail: gated command forms are within ceiling; reported and unresolved reads need review"
echo "verdict=ok"
exit 0
