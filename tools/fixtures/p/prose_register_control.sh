#!/bin/sh
# tools/fixtures/p/prose_register_control.sh -- prove the register reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). The scan reads the real tree's own
# door roster, so its RED path cannot be shown there without damaging the tree. This control
# measures the same awk on planted prose instead: a warm page, a page written entirely in
# refusals, and the edge cases the reading has to get right.
#
# USAGE
#   sh tools/fixtures/p/prose_register_control.sh
#
# Driven by tools/p/prose_register_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/p/prose_register_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

# Every pen below runs the scan from ITS OWN directory, where the relative path to the card that
# publishes the Style-line reader does not resolve -- so the absolute path is handed in. The scan
# refusing without it is the behaviour two legs below prove on purpose.
card_abs=$(CDPATH= cd -- tools/fixtures/q && pwd)/qa_report_card.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# The measure() function, lifted verbatim from the scan so the control reads what the guard reads.
sed -n '/^measure() {/,/^}/p' "$scan" > "$pen/measure.sh"
[ -s "$pen/measure.sh" ] || { echo "control_verdict=measure_not_found" >&2; exit 1; }
. "$pen/measure.sh"

pct_of() { set -- $(measure "$1"); echo "$3"; }
sent_of() { set -- $(measure "$1"); echo "$1"; }

# EVERY LEG IS TALLIED, because a reading nobody names is a reading nobody hears.
# `control_verdict=ok` says only that this control reached its own last line, so a leg the
# witness never names could read `no` under a GREEN gate. Measured `20260910.125644`: all 32
# legs standing today ARE named there, so the hole is the one a lap opens tomorrow -- which is
# exactly how the ascii pen and Patchouli's `silent_leg` found theirs. The tally is derived
# here rather than typed in the witness, so a leg added tomorrow is heard the day it lands.
legs=0
failed=0
say() { # say <name> <yes|no> [detail]
  legs=$((legs + 1))
  [ "$2" = yes ] || failed=$((failed + 1))
  echo "$1=$2${3-}"
}

# 1. Warm prose reads low.
cat > "$pen/warm.md" <<'EOF'
Grain gives you a computer that answers to you. Your words stay on your machine.
Every promise here is one a program has already checked. The system names each bound
before it starts, and it can show you it stayed inside. A witness prints green when a
promise holds. Every name we choose stays clear on the first day and the ten thousandth.
EOF
w=$(pct_of "$pen/warm.md")
[ "$w" -le 20 ] && say warm_reads_low yes || say warm_reads_low no " ($w%)"

# 2. Refusal-led prose reads high.
cat > "$pen/cold.md" <<'EOF'
A check that cannot fail is not a check. Nothing here is trusted until it refuses a
broken input. The guard was blind to an entire class and no meter caught the failure.
A stale claim is worse than a missing one, and a broken reference never resolves.
Nothing grows until something breaks, and no page may lie about what it cannot prove.
EOF
c=$(pct_of "$pen/cold.md")
[ "$c" -ge 60 ] && say cold_reads_high yes || say cold_reads_high no " ($c%)"
[ "$c" -gt "$w" ] && say reading_discriminates yes || say reading_discriminates no

# 3. A fenced code block is code rather than prose, and must not colour the reading.
cat > "$pen/fenced.md" <<'EOF'
Grain gives you a computer that answers to you. Every bound is named before it is used.

```
if (!ok) return error.NotFound; // never, no, cannot, failed, broken, wrong
if (!ok) return error.NotFound; // never, no, cannot, failed, broken, wrong
```

A witness prints green when a promise holds, and the tree keeps its own books.
EOF
f=$(pct_of "$pen/fenced.md")
[ "$f" -le 20 ] && say fence_excluded yes || say fence_excluded no " ($f%)"

# 4. Tables and headings carry labels rather than sentences, and are read past.
cat > "$pen/table.md" <<'EOF'
## Failure, error, broken, missing

| Reading | Now |
|---|---|
| never | no |
| cannot | failed |

Grain gives you a computer that answers to you. Every bound is named before it is used.
A witness prints green when a promise holds, and the tree keeps its own books today.
EOF
t=$(pct_of "$pen/table.md")
[ "$t" -le 20 ] && say table_excluded yes || say table_excluded no " ($t%)"

# 5. A fragment shorter than four words is no sentence.
printf 'Yes. No. Fine. Grain gives you a computer that answers to you today and tomorrow.\n' > "$pen/frag.md"
[ "$(sent_of "$pen/frag.md")" -eq 1 ] && say fragments_skipped yes || say fragments_skipped no

