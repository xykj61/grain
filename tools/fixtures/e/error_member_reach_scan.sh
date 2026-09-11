#!/bin/sh
# tools/fixtures/e/error_member_reach_scan.sh -- can this tree produce every refusal it declares?
#
# WHY THIS EXISTS. TAME asks that a bound fail with a NAMED error, and a named error is a promise
# to the caller: this function can refuse in this particular way, so switch on it. A member
# declared in an `error{...}` set that no code anywhere returns or matches is that promise with
# nothing behind it -- a fence post standing on the diagram and passing through under the hand.
# Zig enforces the other direction only: a returned error must belong to the declared set. Nothing
# asks whether a declared member can ever arrive, so the drift is silent by construction.
#
# Found on an air lap 20260911 by pressing the reflex TAME states and this tree keeps everywhere
# else. Measured then: 4,213 declared member sites across 1,965 authored sources, and NINE sites
# naming a refusal nothing in the tree can make.
#
# WHAT IT READS. Every tracked *.rye outside vendor/, gratitude/ and seed/ -- the authored corpus,
# since a vendored source keeps its own discipline. A member is a line inside an `error{...}`
# block reading `Name,` with an optional trailing `//` comment; a production is `error.Name` or
# `SomeError.Name` anywhere in authored code, which covers a `return`, a `try ... catch` switch
# arm, and a witness's `expectError`. Comments AND string bodies are stripped before the production
# pass, because a member named only in prose is a member nothing can produce -- and a string body is
# prose by that same sentence. The two are told apart by one left-to-right walk rather than by two
# substitutions, since a `//` inside a string opens no comment and a quote inside a comment opens
# no string; the walk and the seven productions it recovered are described at the line that does it.
#
# TWO READINGS, AND ONLY ONE IS A FAULT.
#
#   dead_sites        a declared member NO authored source produces  -- RATCHET, ceiling only falls
#   unreached_in_file a member the DECLARING file never produces     -- reported, never gated
#
# THE SECOND IS NOT THE FIRST, and reading it as one would red the tree for a sound habit. Zig
# error names are global, so several modules may declare one shared vocabulary and a couple of
# them produce it: `OweMisrecorded` is declared in 47 caravan rungs and returned in two, which is
# one name meaning one thing across a ladder. Measured 20260911: 261 sites read unreached in their
# own file and 165 of them are caravan's shared vocabulary. So the gate reads the tree-wide
# question -- can ANYTHING produce this? -- and the per-file number stays a report with its cause
# named, rather than a ceiling somebody would have to argue with every lap.
#
# WHY A RATCHET RATHER THAN A GATE AT ZERO. The nine standing today were not made today, and four
# of them are Glow's -- names left behind when a widening made their check moot (`NotBarePayload`
# predates typed payloads; `MissingTagged` cannot fire because the absent-body case refuses as
# `MissingTuple` before the branch). Repairing another lane's five is that lane's word. A ceiling
# that only falls means the tenth reds on the lap it arrives, which is the whole promise.
#
# WHAT IT DOES NOT REACH. Whether a member that IS produced can be produced by any real input --
# reachability of the branch itself is a question for a witness, not a grep. And a member produced
# only from a language outside this corpus would read dead here; measured 20260911, no such site
# stands, since an error value is Zig's and Zig is what *.rye holds.
#
#   sh tools/fixtures/e/error_member_reach_scan.sh [--list]

set -u
LC_ALL=C
export LC_ALL

DEAD_CEILING=${ERROR_MEMBER_DEAD_CEILING:-9}
CORPUS=${ERROR_MEMBER_CORPUS:-}

