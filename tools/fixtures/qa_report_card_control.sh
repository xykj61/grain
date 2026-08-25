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

# 13 -- an index is read as one only when it DECLARES itself one AND MEASURES like one. Both halves
# planted, because a self-declared exemption is a door and a door beside a wall makes the wall a
# habit again. The declaration alone must not exempt, and the word count alone must not exempt.
# The planted links sit in a PROSE line rather than in bullets, because the reach reading
# skips list lines -- links inside bullets are never counted, so a bullet plant would pass
# against the old rule too and prove nothing. This mirrors docs/README.md, whose own header
# line carries five links in one sentence.
cat > "$pen/declared_short.md" <<'EOF'
# A routing page

**Kind:** crushed index of the rooms below

---

Rooms: [caravan](caravan.md) - [mycelium](mycelium.md) - [image](image.md) - [lotus](lotus.md)
EOF
o=$(run declared_short.md --setting door)
[ "$(val "$o" reach_mode)" = "index" ] && echo "declared_and_short_reads_index=yes" || echo "declared_and_short_reads_index=no ($(val "$o" reach_mode))"
[ "$(val "$o" reach)" -eq 100 ] && echo "index_density_reported=yes" || echo "index_density_reported=no ($(val "$o" reach))"
echo "$o" | grep -q 'reported, not scored' && echo "index_density_named=yes" || echo "index_density_named=no"

# A page that declares an index and carries real prose stays graded -- the floor is what keeps the
# declaration from being an exemption. docs-geode/edu/README.md is the live case: 193 words, A.
{
  echo "# A long routing page"
  echo
  echo "**Kind:** crushed index of everything here"
  echo
  echo "---"
  echo
  printf 'This page carries genuine prose about the rooms it names and it keeps going for long '
  printf 'enough that a reader can follow the argument it is making about them. It reaches '
  printf '[one](a.md) and [two](b.md) and [three](c.md) and [four](d.md) and [five](e.md) and it '
  printf 'reaches [six](f.md) and [seven](g.md) and [eight](h.md) and [nine](i.md) and also '
  printf '[ten](j.md) besides. The words here are ordinary words chosen so that the reading grade '
  printf 'stays low and the only thing the meter can object to is the density of the links that '
  printf 'this page carries through every one of its many sentences about the rooms it holds. '
  printf 'A reader who wants a room can find it here and a reader who wants the argument can read '
  printf 'it here as well, which is what makes this page prose rather than a bare index of names.\n'
} > "$pen/declared_long.md"
o=$(run declared_long.md --setting door)
[ "$(val "$o" reach_mode)" = "graded" ] && echo "declared_but_long_stays_graded=yes" || echo "declared_but_long_stays_graded=no ($(val "$o" reach_mode))"
[ "$(val "$o" reach)" -lt 100 ] && echo "declared_but_long_penalized=yes" || echo "declared_but_long_penalized=no ($(val "$o" reach))"

# A short page that declares nothing stays penalized: section 4's own 20-word probe, read again for
# its mode, so the floor alone can never become the exemption.
o=$(run linky.md --setting door)
[ "$(val "$o" reach_mode)" = "graded" ] && echo "undeclared_short_stays_graded=yes" || echo "undeclared_short_stays_graded=no ($(val "$o" reach_mode))"
[ "$(val "$o" reach)" -lt 100 ] && echo "undeclared_short_penalized=yes" || echo "undeclared_short_penalized=no ($(val "$o" reach))"

# The declaration is read in the HEADER alone, so a body that merely discusses indexes declares
# nothing and cannot smuggle an exemption past the rule.
cat > "$pen/body_only.md" <<'EOF'
# A page about indexes

**Status:** Living

---

This page talks about what a **Kind:** crushed index is and why routing pages exist at all.

- [one](a.md)
- [two](b.md)
EOF
o=$(run body_only.md --setting door)
echo "$o" | grep -q "declares_index=no" && echo "body_declaration_ignored=yes" || echo "body_declaration_ignored=no"
[ "$(val "$o" reach_mode)" = "graded" ] && echo "body_declaration_stays_graded=yes" || echo "body_declaration_stays_graded=no"

# Meter names its own mode rather than borrowing either of the other two.
[ "$(val "$(run cold.md --setting meter)" reach_mode)" = "meter" ] && echo "meter_names_its_mode=yes" || echo "meter_names_its_mode=no"

# 14 -- a placeholder shape is an illustration; a fabricated stamp is still a broken citation.
# .claude/rules/stamp-and-name.md seats both halves: build an illustration from placeholders and it
# stays honest, build one from a real-looking stamp naming no file and it reads as a real citation.
printf 'A page showing the shape [a folded room](date/YYYYMMDD/name) and nothing else at all.\n' > "$pen/shape.md"
o=$(run shape.md)
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "placeholder_costs_nothing=yes" || echo "placeholder_costs_nothing=no ($(val "$o" truth_counted))"
echo "$o" | grep -q 'illustration: date/YYYYMMDD/name' && echo "placeholder_named=yes" || echo "placeholder_named=no"
echo "$o" | grep -q '1 placeholder shapes read as illustrations' && echo "placeholder_counted=yes" || echo "placeholder_counted=no"
echo "$o" | grep -q '0 of 0 cited paths' && echo "placeholder_not_cited=yes" || echo "placeholder_not_cited=no"

printf 'A page showing the shape [a full name](date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.ext) and nothing more.\n' > "$pen/shape2.md"
[ "$(val "$(run shape2.md)" truth_counted)" -eq 100 ] && echo "hhmmss_placeholder_free=yes" || echo "hhmmss_placeholder_free=no"

printf 'A page citing [a log](session-logs/20260101-090000_nothing.kyri) and nothing else at all.\n' > "$pen/fabricated.md"
o=$(run fabricated.md)
[ "$(val "$o" truth_counted)" -eq 80 ] && echo "fabricated_stamp_still_counted=yes" || echo "fabricated_stamp_still_counted=no ($(val "$o" truth_counted))"
echo "$o" | grep -q 'unresolved: session-logs/20260101-090000_nothing.kyri' && echo "fabricated_stamp_named=yes" || echo "fabricated_stamp_named=no"

echo "control_verdict=ok"
