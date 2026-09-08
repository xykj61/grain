#!/bin/sh
# tools/fixtures/q/qa_report_card.sh -- read one artifact and hand back its report card.
#
# WHY THIS FILE EXISTS. This tree measured its prose one way: the share of sentences carrying a
# negative, held at or under 20% for a Door document. That number is true and it is also backwards.
# A reader asked to hold "20% negative" is being told what the page failed to avoid, and a writer
# aiming at it is aiming at a ceiling rather than at a standard. Read the same measurement the other
# way up -- 100 minus that share -- and 20% becomes **80, a B**, which is a grade a person has known
# since school and can aim at without translating.
#
# So the report card is the same discipline pointed forward. Seated 20260824.161948 on Keaton's word.
#
# WHAT IT READS, and what it refuses to invent. Four readings, and the tool counts two and a half of
# them:
#
#   Register  counted   100 minus the share of sentences carrying a negative, floor and all. The
#                       measure() function and the REGISTER_MIN_SENTENCES floor are both lifted from
#                       prose_register_scan.sh, so no number here can drift from it (REDS %201).
#   Reach     counted   whether the intended reader can follow it: Flesch-Kincaid grade and
#                       cross-references per hundred words, against the setting's own budget --
#                       unless the page declares itself an index AND measures like one, where the
#                       density is reported rather than scored. Two conditions, never one.
#   Truth     half      counted: every relative link the page makes, resolved as written, root-
#                       relative, or by the fold rule. A placeholder shape -- `date/YYYYMMDD/name`
#                       -- is an illustration of a path rather than a citation of one, and a
#                       fabricated stamp naming no file still counts. Judged: whether a behavioral
#                       claim is still true, which only reading or running can say.
#   Service   judged    whether the artifact helps the work actually in front of us. The tool prints
#                       the inputs a reader needs and stops there, because a number nobody measured
#                       is worse than a blank.
#
# A REFERENCE TABLE IS HELD OUT OF BOTH COUNTED READINGS and reported beside them, because both are
# computed over sentences and a table has none. The shape is read off the line's own face and is
# argued in tools/fixtures/r/reference_block.awk (REDS %397).
#
# ALL THREE OF THOSE READINGS ARGUED IN FULL beside the code that carries them, further down.
# The short of it: a meter that instructs a repair which would make the artifact worse is the thing
# to fix -- telling an index to pad itself with prose, telling a page that its blessed placeholder
# shape was a broken link, and reading a share off one sentence. No page changed a word.
#
# THE COMPOSITE arrives once the judged readings are handed in with --service and --truth. Without
# them the card prints what it counted and says `composite=judged`, which is the honest output.
#
# THE SCALE, and why it has no minus grades. Keaton's word, 20260824: a plain school scale, so a
# writer reads a B and knows what to do.
#
#   97-100 A+ | 90-96 A | 85-89 B+ | 80-84 B | 75-79 C+ | 70-74 C | 65-69 D+ | 60-64 D | under 60 F
#
# WHAT IS NOT PROVEN. That an A page is a good page. This counts four honest proxies and names the
# two it cannot count, and the second thing to read is always the artifact itself.
#
# USAGE
#   sh tools/fixtures/q/qa_report_card.sh <path> [--setting door|field|meter] [--service 0-100] [--truth 0-100]
#
# BOTH JUDGED FLAGS ARE 0-100, the same scale the three counted readings use, because the composite
# is their mean. Service is four questions worth 25 each -- named, reached, current, and which side
# it carries. Handing in a count out of four reads as 3 of 100 and drops the grade three letters,
# which is REDS %361: the scale lived only in the loop's seat prompt, so the card now prints it.
#   sh tools/fixtures/q/qa_report_card.sh --letter <0-100>
#
# Run from the repository root.

set -u

root=${QA_CARD_ROOT:-.}

# --- the scale ---------------------------------------------------------------------------------
letter_for() {
  n=$1
  if   [ "$n" -ge 97 ]; then echo "A+"
  elif [ "$n" -ge 90 ]; then echo "A"
  elif [ "$n" -ge 85 ]; then echo "B+"
  elif [ "$n" -ge 80 ]; then echo "B"
  elif [ "$n" -ge 75 ]; then echo "C+"
  elif [ "$n" -ge 70 ]; then echo "C"
  elif [ "$n" -ge 65 ]; then echo "D+"
  elif [ "$n" -ge 60 ]; then echo "D"
  else echo "F"
  fi
}

# --- What this card reads, named by the card ------------------------------------------------------
# The card CITES two readings rather than spelling either: measure() and the sentence floor come out
# of the register scan, and the reference-block shape out of the classifier beside this file. That
# is the right design and it has one cost -- every throwaway pen that stages the card must stage the
# whole chain, and a pen is a hand-kept list in someone else's guard.
#
# Adding the classifier proved the cost twice in one lap. Two pens went quiet at once: the citation
# guard's, and this card's own elder-card leg, which stages a second copy to prove a repair from a
# rewording. Neither pen was wrong when it was written; each was a copy of a list that had moved
# (REDS %405).
#
# So the list lives here, beside the code that reads it, and a pen asks rather than remembers.
#
#   sh tools/fixtures/q/qa_report_card.sh --deps
#
# The control builds a pen from nothing but this answer and runs the card in it, so a third citation
# added without a line here fails on the lap that adds it rather than in whichever guard runs next.
if [ "${1:-}" = "--deps" ]; then
  echo "tools/fixtures/p/prose_register_scan.sh"
  echo "tools/fixtures/r/reference_block.awk"
  exit 0
fi

if [ "${1:-}" = "--letter" ]; then
  [ $# -ge 2 ] || { echo "qa: --letter wants a score" >&2; exit 1; }
  letter_for "$2"
  exit 0
fi

path=${1:-}
[ -n "$path" ] || { echo "qa: name an artifact to read" >&2; exit 1; }
[ -f "$root/$path" ] || { echo "qa: $path is absent -- refusing rather than reading zero" >&2; exit 1; }
shift

setting=field
service=-1
truth_given=-1
while [ $# -gt 0 ]; do
  case "$1" in
    --setting) setting=${2:-field}; shift 2 ;;
    --service) service=${2:--1}; shift 2 ;;
    --truth)   truth_given=${2:--1}; shift 2 ;;
    *) echo "qa: unknown option $1" >&2; exit 1 ;;
  esac
done

case "$setting" in
  door)  grade_ceiling=9;  xref_ceiling=1 ;;
  field) grade_ceiling=11; xref_ceiling=3 ;;
  meter) grade_ceiling=0;  xref_ceiling=0 ;;
  *) echo "qa: unknown setting $setting -- door, field, or meter" >&2; exit 1 ;;
esac

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# --- Register: the same reading prose_register_scan.sh gates, flipped -----------------------------
reg_scan="$root/tools/fixtures/p/prose_register_scan.sh"
[ -f "$reg_scan" ] || { echo "qa: the register reading is missing at $reg_scan" >&2; exit 1; }
sed -n '/^measure() {/,/^}/p' "$reg_scan" > "$work/measure.sh"
[ -s "$work/measure.sh" ] || { echo "qa: prose_register_scan.sh no longer publishes measure()" >&2; exit 1; }
. "$work/measure.sh"

