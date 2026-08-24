#!/bin/sh
# tools/fixtures/qa_report_card_control.sh -- prove the report card by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and a scale is exactly the kind of
# thing that looks right and is off by one at every boundary. This control plants prose in a
# throwaway pen and reads every letter boundary from both sides, so the scale is proven rather than
# eyeballed.
#
# USAGE
#   sh tools/fixtures/qa_report_card_control.sh
#
# Driven by tools/q/qa_report_card_witness.rish. Run from the repository root.

set -u

card=tools/fixtures/qa_report_card.sh
reg=tools/fixtures/prose_register_scan.sh
[ -f "$card" ] || { echo "control_verdict=card_missing" >&2; exit 1; }
[ -f "$reg" ] || { echo "control_verdict=register_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures"
cp "$card" "$pen/tools/fixtures/"
cp "$reg" "$pen/tools/fixtures/"

run() { ( cd "$pen" && QA_CARD_ROOT=. sh tools/fixtures/qa_report_card.sh "$@" 2>&1 ); }
val() { echo "$1" | sed -n "s/^$2=\([^ ]*\).*/\1/p" | head -1; }

# 1 -- the scale, at every boundary, from both sides. Eighteen readings, no minus grade anywhere.
scale_ok=yes
for pair in "100 A+" "97 A+" "96 A" "90 A" "89 B+" "85 B+" "84 B" "80 B" "79 C+" "75 C+" \
            "74 C" "70 C" "69 D+" "65 D+" "64 D" "60 D" "59 F" "0 F"; do
  n=${pair% *}; want=${pair#* }
  got=$(run --letter "$n")
  [ "$got" = "$want" ] || { scale_ok=no; echo "scale: $n read $got, wanted $want"; }
done
[ "$scale_ok" = yes ] && echo "scale_exact=yes" || echo "scale_exact=no"

minus=no
for n in 0 59 60 64 65 69 70 74 75 79 80 84 85 89 90 96 97 100; do
  case "$(run --letter "$n")" in *-) minus=yes ;; esac
done
[ "$minus" = no ] && echo "no_minus_grades=yes" || echo "no_minus_grades=no"

# 2 -- Register is the register scan's own reading, flipped. Warm prose high, refusal-led prose low.
cat > "$pen/warm.md" <<'EOF'
Grain gives you a computer that answers to you. Your words stay on your machine.
Every promise here is one a program has already checked. The system names each bound
before it starts, and it can show you it stayed inside. A witness prints green when a
promise holds. Every name we choose stays clear on the first day and the ten thousandth.
EOF
cat > "$pen/cold.md" <<'EOF'
A check that cannot fail is not a check. Nothing here is trusted until it refuses a
broken input. The guard was blind to an entire class and no meter caught the failure.
A stale claim is worse than a missing one, and a broken reference never resolves.
Nothing grows until something breaks, and no page may lie about what it cannot prove.
EOF
w=$(val "$(run warm.md --setting field)" register)
c=$(val "$(run cold.md --setting field)" register)
[ "$w" -ge 80 ] && echo "warm_register_high=yes" || echo "warm_register_high=no ($w)"
[ "$c" -le 40 ] && echo "cold_register_low=yes" || echo "cold_register_low=no ($c)"
[ "$w" -gt "$c" ] && echo "register_discriminates=yes" || echo "register_discriminates=no"

# 3 -- the flip is arithmetic on the register scan's own number, never a second measurement.
sed -n '/^measure() {/,/^}/p' "$pen/tools/fixtures/prose_register_scan.sh" > "$pen/measure.sh"
. "$pen/measure.sh"
set -- $(measure "$pen/cold.md")
[ "$c" -eq $((100 - $3)) ] && echo "register_is_the_flip=yes" || echo "register_is_the_flip=no ($c vs $((100 - $3)))"

# 4 -- Reach falls when the page reaches past its reader: link density over the Door budget.
cat > "$pen/linky.md" <<'EOF'
See [one](a.md) and [two](b.md) and [three](c.md) and [four](d.md) and [five](e.md) here.
See [six](f.md) and [seven](g.md) and [eight](h.md) and [nine](i.md) and [ten](j.md) here.
EOF
lr=$(val "$(run linky.md --setting door)" reach)
pr=$(val "$(run warm.md --setting door)" reach)
[ "$lr" -lt "$pr" ] && echo "reach_falls_on_links=yes" || echo "reach_falls_on_links=no ($lr vs $pr)"
[ "$lr" -lt 100 ] && echo "reach_under_full=yes" || echo "reach_under_full=no"

# 5 -- Meter carries no register or reach budget: refusal-first prose is the subject there.
m=$(run cold.md --setting meter)
[ "$(val "$m" register)" -eq 100 ] && echo "meter_register_free=yes" || echo "meter_register_free=no"
[ "$(val "$m" reach)" -eq 100 ] && echo "meter_reach_free=yes" || echo "meter_reach_free=no"

# 6 -- Truth counts a link that resolves nowhere, and leaves a resolving one alone.
printf 'A page citing [a real neighbour](warm.md) and nothing else at all here.\n' > "$pen/whole.md"
printf 'A page citing [a departed neighbour](gone.md) and nothing else at all here.\n' > "$pen/holed.md"
[ "$(val "$(run whole.md)" truth_counted)" -eq 100 ] && echo "resolving_link_free=yes" || echo "resolving_link_free=no"
[ "$(val "$(run holed.md)" truth_counted)" -eq 80 ] && echo "unresolved_link_counted=yes" || echo "unresolved_link_counted=no"
run holed.md | grep -q 'unresolved: gone.md' && echo "unresolved_named=yes" || echo "unresolved_named=no"

# 7 -- a dated reference whose room has folded resolves by the fold rule, never counted as gone.
mkdir -p "$pen/session-logs/date/20260701"
printf 'x\n' > "$pen/session-logs/date/20260701/20260701-120000_a-log.kyri"
printf 'A page citing [a folded log](session-logs/20260701-120000_a-log.kyri) and nothing else here.\n' > "$pen/folded.md"
[ "$(val "$(run folded.md)" truth_counted)" -eq 100 ] && echo "fold_rule_resolves=yes" || echo "fold_rule_resolves=no"

# 8 -- an http link is not a path this tree can resolve, and is never counted against Truth.
printf 'A page citing [the spec](https://example.invalid/x) and nothing else at all here.\n' > "$pen/web.md"
[ "$(val "$(run web.md)" truth_counted)" -eq 100 ] && echo "web_link_free=yes" || echo "web_link_free=no"

# 9 -- the composite is the mean of four, and the truth gate bites from both sides.
o=$(run warm.md --setting field --service 100 --truth 100)
[ "$(val "$o" composite)" -eq 100 ] && echo "composite_is_mean=yes" || echo "composite_is_mean=no ($(val "$o" composite))"
o=$(run warm.md --setting field --service 60 --truth 60)
[ "$(val "$o" letter)" = "B" ] && echo "mean_of_four_reads=yes" || echo "mean_of_four_reads=no ($(val "$o" letter))"
o=$(run warm.md --setting field --service 100 --truth 60)
[ "$(val "$o" truth_gate)" = "no" ] && echo "gate_holds_at_60=yes" || echo "gate_holds_at_60=no"
o=$(run warm.md --setting field --service 100 --truth 59)
[ "$(val "$o" truth_gate)" = "yes" ] && echo "gate_bites_at_59=yes" || echo "gate_bites_at_59=no"
[ "$(val "$o" letter)" = "F" ] && echo "gate_reads_F=yes" || echo "gate_reads_F=no"

# 10 -- without a judged Service the card refuses to invent a composite.
o=$(run warm.md --setting field)
echo "$o" | grep -q 'service=judged' && echo "service_left_judged=yes" || echo "service_left_judged=no"
echo "$o" | grep -q 'composite=judged' && echo "composite_left_judged=yes" || echo "composite_left_judged=no"
echo "$o" | grep -q 'service_inputs' && echo "service_inputs_reported=yes" || echo "service_inputs_reported=no"

# 11 -- the card refuses rather than reading zero over what it cannot open.
run absent.md >/dev/null 2>&1 && echo "absent_path_refused=no" || echo "absent_path_refused=yes"
run warm.md --setting sideways >/dev/null 2>&1 && echo "unknown_setting_refused=no" || echo "unknown_setting_refused=yes"

# 12 -- the register reading is CITED rather than copied: break the source and the card refuses.
cp "$pen/tools/fixtures/prose_register_scan.sh" "$pen/keep.sh"
grep -v '^measure() {' "$pen/keep.sh" > "$pen/tools/fixtures/prose_register_scan.sh"
run warm.md >/dev/null 2>&1 && echo "register_source_load_bearing=no" || echo "register_source_load_bearing=yes"
cp "$pen/keep.sh" "$pen/tools/fixtures/prose_register_scan.sh"

echo "control_verdict=ok"
