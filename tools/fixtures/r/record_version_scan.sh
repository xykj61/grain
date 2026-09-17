#!/bin/sh
# tools/fixtures/r/record_version_scan.sh -- a record header names its version chronologically.
#
# WHY. `context/specs/rye-versioning-style.md` settled this tree's versioning in June: versions
# here are CHRONOLOGICAL, `YYYYMMDD.HHMMSS`, refusing semantic versioning by name and citing
# Hickey's *Spec-ulation* -- names endure, software grows by accretion, and a counted number says
# nothing about why. REDS `%765` found that ruling walked past: `mantra-weave-v3` was written, a law
# page blessed it from the wrong rule, and Keaton caught it twice. The repair moved one family to
# `mantra-weave-20260916.101910` and audited the rest -- and the audit's remainder is a MOLT wanting
# Keaton's word, since every counted header opens a store this tree already wrote and elder headers
# keep their names forever.
#
# So the row stands OPEN on a population NOTHING READS, and the population GROWS. Measured by
# THIS classifier, run in a detached worktree at each commit rather than by a grep: **16** families
# on `20260801`, **30** on `20260901`, **30** on `20260916`, **32** on `20260917`. The two that
# arrived in that last day are `rye-key-library` and `rye-key-cache`, written by a peer lane the day
# AFTER `%765` was found, repaired and audited -- which is the case for a ratchet, measured rather
# than argued. Chronological families read **0** at all three elder stamps and **1** today.
#
# WHAT A RECORD VERSION IS, and the discriminator is the whole instrument. A version string is a
# string reaching STORED BYTES as a format or header field. The naive grep for `-v<N>` cannot tell
# one from a string that merely looks like one, and this tree holds three of those: a test file's
# CONTENT in `mantra/recall_two_way_sync.rye`, a witness plaintext in `mand/mand_ring1_witness.rye`,
# and a fixture signature VALUE in `mantra/src/receipt_offer_witness.rye`. So the row's own figure
# is a grep's figure, and this reading answers it classified. Four site classes, each decided by
# reading the line rather than judging it:
#
#   declared   a constant whose own name ends `_format`, or is `format_tag` -- the header a module
#              publishes for its record
#   written    the literal reaches an output buffer: `append_kv(out, &off, "format", X)`, or an
#              `appendSlice` of the header line itself
#   compared   the literal is checked against a parsed field -- `std.mem.eql(u8, format.?, X)`,
#              `header`, `fmt`, `kv.val`, `kv.rest`
#   domain     a constant whose name ends `_domain` -- a domain-separation tag hashed into a
#              signature. REPORTED APART rather than folded in: it is a compatibility contract in
#              stored bytes like the others, and it is never a record HEADER, so a lane deciding
#              the molt should see it as its own question.
#
# Anything else carrying a version-shaped literal is `unclassified` and counted as NO record
# version at all -- printed by name, so a genuine header this reading cannot see is visible rather
# than silently absent.
#
# THE RATCHET, under a ceiling that only falls: `counted_families`. A family is the compatibility
# unit -- one name a store's bytes carry forever -- so a family is what a molt moves and what a new
# arrival adds. It RATCHETS rather than walls because the standing 39 are stored bytes that accrete
# never breaks, and a wall would red eight ships for a molt Keaton has not called. What it does
# catch is the next counted family, on the lap it is written.
#
# REPORTED, NEVER GATED: `counted_sites`, `chronological_families` and `chronological_sites` (so a
# molt is visible as a movement rather than only as a lowered ceiling), `domain_families`, and
# `unclassified` with each site named.
#
# WHAT IT DOES NOT REACH. Whether a chronological stamp is the RIGHT stamp. A record header built
# at runtime from pieces rather than written as one literal. Every language beside Rye -- Rishi and
# Glow write records too, and neither is read here. And `tools/fixtures/` is read PAST by name: a
# pen plant must keep the shape it plants, and `amphora_bounds_plants` holds `amphora-v1` and
# `amphora-v2` on purpose.
#
# Pen: tools/fixtures/r/record_version_control.sh. Run from the repository root.
#
# Usage: sh tools/fixtures/r/record_version_scan.sh [--list]

set -f

CEILING=32

list=no
[ "$1" = "--list" ] && list=yes

files=$(git ls-files '*.rye' 2>/dev/null | grep -v '^tools/fixtures/' | grep -v '^vendor/' | grep -v '^gratitude/')
if [ -z "$files" ]; then
  echo "verdict=unreadable -- no tracked .rye sources outside the fixtures room"
  exit 2
fi