# WHAT COUNTS AS A PAGE'S PROSE, and the fault that made this explicit. Both readings below --
# Register and Reach -- skip a line whose first non-whitespace is `#`, which is right for Markdown,
# where `#` opens a heading. In a shell, Rishi, or Rye source `#` and `//` open the ONLY prose the
# file has, and every other line is code. Applied to a program the rule therefore inverted: it threw
# away the comments and graded the code. Measured `20260826` on `tools/fixtures/r/reds_fold.sh`, whose
# comment head is 700 words of plain English -- Reach read 209 "words" of `[ -f "$PIN" ] || fail ...`
# and returned a reading grade of 86 against a ceiling of 9, flooring Reach at 0 and the card at C.
# The page was fine; the instrument was reading the wrong half of it (REDS %276).
#
# THE MARK IS THE LANGUAGE'S, AND GLOW'S IS `::`. That repair named `//` and `#` and left this
# tree's own notation out. Glow opens a comment with `::`, and so do the `.brush` placards, so the
# extractor found no prose in either and emitted an empty file -- 438 tracked `.glow` files and 8
# `.brush` ones, every one of them measuring zero words. Zero words is not a low reading; it is NO
# reading, and the card scored it regardless, so all 34 residents of the shape museum graded C+ 75
# whatever they said and no writing could move one of them. `::` joins the alternation from
# 20260830.053148, and the grades discriminate at once: the same four desks read A 92, B 83, C+ 75,
# A+ 98 (REDS %358).
#
# So the artifact is classified once, here, and both readings feed on the answer. This is the same
# `truth_source` split the citation reading already makes further down, hoisted so that one
# classification serves all three rather than two that can come to disagree.
case "$path" in
  *.md|*.mdc|*.markdown)     artifact_kind=prose ;;
  *.bron|*.kyri)             artifact_kind=notation ;;
  *)                         artifact_kind=program ;;
esac

if [ "$artifact_kind" = prose ]; then
  prose_path="$root/$path"
elif [ "$artifact_kind" = notation ]; then
  # THE THIRD FAMILY THE SAME FAULT REACHED. Kyri and Bron are key-value notations: `#` opens a
  # COMMENT, and every other line is one `key value` record. Read raw, the file gives BOTH readings
  # the wrong half. measure() drops a leading `#` as a Markdown heading, which is right for a
  # document and exactly inverted here, since a notation file keeps its whole document behind that
  # sigil. And a record carries no terminal punctuation, so consecutive records fuse into ONE
  # pseudo-sentence rather than being dropped one at a time by the reading's own under-four-words
  # floor -- the floor that already handles a short line correctly when something separates them.
  #
  # Measured 20260831 on construction/standing-equipment.kyri: 498 comment lines carrying 7,271
  # words -- the file's whole argument -- were thrown away, and 457 record lines were read as a
  # single 915-word sentence, for a reading grade of 327, Reach 0, and a composite of C+ 75 -- a
  # number measured wholly on the half that says nothing. All nineteen tracked notation files
  # carrying 200 words or more of comment prose read EXACTLY ONE sentence that day, template-
  # manifest.bron at 1,786 words of it. One sentence nineteen times is the signature of a reading
  # that never found the prose.
  #
  # WHY IT ARRIVED THROUGH THIS DOOR. REDS %276 made this repair for programs and %358 taught it
  # Glow's `::`; both landed inside the program branch, which is where the extractor lives. A
  # notation file classifies as PROSE, where no extractor runs at all, so the third family walked
  # in past two repairs aimed at it. The mark is the language's -- and so is the record.
  #
  # So the sigil comes off each comment line, and each record line closes with a period of its own.
  # A record then meets the under-four-words floor alone and drops out, exactly as a table row
  # already does; a long field value -- a session log's `obs` line -- stays one unit and is read.
  # A comment whose own content opens with a bullet still reads as a bullet, which is the same
  # answer Markdown gets and the reason this branch prepares text rather than holding a second
  # reading of its own.
  awk '
    /^[ \t]*$/ { print; next }
    /^#/ { line = $0; sub(/^#[ ]?/, "", line); print line; next }
    { print $0 "." }
  ' "$root/$path" > "$work/notation-body.txt"
  notation_comment_lines=$(awk '/^#/ { n++ } END { print n + 0 }' "$root/$path")
  notation_record_lines=$(awk '!/^#/ && !/^[ \t]*$/ { n++ } END { print n + 0 }' "$root/$path")
  prose_path="$work/notation-body.txt"
