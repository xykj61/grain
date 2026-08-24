#!/bin/sh
# tools/fixtures/mycelium_map_roster_scan.sh -- the map a reader enters Mycelium by reaches every module.
#
# WHY. One directory over, caravan/LADDER.md carried a table headed "The Ladder" that named 73
# modules while 110 stood beside it, and no meter had ever read it (REDS %184). The transferable
# rule was written down that lap: a roster listing what a PROGRAM runs gets checked, because a
# missing entry breaks a run; a roster listing what a READER should find gets checked by nobody,
# because a missing entry breaks only understanding, and understanding fails quietly.
#
# Mycelium's front page answers the same problem a better way, and that is what this guard is
# shaped around. Rather than listing all ninety-eight modules, mycelium/README.md names 31 base
# modules in its nine-family map and publishes a SUFFIX TABLE -- `_bron`, `_true`, `_knot`,
# `_fixture_gen`, `_bench` -- so a companion module is reachable by rule instead of by row. That
# rule reaches 95 of the 98 on its own, which is why the page stayed short and stayed honest.
#
# A rule can go short the same way a list can, and more quietly: a module whose name wears no
# seated suffix is invisible to both the map and the rule at once.
#
# WHAT IT READS. Three sets, all three from the tree rather than from this file.
#
#   modules   -- every mycelium/*.rye a reader sees in the directory, files AND symlinks. The three
#                seam symlinks into ../tally/ are modules a reader meets in `ls` and the README
#                already names one of them by that description, so counting them is the honest
#                reading of what the page owes an account of.
#   bases     -- every map entry `[`<name>.rye`](<name>.rye)`, display text and target agreeing
#   suffixes  -- every row of the README's own suffix table, shape `| `_xxx` | ... |`
#
# READING THE SUFFIXES FROM THE PAGE is the load-bearing choice. The rule belongs to the README, so
# the guard asks the README what the rule is rather than reciting a copy that can drift from it.
# Add a suffix to the table and its companions are honored on the next run; drop one and every
# module wearing it reads unreachable, loudly, which is the correct failure.
#
#   unreachable -- a module on disk that is neither a named base nor <named base><seated suffix>.
#                  HELD AT ZERO.
#   phantom     -- a map entry naming a module absent from the directory. HELD AT ZERO.
#   duplicate   -- one module named by two map entries, which may come to disagree. HELD AT ZERO.
#   mismatched  -- an entry whose display text and link target name different modules. HELD AT ZERO.
#   unused_suffix -- a seated suffix no module wears. REPORTED, never gated: a rule may be written
#                  for a shape whose first companion is still to come.
#
# Derivation is ONE suffix deep on purpose, and it costs nothing: `cord_knot_bench.rye` resolves
# because `cord_knot.rye` is itself a named base. A chain that had to be walked would let an
# unnamed middle link hide behind a named end.
#
# WHAT IT DOES NOT REACH, said plainly. Whether a map entry's description is TRUE -- that sentence
# is prose and no grep reads it. Whether a companion actually does what its suffix promises; the
# module's own witness proves the module, and this proves the roster reaches it.
#
# USAGE
#   sh tools/fixtures/mycelium_map_roster_scan.sh              # census -- key=value lines
#   sh tools/fixtures/mycelium_map_roster_scan.sh list         # every fault, one per line
#   sh tools/fixtures/mycelium_map_roster_scan.sh census DIR   # read DIR rather than mycelium/
#
# Driven by tools/m/mycelium_map_roster_witness.rish. Proven both ways by
# mycelium_map_roster_control.sh, which builds real directories in a throwaway pen.
# Run from the repository root.
set -eu

MODE="${1:-census}"
DIR="${2:-mycelium}"
PAGE="$DIR/README.md"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM

# The modules a reader sees. -type f alone would drop the seam symlinks, which are exactly the
# modules most likely to go unnamed, so both file kinds are read.
find "$DIR" -maxdepth 1 -name '*.rye' \( -type f -o -type l \) 2>/dev/null \
  | sed 's|.*/||; s|\.rye$||' | sort > "$TMP/modules"

if [ -f "$PAGE" ]; then
  # A map entry links a module by bare name. A cross-directory link carries a slash and is read
  # past, since ../tally/kumara.rye is a citation of another room rather than a roster entry.
  grep -oE '\[`[a-z0-9_]+\.rye`\]\([a-z0-9_]+\.rye\)' "$PAGE" \
    | sed -E 's/\[`([a-z0-9_]+)\.rye`\]\(([a-z0-9_]+)\.rye\)/\1 \2/' > "$TMP/pairs"
  # The suffix table's own rows. A leading underscore is what marks a suffix row apart from every
  # other single-code-span table in the page.
  grep -oE '^\| `_[a-z_]+` \|' "$PAGE" | sed -E 's/^\| `(_[a-z_]+)` \|/\1/' | sort -u > "$TMP/suffixes"
