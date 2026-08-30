#!/bin/sh
# tools/fixtures/b/borrowed_number_scan.sh -- a witness owns the behaviour it guards, never the
# byte count of somebody else's file.
#
# WHAT THIS IS FOR. A witness sometimes wants a fact about a document -- how many bytes it holds,
# what its SHA-256 is -- and the quickest way to get one is to run the tool once and type the
# answer into an assertion. That typed answer is a copy, and the document it copies stays free to
# change without it. When the document changes, the assertion can never match again, and the
# witness reds for a reason having nothing to do with the behaviour it exists to guard.
#
# WHAT IT COSTS WHEN IT IS MISSED. REDS %341 found two such assertions and repaired them. REDS
# %357, one day later, found three more in the same family: SECURITY.md had moved from 2689 to
# 2659 bytes and context/TWO_ROOMS.md from 6079 to 6030, so all three had been failing since the
# day those documents were edited. None of the three sat on the standing roster, so a 96-guard cold
# pass read 95 green while three guards outside it were red. The lesson %341 wrote was the right
# one and reached only the files it happened to have open -- a repair closes an instance, a grep
# closes a family. A lantern that fires twice becomes a loom, so the family is measured here rather
# than remembered.
#
#   sh tools/fixtures/b/borrowed_number_scan.sh              # measure and gate
#   sh tools/fixtures/b/borrowed_number_scan.sh list         # print every site, with its line
#   sh tools/fixtures/b/borrowed_number_scan.sh prove-red    # plant one site; must refuse
#   sh tools/fixtures/b/borrowed_number_scan.sh prove-vacuum # hand it no sources; must refuse
#
# WHAT A SITE IS. An assertion in a tracked Rishi source comparing a literal that is EXACTLY the
# current byte size, or the current SHA-256, of a tracked file the same source names. Both halves
# are required: a bare number is just a number, and a file named beside a number it does not equal
# is a coincidence of reading rather than a pin.
#
# WHY IT IS CAUGHT WHILE IT IS STILL TRUE. This reading finds a borrowed number at birth, while
# the copy still matches its subject -- which is the only moment catching it is cheap. Once the
# document has moved, the literal is a number matching nothing and this reading goes quiet; by then
# the witness itself is red, and a red is its own alarm. So this guard and the standing roster
# close different halves of one class: the roster hears a pin that has already gone stale, and this
# one refuses the pin before it can.
#
# WHAT IT DOES NOT REACH, named rather than implied.
#   - A Rye selftest spelling another file's facts. The assertion read here is Rishi's `assert`,
#     which is where both firings of this class lived.
#   - A subject named only at runtime. The path must stand as a literal token somewhere in the
#     source; a path assembled from parts is invisible to a reader of the text, including this one.
#   - Intent. A number that equals a named file's size by accident reads exactly like a pin, so a
#     site is judged by a hand and repaired by a hand. This guard counts; it never rewrites.
#   - An already-stale pin, above.
#
# WHY THE FLOOR SITS AT THREE DIGITS, measured rather than chosen. A literal under 100 is read
# past, and so is a subject holding under 100 bytes. Measured on this tree `20260830.064405`: at a
# floor of one digit the reading compares 3,063 literals and returns 5 sites, the fifth being the
# literal `0` matching an empty `.gitkeep`; at three digits it compares 513 and returns 4, and the
# four are real. One digit costs a sixfold larger join and one false site, and buys nothing -- a
# document worth pinning holds more than 99 bytes, and only 5 of the 970 subjects this tree names
# hold fewer.
#
# WHY THE ELSE MESSAGE IS READ PAST. Rishi spells an assertion `assert COND else "message"`, and
# the message is printed rather than compared. A number there pins nothing, so the last quoted
# string on an assert line carrying `else` is dropped before the literals are gathered.
#
# WHY A ZERO REFUSES RATHER THAN REPORTS. A guard that reads no sources prints zero sites, and a
# zero nobody planted looks exactly like a healthy tree -- REDS %240's confident wrong zero. So an
# empty source list is a refusal here (`verdict=no_sources`) rather than a green reading.
set -eu

CEILING="${BORROWED_NUMBER_CEILING:-0}"
mode="${1:-measure}"

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this guard reads tracked living sources" >&2
  exit 1
}
cd "$root"
. "$root/tools/fixtures/s/shell_portable.sh"

# BOUNDS, named at construction. A source naming more than max_names paths, or comparing more than
# max_literals literals, is read up to the bound and no further; both are far above anything in
# this tree today (the widest source names 40-odd paths) and exist so a generated or pathological
# file cannot make this guard's memory grow with its input.
max_names=256
max_literals=256
max_sources=8192

