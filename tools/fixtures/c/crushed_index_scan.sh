#!/bin/sh
# tools/fixtures/c/crushed_index_scan.sh -- a crushed index tells the truth about the room it names.
#
# WHY. A crushed index is the page a reader trusts INSTEAD of walking the room. On 20260906 three
# indexes on one shelf each miscounted the room they stand in front of, and every link on all three
# resolved -- so a link check reads them as whole. The full account is in the witness's own head,
# tools/cr/crushed_index_witness.rish; the mechanism is here.
#
# WHAT A DECLARATION IS, and why the guard reads one rather than a list kept here. A page opts in
# by naming its room in its own header:
#
#   **Kind:** crushed index of `../../press/`      -- as docs-geode/press/README.md writes it,
#                                                     one level
#
# The example above carries backticks and no link, on purpose (`20260907.192241`). It is a QUOTATION
# of another page's line, and `../../press/` is relative to THAT page rather than to this one -- from
# here it would name `tools/press/`, which stands nowhere. Written as `](../../press/)` it read as
# this file's own citation, and tools/co/comment_citation_witness.rish refused the tree for a promise
# nobody had made. A backticked span illustrating syntax is an exclusion that guard already names,
# so the repair is the grammar it already owns rather than a new rule.
#
# The declaration is the page's own promise, so a shelf that grows a new index arrives guarded on
# the day it declares itself, and this file never becomes a roster somebody has to remember to
# edit. docs-geode/press/README.md already carried exactly this line before the guard existed,
# which is why the mechanism is its spelling rather than a new one.
#
# WHAT A MEMBER IS. Every tracked entry directly in the named room -- file or directory -- minus
# `README.md`, which is the room's own door rather than a thing the room holds. One rule serves
# both granularities the shelf actually uses: docs-geode/'s members are its twelve rooms, press/'s
# are its four announcements. A member is LISTED when some link target on the page names it: a
# directory when a target enters it (`api/rishi-language-reference.md` lists `api`), a file when a
# target ends at it. Matching the bare word anywhere on the page would credit a mention in prose as
# a row, which is the failure this guard exists to catch wearing a friendlier face.
#
# THE SECOND DECLARATION, and the fault that earned it. A page may instead promise the WHOLE
# subtree, one word longer:
#
#   **Kind:** crushed index of every page under [`../`](../)      -- as docs-geode/wiki/README.md
#                                                              writes it, the whole subtree
#
# Its members are every tracked file at any depth under the room, minus `README.md` wherever it
# stands, since a door is a door on every floor. The two forms answer two different promises and
# neither substitutes for the other: `docs-geode/README.md` lists ROOMS and says so, while
# `docs-geode/wiki/README.md` promises "every shipped page" across the shelf. Read one room deep,
# that wiki was green while THREE sangha pattern pages stood off the map -- `01-descriptor-exchange`,
# `02-fact-fold` and `03-five-primitives`, each carrying its own Witness basis. The one-level rule
# credited them all, because the page links `sangha/README.md` and a target entering a directory
# lists the directory. That is the SHOPPING fault of `20260906` a second time, one floor down, and
# a lantern that fires twice becomes a loom.
#
# THE DEEP WALK IS BOUNDED, at `max_deep_members` = 256 entries per declared room, and the number is
# the tree's own: a room folds past 256 flat files because a listing longer than that is no longer
# one a reader holds (`.claude/rules/stamp-and-name.md`). An index is the page a reader trusts
# INSTEAD of walking the room, so the same ceiling is the honest one here. A deep room past it is
# REFUSED by name -- `index_rooms_oversize` -- rather than walked in silence, and the answer is to
# split the index or raise the bound with a reason. Measured 20260906: docs-geode/ holds 8.
#
# WHAT IS GATED, hard, all at zero.
#   index_unlisted        -- a member of a declared room with no row on its index
#   index_rooms_missing   -- a declaration naming a room that is not on disk
#   index_rooms_oversize  -- a deep declaration over a room holding more than `max_deep_members`
#   index_doors_missing   -- a link target on a declared index that does not resolve
#   row_stamp_disagrees   -- a table row whose Stamp cell disagrees with the stamp in the file it
#                            links. Measured over all 526 living non-testimony Markdown pages on
#                            20260906: exactly ONE, on this shelf. A molt had moved press/'s Siya
#                            announcement and the repoint followed the LINK, leaving the Stamp cell
#                            a month behind. A repoint sweep follows links, and a stamp in a table
#                            is a claim rather than a link.
#   generated_count_disagrees -- a page spelling the count a GENERATED index derives, where the two
#                            numbers disagree. Measured 20260909: the shelf's own front door said
#                            `38 rooms` in the table row pointing at a generated page whose fresh
#                            render listed 37. The generator proves its own page and nothing beside
#                            it, so a restatement one file away is invisible to it.
#   title_count_claimed   -- a declared index whose own TITLE spells a count of its room. A title is
#                            a name, and the mark law forbids a total inside one, since it stays at
#                            whatever it was the day somebody typed it. Three rooms on this shelf
#                            met the fault in prose and each moved its count into a table; the
#                            fourth stood in a title, where none of the three repairs had looked.
#                            The FORM is refused rather than the value -- see the pass itself.
#   section_count_disagrees -- a title spelling a count of the page's OWN numbered sections, where
#                            the two numbers disagree. The other strand of the same subject, and the
#                            opposite choice: an index's basis is a room other hands grow, so the
#                            form is refused; a page's numbered sections sit inside it, so the VALUE
#                            is checked and a true count keeps its place in a name that reads well.
#                            Measured 20260911 over every living page: eight hold numbered top-level
#                            sections and one spells a count in its title, green over all of it.
#   signature_unbacked    -- a page signing `witness:<name> GREEN` names an instrument something
#                            can find. Measured 20260906: seven living signed pages, six backed by
#                            a fixture that reads their claims, and one -- the shipping shelf's own
#                            front door -- signing GREEN from a witness that stood exactly once in
#                            this tree, inside that sentence.
#
# WHAT IS REPORTED, never gated. The declared-index roster and its member totals, so a reader can
# see how far the guard reaches; `declared_deep`, the count of declarations promising a whole
# subtree, so the two forms can be told apart from the outside; and `signed_pages`, so a signature
# added tomorrow is visible here before anyone asks whether it is backed.
#
# WHAT THIS DOES NOT REACH, said plainly. Whether a row SAYS anything true about the member it
# names -- this proves every member has a row and every row opens on something, not that the
# sentence beside it is honest. And `backed` means an instrument by that name exists and is either
# on the standing roster or named by a tracked file under tools/; it does not prove the instrument
# reads the claims the signature covers. Naming the weaker claim is the point (REDS %446).
#
# A COUNT IN A TITLE IS READ ONLY ON A DECLARED INDEX, which is the honest bound on THAT reading
# rather than an oversight, and the gap it left has its own reading below. `docs-geode/demos/README.md`
# opens `# Demos -- five checks you can run` and holds five numbered sections; it declares `crushed
# demonstrations` rather than an index of a room, so no member walk here derives a number to check it
# against. A page counting its own SECTIONS is a different subject from a page counting a ROOM, and
# giving one reading both jobs is the braid this tree already names single-stranded. So the two stay
# apart: `title_count_claimed` refuses the FORM on a declared index, and `section_count_disagrees`
# checks the VALUE on a page whose own numbered sections supply the basis.
#
# USAGE
#   sh tools/fixtures/c/crushed_index_scan.sh
#
# Driven by tools/cr/crushed_index_witness.rish. Run from the repository root.

