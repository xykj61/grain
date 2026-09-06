#!/bin/sh
# tools/fixtures/q/qa_report_card_control.sh -- prove the report card by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and a scale is exactly the kind of
# thing that looks right and is off by one at every boundary. This control plants prose in a
# throwaway pen and reads every letter boundary from both sides, so the scale is proven rather than
# eyeballed.
#
# USAGE
#   sh tools/fixtures/q/qa_report_card_control.sh
#
# Driven by tools/q/qa_report_card_witness.rish. Run from the repository root.

set -u

card=tools/fixtures/q/qa_report_card.sh
refblock=tools/fixtures/r/reference_block.awk
reg=tools/fixtures/p/prose_register_scan.sh
[ -f "$card" ] || { echo "control_verdict=card_missing" >&2; exit 1; }
[ -f "$reg" ] || { echo "control_verdict=register_missing" >&2; exit 1; }
[ -f "$refblock" ] || { echo "control_verdict=reference_block_missing" >&2; exit 1; }
# Everything the card cites, asked of the card rather than remembered here (REDS %405).
deps=$(sh "$card" --deps)

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
# The pen mirrors the folded letter rooms (letter fold, seated 20260828): the card sits at q/
# and lifts measure() from the register scan at p/, and reads the reference-block classifier
# beside itself at q/.
mkdir -p "$pen/tools/fixtures/q" "$pen/tools/fixtures/p"
cp "$card" "$pen/tools/fixtures/q/"
for d in $deps; do mkdir -p "$pen/$(dirname "$d")" && cp "$d" "$pen/$d"; done

run() { ( cd "$pen" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh "$@" 2>&1 ); }
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
# Both plants carry at least REGISTER_MIN_SENTENCES sentences, so the register reading SCORES
# them rather than reporting them. A plant under the floor would read 100 whatever it said,
# and this whole section would pass while testing nothing.
cat > "$pen/warm.md" <<'EOF'
Grain gives you a computer that answers to you. Your words stay on your machine.
Every promise here is one a program has already checked. The system names each bound
before it starts, and it can show you it stayed inside. A witness prints green when a
promise holds. Every name we choose stays clear on the first day and the ten thousandth.
The tree keeps its own record of every round it runs. A reader arriving today finds the
same doors a reader found last season. Each guard proves both directions of the
promise it makes. The work belongs to whoever runs it, and it stays that way.
EOF
cat > "$pen/cold.md" <<'EOF'
A check that cannot fail is not a check. Nothing here is trusted until it refuses a
broken input. The guard was blind to an entire class and no meter caught the failure.
A stale claim is worse than a missing one, and a broken reference never resolves.
Nothing grows until something breaks, and no page may lie about what it cannot prove.
No roster is trusted while it cannot refuse a wrong entry. A number nobody measured is
worse than no number at all. Nothing stops a stale page from lying about a dead path.
A wall with a door beside it is never a wall. No claim survives without a witness.
EOF
w=$(val "$(run warm.md --setting field)" register)
c=$(val "$(run cold.md --setting field)" register)
[ "$w" -ge 80 ] && echo "warm_register_high=yes" || echo "warm_register_high=no ($w)"
[ "$c" -le 40 ] && echo "cold_register_low=yes" || echo "cold_register_low=no ($c)"
[ "$w" -gt "$c" ] && echo "register_discriminates=yes" || echo "register_discriminates=no"

# 3 -- the flip is arithmetic on the register scan's own number, never a second measurement.
sed -n '/^measure() {/,/^}/p' "$pen/tools/fixtures/p/prose_register_scan.sh" > "$pen/measure.sh"
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

# 4b -- AND THE SAME TEN LINKS, MOVED OFF RUNNING PROSE, ARE INVISIBLE TO THAT BUDGET. Case 4 plants
# its links in two plain sentences, which is the one shape the density reading can see; it would pass
# unchanged if the reading counted nothing else. So the same ten are planted three more ways -- a
# list, a table, and a bold-key header line, which is how this tree writes nearly all of its
# citations -- and each is asserted to read zero, with `reach_links` naming what was held out.
# A blindness proven is a blindness a reader can act on; an unproven one reads exactly like reach
# (REDS %492).
cat > "$pen/listy.md" <<'EOF'
This page carries its citations the way a room index does, one to a line.

- [one](a.md) and [two](b.md)
- [three](c.md) and [four](d.md)
- [five](e.md) and [six](f.md)
- [seven](g.md) and [eight](h.md)
- [nine](i.md) and [ten](j.md)
EOF
cat > "$pen/tably.md" <<'EOF'
This page carries its citations in a table, the way a crushed index does.

| Page | Leads to |
|---|---|
| [one](a.md) | [two](b.md) |
| [three](c.md) | [four](d.md) |
| [five](e.md) | [six](f.md) |
| [seven](g.md) | [eight](h.md) |
| [nine](i.md) | [ten](j.md) |
EOF
cat > "$pen/heady.md" <<'EOF'
**Written from:** [one](a.md) - [two](b.md) - [three](c.md) - [four](d.md) - [five](e.md)
**Kin:** [six](f.md) - [seven](g.md) - [eight](h.md) - [nine](i.md) - [ten](j.md)

This page carries its citations in its header block, which is where this tree puts them.
EOF
blind_ok=yes
for plant in listy tably heady; do
  o=$(run "$plant.md" --setting door)
  seen=$(val "$o" reach_links)
  [ "$seen" = 0 ] || { blind_ok=no; echo "blind: $plant read $seen links in prose, wanted 0"; }
  echo "$o" | grep -q "reach_links=0 of 10 " \
    || { blind_ok=no; echo "blind: $plant did not report 10 links on the page"; }
done
[ "$blind_ok" = yes ] && echo "links_off_prose_unseen=yes" || echo "links_off_prose_unseen=no"

# The ceiling that case 4 proves bites cannot bite ANY of the three, which is the consequence.
lb=yes
for plant in listy tably heady; do
  [ "$(val "$(run "$plant.md" --setting door)" reach)" -eq 100 ] || lb=no
done
[ "$lb" = yes ] && echo "off_prose_links_never_cost_reach=yes" || echo "off_prose_links_never_cost_reach=no"

# And the report is arithmetic on the two counts rather than a third measurement of its own.
o=$(run linky.md --setting door)
rl_seen=$(val "$o" reach_links)
rl_all=$(echo "$o" | sed -n 's/^reach_links=[0-9]* of \([0-9]*\) .*/\1/p')
rl_held=$(echo "$o" | sed -n 's/^reach_links=.* (\([0-9]*\) held out.*/\1/p')
[ "$rl_all" = 10 ] && [ $((rl_seen + rl_held)) -eq "$rl_all" ] \
  && echo "reach_links_adds_up=yes" || echo "reach_links_adds_up=no ($rl_seen + $rl_held vs $rl_all)"

# THE LEG THAT TELLS THE REPORT FROM A DECORATION. The elder is the state this repair ended: the
# only link number a reader had was the one the density reading could see. It is built by giving the
# whole-page count the reach awk's own two line filters, so the card counts exactly what it could
# already count -- and `listy.md`, whose ten citations all sit on list lines, reads `0 of 0`. That
# reading is the fault in one line: no links seen, and none reported to have been held out.
mkdir -p "$pen/elderlinks/tools/fixtures/q" "$pen/elderlinks/tools/fixtures/p"
sed 's%{ n += gsub%/^[ \t]*[-*>#]/ { next } /^[ \t]*[|]/ { next } { n += gsub%' \
  "$pen/tools/fixtures/q/qa_report_card.sh" > "$pen/elderlinks/tools/fixtures/q/qa_report_card.sh"
