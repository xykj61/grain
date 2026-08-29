#!/bin/sh
# tools/fixtures/g/glow_gate_answer_control.sh -- the pen for glow_gate_answer_scan.sh.
#
# Sixteen cases on real planted .rish files in a throwaway directory, every refusal shown from both
# sides -- planted and then removed -- because a refusal proven only in the passing direction cannot
# be told from a bypass. The bitten cases include the real standing hit verbatim
# (`contains "EXIT:"` in tools/g/glow_lower_assert_witness.rish) and the real %310 needle
# (`contains "0"`), so each refusal is proven against a fault that actually happened.
#
#   sh tools/fixtures/g/glow_gate_answer_control.sh
#
# Run from the repository root; the scan itself refuses elsewhere.

set -u

scan="tools/fixtures/g/glow_gate_answer_scan.sh"
if [ ! -f "$scan" ]; then
  echo "control=refused"
  echo "refused: $scan is the scan this pen drives, and it is absent" >&2
  exit 1
fi

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
no() { echo "case=$1 FAILED -- $2"; fails=$((fails + 1)); }

# read <file> <key> -- one reading off the scan's report of one planted file
read_key() { sh "$scan" report "$1" 2>/dev/null | grep "^$2=" | head -1 | cut -d= -f2; }
verdict()  { sh "$scan" report "$1" 2>/dev/null | grep '^verdict=' | head -1 | cut -d= -f2; }
detail()   { sh "$scan" report "$1" 2>/dev/null | grep '^detail:'; }

# --- the laundered needle, bitten -------------------------------------------------------------
# The literal %310 shape: `contains "0"` against output whose tail is EXIT:0.
cat > "$pen/launder.rish" <<'F'
let run_gate = run ["sh" "-c" "${bin} 9 8; echo EXIT:$?"]
assert run_gate.ok else "gate failed to launch"
assert run_gate.out contains "0" else "gate did not answer 0"
F
[ "$(verdict "$pen/launder.rish")" = framing_satisfies_needle ] \
  && ok launder_bitten || no launder_bitten "a needle the EXIT tail supplies must be refused"
[ "$(read_key "$pen/launder.rish" laundered_needles)" = 1 ] \
  && ok launder_counted || no launder_counted "the laundered count must read one"
detail "$pen/launder.rish" | grep -q 'contains "0"' \
  && ok launder_named || no launder_named "the refusal must name the needle it caught"

# The real standing hit, verbatim: `contains "EXIT:"` is supplied by every EXIT tail.
cat > "$pen/exitcolon.rish" <<'F'
let run_un = run ["sh" "-c" "${un_bin} >/dev/null 2>&1; echo EXIT:$?"]
assert run_un.out contains "EXIT:" else "unwelcome produced no exit"
assert (run_un.out contains "EXIT:0") == false else "unwelcome must not exit 0"
F
[ "$(verdict "$pen/exitcolon.rish")" = framing_satisfies_needle ] \
  && ok exit_colon_bitten || no exit_colon_bitten "the bare EXIT: needle must be refused"

# --- the same file, repaired: the refusal is freed --------------------------------------------
cat > "$pen/repaired.rish" <<'F'
let run_un = run ["sh" "-c" "${un_bin} >/dev/null 2>&1; echo EXIT:$?"]
assert run_un.ok else "unwelcome failed to launch"
assert (run_un.out contains "EXIT:0") == false else "unwelcome must not exit 0"
F
[ "$(verdict "$pen/repaired.rish")" = every_needle_outlives_the_framing ] \
  && ok repair_free || no repair_free "the repaired shape must pass"
[ "$(read_key "$pen/repaired.rish" never_refused_files)" = 0 ] \
  && ok negated_refusal_counts || no negated_refusal_counts "a negated exit assertion is a refusal"

# --- the honest exit-code walls stay free ------------------------------------------------------
cat > "$pen/twosided.rish" <<'F'
let run_welcome = run ["sh" "-c" "${welcome_bin}; echo EXIT:$?"]
assert run_welcome.ok else "welcome failed to launch"
assert run_welcome.out contains "EXIT:0" else "welcome did not exit 0"
let run_unwelcome = run ["sh" "-c" "${unwelcome_bin}; echo EXIT:$?"]
assert run_unwelcome.out contains "EXIT:1" else "unwelcome did not exit 1"
F
[ "$(verdict "$pen/twosided.rish")" = every_needle_outlives_the_framing ] \
  && ok exit_framing_free || no exit_framing_free "an exact EXIT:<code> needle must pass free"
[ "$(read_key "$pen/twosided.rish" never_refused_files)" = 0 ] \
  && ok refusal_seen || no refusal_seen "a file asserting EXIT:1 has seen its wall refuse"
[ "$(read_key "$pen/twosided.rish" answer_blind_runs)" = 2 ] \
  && ok blind_counted || no blind_counted "two framing-only runs must read as two blind runs"

# --- a spoken answer clears the blind reading --------------------------------------------------
cat > "$pen/speaks.rish" <<'F'
let run_gate = run ["sh" "-c" "${bin} 9 8; echo EXIT:$?"]
assert run_gate.ok else "gate failed to launch"
assert run_gate.out contains "EXIT:0" else "gate did not exit 0"
assert trim run_gate.out == "gardens_lawful 0" else "gate must answer 0 past its cap"
F
[ "$(read_key "$pen/speaks.rish" answer_blind_runs)" = 0 ] \
  && ok blind_cleared || no blind_cleared "a run reading its spoken answer is not blind"