else
  # A program carries two settings in one file. The grammar names the Door: `//!` is a module
  # document in Rye, while a leading `#` or `::` block is the module document in the other family
  # tongues. Meter is narrower: the seated `invariant:` line beside a bound or assert. Declaration
  # docs (`///`) and loose comments are useful prose, yet neither pole owns them, so the card names
  # their count and leaves them out rather than letting a typed --setting decide their grade.
  awk '
    function clean(line) {
      sub(/^[ \t]*(\/\/!|#|::)[ ]?/, "", line)
      return line
    }
    NR == 1 && /^#!/ { next }
    !code && /^[ \t]*\/\/!/ { print clean($0); next }
    !code && /^[ \t]*(#|::)/ { print clean($0); next }
    !code && /^[ \t]*$/ { next }
    { code = 1 }
  ' "$root/$path" > "$work/program-head.txt"
  awk '/^[ \t]*(\/\/|#|::)/ && /invariant:/ {
         line = $0
         sub(/^[ \t]*(\/\/[\/!]?|#|::)[ ]?/, "", line)
         print line
       }' "$root/$path" > "$work/program-meter.txt"
  program_decl_lines=$(awk '/^[ \t]*\/\/\// { n++ } END { print n + 0 }' "$root/$path")
  program_meter_lines=$(wc -l < "$work/program-meter.txt" | tr -d ' ')
  program_head_lines=$(wc -l < "$work/program-head.txt" | tr -d ' ')
  prose_path="$work/program-head.txt"

  # The caller chooses a document's setting. A program's two settings come from Gauge itself, so
  # the same bytes must read the same whichever legacy word a hand supplies.
  grade_ceiling=9
  xref_ceiling=1
fi

# WHICH SETTING A ROSTER TAKES, ANSWERED BY MEASUREMENT RATHER THAN ASSERTED. The free pass belongs
# where there is nothing to read, and a notation file's own grammar says which case it is in.
#
# Measured 20260831 across all 4,090 tracked .bron and .kyri files, and the family splits cleanly:
# 3,983 carry ZERO comment lines and 107 carry at least one. The zero side is 3,928 session logs --
# which .claude/rules/session-logs.md already seats at Meter -- plus 55 pure data corpora under
# mycelium/corpora/, pond/apps/corpora/ and bat/. Those files are all record, they are Gauge's own
# "ledger rows", and Meter is right for them. The other side is the rosters, registries, manifests
# and system descriptors, and REDS %402 established what those files are: the comment block is the
# document, and the records are data counted beside it.
#
# So Meter frees a notation ONLY when there is no comment block. Where a document stands, the free
# pass is refused, because freeing it makes the reading a CONSTANT: register and reach are both set
# to 100 below, leaving a composite fixed by Truth and Service alone. Measured on the nineteen
# notation files carrying 200 words or more of comment prose, every one of them read EXACTLY 94 at
# Meter with Service held at 75 -- one number across nineteen different inputs, which is the same
# disconnected reading %402 repaired and the same signature (one sentence, composite 75) it read on
# its way in. At Field the same nineteen read 81 to 92, an eleven-point spread, every one at or
# above B. The class needs no relief to clear the door; it needed an instrument that could tell its
# members apart.
#
# WHY FIELD IS THE FALLBACK AND NOT DOOR. Meter carries no ceiling to fall back ON -- its
# grade_ceiling is 0 -- so a refused notation must be read at a real one, and Field is this card's
# own default. The measurement agrees: of the nineteen, twelve exceed Door's 20% register ceiling
# and eight exceed its grade ceiling of 9, against three and two at Field's. A typed `--setting
# door` is still honored, because whether Door's ceiling of 9 is right at all is a separate open
# question on the live card, and settling it quietly inside a different repair would be reaching.
notation_meter="n/a (meter not asked for)"
if [ "$artifact_kind" = notation ] && [ "$setting" = meter ]; then
  if [ "$notation_comment_lines" -eq 0 ]; then
    notation_meter="free (no comment block -- the file is all record)"
  else
    notation_meter="refused ($notation_comment_lines comment lines carry a document; read at field)"
    setting=field
    grade_ceiling=11
    xref_ceiling=3
  fi
fi

# --- The reference block: a table is not a paragraph ---------------------------------------------
# Both readings below are computed over SENTENCES, and a reference table has none. This tree writes
# its key lists without terminal punctuation -- `#   store_wired      whether store_large still
# consults that wall` -- so a run of them carries no sentence end and merges into whatever sentence
# abuts it. The card then weighs a head as if it held a handful of enormous ones.
#
# Measured on one file, single-variable: add a terminal period to each of 28 such lines in
# tools/fixtures/p/pond_spool_cloth_glow_tend_scan.sh, change nothing else, and Register moves
# 48 -> 74, Reach 30 -> 90, composite 74 -> A 91. Seventeen composite points of punctuation, on a
# file whose content did not move (REDS %397).
#
# So a reference block is held out of both readings and REPORTED beside them, the way declaration
# docs already are. What counts as one is read off the line's own face, and the shape with its two
# thresholds is argued in tools/fixtures/r/reference_block.awk -- CITED rather than spelled here,
# the same discipline measure() and the register floor already keep, so one reading serves the card
# and its control rather than two that can come to disagree.
#
# IT RUNS AFTER the branch above rather than inside it, so all three artifact kinds are read the
# same way. A notation's records arrive here already carrying the period that branch appends, and
# the ones that are ALSO a key table -- template-manifest.bron's 123 `template  <path>  # why`
# lines -- are held out here as well; both roads end at "this is not prose", which is the answer.
#
# WHAT THIS REACHES, measured 20260831. Across every tracked program source: 154 heads carry a
# block, 928 lines in all, and holding them out moves 130 of those files -- 57 across the B door,
# one below it, mean +7.2, and ZERO crossing under the register floor, so every rise is Reach and
# no page became unmeasurable. Eighty-four of the 154 are `.glow` desks, whose six-line placard IS
# the genre. It is NOT a tree-wide lift: over the 135 `.rye`, `.rish` and `.sh` sources sampled
# every 37th, exactly one carries a block and the below-B count stands at 64 either way -- so the
# standing question about Door's ceiling of 9 against module heads is untouched by this, which is
# worth knowing before anyone answers it.
ref_awk="$root/tools/fixtures/r/reference_block.awk"
[ -f "$ref_awk" ] || { echo "qa: the reference reading is missing at $ref_awk" >&2; exit 1; }
awk -v MODE=prose -f "$ref_awk" "$prose_path" > "$work/prose.txt"
reference_lines=$(awk -v MODE=count -f "$ref_awk" "$prose_path")
prose_path="$work/prose.txt"

set -- $(measure "$prose_path")
sentences=$1
negatives=$2
neg_pct=$3
register=$((100 - neg_pct))

# The floor the register scan already applies, CITED rather than copied -- the same discipline that
# governs measure() above. A share needs a denominator big enough to mean something: one negative
# sentence out of one reads 100%, which is arithmetic on a rounding error rather than a fact about
# how a page is written. The teaching tier in prose_register_scan.sh has held this floor since it
# was written, and the card citing that scan had been dropping it, so the same page could be
# unmeasurable to one reading and scored 0 by the other.
#
# Measured 20260825: 27 living teaching pages sit under the floor, and six of them read 100% from a
# SINGLE sentence -- docs-geode/libraries/README.md among them, which is generated and proven green
# by its own witness. Below the floor the share is REPORTED rather than scored, and named on the
# card, so a reader still sees it.
#
# TWO CONDITIONS, NEVER ONE -- amended REDS %430. This comment argued for one condition and was
# wrong, and the argument it made against a second is the one that convicts it: the index reading
# needs two conditions because a page DECLARES itself an index and a self-declared exemption is a
# door. That is true and it is not the whole test. The floor's own reasoning is stated at n=1 --
# "one negative sentence out of one is a rounding error, not a register" -- and it was asserted for
# every n up to seven, where a share is no rounding error at all. A freed reading does not abstain:
# the composite divides by four regardless, so a Register that measured nothing votes 100.
#
# Measured over the 870 living tracked Markdown pages outside gratitude/, vendor/ and seed/: 560
# carried a freed Register contributing its ceiling, 206 of them printing a negative share ABOVE
# Door's own 20%, and 176 of those reading B or better. One read A/94 on thirteen words.
#
# THE SECOND CONDITION IS DERIVED RATHER THAN GRANTED, which is why it can be checked. One sentence
# moves a share by 100/n points, so the floor's argument holds exactly while a single sentence could
# still carry the reading across the ceiling, and stops holding the moment it cannot:
#
#     free  <=>  |share - DOOR_MAX| * sentences < 100
#
# At n=1 that is |share-20| < 100, which frees a share of 100, so the seated reasoning is kept whole
# rather than overridden. At n=0 it frees by construction, which is right: a page with no sentence
# has no register to read. From n=6 up a share far from the ceiling is scored, because no one
# sentence could have put it there. The arithmetic repairs the INPUT rather than the mean, which is
# the same move the Meter branch below already made, and mean_of_four_reads is untouched.
#
# The wall is untouched. tools/p/prose_register_witness.rish still gates the twelve door documents at
# 20% with no floor, and nothing here reaches it. A gate that grows an exemption stops being a gate.
register_floor=$(sed -n 's/^REGISTER_MIN_SENTENCES=\([0-9]*\)$/\1/p' "$reg_scan" | head -1)
[ -n "$register_floor" ] || { echo "qa: prose_register_scan.sh no longer publishes REGISTER_MIN_SENTENCES" >&2; exit 1; }
# Lifted from the same file as the floor and the measure(), so the ceiling this door reasons about
# and the ceiling the wall enforces are one number that cannot drift apart. BOTH ceilings are read,
# because Gauge gives Door 20% and Field 30% and the question "could one sentence have crossed it"
# has a different answer at each -- reasoning about a Field page against Door's ceiling would score
# pages the law never put over one. Meter is uncapped by Gauge's own table, so it frees here and is
# named as Meter by the branch below rather than being reasoned about as prose.
register_door_max=$(sed -n 's/^DOOR_MAX=\([0-9]*\)$/\1/p' "$reg_scan" | head -1)
[ -n "$register_door_max" ] || { echo "qa: prose_register_scan.sh no longer publishes DOOR_MAX" >&2; exit 1; }
register_field_max=$(sed -n 's/^FIELD_MAX=\([0-9]*\)$/\1/p' "$reg_scan" | head -1)
[ -n "$register_field_max" ] || { echo "qa: prose_register_scan.sh no longer publishes FIELD_MAX" >&2; exit 1; }
case "$setting" in
  door)  register_ceiling=$register_door_max ;;
  field) register_ceiling=$register_field_max ;;
  *)     register_ceiling=$neg_pct ;;
esac

# Whether there was enough prose to measure is ONE question, answered once, and both scored
# readings must answer it the same way -- that agreement is what an earlier round already had to
# repair. Whether a thin denominator MATTERED is a second question, and only the register asks it,
# so the floor finding is published separately from the mode it leads to.
register_floor_met=yes
[ "$sentences" -lt "$register_floor" ] && register_floor_met=no

# The distance from the ceiling is a pure function of two numbers already in hand, so it is computed
# unconditionally rather than inside the branch that uses it. Written inside, it is undefined on
# every path that does not take the branch -- which the control's own elder-card leg found at once,
# by rewriting the condition to `if false` and reading a detail line that referenced it.
if [ "$neg_pct" -ge "$register_ceiling" ]; then
  register_gap=$((neg_pct - register_ceiling))
else
  register_gap=$((register_ceiling - neg_pct))
fi

register_mode=scored
if [ "$sentences" -lt "$register_floor" ]; then
  if [ "$((register_gap * sentences))" -lt 100 ]; then
    register_mode=reported
    register=100
  fi
fi

# --- Reach: can the intended reader follow it ----------------------------------------------------
# Flesch-Kincaid over the same prose the register reading sees, plus link density. Syllables are
# counted by vowel groups with a silent trailing `e` removed and a floor of one, which is the
# ordinary heuristic and honest to about half a grade.
# WHICH LINES THIS READING CAN SEE, stated because for a long time it was not. Flesch-Kincaid is
# arithmetic over sentences, and a table row, a list item, a heading and a bold-key header line hold
# none -- so all four are held out, the same call `reference_block.awk` makes for Register one
# reading up. That part is right.
#
# WHAT WAS WRONG WITH IT, AND WHY THE FIX IS NOT THE ONE THE RED PROPOSED (REDS %574). The elder
# card rule was the single pattern `/^[ \t]*[-*>#]/` -- a line opening with a list marker OR an
# emphasis marker, with no test for the whitespace that tells the two apart. Markdown needs that
# whitespace: `- item` is a list, `**Lotus** is Grain's own creative suite` is a paragraph, and
# `*May every vessel stay sealed in motion.*` is a radiant wish. So the reading dropped every
# sentence this tree's own style rules ask for -- Gauge writes a paragraph's claim in bold at its
# head, and `radiant-wishes-ending` closes an earned page in italics. Measured over the 45 graded
# pages of the door, teaching and candidate rosters on `20260908.085832`: **155 bold-led prose
# lines on 33 pages, and 55 italic-led lines on 42 of the 45**. The card was blind to the closing
# line of nearly every front door it grades.
#
# THE RED NAMED THE CURE AS ADOPTING THE REGISTER RULE, AND THE MEASUREMENT REFUSED IT. Register's
# three line rules do keep both forms, so they fix the blindness -- and they also admit the
# `**Key:** value` header line, which holds no sentence and is the fourth kind held out above.
# Across the same 45 pages that is **232 header lines against 155 bold-led prose lines**, on 44 of
# 45 pages: adopting the shadow wholesale would let in more noise than signal, by count. Composites
# under it moved 19 down, 7 up, mean -1.42 -- the net of two opposite errors partly cancelling,
# which is why 7 pages ROSE under a reading everyone called stricter.
#
# SO THE RULE IS THE THIRD ONE: Register's marker-then-whitespace tests, PLUS a hold-out for the
# `**Key:**` header line -- bold run ending in a colon, and no terminal punctuation, since a line
# that ends in a full stop is a sentence whatever it opens with. Measured across the same 45:
# **22 unchanged, 13 up, 10 down, mean +0.58, worst fall 5 (`amphora/README.md`), best rise 8**
# (`docs-geode/edu/yonder/pleac/README.md`). **No page crosses below the B door**, and two rise
# above it -- `expanding-prompts/components/README.md` and `mandate/README.md` -- which were held
# under the door by a blindness rather than by their prose.
#
# THE RESIDUE, NAMED RATHER THAN SWALLOWED: the hold-out reads a colon INSIDE the bold run, so the
# `**Standing witnesses** (twelve at tier lap): ...` form -- colon outside -- is still counted as
# prose. That is **44 lines of the 276** across the 45, and it is the whole of `amphora`'s 5-point
# fall. Widening it wants a rule that can tell a parenthetical from a sentence, which is a bigger
# question than this repair, so it is measured here rather than guessed at. What was NOT stated is that the link count rides in the same awk,
# so a citation on any of those lines is held out with the words, and the density below is computed
# over running prose alone.
#
# MEASURED 20260906 over 5,409 tracked Markdown files outside gratitude/ and vendor/: this reading
# sees 2,690 links and holds out 15,528 -- 9,809 on list, heading or bold-key lines and 5,719 in
# tables -- so it sees 14.8% of them, and 1,766 files carry links while reading zero. `docs/README.md`,
# the worked example in the index-relief comment below, carries 28 links on the page and 5 here;
# `docs-geode/wiki/README.md`, whose whole body is a 14-row table of links, carries about 50 and
# reads 2 (REDS %492).
#
# SO THE COUNT IS REPORTED BOTH WAYS BELOW and the density stays exactly as it was. Widening the
# numerator would re-grade the tree in one unmeasured step, and this file already refuses that shape
# once -- a separate open question is not settled quietly inside a different repair. What a reader
# can no longer do is quote `links` as the page's link count, which is what it had been read as.
reach_read() { awk -v gc="$grade_ceiling" -v xc="$xref_ceiling" -v rule="$1" '
  BEGIN { infence = 0 }
  /^```/ { infence = 1 - infence; next }
  infence { next }
  /^[ \t]*\|/ { next }
  /^[ \t]*[-*_][-*_ \t]*$/ { next }
  /^[ \t]*[-*+][ \t]/ { next }
  /^[ \t]*[>#]/ { next }
  # THE RESIDUE IS RULED ON RATHER THAN LEFT OPEN (20260908.104232). This hold-out wants the colon
  # INSIDE the bold run, so a bold label followed by a parenthetical and then a colon is still
  # counted as prose -- 44 lines of 276 on the page that raised it. The obvious repair is to allow a
  # colon AFTER the bold run with a parenthetical permitted between, and measuring that repair
  # refuses it.
  #
  # Tree-wide it would newly exclude 257 lines, and those 257 are two different things wearing one
  # shape: 172 are LABELS -- a noun phrase, a qualifier, a colon, then values -- and 85 are CLAIMS,
  # bold assertion then colon then evidence, which is this trees own house sentence form. Splitting
  # them by bold-run length misfiles the 85. Splitting them by what follows the colon misfiles as
  # many. No positional rule separates a label from a claim, because the difference is whether the
  # bold run holds a verb, and that is semantics rather than shape.
  #
  # SO THE RULE STAYS, AND THE REASON IS THAT THE ERROR IS ASYMMETRIC. This reading counts NEGATIVE
  # sentences. Counting a label as a sentence dilutes the ratio slightly toward positive, since a
  # label carries little negation. EXCLUDING a claim hides real negation, which is the one thing this
  # reading exists to see. Erring toward counting errs in the safe direction, so the residue is a
  # known dilution rather than a defect, written here so the next reader meets the measurement
  # instead of repeating it.
  rule == "card" && /^[ \t]*\*\*[^*]+:\*\*/ && $0 !~ /[.!?]["`)]?[ \t]*$/ { next }
  /^[ \t]*$/ { next }
  {
    line = $0
    while (match(line, /\]\([^)]*\)/)) { links++; line = substr(line, RSTART + RLENGTH) }
    line = $0
    gsub(/\[[^]]*\]\([^)]*\)/, " link ", line)
    gsub(/`[^`]*`/, " code ", line)
    buf = buf " " tolower(line)
  }
  END {
    n = split(buf, s, /[.!?]+[ ]/)
    for (i = 1; i <= n; i++) {
      w = split(s[i], t, /[ ]+/)
      if (w < 4) continue
      sent++
      for (j = 1; j <= w; j++) {
        word = t[j]
        gsub(/[^a-z]/, "", word)
        if (word == "") continue
        words++
        sub(/e$/, "", word)
        c = split(word, v, /[aeiouy]+/)
        syl = c - 1
        if (syl < 1) syl = 1
        syllables += syl
      }
    }
    if (sent == 0 || words == 0) { print "0 0 0 0 0 0 0"; exit }
    grade = 0.39 * (words / sent) + 11.8 * (syllables / words) - 15.59
    if (grade < 0) grade = 0
    per100 = links * 100 / words
    go = grade - gc;   if (go < 0) go = 0
    xo = per100 - xc;  if (xo < 0) xo = 0
    # THE TWO OVERAGES ARE PRINTED RATHER THAN ONE COMPOSED READING, so each can be freed on its
    # own condition without a second arithmetic beside this one that could drift from it. The
    # grade term is freed below the sentence floor; the cross-reference term is freed for a
    # declared index. The empty exit above prints both overages as zero, which is the whole of
    # the repair for a file with nothing to read: no overage, so no penalty.
    printf "%d %d %d %d %d %d %d\n", int(go + 0.5), int(xo + 0.5), int(grade + 0.5), int(per100 + 0.5), words, links, sent
  }
' "$2"; }
# TWO READINGS FROM ONE FUNCTION, so the shadow can never drift from the reading it shadows. The
# `card` rule is the line filter this reading has always applied and is unchanged; the `register`
# rule is prose_register_scan.sh's own four line rules, spelled here because that scan holds them
# inside measure() rather than in a file this one can source. What the shadow reading exists for is
# stated in the comment below its own arithmetic: to MEASURE the standing question, never to answer
# it. Nothing in the default path reads the shadow.
reach_raw=$(reach_read card "$prose_path")
reach_raw_shadow=$(reach_read register "$prose_path")
# The whole-page count, extracted the way Truth extracts its citations, so the two readings of one
# file can never disagree about how many links it holds.
# Read from the file on disk rather than from `$prose_path`, which by here is the reference-block
# filtered copy the two scored readings share -- counting the page's links off a filtered copy would
# reproduce the very blindness this number exists to report.
links_all=$(awk '{ n += gsub(/\]\(/, "&") } END { print n + 0 }' "$root/$path" 2>/dev/null)
[ -n "$links_all" ] || links_all=0

set -- $reach_raw
grade_over=$1
xref_over=$2
grade=$3
xrefs=$4
words=$5
links=$6
reach_sentences=$7

# --- The page's own declaration: an index says so, and then measures like one ---------------------
# A cross-reference budget of one per hundred words is written for prose. On an index the links ARE
# the content, so the budget measures the page against a standard it was never built to meet:
# docs/README.md carries 10 words of prose and 5 links, which reads 50 per 100w against a budget of
# 1 and floors Reach at zero. That is a meter instructing a repair -- pad the page with prose --
# which would make the artifact worse, and a meter that does that is the thing to fix.
#
# So the card reads a page's own declaration, the way declared_ceiling reads a page's own limit.
# TWO conditions, never one, because a self-declared exemption is a door, and a door beside a wall
# makes the wall a habit again:
#
#   1. The page DECLARES itself an index, in its HEADER -- `**Depth:** routing` or `**Kind:** ...
#      index`. Header only, meaning the block above the first `---` rule, so a body that merely
#      discusses indexes declares nothing.
#   2. The page MEASURES as one -- under 100 words of prose. A rate expressed per hundred words is
#      extrapolation below one full unit of its own denominator, and that is the whole fault here.
#
# Measured 20260825 over every living page: four declare an index in their header, and three of them
# carry 13, 13, and 10 words. The fourth, docs-geode/edu/README.md, carries 193 and already reads A
# at 3 xrefs per 100w -- so the floor keeps a readable index graded and lifts only the pages whose
# denominator cannot carry the rate. That the pair discriminates on real data, before a line of this
# was written, is what makes it a reading rather than an opt-out.
index_floor=100
declares_index=no
awk 'NR <= 40 { if ($0 ~ /^---[ \t]*$/) exit; print }' "$root/$path" \
  | grep -qE '[*][*]Depth:[*][*][^|]*routing|[*][*]Kind:[*][*][^|]*index' && declares_index=yes

