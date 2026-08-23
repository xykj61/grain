#!/bin/sh
# tools/fixtures/tool_path_repoint_scan.sh -- repoint LIVING files at the tools fold's new paths.
#
# WHY. The mark law resolves a stale reference rather than rewriting it, and that is right for
# dated testimony: 2,866 dated files name a `tools/<file>` path and each keeps every word it ever
# wrote. It is wrong for living code. A witness that runs `rishi/bin/rishi run tools/foo.rish`
# resolves nothing once `foo.rish` sits in `tools/f/` -- it simply fails. So living things are
# repointed and testimony is resolved, exactly as tools/fixtures/dated_path_repoint_scan.sh does
# for the `date/YYYYMMDD/` fold. This is that tool's sibling, for the fold of `tools/` itself.
#
# WHAT THE FOLD DID, so the map below reads as a measurement rather than as memory. Every flat
# entry of `tools/` moved: a `.rish`, `.sh`, or data file into `tools/<first sprig letter>/`, with
# `a` and `c` splitting one letter deeper because each stood over the 256 bound alone; and every
# `.rye` source into `tools/rye/`, together with the 24 crypto shims and the `enrich/` room those
# sources import by bare name. Zig refuses an import that escapes the root file's directory, so a
# bare-name `@import` is a directory relationship the language enforces and the whole Rye closure
# of `tools/` is one room by the compiler's own rule.
#
# WHAT IT CHANGES, AND NOTHING ELSE. Where a reference names a file that has moved, the matched
# text becomes the new path. Any `../` prefix is carried through untouched. A reference that still
# resolves is left alone -- `tools/fixtures/x.sh` and `tools/gen/y.rish` never moved, and their
# citations are not touched.
#
# Idempotent: a repointed path holds no bare `tools/<basename>` at the room root, so a second run
# changes nothing.
#
# THE MAP IS BUILT FROM THE TREE AS IT NOW STANDS. Every file at `tools/<room>/<basename>`, where
# the room is one or two letters or `rye`, names the flat path it used to answer to. The `enrich/`
# room moved whole, so `tools/enrich/<basename>` maps to `tools/rye/enrich/<basename>` beside it.
# No table of which letters split is written anywhere, which is the same property that lets
# tools/tool_path_resolve.rish compute an answer with no index.
#
# WHAT IS THE INSTRUMENT HERE, and it is one name. tools/t/tool_path_witness.rish must cite a
# `tools/` path that no longer stands, because proving the resolver recovers such a path requires
# having one; repointing that citation would leave the rung asserting that an already-correct path
# resolves, which is true and worthless (REDS %121). Every other file in the tree that names a
# `tools/` path is field, including the dated-path tools, whose own deliberately stale references
# point at `counsel/` rather than at `tools/`.
#
# USAGE
#   sh tools/fixtures/tool_path_repoint_scan.sh          # dry run -- reports, touches nothing
#   sh tools/fixtures/tool_path_repoint_scan.sh apply    # rewrite the living files
#
# Driven by tools/t/tool_path_repoint.rish; proven by tools/t/tool_path_repoint_witness.rish.
# Run from the repository root.

set -eu

mode="${1:-dry}"
room="${2:-tools}"


work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The map: every folded file names the flat path it used to answer to. A room is one or two
# letters, or `rye`; every subdirectory the room already held is a word of three characters or
# more, so no standing room can be mistaken for a fold room.
find "$room" -mindepth 2 -maxdepth 2 \( -type f -o -type l \) 2>/dev/null \
  | awk -F/ -v room="$room" '
      {
        r = $(NF - 1); base = $NF
        if (r !~ /^([a-z]|[a-z][a-z]|rye)$/) next
        print room "/" base "\t" $0
      }' | sort -u > "$work/map.tsv"

# The enrich room moved whole, under tools/rye/, so its own files map one level across.
find "$room/rye/enrich" -maxdepth 1 \( -type f -o -type l \) 2>/dev/null \
  | awk -F/ -v room="$room" '{ print room "/enrich/" $NF "\t" $0 }' | sort -u >> "$work/map.tsv"

sort -u -o "$work/map.tsv" "$work/map.tsv"
echo "folded_files_mapped=$(wc -l < "$work/map.tsv" | tr -d ' ')"