set -eu

root="${CRUSHED_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$root"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# THE FILE LIST REACHES `xargs` ON STDIN, never through `-a`. That flag is GNU-only and BSD `xargs`
# has no equivalent at all, so a scan spelled with it dies on the macOS bench before it reads a
# line. `shell_dialect` gates that family at zero and read four sites in this file on the lap it was
# written -- the second guard this round to catch its own author, which is what a standing meter is
# for. Redirection is the spelling every host runs.

# A repository-relative path with its `.` and `..` folded away, computed from the string alone so
# the answer does not depend on what happens to exist on disk. The first draft of this walked the
# path with two sed substitutions in a loop and stopped one component short: `docs-geode/press/`
# plus `../../press/` came out `docs-geode/../press/`, because the second `..` had no leading slash
# in front of its component and the glob that drove the loop needed one. Splitting on `/` and
# keeping a stack has no such edge -- the trailing slash is carried because a room is written with
# one and the member listing depends on the exact prefix.
resolve_path() {
  printf '%s\n' "$1" | awk '{
    n = split($0, part, "/")
    top = 0
    trail = 0
    for (i = 1; i <= n; i++) {
      p = part[i]
      if (p == "") { if (i == n) trail = 1; continue }
      if (p == ".") continue
      if (p == "..") { if (top > 0) top--; continue }
      out[++top] = p
    }
    s = ""
    for (i = 1; i <= top; i++) s = s (i > 1 ? "/" : "") out[i]
    if (trail && s != "") s = s "/"
    print s
  }'
}