# THE FLOOR THE REGISTER READING ALREADY HOLDS, HONORED BY THE GRADE TERM AS WELL (REDS %407). A
# reading grade is two rates -- words per sentence, and syllables per word -- so it needs a
# denominator big enough to mean something, exactly as a share does. The card was checking that
# denominator for one scored reading and not the other, and in one run over one prose_path it would
# print `register=100 ... reported, not scored` beside a scored grade computed from the same words.
#
# THE EMPTY CASE IS THE PLAIN ONE, AND IT WAS THE WORST READING ON THE SCALE. When the prepared
# prose carries no sentence at all the awk above took an early exit whose first field was the reach
# itself, so a file with NOTHING to read scored Reach zero -- while its own grade printed 0 against
# a ceiling of 9. Measured 20260831 over 385 sampled artifacts: 17 carried zero words of prose and
# every one of them read reach=0.
#
# WHAT THE FLOOR REACHES, MEASURED RATHER THAN ESTIMATED. Of those 385 -- 55 record-only notation
# files, a 60-log sample, 163 programs, and all 107 documented notation files -- 207 sat under this
# floor and 137 of them took a scored Reach below 100 anyway. The worst readings are data corpora,
# where the syllable heuristic counts vowel groups inside a 128-character hex string:
# mycelium/corpora/braid_dag.bron reads 6.1 syllables per word and a grade of 59 over 30 words, and
# 41 of the 55 record-only files read D+ on that alone. Session logs are untouched -- 0 of 60 sat
# under the floor with a scored grade -- which is the answer to the door that sent this lap out.
#
# TWO TERMS, TWO DOORS, DELIBERATELY INDEPENDENT. The grade term is freed by a MEASURED sentence
# count; the cross-reference term is freed only by the index door below, which needs a page to
# DECLARE itself an index and to MEASURE as one. Keeping them apart is what lets this floor land
# without touching that decision: a twenty-word page with five links stays penalized for its link
# density, because a rate is still a rate, while it stops being graded on a readability score no
# twenty words can carry. The floor is read from the register scan rather than spelled here, so one
# number governs both readings and neither can drift from the other.
grade_mode=scored
reach_mode=graded
if [ "$sentences" -lt "$register_floor" ]; then
  grade_mode=reported
  grade_over=0
