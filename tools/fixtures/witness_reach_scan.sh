#!/bin/sh
# tools/fixtures/witness_reach_scan.sh -- which witnesses on disk does a runner actually run?
#
# WHY THIS EXISTS. construction/standing-equipment.kyri opens with the sentence this meter measures:
# "a guard that is never run guards nothing either." The roster names what stands; nothing counted
# what stands OUTSIDE it. active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md
# booked the question by name and left it open: "whether every witness on disk is reached by
# something ... means tracing reachability rather than comparing counts, which is a round of its own."
# This is that round. It traces reachability.
#
# WHAT IT READS. Every tracked *.rish and *.sh source plus tools/hooks/*, for paths in INVOCATION
# position, and follows them from the roster outward. Seven readings come out, and the last is the
# gated one:
#
#   total     every tracked *_witness.rish on disk
#   standing  reachable from the roster's EVERY-LAP rows, transitively -- sung on every lap
#   cadence   reachable from the roster's CADENCE rows and not from the every-lap ones -- heard on
#             the fifth round, which is a slower promise and so a separate number. Reading the two
#             as one would report 75 crypto witnesses as sung every lap on the strength of a row
#             that runs once in five, which is a truer-SOUNDING number than the one before it.
#   reached   standing + cadence -- the witnesses a clock actually carries
#   sung      named in an invocation position by any runner on disk, roster or choir. A NAME is all
#             this reading takes. Whether anything runs the file doing the naming is the separate
#             question the two bands below answer.
#   unclocked named by some runner, and no roster row reaches that runner -- a promise with nobody
#             to keep it
#   unheard   named by no runner at all
#   unreached unclocked + unheard, which is total - standing - cadence. THIS IS THE GATED NUMBER.
#
# TWO MORE READINGS, REPORTED RATHER THAN GATED, and the reason they are not gated is the whole
# point of them (20260828.150430):
#
#   outside_convention  a tracked .rish that NAMES ITSELF A WITNESS on its own first line and
#                       carries a top-level `assert`, and does not wear the `_witness.rish`
#                       suffix -- so `total` above, which is `git ls-files '*_witness.rish'`,
#                       never counts it and no reading here has ever described it
#   outside_dark        of those, the ones no other tracked runner names at all
#
# WHY THIS POPULATION EXISTS AT ALL. tools/ca/caravan_suite_witness.rish:31 records the same
# defect found by hand on 20260827: eight runners stood in tools/ca/ outside the suffix, the only
# living roster that ran them was tools/p/parity_ch01.rish -- itself on no standing roster -- and
# ONE OF THE EIGHT HAD BEEN RED. They were renamed to carry `_witness` and the roster read 121
# rather than 113. That file writes the general lesson in its own words: "when a guard finds its
# subjects by name, the naming convention IS the guard, and anything outside it is not guarded at
# all." The repair stopped at Caravan. This reading is that sentence turned into a number, so the
# next such file is met on the lap it lands rather than by the next hand that happens to look.
#
# WHY REPORTED AND NOT GATED, stated plainly because a reader will reach for a ceiling here. The
# established repair is Caravan's: rename the file so the suffix carries it. Yet a renamed file
# joins `total`, and these are unclocked, so each rename raises `unreached` by one against a
# CEILING that only falls. Measured 20260828: 119 outside the convention, `unreached` 1140 under a
# ceiling of 1154. Gating this number would push a hand toward a rename that reds the gate beside
# it -- one guard demanding what another forbids, which is how a wall becomes a thing people turn
# off. The tier that rosters tools/p/parity.rish is the real answer, and it costs build time, so
# it is Keaton's word. Reporting is the honest act until then, which is the same ruling
# tools/fixtures/room_bound_scan.sh reached for a terminal shelf.
#
# THE SUFFIX IS BAKED IN TWICE, worth knowing before trusting these two numbers as complete: the
# choir-edge extractor below also greps `_witness\.rish`, so a choir listing an outside-convention
# file reaches it in `e_call` only when the call is spelled out in command position.
#
# WHY THE GATE SITS ON `unreached` RATHER THAN ON `unheard` (REDS %224, 20260825.162410). A ratchet
# is worth its authority when the number stands for the property. A ceiling on `unheard` falls when
# a choir is WRITTEN: list a hundred witnesses in a new file, leave it off the roster, and the
# number drops by a hundred while exactly the same guards run as the day before. A ceiling on
# `unreached` falls when a choir is ROSTERED, which is the lap its rungs begin to run. The move is
# strictly stronger, since every unheard witness is also unreached -- nothing formerly caught now
# passes. Measured the day the gate moved: 265 witnesses stood named by a runner no roster row
# reaches, so the old gate read 937 while 1,202 of 1,692 were carried by no clock.
#
# WHAT COUNTS AS AN INVOCATION, and why the distinction is the whole difficulty. A path NAMED is not
# a path RUN. REDS %218 taught the same line one direction over: a citation in a comment is a promise
# rather than a call. Three shapes here look like calls and are not, and each was found in real
# sources on 20260825 while this meter was being written:
#
#   grep -oE '...' tools/cr/crypto_suite_witness.rish     a file read as DATA (crypto_count_guard:73)
#   "**Ran:** `rishi/bin/rishi run ..._witness.rish`"     a string a script PRINTS (the almanac)
#   #   rishi/bin/rishi run tools/x/foo_witness.rish      a comment's usage line, in every witness
#
# So the rule is command position, applied uniformly: a comment line is skipped, a quoted span is
# data, and what remains is split at the shell's own command separators. A `-c` payload is unwrapped
# first and read by the same rule, because `run ["sh" "-c" "rishi run x"]` genuinely calls x while
# `run ["sh" "-c" "grep x"]` genuinely does not. In Rishi, `run ["rishi/bin/rishi" "run" "<path>"]`
# and `run ["sh" "<path>"]` are calls by shape. A choir -- a file handing a VARIABLE to `rishi run`
# and singing a list -- reaches every witness in its `let ... = [ ... ]` literals.
#
# THE HONEST LIMIT, named rather than hidden. An invocation through a variable the meter cannot
# resolve (`rishi/bin/rishi run "$generator"` in tools/hooks/pre-commit) is invisible to it, so
# `unheard` and `unreached` are UPPER bounds on what is truly unrun, and every name in either is
# worth reading before it is believed. The meter proves a witness is reachable from a roster row;
# whether that row's guard asserts anything worth asserting is the reading beside it, taken by a
# person.
#
# USAGE
#   sh tools/fixtures/witness_reach_scan.sh              # the seven readings
#   sh tools/fixtures/witness_reach_scan.sh --list       # the unheard, one per line
#   sh tools/fixtures/witness_reach_scan.sh --unclocked  # named by a runner nothing runs
#   sh tools/fixtures/witness_reach_scan.sh --unreached  # the gated set: unclocked + unheard
#   sh tools/fixtures/witness_reach_scan.sh --sung       # the sung, one per line
#   sh tools/fixtures/witness_reach_scan.sh --standing   # the every-lap set, one per line
#   sh tools/fixtures/witness_reach_scan.sh --cadence    # the every-fifth-lap set, one per line
#   sh tools/fixtures/witness_reach_scan.sh --families   # the UNREACHED, grouped by name prefix --
#                                                        # the census follows the gate, so a family
#                                                        # count and the ceiling mean one thing
#   sh tools/fixtures/witness_reach_scan.sh --families-unheard   # the older reading, kept, since it
#                                                        # answers "has the choir been written yet"
#   sh tools/fixtures/witness_reach_scan.sh --outside    # self-declared witnesses the suffix
#                                                        # hides from every reading above
#
# Run from the repository root. WITNESS_REACH_CEILING overrides the ceiling, for the control alone.