# 6. An empty page reads zero rather than dividing by zero.
: > "$pen/empty.md"
[ "$(pct_of "$pen/empty.md")" -eq 0 ] && say empty_safe yes || say empty_safe no

# 8. A paragraph that opens with a bold span is prose, and is read (REDS %451). This is the whole
#    of the repair: the elder `*` branch dropped every one of these, so a page could be graded on
#    the fraction of itself that happened to start with a plain word.
cat > "$pen/boldlead.md" <<'EOF'
# A page

**Language:** EN

**What went wrong:** the guard was blind to an entire class and no meter caught the failure.
**What caught it:** nothing did, and the broken reading stood for weeks without a refusal.
**What it taught:** a stale claim is worse than a missing one, and no page may lie about it.
EOF
b=$(pct_of "$pen/boldlead.md")
[ "$(sent_of "$pen/boldlead.md")" -ge 3 ] && say bold_lead_is_read yes || say bold_lead_is_read no
[ "$b" -ge 60 ] && say bold_lead_reads_high yes || say bold_lead_reads_high no " ($b%)"

# 9. A real bullet is still read past -- the marker THEN whitespace, which is what CommonMark says.
cat > "$pen/bullets.md" <<'EOF'
Grain gives you a computer that answers to you. Every bound is named before it is used.

- never, no, cannot, failed, broken, wrong, lost, stale, dead, refused, missing, absent
* never, no, cannot, failed, broken, wrong, lost, stale, dead, refused, missing, absent
+ never, no, cannot, failed, broken, wrong, lost, stale, dead, refused, missing, absent

A witness prints green when a promise holds, and the tree keeps its own books today.
EOF
u=$(pct_of "$pen/bullets.md")
[ "$u" -le 20 ] && say bullets_excluded yes || say bullets_excluded no " ($u%)"

# 10. Front matter is dropped ON PURPOSE, where it used to fall to the bullet branch by accident.
#     The wrapped value on the continuation line rides with it, which is what finally drops the
#     shared `**Where this sits:**` navigation block -- twelve words carrying one negation, counted
#     as prose on 111 front doors.
cat > "$pen/front.md" <<'EOF'
# A page

**Status:** Living -- broken, stale, lost, dead, refused, missing, wrong, and never repaired
**Where this sits:** home is the root, and the whole path from nothing to a signed home is
here, with no leader to elect and no central book to guard along the way at all

Grain gives you a computer that answers to you. Every bound is named before it is used.
A witness prints green when a promise holds, and the tree keeps its own books today.
EOF
m=$(pct_of "$pen/front.md")
[ "$m" -le 20 ] && say front_matter_excluded yes || say front_matter_excluded no " ($m%)"

# 11. THE REFUSAL SIDE OF THE SAME RULE, and the reason it needs both position and shape. A body
#     paragraph opening with a bold key is the SAME SHAPE as front matter, so a rule keyed on shape
#     alone ate real prose on 77 of 703 living documents when it was tried. The block therefore
#     ends at the first blank line, and everything after it is prose again.
cat > "$pen/afterfront.md" <<'EOF'
# A page

**Status:** Living

**What went wrong:** the guard was blind to an entire class and no meter caught the failure.
**What caught it:** nothing did, and the broken reading stood for weeks without a refusal.
**What it taught:** a stale claim is worse than a missing one, and no page may lie about it.
EOF
a=$(pct_of "$pen/afterfront.md")
[ "$a" -ge 60 ] && say body_after_front_matter_is_read yes || say body_after_front_matter_is_read no " ($a%)"

# 12. A page whose body opens with a bold span and carries NO front matter keeps that body. The
#     head rule requires the short-key shape, so an opening sentence in bold is a sentence.
cat > "$pen/nofront.md" <<'EOF'
# A page

**The working style of this tree** is one nobody measured, and the reading was broken.
Nothing here was trusted, and the stale claim never refused a single wrong input at all.
EOF
[ "$(sent_of "$pen/nofront.md")" -ge 2 ] && say bold_opening_without_key_is_read yes || say bold_opening_without_key_is_read no

# 13. The real door roster passes, and the scan agrees with itself.
out=$(sh "$scan" 2>/dev/null)
echo "$out" | grep -q 'door_over_ceiling=0' && say live_door_clean yes || say live_door_clean no
echo "$out" | grep -q 'verdict=ok' && say live_verdict_ok yes || say live_verdict_ok no

