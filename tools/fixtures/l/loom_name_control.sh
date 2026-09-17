#!/bin/sh
# tools/fixtures/l/loom_name_control.sh -- prove the name reading on a planted corpus.
#
#   sh tools/fixtures/l/loom_name_control.sh
#
# Every reading `tools/fixtures/l/loom_name_scan.sh` prints is asserted here against a corpus whose
# right answer was worked out by hand before the scan ran, and every verdict is shown from BOTH
# sides -- planted so it fires, then changed so the same pen gives a different word. A verdict
# proven in one direction alone cannot be told from a constant.
#
# THAT IS THE LOAD-BEARING REASON THIS PEN EXISTS, and it is measured rather than assumed. Over the
# 60 keys `tools/l/loom_trend.sh --keys` lists, the live journal returns `name_shared` **60 times
# and the other two verdicts never** (`20260917`). An instrument whose corpus only ever draws one of
# its three answers is indistinguishable, from the corpus alone, from an instrument that can only
# say one thing. So `name_scopes` and `kind_scopes` are proven here, on corpora built to draw them.
#
# THE PEN IS A REAL GIT REPOSITORY, because the read is `git ls-files` and a directory walk would
# prove a different instrument than the one that ships.
#
# MUTATIONS RUN EVERY PASS rather than being recorded once, and each is preceded by a check that its
# own marker still stands in the source -- a mutation removing nothing reads as a passing leg.
#
# No network, no key, no funds, no device. Writes only inside a temporary pen it removes.