set -u

# One dialect for both piers: xargs_lines / xargs_lines_batched run a command over a
# newline-delimited path list in a spelling GNU and BSD userland both accept.
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"

# The ceiling holds `unreached`, only falls, and carries no slack. Measured 20260825.162410 on this
# pier: 1,692 tracked witnesses, 168 standing, 322 cadence, 490 reached, 755 sung, 265 unclocked,
# 937 unheard, 1,202 unreached. Measured again 20260825.234902 after the season leaf choir was
# rostered: 1,695 tracked, 171 standing, 370 cadence, 541 reached, 787 sung, 246 unclocked,
# 908 unheard, 1,154 unreached.
#
# HOW THE READINGS MOVED, so a later lap can tell a real fall from a bookkeeping one. Standing read
# 56 on the morning this meter was written and moved to 167 in one roster row, when
# tools/ca/caravan_suite_witness.rish was seated and carried its 111 rungs with it; the cadence
# column opened at 82 the same way, when tools/cr/crypto_suite_witness.rish took the first
# `tier cadence` row and brought its family with it. That choir was itself UNHEARD until that row,
# which is why unheard fell by exactly one while cadence rose by 82: its rungs were already sung,
# by a choir nothing ran. Then the largest family moved in one round -- tools/al/ales_suite_witness.rish
# was WRITTEN on 20260825.132121, took the second `tier cadence` row, and carried 240 into cadence
# while unheard fell 1,176 to 937.
#
# Both of those falls were real, because each choir took a roster row in the same lap it was
# written. The gate now REQUIRES that pairing rather than trusting it: `unreached` moves only when
# a row lands. Lower the ceiling whenever a choir lands WITH its roster row.
#
# 1201 -> 1154 on 20260825.234902, a fall of 47: the season leaf choir took a `tier cadence` row
# and carried the 33 leaves it sings plus the 14 more those leaves reach. The choir DECLARES its
# 33 with a `# reach-list:` enumerator rather than leaving this meter to read its glob, which
# selects 144 and would have overstated the fall by 111 (REDS %238). A ceiling falls by what a
# row carries, and what a row carries is a thing to ask rather than infer.
#
# 1202 -> 1201 on 20260825.183336, and the single step is the point. tools/r/remember_git_nib_witness.rish
# had stood in the `unclocked` band its whole life -- the loom booked after the nib class fired
# twice, named by files no roster row reaches -- and the lap that needed it found the card carrying
# a hash that resolved nowhere (REDS %228). One roster row moved it to `standing`. A second row
# seated tools/r/reds_ledger_headline_witness.rish, born rostered, which raises `total` and
# `standing` together and leaves `unreached` where it stood. So the number fell by exactly the one
# file that changed clocks, which is what this gate was rewritten to mean.
CEILING=${WITNESS_REACH_CEILING:-1154}
# The family ceiling, seated 20260828 at what the tree measured that day: 222 of 291 families carry
# no clock at all. It only falls, and it falls whenever a family's first roster row lands. It is a
# ratchet rather than a wall at zero for the same reason CEILING is: a wall that refuses ordinary
# work is a wall somebody turns off.
FAMILY_CEILING=${WITNESS_REACH_FAMILY_CEILING:-222}

