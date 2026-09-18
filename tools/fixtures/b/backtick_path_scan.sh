#!/bin/sh
# tools/fixtures/b/backtick_path_scan.sh -- a backticked path is a promise too, and no guard read it.
#
# WHY. This tree holds both halves of a Markdown link. The target promise -- *this opens* -- is held
# by tools/l/living_docs_lint.rish, tools/fixtures/t/tracked_link_scan.sh and
# tools/fixtures/l/link_touch_scan.sh. The text promise -- *this is where it lives* -- is walled at
# zero by tools/fixtures/l/link_text_promise_scan.sh. A path written in bare backticks with NO link
# around it is read by none of them, and it is the shape this tree reaches for most: a Kin line, a
# Machinery line, a table cell, a sentence naming the witness that binds a claim.
#
# The recognition rule is already this tree's own. tools/hooks/commit-msg refuses a commit body that
# cites a path the tree does not carry, reading "only what looks like one of this tree's own paths
# (a slash, and an extension this tree writes) and asks the filesystem" (.claude/rules/git-signing.md).
# So the same promise is checked where it can never be edited, and unchecked where it can.
#
# WHAT IS READ, and what is deliberately read past.
#   A span counts only when it LOOKS like a path a reader would copy: it holds a slash, ends in an
#   extension this tree writes, and carries no space, fragment, parenthesis or glob character. A
#   prose phrase in backticks is not a promise about a path.
#   A link's ANCHOR TEXT is removed before the read. That half is link_text_promise's reading, held
#   at zero already, and two guards counting one span would price one fault twice.
#   A PLACEHOLDER is an illustration rather than a citation, and the mark law asks for exactly this
#   shape -- "Illustrate with placeholders, cite only what exists" (.claude/rules/stamp-and-name.md).
#   A span carrying YYYY, MM, DD, HH, SS runs, an angle-bracket slot, a shell expansion or a run of
#   N is read past and counted apart.
#   THE TWO APPEND-ONLY LEDGERS are read past by name: construction/REDS.md and
#   construction/CHECKPOINTS.md. A row records what was true when it was written, and the ledger's
#   own first law is that a row is never edited. Their fold shelves live under archive/ and are
#   already testimony by room.
#
# THREE SPELLINGS ARE HONEST, and a span reaching the tree by none of them is the broken promise.
#   ROOT-relative, the spelling a grep from the repository root answers.
#   PAGE-relative, the spelling a link beside it would use.
#   ROOM-relative, the spelling a page writes about its own room -- classical-vedic-astrology's
#   reading template names `studies/life-frame/...` from inside templates/, and the same page links
#   `../studies/life-frame/...` one line above. Both are honest to a reader standing in that room.
#   Reading only the first two counted 60 of that one page's cells as broken promises.
#
# Resolution is against the TRACKED tree, never the filesystem, for the reason tracked_link_scan
# gives: an untracked symlink on one pier answers a question a fresh clone answers differently.
#
# WHAT IS GATED. Living pages, as a ratchet under a ceiling that only ever falls. A ratchet rather
# than a wall because the standing population is large and every hit wants the lane that owns its
# page: a citation of context/TAME_STYLE.md wants the TAME room, one of work-in-progress/ wants the
# room breached to crux. A wall here would red on ordinary work, and a wall somebody turns off is
# worth less than a ceiling that falls.
#
# WHAT IS REPORTED, never gated. The same reading across dated testimony -- a page whose own
# basename carries a one-clock stamp, and every date/, archive/ or yonder/ shelf. Accrete-never-break:
# testimony keeps every word it wrote, and a stale reference there is resolved rather than rewritten
# (rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>). The placeholder count is
# reported too, so an empty exclusion and a large one read differently from outside.
#
# WHAT A GITIGNORE READING CANNOT SETTLE, measured rather than assumed. A room this tree holds
# untracked on purpose -- .lap/ for one lap's scratch, .gnupg-rye/ for a ship's own keyring --
# looked like a class worth counting apart, and git check-ignore cannot name it. This tree's
# .gitignore denies the root with `/*` and allows its own paths back one at a time, so
# `git check-ignore -v .lap/msg.txt` answers `.gitignore:8:/*` and so does
# `git check-ignore -v old/doc/spec/flw.txt`, a path belonging to another project entirely. The
# question "is this ignored" answers "is this allow-listed" on a deny-by-default tree, so the split
# was dropped and every such citation stays counted. A reader meets three genres in the listing and
# each wants the lane that owns its page: a room this tree renamed, a path in a teacher's own tree,
# and a file a tutorial asks its reader to write.
#
# A PAGE GOVERNING THIS CLASS MAY NOT SPELL AN INSTANCE OF IT, and the account announcing this scan
# proved so by reddening it: three example citations quoted as evidence took the reading 65 to 68.
# The scan is right to count them -- a meter reading for truth hears a sentence that must stay false
# exactly as it hears one asserting it, which .claude/rules/derived-spine.md already names one
# instrument over for its pen plants. So describe a broken citation in prose and leave the spelling
# to this scan's own listing. tools/hooks/commit-msg refuses a commit body the same way, for the
# same reason, and refused that round's body three times before it landed.
#
# WHAT THIS DOES NOT REACH. Markdown alone: .md and .mdc pages, so a backticked path standing in a
# .rish witness header, a .kyri roster comment or a .rye module head makes the same promise to the
# same reader and is read by nothing. That is a second population and a second lap; this one takes
# the room where the tree writes most of its prose.
#
# A backticked path inside a fenced code block is read like any other, so
# a usage line naming a script this tree lacks is counted -- which is the reading wanted. A path
# written without backticks is not read at all: a bare word in prose has no shape a scanner can
# trust, which is the same limit the commit-msg hook names for itself.
#
# USAGE
#   sh tools/fixtures/b/backtick_path_scan.sh
#   sh tools/fixtures/b/backtick_path_scan.sh --list     # name every living hit
#
# Driven by tools/b/backtick_path_witness.rish. Run from the repository root.