for d in $deps; do mkdir -p "$pen/elderlinks/$(dirname "$d")" && cp "$d" "$pen/elderlinks/$d"; done
cp "$pen/listy.md" "$pen/elderlinks/"
el=$( ( cd "$pen/elderlinks" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh listy.md --setting door ) 2>&1 )
echo "$el" | grep -q "reach_links=0 of 0 " \
  && echo "filtered_count_reproduces_the_blindness=yes" \
  || echo "filtered_count_reproduces_the_blindness=no ($(echo "$el" | sed -n 's/^\(reach_links=[^(]*\).*/\1/p'))"

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
cp "$pen/tools/fixtures/p/prose_register_scan.sh" "$pen/keep.sh"
grep -v '^measure() {' "$pen/keep.sh" > "$pen/tools/fixtures/p/prose_register_scan.sh"
run warm.md >/dev/null 2>&1 && echo "register_source_load_bearing=no" || echo "register_source_load_bearing=yes"
cp "$pen/keep.sh" "$pen/tools/fixtures/p/prose_register_scan.sh"

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

# 14b -- a link inside a backtick span or a fenced block is not a link (seated 20260906.133800, the
# round the card's own elder note asked for by name). Markdown renders it as literal text, so it
# cites nothing and cannot be broken -- and every page that teaches the fold rule quotes the shape
# `](X)` inside backticks, where the elder reading took 20 points of Truth per quotation. Both
# halves are planted, because a mask that also hid a REAL link would be a way to stop being checked.
printf 'A page quoting the shape `](X)` and `](../../Y)` inside code marks and nothing else at all.\n' > "$pen/spanned.md"
o=$(run spanned.md)
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "code_span_link_costs_nothing=yes" || echo "code_span_link_costs_nothing=no ($(val "$o" truth_counted))"
echo "$o" | grep -q '0 of 0 cited paths' && echo "code_span_link_not_cited=yes" || echo "code_span_link_not_cited=no"

printf 'A page fencing a link.\n\n```\nsee [a thing](nowhere-at-all.md)\n```\n\nAnd nothing else at all.\n' > "$pen/fenced_link.md"
o=$(run fenced_link.md)
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "fenced_link_costs_nothing=yes" || echo "fenced_link_costs_nothing=no ($(val "$o" truth_counted))"

printf 'A page citing [a real absence](gone-for-good.md) in plain prose and nothing else at all.\n' > "$pen/plain_broken.md"
o=$(run plain_broken.md)
[ "$(val "$o" truth_counted)" -eq 80 ] && echo "plain_broken_still_counted=yes" || echo "plain_broken_still_counted=no ($(val "$o" truth_counted))"
echo "$o" | grep -q 'unresolved: gone-for-good.md' && echo "plain_broken_named=yes" || echo "plain_broken_named=no"

printf 'A page citing [the pin](REDS.md) beside a quoted `](X)` shape, and nothing else at all.\n' > "$pen/REDS.md"
printf 'A page citing [the pin](REDS.md) beside a quoted `](X)` shape, and nothing else at all.\n' > "$pen/mixed.md"
o=$(run mixed.md)
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "mixed_line_keeps_the_real_link=yes" || echo "mixed_line_keeps_the_real_link=no ($(val "$o" truth_counted))"
echo "$o" | grep -q '0 of 1 cited paths' && echo "mixed_line_cites_once=yes" || echo "mixed_line_cites_once=no"

# 15 -- the register floor, read from both sides at its own boundary. A share needs a denominator
# big enough to mean something, and the number is CITED from prose_register_scan.sh rather than
# spelled here, so one floor governs both readings and neither can drift.
floor=$(sed -n 's/^REGISTER_MIN_SENTENCES=\([0-9]*\)$/\1/p' "$pen/tools/fixtures/p/prose_register_scan.sh" | head -1)
[ "$floor" = "8" ] && echo "floor_is_cited=yes" || echo "floor_is_cited=no ($floor)"

# Seven refusal-led sentences, one under the floor: reported, never scored.
cat > "$pen/under_floor.md" <<'EOF'
A check that cannot fail is not a check. Nothing here is trusted until it refuses.
The guard was blind to a class and no meter caught the failure. A stale claim is
worse than a missing one. Nothing grows until something breaks. No roster is
trusted while it cannot refuse a wrong entry. A number nobody measured is worse
than no number at all.
EOF
# TWO CONDITIONS, NEVER ONE (REDS %430). Under the floor is where the argument STARTS, not where it
# ends: the reading is freed only where one sentence could still have carried the share across the
# ceiling, |share - ceiling| * n < 100. These seven sentences are 100% refusal-led against a 30%
# Field ceiling, seventy points away over seven sentences, so no single sentence put it there and it
# is scored. This leg read `reported` and `register=100` before the amendment -- an A-grade vote
# from a reading that measured nothing.
o=$(run under_floor.md --setting field)
[ "$(val "$o" register_floor_met)" = "no" ] && echo "under_floor_seen=yes" || echo "under_floor_seen=no ($(val "$o" register_floor_met))"
[ "$(val "$o" register_mode)" = "scored" ] && echo "under_floor_far_share_scored=yes" || echo "under_floor_far_share_scored=no ($(val "$o" register_mode))"
[ "$(val "$o" register)" -eq 0 ] && echo "under_floor_far_share_costs=yes" || echo "under_floor_far_share_costs=no ($(val "$o" register))"
echo "$o" | grep -q 'no single sentence could have carried this reading' && echo "under_floor_scored_explains=yes" || echo "under_floor_scored_explains=no"
echo "$o" | grep -q 'of 7 sentences' && echo "under_floor_share_still_shown=yes" || echo "under_floor_share_still_shown=no"

# THE SEATED REASONING, KEPT WHOLE. "One negative sentence out of one is a rounding error, not a
# register" -- at n=1 a share of 100 is still 80 points from the ceiling times one sentence, which
# is under 100, so it frees exactly as it always did. The amendment narrows the door; it does not
# move this case through it.
printf 'A guard that cannot fail guards nothing.\n' > "$pen/one_sentence.md"
o=$(run one_sentence.md --setting field)
[ "$(val "$o" register_floor_met)" = "no" ] && echo "one_sentence_under_floor=yes" || echo "one_sentence_under_floor=no"
[ "$(val "$o" register_mode)" = "reported" ] && echo "one_sentence_still_free=yes" || echo "one_sentence_still_free=no ($(val "$o" register_mode))"
[ "$(val "$o" register)" -eq 100 ] && echo "one_sentence_not_scored=yes" || echo "one_sentence_not_scored=no ($(val "$o" register))"
echo "$o" | grep -q 'reported, not scored' && echo "under_floor_named=yes" || echo "under_floor_named=no"