# Living files only, and TRACKED ONLY. `git ls-files` is the field boundary here rather than
# `find`, because this tree keeps working state inside itself: `.claude-state/` holds the agent's
# own transcripts, bound in by the jail, and a first `find`-based pass over the same corpus reached
# 517 references inside a single transcript file. Those are a memory of what an agent read, not a
# reference anyone follows, and rewriting them would edit the record of a conversation. A tracked
# file is exactly the set that promises a reader something.
#
# A dated basename is testimony and is never opened for writing here -- WITH ONE ROOM NAMED, and
# the test for naming another is written rather than felt. `foundations/` holds 76 documents whose
# basenames carry a one-clock stamp and whose bodies are living: each one is edited, each carries a
# Status line, and `tools/f/foundations_link_witness.rish` holds their broken links at ZERO on
# every roster run. A room a standing guard requires to resolve is a room this tool must repoint,
# or the fold reds that guard by construction -- which it did, on two links naming
# `../tools/drey_witness.rish` and `../tools/hunk_qoi_witness.rish`.
#
# THE TEST, so this stays a rule rather than a habit: a dated-named room joins this list when a
# standing guard gates its references at zero. Nothing else qualifies today -- session logs,
# counsel, waymarks, and the dated design rooms are testimony, no guard requires their references
# to resolve, and repointing thousands of them would be a Tier 2 breach at scale in service of
# tidiness, which the mark law already declined.
LIVING_DATED_ROOMS="foundations"

# THE INSTRUMENT, FOR THIS FOLD, IS ONE NAME -- and reaching for the shared list was the mistake
# that taught it. tools/fixtures/dated_path_exclusions.sh names what the DATED-path tools decline
# to read, and its entries protect deliberately stale DATED references: `dated_path_witness.rish`
# cites a flat `counsel/...` path to prove the resolver recovers it. Those same files also cite
# `tools/dated_path_resolve.rish`, which is an ordinary living reference that this fold moved --
# and excluding the file wholesale left the witness invoking a tool at a path that no longer
# stands, so it reddened on the next roster run.
#
# So the question the two lists answer is the same, and the answer is different, because the
# references are different. Only `tool_path_*` cites a `tools/` path that must stay stale, since
# tools/t/tool_path_witness.rish proves recovery and needs something to recover. That is REDS %121
# read correctly rather than borrowed: exclude the instrument for THIS meter, not for another's.
excluded_names="tool_path_*"
excluded_paths=""

living_rooms_re=$(printf '%s' "$LIVING_DATED_ROOMS" | tr ' ' '|')

git ls-files 2>/dev/null \
  | grep -E '\.(md|mdc|rish|rye|sh|bron|kyri|brix|txt|json|awk|jq|example|conf)$|(^|/)(\.gitignore|pre-commit|commit-msg)$' \
  | awk -F/ -v living="^($living_rooms_re)/" \
      '$0 ~ living || $NF !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_/' \
  | while IFS= read -r f; do
      base="${f##*/}"
      skip=no
      set -f
      for n in $excluded_names; do
        # shellcheck disable=SC2254 -- the glob is the point: these are find-style -name patterns.
        case "$base" in $n) skip=yes ;; esac
      done
      for p in $excluded_paths; do
        [ "$f" = "$p" ] && skip=yes
      done
      set +f
      # `git ls-files` reads the INDEX, which lags the working tree the moment a move is made and
      # not yet staged. A path the index still names and the disk no longer has is skipped rather
      # than silently dropped by a later grep, so the considered count says what was actually read.
      [ "$skip" = no ] && [ -f "$f" ] && printf '%s\n' "$f"
    done > "$work/living.txt"

echo "living_files_considered=$(wc -l < "$work/living.txt" | tr -d ' ')"

# Narrow to files that could possibly hold a tools reference, so awk is spawned only where it
# could do work.
# The narrowing is a speed filter and nothing more, so it is deliberately wide: a first cut
# demanded that `tools/` open a word, which declined every `../tools/x.rish` in the tree -- 204 of
# them, including the two foundations links that reddened the room's own guard. Correctness lives
# in the awk below, which rewrites only a basename the map holds.
xargs -a "$work/living.txt" -d '\n' grep -lIF "$room/" 2>/dev/null \
  > "$work/candidates.txt" || true
echo "candidates_holding_a_tools_path=$(wc -l < "$work/candidates.txt" | tr -d ' ')"