# THE CORPUS: living tracked Markdown. Dated testimony keeps every word it wrote (accrete-never-
# break), and the tree draws that line by the basename -- a file whose own name carries a one-clock
# stamp is testimony. The stamp shape is written with the WIDE spelling, `[_.]` rather than `_`, so
# a sprigless name is testimony too: 237 tracked logs carry a stamp and no sprig, and a pattern
# requiring the sprig read every one of them as living (REDS %175).
git ls-files '*.md' \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | sort > "$work/living.txt"

# A CORPUS OF ZERO IS A RED, NEVER A READING. Every count below is taken against this one list, so
# an empty list would hand back a confident zero for every gate at once -- the shape REDS %170
# names, and the shape a guard is least able to notice about itself.
if [ ! -s "$work/living.txt" ]; then
  echo "refused: no living Markdown found -- the corpus every reading below counts against is empty" >&2
  exit 1
fi
echo "living_pages=$(wc -l < "$work/living.txt" | tr -d ' ')"

# --- the declared indexes, and the rooms they promise ---------------------------------------------
# A header is the block above the first `---` rule, read at most forty lines in, exactly as the
# quality card reads a page's own declaration. A body that merely discusses crushed indexes
# declares nothing.
: > "$work/declared.txt"
while IFS= read -r page; do
  [ -f "$page" ] || continue
  decl=$(awk 'NR <= 40 { if ($0 ~ /^---[ \t]*$/) exit; print }' "$page" \
    | grep -oE '\*\*Kind:\*\*[^|]*crushed index of[^)]*\)' | head -1) || true
  [ -n "$decl" ] || continue
  # The room is the LINK TARGET, never the label: a label may be prettified and a target may not.
  target=$(printf '%s' "$decl" | grep -oE '\]\([^)]+\)$' | sed 's/^](//; s/)$//')
  [ -n "$target" ] || continue
  # Resolve the target relative to the page's own directory, so `../../press/` from
  # docs-geode/press/README.md reads `press/`. A pure text resolve keeps this a function of the
  # two strings rather than of what happens to exist.
  dir=$(dirname "$page")
  room=$(resolve_path "$dir/$target")
  case "$room" in */) ;; *) room="$room/" ;; esac
  # WHICH PROMISE the page made, read from the declaration's own words. `every page under` reaches
  # the whole subtree; anything else reaches one level, which is what every declaration written
  # before 20260906 meant and still means. The depth rides in the record so the members loop below
  # never has to re-read the page.
  case "$decl" in
    *"crushed index of every page under"*) depth=deep ;;
    *) depth=room ;;
  esac
  printf '%s %s %s\n' "$page" "$room" "$depth" >> "$work/declared.txt"
done < "$work/living.txt"

declared=$(wc -l < "$work/declared.txt" | tr -d ' ')
echo "declared_indexes=$declared"
# COUNTED WITH `awk` RATHER THAN `grep -c`, for the reason this file already gives at the stamp
# pass: `grep` exits 1 on finding nothing, which is an answer, and the `|| true` that tolerates it
# tolerates an unreadable file just as quietly. An `awk` program producing output has no
# found-nothing exit, so `set -e` still carries a real failure here.
echo "declared_deep=$(awk '$3 == "deep" { n++ } END { print n + 0 }' "$work/declared.txt")"

# --- every member of a declared room has a row ----------------------------------------------------
unlisted=0
rooms_missing=0
rooms_oversize=0
doors_missing=0
members_total=0
max_deep_members=256
: > "$work/unlisted.txt"
: > "$work/rooms_missing.txt"
: > "$work/rooms_oversize.txt"
: > "$work/doors_missing.txt"

