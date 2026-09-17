#!/bin/sh
# tools/fixtures/c/comment_path_scan.sh -- a backticked path in a program's comment is a promise too.
#
# WHY. tools/fixtures/b/backtick_path_scan.sh holds this promise for Markdown and named its own
# remainder on its face: a path in bare backticks standing in a .rish witness header, a .kyri roster
# comment or a .rye module head makes the same promise to the same reader and is read by nothing.
# This is that second population, and the card asked whether it wants one lap per language or one
# meter over every authored comment. One meter: the recognition rule is one rule, and a rule written
# twice is a rule two files may quietly come to disagree about.
#
# THE SIBLING ONE HOUSE OVER. tools/fixtures/c/comment_citation_scan.sh already reads Markdown LINK
# targets on these same comment lines, and reads a backticked span PAST by name -- "a backticked span
# illustrates syntax" is one of the four cases its own header lists. So the two guards are the target
# half and the anchor half of one promise, exactly as tools/fixtures/t/tracked_link_scan.sh and
# tools/fixtures/l/link_text_promise_scan.sh divide the same work for pages.
#
# WHAT IS READ. A tracked authored source, on a line whose first non-blank characters are its
# language's comment mark: `//` in .rye and .zig, `::` in .glow, `#` in .rish, .sh, .kyri, .bron and
# .brix. A span counts only when it LOOKS like a path a reader would copy -- it holds a slash, ends
# in an extension this tree writes, and carries no space, glob or punctuation a path would not.
#
# AN OWN-LINE COMMENT ONLY, and that bound is deliberate. Telling a trailing `#` from one inside a
# string wants parsing rather than scanning, which is the same limit tools/fixtures/s/shell_comment_ascii_scan.sh
# names for itself. A SYMLINK is read past for the reason tools/fixtures/c/comment_citation_scan.sh
# learned on 20260825: six symlinked doors read as eleven broken citations, and repairing them would
# have written through the links into six correct bodies.
#
# THE FOURTH GENRE, which is this reading's own finding. In a prose page a backticked path is nearly
# always a citation. In a scan or a control it is as often a description of a directory the script
# ITSELF BUILDS in a throwaway pen -- `sub/a.txt`, `room/armor.txt`, a pen's own README. Counting
# those as broken promises would be wrong, so they are told apart by a checkable question rather than
# by judgment: IS THE SPAN'S PARENT DIRECTORY ONE THIS TREE CARRIES? A span whose parent is tracked
# names a file that should be there and is missing. A span whose parent this tree has never carried
# names a room somewhere else -- a pen, or a teacher's own tree. Measured on the lap this landed,
# that question splits the population roughly in half.
#
# ITS HONEST LIMIT. The question reads whether a DIRECTORY exists, so a pen path whose parent happens
# to coincide with a real directory of this tree reads as a citation, and sits in the ratchet with
# everything else wanting a reader. A sharper split would need to know what each script creates,
# which is dataflow rather than scanning.
#
# A FIELD IS NOT A PATH. A header quoting its own output line -- a key, an equals sign and a path,
# or a shell expansion, or a label before the first slash -- is showing a reader what the program
# PRINTS. Such a span is read past. THIS SHARPENS THE REPORT RATHER THAN THE GATE, and the control
# asserts exactly that: a key=path has no tracked parent, so without this test it would be counted
# as a room somewhere else rather than as a broken promise. The gate does not move either way, and
# saying so is worth more than letting a reader assume the test is load-bearing for the refusal.
#
# A PLACEHOLDER is an illustration rather than a citation, and the mark law asks for exactly this
# shape (.claude/rules/stamp-and-name.md). A span carrying YYYY, MM, DD, HH, SS runs, an angle-bracket
# slot or a run of N is read past and counted apart.
#
# WHAT IS GATED. Living files, as a ratchet under a ceiling that only ever falls -- never a wall.
# Three genres stand inside the living count and each wants the lane that owns its file: an ELDER
# PRE-FOLD SPELLING a resolver quotes as its own input, since tools/t/tool_path_resolve.rish exists
# precisely because those spellings went stale; a DELIBERATE PHANTOM, since tools/fixtures/p/phantom_path_scan.sh
# names a path that must not exist; and a genuinely stale citation wanting repair. A wall would red
# the first two forever, and a wall somebody turns off is worth less than a ceiling that falls.
#
# A GUARD GOVERNING THIS CLASS MAY NOT SPELL AN INSTANCE OF IT. This header describes its genres in
# prose and leaves every spelling to the --list output, for the reason .claude/rules/derived-spine.md
# already gives one instrument over: a meter reading for truth hears a sentence that must stay false
# exactly as it hears one asserting it.
#
# WHAT IS REPORTED, never gated. The same reading over dated testimony, the pen genre, and the
# placeholder count, so an empty exclusion and a large one read differently from outside.
#
# THE ROOT IS WALKED to TRACKED sentinels. REDS %788 counts 189 tracked shell sources that walk to
# `rishi/bin`, a room holding only a built binary, so they refuse in a fresh clone before reading a
# file. This scan asks for tools/fixtures and construction, both of which a checkout of tracked bytes
# carries, and adds no instance to that sweep.
#
# USAGE
#   sh tools/fixtures/c/comment_path_scan.sh
#   sh tools/fixtures/c/comment_path_scan.sh --list     # name every living hit
#
# Driven by tools/c/comment_path_witness.rish. Run from the repository root.