# AND THE MIDDLE, which is what makes this a rule rather than a headcount: under the floor, with a
# share NEAR the ceiling, still frees -- because there one sentence genuinely could have crossed it.
# Without this leg the amendment would be indistinguishable from "score everything past n=1".
cat > "$pen/near_ceiling.md" <<'EOF'
A witness binds a claim to a measurement. Every bound names its own maximum.
The roster reads what it can reach. A stamp orders and a name means.
No number is trusted without its unit.
EOF
o=$(run near_ceiling.md --setting field)
[ "$(val "$o" register_floor_met)" = "no" ] && echo "near_ceiling_under_floor=yes" || echo "near_ceiling_under_floor=no"
[ "$(val "$o" register_mode)" = "reported" ] && echo "near_ceiling_still_free=yes" || echo "near_ceiling_still_free=no ($(val "$o" register_mode))"

# The same prose with one more sentence, AT the floor: scored, and scored low. The boundary is read
# from both sides, so no page can sit at the floor and be treated as if it were under it.
cat > "$pen/at_floor.md" <<'EOF'
A check that cannot fail is not a check. Nothing here is trusted until it refuses.
The guard was blind to a class and no meter caught the failure. A stale claim is
worse than a missing one. Nothing grows until something breaks. No roster is
trusted while it cannot refuse a wrong entry. A number nobody measured is worse
than no number at all. No claim survives without a witness to bind it.
EOF
o=$(run at_floor.md --setting field)
[ "$(val "$o" register_mode)" = "scored" ] && echo "at_floor_scored=yes" || echo "at_floor_scored=no ($(val "$o" register_mode))"
[ "$(val "$o" register)" -le 40 ] && echo "at_floor_scored_low=yes" || echo "at_floor_scored_low=no ($(val "$o" register))"
echo "$o" | grep -q 'of 8 sentences' && echo "at_floor_denominator=yes" || echo "at_floor_denominator=no"

# Meter names its own register mode rather than borrowing either of the other two.
[ "$(val "$(run cold.md --setting meter)" register_mode)" = "meter" ] && echo "meter_names_register_mode=yes" || echo "meter_names_register_mode=no"

# The floor is CITED, so losing it from the source makes the card refuse rather than guess -- the
# same proof measure() already carries in section 12.
cp "$pen/tools/fixtures/p/prose_register_scan.sh" "$pen/keep2.sh"
grep -v '^REGISTER_MIN_SENTENCES=' "$pen/keep2.sh" > "$pen/tools/fixtures/p/prose_register_scan.sh"
run warm.md >/dev/null 2>&1 && echo "floor_source_load_bearing=no" || echo "floor_source_load_bearing=yes"
cp "$pen/keep2.sh" "$pen/tools/fixtures/p/prose_register_scan.sh"

# 16 -- Truth in a program reads comment lines, and a symlink's citations belong to its body.
mkdir -p "$pen/lib" "$pen/apps/one" "$pen/spec"
printf 'a spec\n' > "$pen/spec/a.md"
# The planted comment lines are written through printf rather than sat in a heredoc, because
# a heredoc line beginning `//!` IS a comment line in this file too, and its relative target
# resolves from the pen rather than from tools/fixtures. The guard was right to say so.
{ printf '%s\n' "//! Ground: [\`spec/a.md\`](../spec/a.md)"
  printf '%s\n' 'const row = "| [`x`](../../nowhere/at/all.md) |";'
  printf '%s\n' '//    y[2] = x[1](32000) + 3/4-y[1](-32768) = 7424.'
} > "$pen/lib/body.rye"
o=$(run lib/body.rye --setting meter)
[ "$(val "$o" truth_source)" = "comments" ] && echo "program_cites_in_comments=yes" || echo "program_cites_in_comments=no ($(val "$o" truth_source))"
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "program_body_truth_clean=yes" || echo "program_body_truth_clean=no ($(val "$o" truth_counted))"
echo "$o" | grep -q 'of 1 cited paths' && echo "code_and_math_left_out=yes" || echo "code_and_math_left_out=no"

# The same body reached through a second door. Read at the link's own path `../spec/a.md` lands in
# apps/spec and is broken; the card resolves the link and reads the citation from where it was
# written, which is what kept six correct files from being repaired into breakage on 20260825.
( cd "$pen/apps/one" && ln -sf ../../lib/body.rye body.rye )
o=$(run apps/one/body.rye --setting meter)
[ "$(val "$o" path_kind)" = "symlink" ] && echo "symlink_named=yes" || echo "symlink_named=no ($(val "$o" path_kind))"
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "symlink_reads_the_body=yes" || echo "symlink_reads_the_body=no ($(val "$o" truth_counted))"

# And resolving the link is a correction rather than an exemption: break the body and both doors say so.
printf '%s\n' "//! Ground: [\`spec/a.md\`](../../spec/a.md)" > "$pen/lib/body.rye"
[ "$(val "$(run lib/body.rye --setting meter)" truth_counted)" -eq 80 ] && echo "body_break_seen=yes" || echo "body_break_seen=no"
[ "$(val "$(run apps/one/body.rye --setting meter)" truth_counted)" -eq 80 ] && echo "body_break_seen_through_door=yes" || echo "body_break_seen_through_door=no"

# A prose file cites everywhere, headings and code lines alike -- a Markdown heading begins with `#`
# and would read as a comment mark, so the program rule is kept away from prose deliberately.
printf '# [a heading link](gone.md)\n\nAnd a plain sentence with four words.\n' > "$pen/heading.md"
o=$(run heading.md)
[ "$(val "$o" truth_source)" = "prose" ] && echo "prose_cites_everywhere=yes" || echo "prose_cites_everywhere=no"
[ "$(val "$o" truth_counted)" -eq 80 ] && echo "heading_link_still_counted=yes" || echo "heading_link_still_counted=no ($(val "$o" truth_counted))"

# 17 -- a page QUOTING link syntax inside backticks yields no citation. The link grep matches `](`
# straight through a backtick span, so a REDS row explaining a fold produced a "target" made of the
# prose between two spans. Zero tracked paths in this tree carry a backtick, so the rule is safe.
printf 'A regex rewriting every `](../` also caught the header %s `](../REDS.md)` in that row.\n' '' > "$pen/quoted.md"
o=$(run quoted.md)
[ "$(val "$o" truth_counted)" -eq 100 ] && echo "quoted_syntax_free=yes" || echo "quoted_syntax_free=no ($(val "$o" truth_counted))"
echo "$o" | grep -q 'of 0 cited paths' && echo "quoted_syntax_not_cited=yes" || echo "quoted_syntax_not_cited=no"

# And a real broken link on the same page still counts, so quoting is not a way to stop being read.
printf 'A regex rewriting every `](../` also caught `](../REDS.md)`, and [a departed page](gone-for-good.md) besides.\n' > "$pen/quoted_and_real.md"
o=$(run quoted_and_real.md)
[ "$(val "$o" truth_counted)" -eq 80 ] && echo "real_link_beside_quote_counted=yes" || echo "real_link_beside_quote_counted=no ($(val "$o" truth_counted))"
echo "$o" | grep -q 'unresolved: gone-for-good.md' && echo "real_link_beside_quote_named=yes" || echo "real_link_beside_quote_named=no"