fi
if [ "$declares_index" = yes ] && [ "$words" -lt "$index_floor" ]; then
  reach_mode=index
  xref_over=0
fi

# One arithmetic, composed after both doors have had their say, so a page that qualifies for
# neither, either, or both is answered by the same line rather than by three of them.
reach=$(( 100 - 10 * grade_over - 10 * xref_over ))
[ "$reach" -lt 0 ] && reach=0

# --- The shadow reading: what the standing question would COST, measured rather than answered -----
# The report above says the two scored readings measure two different documents, and names the
# question on construction/ITINERARY.md rather than settling it: should Reach see what Register
# already sees? That question had a shape and no number. This is the number.
#
# The shadow runs the SAME reach arithmetic over the SAME prose_path under prose_register_scan.sh's
# line rules, and passes through the same two freeing doors -- the sentence floor for the grade
# term, the index door for the cross-reference term -- so the two readings differ in exactly one
# thing, which is the thing under question. It is PRINTED, never composed into `composite`, and
# nothing above reads it.
#
# MEASURED 20260907 over the 1,204 living tracked Markdown pages outside gratitude/, vendor/,
# seed/, session-logs/ and the dated shelves, at Service 100 so the counted half alone decides:
# pages 1,204 -- letters_moved 383 -- down 293, up 90 -- mean composite delta -0.99
# Reach falls on 479 pages and rises on 140. Across the B door: 55 pages cross BELOW it, 26 cross up.
# By room, the skew is the finding: foundations/ moves 26 pages and 25 of them DOWN;
# active-designing/ 55 down against 1 up; external-research/ 55 down against 14 up; .claude/rules/
# 13 of 51 pages move and 10 fall. counsel/, whose registers are mixed, is 30 down against 20 up.
# The widest single readings are context/specs/20260715-193000_two-dev-environments-and-mobile-
# emulation.md, A+ to C+ as Reach goes 100 to 0, and granary/README.md, C+ to A+ as it goes 0 to 90.
#
# THE DIRECTION IS THE FINDING, and it is the opposite of what the three pages that prompted this
# lap suggested. Admitting the dropped prose does two things at once. On a LONG page it restores
# hard, bold-led paragraphs, which raises the Flesch-Kincaid grade past the ceiling of 9 and Reach
# FALLS -- and those pages are this tree's own house style, .claude/rules/ above all, so the
# blind spot flatters precisely the prose written most carefully in this voice. On a SHORT page the
# current reading survives as a fragment of the shared navigation header whose link density floors
# it, so admitting the body dilutes the density and Reach RISES. Same blind spot, two populations,
# and the long one is far the larger.
#
# SO THE RE-GRADE IS A NET DEMOTION rather than the repair it looks like from three doors. That is
# worth knowing before anyone takes it, and it is why this stays reported. The question is still
# Keaton's; what changed is that it now has a cost attached.
set -- $reach_raw_shadow
shadow_grade_over=$1
shadow_xref_over=$2
shadow_words=$5
[ "$sentences" -lt "$register_floor" ] && shadow_grade_over=0
[ "$declares_index" = yes ] && [ "$shadow_words" -lt "$index_floor" ] && shadow_xref_over=0
reach_shadow=$(( 100 - 10 * shadow_grade_over - 10 * shadow_xref_over ))
[ "$reach_shadow" -lt 0 ] && reach_shadow=0