while read -r page room depth; do
  if [ ! -d "$room" ]; then
    rooms_missing=$((rooms_missing + 1))
    printf '%s declares %s\n' "$page" "$room" >> "$work/rooms_missing.txt"
    continue
  fi

  # The page's link targets, once, with any fragment cut -- a `#section` names a place inside a
  # page rather than a different page.
  grep -oE '\]\([^)]+\)' "$page" | sed 's/^](//; s/)$//; s/#.*//' | sort -u > "$work/targets.txt"

  # Every door on a declared index opens. A row naming a file that is not there is the one fault an
  # index can carry that a reader cannot see from the index itself.
  while IFS= read -r t; do
    case "$t" in
      ""|http*|mailto:*) continue ;;
    esac
    p=$(resolve_path "$(dirname "$page")/$t")
    if [ ! -e "$p" ]; then
      doors_missing=$((doors_missing + 1))
      printf '%s -> %s\n' "$page" "$t" >> "$work/doors_missing.txt"
    fi
  done < "$work/targets.txt"

  # The room's members. A `room` declaration reads one level: the first path component of each
  # tracked path, so a directory is one member however much it holds. A `deep` declaration reads the
  # whole subtree: every tracked file at any depth, with `README.md` dropped wherever it stands,
  # since a door is a door on every floor.
  if [ "$depth" = deep ]; then
    # DEFERRED AND DATED ROOMS ARE NOT MEMBERS, and this line was the one place in this file that
    # disagreed with it. The corpus above is built as living tracked Markdown with
    # `grep -vE '(^|/)(date|archive|yonder)/'`, on the tree's own law that those rooms hold
    # testimony and deferred work -- yet the deep walk read them as pages an index must name. A
    # room that folds a day shelf, or parks work in `yonder/`, would then owe its index a row for
    # every parked file. Found `20260906` when a drafting room moved under a deep-declared shelf
    # and the guard asked for twenty rows on a page about shipped teaching surfaces.
    git ls-files "$room" | sed "s|^$room||" | grep -vE '(^|/)(date|archive|yonder)/' | grep -vE '(^|/)README\.md$' | sort -u > "$work/members.txt" || true
    # THE BOUND, checked at the edge before the walk rather than after it. A refusal that arrives
    # once the work is done is a report rather than a bound.
    if [ "$(wc -l < "$work/members.txt" | tr -d ' ')" -gt "$max_deep_members" ]; then
      rooms_oversize=$((rooms_oversize + 1))
      printf '%s declares every page under %s -- %s members, over max_deep_members=%s\n' \
        "$page" "$room" "$(wc -l < "$work/members.txt" | tr -d ' ')" "$max_deep_members" \
        >> "$work/rooms_oversize.txt"
      continue
    fi
  else
    # THE SAME LAW AS THE DEEP BRANCH, applied where a member is a bare path component. The deep
    # walk above drops `date/`, `archive/`, and `yonder/` because those rooms hold testimony and
    # deferred work, which an index does not owe a row. The one-level walk cuts each path to its
    # first component, so a folded day shelf arrives here as the bare word `date` -- and a pattern
    # written `(^|/)date/` cannot match a word carrying no slash. `press/` folded its first shelf on
    # `20260908` and the guard immediately asked its index for a row naming `date`, a row the tree's
    # own fold law forbids. One law, two branches, and only one of them had it.
    git ls-files "$room" | sed "s|^$room||" | cut -d/ -f1 | sort -u \
      | grep -vxE '(date|archive|yonder)' | grep -v '^README\.md$' > "$work/members.txt" || true
  fi
  while IFS= read -r m; do
    [ -n "$m" ] || continue
    members_total=$((members_total + 1))
    # `/` IS NOT ESCAPED, and this matters only once a member can hold one. In an ERE a slash is an
    # ordinary character, while `\/` is a backslash before an ordinary character -- undefined by
    # POSIX, accepted by GNU grep, and exactly the kind of line that reads fine here and dies on the
    # macOS bench. A one-level member never held a slash, so the escape was harmless and untested;
    # a deep member is a path, so it holds one on every row.
    esc=$(printf '%s' "$m" | sed 's|[].[^$*\\]|\\&|g')
    if [ -d "$room$m" ]; then pat="(^|/)$esc/"; else pat="(^|/)$esc\$"; fi
    if grep -qE "$pat" "$work/targets.txt"; then continue; fi
    unlisted=$((unlisted + 1))
    printf '%s has no row on %s\n' "$room$m" "$page" >> "$work/unlisted.txt"
  done < "$work/members.txt"
done < "$work/declared.txt"

echo "index_members=$members_total"
echo "index_unlisted=$unlisted"
echo "index_rooms_missing=$rooms_missing"
echo "index_rooms_oversize=$rooms_oversize"
echo "index_doors_missing=$doors_missing"