set -eu

# The root is WALKED from this script's own $0 rather than computed by depth arithmetic: a fold
# moving this script one directory deeper breaks a fixed reach in silence. The sibling fallback
# stays because tools/fixtures/b/backtick_path_control.sh copies this scan into a flat pen with no
# tree at all, where a walk that only refuses would refuse the control's own ground.
_here=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_root="$_here"
_steps=0
while [ ! -d "$_root/rishi/bin" ] || [ ! -d "$_root/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$_root" = "/" ] || [ -z "$_root" ]; then
    _root=""
    break
  fi
  _root=$(dirname "$_root")
done
if [ -n "$_root" ]; then
  _portable="$_root/tools/fixtures/s/shell_portable.sh"
else
  _portable="$_here/../s/shell_portable.sh"
fi
[ -f "$_portable" ] || { echo "$0: shell_portable.sh absent -- looked in a walked root and beside \$0" >&2; exit 2; }
. "$_portable"

# THE CEILING ONLY EVER FALLS. Seated at 65 on 20260917, the reading of the tree on the lap this
# scan landed: 65 living citations across 38 pages. Lowered to 64 on 20260918: context/QUIN.md's
# citation repointed to where the file actually folded, and three already-cut SHRED_PREP.md fossil
# paths de-backticked, since a fossil row's whole point is to name a path that no longer resolves.
# A later lap's own edits put the count back to 65 before this scan next ran (Grass's
# reverse-reading lane, `20260918`): `rye/README.md`'s own elder reference named
# `archive/ALMANAC.md` room-relative to itself, when the file it means lives at
# `rye-learning-process/archive/ALMANAC.md` -- the very spelling the SAME PAGE already uses two
# lines below for the same file. Repointed to match, which returns the count to 64; the ceiling
# holds there rather than falling further.
# Lower it in the same commit as any sweep.
ceiling="${BACKTICK_PATH_CEILING:-64}"
list=no
case "${1:-}" in
  --list) list=yes ;;
  "") ;;
  *) echo "verdict=bad_flag"; echo "refused: unknown flag ${1} -- this scan takes --list" >&2; exit 1 ;;
esac

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: run me from inside the repository" >&2; exit 1; }

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files > "$work/tracked.txt"
# vendor/, gratitude/ and seed/ are held or projected rather than authored here.
# Each page is handed to awk with a leading `./`. awk reads a bare argument as a VARIABLE ASSIGNMENT
# whenever the name left of an equals sign is a valid identifier, so a root-level page called
# `eq=1.md` would be read as a setting rather than opened -- no error, no hit, and the page passes
# in silence. A slash anywhere already defeats that reading, which is why only the root runs out of
# accident. The prefix is stripped back off inside the program, so every reported path stays the
# tracked spelling.
git ls-files '*.md' '*.mdc' \
  | grep -v '^vendor/' | grep -v '^gratitude/' | grep -v '^seed/' \
  | sed 's|^|./|' > "$work/pages.txt" || true

pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
[ "$pages" -gt 0 ] || { echo "pages=0"; echo "verdict=no_pages"; exit 1; }