# Meter carries no reach budget, because refusal-first prose is the subject rather than a fault.
# A whole program is never Meter: its head remains Door and its bound lines are reported below.
[ "$setting" = "meter" ] && [ "$artifact_kind" != program ] \
  && { register=100; reach=100; reach_mode=meter; register_mode=meter; grade_mode=meter; }

# --- Truth, the counted half: every relative link resolves somewhere ------------------------------
# A relative citation belongs to the BODY that wrote it, and a symlink is a second door onto one
# body rather than a second copy of it. `pond/apps/granary/wov_core.rye` is mode 120000 pointing at
# `granary/wov_core.rye`; read at the link's own path its `](../context/specs/...)` lands in
# `pond/apps/context/`, and read at the body's path it lands exactly right. Six such doors read as
# eleven broken citations on 20260825, and repairing them would have written through the links into
# six correct bodies and broken all six at their real homes.
#
# So Truth resolves the link and reads the citation from where it was written. The card names that
# it did, because a reader deserves to know which of two doors was measured.
dir=$(cd "$root/$(dirname "$path")" 2>/dev/null && pwd)
[ -n "$dir" ] || dir=$root/$(dirname "$path")
path_kind=file
if [ -L "$root/$path" ]; then
  path_kind=symlink
  link=$(readlink "$root/$path")
  case "$link" in
    /*) linkdir=$(dirname "$link") ;;
    *)  linkdir=$(cd "$dir" 2>/dev/null && cd "$(dirname "$link")" 2>/dev/null && pwd) ;;
  esac
  [ -n "$linkdir" ] && dir=$linkdir
fi
cited=0
unresolved=0
illustrations=0
: > "$work/unresolved.txt"
: > "$work/illustrations.txt"
# A citation is a promise the FILE makes, and a program mostly makes none. In a prose file every
# link is a citation and is read as one. In a program, link syntax is almost always something else:
# a fixture the file plants in a throwaway pen, or a fragment of a page the file EMITS -- and a path
# in emitted output is relative to wherever that output lands rather than to the file that wrote it.
# tools/fixtures/g/geode_libraries_scan.sh writes `](../../README.md)` into a page that lives two
# directories away, and reading it from the scan's own directory lands outside the repository.
#
# So outside a prose file, a link counts only where the file is SPEAKING -- on a comment line, whose
# first non-whitespace is `//` or `#`, the two comment marks this tree's languages use.
#
# Measured 20260825, and the rule discriminates rather than merely quieting things down:
# pond/customs.rye keeps 3 of 3 and caravan/subscribe_poll_service.rye keeps 3 of 3, all genuine
# `//!` doc-comment citations; tools/rye/session_logs_archive.rye keeps its 2 real ones and drops 28
# fragments of the index rows it writes; six control scripts drop every planted fixture and keep
# nothing, which is right, because they cite nothing.
#
# A BROKEN link in a comment still counts. That is the half that keeps this a reading rather than a
# way for a program to stop being checked, and the control plants it.
#
# Prose files keep every line, deliberately: a Markdown heading begins with `#` and would read as a
# comment under the rule above, so applying it there would count only the headings.
#
# WHAT A PROSE FILE DOES DROP, seated `20260906.133800` -- the round this file's elder note asked
# for by name and declined to guess at. A link inside a backtick span or a fenced block is not a
# link: Markdown renders it as literal text, so it cites nothing and cannot be broken. The comments
# branch below has masked code spans since it was written; prose did not, and the cost fell on
# exactly the pages that follow the mark law most carefully. `.claude/rules/stamp-and-name.md` asks
# that an example path be built from PLACEHOLDERS -- `](X)`, `](../../Y)` -- and every page teaching
# the fold rule quotes that shape inside backticks, where this reading counted each one an
# unresolved citation and took 20 points of Truth for it. Measured `20260906.133800`: **30 wholly
# code-spanned link shapes across 12 tracked pages**, every one of them in a rule page, a design
# essay, or a REDS shelf explaining how a fold re-anchors.
#
# The elder note also feared the reach. It is bounded and it runs one way: masking can only REMOVE
# candidate targets, so `unresolved` can only fall and a grade can only rise or hold. Nothing that
# resolves today stops resolving.
#
# A fence toggles on a line whose first non-blank run is three or more backticks or tildes, which is
# the CommonMark rule as far as this needs it; an unclosed fence swallows the rest of the file,
# which is what a renderer does too.
case "$path" in
  *.md|*.mdc|*.markdown|*.bron|*.kyri) truth_source=prose ;;
  *)                                       truth_source=comments ;;
esac

if [ "$truth_source" = prose ]; then
  awk '
    /^[ \t]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    { line = $0; gsub(/`[^`]*`/, " code ", line); print line }
  ' "$root/$path" 2>/dev/null
else
  awk '/^[ \t]*(\/\/|#)/ { line = $0; gsub(/`[^`]*`/, " code ", line); print line }' "$root/$path" 2>/dev/null
fi | grep -o '](\([^)]*\))' | sed 's/^](//; s/)$//' | sed 's/#.*$//' > "$work/links.txt" || :
while IFS= read -r target; do
  [ -n "$target" ] || continue
  case "$target" in http*|mailto:*|'<'*) continue ;; esac
  # An example path in prose is a SHAPE -- `date/YYYYMMDD/name` -- with letter placeholders standing
  # where the digits would go. `.claude/rules/stamp-and-name.md` seats that spelling and asks for it
  # by name: build an illustration from placeholders and it stays honest; build one from a real-
  # looking stamp and a sprig naming no file, and it reads as a real citation to every reader and
  # every tool. So a placeholder run is an illustration rather than a citation.
  #
  # Only the two runs that law spells inside a path shape count, YYYYMMDD and HHMMSS. Measured
  # 20260825: zero of this tree's tracked paths carry either run literally, so the reading can never
  # swallow a real path, and exactly 8 links across all living Markdown match, in 4 files. A
  # FABRICATED stamp -- digits naming no file -- still counts against Truth, which is the half that
  # keeps this a reading rather than an escape hatch, and the control plants both halves.
  case "$target" in
    *YYYYMMDD*|*HHMMSS*|*"<"*">"*|*...*)
      illustrations=$((illustrations + 1))
      printf 'illustration: %s\n' "$target" >> "$work/illustrations.txt"
      continue ;;
  esac
  # In a program, a citation names a path, and `](` occurs in prose that means something else.
  # lotus/allpass.rye works an example through in a comment -- `x[1](32000) + 3/4-y[1](-32768)` --
  # where the brackets are array indices and the parentheses are values, and three "targets" of
  # 32000, -32768 and 7424 fall straight out of the pattern. So a target counts only where it looks
  # like a path: a slash, or a short trailing extension. `linengrow/murr.rye` cites its sibling as
  # `](murr_core.rye)` with no slash at all and that citation is real, which is why the extension
  # half is here rather than a plainer slash-only rule.
  if [ "$truth_source" = comments ]; then
    case "$target" in
      */*|*.??|*.???|*.????|*.?????) ;;
      *) continue ;;
    esac
  fi
  # A target carrying a backtick is not a path. The link grep matches `](` through a backtick span,
  # so a page quoting link syntax inside code marks -- `](../REDS.md)` in a REDS row explaining a
  # fold -- yields a "target" made of the prose between two spans. Zero tracked paths in this tree
  # contain a backtick, so this can never swallow a real one. Measured 20260825: it is the only such
  # artifact in the whole living non-yonder population, which is why a full fenced-block rule was
  # left alone -- it would touch 20+ documents to repair one reading.
  case "$target" in
    *'`'*) continue ;;
  esac
  cited=$((cited + 1))
  [ -e "$dir/$target" ] && continue
  [ -e "$root/$target" ] && continue
  base=$(basename "$target")
  day=$(echo "$base" | sed -n 's/^\([0-9]\{8\}\)-[0-9]\{6\}[_.].*/\1/p')
  if [ -n "$day" ]; then
    hit=$(find "$root" -path "*/date/$day/$base" -print -quit 2>/dev/null)
    [ -n "$hit" ] && continue
  fi
  unresolved=$((unresolved + 1))
  printf 'unresolved: %s\n' "$target" >> "$work/unresolved.txt"