# One awk pass per tree. A line is stripped of its `//` comment before classification, so a version
# named in prose never counts; the strip is naive about a `//` inside a literal and says so, which
# lands such a line in `unclassified` -- the safe direction, since an unclassified site is PRINTED.
printf '%s\n' $files | xargs awk '
  function strip(s,   i, out, inq, ch, prev) {
    out = ""; inq = 0; prev = ""
    for (i = 1; i <= length(s); i++) {
      ch = substr(s, i, 1)
      if (inq == 0 && ch == "/" && prev == "/") { out = substr(out, 1, length(out) - 1); break }
      if (ch == "\"" && prev != "\\") inq = 1 - inq
      out = out ch
      prev = ch
    }
    return out
  }
  {
    line = strip($0)
    # A header written straight into a buffer carries its own newline -- `appendSlice(allocator,
    # "mantra-weave-20260916.101910\n")` -- so the escape is folded away before the literal is
    # read. Without this the one chronological family is seen at its COMPARE site and missed at
    # the WRITE, which is the site that puts bytes in a store.
    gsub(/\\n"/, "\"", line)
    rest = line
    while (match(rest, /"[a-z][a-z0-9.-]*"/)) {
      lit = substr(rest, RSTART + 1, RLENGTH - 2)
      rest = substr(rest, RSTART + RLENGTH)

      kind = ""
      if (lit ~ /-v[0-9]+$/)                    { kind = "counted";       fam = lit; sub(/-v[0-9]+$/, "", fam) }
      else if (lit ~ /-[0-9]{8}\.[0-9]{6}$/)    { kind = "chronological"; fam = lit; sub(/-[0-9]{8}\.[0-9]{6}$/, "", fam) }
      if (kind == "") continue

      cls = "unclassified"
      if (line ~ /(^|[^a-zA-Z0-9_])const[ \t]+[a-z0-9_]*_domain[ \t:]/)                          cls = "domain"
      else if (line ~ /(^|[^a-zA-Z0-9_])const[ \t]+([a-z0-9_]*_format|format_tag)[ \t:]/)        cls = "declared"
      else if (line ~ /append_kv\(/ && line ~ /"format"/)                                        cls = "written"
      else if (line ~ /appendSlice\(/)                                                           cls = "written"
      else if (line ~ /std\.mem\.eql\(/ && line ~ /(format|header|fmt|\.val|\.rest)/)            cls = "compared"

      printf "%s\t%s\t%s\t%s\t%s:%d\n", cls, kind, fam, lit, FILENAME, FNR
    }
  }
' > .lap/record_version_sites.txt

sites=.lap/record_version_sites.txt
if [ ! -s "$sites" ]; then
  echo "verdict=unreadable -- the classifier read $(printf '%s\n' $files | wc -l | tr -d ' ') sources and found no version-shaped literal at all"
  exit 2
fi

# Counted in awk rather than by `grep -E` on a tab: `\t` inside a bracket-free ERE is a GNU
# extension and a portable shell reads it as a stray backslash, which a first draft of this scan
# proved by answering a comfortable zero on every reading at once.
eval "$(awk -F'\t' '
  $1 == "declared" || $1 == "written" || $1 == "compared" {
    if ($2 == "counted")       { cs++; cf[$3] = 1 }
    else                       { hs++; hf[$3] = 1 }
  }
  $1 == "domain"       { df[$3] = 1 }
  $1 == "unclassified" { un++ }
  END {
    for (k in cf) nc++
    for (k in hf) nh++
    for (k in df) nd++
    printf "counted_sites=%d counted_families=%d chrono_sites=%d chrono_families=%d domain_families=%d unclassified=%d\n", cs, nc + 0, hs, nh + 0, nd + 0, un
  }
' "$sites")"

if [ "$list" = yes ]; then
  sort "$sites" | while IFS='	' read -r cls kind fam lit site; do
    echo "$cls $kind $lit at $site"
  done
fi

awk -F'\t' '$1 == "unclassified" { print $4 "\t" $5 }' "$sites" | while IFS='	' read -r lit site; do
  echo "unclassified: $lit at $site reaches no format field this reading can see"
done

echo "counted_families=$counted_families ceiling=$CEILING"
echo "counted_sites=$counted_sites"
echo "chronological_families=$chrono_families chronological_sites=$chrono_sites"
echo "domain_families=$domain_families"
echo "unclassified=$unclassified"

if [ "$counted_families" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling -- a new counted record family stands; versions here are chronological (context/specs/rye-versioning-style.md)"
  exit 1
fi
echo "verdict=counted_families_under_ceiling"