# 18 -- a program's prose is whatever its own language marks as a comment, and Glow marks it `::`.
# The comment rule was written for `//` and `#` and left this tree's OWN notation out, so all 438
# tracked .glow files and the 8 .brush placards read zero words of prose. Zero words is not a low
# reading; it is no reading, and the card scored it anyway -- every file in the shape museum
# graded C+ 75 whatever it said (REDS %357). Both directions are proven here, because a mark the
# card knows and a mark it does not must read differently or the clause is decoration.
glow_placard() {
  printf '%s\n' "::  name       $1" \
    '::  shape      paths -- int (@u32)' \
    '::  invariant  a placard says what the shape is for before any rune' \
    '::  example    9' \
    '::  readers    the museum' \
    '::  nib        control-v0' \
    '::' \
    '::  A pedestal opens with six plain lines and then says why the number is that number. This' \
    '::  sentence is here so the reading has words to weigh, and it is written the way a visitor' \
    '::  would want to hear it read aloud in the room.'
}
glow_placard "known mark" > "$pen/desk.glow"
o=$(run desk.glow --setting field --service 100)
[ "$(val "$o" reach)" -gt 0 ] && echo "glow_prose_read=yes" || echo "glow_prose_read=no ($(val "$o" reach))"
echo "$o" | grep -q 'reach=.*[1-9][0-9]* words' && echo "glow_words_counted=yes" || echo "glow_words_counted=no"

# The same prose behind a mark the card does not know reads nothing, which is what the museum's
# whole room looked like until this clause landed.
glow_placard "unknown mark" | sed 's/^::/;;/' > "$pen/desk_unknown.glow"
o=$(run desk_unknown.glow --setting field --service 100)
# WHAT THIS LEG ASSERTS ON, AND WHY IT MOVED (REDS %407). Reading nothing is measured by the word
# count, and the card used to answer a zero word count with reach=0 -- the worst reading on the
# scale for a file it had not read at all. The grade floor retired that, so the leg now reads the
# words and the reported mode, which is what "the card saw nothing here" has always actually meant.
echo "$o" | grep -q 'reach=100 (grade 0 .*0 words, 0 links)' \
  && [ "$(val "$o" grade_mode)" = reported ] \
  && echo "unknown_mark_reads_nothing=yes" || echo "unknown_mark_reads_nothing=no ($(val "$o" reach))"

# And the clause reaches only lines that OPEN with the mark: `::` inside a sentence is prose, never
# a second comment head to strip.
printf '%s\n' '// A note whose sentence mentions a :: mark mid-line stays one whole sentence here.' > "$pen/midline.rye"
o=$(run midline.rye --setting field --service 100)
[ "$(val "$o" program_head_lines)" -eq 0 ] && echo "midline_unstripped=yes" || echo "midline_unstripped=no"
[ "$(val "$o" program_meter_lines)" -eq 0 ] && echo "midline_still_read=yes" || echo "midline_still_read=no"

# 19 -- a program carries its settings in its comment forms, never in the caller's word. The Door
# head stays readable while refusal-heavy invariant lines stay exact at Meter. Declaration docs
# are the third form in the grammar; the card reports them and assigns them to neither pole.
cat > "$pen/two_poles.rye" <<'EOF'
//! A small queue keeps ready work in a fixed array. A reader can learn its purpose here.
//! The module owns the capacity and reports when the queue is full.
//! Each item keeps its place until a caller removes it.
//! The public operations share one capacity declared below.
//! A caller receives a named error when the array is full.
//! The queue changes in one direction for each successful call.
//! Its tests can read the same state that production code changes.
//! This head tells a new reader what the module provides.
const std = @import("std");
/// Adds one item to the queue.
pub fn add() void {
    // invariant: no write may pass the fixed queue bound.
    // invariant: a full queue cannot accept another item.
}
EOF
door_program=$(run two_poles.rye --setting door --service 100)
field_program=$(run two_poles.rye --setting field --service 100)
meter_program=$(run two_poles.rye --setting meter --service 100)
door_letter=$(val "$door_program" letter)
[ "$door_letter" = "$(val "$field_program" letter)" ] \
  && [ "$door_letter" = "$(val "$meter_program" letter)" ] \
  && echo "program_setting_independent=yes" || echo "program_setting_independent=no"
[ "$(val "$door_program" program_head_lines)" -eq 8 ] \
  && echo "program_head_is_door=yes" || echo "program_head_is_door=no"
[ "$(val "$door_program" program_meter_lines)" -eq 2 ] \
  && echo "program_bounds_are_meter=yes" || echo "program_bounds_are_meter=no"
[ "$(val "$door_program" program_decl_lines)" -eq 1 ] \
  && echo "program_decl_reported=yes" || echo "program_decl_reported=no"
[ "$(val "$door_program" meter_register)" -eq 100 ] \
  && [ "$(val "$door_program" meter_reach)" -eq 100 ] \
  && echo "program_meter_unscored=yes" || echo "program_meter_unscored=no"

# Both poles are load-bearing. A hostile bound sentence must leave the Door reading unchanged, and
# a hostile module head must still lower it even when the caller asks for Meter.
cp "$pen/two_poles.rye" "$pen/bound_hostile.rye"
printf '%s\n' '    // invariant: no bound can fail and no fault may pass and nothing is accepted.' \
  >> "$pen/bound_hostile.rye"
hostile_bound=$(run bound_hostile.rye --setting door --service 100)
[ "$(val "$door_program" register)" -eq "$(val "$hostile_bound" register)" ] \
  && echo "program_meter_cannot_lower_door=yes" || echo "program_meter_cannot_lower_door=no"
sed 's/A small queue keeps/No small queue can keep/' "$pen/two_poles.rye" > "$pen/head_hostile.rye"
hostile_head=$(run head_hostile.rye --setting meter --service 100)
[ "$(val "$hostile_head" register)" -lt "$(val "$meter_program" register)" ] \
  && echo "program_door_still_scored=yes" || echo "program_door_still_scored=no"


# 8 -- a notation file's document is its comment block, and its records are data. Kyri and Bron
# open a comment with `#`, which the prose reading drops as a Markdown heading, and close a record
# with nothing at all, so consecutive records fuse into one pseudo-sentence rather than meeting the
# reading's under-four-words floor one at a time. Both halves are planted here, and both are read a
# second time through a card carrying the elder classifier, since a repair proven only in the
# passing direction cannot be told from a rewording.
cat > "$pen/roster_warm.kyri" <<'EOF'
# roster_warm.kyri -- the standing guards, as a list a program can read.
#
# WHY THIS FILE EXISTS. A roster names each guard the tree runs, so the list can be counted and
# dated rather than trusted. Each row carries the path a runner invokes and the clock it runs on.
# A reader arriving today finds the same rows a reader found last season, and each row says plainly
# what it stands for. The tree keeps its own record of every round it runs.
# WHAT A ROW MEANS. One record per standing check, naming the path, the tier, and the stamp it was
# seated. A guard names its own clock, so a choir sings on a slower one and still gets heard.
# HOW IT IS KEPT HONEST. The witness proves every path exists and every recited count matches.
format roster-v1
stamp 20260831.100000
voice Kyri
EOF
i=0
while [ $i -lt 30 ]; do
  printf 'guard example_%s\npath tools/e/example_%s.rish\ntier lap\nstamp 20260831.100000\n' "$i" "$i" >> "$pen/roster_warm.kyri"
  i=$((i + 1))
done
sed 's/^# WHY THIS FILE EXISTS\. A roster names each guard the tree runs, so the list can be counted and/# WHY THIS FILE EXISTS. No roster can be trusted, and nothing here is safe from error, so the list/; s/^# dated rather than trusted\. Each row carries the path a runner invokes and the clock it runs on\./# fails or breaks without it. Each row is wrong or missing until a guard refuses the broken one./; s/^# A reader arriving today finds the same rows a reader found last season, and each row says plainly/# A reader who cannot follow it is lost, and a stale row is worse than no row, never useful./; s/^# what it stands for\. The tree keeps its own record of every round it runs\./# Nothing is proven and no claim is safe, so a missing witness is a broken promise, not a risk./' \
  "$pen/roster_warm.kyri" > "$pen/roster_cold.kyri"