# Root by upward walk (the letter fold moves this script's depth, so fixed ../.. arithmetic
# breaks), and skipped entirely when a corpus is handed in -- a control's pen is a directory of
# sources rather than a tree, and asking it for a root would refuse the one caller that needs no
# root at all.
if [ -z "$CORPUS" ]; then
  ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
  _em_steps=0
  while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
    _em_steps=$((_em_steps + 1))
    if [ "$_em_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
      echo "$0: no tree root within 8 steps (needs tools/fixtures and .git)" >&2
      exit 2
    fi
    ROOT=$(dirname "$ROOT")
  done
  cd "$ROOT" || exit 2
fi

list=no
[ "${1:-}" = "--list" ] && list=yes

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

if [ -n "$CORPUS" ]; then
  find "$CORPUS" -name '*.rye' -type f | sort > "$pen/files.txt"
else
  git ls-files '*.rye' | grep -vE '^(vendor|gratitude|seed)/' | sort > "$pen/files.txt"
fi
files=$(wc -l < "$pen/files.txt" | tr -d ' ')

if [ "$files" -eq 0 ]; then
  echo "files=0"
  echo "verdict=no_corpus"
  echo "detail: the reading found no authored *.rye source -- the meter has lost its subject, which reads exactly like a clean tree"
  exit 1
fi

# ONE PASS over the corpus, emitting three streams. It was two awk walks plus a sed-and-grep walk
# until `20260911.060527`, which read every source three times for 11.7s; folding them into one
# reader took it to 7.6s over the same 1,965 files, byte-identical output.
#
#   D<TAB>file<TAB>Name   a declared member site
#   P<TAB>Name            a production, anywhere in authored code
#   U<TAB>file<TAB>Name   a member the DECLARING file itself never produces
# `tr` and `xargs -0` rather than `xargs -a`: the arg-file flag is GNU-only, and this fleet has a
# Mac door, where a guard reading zero files would read as a clean tree (`shell_dialect`).
tr '\n' '\0' < "$pen/files.txt" | xargs -0 awk '
  FNR == 1 { flush(); nd = 0; inset = 0; delete used; delete seen; prevfile = FILENAME }
  {
    line = $0
    # A STRING BODY IS PROSE, and a `//` inside one opens no comment. Both halves of that sentence
    # were learned by measuring `20260911`: the reader stripped comments and left string bodies
    # standing, so a member named only inside a literal would have read as PRODUCED; and it
    # truncated at the first `//` anywhere, so `"sub//a.txt"` in `amphora/manifest_entry.rye:293`
    # and `"ok|udp://1|fresh|0"` in `comlink/discovery/gossip.rye:137` each took a real
    # `return error.` off the end of their own line. Seven productions were being lost that way, and
    # the count came from the repair itself rather than from a probe -- a first probe read fifteen
    # and was measuring its own broken patch. Neither moved `dead_sites` -- every name the strip
    # dropped is produced elsewhere too -- so both
    # were latent rather than live, and a reader repaired while its gate is quiet is a reader
    # repaired for free. The walk below runs only on lines holding a quote or a slash pair, which
    # is what keeps the pass at its measured speed.
    if (line ~ /["]/ || line ~ /\/\//) {
      out = ""; instr = 0; L = length(line); i = 1
      while (i <= L) {
        ch = substr(line, i, 1)
        if (instr) {
          if (ch == "\\") { out = out "  "; i += 2; continue }
          if (ch == "\"") { instr = 0; out = out "\""; i++; continue }
          out = out " "; i++; continue
        }
        if (ch == "\"") { instr = 1; out = out "\""; i++; continue }
        if (ch == "/" && substr(line, i + 1, 1) == "/") break
        out = out ch; i++
      }
      line = out
    }
    # A set opens only when `error{` ENDS the line. An inline set -- `error{Overflow}!u32` in a
    # signature -- closes on its own line and must never open the block, or a capitalized member
    # below it in the file reads as a declared refusal.
    if (!inset && line ~ /error\{[[:space:]]*$/) { inset = 1; next }
    if (inset && line ~ /^[[:space:]]*\}/) { inset = 0; next }
    if (inset && line ~ /^[[:space:]]*[A-Z][A-Za-z0-9_]*,[[:space:]]*$/) {
      g = line
      gsub(/[[:space:],]/, "", g)
      if (!(g in seen)) { seen[g] = 1; order[++nd] = g; print "D\t" FILENAME "\t" g }
      next
    }
    s = line
    while (match(s, /(error|[A-Za-z0-9_]*Err(or)?)\.[A-Z][A-Za-z0-9_]*/)) {
      tok = substr(s, RSTART, RLENGTH)
      sub(/^.*\./, "", tok)
      used[tok] = 1
      print "P\t" tok
      s = substr(s, RSTART + RLENGTH)
    }
  }
  function flush(   i) { for (i = 1; i <= nd; i++) if (!(order[i] in used)) print "U\t" prevfile "\t" order[i] }
  END { flush() }
' > "$pen/stream.txt"

sed -n 's/^D\t//p' "$pen/stream.txt" | sort -u > "$pen/decl.txt"
sed -n 's/^P\t//p' "$pen/stream.txt" | sort -u > "$pen/produced.txt"
sed -n 's/^U\t//p' "$pen/stream.txt" | sort -u > "$pen/unreached.txt"

members=$(wc -l < "$pen/decl.txt" | tr -d ' ')
cut -f2 "$pen/decl.txt" | sort -u > "$pen/names.txt"
names=$(wc -l < "$pen/names.txt" | tr -d ' ')
produced=$(wc -l < "$pen/produced.txt" | tr -d ' ')

comm -23 "$pen/names.txt" "$pen/produced.txt" > "$pen/deadnames.txt"
dead_names=$(wc -l < "$pen/deadnames.txt" | tr -d ' ')

: > "$pen/deadsites.txt"
if [ "$dead_names" -gt 0 ]; then
  awk -F'\t' 'NR==FNR { dead[$1] = 1; next } ($2 in dead) { print }' \
    "$pen/deadnames.txt" "$pen/decl.txt" > "$pen/deadsites.txt"
fi
dead_sites=$(wc -l < "$pen/deadsites.txt" | tr -d ' ')
unreached_in_file=$(wc -l < "$pen/unreached.txt" | tr -d ' ')

verdict=ok
[ "$dead_sites" -gt "$DEAD_CEILING" ] && verdict=dead_over_ceiling

echo "files=$files"
echo "members=$members"
echo "names=$names"
echo "produced=$produced"
echo "dead_sites=$dead_sites"
echo "dead_names=$dead_names"
echo "dead_ceiling=$DEAD_CEILING"
echo "unreached_in_file=$unreached_in_file"
echo "verdict=$verdict"

if [ "$list" = yes ]; then
  echo "dead_site_list:"
  while IFS="$(printf '\t')" read -r f n; do
    [ -n "$f" ] && echo "  $f $n"
  done < "$pen/deadsites.txt"
fi

[ "$verdict" = ok ] || exit 1
exit 0