# --- a row's stamp against the stamp in the file it links -----------------------------------------
# A table row carrying a `YYYYMMDD.HHMMSS` cell beside a link into a dated file is making two claims
# about one thing. A molt moves the file and a repoint sweep follows the LINK; the cell is not a
# link, so it stays where it was and every meter reads the row as fine.
#
# THIS PASS TOLERATES NOTHING. An `awk` program producing OUTPUT has no found-nothing exit, so any
# non-zero here is a failure rather than an answer -- and a `|| true` on it would report a tree with
# no disagreements whether the reading ran or not (REDS %413, %416). `set -eu` carries the refusal.
xargs awk -F'|' < "$work/living.txt" '
  /^\|/ {
    cell = $2
    gsub(/[ \t`*]/, "", cell)
    if (cell !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\.[0-9][0-9][0-9][0-9][0-9][0-9]$/) next
    row = $0
    while (match(row, /\]\([^)]+\)/)) {
      t = substr(row, RSTART + 2, RLENGTH - 3)
      row = substr(row, RSTART + RLENGTH)
      n = t
      sub(/.*\//, "", n)
      if (n !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]/) continue
      seen = substr(n, 1, 8) "." substr(n, 10, 6)
      if (seen != cell) printf "%s: row says %s, the file it links says %s\n", FILENAME, cell, seen
    }
  }' > "$work/stamps.txt"
stamp_disagrees=$(wc -l < "$work/stamps.txt" | tr -d ' ')
echo "row_stamp_disagrees=$stamp_disagrees"

# --- a GREEN signature names an instrument that exists --------------------------------------------
# A page may sign itself `witness:<name> GREEN`. Six such pages are backed by a fixture that reads
# their claims and aborts on the first that fails; one was backed by nothing at all.
#
# THIS GUARD READS PAST ITS OWN THREE FILES, and the reason is a fault this tree has already paid
# for: an instrument that spells the shape it hunts will find itself and report a clean tree (REDS
# %458). So the scan, its control, and its witness are excluded by name from the backing search,
# and the backing this guard's own signature rests on is the STANDING ROSTER -- which is the
# stronger form anyway, since a roster row means the instrument actually runs.
# TWO PASSES RATHER THAN ONE PIPELINE, so each failure keeps its own meaning. `grep` exits 1 when
# it finds nothing, which is an ANSWER and correctly tolerated; `sed` and `sort` have no such exit,
# so a pipeline ending in `sort ... || true` discards a real failure alongside grep's answer and
# reports a tree with no signatures at all. `instrument_refusal` read this line on the lap it was
# written (REDS %413, %416), which is a loom catching its own author.
: > "$work/sigs.raw"
xargs grep -hoE '^witness:[a-z0-9-]+' < "$work/living.txt" 2>/dev/null > "$work/sigs.raw" || true
sed 's/^witness://' "$work/sigs.raw" | sort -u > "$work/sigs.txt"
echo "signed_pages=$(xargs grep -lE '^witness:[a-z0-9-]+ +GREEN' < "$work/living.txt" 2>/dev/null | wc -l | tr -d ' ')"

git ls-files 'tools/*' \
  | grep -vE '(^|/)(crushed_index_scan\.sh|crushed_index_control\.sh|crushed_index_witness\.rish)$' \
  > "$work/instruments.txt"

unbacked=0
: > "$work/unbacked.txt"
while IFS= read -r name; do
  [ -n "$name" ] || continue
  # The stronger backing first: a guard of that name on the standing roster runs every lap.
  if grep -qE "^guard $(printf '%s' "$name" | tr '-' '_')\$" construction/standing-equipment.kyri 2>/dev/null; then
    continue
  fi
  # The weaker backing: a tracked file under tools/, this guard's own excluded, names it.
  if xargs grep -lF "witness:$name" < "$work/instruments.txt" 2>/dev/null | head -1 | grep -q .; then
    continue
  fi
  unbacked=$((unbacked + 1))
  printf '%s names no instrument\n' "$name" >> "$work/unbacked.txt"
done < "$work/sigs.txt"
echo "signature_unbacked=$unbacked"

# --- a page spelling the count a generated index derives -------------------------------------------
# THE FAULT THIS READS, and it is the one this whole guard was drawn for wearing its plainest face.
# One index on this shelf is GENERATED -- `docs-geode/libraries/README.md`, rendered off the tree by
# tools/g/geode_libraries.rish and held byte for byte by its own witness -- so its count is derived
# and moves when the tree does. Then the shelf's front door spelled that count in the very table row
# pointing at it: `38 rooms holding Rye modules`, against a page whose fresh render listed 37. The
# generated page was green throughout, because a generator proves its OWN page and nothing beside it.
#
# Every other reading here is blind to it by construction. The declaration check asks whether each
# member has a row; the door check asks whether each link opens; the stamp check reads a stamp cell.
# A number typed in prose about another page's rows is none of those, so it stood on the most-read
# page of the shelf until a hand read the two together (`20260909.151033`).
#
# WHAT COUNTS AS A GENERATED INDEX, derived rather than rostered: a living page saying `generated by`
# in its own header and holding table rows whose first cell is a link. Its derived reading is that
# row count, and the noun to look for is its own first column's header, lowercased -- `| Room |`
# gives `room`, so `N rooms` on a citing line is a restatement of a number the page already holds.
# The rule stays a declaration rather than a list, so a generated index added tomorrow arrives
# guarded, and this file never becomes a roster somebody must remember to edit.
#
# WHAT IT LEAVES ALONE, on purpose. A page may name the scale without spelling it -- the first-hour
# tutorial says "more than sixteen hundred" witnesses and sends the reader to the generated block
# for the exact count, which is the honest form and carries no integer to disagree with. Only a
# spelled integer beside the index's own noun is read, and only on a line that links the index.
xargs grep -lE 'generated by' < "$work/living.txt" 2>/dev/null > "$work/gen_candidates.txt" || true
: > "$work/generated.txt"
while IFS= read -r page; do
  [ -n "$page" ] || continue
  rows=$(grep -cE '^\| *\[' "$page" || true)
  [ "$rows" -gt 0 ] || continue
  noun=$(awk -F'|' '/^\|/ { c = $2; gsub(/[ \t`*]/, "", c); if (c ~ /^[A-Za-z]+$/) { print tolower(c); exit } }' "$page")
  [ -n "$noun" ] || continue
  printf '%s\t%s\t%s\n' "$page" "$rows" "$noun" >> "$work/generated.txt"
