#!/usr/bin/env sh
# instrument_refusal_control.sh -- prove the refusal meter on planted scans in a throwaway pen.
#
# EVERY REFUSAL IS SHOWN FROM BOTH SIDES. A refusal proven only in the passing direction cannot be
# told from a bypass, so each shape is planted, bitten, then made innocent and shown to walk free.
# The welcomes matter as much as the bites here: this meter's whole design rests on telling a
# swallowed failure apart from a documented one, and a meter that bit both would be turned off.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
scan="$ROOT/tools/fixtures/i/instrument_refusal_scan.sh"
checks=0; failures=0
say() { checks=$((checks + 1)); printf '%s\n' "$1"; case "$1" in *=no) failures=$((failures + 1)) ;; esac; }

pen=$(mktemp -d); trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures/z"
( cd "$pen" && git init -q . && git config user.email c@e && git config user.name c )

plant() { printf '%s\n' "$2" > "$pen/tools/fixtures/z/probe.sh"; ( cd "$pen" && git add -A >/dev/null 2>&1 ); }
read_verdict() { ( cd "$pen" && sh "$scan" --root "$pen" 2>/dev/null ) || true; }

# 1 -- the bite: an output-producing pass whose failure is discarded.
plant x 'awk -f prog.awk in.txt > "$work/out" || true'
case "$(read_verdict)" in *swallowed_instrument_passes=1*) say "swallowed_awk_bitten=yes" ;; *) say "swallowed_awk_bitten=no" ;; esac

# 2 -- the same line with its status checked walks free.
plant x 'if ! awk -f prog.awk in.txt > "$work/out"; then echo instrument=failed; exit 1; fi'
case "$(read_verdict)" in *swallowed_instrument_passes=0*) say "checked_status_free=yes" ;; *) say "checked_status_free=no" ;; esac

# 3 -- grep leads: exit 1 is an ANSWER, not a fault, and tolerating it is correct.
plant x 'grep -E "$re" "$all" > "$work/out" || true'
case "$(read_verdict)" in *swallowed_instrument_passes=0*) say "grep_exit_one_free=yes" ;; *) say "grep_exit_one_free=no" ;; esac

# 4 -- a predicate awk answers by exiting and writes no file.
plant x 'awk "END { exit !found }" "$f" 2>/dev/null || true'
case "$(read_verdict)" in *swallowed_instrument_passes=0*) say "predicate_awk_free=yes" ;; *) say "predicate_awk_free=no" ;; esac

# 5 -- a documented toleration says so at the site, and only exempts the NEXT line.
plant x '# instrument-tolerated: a partial read is the intended outcome
tr "\n" "\0" < "$list" | xargs -0 cat > "$work/out" || true'
case "$(read_verdict)" in *swallowed_instrument_passes=0*) say "marked_toleration_free=yes" ;; *) say "marked_toleration_free=no" ;; esac

# 6 -- THE BITING DIRECTION FOR THE MARKER: it exempts one line, not the rest of the file.
plant x '# instrument-tolerated: only the next line
tr "\n" "\0" < "$list" | xargs -0 cat > "$work/out" || true
sed -e s/a/b/ "$in" > "$work/two" || true'
case "$(read_verdict)" in *swallowed_instrument_passes=1*) say "marker_exempts_one_line_only=yes" ;; *) say "marker_exempts_one_line_only=no" ;; esac

# 7 -- a comment is prose, never a hit.
plant x '# awk -f prog.awk in.txt > "$work/out" || true'
case "$(read_verdict)" in *swallowed_instrument_passes=0*) say "comment_free=yes" ;; *) say "comment_free=no" ;; esac

# 8 -- no redirect, no hit: a pass producing no file cannot report an empty one.
plant x 'awk -f prog.awk in.txt || true'
case "$(read_verdict)" in *swallowed_instrument_passes=0*) say "no_redirect_free=yes" ;; *) say "no_redirect_free=no" ;; esac

# 9 and 10 -- the ceiling is proven from both sides, so no override exists and none is wanted.
plant x 'awk -f prog.awk in.txt > "$work/out" || true'
case "$( ( cd "$pen" && INSTRUMENT_REFUSAL_CEILING=1 sh "$scan" --root "$pen" 2>/dev/null ) || true)" in
  *verdict=ok*) say "at_ceiling_free=yes" ;; *) say "at_ceiling_free=no" ;; esac
case "$(read_verdict)" in *verdict=over_ceiling*) say "past_ceiling_refused=yes" ;; *) say "past_ceiling_refused=no" ;; esac

# 11 -- the meter obeys its own law: it refuses when IT cannot run.
case "$( ( cd "$pen" && sh "$scan" --root /nonexistent-root 2>&1 ) || true)" in
  *instrument=failed*|*no\ tree\ root*|*cannot*) say "meter_refuses_when_blind=yes" ;; *) say "meter_refuses_when_blind=no" ;; esac