# 14-16. THE UNROSTERED CENSUS, proven by planting rather than by watching the live tree. The
#     reading names every tracked README.md that clears the eight-sentence floor, stands above the
#     door ceiling, and is absent from the DOOR roster -- and it is REPORTED, never gated, because
#     a page that agreed to nothing must not refuse the tree. Watching the live numbers would prove
#     that only while the tree happens to hold a candidate, so the proof is a pen: one page, two
#     rosters, and the verdict read both ways.
census=$(mktemp -d "${TMPDIR:-/tmp}/prose_register_census.XXXXXX")
mkdir -p "$census/room"
cat > "$census/README.md" <<'EOF'
# The pen front door

**Style:** Gauge, Door setting

This page leads with what is, and it names the work it holds in plain words.
Every room here keeps its own catalog, and the catalog names each file it holds.
A reader arriving today finds the same order a reader finds in a decade.
The witnesses run on metal, and each one prints the reading it took.
The bounds are named at construction, and the edge checks them once.
Each claim carries the measurement that earned it, in the same sentence.
The style is Gauge, and the door setting holds at twenty percent.
A lane joins this roster by sweeping its page and adding its path.
EOF
cat > "$census/room/README.md" <<'EOF'
# The pen room door

Nothing here was measured, and the claim never refused a wrong input.
The reading is broken, and the stale number cannot be trusted at all.
No guard watches this page, and no witness reads what it says.
The elder shape failed, and the repair was lost before it landed.
This room has no catalog, and nobody knows what it holds.
The bound is missing, so an allocation here is unbounded and wrong.
Every path it names is stale, and not one of them resolves.
A reader finds no order, and the absent index makes it worse.
EOF
( cd "$census" && git init -q . && git add -A ) >/dev/null 2>&1
sed 's|^DOOR=".*"|DOOR="README.md"|' "$scan" > "$census/scan_unrostered.sh"
sed 's|^DOOR=".*"|DOOR="README.md room/README.md"|' "$scan" > "$census/scan_rostered.sh"
un=$(cd "$census" && PROSE_CARD_READER="$card_abs" sh scan_unrostered.sh 2>/dev/null)
ro=$(cd "$census" && PROSE_CARD_READER="$card_abs" sh scan_rostered.sh 2>/dev/null)

# The plant plants something: the page IS named, by path and by share.
echo "$un" | grep -q '^candidate: room/README.md ' \
  && say census_names_the_page yes || say census_names_the_page no
# And naming it changes no verdict -- one candidate standing, and the scan still balances.
{ echo "$un" | grep -q '^front_doors_unrostered_over=1$' && echo "$un" | grep -q '^verdict=ok$'; } \
  && say census_reported_not_gated yes || say census_reported_not_gated no
# The load-bearing other side: the SAME bytes on the roster refuse. One roster line apart, so the
# reading is told from the gate rather than assumed to differ from it.
{ echo "$ro" | grep -q '^door_over_ceiling=1$' && echo "$ro" | grep -q '^verdict=register_drift$' \
  && echo "$ro" | grep -q '^front_doors_unrostered_over=0$'; } \
  && say census_roster_gates_the_same_page yes || say census_roster_gates_the_same_page no
rm -rf "$census"

# 17-20. THE LAW TIER, proven in a pen rather than by watching the live count. `.claude/rules/*.md`
#     is the prose every ship loads before its first token, and until 20260910 no reading compared
#     it against the ceiling context/GAUGE_STYLE.md states. The tier is a ratchet that GATES, so
#     both sides are shown: one page over the target refuses at a ceiling of zero and walks free at
#     a ceiling of one, one roster number apart, and a page under the eight-sentence floor stays
#     unread rather than counted. The pen carries its own DOOR roster, since the live roster's
#     fifteen paths are absent there and would refuse for a reason this leg is not about.
law=$(mktemp -d "${TMPDIR:-/tmp}/prose_register_law.XXXXXX")
mkdir -p "$law/.claude/rules"
cat > "$law/README.md" <<'EOF'
# The pen front door

**Style:** Gauge, Door setting

This page leads with what is, and it names the work it holds in plain words.
Every room here keeps its own catalog, and the catalog names each file it holds.
A reader arriving today finds the same order a reader finds in a decade.
The witnesses run on metal, and each one prints the reading it took.
The bounds are named at construction, and the edge checks them once.
Each claim carries the measurement that earned it, in the same sentence.
The style is Gauge, and the door setting holds at twenty percent.
A lane joins this roster by sweeping its page and adding its path.
EOF
cat > "$law/.claude/rules/warm.md" <<'EOF'
# A warm rule

