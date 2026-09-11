#!/bin/sh
# tools/fixtures/r/rish_spoken_ascii_convert.sh -- convert the table forms inside Rishi SPOKEN
# regions, and nothing else.
#
# WHY A TOOL RATHER THAN A `sed`. A blanket substitution over a `.rish` source reaches four
# populations this tree keeps apart on purpose, and only one of them is this converter's subject:
#
#   * a `#` COMMENT -- `tools/fixtures/s/shell_comment_ascii_scan.sh` counts it against its own
#     ceiling. Charging one character to two ceilings makes each reading depend on the other.
#   * a `run [...]` ARGUMENT, a `let` binding, an `if` condition -- what the program feeds ONWARD.
#     Its bytes are behavior.
#   * an assert's CONDITION -- a match pattern. Measured `20260910.180158`: 164 counted characters
#     stand in assert conditions, and 126 of them match a Rye binary's `selftest.out`. A guard
#     hunting an em dash has to contain one, so converting a condition asks the tree's own guards
#     to stop finding what they guard.
#   * a `say` line, or an `assert ... else` message -- prose a guard says TO A PERSON, on their
#     terminal and into `session-output/`. Converting it changes register rather than behavior,
#     and register is what `.claude/rules/ascii-first.md` governs. This is the subject.
#
# AND ONE EXCLUSION THAT HAS NO SIBLING: A COUPLED SAYING. Rye's `print` and Glow's `::` comment
# each speak one way -- to a person, and to nobody else. A Rishi `say` is also a WIRE BETWEEN
# GUARDS: one witness runs another and asserts on what it said. Convert one side of that wire and
# the other side stops matching, so a spoken line whose text another runner matches on is held
# back whole and named. Measured `20260910.180158` over 2,481 tracked `.rish` sources against 197
# match-position literals: **16 coupled spoken lines across 12 files**, against roughly 6,800
# spoken lines carrying a counted character. Small, and the difference between a green sweep and
# a broken guard.
#
# WHAT IT CONVERTS, each spelled by the rule's own substitution table:
#   em dash -> `--`   en dash -> `-`   middle dot -> `-`   ellipsis -> `...`
#   right, left, and left-right arrow -> `->`, `<-`, `<->`   typographic minus -> `-`
# Everything else -- a section sign, a `<=`, a superscript, a Greek letter -- is a reader's word to
# choose and is left standing. `tools/fixtures/r/rish_spoken_ascii_scan.sh` reports that tail apart
# under `notation=` for exactly this reason, and this converter carries the SAME table it does, so
# a file it changes falls in that scan's reading by exactly what it converted and moves no other
# meter at all.
#
# THE MODE IS IN THE PATH, WRITTEN THROUGH THE ORIGINAL INODE. `cat "$tmp" > "$f"` preserves the
# mode the repository tracks; `mv` would carry the temporary file's instead
# (`.claude/rules/exec-bit.md`).
#
# USAGE
#   sh tools/fixtures/r/rish_spoken_ascii_convert.sh --check <path>...   # report, change nothing
#   sh tools/fixtures/r/rish_spoken_ascii_convert.sh --apply <path>...   # rewrite in place
#   sh tools/fixtures/r/rish_spoken_ascii_convert.sh --matchers          # print the coupling set
#
# Run from the repository root.

set -u

mode="${1:-}"
case "$mode" in
  --check | --apply) shift ;;
  --matchers) ;;
  *)
    echo "usage: sh tools/fixtures/r/rish_spoken_ascii_convert.sh --check|--apply <path>... | --matchers"
    exit 2
    ;;
esac

# THE COUPLING SET, derived on every run rather than pinned in a file beside this one. A pinned
# list is a second artifact that drifts the first time a guard's spoken sentence changes, and the
# whole subject here is a wire between two files staying in step.
#
# What counts as a match position, drawn wider than strictly needed on purpose -- over-coupling
# costs a character left standing, under-coupling costs a broken guard:
#   * the CONDITION half of an `assert ... else "..."` line
#   * any line carrying `contains "`, `grep`, or a `-q` flag
# A literal shorter than six bytes is passed over: a fragment that short matches by accident.
matchers() {
  git ls-files "*.rish" "*.sh" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/" > "$mt_list"
  # Fed through `xargs -0` rather than an unquoted `$(cat ...)`: a path carrying a space splits on
  # the word boundary and falls out of the coupling set in silence, which is the shape
  # `.claude/rules/ascii-first.md` booked one room over. `xargs` may split the roster across several
  # awk runs, which costs nothing here -- every run prints literals into one `sort -u`.
  tr '\n' '\0' < "$mt_list" | LC_ALL=C xargs -0 awk '
    {
      line = $0
      t = line
      sub(/^[ \t]+/, "", t)
      if (substr(t, 1, 1) == "#") next
      if (line !~ /[\300-\377]/) next
      spoken = (t ~ /^say[ \t]/)
      # Region one -- everything that is NOT a spoken region. An assert contributes its condition
      # half; a `say` line contributes nothing; every other line contributes whole.
      if (spoken) region = ""
      else if (t ~ /^assert[ \t]/ && t ~ /[ \t]else[ \t]+"/) {
        i = index(line, "else \"")
        region = (i > 0 ? substr(line, 1, i - 1) : line)
      } else region = line
      emit(region)
      # Region two -- any line carrying a matching construct, spoken or not, since a `say` line may
      # itself hold the pattern a sibling searches for. An assert contributes its CONDITION half
      # here as well: its own `else` message is prose this converter exists to reach, and reading
      # the whole line would let every refusal message couple itself and hold itself back.
      if (line ~ /contains[ \t]+"/ || line ~ /grep/ || line ~ /-q[ \t]/) {
        if (t ~ /^assert[ \t]/ && t ~ /[ \t]else[ \t]+"/) {
          i = index(line, "else \"")
          emit(i > 0 ? substr(line, 1, i - 1) : line)
        } else emit(line)
      }
    }
    function emit(region,   n, m, k, parts, sp) {
      if (region == "") return
      n = split(region, parts, "\"")
      for (k = 2; k <= n; k += 2)
        if (parts[k] ~ /[\300-\377]/ && length(parts[k]) >= 6) print parts[k]
      m = split(region, sp, "\047")
      for (k = 2; k <= m; k += 2)
        if (sp[k] ~ /[\300-\377]/ && length(sp[k]) >= 6) print sp[k]
    }
  ' 2>/dev/null | sort -u
}