warm_notation=$(run roster_warm.kyri --setting field --service 100)
cold_notation=$(run roster_cold.kyri --setting field --service 100)

[ "$(val "$cold_notation" register_mode)" = scored ] \
  && [ "$(val "$cold_notation" register)" -lt 100 ] \
  && echo "notation_comment_read=yes" || echo "notation_comment_read=no"
[ "$(val "$warm_notation" register)" -gt "$(val "$cold_notation" register)" ] \
  && echo "notation_register_discriminates=yes" || echo "notation_register_discriminates=no"
[ "$(val "$warm_notation" notation_comment_lines)" -eq 9 ] \
  && [ "$(val "$warm_notation" notation_record_lines)" -eq 123 ] \
  && echo "notation_counts_reported=yes" || echo "notation_counts_reported=no"

# Records are data: two hundred more of them must move neither the sentence count nor the grade.
cp "$pen/roster_warm.kyri" "$pen/roster_long.kyri"
i=0
while [ $i -lt 50 ]; do
  printf 'guard filler_%s\npath tools/f/filler_%s.rish\ntier cadence\nstamp 20260831.100000\n' "$i" "$i" >> "$pen/roster_long.kyri"
  i=$((i + 1))
done
long_notation=$(run roster_long.kyri --setting field --service 100)
warm_sent=$(echo "$warm_notation" | sed -n 's/^register=[0-9]* (negative [0-9]*% of \([0-9]*\) sentences.*/\1/p')
long_sent=$(echo "$long_notation" | sed -n 's/^register=[0-9]* (negative [0-9]*% of \([0-9]*\) sentences.*/\1/p')
warm_grade=$(echo "$warm_notation" | sed -n 's/^reach=[0-9]* (grade \([0-9]*\).*/\1/p')
long_grade=$(echo "$long_notation" | sed -n 's/^reach=[0-9]* (grade \([0-9]*\).*/\1/p')
[ "$warm_sent" = "$long_sent" ] && [ "$warm_grade" = "$long_grade" ] \
  && echo "notation_records_are_data=yes" || echo "notation_records_are_data=no"

# 8b -- WHICH SETTING A NOTATION TAKES, decided by its own grammar rather than by the typed word.
# Meter sets register and reach both to 100, so a file it frees has a composite fixed by Truth and
# Service alone -- the same number whatever it says. That is right where the file is all record and
# wrong where a document stands, and a notation file wears the difference in its comment lines.
meter_documented=$(run roster_cold.kyri --setting meter --service 100)
[ "$(val "$meter_documented" register_mode)" = scored ] \
  && [ "$(val "$meter_documented" register)" -lt 100 ] \
  && echo "notation_document_refuses_meter=yes" || echo "notation_document_refuses_meter=no"
[ "$(val "$meter_documented" qa_setting)" = field ] \
  && echo "notation_refused_meter_falls_to_field=yes" || echo "notation_refused_meter_falls_to_field=no"

# The typed word must not be able to move the reading, which is the whole point of taking the
# setting from the grammar. Meter and field read the same bytes to the same letter.
[ "$(val "$meter_documented" composite)" = "$(val "$cold_notation" composite)" ] \
  && [ "$(val "$meter_documented" letter)" = "$(val "$cold_notation" letter)" ] \
  && echo "notation_meter_cannot_lift_field=yes" || echo "notation_meter_cannot_lift_field=no"

# The refusal names itself, so a reader knows which half of the grammar answered.
echo "$meter_documented" | grep -q '^notation_meter=refused' \
  && echo "notation_meter_refusal_named=yes" || echo "notation_meter_refusal_named=no"

# A record's VALUE is prose when it is prose. A log-shaped plant carries no comment block at all,
# and its long fields must still be read rather than dropped with the short ones.
cat > "$pen/log_shaped.kyri" <<'EOF'
format session-log-v1
stamp 20260831.100000
voice Kyri
title the reading that found its prose
obs THE CARD READS A NOTATION FILE BY ITS OWN GRAMMAR NOW. A comment line gives up its sigil and a
obs record line closes with a period, so a short field falls under the four-word floor by itself.
obs THE SAME BYTES READ THE SAME NUMBER WHERE THE GRAMMAR AGREES. A document keeps every reading it
obs already had, and a program keeps its head and its bounds exactly where the split put them.
obs A LONG FIELD IS PROSE AND STAYS READ. The record carries the sentence, so the sentence is read.
obs THE SHORT FIELDS LEAVE THE READING RATHER THAN JOINING IT. A stamp is data and reads as data.
obs EVERY ROW HERE CARRIES ENOUGH WORDS TO CLEAR THE FLOOR THE REGISTER SCAN ALREADY PUBLISHES.
obs THE FLOOR IS EIGHT SENTENCES AND THIS PLANT CARRIES MORE THAN EIGHT OF THEM ON PURPOSE.
obs A PLANT UNDER THE FLOOR WOULD READ ONE HUNDRED WHATEVER IT SAID AND PROVE NOTHING AT ALL.
recommend keep-going the reading now measures the half of the file that carries the argument
EOF
log_notation=$(run log_shaped.kyri --setting field --service 100)
[ "$(val "$log_notation" register_mode)" = scored ] \
  && [ "$(val "$log_notation" notation_comment_lines)" -eq 0 ] \
  && echo "notation_fields_still_read=yes" || echo "notation_fields_still_read=no"

# The other half of the grammar. A record-only notation -- a session log, a data corpus -- carries
# no document at all, so Meter is exactly right for it and the free pass stands. Measured 20260831:
# 3,983 of 4,090 tracked notation files are on this side, 3,928 of them session logs, which
# .claude/rules/session-logs.md already seats at Meter. Freeing what has nothing to read is the
# same judgement as refusing what does.
meter_record_only=$(run log_shaped.kyri --setting meter --service 100)
[ "$(val "$meter_record_only" register)" -eq 100 ] \
  && [ "$(val "$meter_record_only" reach)" -eq 100 ] \
  && [ "$(val "$meter_record_only" register_mode)" = meter ] \
  && echo "notation_record_only_keeps_meter=yes" || echo "notation_record_only_keeps_meter=no"
echo "$meter_record_only" | grep -q '^notation_meter=free' \
  && echo "notation_free_pass_named=yes" || echo "notation_free_pass_named=no"

# THE LEG THAT TELLS A REPAIR FROM A REWORDING. A card carrying the elder meter test -- one that
# asked only whether the artifact was a program -- freed the documented roster too, so warm and
# cold rosters both read the SAME composite there whatever their prose said. Measured on the tree
# 20260831: all nineteen notation files carrying 200 words or more of comment prose read exactly 94
# at Meter with Service at 75, one number across nineteen different inputs.
mkdir -p "$pen/eldermeter/tools/fixtures/q" "$pen/eldermeter/tools/fixtures/p"
sed 's/^if \[ "\$artifact_kind" = notation \] \&\& \[ "\$setting" = meter \]; then$/if false; then/' \
  "$pen/tools/fixtures/q/qa_report_card.sh" > "$pen/eldermeter/tools/fixtures/q/qa_report_card.sh"