Every allocation names its maximum at construction, and the edge checks it once.
A witness prints the reading it took, so a claim arrives with its own evidence.
The stamp orders a mark and the name means it, which is all a mark needs.
Prefer the affirmative restatement, and let each sentence land before the next.
A lane repairs the page it touches, and the ceiling falls in the same commit.
Dated testimony keeps every word it wrote, and the living page sweeps on touch.
The rule governs what is written from here forward, and says so at its door.
One clock stamps every mark, and a later stamp is a later version.
EOF
cat > "$law/.claude/rules/cold.md" <<'EOF'
# A cold rule

Nothing here is trusted, and no claim may be believed without a witness.
A guard that cannot red guards nothing, and this one never refused at all.
The elder shape failed, and the repair was lost before it ever landed.
No page may lie about what it cannot prove, and none of them resolves.
The bound is missing, so an allocation here is unbounded and wrong.
A stale claim is worse than a missing one, and nothing catches it.
Never write the banned word, and never route around a broken reference.
No lane may sweep this room, and no meter has ever read it.
EOF
cat > "$law/.claude/rules/short.md" <<'EOF'
# A short rule

Nothing here is measured, and no guard reads it at all.
EOF
( cd "$law" && git init -q . && git add -A ) >/dev/null 2>&1
sed 's|^DOOR=".*"|DOOR="README.md"|' "$scan" > "$law/base.sh"
sed 's|^law_ceiling=.*|law_ceiling=0|' "$law/base.sh" > "$law/scan_tight.sh"
sed 's|^law_ceiling=.*|law_ceiling=1|' "$law/base.sh" > "$law/scan_loose.sh"
tight=$(cd "$law" && PROSE_CARD_READER="$card_abs" sh scan_tight.sh 2>/dev/null)
loose=$(cd "$law" && PROSE_CARD_READER="$card_abs" sh scan_loose.sh 2>/dev/null)

# The plant plants something: the cold page IS named, by path and by share.
echo "$tight" | grep -q '^law: .claude/rules/cold.md ' \
  && say law_names_the_page yes || say law_names_the_page no
# The warm page written the same day in the same room stays off the listing, so the reading
# discriminates inside the tier rather than counting every rule page it finds.
echo "$tight" | grep -q '^law: .claude/rules/warm.md ' \
  && say law_spares_the_warm_page no || say law_spares_the_warm_page yes
# Under the eight-sentence floor a page is unread rather than counted -- three rule pages in the
# room, two of them long enough to read a share from honestly.
{ echo "$tight" | grep -q '^law_documents=3$' && echo "$tight" | grep -q '^law_readable=2$'; } \
  && say law_floor_holds yes || say law_floor_holds no
# One over the ceiling refuses.
{ echo "$tight" | grep -q '^law_over_field_target=1$' && echo "$tight" | grep -q '^verdict=register_drift$'; } \
  && say law_ceiling_refuses yes || say law_ceiling_refuses no
# The same bytes one ceiling number apart walk free, so the refusal is told from a scan that
# refuses everything.
{ echo "$loose" | grep -q '^law_over_field_target=1$' && echo "$loose" | grep -q '^verdict=ok$'; } \
  && say law_ceiling_lifts yes || say law_ceiling_lifts no
rm -rf "$law"

# --explain: the repair-grade reading, proven to agree with the count it explains.
#
# WHY THESE LEGS. A listing that names sentences the gate did not count, or misses ones it did,
# is worse than no listing: a lane sweeps the wrong prose and the share stays where it was. So the
# legs press on the agreement rather than on the printout -- the row count against the counted
# negatives, and the alignment of the printed text against the sentence that carried the word.
ex="$pen/explain"
mkdir -p "$ex"
cat > "$ex/page.md" <<'EOF'
# A page the meter normalises

**Stamp:** `20260910.000000`