# One awk per batch of pages, reading the tracked set once. The program lands in the pen rather
# than on stdin: xargs splits this roster into several batches, and `awk -f /dev/stdin` would be
# handed an exhausted stream from the second batch on -- which reads as an empty program, so most
# of the tree would pass in silence.
cat > "$work/read.awk" <<'AWK'
function norm(p,   i, c, parts, stack, n, out) {
  gsub(/\/+/, "/", p)
  c = split(p, parts, "/")
  n = 0
  for (i = 1; i <= c; i++) {
    if (parts[i] == "" || parts[i] == ".") continue
    if (parts[i] == "..") { if (n > 0) n--; continue }
    stack[++n] = parts[i]
  }
  out = ""
  for (i = 1; i <= n; i++) out = (out == "" ? stack[i] : out "/" stack[i])
  return out
}
function here(p) { return (p != "" && ((p in tracked) || (p in dirs))) }
# Testimony keeps every word it wrote: a stamped basename, or any dated / archived / deferred shelf.
function testimony(p,   b) {
  if (p ~ /(^|\/)(date|archive|yonder)\//) return 1
  b = p; sub(/^.*\//, "", b)
  return (b ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/)
}
# An illustration rather than a citation: the mark law asks for placeholders by name.
function placeholder(s) {
  return (s ~ /YYYY|MM\/|DD|HHMMSS|HH\/|NNN|<|\$\{|\$[A-Z_]/)
}
NR == FNR {
  tracked[$0] = 1
  d = $0
  while (sub(/\/[^\/]*$/, "", d)) dirs[d] = 1
  next
}
FNR == 1 {
  page = FILENAME; sub(/^\.\//, "", page)
  dir = page; if (!sub(/\/[^\/]*$/, "", dir)) dir = ""
  room = page; if (!sub(/\/.*$/, "", room)) room = ""
  # The two append-only ledgers: a row records what was true when it was written.
  ledger = (page == "construction/REDS.md" || page == "construction/CHECKPOINTS.md")
}
{
  if (ledger) next
  line = $0
  # A link's anchor text is link_text_promise's reading, held at zero already.
  gsub(/\[`[^`]*`\]\(/, "[ANCHOR](", line)
  while (match(line, /`[^`]+`/)) {
    s = substr(line, RSTART + 1, RLENGTH - 2)
    line = substr(line, RSTART + RLENGTH)
    if (s ~ /[ \t#*?(){},|]/) continue
    if (s ~ /^(https?:|mailto:|\/|!|~)/) continue
    if (s !~ /\//) continue
    if (s !~ /\.(md|mdc|rish|rye|sh|kyri|bron|brix|glow|awk|json|txt|nix|brush|myc|zig|py)$/) continue
    if (placeholder(s)) { print "placeholder\t" page "\t" s; continue }
    # Three honest spellings: root-relative, page-relative, room-relative.
    if (here(norm(s))) continue
    if (here(norm(dir "/" s))) continue
    if (room != "" && here(norm(room "/" s))) continue
    print (testimony(page) ? "testimony" : "living") "\t" page "\t" s
  }
}
AWK
xargs_lines "$work/pages.txt" awk -f "$work/read.awk" "$work/tracked.txt" > "$work/hits.txt"

living=$(awk -F'\t' '$1 == "living"' "$work/hits.txt" | wc -l | tr -d ' ')
testimony=$(awk -F'\t' '$1 == "testimony"' "$work/hits.txt" | wc -l | tr -d ' ')
placeholder=$(awk -F'\t' '$1 == "placeholder"' "$work/hits.txt" | wc -l | tr -d ' ')
living_pages=$(awk -F'\t' '$1 == "living" { print $2 }' "$work/hits.txt" | sort -u | wc -l | tr -d ' ')

if [ "$list" = yes ]; then
  awk -F'\t' '$1 == "living" { print "promise: " $2 " cites " $3 }' "$work/hits.txt" | sort
fi

echo "pages=$pages"
echo "living=$living"
echo "living_pages=$living_pages"
echo "testimony=$testimony"
echo "placeholder=$placeholder"
echo "ceiling=$ceiling"

if [ "$living" -gt "$ceiling" ]; then
  echo "ceiling_ok=no"
  echo "verdict=over_ceiling"
  echo "refused: $living living backticked paths name a file the tree does not carry, above the ceiling of $ceiling" >&2
  echo "refused: name them with  sh tools/fixtures/b/backtick_path_scan.sh --list" >&2
  exit 1
fi

echo "ceiling_ok=yes"
echo "verdict=ok"