for d in $deps; do mkdir -p "$pen/eldermeter/$(dirname "$d")" && cp "$d" "$pen/eldermeter/$d"; done
cp "$pen/roster_warm.kyri" "$pen/roster_cold.kyri" "$pen/eldermeter/"
eldermeter() { ( cd "$pen/eldermeter" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh "$@" 2>&1 ); }
em_warm=$(eldermeter roster_warm.kyri --setting meter --service 100)
em_cold=$(eldermeter roster_cold.kyri --setting meter --service 100)
[ "$(val "$em_warm" composite)" = "$(val "$em_cold" composite)" ] \
  && [ "$(val "$em_cold" register)" -eq 100 ] \
  && echo "notation_elder_meter_was_constant=yes" || echo "notation_elder_meter_was_constant=no"
[ "$(val "$meter_documented" composite)" != "$(val "$em_cold" composite)" ] \
  && echo "notation_meter_repair_bites=yes" || echo "notation_meter_repair_bites=no"

# The elder classifier, carried back into a copy of the card. It sent a notation file down the
# prose path, where no extractor runs, so the whole comment block was invisible: warm and cold must
# read IDENTICALLY there. This is the leg that tells a repair from a rewording.
mkdir -p "$pen/elder/tools/fixtures/q" "$pen/elder/tools/fixtures/p"
sed 's/^  \*\.bron|\*\.kyri)             artifact_kind=notation ;;$/  *.bron|*.kyri)             artifact_kind=prose ;;/' \
  "$pen/tools/fixtures/q/qa_report_card.sh" > "$pen/elder/tools/fixtures/q/qa_report_card.sh"
for d in $deps; do mkdir -p "$pen/elder/$(dirname "$d")" && cp "$d" "$pen/elder/$d"; done
cp "$pen/roster_warm.kyri" "$pen/roster_cold.kyri" "$pen/elder/"
elder() { ( cd "$pen/elder" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh "$@" 2>&1 ); }
elder_warm=$(elder roster_warm.kyri --setting field --service 100)
elder_cold=$(elder roster_cold.kyri --setting field --service 100)
[ "$(val "$elder_warm" register)" = "$(val "$elder_cold" register)" ] \
  && [ "$(val "$elder_warm" composite)" = "$(val "$elder_cold" composite)" ] \
  && echo "notation_elder_was_blind=yes" || echo "notation_elder_was_blind=no"
elder_sent=$(echo "$elder_warm" | sed -n 's/^register=[0-9]* (negative [0-9]*% of \([0-9]*\) sentences.*/\1/p')
[ "$elder_sent" = 1 ] && echo "notation_elder_read_one_sentence=yes" || echo "notation_elder_read_one_sentence=no"

# 20 -- A TABLE IS NOT A PARAGRAPH. Both counted readings are computed over SENTENCES, and a
# reference table has none: this tree writes its key lists without terminal punctuation, so a run of
# them merges into whatever sentence abuts it and the card weighs the head as if it held a handful
# of enormous ones. Twenty-eight such lines moved one real scan from C 74 to A 91 with its content
# unchanged -- seventeen composite points of punctuation (REDS %397).
#
# The crux is the first pair, and it is one paragraph read twice: the SAME prose must read the SAME
# grade whether or not a punctuation-free table sits beside it.
para='# A queue keeps ready work in a fixed array, and a reader learns its purpose here.
# The module owns the capacity and reports plainly when the queue is full.
# Each item keeps its place until a caller removes it, in the order it arrived.
# The public operations share one capacity, declared beside the array below.
# A caller receives a named error the moment the array has no room left.
# The queue moves in one direction for each call that succeeds.
# Its tests read the same state that the production path changes.
# This head tells a new reader what the module provides, and stops there.'
table='#
#   ready          how many items the queue holds right now, before any caller has been answered
#   capacity       the fixed ceiling the array was built with, declared once beside the array
#   accepted       items the queue took in, counted since the last reset of the counters
#   refused        items turned away because the array had no room left for another one
#   high_water     the largest depth the queue reached across the whole run, kept for tuning
#   resets         how many times a caller cleared the queue and started the counters again
#   waiters        callers parked until room appears, counted at the moment of the reading
#   drained        whether the queue emptied at least once since the counters were last reset'

printf '%s\n' "$para" > "$pen/plain.rye"
printf '%s\n%s\n' "$para" "$table" > "$pen/tabled.rye"
plain=$(run plain.rye --service 100)
tabled=$(run tabled.rye --service 100)
[ "$(val "$plain" register)" = "$(val "$tabled" register)" ] \
  && [ "$(val "$plain" reach)" = "$(val "$tabled" reach)" ] \
  && echo "table_leaves_prose_unmoved=yes" \
  || echo "table_leaves_prose_unmoved=no ($(val "$plain" register)/$(val "$plain" reach) vs $(val "$tabled" register)/$(val "$tabled" reach))"
[ "$(val "$plain" reference_lines)" -eq 0 ] && echo "paragraph_holds_no_table=yes" || echo "paragraph_holds_no_table=no"
[ "$(val "$tabled" reference_lines)" -eq 8 ] && echo "table_counted=yes" || echo "table_counted=no ($(val "$tabled" reference_lines))"
echo "$tabled" | grep -q '^reference_lines=8 ' && echo "table_named=yes" || echo "table_named=no"

# And the hold-out is what does the work rather than the plant being harmless. One token of the
# classifier's own threshold is mutated in the pen so no block ever forms -- which is the card as it
# read before this repair -- and the SAME two files then disagree by ten register and thirty reach.
# A pass proven only in the passing direction cannot be told from a reading that does nothing.
sed 's/if (entries >= 2)/if (entries >= 99999)/' \
  "$pen/tools/fixtures/r/reference_block.awk" > "$pen/blind.awk"
mv "$pen/tools/fixtures/r/reference_block.awk" "$pen/keep.awk"
cp "$pen/blind.awk" "$pen/tools/fixtures/r/reference_block.awk"
bp=$(run plain.rye --service 100)
bt=$(run tabled.rye --service 100)
mv "$pen/keep.awk" "$pen/tools/fixtures/r/reference_block.awk"
[ "$(val "$bp" reach)" -gt "$(val "$bt" reach)" ] \
  && [ "$(val "$bp" register)" -gt "$(val "$bt" register)" ] \
  && echo "hold_out_load_bearing=yes" \
  || echo "hold_out_load_bearing=no ($(val "$bp" register)/$(val "$bp" reach) vs $(val "$bt" register)/$(val "$bt" reach))"

# ONE entry is not a block. A single double-spaced line is far more often prose than a table, and
# holding a lone line out would quietly shrink a page's measured prose. Both sides on one shape:
# one entry is read as prose, and the second entry makes both a block.
printf '%s\n#\n#   ready      how many items the queue holds right now\n' "$para" > "$pen/one_entry.rye"
o=$(run one_entry.rye --service 100)
[ "$(val "$o" reference_lines)" -eq 0 ] && echo "lone_entry_stays_prose=yes" || echo "lone_entry_stays_prose=no ($(val "$o" reference_lines))"
printf '%s\n#\n#   ready      how many items the queue holds right now\n#   capacity   the fixed ceiling the array was built with\n' "$para" > "$pen/two_entry.rye"
o=$(run two_entry.rye --service 100)
[ "$(val "$o" reference_lines)" -eq 2 ] && echo "two_entries_make_a_block=yes" || echo "two_entries_make_a_block=no ($(val "$o" reference_lines))"