work=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files > "$work/tracked.txt"
git ls-files '*.rish' > "$work/sources.txt"

if [ "$mode" = prove-vacuum ]; then
  # The vacuum, proven rather than assumed: hand the reading an empty source list and watch it
  # refuse. Without this leg a broken glob would read zero sites and print verdict=ok.
  : > "$work/sources.txt"
fi

if [ "$mode" = prove-red ]; then
  # The plant is ONE file rather than a copy of the repository -- REDS %239 was a pen that filled
  # the tmpfs and reddened four unrelated guards mid-run, so a pen here stays small. It borrows a
  # real fact from a real tracked file, which is what makes it the shape this guard hunts: the
  # size is read at plant time, so the plant is true the moment it is written, exactly as a
  # hand-typed pin is true the moment a hand types it.
  subject=tools/fixtures/s/shell_portable.sh
  planted_size=$(wc -c < "$subject" | tr -d ' ')
  printf 'assert out contains "%s reassembled %s B" else "planted borrowed count"\n' \
    "$subject" "$planted_size" > "$work/planted_borrow.rish"
  echo "$work/planted_borrow.rish" >> "$work/sources.txt"
fi

sources_read=$(grep -c . "$work/sources.txt" || true)
if [ "$sources_read" -gt "$max_sources" ]; then
  echo "refused: $sources_read sources past max_sources=$max_sources" >&2
  exit 1
fi