set -eu

_here=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_root="$_here"
_steps=0
while [ ! -d "$_root/tools/fixtures" ] || [ ! -d "$_root/construction" ]; do
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

# THE CEILING ONLY EVER FALLS. Seated on 20260917 at the reading of the tree on the lap this scan
# landed. Lower it in the same commit as any sweep.
ceiling="${COMMENT_PATH_CEILING:-61}"
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

# A symlink's citations belong to its body, never to the door. git ls-files -s reports mode 120000
# for a symlink, so the roster is built from the staged modes rather than from a filesystem test.
git ls-files -s > "$work/staged.txt"
awk '$1 == "120000" { sub(/^[^\t]*\t/, ""); print }' "$work/staged.txt" > "$work/links.txt"

# vendor/, gratitude/ and seed/ are held or projected rather than authored here.
# Each source is handed to awk with a leading `./`: awk reads a bare argument as a VARIABLE
# ASSIGNMENT whenever the name left of an equals sign is a valid identifier, so a root-level file
# called `eq=1.sh` would be read as a setting rather than opened -- no error, no hit, and it passes
# in silence. The prefix is stripped back off inside the program, so every reported path stays the
# tracked spelling.
# An empty pattern file is read differently by different greps, so the symlink filter runs only
# when there is something to filter -- a portability trap rather than a style choice.
git ls-files '*.rye' '*.rish' '*.sh' '*.kyri' '*.bron' '*.glow' '*.brix' '*.zig' \
  | grep -v '^vendor/' | grep -v '^gratitude/' | grep -v '^seed/' > "$work/all.txt" || true
if [ -s "$work/links.txt" ]; then
  grep -vxF -f "$work/links.txt" "$work/all.txt" > "$work/kept.txt" || true
else
  cat "$work/all.txt" > "$work/kept.txt"
fi
sed 's|^|./|' "$work/kept.txt" > "$work/sources.txt"

sources=$(wc -l < "$work/sources.txt" | tr -d ' ')
[ "$sources" -gt 0 ] || { echo "sources=0"; echo "verdict=no_sources"; exit 1; }