done < "$work/gen_candidates.txt"
echo "generated_indexes=$(wc -l < "$work/generated.txt" | tr -d ' ')"

# THIS PASS TOLERATES NOTHING EITHER. `awk` producing output has no found-nothing exit, so a
# non-zero status here is a failure rather than an answer, and `set -eu` carries the refusal.
xargs awk -v GEN="$work/generated.txt" < "$work/living.txt" '
  function fold(p,   n, part, i, top, out, s) {
    n = split(p, part, "/")
    top = 0
    for (i = 1; i <= n; i++) {
      if (part[i] == "" || part[i] == ".") continue
      if (part[i] == "..") { if (top > 0) top--; continue }
      out[++top] = part[i]
    }
    s = ""
    for (i = 1; i <= top; i++) s = s (i > 1 ? "/" : "") out[i]
    return s
  }
  BEGIN {
    while ((getline line < GEN) > 0) {
      split(line, f, "\t")
      rows[f[1]] = f[2]
      noun[f[1]] = f[3]
    }
    close(GEN)
  }
  FNR == 1 { dir = FILENAME; if (!sub(/\/[^\/]*$/, "/", dir)) dir = "" }
  {
    rest = $0
    while (match(rest, /\]\([^)]+\)/)) {
      target = substr(rest, RSTART + 2, RLENGTH - 3)
      rest = substr(rest, RSTART + RLENGTH)
      sub(/#.*$/, "", target)
      if (target ~ /^[A-Za-z][A-Za-z0-9+.-]*:/) continue
      named = fold(substr(target, 1, 1) == "/" ? substr(target, 2) : dir target)
      if (!(named in rows)) continue
      tail = $0
      while (match(tail, /[0-9]+/)) {
        spelled = substr(tail, RSTART, RLENGTH)
        tail = substr(tail, RSTART + RLENGTH)
        probe = tolower(tail)
        sub(/^[ \t*`]+/, "", probe)
        if (probe !~ ("^" noun[named] "s?([^a-z]|$)")) continue
        if (spelled + 0 == rows[named] + 0) continue
        key = FILENAME "|" spelled "|" named
        if (key in said) continue
        said[key] = 1
        printf "%s: says %s %ss, and %s derives %s\n", FILENAME, spelled, noun[named], named, rows[named]
      }
    }
  }' > "$work/gencounts.txt"
generated_count_disagrees=$(wc -l < "$work/gencounts.txt" | tr -d ' ')
echo "generated_count_disagrees=$generated_count_disagrees"

# --- a count spelled in a declared index's own TITLE ----------------------------------------------
# THE FAULT, and this shelf has now met it four times. A crushed index is the page a reader trusts
# instead of walking the room, so a count on it is the page's strongest claim. Three of the four
# firings were repaired by hand, each the same way, and each repair wrote down what it learned:
#
#   docs-geode/README.md   -- three sentences said `ten rooms` while the table listed twelve, from
#                             the very commit that added the twelfth, and stood sixteen days. Its
#                             own repair line now reads *the count lives in the table*.
#   docs-geode/press/README.md -- said `three` for two weeks while four pieces stood, and argued the
#                             point at length in the paragraph carrying the wrong number.
#   docs-geode/etc/README.md -- named eleven neighbors while twelve stood, so the list became the
#                             `**Neighbors:**` key that tools/r/room_enumeration_witness.rish reads.
#
# All three moved the count OUT of prose and into a structure something derives. None of them looked
# at a title. `docs-geode/blog/README.md` opened `# Blog -- one piece stands`, true on the day it
# was typed and false on the day a second piece lands -- the fourth instance, standing in the one
# place the three repairs never reached. A lantern that fires twice becomes a loom; this one fired
# three times.
#
# WHAT IS READ, and why the FORM rather than the VALUE. A title is a NAME, and the mark law is
# already explicit about a total inside one: *Count, rather than number -- a total carried inside a
# name stays at whatever it was the day somebody typed it* (.claude/rules/stamp-and-name.md, and
# foundations/20260905-154954_the-clock-and-the-mark.md, which measured nine ladders whose announced
# lengths outran what they reached). So the reading refuses the form rather than checking the
# number, and that choice is what makes it safe: a page's BODY quotes its own past counts -- press/'s
# repair paragraph says *this page said three for two weeks* -- and a value check cannot tell that
# testimony from a live claim. A title holds no such quotation, which is why the title is the one
# line where refusing the form is both possible and right.
#
# WHO IS READ: the declared indexes above, and nobody else. A page whose whole promise is to tell
# the truth about a room's membership is the page that owes its name to a derived count. Four stand
# today; a fifth arrives guarded on the day it declares itself, like every other reading here.
#
# WHAT A COUNT IS: a cardinal numeral or number word, standing as its own word, FOLLOWED by an
# alphabetic word -- `one piece`, `12 rooms`. A number at a title's end is an identifier rather than
# a census (`Kyri 6`), so it passes free. The named answer to a refusal is the one all three repairs
# above already took: move the count into the table, where the member walk at the top of this file
# reads it against the room on disk every lap.
#
# IT CAN REFUSE A NUMBER THAT IS NOT A COUNT, and that trade is chosen rather than overlooked. A
# declared index titled `Press 2026 index` would be held, since a year followed by a word reads the
# same as a census from here. The refusal names the page and its repair in one line, so the cost of
# being wrong is one sentence a hand reads -- against three repairs this shelf has already paid for
# being blind. On a population of four pages, over-refusing is the cheaper direction.
: > "$work/titlecounts.txt"
while read -r page room depth; do
  title=$(head -1 "$page")
  case "$title" in '#'*) ;; *) continue ;; esac
  printf '%s\n' "$title" \
    | grep -oiE '(^|[^a-z0-9-])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|[0-9]+)[ ]+[a-z]' \
    | head -1 | grep -q . || continue
  printf '%s: the title spells a count of %s -- move it into the table, which the member walk reads\n' \
    "$page" "$room" >> "$work/titlecounts.txt"
done < "$work/declared.txt"
title_count_claimed=$(wc -l < "$work/titlecounts.txt" | tr -d ' ')
echo "title_count_claimed=$title_count_claimed"

# --- a title spelling a count of the page's OWN numbered sections ---------------------------------
# THE SUBJECT, and why it is a separate strand. The reading above refuses a count in a declared
# index's title without looking at its value, and that choice is right THERE: an index's basis is a
# room on disk, which grows under other hands, so any number in the name is a forecast. A page
# counting its own numbered sections is the opposite case. Its basis is INSIDE it -- the sections it
# holds, in the same file, moved only by the hand editing that page -- so the number can be CHECKED
# rather than banned, and a true count keeps its place in a title that reads well.
#
# This is the gap the head named by name and left open. `docs-geode/demos/README.md` opens
# `# Demos -- five checks you can run` over five sections headed `## 1.` through `## 5.`, true since
# it was written and held by nothing. A sixth check lands and the title is wrong with no line moving
# in any file a standing guard reads.
#
# WHAT IS READ, derived rather than rostered: a living page whose first line is a `# ` title, whose
# title spells a cardinal followed by an alphabetic word, and which holds at least one top-level
# section headed by an integer -- `## 1.`, `## 2 `, `## 3)`. Its derived reading is HOW MANY such
# sections the page holds, never the highest number one of them wears: a page whose sections run
# 1, 2, 3, 5 holds four checks, and whether its numbering skipped a step is a different subject
# wanting a different repair.
#
# WHAT IT LEAVES ALONE. A page with no numbered sections supplies no basis, so it is not read here
# at all. A number at a title's END is an identifier rather than a census, exactly as above. And an
# undeclared page counting a ROOM is still unread by anything -- named under *what is not proven*.
#
# THE POPULATION IS ONE, said plainly rather than dressed up. Measured `20260911.083000` across every
# living non-testimony Markdown page: EIGHT hold numbered top-level sections, and exactly one of
# those spells a count in its title. The reading is green over all of it today. A guard is worth what
# it catches on the lap the fault arrives, and this one is standing before the sixth check lands.
: > "$work/sectioncounts.txt"
while IFS= read -r page; do
  [ -f "$page" ] || continue
  title=$(head -1 "$page")
  case "$title" in '#'[!#]*) ;; *) continue ;; esac
  sections=$(grep -cE '^## *[0-9]+[.) ]' "$page" || true)
  [ "${sections:-0}" -gt 0 ] || continue
  word=$(printf '%s\n' "$title" \
    | grep -oiE '(^|[^a-z0-9-])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|[0-9]+)[ ]+[a-z]' \
    | head -1 | sed 's/^[^A-Za-z0-9]*//; s/[ ][A-Za-z]$//' | tr 'A-Z' 'a-z')
  [ -n "$word" ] || continue
  case "$word" in
    one) spelled=1 ;; two) spelled=2 ;; three) spelled=3 ;; four) spelled=4 ;;
    five) spelled=5 ;; six) spelled=6 ;; seven) spelled=7 ;; eight) spelled=8 ;;
    nine) spelled=9 ;; ten) spelled=10 ;; eleven) spelled=11 ;; twelve) spelled=12 ;;
    thirteen) spelled=13 ;; fourteen) spelled=14 ;; fifteen) spelled=15 ;; sixteen) spelled=16 ;;
    seventeen) spelled=17 ;; eighteen) spelled=18 ;; nineteen) spelled=19 ;; twenty) spelled=20 ;;
    *[!0-9]*) continue ;;
    *) spelled=$word ;;
  esac
  [ "$spelled" -eq "$sections" ] && continue
  printf '%s: the title says %s, and the page holds %s numbered sections\n' \
    "$page" "$spelled" "$sections" >> "$work/sectioncounts.txt"