else
  : > "$TMP/pairs"
  : > "$TMP/suffixes"
fi

# An entry whose display text and target disagree names two modules and is trusted for neither.
awk '$1 != $2 { print $1 " " $2 }' "$TMP/pairs" > "$TMP/mismatched"
awk '$1 == $2 { print $1 }' "$TMP/pairs" | sort > "$TMP/bases_all"
sort -u "$TMP/bases_all" > "$TMP/bases"

comm -13 "$TMP/modules" "$TMP/bases" > "$TMP/phantom"
uniq -d "$TMP/bases_all" > "$TMP/duplicate"

# Reachability: named directly, or a named base wearing exactly one seated suffix.
awk -v sfxfile="$TMP/suffixes" '
  BEGIN {
    ns = 0
    while ((getline s < sfxfile) > 0) { if (s != "") { sfx[++ns] = s } }
    close(sfxfile)
  }
  NR == FNR { base[$0] = 1; next }
  {
    m = $0
    if (m in base) { next }
    for (i = 1; i <= ns; i++) {
      s = sfx[i]
      if (length(m) > length(s) && substr(m, length(m) - length(s) + 1) == s) {
        b = substr(m, 1, length(m) - length(s))
        if (b in base) { next }
      }
    }
    print m
  }
' "$TMP/bases" "$TMP/modules" > "$TMP/unreachable"

# A suffix no module wears -- reported so a rule written ahead of its first companion is visible.
awk -v modfile="$TMP/modules" '
  BEGIN { nm = 0; while ((getline m < modfile) > 0) { if (m != "") { mod[++nm] = m } } close(modfile) }
  {
    s = $0
    worn = 0
    for (i = 1; i <= nm; i++) {
      m = mod[i]
      if (length(m) > length(s) && substr(m, length(m) - length(s) + 1) == s) { worn = 1 }
    }
    if (!worn) { print s }
  }
' "$TMP/suffixes" > "$TMP/unused_suffix"

n_modules=$(wc -l < "$TMP/modules" | tr -d ' ')
n_bases=$(wc -l < "$TMP/bases" | tr -d ' ')
n_suffixes=$(wc -l < "$TMP/suffixes" | tr -d ' ')
n_unreachable=$(wc -l < "$TMP/unreachable" | tr -d ' ')
n_phantom=$(wc -l < "$TMP/phantom" | tr -d ' ')
n_duplicate=$(wc -l < "$TMP/duplicate" | tr -d ' ')
n_mismatched=$(wc -l < "$TMP/mismatched" | tr -d ' ')
n_unused=$(wc -l < "$TMP/unused_suffix" | tr -d ' ')

if [ "$MODE" = list ]; then
  while IFS= read -r m; do [ -n "$m" ] && echo "unreachable: $DIR/$m.rye is neither named in $PAGE nor a named base wearing a seated suffix"; done < "$TMP/unreachable"
  while IFS= read -r m; do [ -n "$m" ] && echo "phantom: $PAGE names $m.rye, which is absent from $DIR/"; done < "$TMP/phantom"
  while IFS= read -r m; do [ -n "$m" ] && echo "duplicate: $m.rye is named by more than one map entry in $PAGE"; done < "$TMP/duplicate"
  while IFS= read -r m; do [ -n "$m" ] && echo "mismatched: an entry shows $m"; done < "$TMP/mismatched"
  while IFS= read -r s; do [ -n "$s" ] && echo "unused_suffix: the table seats $s and no module in $DIR/ wears it"; done < "$TMP/unused_suffix"
fi

echo "page=$PAGE"
echo "modules_on_disk=$n_modules"
echo "bases_named=$n_bases"
echo "suffixes_seated=$n_suffixes"
echo "unreachable=$n_unreachable"
echo "phantom=$n_phantom"
echo "duplicate_entries=$n_duplicate"
echo "mismatched_entries=$n_mismatched"
echo "unused_suffix=$n_unused"

# A reading over an empty directory finds no fault and would report clean while measuring nothing,
# so the corpus size is published beside the verdict (REDS %170).
if [ "$n_modules" -eq 0 ]; then
  echo "reaches_all=no"
  echo "verdict=empty_corpus"
  exit 1
fi

if [ "$n_unreachable" -eq 0 ] && [ "$n_phantom" -eq 0 ] && [ "$n_duplicate" -eq 0 ] && [ "$n_mismatched" -eq 0 ]; then
  echo "reaches_all=yes"
  echo "verdict=ok"
  exit 0
fi
echo "reaches_all=no"
echo "verdict=map_short"
exit 1
