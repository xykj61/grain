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
reg=tools/fixtures/p/prose_register_scan.sh
[ -f "$card" ] || { echo "control_verdict=card_missing" >&2; exit 1; }
[ -f "$reg" ] || { echo "control_verdict=register_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
# The pen mirrors the folded letter rooms (letter fold, seated 20260828): the card sits at q/
# and lifts measure() from the register scan at p/.
mkdir -p "$pen/tools/fixtures/q" "$pen/tools/fixtures/p"
cp "$card" "$pen/tools/fixtures/q/"
cp "$reg" "$pen/tools/fixtures/p/"

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
o=$(run under_floor.md --setting field)
[ "$(val "$o" register_mode)" = "reported" ] && echo "under_floor_reported=yes" || echo "under_floor_reported=no ($(val "$o" register_mode))"
[ "$(val "$o" register)" -eq 100 ] && echo "under_floor_not_scored=yes" || echo "under_floor_not_scored=no ($(val "$o" register))"
echo "$o" | grep -q 'reported, not scored' && echo "under_floor_named=yes" || echo "under_floor_named=no"
echo "$o" | grep -q 'of 7 sentences' && echo "under_floor_share_still_shown=yes" || echo "under_floor_share_still_shown=no"

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
echo "$o" | grep -q 'reach=0 .*0 words' && echo "unknown_mark_reads_nothing=yes" || echo "unknown_mark_reads_nothing=no ($(val "$o" reach))"

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

# Meter frees a notation file exactly as it frees a document, so a session log read at Meter is
# unmoved by any of this.
meter_notation=$(run roster_cold.kyri --setting meter --service 100)
[ "$(val "$meter_notation" register)" -eq 100 ] && [ "$(val "$meter_notation" reach)" -eq 100 ] \
  && echo "notation_meter_unscored=yes" || echo "notation_meter_unscored=no"

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

# The elder classifier, carried back into a copy of the card. It sent a notation file down the
# prose path, where no extractor runs, so the whole comment block was invisible: warm and cold must
# read IDENTICALLY there. This is the leg that tells a repair from a rewording.
mkdir -p "$pen/elder/tools/fixtures/q" "$pen/elder/tools/fixtures/p"
sed 's/^  \*\.bron|\*\.kyri)             artifact_kind=notation ;;$/  *.bron|*.kyri)             artifact_kind=prose ;;/' \
  "$pen/tools/fixtures/q/qa_report_card.sh" > "$pen/elder/tools/fixtures/q/qa_report_card.sh"
cp "$pen/tools/fixtures/p/prose_register_scan.sh" "$pen/elder/tools/fixtures/p/"
cp "$pen/roster_warm.kyri" "$pen/roster_cold.kyri" "$pen/elder/"
elder() { ( cd "$pen/elder" && QA_CARD_ROOT=. sh tools/fixtures/q/qa_report_card.sh "$@" 2>&1 ); }
elder_warm=$(elder roster_warm.kyri --setting field --service 100)
elder_cold=$(elder roster_cold.kyri --setting field --service 100)
[ "$(val "$elder_warm" register)" = "$(val "$elder_cold" register)" ] \
  && [ "$(val "$elder_warm" composite)" = "$(val "$elder_cold" composite)" ] \
  && echo "notation_elder_was_blind=yes" || echo "notation_elder_was_blind=no"
elder_sent=$(echo "$elder_warm" | sed -n 's/^register=[0-9]* (negative [0-9]*% of \([0-9]*\) sentences.*/\1/p')
[ "$elder_sent" = 1 ] && echo "notation_elder_read_one_sentence=yes" || echo "notation_elder_read_one_sentence=no"

echo "control_verdict=ok"