# One awk per batch, reading the tracked set once per batch. The program lands in the pen rather than
# on stdin: xargs splits this roster into several batches, and `awk -f /dev/stdin` would be handed an
# exhausted stream from the second batch on -- an empty program, so most of the tree would pass in
# silence.
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
# Does this tree carry the room the span names? A parent the tree holds means a file that should be
# there; a parent it has never held means a room somewhere else -- a pen, or a teacher's own tree.
function room_held(p,   q) {
  q = norm(p)
  if (q == "") return 0
  if (q !~ /\//) return 1
  sub(/\/[^\/]*$/, "", q)
  return (q in dirs)
}
# Testimony keeps every word it wrote: a stamped basename, or any dated / archived / deferred shelf.
function testimony(p,   b) {
  if (p ~ /(^|\/)(date|archive|yonder)\//) return 1
  b = p; sub(/^.*\//, "", b)
  return (b ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/)
}
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
  if (page ~ /\.rye$/ || page ~ /\.zig$/) mark = "//"
  else if (page ~ /\.glow$/) mark = "::"
  else mark = "#"
  mlen = length(mark)
}
{
  line = $0
  sub(/^[ \t]+/, "", line)
  if (substr(line, 1, mlen) != mark) next
  while (match(line, /`[^`]+`/)) {
    s = substr(line, RSTART + 1, RLENGTH - 2)
    line = substr(line, RSTART + RLENGTH)
    if (s ~ /[ \t#*?(){},|]/) continue
    # A field a program prints, rather than a path a reader copies.
    if (s ~ /[=$]/) continue
    if (s ~ /^[^\/]*:/) continue
    if (s ~ /^(\/|!|~)/) continue
    if (s !~ /\//) continue
    if (s !~ /\.(md|mdc|rish|rye|sh|kyri|bron|brix|glow|awk|json|txt|nix|brush|myc|zig|py)$/) continue
    if (placeholder(s)) { print "placeholder\t" page "\t" s; continue }
    # Three honest spellings: root-relative, page-relative, room-relative.
    if (here(norm(s))) continue
    if (here(norm(dir "/" s))) continue
    if (room != "" && here(norm(room "/" s))) continue
    if (!(room_held(s) || room_held(dir "/" s) || (room != "" && room_held(room "/" s)))) {
      print "pen\t" page "\t" s
      continue
    }
    print (testimony(page) ? "testimony" : "living") "\t" page "\t" s
  }
}
AWK
xargs_lines "$work/sources.txt" awk -f "$work/read.awk" "$work/tracked.txt" > "$work/hits.txt"

living=$(awk -F'\t' '$1 == "living"' "$work/hits.txt" | wc -l | tr -d ' ')
testimony=$(awk -F'\t' '$1 == "testimony"' "$work/hits.txt" | wc -l | tr -d ' ')
pen=$(awk -F'\t' '$1 == "pen"' "$work/hits.txt" | wc -l | tr -d ' ')
placeholder=$(awk -F'\t' '$1 == "placeholder"' "$work/hits.txt" | wc -l | tr -d ' ')
living_files=$(awk -F'\t' '$1 == "living" { print $2 }' "$work/hits.txt" | sort -u | wc -l | tr -d ' ')
links=$(wc -l < "$work/links.txt" | tr -d ' ')

if [ "$list" = yes ]; then
  awk -F'\t' '$1 == "living" { print "promise: " $2 " cites " $3 }' "$work/hits.txt" | sort
fi

echo "sources=$sources"
echo "symlinks_read_past=$links"
echo "living=$living"
echo "living_files=$living_files"
echo "pen=$pen"
echo "testimony=$testimony"
echo "placeholder=$placeholder"
echo "ceiling=$ceiling"

if [ "$living" -gt "$ceiling" ]; then
  echo "ceiling_ok=no"
  echo "verdict=over_ceiling"
  echo "refused: $living living backticked paths in comments name a file the tree does not carry, above the ceiling of $ceiling" >&2
  echo "refused: name them with  sh tools/fixtures/c/comment_path_scan.sh --list" >&2
  exit 1
fi

echo "ceiling_ok=yes"
echo "verdict=ok"