# A wrapped description rides with the entry that opened it, since a line indented past the key
# column is the same row carrying on. Without this the run breaks at every wrap: fourteen real
# entries in tools/fixtures/t/tool_path_scan.sh read as three lone lines before it was written.
printf '%s\n#\n#   ready      how many items the queue holds right now, counted before any caller\n#              has been answered, so a reader sees the depth rather than the throughput\n#   capacity   the fixed ceiling the array was built with\n' "$para" > "$pen/wrapped.rye"
o=$(run wrapped.rye --service 100)
[ "$(val "$o" reference_lines)" -eq 3 ] && echo "continuation_rides_along=yes" || echo "continuation_rides_along=no ($(val "$o" reference_lines))"

# A blank line ends a block, because a blank line is how this tree ends a table. Two entries with a
# blank between them are two lone lines, and a lone line stays prose.
printf '%s\n#\n#   ready      how many items the queue holds right now\n#\n#   capacity   the fixed ceiling the array was built with\n' "$para" > "$pen/split.rye"
o=$(run split.rye --service 100)
[ "$(val "$o" reference_lines)" -eq 0 ] && echo "blank_ends_a_block=yes" || echo "blank_ends_a_block=no ($(val "$o" reference_lines))"

# Entries at different key columns are different tables, never one block.
printf '%s\n#\n#   ready      how many items the queue holds right now\n#       capacity   the fixed ceiling the array was built with\n' "$para" > "$pen/uneven.rye"
o=$(run uneven.rye --service 100)
[ "$(val "$o" reference_lines)" -eq 0 ] && echo "key_column_binds_a_block=yes" || echo "key_column_binds_a_block=no ($(val "$o" reference_lines))"

# A prose file is read the same way. Measured 20260831: exactly one living non-dated prose file of
# 1,503 carries a reference block at all -- template-manifest.bron, whose every line reads
# `template  <path>  # why` -- so this clause is written for the genre rather than for a population.
printf 'This page explains one small thing and then shows the keys it uses.\n\n    ready      how many items the queue holds right now\n    capacity   the fixed ceiling the array was built with\n' > "$pen/doc.md"
o=$(run doc.md --setting field --service 100)
[ "$(val "$o" reference_lines)" -eq 2 ] && echo "prose_table_held_out=yes" || echo "prose_table_held_out=no ($(val "$o" reference_lines))"

# A fenced block is left alone. Both readings already skip a fence, so reaching in would move no
# grade and would only inflate the count the card prints.
printf 'This page shows a listing inside a fence, which both readings already read past.\n\n```\n  ready      how many items the queue holds right now\n  capacity   the fixed ceiling the array was built with\n```\n' > "$pen/fenced.md"
o=$(run fenced.md --setting field --service 100)
[ "$(val "$o" reference_lines)" -eq 0 ] && echo "fence_left_alone=yes" || echo "fence_left_alone=no ($(val "$o" reference_lines))"

# And the reading is CITED rather than spelled beside the card, the same discipline measure() and
# the register floor already keep: losing the classifier refuses rather than guessing a zero.
mv "$pen/tools/fixtures/r/reference_block.awk" "$pen/reference_block.away"
o=$(run tabled.rye --service 100)
mv "$pen/reference_block.away" "$pen/tools/fixtures/r/reference_block.awk"
echo "$o" | grep -q 'reference reading is missing' && echo "reference_source_load_bearing=yes" || echo "reference_source_load_bearing=no"

# 21 -- the card names what it reads, and the naming is proven by building a pen from nothing else.
# Two pens went quiet in one lap when the card gained a second citation: the citation guard's, and
# this control's own elder-card leg. Neither was wrong when it was written; each held a copy of a
# list that had moved (REDS %405). So the list lives beside the code and a pen asks for it, and this
# case is what keeps the answer honest -- a third citation added without a line in `--deps` fails
# here, on the lap that adds it, rather than in whichever guard happens to run next.
deps_pen=$(mktemp -d)
mkdir -p "$deps_pen/tools/fixtures/q"
cp "$card" "$deps_pen/tools/fixtures/q/"
for d in $deps; do mkdir -p "$deps_pen/$(dirname "$d")" && cp "$d" "$deps_pen/$d"; done
printf '%s\n' '# A queue keeps ready work in a fixed array, and a reader learns its purpose here.' \
  '# The module owns the capacity and reports plainly when the queue is full.' \
  '# Each item keeps its place until a caller removes it, in the order it arrived.' \
  '# A caller receives a named error the moment the array has no room left.' > "$deps_pen/probe.rye"
deps_out=$( cd "$deps_pen" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh probe.rye --service 100 2>&1 )
rm -rf "$deps_pen"
[ "$(val "$deps_out" letter)" != "" ] && echo "deps_list_is_complete=yes" \
  || echo "deps_list_is_complete=no ($deps_out)"
[ "$(echo "$deps" | wc -l | tr -d ' ')" -ge 2 ] && echo "deps_list_is_named=yes" || echo "deps_list_is_named=no"
for d in $deps; do [ -f "$d" ] || { echo "deps_list_resolves=no ($d)"; deps_bad=1; }; done
[ "${deps_bad:-0}" = 0 ] && echo "deps_list_resolves=yes"

# 8c -- THE GRADE TERM CARRIES THE FLOOR THE REGISTER READING ALREADY HOLDS (REDS %407). A reading
# grade is two rates, words per sentence and syllables per word, so it needs a denominator the same
# way a share does -- and the card checked that denominator for one scored reading and not the
# other. Measured 20260831 over 385 sampled artifacts: 207 sat under the floor and 137 of them took
# a scored Reach below 100 anyway, 17 of those carrying no prose at all and reading reach=0.
#
# The plants below press on both sides of the floor and on both terms, because the grade term and
# the cross-reference term are freed by different doors on purpose.
cat > "$pen/hex_corpus.bron" <<'EOF'
format cord-dag-v1
block 174d54c6d3de2d3bba9d1d089ec807b039a24e79357bf2570d622338c10f8a6b553ee95ee6e69cc2486c7bbd1875477247542c4622a36a8e4fe8f5af4480c10c 0 1 100 - a6624a7b97068874da0f3534fd9585ba34a280466bce20e2a8eceeebf4e6ec654fedafcbe147fd26b310ab6da5996d40761ceedc79c1edda239ce388691d3003
block 174d54c6d3de2d3bba9d1d089ec807b039a24e79357bf2570d622338c10f8a6b553ee95ee6e69cc2486c7bbd1875477247542c4622a36a8e4fe8f5af4480c10c 1 1 100 - a6624a7b97068874da0f3534fd9585ba34a280466bce20e2a8eceeebf4e6ec654fedafcbe147fd26b310ab6da5996d40761ceedc79c1edda239ce388691d3003
block 174d54c6d3de2d3bba9d1d089ec807b039a24e79357bf2570d622338c10f8a6b553ee95ee6e69cc2486c7bbd1875477247542c4622a36a8e4fe8f5af4480c10c 2 1 100 - a6624a7b97068874da0f3534fd9585ba34a280466bce20e2a8eceeebf4e6ec654fedafcbe147fd26b310ab6da5996d40761ceedc79c1edda239ce388691d3003
block 174d54c6d3de2d3bba9d1d089ec807b039a24e79357bf2570d622338c10f8a6b553ee95ee6e69cc2486c7bbd1875477247542c4622a36a8e4fe8f5af4480c10c 3 1 100 - a6624a7b97068874da0f3534fd9585ba34a280466bce20e2a8eceeebf4e6ec654fedafcbe147fd26b310ab6da5996d40761ceedc79c1edda239ce388691d3003
block 174d54c6d3de2d3bba9d1d089ec807b039a24e79357bf2570d622338c10f8a6b553ee95ee6e69cc2486c7bbd1875477247542c4622a36a8e4fe8f5af4480c10c 4 1 100 - a6624a7b97068874da0f3534fd9585ba34a280466bce20e2a8eceeebf4e6ec654fedafcbe147fd26b310ab6da5996d40761ceedc79c1edda239ce388691d3003
EOF
hex=$(run hex_corpus.bron --setting field --service 100)
[ "$(val "$hex" grade_mode)" = reported ] \
  && [ "$(val "$hex" reach)" -eq 100 ] \
  && echo "grade_floor_frees_the_corpus=yes" || echo "grade_floor_frees_the_corpus=no ($(val "$hex" reach))"

