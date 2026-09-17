#!/bin/sh
# tools/fixtures/l/loom_values.sh -- the loom journal's value read, spelled once.
#
# WHY A SIBLING. `tools/l/loom_trend.sh` reads a `loom` key back across every tracked session log
# and answers min, max, mean and direction. This lap adds a second reader asking a different
# question of the SAME values, and two readers spelling one read is two readings that may quietly
# come to disagree -- the braid `foundations/20260823-204456_single-stranded.md` names. So the read
# moves here, both callers source this file, and the trend's own output is proven byte-identical
# before and after the move.
#
# SOURCE IT, DO NOT RUN IT. It defines two named projections of one read and does nothing else:
#
#   . "$root/tools/fixtures/l/loom_values.sh"
#   loom_values "seconds" "$work/values.txt"         # STAMP  VALUE  FILE
#   loom_family_values "seconds" "$work/fam.txt"     # STAMP  VALUE  SCOPE  KIND  FILE
#
# Both honor LOOM_FAMILY from the environment. `loom_values` output is unchanged by the second
# projection's arrival, which `tools/l/loom_trend_witness.rish` and this file's own control prove
# by comparing bytes; one awk carries the grammar so the two readings can never drift apart.
#
# THE SCOPE AND THE KIND, read off the line's own door. A loom line declares what population its
# numbers belong to in its FIRST token, and the journal writes that declaration two ways:
#
#   loom witness=mandate_store_witness wall_ms=42      pair form:  kind `witness`, scope `witness=mandate_store_witness`
#   loom molt files_working_tree=97 renames=6          bare form:  kind `molt`,    scope `molt`
#
# Measured over 6,574 tracked loom lines on `20260917`: 4,112 pair, 2,035 bare, and **427 naming no
# family at all**, whose first token is already a measurement. Those last get scope and kind `-`,
# because a line that declares no population has none to report, and inventing one from the second
# token would read a measurement as a label. Every figure here is FREE and moves with the journal.
#
# THE SHAPE IT READS is the one `.claude/rules/session-logs.md` names and the tree writes:
#
#   loom roster=standing_equipment_run guards=109 green=99 red=10 seconds=1562
#
# so `seconds`, `guards` and `roster` are each a key. Each match emits one tab-separated row of
# STAMP, VALUE, FILE. The stamp comes from the log's own basename rather than from its body, so no
# file is opened twice, and ordering is left to the caller because the two callers sort alike and a
# sort inside a producer is a decision the producer has no business making.
#
# ONE PASS, AND WHY THAT MATTERS HERE. The elder read ran a `grep`, a `tr`, a second `grep` and a
# `cut` per log, which is four processes across as many as 4,000 files. One `awk` does the same
# work in one process, and the listing mode that took over two minutes on this pier returns in
# seconds. The behavior is held identical by `tools/l/loom_trend_witness.rish`-adjacent proof in
# this lap's own control, which runs the elder pipeline and this function over one corpus and
# compares the bytes.
#
# ONE DIFFERENCE, NAMED RATHER THAN HIDDEN. The elder matched a key with `grep -E "^${KEY}="`, so a
# key carrying a regular-expression character was read as a PATTERN. This compares the key
# LITERALLY. Every key the journal holds is `[A-Za-z_][A-Za-z0-9_]*`, so no reading in this tree
# moves; the refinement is toward the safe direction, since a literal read cannot match a key
# nobody wrote.
#
# BOUNDS: at most LOOM_MAX_LOGS logs are read, default 4,000.
#
# No network, no key, no funds, no device. Reads tracked session logs and writes only the file it
# is handed.

# loom_values KEY OUTFILE -- write STAMP<tab>VALUE<tab>FILE rows for every occurrence of KEY.
loom_values() { loom_emit "${1-}" "${2-}" 0; }

# loom_family_values KEY OUTFILE -- the same rows carrying the line's declared population:
# STAMP<tab>VALUE<tab>SCOPE<tab>KIND<tab>FILE, with `-` for a line that declares none.
loom_family_values() { loom_emit "${1-}" "${2-}" 1; }

# loom_emit KEY OUTFILE WITHFAMILY -- the one read both projections above are cut from.
# Honors LOOM_FAMILY (a fixed string the whole loom line must contain) and LOOM_MAX_LOGS.
# Returns 2 when the corpus is empty, which is a red rather than a reading (REDS %170).
loom_emit() {
  lv_key="${1-}"
  lv_out="${2-}"
  lv_fam_out="${3-0}"
  [ -n "$lv_key" ] || { echo "loom read: refused -- name the key" >&2; return 2; }
  [ -n "$lv_out" ] || { echo "loom read: refused -- name the output file" >&2; return 2; }

  lv_max=${LOOM_MAX_LOGS:-4000}
  lv_logs="${lv_out}.logs"
  git ls-files 'session-logs/date/*/*.kyri' 2>/dev/null | head -"$lv_max" > "$lv_logs"

  # invariant: a corpus of zero is a red, never a reading -- every figure below would print clean.
  if [ ! -s "$lv_logs" ]; then
    echo "loom read: refused -- no tracked session logs, so every reading would be empty" >&2
    rm -f "$lv_logs"
    return 2
  fi

  awk -v key="$lv_key" -v fam="${LOOM_FAMILY:-}" -v logs="$lv_logs" -v withfam="$lv_fam_out" '
    # the line declares its population in token 2, in one of two forms, or declares none
    function scope_of(tok,   eq, v) {
      eq = index(tok, "=")
      if (eq == 0) return tok                       # bare form -- the word is the whole scope
      v = substr(tok, eq + 1)
      if (v == "") return "-"
      if (v + 0 == v) return "-"                    # a number in token 2 is a measurement, never a label
      return tok
    }
    function kind_of(scope,   eq) {
      if (scope == "-") return "-"
      eq = index(scope, "=")
      if (eq == 0) return scope
      return substr(scope, 1, eq - 1)
    }
    BEGIN {
      klen = length(key)
      while ((getline f < logs) > 0) {
        b = f; sub(/^.*\//, "", b); stamp = substr(b, 1, 15)
        while ((getline line < f) > 0) {
          if (substr(line, 1, 5) != "loom ") continue
          if (fam != "" && index(line, fam) == 0) continue
          n = split(line, a, / /)
          if (withfam) { sc = (n >= 2) ? scope_of(a[2]) : "-"; kd = kind_of(sc) }
          for (i = 1; i <= n; i++) {
            if (substr(a[i], 1, klen + 1) == key "=") {
              if (withfam)
                printf "%s\t%s\t%s\t%s\t%s\n", stamp, substr(a[i], klen + 2), sc, kd, f
              else
                printf "%s\t%s\t%s\n", stamp, substr(a[i], klen + 2), f
            }
          }
        }
        close(f)
      }
      close(logs)
    }
  ' > "$lv_out"

  rm -f "$lv_logs"
  return 0
}