done < "$work/links.txt"

truth_counted=$((100 - 20 * unresolved))
[ "$truth_counted" -lt 0 ] && truth_counted=0

# --- Service inputs: what a reader needs to supply the judged number ------------------------------
citers=$( ( cd "$root" && git grep -l -- "$(basename "$path")" -- ':!'"$path" 2>/dev/null ) | grep -cvE '(^|/)[0-9]{8}-[0-9]{6}[_.]|(^|/)date/' || : )
[ -n "$citers" ] || citers=0
named_by_card=no
[ -f "$root/construction/ITINERARY.md" ] && grep -q -- "$(basename "$path")" "$root/construction/ITINERARY.md" 2>/dev/null && named_by_card=yes
in_seed=no
if [ -f "$root/template-manifest.bron" ]; then
  room=$(echo "$path" | cut -d/ -f1)
  grep -qE "^allow ($room|$path)\$" "$root/template-manifest.bron" 2>/dev/null && in_seed=yes
fi

# --- The card ------------------------------------------------------------------------------------
echo "qa_path=$path"
echo "qa_setting=$setting"
echo "reference_lines=$reference_lines (held out of both readings and reported, like declaration docs)"
if [ "$artifact_kind" = program ]; then
  set -- $(measure "$work/program-meter.txt")
  meter_sentences=$1
  meter_negatives=$2
  meter_neg_pct=$3
  meter_words=$(awk '{ for (i = 1; i <= NF; i++) n++ } END { print n + 0 }' "$work/program-meter.txt")
  echo "program_dial=split (module head Door; invariant bounds Meter; declaration docs reported)"
  echo "program_head_lines=$program_head_lines"
  echo "program_meter_lines=$program_meter_lines"
  echo "program_decl_lines=$program_decl_lines"
  echo "meter_register=100 (negative $meter_neg_pct% of $meter_sentences sentences reported, not scored)"
  echo "meter_reach=100 ($meter_words words reported, not scored)"