# The number is still PRINTED, exactly as the register reading prints a share it declined to score.
# A free pass that hides its own reading teaches a reader nothing.
echo "$hex" | grep -q 'grade [0-9]* against [0-9]* reported, not scored' \
  && echo "grade_floor_names_the_grade=yes" || echo "grade_floor_names_the_grade=no"

# A file with NOTHING to read cannot be unreadable. Every field here sits under the four-word floor,
# so no sentence survives to be measured and both overages are zero.
cat > "$pen/empty_prose.kyri" <<'EOF'
format cord-dag-v1
parent caad12b54ff58719
parent 528cde6b1772d1fe
block 5f671329
EOF
empty=$(run empty_prose.kyri --setting field --service 100)
[ "$(val "$empty" reach)" -eq 100 ] \
  && echo "$empty" | grep -q 'reach=100 (grade 0 .* 0 words, 0 links)' \
  && echo "empty_prose_reads_full=yes" || echo "empty_prose_reads_full=no ($(val "$empty" reach))"

# The two scored readings now answer the same denominator question the same way, which is the whole
# of the fault: one card, one prose_path, two readings disagreeing about whether there was enough
# prose to measure.
# Read on the FLOOR FINDING rather than on the mode, since REDS %430 gave the register a second
# question the grade reading does not ask. The fault this leg was written for is untouched: one
# card, one prose_path, and both readings must still agree about whether there was prose to measure.
[ "$(val "$empty" register_floor_met)" = "no" ] \
  && [ "$(val "$empty" grade_mode)" = "reported" ] \
  && [ "$(val "$hex" register_floor_met)" = "no" ] \
  && [ "$(val "$hex" grade_mode)" = "reported" ] \
  && echo "floors_agree_across_readings=yes" || echo "floors_agree_across_readings=no"

# THE PRESERVATION LEG, and the one that keeps the floor from becoming an exemption. Prose that
# clears the floor is graded exactly as before, and a hard page is still penalized for being hard.
cat > "$pen/long_hard.md" <<'EOF'
The instrumentation subsystem's heterogeneous reconciliation methodology necessitates
comprehensive architectural reconsideration throughout the interdependent modules.
Organizational infrastructure modernization presupposes substantial methodological
realignment across every participating administrative constituency involved here.
Consequently the aforementioned reconciliation apparatus demonstrates considerable
operational inefficiency whenever computational resources become disproportionately
constrained. Institutional documentation requirements invariably accompany such
comprehensive reorganizational undertakings within contemporary engineering practice.
Additionally the corresponding verification procedures demand extraordinary diligence
from participating implementation specialists throughout the transitional interval.
Notwithstanding these considerations the underlying architectural presuppositions
remain fundamentally unaltered by the reconciliation methodology described above.
Furthermore the interdependent configuration parameters necessitate individualized
reconsideration whenever organizational circumstances demonstrably deteriorate.
Simultaneously the accompanying instrumentation continues generating substantial
quantities of intermediate diagnostic material requiring subsequent interpretation.
Comparatively equivalent methodologies demonstrate indistinguishable characteristics
under experimentally comparable operational circumstances throughout the interval.
Nevertheless the architectural reconsideration remains provisionally incomplete until
supplementary verification procedures accompany every participating implementation.
Ultimately the reconciliation methodology accommodates considerable heterogeneity
without compromising the interdependent architectural presuppositions established.
EOF
hard=$(run long_hard.md --setting door --service 100)
[ "$(val "$hard" grade_mode)" = scored ] \
  && [ "$(val "$hard" reach)" -lt 100 ] \
  && echo "long_prose_still_graded=yes" || echo "long_prose_still_graded=no ($(val "$hard" grade_mode)/$(val "$hard" reach))"

# THE OTHER TERM IS UNTOUCHED, which is what lets this floor land without reopening the index door's
# own decision. linky.md is section 4's twenty-word probe: undeclared and short, so its grade is
# freed and its link density is still scored. A page that declares nothing still cannot buy relief
# from a rate it genuinely exceeds.
linky=$(run linky.md --setting door --service 100)
[ "$(val "$linky" grade_mode)" = reported ] \
  && [ "$(val "$linky" reach)" -lt 100 ] \
  && echo "link_penalty_survives_the_floor=yes" || echo "link_penalty_survives_the_floor=no ($(val "$linky" reach))"

# THE LEG THAT TELLS A REPAIR FROM A REWORDING, built by carrying the elder reading back into a copy
# of the card. Two lines make the elder: the floor condition, and the empty exit whose first field
# WAS the reach itself rather than the grade overage. With both restored, the corpus reads zero and
# the empty file reads zero -- the readings this repair was written against.
mkdir -p "$pen/eldergrade/tools/fixtures/q" "$pen/eldergrade/tools/fixtures/p"
sed 's/^if \[ "\$sentences" -lt "\$register_floor" \]; then$/if false; then/; s/^    if (sent == 0 || words == 0) { print "0 0 0 0 0 0"; exit }$/    if (sent == 0 || words == 0) { print "10 0 0 0 0 0"; exit }/' \
  "$pen/tools/fixtures/q/qa_report_card.sh" > "$pen/eldergrade/tools/fixtures/q/qa_report_card.sh"
for d in $deps; do mkdir -p "$pen/eldergrade/$(dirname "$d")" && cp "$d" "$pen/eldergrade/$d"; done
cp "$pen/hex_corpus.bron" "$pen/empty_prose.kyri" "$pen/eldergrade/"
eldergrade() { ( cd "$pen/eldergrade" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh "$@" 2>&1 ); }
eg_hex=$(eldergrade hex_corpus.bron --setting field --service 100)
eg_empty=$(eldergrade empty_prose.kyri --setting field --service 100)
[ "$(val "$eg_hex" reach)" -eq 0 ] \
  && [ "$(val "$eg_empty" reach)" -eq 0 ] \
  && echo "elder_grade_scored_the_unmeasurable=yes" || echo "elder_grade_scored_the_unmeasurable=no"
[ "$(val "$eg_hex" composite)" != "$(val "$hex" composite)" ] \
  && [ "$(val "$eg_empty" composite)" != "$(val "$empty" composite)" ] \
  && echo "grade_floor_repair_bites=yes" || echo "grade_floor_repair_bites=no"

echo "control_verdict=ok"