# ONE awk per chunk of files, reading the map once. The cost of a lookup table is paid once or it
# is paid forever (REDS %113).
: > "$work/hits.tsv"
if [ -s "$work/candidates.txt" ]; then
  xargs -a "$work/candidates.txt" -d '\n' -n 400 \
    awk -v mapfile="$work/map.tsv" -v mode="$mode" -v room="$room" '
      BEGIN {
        while ((getline line < mapfile) > 0) { split(line, p, "\t"); map[p[1]] = p[2] }
        close(mapfile)
        prev = ""; hits = 0
        # The extensions the folded room actually holds, measured rather than guessed:
        # rish, sh, rye, example, jq, awk, conf. Anchoring the extension is what keeps a
        # reference written mid-sentence from matching with its sentence period attached.
        re = "(\\.\\./)*([A-Za-z0-9_.-]+/)+[A-Za-z0-9._-]+\\.(rish|sh|rye|example|jq|awk|conf)"
      }
      FNR == 1 {
        if (prev != "") { close(prev ".tpr"); if (hits > 0) print prev "\t" hits > "/dev/stderr" }
        prev = FILENAME; hits = 0
      }
      {
        line = $0; out = ""
        while (match(line, re)) {
          pre = substr(line, 1, RSTART - 1)
          m = substr(line, RSTART, RLENGTH)
          line = substr(line, RSTART + RLENGTH)
          key = m
          while (sub(/^\.\.\//, "", key)) ;
          sub(/^\.\//, "", key)
          # A LEADING HYPHEN OR DOT IS PUNCTUATION, NEVER THE START OF A ROOM NAME. A tool basename
          # may hold a hyphen -- `width-check.rish`, `agent-jail.sh` -- so `-` belongs in the match
          # class, and that lets a match begin one character early inside a shell default:
          # `${VAR:-tools/x.rish}` matches from `-tools/` onward, whose key opens at `-` and finds
          # nothing. One such line left `caravan_suite_witness.rish` unable to name its own roster,
          # and the choir of 108 rungs refused. Trimmed into the carried prefix, so nothing is lost.
          while (key ~ /^[-.]/) { key = substr(key, 2) }
          # Whatever was trimmed is carried through untouched: the key is always a suffix of the
          # match, so the prefix is simply the rest of it.
          prefix = substr(m, 1, length(m) - length(key))
          # ONE CUT, AND ONLY BEHIND A DOLLAR SIGN. A shell variable written as $ROOT/tools/x.rish
          # matches from `ROOT/` onward, because `$` is not a path character, so that one leading
          # segment must move into the carried prefix for the key to open at the room. Every other
          # leading segment is a real directory, and `otherproject/tools/x.rish` names a path in
          # some other tree that this tool has no business rewriting. So the cut is allowed exactly
          # when the text immediately before the match ends in `$`, which is the whole set of cases
          # where the segment was never a directory at all. Measured `20260823.145600`: the tracked
          # collection writes `../` 204 times, `./` 183 times, and one `$ROOT/` -- and every other
          # prefixed form names a fixture pen whose basenames this map does not hold.
          if (substr(key, 1, length(room) + 1) != room "/" && pre ~ /\$$/ && index(key, "/") > 0) {
            cut = index(key, "/")
            prefix = prefix substr(key, 1, cut)
            key = substr(key, cut + 1)
          }
          if (substr(key, 1, length(room) + 1) == room "/" && key in map) { m = prefix map[key]; hits++ }
          out = out pre m
        }
        print out line > (FILENAME ".tpr")
      }
      END {
        if (prev != "") { close(prev ".tpr"); if (hits > 0) print prev "\t" hits > "/dev/stderr" }
      }
    ' 2>> "$work/hits.tsv"
fi

if [ -s "$work/hits.tsv" ]; then sed 's/^/would_repoint: /' "$work/hits.tsv" | head -40; fi
changed=$(wc -l < "$work/hits.tsv" | tr -d ' ')
edits=$(awk -F'\t' '{n += $2} END {print n + 0}' "$work/hits.tsv")

# The rewritten copies land beside their originals and are swept either way, so a dry run leaves
# the tree byte-identical and an apply moves only the files that actually changed. `cat > "$f"`
# writes through the original inode, so a tracked file's mode survives the write -- `mv` would
# carry the temporary's mode instead, which is how thirty-nine exec bits were lost once
# (.claude/rules/exec-bit.md).
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if [ "$mode" = apply ] && [ -f "$f.tpr" ]; then
    cat "$f.tpr" > "$f"
  fi
done < "$work/candidates.txt"
while IFS= read -r f; do
  rm -f "$f.tpr"
done < "$work/candidates.txt"

echo "living_files_touched=$changed"
echo "references_repointed=$edits"
echo "mode=$mode"
echo "verdict=ok"