pen="${TMPDIR:-.}/.rish-spoken-convert.$$"
mkdir -p "$pen" || { echo "verdict=no_pen"; exit 2; }
mt_list="$pen/runners"
mt="$pen/matchers"
trap 'rm -rf "$pen"' EXIT INT TERM

matchers > "$mt" || { echo "verdict=matchers_refused"; exit 2; }

if [ "$mode" = --matchers ]; then
  cat "$mt"
  echo "RISH_SPOKEN_ASCII_MATCHERS count=$(wc -l < "$mt" | tr -d ' ')"
  exit 0
fi

[ "$#" -gt 0 ] || { echo "verdict=no_paths"; exit 2; }

rewrite() {
  LC_ALL=C awk -v MT="$mt" '
    BEGIN {
      np = 0
      while ((getline p < MT) > 0) if (length(p) > 0) pat[++np] = p
      close(MT)
      changed = 0
      held = 0
    }
    {
      s = $0
      t = s
      sub(/^[ \t]+/, "", t)
      if (substr(t, 1, 1) == "#") { print s; next }
      start = 0
      if (t ~ /^say[ \t]/) start = 1
      else if (t ~ /^assert[ \t]/ && t ~ /[ \t]else[ \t]+"/) {
        # The LAST ` else "`, never the first. A condition may itself hold those bytes, and reading
        # the last one converts less rather than more -- the safe direction when the two part.
        off = 0; last = 0
        while (match(substr(s, off + 1), /[ \t]else[ \t]+"/)) { last = off + RSTART; off = off + RSTART }
        start = last
      }
      if (start == 0) { print s; next }
      region = substr(s, start)
      for (k = 1; k <= np; k++) if (index(region, pat[k]) > 0) { held++; print s; next }
      print substr(s, 1, start - 1) convert(region)
    }
    END { print "held_coupled=" held + 0 > "/dev/stderr"; exit (changed ? 0 : 1) }

    function convert(str,   out, i, len, c, seq, j, rep) {
      out = ""
      i = 1
      len = length(str)
      while (i <= len) {
        c = substr(str, i, 1)
        if (c ~ /[\300-\377]/) {
          seq = c; j = i + 1
          while (j <= len && substr(str, j, 1) ~ /[\200-\277]/) { seq = seq substr(str, j, 1); j++ }
          rep = plain(seq)
          if (rep != seq) changed = 1
          out = out rep
          i = j
          continue
        }
        out = out c
        i++
      }
      return out
    }

    # The forms the rule names and spells, and nothing beside them.
    function plain(seq) {
      if (seq == "\342\200\224") return "--"
      if (seq == "\342\200\223") return "-"
      if (seq == "\302\267")     return "-"
      if (seq == "\342\200\246") return "..."
      if (seq == "\342\206\222") return "->"
      if (seq == "\342\206\220") return "<-"
      if (seq == "\342\206\224") return "<->"
      if (seq == "\342\210\222") return "-"
      return seq
    }
  ' "$1"
}

changed=0
read_files=0
held=0
for f in "$@"; do
  [ -f "$f" ] || { echo "detail=absent path=$f"; continue; }
  read_files=$((read_files + 1))
  tmp="$pen/one"
  if rewrite "$f" 2> "$pen/held" > "$tmp"; then
    changed=$((changed + 1))
    if [ "$mode" = --apply ]; then
      # Written through the original inode, so the tracked mode survives the rewrite.
      cat "$tmp" > "$f"
      echo "converted=$f"
    else
      echo "would_convert=$f"
    fi
  fi
  h=$(sed -n 's/^held_coupled=//p' "$pen/held" 2>/dev/null)
  case "${h:-0}" in '' | *[!0-9]*) h=0 ;; esac
  [ "$h" -gt 0 ] && echo "held_coupled=$h path=$f"
  held=$((held + h))
done

echo "RISH_SPOKEN_ASCII_CONVERT mode=${mode#--} read=$read_files changed=$changed held_coupled=$held matchers=$(wc -l < "$mt" | tr -d ' ')"