This opening sentence is warm and carries the work forward for every reader.
The elder reading was **wrong.** The guard was blind here, and the meter caught the failure.
A second warm sentence follows it and says what the tree already holds today.
Read [the elder note](https://example.com/a.b.c) before the next one, which stays warm.
This third sentence is broken and the repair was lost before it ever landed.
EOF

exout=$(sh "$scan" --explain "$ex/page.md" 2>&1)
rows=$(echo "$exout" | grep -c '^neg ')
counted=$(echo "$exout" | sed -n 's/^explain_negative=//p')

# The listing exists and names sentences.
[ "$rows" -gt 0 ] && say explain_names_the_sentences yes || say explain_names_the_sentences no
# One row per counted negative -- the listing agrees with the number the gate reads.
[ "$rows" = "$counted" ] && say explain_agrees_with_the_count yes || say explain_agrees_with_the_count no
# The word that counted the sentence is named, rather than left to a reader to find.
echo "$exout" | grep -qE '^neg [0-9]+ \[[^]]*blind[^]]*\] ' && say explain_names_the_word yes || say explain_names_the_word no
# Capitals survive, so the printed sentence is recognisable in the file the lane opens.
echo "$exout" | grep -q '^neg [0-9]* \[[a-z ]*\] The guard was blind' \
  && say explain_keeps_capitals yes || say explain_keeps_capitals no
# THE ALIGNMENT LEG, and the reason the second buffer carries the substitutions rather than the
# file's own bytes. `**wrong.**` holds a period the splitter cannot reach until the emphasis marks
# come off, so the substituted buffer splits there and the untouched one does not -- every later
# sentence slides by one, and the last negative prints as its neighbour. Measured across the law
# room and the foundations, the two spellings disagree on nearly every page this tree writes, by
# four to fourteen sentences each. It prints as itself.
echo "$exout" | grep -q '^neg [0-9]* \[[a-z ]*\] This third sentence is broken' \
  && say explain_aligns_after_normalising yes || say explain_aligns_after_normalising no
# A page the meter reads as warm lists nothing and still answers.
cat > "$ex/warm.md" <<'EOF'
# A warm page

Every sentence here leads with what the tree holds today.
The guard reads each room and reports what it finds.
A lane sweeps one page and lowers the ceiling in the same commit.
Warmth is what the register asks for, and this page gives it.
EOF
warm=$(sh "$scan" --explain "$ex/warm.md" 2>&1)
{ echo "$warm" | grep -q '^explain_listed=0$' && echo "$warm" | grep -q '^verdict=ok$'; } \
  && say explain_warm_lists_nothing yes || say explain_warm_lists_nothing no
# The listing is bounded, and says where it stopped rather than trailing off in silence.
bounded=$(sh "$scan" --explain "$ex/page.md" 1 2>&1)
{ [ "$(echo "$bounded" | grep -c '^neg ')" = "1" ] && echo "$bounded" | grep -q '^explain_truncated_at=1$'; } \
  && say explain_bounded yes || say explain_bounded no
# An absent path refuses rather than reporting an empty page as clean.
sh "$scan" --explain "$ex/absent.md" >/dev/null 2>&1 \
  && say explain_refuses_an_absent_path no || say explain_refuses_an_absent_path yes
# THE READING IS UNTOUCHED. measure() with one argument answers exactly what it answers with the
# flag set, so the mode adds a printout and changes no number the gate reads.
plain=$(measure "$ex/page.md")
flagged=$(measure "$ex/page.md" 1 80 | grep -vE '^(neg |explain_)')
[ "$plain" = "$flagged" ] && say explain_reading_unchanged yes || say explain_reading_unchanged no
rm -rf "$ex"

# --- The door roster's own declarations ---------------------------------------------------------
# The scan asks each rostered door whether it names its Door setting at its own door. The
# classifier is lifted the way measure() is, so the control reads exactly what the guard reads,
# and the Style-line reader beneath it is lifted from the card the scan cites.
sed -n '/^door_setting_verdict() {/,/^}/p' "$scan" > "$pen/door_verdict.sh"
sed -n '/^QA_HEAD_LINES=/p;/^declared_style_line_of() {/,/^}/p' tools/fixtures/q/qa_report_card.sh > "$pen/declared.sh"
if [ -s "$pen/door_verdict.sh" ] && [ -s "$pen/declared.sh" ]; then
  say door_classifier_lifted yes
  . "$pen/declared.sh"
  . "$pen/door_verdict.sh"

  printf '# A page\n\n**Style:** Gauge, Door setting (see `x.md`)\n\nProse.\n' > "$pen/d_named.md"
  [ "$(door_setting_verdict "$pen/d_named.md")" = declared ] \
    && say door_named_reads_declared yes || say door_named_reads_declared no

  printf '# A page\n\n**Style:** Gauge, Field setting\n\nProse.\n' > "$pen/d_field.md"
  [ "$(door_setting_verdict "$pen/d_field.md")" = unnamed ] \
    && say door_field_reads_unnamed yes || say door_field_reads_unnamed no

  printf '# A page\n\nProse with no front matter at all.\n' > "$pen/d_none.md"
  [ "$(door_setting_verdict "$pen/d_none.md")" = absent ] \
    && say door_silent_reads_absent yes || say door_silent_reads_absent no

  # The key written INLINE after another key is the shape 65 pages use, and the shape the elder
  # anchored grep in the card could not see (REDS-class finding of 20260910.163831).
  printf '# A page\n\n**Language:** EN - **Style:** Gauge, Door setting - **Voice:** Kyri\n' > "$pen/d_inline.md"
  [ "$(door_setting_verdict "$pen/d_inline.md")" = declared ] \
    && say door_inline_reads_declared yes || say door_inline_reads_declared no

  # Past the head bound is body prose rather than a declaration.
  { i=1; while [ "$i" -le 45 ]; do echo "Filler line $i carries no key at all."; i=$((i + 1)); done
    echo '**Style:** Gauge, Door setting'; } > "$pen/d_deep.md"
  [ "$(door_setting_verdict "$pen/d_deep.md")" = absent ] \
    && say door_past_head_reads_absent yes || say door_past_head_reads_absent no

  # Lowercase is the same declaration; the card's own case arms say so.
  printf '**Style:** gauge, door setting\n' > "$pen/d_case.md"
  [ "$(door_setting_verdict "$pen/d_case.md")" = declared ] \
    && say door_case_insensitive yes || say door_case_insensitive no
else
  say door_classifier_lifted no
fi

# The citation is live rather than decorative: a card that is gone, and a card that has stopped
# publishing the reader, each REFUSE. A scan that guessed would report every door as silent.
printf '#!/bin/sh\necho hi\n' > "$pen/blind_card.sh"
blind=$(PROSE_CARD_READER="$pen/blind_card.sh" sh "$scan" 2>&1 || :)
echo "$blind" | grep -q '^verdict=reader_absent$' \
  && say door_reader_blind_refuses yes || say door_reader_blind_refuses no
gone=$(PROSE_CARD_READER="$pen/no_such_card.sh" sh "$scan" 2>&1 || :)
echo "$gone" | grep -q '^verdict=reader_absent$' \
  && say door_reader_absent_refuses yes || say door_reader_absent_refuses no

# The wall, shown from both sides on one warm page: an undeclared rostered door refuses, and the
# SAME bytes one clause later walk free. A refusal proven only in the passing direction cannot be
# told from a bypass.
dpen=$(mktemp -d)
mkdir -p "$dpen/room"
cat > "$dpen/room/README.md" <<'EOF'
# A room

Grain gives you a computer that answers to you. Your words stay on your machine here.
Every promise on this page is one a program has already checked before you read it.
A witness prints green when a promise holds, and the tree keeps its own books openly.
Every name we choose stays clear on the first day and on the ten thousandth day too.
EOF
( cd "$dpen" && git init -q . && git add -A ) >/dev/null 2>&1
sed 's|^DOOR=".*"|DOOR="room/README.md"|' "$scan" > "$dpen/scan.sh"
bare=$(cd "$dpen" && PROSE_CARD_READER="$card_abs" sh scan.sh 2>&1 || :)
{ echo "$bare" | grep -q '^door_setting_undeclared=1$' \
  && echo "$bare" | grep -q '^verdict=door_setting_undeclared$' \
  && echo "$bare" | grep -q '^undeclared: room/README.md carries no Style line'; } \
  && say door_gate_bites yes || say door_gate_bites no
{ printf '**Style:** Gauge, Door setting\n\n'; cat "$dpen/room/README.md"; } > "$dpen/head.tmp"
cat "$dpen/head.tmp" > "$dpen/room/README.md"
rm -f "$dpen/head.tmp"
( cd "$dpen" && git add -A ) >/dev/null 2>&1
lifted=$(cd "$dpen" && PROSE_CARD_READER="$card_abs" sh scan.sh 2>&1 || :)
{ echo "$lifted" | grep -q '^door_setting_undeclared=0$' \
  && echo "$lifted" | grep -q '^door_setting_declared=1$' \
  && echo "$lifted" | grep -q '^verdict=ok$'; } \
  && say door_gate_lifts yes || say door_gate_lifts no
rm -rf "$dpen"

# These two say what the legs read, beneath every named assertion in the witness.
echo "control_legs=$legs"
echo "control_failed=$failed"

echo "control_verdict=ok"