set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
pen=$(mktemp -d "${TMPDIR:-/tmp}/loom-name-pen.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

. "$root/tools/fixtures/s/shell_portable.sh"

legs=0
failed=0

leg() { # leg NAME WANT GOT
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 ok want=$2"
  else
    failed=$((failed + 1))
    echo "leg $1 FAILED want=$2 got=$3"
  fi
}

plant() { # plant CORPUS DAY NAME LINE...
  c=$1; d=$2; n=$3; shift 3
  mkdir -p "$c/session-logs/date/$d"
  f="$c/session-logs/date/$d/$d-000000_$n.kyri"
  {
    echo "format session-log-v1"
    echo "stamp $d.000000"
    for l in "$@"; do echo "$l"; done
  } > "$f"
}

newcorpus() { # newcorpus NAME -> path
  c="$pen/$1"
  mkdir -p "$c"
  ( cd "$c" && git init -q . && git config user.email pen@example.invalid && git config user.name pen ) >/dev/null
  echo "$c"
}

commitall() { ( cd "$1" && git add -A && git -c commit.gpgsign=false commit -qm pen ) >/dev/null; }

scan() { # scan CORPUS KEY [MODE]
  LOOM_ROOT="$1" sh "$root/tools/fixtures/l/loom_name_scan.sh" "$2" "${3-summary}" 2>&1 || true
}

field() { printf '%s\n' "$1" | grep -E "^$2=" | head -1 | cut -d= -f2- | cut -d' ' -f1; }
field2() { printf '%s\n' "$1" | grep -E "(^| )$2=" | head -1 | tr ' ' '\n' | grep -E "^$2=" | cut -d= -f2-; }

# ---------------------------------------------------------------- A: name_shared, both forms
# Worked by hand BEFORE the scan ran. Six occurrences of `v`:
#   witness=alpha x2, witness=beta x1   -> kind `witness`, 3 occurrences, 2 scopes
#   roster=gamma x1                     -> kind `roster`,  1 occurrence,  1 scope
#   molt x1                             -> bare form: kind and scope both `molt`
#   leading numeric x1                  -> declares nothing: scope `-`, counted undeclared
# declared 5, kinds 3, scopes 4, top kind `witness` at 3/5 = 600 ppt.
A=$(newcorpus shared)
plant "$A" 20260101 one   "loom witness=alpha v=10"
plant "$A" 20260101 two   "loom witness=alpha v=12"
plant "$A" 20260102 three "loom witness=beta v=14"
plant "$A" 20260102 four  "loom roster=gamma v=20"
plant "$A" 20260103 five  "loom molt v=30"
plant "$A" 20260103 six   "loom files=99 v=40"
commitall "$A"
out=$(scan "$A" v)

leg occurrences "6" "$(field "$out" occurrences)"
leg declared "5" "$(field2 "$out" declared)"
leg undeclared "1" "$(field2 "$out" undeclared)"
leg kinds "3" "$(field2 "$out" kinds)"
leg scopes "4" "$(field2 "$out" scopes)"
leg top_kind "witness" "$(field2 "$out" top_kind)"
leg top_kind_ppt "600" "$(field2 "$out" top_kind_ppt)"
leg verdict_shared "name_shared" "$(field "$out" verdict)"

# The bare form is a scope rather than a skipped token, and the numeric leader is not a label.
leg bare_is_a_scope "1" "$(scan "$A" v --explain | grep -c '^scope molt kind=molt occurrences=1$')"
leg numeric_leader_no_scope "0" "$(scan "$A" v --explain | grep -c '^scope files')"
leg explain_lists_all "4" "$(scan "$A" v --explain | grep -c '^scope ')"

# ---------------------------------------------------------------- B: kind_scopes
# One kind, three instances -- LOOM_FAMILY=witness reaches every value, a rename need not.
B=$(newcorpus kindscoped)
plant "$B" 20260101 one   "loom witness=alpha v=10"
plant "$B" 20260101 two   "loom witness=beta v=12"
plant "$B" 20260102 three "loom witness=gamma v=14"
commitall "$B"
outb=$(scan "$B" v)
leg kind_kinds "1" "$(field2 "$outb" kinds)"
leg kind_scopes_n "3" "$(field2 "$outb" scopes)"
leg kind_ppt "1000" "$(field2 "$outb" top_kind_ppt)"
leg verdict_kind "kind_scopes" "$(field "$outb" verdict)"

# ---------------------------------------------------------------- C: name_scopes, measured
# One scope written four times -- the only reading where the name genuinely holds the population.
C=$(newcorpus scoped)
plant "$C" 20260101 one   "loom roster=cold v=10"
plant "$C" 20260101 two   "loom roster=cold v=12"
plant "$C" 20260102 three "loom roster=cold v=14"
plant "$C" 20260102 four  "loom roster=cold v=16"
commitall "$C"
outc=$(scan "$C" v)
leg scoped_scopes "1" "$(field2 "$outc" scopes)"
leg verdict_scoped "name_scopes" "$(field "$outc" verdict)"
leg scoped_evidence "measured" "$(field "$outc" scope_evidence)"
leg scoped_no_singleton_detail "0" "$(printf '%s\n' "$outc" | grep -c 'one occurrence')"

# ---------------------------------------------------------------- D: the singleton trap
# One occurrence has one scope by arithmetic. The verdict still reads name_scopes -- it is true --
# and the detail line says the reading is unmeasured, which is the sibling's own singleton lesson.
D=$(newcorpus singleton)
plant "$D" 20260101 one "loom history=drop v=10"
commitall "$D"
outd=$(scan "$D" v)
leg singleton_verdict "name_scopes" "$(field "$outd" verdict)"
leg singleton_evidence "unmeasured" "$(field "$outd" scope_evidence)"
leg singleton_named "1" "$(printf '%s\n' "$outd" | grep -c 'arithmetic rather than evidence')"

# ---------------------------------------------------------------- E: undeclared only
# Every line leads with a measurement, so no population is declared anywhere.
E=$(newcorpus undeclared)
plant "$E" 20260101 one "loom files=99 v=10"
plant "$E" 20260102 two "loom files=98 v=12"
commitall "$E"
oute=$(scan "$E" v)
leg undeclared_only_verdict "undeclared_only" "$(field "$oute" verdict)"
leg undeclared_only_count "2" "$(field2 "$oute" undeclared)"
leg undeclared_only_declared "0" "$(field2 "$oute" declared)"
leg undeclared_only_kinds "0" "$(field2 "$oute" kinds)"

# ---------------------------------------------------------------- F: absent key, and the empty corpus
leg absent_verdict "absent" "$(field "$(scan "$A" nosuchkey)" verdict)"
leg absent_occurrences "0" "$(field "$(scan "$A" nosuchkey)" occurrences)"

F=$(newcorpus empty)
mkdir -p "$F/session-logs/date/20260101"
( cd "$F" && : > .keep && git add -A && git -c commit.gpgsign=false commit -qm pen ) >/dev/null
outf=$(scan "$F" v)
leg empty_corpus_refuses "1" "$(printf '%s\n' "$outf" | grep -c 'no tracked session logs')"

# ---------------------------------------------------------------- G: LOOM_FAMILY is honored
# Scoping the shared corpus to one kind must leave exactly that kind standing.
outg=$(LOOM_ROOT="$A" LOOM_FAMILY=witness sh "$root/tools/fixtures/l/loom_name_scan.sh" v 2>&1 || true)
leg family_filter_kinds "1" "$(field2 "$outg" kinds)"
leg family_filter_verdict "kind_scopes" "$(field "$outg" verdict)"

# ---------------------------------------------------------------- H: non-numeric values are counted
# A population of witness names is a legitimate reading; this scan takes no median, so it keeps them.
H=$(newcorpus words)
plant "$H" 20260101 one "loom roster=cold v=green"
plant "$H" 20260101 two "loom witness=alpha v=red"
commitall "$H"
outh=$(scan "$H" v)
leg words_counted "2" "$(field "$outh" occurrences)"
leg words_verdict "name_shared" "$(field "$outh" verdict)"

# ---------------------------------------------------------------- I: the sibling projections agree
# loom_values and loom_family_values read one grammar, so the rows they emit must agree in count
# and in value. A drift here is the braid this file's sibling was split to prevent.
. "$root/tools/fixtures/l/loom_values.sh"
( cd "$A" && LOOM_ROOT="$A" :; )
( cd "$A"
  . "$root/tools/fixtures/l/loom_values.sh"
  loom_values v "$pen/plain.txt"
  loom_family_values v "$pen/fam.txt"
) >/dev/null 2>&1
leg projections_same_count "$(grep -c . "$pen/plain.txt")" "$(grep -c . "$pen/fam.txt")"
leg projections_same_values \
  "$(cut -f2 "$pen/plain.txt" | sort | tr '\n' ',')" \
  "$(cut -f2 "$pen/fam.txt" | sort | tr '\n' ',')"

# ---------------------------------------------------------------- mutations
mutate() { # mutate NAME SRC MARKER SED_EXPR FIELD CORPUS KEY HONEST_VALUE
  mname=$1; msrc=$2; marker=$3; expr=$4; fld=$5; corp=$6; mkey=$7; base=$8
  legs=$((legs + 1))
  if ! grep -q -- "$marker" "$msrc"; then
    failed=$((failed + 1)); echo "leg mutation_marker_$mname FAILED -- the line it removes is gone: $marker"; return
  fi
  echo "leg mutation_marker_$mname ok want=present"
  cp "$msrc" "$pen/orig.$mname"
  sed_inplace "$expr" "$msrc"
  got=$(LOOM_ROOT="$corp" LOOM_FAMILY="${MUT_FAMILY:-}" sh "$root/tools/fixtures/l/loom_name_scan.sh" "$mkey" 2>&1 || true)
  cat "$pen/orig.$mname" > "$msrc"
  legs=$((legs + 1))
  gotv=$(printf '%s\n' "$got" | grep -oE "(^| )$fld=[^ ]*" | head -1 | cut -d= -f2-)
  if [ "$gotv" = "$base" ]; then
    failed=$((failed + 1)); echo "leg mutation_$mname FAILED -- removing it moved nothing; $fld still reads $base"
  else
    echo "leg mutation_$mname ok want=bitten got=$gotv"
  fi
}

SCANSRC="$root/tools/fixtures/l/loom_name_scan.sh"
SIBSRC="$root/tools/fixtures/l/loom_values.sh"

# M1 -- read a numeric leading token as a label. Corpus A's `files=99` line would become a scope,
# so the undeclared count falls and a measurement is reported as a population.
mutate numeric_is_not_a_label "$SIBSRC" 'if (v + 0 == v) return "-"' \
  's|if (v + 0 == v) return "-"|if (0) return "-"|' undeclared "$A" v 1
# M2 -- drop the bare form, so `loom molt v=30` loses the only scope it declares.
mutate bare_form_read "$SIBSRC" 'if (eq == 0) return tok' \
  's|if (eq == 0) return tok|if (eq == 0) return "-"|' scopes "$A" v 4
# M3 -- take the kind as the whole token, so `witness=alpha` and `witness=beta` stop being one kind
# and corpus B's kind_scopes verdict collapses.
mutate kind_is_the_leading_key "$SIBSRC" 'return substr(scope, 1, eq - 1)' \
  's|return substr(scope, 1, eq - 1)|return scope|' verdict "$B" v kind_scopes
# M4 -- let the singleton pass unnamed, which is the sibling's own booked fault in this room.
mutate singleton_named "$SCANSRC" '(declared == 1 ? "unmeasured" : "measured")' \
  's|(declared == 1 ? "unmeasured" : "measured")|("measured")|' scope_evidence "$D" v unmeasured
# M5 -- drop the family filter in the SIBLING, read through the scan that sources it.
MUT_FAMILY=witness
mutate sibling_family "$SIBSRC" 'index(line, fam) == 0' \
  's/if (fam != "" \&\& index(line, fam) == 0) continue//' kinds "$A" v 1
MUT_FAMILY=

# THE LEG TALLY RIDES BESIDE THE VERDICT. A control reaching its last line says only that it
# reached it, so a leg written tomorrow and counted by nobody would ride under a green witness.
EXPECTED_LEGS=45
echo "control_legs=$legs"
echo "control_expected=$EXPECTED_LEGS"
echo "control_failed=$failed"
echo "control_verdict=$([ "$failed" -eq 0 ] && [ "$legs" -eq "$EXPECTED_LEGS" ] && echo ok || echo red)"