# ---- the fallback reading: a failure that substitutes a VALUE, added 20260906 --------------------
# The same both-sides discipline. Emptiness at least looks like nothing; a fallback value reads as
# an answer, so this shape is the worse of the two and its exclusions have to be exact.
#
# THE PLANTS SPELL `||` THROUGH `$D`, and that is a repair rather than a flourish. This control is
# itself a tracked tool scan, so a plant written literally puts the very shape under test into the
# meter's own corpus and the live tree reds on the control's fixtures. The elder `|| true` plants
# above escape only because a plant's closing quote falls where the pattern wants end-of-line --
# an accident, not a decision. `$D` makes it a decision: the pen holds the exact bytes, and this
# file's source spells no discard at all.
D='||'

# 12 -- the bite: an output-producing pass whose failure puts a value back in its place.
plant x "b=\$(awk -v p=\"\$1\" '\$1 == p { print \$2 }' \"\$BASE\" 2>/dev/null $D echo -)"
case "$(read_verdict)" in *fallback_instrument_passes=1*) say "fallback_value_bitten=yes" ;; *) say "fallback_value_bitten=no" ;; esac

# 13 -- the same lookup with its status left readable walks free.
plant x "b=\$(awk -v p=\"\$1\" '\$1 == p { print \$2 }' \"\$BASE\")"
case "$(read_verdict)" in *fallback_instrument_passes=0*) say "readable_status_free=yes" ;; *) say "readable_status_free=no" ;; esac

# 14 -- a `test && echo yes || echo no` TERNARY discards nothing: its `||` is an else-branch. Six of
# the first seven hits this reading ever produced were exactly this, so the exclusion is the meter.
plant x "[ \"\$(wc -l < \"\$f\" | tr -d ' ')\" = 5 ] && echo five=yes $D echo five=no"
case "$(read_verdict)" in *fallback_instrument_passes=0*) say "ternary_free=yes" ;; *) say "ternary_free=no" ;; esac

# 15 -- THE JOINING CASE. The same ternary across continuation lines: a line-at-a-time reader sees
# only the `|| echo` tail and calls it a swallow. This was the seventh of those seven hits, and it
# stands today in `qa_report_card_control.sh`.
plant x "sed -n 's/^r//p' \"\$el\" \\
  && echo blindness=yes \\
  $D echo blindness=no"
case "$(read_verdict)" in *fallback_instrument_passes=0*) say "multiline_ternary_free=yes" ;; *) say "multiline_ternary_free=no" ;; esac

# 16 -- grep leads, in this spelling too: exit 1 is no-match, and a placeholder for it is correct.
plant x "v=\$(grep -E \"^\$k \" \"\$all\" | cut -d' ' -f2 $D echo -)"
case "$(read_verdict)" in *fallback_instrument_passes=0*) say "grep_fallback_free=yes" ;; *) say "grep_fallback_free=no" ;; esac

# 17 -- a comment is prose in this reading as well.
plant x "# b=\$(awk '{ print }' \"\$f\" 2>/dev/null $D echo -)"
case "$(read_verdict)" in *fallback_instrument_passes=0*) say "fallback_comment_free=yes" ;; *) say "fallback_comment_free=no" ;; esac

# 18 and 19 -- the fallback ceiling from both sides, so no override exists and none is wanted.
plant x "b=\$(awk '{ print }' \"\$f\" 2>/dev/null $D echo -)"
case "$( ( cd "$pen" && INSTRUMENT_FALLBACK_CEILING=1 sh "$scan" --root "$pen" 2>/dev/null ) || true)" in
  *verdict=ok*) say "fallback_at_ceiling_free=yes" ;; *) say "fallback_at_ceiling_free=no" ;; esac
case "$(read_verdict)" in *verdict=over_ceiling*) say "fallback_past_ceiling_refused=yes" ;; *) say "fallback_past_ceiling_refused=no" ;; esac

# 20 -- THE TWO READINGS STAY APART. One shape at its own raised ceiling must not free the other,
# which is the whole reason they are counted separately rather than summed.
plant x "awk -f prog.awk in.txt > \"\$work/out\" $D true
b=\$(awk '{ print }' \"\$f\" 2>/dev/null $D echo -)"
case "$( ( cd "$pen" && INSTRUMENT_FALLBACK_CEILING=9 sh "$scan" --root "$pen" 2>/dev/null ) || true)" in
  *verdict=over_ceiling*) say "raised_fallback_ceiling_frees_only_itself=yes" ;; *) say "raised_fallback_ceiling_frees_only_itself=no" ;; esac

echo "control_checks=$checks"
echo "control_failures=$failures"
if [ "$failures" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=broken"; exit 1
