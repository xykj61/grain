#!/usr/bin/env sh
# instrument_absence_scan.sh -- a tool that is absent must not wear that tool's answer.
#
# WHY THIS READS A DIFFERENT SUBJECT THAN ITS SIBLING. `instrument_refusal_scan.sh` (REDS %416)
# gates an output-producing pass, redirected INTO A FILE, whose failure is discarded. That reading
# is honest and narrow, and it is blind by construction to the shape booked as REDS %442, where the
# pass is captured into a VARIABLE and its emptiness is the pass branch:
#
#   hits="$(rg PATTERN paths 2>/dev/null || true)"
#   if [ -n "$hits" ]; then refuse; fi
#
# Three constructions in those two lines each discard the evidence. `2>/dev/null` hides
# `rg: command not found`; `|| true` discards exit 127; and the emptiness test reads "nothing
# matched" out of "nothing ran". A host without ripgrep therefore prints the sweep's GREEN line
# byte for byte. Measured on this pier `20260905.223102` with ripgrep genuinely off PATH -- not a
# shim answering 127, which `command -v` still finds -- **117 tracked scans name `rg` in command
# position, and two of them printed GREEN and exited 0**:
# `tools/fixtures/i/inner_i1_twah_residual.sh` and `tools/fixtures/i/inner_i2_djin_prose.sh`.
# `rishi/bin/rishi run tools/i/inner_i1_twah_residual.rish` read GREEN with no ripgrep on the host.
# The other 115 refused for reasons of their own -- loudly, and by accident, since none of them
# names the instrument.
#
# WHY A GATE AND NOT A RATCHET. The design in
# `active-designing/yonder/20260905-064341_the-tools-a-guard-may-assume.md` is right that
# "borrowed sites with no probe" is a ratchet needing a tool-grant roster first: 992 `rg` sites
# cannot become zero in one lap, and that count is an opinion until a roster says which tier each
# tool is in. THIS reading makes no claim about tiers. It counts one construction that converts a
# missing tool into a clean bill of health, and there is no honest reason to write a new one. Two
# sites stood when it was written and both are repaired in the same commit, so it opens at zero.
#
# WHAT IT DOES NOT MODEL, stated because a reader reads silence as coverage
# (`active-designing/20260823-232125_the-edge-of-an-instruments-model.md`):
#   * an instrument PRESENT but broken -- a different fault with the same silence
#   * a capture tested by `case`, by string comparison, or by line count rather than by -n / -z
#   * a borrowed instrument whose absence is loud today by luck, which is the ratchet's subject
#   * whether a tool is granted, carried, or borrowed -- that is the roster's claim, not this one
#
# THE INSTRUMENT THIS METER ITSELF USES IS GRANTED. Its awk is POSIX awk -- no `match(s, re, arr)`,
# which is a GNU extension -- because a guard about borrowed instruments that reaches for one has
# refuted itself. The first draft used `gawk` and had to be rewritten.
#
#   sh tools/fixtures/i/instrument_absence_scan.sh
#   sh tools/fixtures/i/instrument_absence_scan.sh --root DIR
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_ia_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _ia_steps=$((_ia_steps + 1))
  if [ "$_ia_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    *) echo "$0: unknown argument $1" >&2; exit 2 ;;
  esac
done
[ -d "$ROOT" ] || { echo "$0: no such root $ROOT" >&2; exit 2; }
cd "$ROOT"

# The gate is zero and it opened at zero, so it never has to be lowered on a lap that is busy.
CEILING=0

# BORROWED, for this reading only. `git` is deliberately absent: the design calls it carried --
# no clone of this tree exists without it -- so a guard may assume it the way it assumes a shell.
# Adding a name here can only find more, never fewer, which is the safe direction for a gate.
BORROWED='rg|jq|mktemp|flock|timeout|python3|python|sha256sum|sha3sum|shasum|md5sum|realpath|readlink|stat|seq|tac|column|base64|xxd|gsed|gawk|curl|wget|rsync|node|npm|zig'

work=$(mktemp -d 2>/dev/null) || { echo "$0: cannot make a work directory" >&2; exit 2; }
trap 'rm -rf "$work"' EXIT INT TERM

# The subject is tracked shell under tools/. A pen copy outside git falls back to find, so the
# control can point this meter at a throwaway tree that was never a repository.
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$ROOT" ls-files 'tools/*.sh' 'tools/**/*.sh' > "$work/files" 2>/dev/null || :
else
  find tools -name '*.sh' -type f > "$work/files" 2>/dev/null || :
fi
scanned=$(grep -c . "$work/files" || true)

# THE PASS ITSELF, and its failure is checked rather than discarded -- this meter obeys the law it
# enforces. Logical lines are rebuilt by tracking unclosed `$(`, because the capture this reads
# routinely runs to four physical lines of --glob flags.
: > "$work/hits"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if ! awk -v FNAME="$f" -v BORROWED="$BORROWED" -v Q="'" '
    function first_word(s,   t) {
      sub(/^[ \t]*/, "", s)
      t = s
      sub(/[ \t].*$/, "", t)
      return t
    }
    {
      # A HEREDOC BODY IS TEXT THIS SCRIPT WRITES, rather than a pass it runs, and it is tracked
      # before anything else reads the line. A control proving this meter has to plant the very
      # shape the meter detects, and a `cat > pen/x <<PLANT` plant necessarily lives in the
      # control source -- so the meter read its own proof as a wound (REDS %443). The tree already
      # draws exactly this line for its ASCII comment meters, which skip a shell heredoc body
      # because it is what a program feeds onward rather than what it executes.
      body = 0
      if (hd != "") {
        term = $0
        if (hd_dash) sub(/^[ \t]+/, "", term)
        if (term == hd) { hd = "" } else { body = 1 }
      } else if (match($0, /<<-?[ \t]*/)) {
        dash = (substr($0, RSTART + 2, 1) == "-")
        rest = substr($0, RSTART + RLENGTH)
        c = substr(rest, 1, 1)
        if (c == Q || c == "\"") rest = substr(rest, 2)
        if (match(rest, /^[A-Za-z_][A-Za-z0-9_]*/)) {
          hd = substr(rest, RSTART, RLENGTH)
          hd_dash = dash
        }
      }
      buf = buf $0 " "
      n = split(buf, parts, /\$\(/); opens = n - 1
      m = split(buf, closed, /\)/);  closes = m - 1
      if (opens > closes) { if (body) pend = 1; next }
      line = buf; buf = ""
      inbody = (body || pend); pend = 0
      # A file that asks for its instrument by name has already answered this meter -- and only
      # when it asks in its OWN code. `require_instrument` inside a heredoc is fixture text, so a
      # file exempted by a plant it merely writes was exempted by luck rather than by reasoning.
      if (line ~ /require_instrument/ && !inbody) { armed = 1 }
      # VAR="$( <borrowed> ... || true )"  -- the capture whose failure cannot be seen.
      if (line ~ /^[ \t]*[A-Za-z_][A-Za-z0-9_]*=["]?\$\(/) {
        v = line
        sub(/^[ \t]*/, "", v)
        sub(/=.*$/, "", v)
        inner = line
        sub(/^[^(]*\$\(/, "", inner)
        head = first_word(inner)
        if (head ~ ("^(" BORROWED ")$") && line ~ /\|\|[ \t]*(true|:)[ \t]*\)/) {
          site[v] = FNAME ":" FNR
          tool[v] = head
          fixt[v] = inbody
        }
      }
      # ... and later read for emptiness, which is where "nothing ran" becomes "nothing matched".
      if (match(line, /\[[ \t]+-[nz][ \t]+"?\$\{?[A-Za-z_][A-Za-z0-9_]*\}?"?[ \t]+\]/)) {
        t = substr(line, RSTART, RLENGTH)
        gsub(/[][$"{}]|[ \t]+-[nz][ \t]+|[ \t]+/, "", t)
        if (t in site) {
          print site[t] " var=" t " tool=" tool[t] " armed=" (armed ? "yes" : "no") " fixture=" ((fixt[t] || inbody) ? "yes" : "no")
          delete site[t]
        }
      }
    }
  ' "$f" >> "$work/hits" 2>"$work/awkerr"; then
    echo "instrument=failed"
    echo "detail=scan_pass_refused_on=$f"
    sed -n '1,5p' "$work/awkerr" | sed 's/^/detail_awk=/'
    echo "verdict=misread"
    exit 1
  fi
done < "$work/files"

# A file that reaches require_instrument has answered the question this meter asks, so its capture
# is a reading rather than a wound. The exemption is per file rather than per tool on purpose: a
# script asking for one instrument by name has met the reflex, and a second unasked tool in the
# same file is the ratchet's subject rather than this gate's.
#
# A FIXTURE CAPTURE IS REPORTED AND NEVER GATED. A capture inside a heredoc body is a plant this
# script writes into a pen, and every control for this meter must write one -- so counting it as
# field turns a proof into a wound and makes the guard refuse the moment it is tracked (REDS %443).
# It is printed rather than dropped, because a cap nobody can see is a cap nobody can check.
grep ' fixture=yes$' "$work/hits" > "$work/fixture" 2>/dev/null || :
grep -v ' fixture=yes$' "$work/hits" > "$work/own" 2>/dev/null || :
grep -v ' armed=yes ' "$work/own" > "$work/open" 2>/dev/null || :
open=$(grep -c . "$work/open" || true)
armed=$(grep -c ' armed=yes ' "$work/own" || true)
fixture=$(grep -c . "$work/fixture" || true)

[ "$open" -eq 0 ] || sed 's/^/blind_capture: /' "$work/open"
[ "$fixture" -eq 0 ] || sed 's/^/fixture_capture: /' "$work/fixture"

echo "scans_read=$scanned"
echo "blind_captures_armed=$armed"
echo "blind_captures_in_fixture=$fixture"
echo "blind_captures_open=$open"
echo "blind_capture_ceiling=$CEILING"
echo "story=an_absent_tool_must_not_wear_that_tools_answer>emptiness_is_not_evidence>ask_for_it_by_name"

if [ "$open" -le "$CEILING" ]; then
  echo "under_ceiling=yes"
  echo "verdict=ok"
  exit 0
fi
echo "under_ceiling=no"
echo "verdict=over_ceiling"
echo "refused: $open captures of a borrowed instrument read their own emptiness as health, against a ceiling of $CEILING." >&2
exit 1