[ "$(verdict "$pen/speaks.rish")" = every_needle_outlives_the_framing ] \
  && ok real_needle_free || no real_needle_free "the %310 repaired shape must pass"

# --- never_refused, both sides ------------------------------------------------------------------
cat > "$pen/onesided.rish" <<'F'
let run_a = run ["sh" "-c" "${a_bin}; echo EXIT:$?"]
assert run_a.out contains "EXIT:0" else "a did not exit 0"
let run_b = run ["sh" "-c" "${b_bin}; echo EXIT:$?"]
assert run_b.out contains "EXIT:0" else "b did not exit 0"
F
[ "$(read_key "$pen/onesided.rish" never_refused_files)" = 1 ] \
  && ok norefuse_counted || no norefuse_counted "a file that never proves a refusal must be counted"
printf 'let run_c = run ["sh" "-c" "${c_bin}; echo EXIT:$?"]\nassert run_c.out contains "EXIT:1" else "c did not refuse"\n' >> "$pen/onesided.rish"
[ "$(read_key "$pen/onesided.rish" never_refused_files)" = 0 ] \
  && ok norefuse_cleared || no norefuse_cleared "adding a refusal must clear the reading"

# --- a captured run nobody asserted --------------------------------------------------------------
cat > "$pen/unread.rish" <<'F'
let run_seen = run ["sh" "-c" "${bin}; echo EXIT:$?"]
assert run_seen.out contains "EXIT:0" else "seen did not exit 0"
let run_ignored = run ["sh" "-c" "${other}; echo EXIT:$?"]
say "done"
F
[ "$(read_key "$pen/unread.rish" unread_runs)" = 1 ] \
  && ok unread_counted || no unread_counted "a captured run never asserted must be counted"

# --- files outside the idiom, and files that are not there ----------------------------------------
cat > "$pen/noidiom.rish" <<'F'
let plain = run ["sh" "-c" "echo hello"]
assert plain.out contains "hello" else "plain did not speak"
F
[ "$(read_key "$pen/noidiom.rish" witness_files)" = 0 ] \
  && ok no_idiom_told_apart || no no_idiom_told_apart "a witness without the EXIT idiom reads as no file"
[ "$(verdict "$pen/absent.rish")" = no_such_file ] \
  && ok absent_told_apart || no absent_told_apart "an absent file must read distinctly"


# --- the two ratchets, proven from both sides with no override ----------------------------------
# The ceilings are read off the scan's own output rather than spelled again here, so deleting one
# makes this pen refuse rather than guess.
blind_ceiling=$(sh "$scan" 2>/dev/null | grep '^answer_blind_ceiling=' | cut -d= -f2)
norefuse_ceiling=$(sh "$scan" 2>/dev/null | grep '^never_refused_ceiling=' | cut -d= -f2)
if [ -z "${blind_ceiling:-}" ] || [ -z "${norefuse_ceiling:-}" ]; then
  no ceilings_cited "the scan must publish both ceilings for this pen to read"
else
  ok ceilings_cited

  # answer_blind: exactly at the ceiling passes free, one over refuses.
  plant_blind() {
    : > "$2"
    i=0
    while [ "$i" -lt "$1" ]; do
      printf 'let run_%d = run ["sh" "-c" "${b%d}; echo EXIT:$?"]\nassert run_%d.out contains "EXIT:0" else "b%d did not exit 0"\n' "$i" "$i" "$i" "$i" >> "$2"
      i=$((i + 1))
    done
  }
  plant_blind "$blind_ceiling" "$pen/atblind.rish"
  [ "$(verdict "$pen/atblind.rish")" = every_needle_outlives_the_framing ] \
    && ok ratchet_blind_under_free || no ratchet_blind_under_free "a ratchet at its ceiling must pass free"
  plant_blind "$((blind_ceiling + 1))" "$pen/overblind.rish"
  [ "$(verdict "$pen/overblind.rish")" = answer_blind_rose ] \
    && ok ratchet_blind_over_refused || no ratchet_blind_over_refused "one blind run past the ceiling must refuse"

  # never_refused: a file-counted ceiling, so the pen plants whole files.
  i=0
  set --
  while [ "$i" -lt "$norefuse_ceiling" ]; do
    printf 'let run_x = run ["sh" "-c" "${b}; echo EXIT:$?"]\nassert run_x.out contains "EXIT:0" else "no refusal here"\n' > "$pen/nr$i.rish"
    set -- "$@" "$pen/nr$i.rish"
    i=$((i + 1))
  done
  [ "$(sh "$scan" report "$@" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" = every_needle_outlives_the_framing ] \
    && ok ratchet_norefuse_under_free || no ratchet_norefuse_under_free "files at the ceiling must pass free"
  printf 'let run_x = run ["sh" "-c" "${b}; echo EXIT:$?"]\nassert run_x.out contains "EXIT:0" else "no refusal here"\n' > "$pen/nrover.rish"
  [ "$(sh "$scan" report "$@" "$pen/nrover.rish" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" = never_refused_rose ] \
    && ok ratchet_norefuse_over_refused || no ratchet_norefuse_over_refused "one file past the ceiling must refuse"
fi

# --- a captured run nobody read is a gate, not a ratchet -------------------------------------------
[ "$(verdict "$pen/unread.rish")" = run_never_read ] \
  && ok unread_gated || no unread_gated "a captured run never asserted must refuse at zero"

if [ "$fails" -eq 0 ]; then
  echo "control=ok"
  exit 0
fi
echo "control=failed cases=$fails"
exit 1