done < "$work/living.txt"
section_count_disagrees=$(wc -l < "$work/sectioncounts.txt" | tr -d ' ')
echo "section_count_disagrees=$section_count_disagrees"

[ "$unlisted" -eq 0 ] || sed 's/^/unlisted: /' "$work/unlisted.txt"
[ "$rooms_missing" -eq 0 ] || sed 's/^/room_missing: /' "$work/rooms_missing.txt"
[ "$rooms_oversize" -eq 0 ] || sed 's/^/room_oversize: /' "$work/rooms_oversize.txt"
[ "$doors_missing" -eq 0 ] || sed 's/^/door_missing: /' "$work/doors_missing.txt"
[ "$stamp_disagrees" -eq 0 ] || sed 's/^/stamp: /' "$work/stamps.txt"
[ "$unbacked" -eq 0 ] || sed 's/^/unbacked: /' "$work/unbacked.txt"
[ "$generated_count_disagrees" -eq 0 ] || sed 's/^/generated_count: /' "$work/gencounts.txt"
[ "$title_count_claimed" -eq 0 ] || sed 's/^/title_count: /' "$work/titlecounts.txt"
[ "$section_count_disagrees" -eq 0 ] || sed 's/^/section_count: /' "$work/sectioncounts.txt"

if [ "$unlisted" -eq 0 ] && [ "$rooms_missing" -eq 0 ] && [ "$rooms_oversize" -eq 0 ] \
   && [ "$doors_missing" -eq 0 ] && [ "$generated_count_disagrees" -eq 0 ] \
   && [ "$title_count_claimed" -eq 0 ] && [ "$section_count_disagrees" -eq 0 ] \
   && [ "$stamp_disagrees" -eq 0 ] && [ "$unbacked" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=index_disagrees"
  echo "refused: a crushed index disagrees with the room it names -- read the lines above" >&2
fi