cat > "$work/collect.awk" <<'AWK'
# Emit, for each Rishi source that compares a quoted literal, the literals it pins and the tracked
# paths it names. A source comparing nothing emits nothing, so the size and digest work below is
# bounded by what the asserting sources actually name rather than by the whole tree.
BEGIN {
  while ((getline p < IDX) > 0) {
    tracked[p] = 1
    b = p
    sub(/^.*\//, "", b)
    bcount[b]++
    bpath[b] = p
  }
  close(IDX)
  cur = ""; nn = 0; nl = 0
}

function flush(   i) {
  if (cur == "" || nl == 0) return
  for (i = 1; i <= nl; i++) print "LIT\t" cur "\t" lit[i] "\t" litline[i] "\t" litkind[i]
  for (i = 1; i <= nn; i++) print "NAME\t" cur "\t" nam[i]
}

FNR == 1 { flush(); cur = FILENAME; nn = 0; nl = 0; split("", seenn); split("", seenl) }

# EVERY line names paths, comments included. The elder defect named its subject in a comment above
# the assertion rather than inside the compared string, so a reading that looked only at the
# assertion would have passed the very sites this guard exists for.
{
  s = $0
  while (match(s, "[A-Za-z0-9_./-]+")) {
    tok = substr(s, RSTART, RLENGTH)
    s = substr(s, RSTART + RLENGTH)
    p = ""
    if (tok in tracked) p = tok
    # A BARE BASENAME BINDS ONLY WHEN IT IS UNIQUE. `SECURITY.md` names one file and is how the
    # elder defect named its subject; `README.md` names dozens, so a mention of it identifies
    # nothing and is read past.
    else if (bcount[tok] == 1) p = bpath[tok]
    if (p != "" && !(p in seenn) && nn < MAXNAMES) { seenn[p] = 1; nam[++nn] = p }
  }
}

/^[ \t]*assert[ \t]/ {
  ns = 0; t = $0
  while (match(t, "\"[^\"]*\"")) {
    str[++ns] = substr(t, RSTART + 1, RLENGTH - 2)
    t = substr(t, RSTART + RLENGTH)
  }
  if ($0 ~ /[ \t]else[ \t]/ && ns > 0) ns--
  for (i = 1; i <= ns; i++) {
    u = str[i]
    while (match(u, "[0-9a-f]+")) {
      v = substr(u, RSTART, RLENGTH)
      u = substr(u, RSTART + RLENGTH)
      kind = ""
      if (length(v) == 64) kind = "hex"
      else if (v ~ /^[0-9]+$/ && length(v) >= MINDIGITS) kind = "size"
      if (kind != "" && !((v SUBSEP kind) in seenl) && nl < MAXLITS) {
        seenl[v SUBSEP kind] = 1
        lit[++nl] = v; litline[nl] = FNR; litkind[nl] = kind
      }
    }
  }
}

END { flush() }
AWK

: > "$work/records.txt"
xargs_lines_batched 400 "$work/sources.txt" \
  awk -v IDX="$work/tracked.txt" -v MAXNAMES="$max_names" -v MAXLITS="$max_literals" \
      -v MINDIGITS=3 -f "$work/collect.awk" >> "$work/records.txt"

literals=$(awk -F'\t' '$1 == "LIT"' "$work/records.txt" | grep -c . || true)

# THE SUBJECTS, measured once each. Only paths named by a source that compares a literal reach
# this loop, and only a regular file holding at least 100 bytes becomes a subject -- a symlink to
# a directory answers 0 to `wc -c` and would then match every literal `0` a source ever compared.
awk -F'\t' '$1 == "NAME" { print $3 }' "$work/records.txt" | sort -u > "$work/subjects.txt"
: > "$work/sizes.txt"
while IFS= read -r p; do
  [ -f "$p" ] || continue
  n=$(wc -c < "$p" | tr -d ' ')
  [ "$n" -ge 100 ] || continue
  printf '%s\t%s\n' "$p" "$n" >> "$work/sizes.txt"
done < "$work/subjects.txt"

# THE DIGESTS, measured only where a digest is actually compared. Hashing every subject would cost
# the whole reading; only sources comparing a 64-character hexadecimal literal can pin one, and
# there are few of them.
awk -F'\t' '$1 == "LIT" && $5 == "hex" { f[$2] = 1 }
            $1 == "NAME" && ($2 in f) { print $3 }' "$work/records.txt" | sort -u > "$work/hexsubjects.txt"
: > "$work/digests.txt"
while IFS= read -r p; do
  [ -f "$p" ] || continue
  if command -v sha256sum >/dev/null 2>&1; then h=$(sha256sum "$p" | cut -d' ' -f1)
  elif command -v shasum >/dev/null 2>&1; then h=$(shasum -a 256 "$p" | cut -d' ' -f1)
  else echo "refused: no sha256 tool on this host" >&2; exit 1
  fi
  printf '%s\t%s\n' "$p" "$h" >> "$work/digests.txt"
done < "$work/hexsubjects.txt"

cat > "$work/join.awk" <<'AWK'
# A literal meets a subject only when the subject was actually measured. An awk array element that
# was never set compares equal to both "" and 0, so an unguarded lookup reports every unmeasured
# path as a match for the literal `0` -- which is how this join first read 113 sites where 4 stand.
BEGIN { FS = "\t"
  while ((getline l < SIZES) > 0) { split(l, a, "\t"); sizeof_[a[1]] = a[2] }
  close(SIZES)
  while ((getline l < DIGESTS) > 0) { split(l, a, "\t"); digestof[a[1]] = a[2] }
  close(DIGESTS)
  cur = ""; nn = 0; nl = 0
}
function flush(   i, j) {
  if (cur == "" || nl == 0) return
  for (i = 1; i <= nl; i++) for (j = 1; j <= nn; j++) {
    if (litkind[i] == "size" && (nam[j] in sizeof_) && sizeof_[nam[j]] == lit[i])
      print cur ":" litline[i] "\tsize\t" lit[i] "\t" nam[j]
    else if (litkind[i] == "hex" && (nam[j] in digestof) && digestof[nam[j]] == lit[i])
      print cur ":" litline[i] "\tdigest\t" lit[i] "\t" nam[j]
  }
}
$1 == "LIT" { if ($2 != cur) { flush(); cur = $2; nn = 0; nl = 0 }
  lit[++nl] = $3; litline[nl] = $4; litkind[nl] = $5 }
$1 == "NAME" { nam[++nn] = $3 }
END { flush() }
AWK

awk -v SIZES="$work/sizes.txt" -v DIGESTS="$work/digests.txt" \
    -f "$work/join.awk" "$work/records.txt" | sort -u > "$work/sites.txt"

sites=$(grep -c . "$work/sites.txt" || true)
subjects=$(grep -c . "$work/sizes.txt" || true)
digests=$(grep -c . "$work/digests.txt" || true)

echo "borrowed_number: a witness owns the behaviour it guards, never another file's byte count."
echo "sources_read=$sources_read"
echo "literals_compared=$literals"
echo "subjects_measured=$subjects"
echo "digests_measured=$digests"
echo "borrowed_numbers=$sites"
echo "borrowed_ceiling=$CEILING"

if [ "$mode" = list ] || [ "$sites" -gt "$CEILING" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    echo "site $line"
  done < "$work/sites.txt"
fi

if [ "$sources_read" -eq 0 ]; then
  echo "verdict=no_sources"
  echo "refused: no Rishi sources reached the reading -- a zero nobody planted is not a green tree." >&2
  exit 1
fi

if [ "$sites" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  exit 1
fi

echo "verdict=ok"