mode="${1:-}"
roster=construction/standing-equipment.kyri

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

git ls-files '*_witness.rish' | sort -u > "$pen/all"
git ls-files '*.rish' '*.sh' 'tools/hooks/*' | sort -u > "$pen/sources"

# One awk pass over every source, emitting "<caller>TAB<callee>" for each invocation it can see.
xargs_lines "$pen/sources" awk '
  function emit(p) { if (p ~ /\.(rish|sh)$/) print FILENAME "\t" p }

  # Command position, applied to one stretch of shell text.
  function commands(text,   n, part, i, s, t) {
    gsub(/[;&|(){}`]|\$\(/, "\n", text)
    n = split(text, part, "\n")
    for (i = 1; i <= n; i++) {
      s = part[i]; sub(/^[[:space:]]+/, "", s)
      if (match(s, /^(sh|bash)[[:space:]]+[A-Za-z0-9_.\/-]+\.(sh|rish)/)) {
        t = substr(s, RSTART, RLENGTH); sub(/^[a-z]+[[:space:]]+/, "", t); emit(t)
      }
      if (match(s, /^(rishi\/bin\/)?rishi[[:space:]]+run[[:space:]]+[A-Za-z0-9_.\/-]+\.rish/)) {
        t = substr(s, RSTART, RLENGTH); sub(/.*[[:space:]]/, "", t); emit(t)
      }
    }
  }

  /^[[:space:]]*#/ { next }
  {
    # Rishi calls by shape: run ["rishi/bin/rishi" "run" "<path>"].
    line = $0
    while (match(line, /run \[[[:space:]]*"rishi\/bin\/rishi"[[:space:]]+"run"[[:space:]]+"[^"]+"/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln); sub(/.*"run"[[:space:]]+"/, "", seg); sub(/"$/, "", seg)
      emit(seg); line = substr(line, st + ln)
    }

    # Rishi calls by shape: run ["sh" "<path>"], where the first argument is never a flag.
    line = $0
    while (match(line, /run \[[[:space:]]*"(sh|bash)"[[:space:]]+"[^"-][^"]*"/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln); sub(/^run \[[[:space:]]*"(sh|bash)"[[:space:]]+"/, "", seg); sub(/"$/, "", seg)
      emit(seg); line = substr(line, st + ln)
    }

    # A -c payload is shell text in either language. RSTART and RLENGTH are saved BEFORE the call,
    # because commands() runs match() of its own and would otherwise leave RLENGTH at -1 here --
    # substr(line, -1) returns the whole line, and the loop never advances. Found by hanging.
    line = $0
    while (match(line, /("-c"[[:space:]]+"[^"]*"|-c[[:space:]]+"[^"]*")/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln); sub(/^"?-c"?[[:space:]]+"/, "", seg); sub(/"$/, "", seg)
      commands(seg); line = substr(line, st + ln)
    }

    # A WRAPPER HANDS ON A COMMAND, and everything after a bare "--" element is that command.
    # run ["sh" "tools/p/parity_time_one.sh" "rbwire" "--" "rishi/bin/rishi" "run" "<path>"] calls
    # <path> as surely as a bare `rishi run` does; the wrapper only times it. Reading the wrapper
    # alone and stopping there made 430 real invocations invisible to this graph (REDS %317), which
    # is why `unheard` -- "named by no runner at all" -- was reporting 109 witnesses that a runner
    # names in plain command position. The tail is unquoted into words and read by the same
    # commands() rule as every other shape, so a wrapper earns no privilege the rest do not have.
    line = $0
    while (match(line, /run \[[^]]*"--"[^]]*\]/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln)
      sub(/^.*"--"/, "", seg)
      gsub(/"/, " ", seg); sub(/\]/, " ", seg)
      commands(seg); line = substr(line, st + ln)
    }

    # AN ENV PREFIX IS NOT A COMMAND EITHER. run ["env" "PARITY_COST_CHAPTER=ch01" ...
    # "rishi/bin/rishi" "run" "<path>"] is how tools/p/parity.rish calls both parity choirs, and
    # reading the first token alone saw "env" and stopped. Drop a leading `env` and every
    # VAR=value token, then read what remains by the same rule -- the assignments are the
    # environment, and the command starts after them.
    line = $0
    while (match(line, /run \[[[:space:]]*"env"[^]]*\]/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln)
      sub(/^run \[[[:space:]]*"env"/, "", seg)
      gsub(/"/, " ", seg); sub(/\]/, " ", seg)
      while (match(seg, /^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*/)) sub(/^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*/, "", seg)
      commands(seg); line = substr(line, st + ln)
    }

    # What is left once every quoted span is blanked: a quoted span is data, never a command.
    line = $0
    gsub(/"[^"]*"/, " ", line); gsub(/\047[^\047]*\047/, " ", line)
    commands(line)
  }
' > "$pen/e_call" 2>/dev/null

# A choir hands a VARIABLE to `rishi run`, so every witness in its list literals is sung by it.
xargs_lines "$pen/sources" grep -lE 'run \[[[:space:]]*"rishi/bin/rishi"[[:space:]]+"run"[[:space:]]+[A-Za-z_]' 2>/dev/null \
  | sort -u > "$pen/choirs"
: > "$pen/e_choir"
while IFS= read -r c; do
  grep -vE '^[[:space:]]*#' "$c" 2>/dev/null | grep -E '^[[:space:]]*let [A-Za-z_]+ = \[' \
    | grep -oE '[A-Za-z0-9_./-]+_witness\.rish' | sort -u | sed "s|^|$c	|" >> "$pen/e_choir"
done < "$pen/choirs"

# A DISCOVERING CHOIR reaches what its own rule selects (REDS %238). The shape above reads a
# Rishi choir that LISTS its members in a `let ... = [ ... ]` literal. A choir may instead
# DISCOVER them -- `git ls-files <pattern>` into a loop that hands each result to `rishi run` --
# which is the same discipline tools/r/room_bound_witness.rish already keeps for rooms, and it
# is strictly better: a witness born tomorrow is sung on the lap it lands rather than on the lap
# somebody remembers to edit a list. Invisible to the literal reading, such a choir sang 33
# witnesses while this meter reported every one of them unreached.
#
# THE CHOIR IS ASKED RATHER THAN INFERRED, and that distinction is the whole of it. Inferring
# reach from the choir's glob was tried first and overstated by 111: the season choir's pattern
# selects 144 equinox witnesses and it sings the 33 that chain nobody, so a meter reading the
# glob would have called 111 refusing-or-unrun witnesses reached. A number that says more than
# it measured is worse than a number that admits a blind spot.
#
# So a discovering choir DECLARES an enumerator, on one line, and this meter runs it:
#
#   # reach-list: sh tools/fixtures/season_leaf_choir_scan.sh --list
#
# The command prints one witness path per line and runs none of them. It is opt-in, bounded, and
# exact -- a choir that changes what it sings changes what it reports in the same edit, because
# the enumerator and the sing read one list. A source declaring nothing is read exactly as before.
: > "$pen/e_discover"
grep -l '^# reach-list: ' $(cat "$pen/sources") 2>/dev/null | sort -u > "$pen/declared" || true
while IFS= read -r c; do
  [ -n "$c" ] || continue
  cmd=$(sed -n 's/^# reach-list: //p' "$c" | head -1)
  [ -n "$cmd" ] || continue
  sh -c "$cmd" 2>/dev/null | grep -E '_witness\.rish$' | sort -u | sed "s|^|$c\t|" >> "$pen/e_discover"
done < "$pen/declared"
sort -u -o "$pen/e_discover" "$pen/e_discover"
echo "declared_enumerators=$(wc -l < "$pen/declared" | tr -d ' ')"

# The roster's own rows are the runner's calls, read from the roster rather than spelled here --
# and each row's TIER decides which reading it feeds. A record naming no tier means `lap`, which is
# what every row meant before the field existed.
: > "$pen/e_roster"; : > "$pen/roots_lap"; : > "$pen/roots_cadence"
if [ -f "$roster" ]; then
  awk '
    function flush() {
      if (n != "" && p != "") print p "\t" (t == "" ? "lap" : t)
      n = ""; p = ""; t = ""
    }
    $1 == "guard" { flush(); n = $2; next }
    $1 == "path"  { if (n != "") p = $2; next }
    $1 == "tier"  { if (n != "") t = $2; next }
    END { flush() }
  ' "$roster" > "$pen/roster_rows"
  awk -F'\t' -v r="$roster" '{ print r "\t" $1 }' "$pen/roster_rows" > "$pen/e_roster"
  awk -F'\t' '$2 == "lap"     { print $1 }' "$pen/roster_rows" | sort -u > "$pen/roots_lap"
  awk -F'\t' '$2 == "cadence" { print $1 }' "$pen/roster_rows" | sort -u > "$pen/roots_cadence"
fi

cat "$pen/e_call" "$pen/e_choir" "$pen/e_discover" "$pen/e_roster" | sort -u > "$pen/edges"

cut -f2 "$pen/edges" | sort -u > "$pen/invoked"
comm -12 "$pen/all" "$pen/invoked" > "$pen/sung"
comm -23 "$pen/all" "$pen/invoked" > "$pen/unheard"

# Reachability, from whichever roots a reading starts at. One walk, called twice, so the two
# readings can never drift apart by being written twice.
closure() {  # closure <roots-file> <out-file>
  sort -u "$1" > "$pen/f"
  cp "$pen/f" "$pen/s"
  while [ -s "$pen/f" ]; do
    awk -F'\t' 'NR == FNR { f[$1] = 1; next } ($1 in f) { print $2 }' "$pen/f" "$pen/edges" \
      | sort -u > "$pen/n"
    comm -23 "$pen/n" "$pen/s" > "$pen/f"
    cat "$pen/f" >> "$pen/s"
    sort -u "$pen/s" -o "$pen/s"
  done
  cp "$pen/s" "$2"
}

# Standing: what the every-lap tier and the hooks reach, which is what actually runs each lap.
{ cat "$pen/roots_lap"; git ls-files 'tools/hooks/*'; } | sort -u > "$pen/frontier_lap"
closure "$pen/frontier_lap" "$pen/seen_lap"
comm -12 "$pen/all" "$pen/seen_lap" > "$pen/standing"

# Cadence: what the slower tier reaches and the every-lap tier does not already carry.
closure "$pen/roots_cadence" "$pen/seen_cadence"
comm -12 "$pen/all" "$pen/seen_cadence" > "$pen/cadence_all"
comm -23 "$pen/cadence_all" "$pen/standing" > "$pen/cadence"

# The roster's whole reach, on both its clocks. What falls outside it is what no clock carries, and
# that set is the one the ceiling holds (REDS %224). The two closures above already did the walking;
# these three lines only read their answers, so the third band costs no second traversal.
cat "$pen/standing" "$pen/cadence" | sort -u > "$pen/reached"
comm -23 "$pen/all" "$pen/reached" > "$pen/unreached"
comm -12 "$pen/sung" "$pen/unreached" > "$pen/unclocked"

total=$(wc -l < "$pen/all" | tr -d ' ')
standing=$(wc -l < "$pen/standing" | tr -d ' ')
cadence=$(wc -l < "$pen/cadence" | tr -d ' ')
reached=$(wc -l < "$pen/reached" | tr -d ' ')
sung=$(wc -l < "$pen/sung" | tr -d ' ')
unclocked=$(wc -l < "$pen/unclocked" | tr -d ' ')
unheard=$(wc -l < "$pen/unheard" | tr -d ' ')
unreached=$(wc -l < "$pen/unreached" | tr -d ' ')

# A family census, grouped by the first word of a basename. It reads the GATED set by default,
# because a family count and a ceiling that disagree about which set they cover is how a lap comes
# to believe a family is closer to done than it is.
#
# THE DENOMINATOR, AND WHY IT ARRIVED LATE (20260828). This census printed twenty absolute counts
# and nothing else, so `86 hunk` and `12 tally` read as one large family and one small one. They
# are not: all 86 of hunk's witnesses are unreached and 12 of tally's 18 are, and a count without
# its total cannot say so. Worse, `head -20` dropped 224 of the 244 families holding an unreached
# witness without a word -- `comlink` at 4 of 5 and `mantra` at 6 of 7 never printed at all, so the
# module a reader came to check was the module the census hid. A meter that silently truncates
# reports a passing tail it never looked at, which is REDS %301's lesson one layer up: a room that
# never ARRIVES at a meter has not passed it either.
#
# So a family line now carries `unreached/total` and the share, the list is printed whole, and the
# summary line names how many families there are and how many are WHOLLY unreached.
family_names() { sed -E 's|^tools/[^/]+/||; s|^.*/||' "$1" | cut -d_ -f1; }

# families <set-file> -- one line per family: share, unreached/total, name, ranked by share then size.
families() {
  family_names "$pen/all" | sort | uniq -c | awk '{ print $2 "\t" $1 }' | sort > "$pen/fam_tot"
  family_names "$1"       | sort | uniq -c | awk '{ print $2 "\t" $1 }' | sort > "$pen/fam_sel"
  join -t"$(printf '\t')" "$pen/fam_tot" "$pen/fam_sel" \
    | awk -F'\t' '{ printf "%6.1f%%  %4d/%-4d  %s\n", 100*$3/$2, $3, $2, $1 }' \
    | sort -rn -k1
}

# wholly_unreached -- families in which EVERY witness is unreached, so the whole system has no clock.
# This is the reading `unreached` alone cannot give. Rostering one member of an 86-witness family
# lowers `unreached` by one and this by one; deleting a family's only REACHED member lowers `total`,
# leaves `unreached` exactly where it stood, and unguards the whole family -- which is the case the
# single total is blind to, and the case this number exists to catch.
wholly_unreached_count() {
  family_names "$pen/all"       | sort | uniq -c | awk '{ print $2 "\t" $1 }' | sort > "$pen/fam_tot"
  family_names "$pen/unreached" | sort | uniq -c | awk '{ print $2 "\t" $1 }' | sort > "$pen/fam_unr"
  join -t"$(printf '\t')" "$pen/fam_tot" "$pen/fam_unr" | awk -F'\t' '$2 == $3' | wc -l | tr -d ' '
}

families_total=$(family_names "$pen/all" | sort -u | wc -l | tr -d ' ')
wholly_unreached=$(wholly_unreached_count)

# OUTSIDE THE CONVENTION. Two tests, both cheap and both deliberately strict, because a false
# positive here accuses a working file of being a hidden guard. A file must (1) name itself a
# witness on its own FIRST line -- its self-description, not a citation of some other witness
# further down, which is what a five-line window wrongly admitted while this was being written --
# and (2) carry an `assert` in command position. A reporting tool that merely mentions a witness
# fails the first test; a demo that runs a binary and checks nothing fails the second.
git ls-files '*.rish' | grep -v '_witness\.rish$' | sort -u > "$pen/nonsuffix"
: > "$pen/outside"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  head -1 "$f" | grep -qiE '(^|[^a-z])witness([^a-z]|$)' || continue
  grep -qE '^[[:space:]]*assert ' "$f" || continue
  echo "$f" >> "$pen/outside"
done < "$pen/nonsuffix"
sort -u -o "$pen/outside" "$pen/outside"

# Dark means no OTHER tracked runner names it in command position. The edge list is the one every
# reading above is built from, so this answer is the meter's own, rather than a second opinion from
# a grep -- a grep for the basename finds the file's own usage comment and calls it reached.
awk -F'\t' '$1 != $2 { print $2 }' "$pen/e_call" | sort -u > "$pen/called"
comm -23 "$pen/outside" "$pen/called" > "$pen/outside_dark"
outside_convention=$(wc -l < "$pen/outside" | tr -d ' ')
outside_dark=$(wc -l < "$pen/outside_dark" | tr -d ' ')

case "$mode" in
  --list)      sed 's/^/unheard /'   "$pen/unheard" ;;
  --unclocked) sed 's/^/unclocked /' "$pen/unclocked" ;;
  --unreached) sed 's/^/unreached /' "$pen/unreached" ;;
  --sung)      sed 's/^/sung /'      "$pen/sung" ;;
  --standing)  sed 's/^/standing /'  "$pen/standing" ;;
  --cadence)   sed 's/^/cadence /'   "$pen/cadence" ;;
  --families)         families "$pen/unreached" ;;
  --families-unheard) families "$pen/unheard" ;;
  --families-whole)   families "$pen/unreached" | awk '$1 == "100.0%"' ;;
  --outside)          sed 's/^/outside /' "$pen/outside" ;;
  --outside-dark)     sed 's/^/outside_dark /' "$pen/outside_dark" ;;
esac

if [ "$unreached" -le "$CEILING" ]; then under=yes; else under=no; fi
if [ "$wholly_unreached" -le "$FAMILY_CEILING" ]; then funder=yes; else funder=no; fi
echo "WITNESS_REACH total=$total standing=$standing cadence=$cadence reached=$reached sung=$sung unclocked=$unclocked unheard=$unheard unreached=$unreached ceiling=$CEILING under_ceiling=$under families=$families_total wholly_unreached=$wholly_unreached family_ceiling=$FAMILY_CEILING under_family_ceiling=$funder outside_convention=$outside_convention outside_dark=$outside_dark"