fi
if [ "$artifact_kind" = notation ]; then
  echo "notation_dial=split (the comment block is the document; records are data, counted here)"
  echo "notation_comment_lines=$notation_comment_lines"
  echo "notation_record_lines=$notation_record_lines"
  echo "notation_meter=$notation_meter"
fi
if [ "$register_mode" = scored ]; then
  echo "register=$register (negative $neg_pct% of $sentences sentences)"
else
  echo "register=$register (negative $neg_pct% of $sentences sentences reported, not scored)"
fi
echo "register_mode=$register_mode (floor $register_floor sentences, cited from prose_register_scan.sh)"
echo "register_floor_met=$register_floor_met (at or above the $register_floor-sentence floor)"
if [ "$register_floor_met" = no ] && [ "$register_mode" = scored ]; then
  echo "detail: under the floor and scored anyway -- ${register_gap} points from the ${register_ceiling}% ceiling over $sentences sentences, so no single sentence could have carried this reading across it (REDS %430)"
fi
if [ "$grade_mode" = reported ]; then
  grade_note="grade $grade against $grade_ceiling reported, not scored"
else
  grade_note="grade $grade against $grade_ceiling"
fi
if [ "$reach_mode" = index ]; then
  xref_note="xrefs $xrefs per 100w reported, not scored"
else
  xref_note="xrefs $xrefs per 100w against $xref_ceiling"
fi
echo "reach=$reach ($grade_note; $xref_note; $words words, $links links)"
links_held=$(( links_all - links ))
[ "$links_held" -lt 0 ] && links_held=0
echo "reach_links=$links of $links_all on the page ($links_held held out with the lines that carry no sentence -- tables, lists, headings, bold-key header lines; reported, never scored)"

# THE OTHER HALF OF THE SAME BLINDNESS, and it needs no second copy of any filter to see. The line
# above reports the links this reading cannot count. This one reports the SENTENCES, and the two
# come from one cause: the comment above says a bold-key header line holds no sentence, which is
# true of a header line and false of a body paragraph -- and no rule here tells them apart. The
# skip is `/^[ \t]*[-*>#]/`, a marker ALONE, where prose_register_scan.sh takes `/^[ \t]*[-*+][ \t]/`,
# a marker THEN whitespace, and holds the front-matter block out by its own frontmatter_key(). So
# `**What would enter:** a piece written to be read for its own sake ...` opens with `*` and is
# dropped here as a bullet, while the register reading opposite reads it as the prose it is.
#
# TWO SCORED READINGS ON ONE CARD THEREFORE MEASURE TWO DIFFERENT DOCUMENTS, which is the exact
# agreement the sentence-floor comment above asserts holds ("both scored readings must answer it
# the same way"). The floor made them agree about HOW MUCH prose there is; nothing made them agree
# about WHICH LINES it is.
#
# MEASURED 20260907 over 5,583 tracked Markdown files outside gratitude/ and vendor/: 1,330 carry a
# bold-led body paragraph this reading drops -- 5,854 paragraphs, 349,913 words. Excluding the
# Meter-class ledgers and the dated shelves, 480 living pages lose 130,902 words, 30% of their
# prose; 88 lose over half, and 12 are graded on under a tenth of their own page.
#
# THE HARM RUNS BOTH WAYS, which is why no grade sweep ever caught it. On a long page the dropped
# prose leaves almost nothing to fault, so Reach reads 100 and the grade goes UP:
# foundations/20260702-202612_a-conversation-with-serena.md carries 1,132 words and is read on 3,
# context/THREATS.md 975 read on 13, docs-geode/libraries/README.md 661 read on 13 -- all three
# Reach 100. On a short page the drop leaves a fragment of the shared navigation header behind and
# its link density floors the reading, so the grade goes DOWN: docs-geode/blog/README.md holds 249
# words and 6 links, is read on 35 and 2, and takes Reach 10 for it.
#
# REPORTED, NEVER RE-GRADED, on the same reasoning the link count above already carries: admitting
# these lines would re-grade the tree in one unmeasured step, and this file refuses that shape
# twice already. The number is published so a reader can no longer quote `words` as the page's
# prose, and the standard question -- should Reach see what Register already sees -- is named on
# construction/ITINERARY.md rather than settled quietly inside a report.
reach_prose_held=$(( sentences - reach_sentences ))
[ "$reach_prose_held" -lt 0 ] && reach_prose_held=0
echo "reach_prose=$reach_sentences of $sentences sentences the register reading sees ($reach_prose_held held out where the two line rules part -- both now read a marker then whitespace, so what parts company is the \`**Key:**\` header line this reading holds out and the register reading counts; reported, never scored)"
echo "reach_mode=$reach_mode (declares_index=$declares_index; index floor $index_floor words)"
echo "grade_mode=$grade_mode (floor $register_floor sentences, cited from prose_register_scan.sh)"
echo "truth_counted=$truth_counted ($unresolved of $cited cited paths unresolved; $illustrations placeholder shapes read as illustrations)"
echo "truth_source=$truth_source (a program cites in its comments; a prose file cites everywhere)"
[ "$path_kind" = symlink ] && echo "path_kind=symlink (citations read from the body at $dir)"
[ -s "$work/unresolved.txt" ] && cat "$work/unresolved.txt"
[ -s "$work/illustrations.txt" ] && cat "$work/illustrations.txt"
echo "service_inputs living_citers=$citers named_by_card=$named_by_card in_seed=$in_seed"

truth=$truth_given
[ "$truth" -lt 0 ] && truth=$truth_counted
echo "truth=$truth"

# The scale, printed where the judgment is made rather than only where the arithmetic is (REDS
# %361). Additive on purpose: a witness, two launchers, and three scans read this card, so the
# `service=` line keeps its shape and this one stands beside it.
echo "service_scale=0-100 -- four questions worth 25 each: named, reached, current, side"

if [ "$service" -lt 0 ]; then
  echo "service=judged"
  echo "composite=judged -- hand in --service to close the card"
  exit 0
fi

echo "service=$service"
composite=$(( (register + reach + truth + service + 2) / 4 ))
composite_shadow=$(( (register + reach_shadow + truth + service + 2) / 4 ))
[ "$composite_shadow" -gt 100 ] && composite_shadow=100
[ "$composite" -gt 100 ] && composite=100

# Truth is a gate rather than a quarter. A page whose claims have gone false costs a reader more
# than an absent one, so honesty-first is written into the arithmetic rather than left to a habit.
gated=no
if [ "$truth" -lt 60 ]; then
  composite=59
  gated=yes
fi

[ "$gated" = yes ] && composite_shadow=59
echo "truth_gate=$gated"
echo "composite=$composite"
echo "letter=$(letter_for "$composite")"
echo "reach_shadow=$reach_shadow (reported, never scored -- Reach under the register reading's line rules)"
echo "composite_shadow=$composite_shadow"
echo "letter_shadow=$(letter_for "$composite_shadow")"
