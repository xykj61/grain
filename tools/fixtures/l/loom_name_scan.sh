#!/bin/sh
# tools/fixtures/l/loom_name_scan.sh -- does this loom key's NAME say which population it measures?
#
#   sh tools/fixtures/l/loom_name_scan.sh <key>
#   sh tools/fixtures/l/loom_name_scan.sh <key> --explain      # one row per declared scope
#
# WHY THIS EXISTS. `tools/fixtures/l/loom_sitting_scan.sh` asks whether a key can prove a change,
# and it answers AFTER the fact: it takes each day shelf's own spread as a resolution floor and
# reads `spread_class=suspect_mixed` once the sitting medians range wider than their own median.
# That reading names a key as mixed and stops there. It cannot say WHERE the mixing came from, so
# it cannot say what would repair it -- and those are two different repairs. A key merging the work
# of several families is repaired by a NAME: write `roster_cold_s` and `roster_hot_s` and the two
# populations part at the door. A key mixing inside ONE family is repaired by nothing a rename
# reaches, because the workload itself varies.
#
# This reads the half the sitting scan leaves: how much of a key's population is DECLARED ON ITS
# OWN LINE, before any statistic is taken. It is the earth-row reading of the same corpus -- the
# fact off the face rather than the inference after.
#
# THE GROUND, AND IT IS THE LAP'S FIRST FINDING. A loom line declares its population in its first
# token, and the journal writes that declaration in two forms nobody's law named as two:
#
#   loom witness=mandate_store_witness wall_ms=42     pair form
#   loom molt files_working_tree=97 renames=6         bare form
#
# Measured `20260917` over 6,574 tracked loom lines: **4,112 pair, 2,035 bare, and 427 declaring no
# family at all**, their first token already a measurement. So the convention the sitting scan's
# `LOOM_FAMILY` disambiguator rests on holds on 93 percent of lines and on no line by rule. Every
# figure here is FREE and moves with the journal; `loom_values.sh` carries the parse.
#
# THE TWO READINGS, because a scope and a kind are two facts:
#
#   kinds    distinct leading KEYS -- `witness`, `roster`, `molt`. What `LOOM_FAMILY=<kind>` reaches.
#   scopes   distinct leading TOKENS -- `witness=mandate_store_witness`. The finest population the
#            line declares, which is what a rename would have to separate.
#
# THE VERDICT names which repair the key's name admits, and never whether one is owed:
#
#   name_scopes    one scope writes this key. Its name already says its population; nothing to split.
#   kind_scopes    one kind, several instances. `LOOM_FAMILY=<kind>` reaches the whole population,
#                  so a reader who knows to type it is served and a reader who does not is misled.
#   name_shared    several kinds write it. No single LOOM_FAMILY value reaches this key's values,
#                  and a reader reading it whole is reading several workloads as one.
#
# `scope_evidence` reads `unmeasured` when one declared occurrence stands behind the verdict, since
# a key written once has one scope by arithmetic rather than by naming. It matters: over the live
# journal the ONLY keys reading `name_scopes` are near-singletons, so a reader taking that word as
# a compliment would have it exactly backwards.
#
# `undeclared` counts occurrences on lines naming no family, which no LOOM_FAMILY value can reach
# at all. It is reported beside the verdict rather than folded into it, since a key that is
# otherwise single-scoped and carries ten undeclared occurrences is a different repair from one
# that is shared.
#
# WHAT THE VERDICT DOES NOT SAY. Whether this key SHOULD be split. `name_shared` on a deliberately
# cross-cutting key -- `wall_s`, which every family times with -- is the key working as intended and
# a reader needing to scope it. The verdict is a fact about the name, and the judgment is the
# pier's.
#
# IT GATES NOTHING. Which keys eight ships write, and under what family words, is this pier's habit
# rather than any lane's fault. `tools/l/loom_name_witness.rish` proves the instrument answers
# correctly over a planted corpus; it holds no ceiling over the journal.
#
# WHAT THIS DOES NOT READ. Whether two scopes measure the same work under two names, which is the
# mirror fault and wants its own run. Whether a value means what its writer thought. Non-numeric
# values, which are counted and otherwise skipped, since a population of witness names is a
# legitimate reading and a median of them is not.
#
# BOUNDS: LOOM_MAX_LOGS logs (default 4,000); LOOM_MAX_SCOPES scopes listed by --explain
# (default 200).
#
# No network, no key, no funds, no device. Reads tracked session logs and writes nothing outside a
# temporary directory it removes.

set -eu

# THE SIBLING IS SOURCED FROM THIS FILE'S OWN DIRECTORY, never from the corpus root, so a pen that
# sets LOOM_ROOT to a throwaway repository holding logs and no tools can still prove this.
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=${LOOM_ROOT:-$(CDPATH= cd -- "$here/../../.." && pwd)}
cd "$root"

. "$here/loom_values.sh"

KEY=${1:-}
MODE=${2:-summary}
[ -n "$KEY" ] || { echo "usage: loom_name_scan.sh <key> [--explain]" >&2; exit 2; }

MAX_SCOPES=${LOOM_MAX_SCOPES:-200}

work=$(mktemp -d "${TMPDIR:-/tmp}/loom-name.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

loom_family_values "$KEY" "$work/rows.txt" || exit 2

total=$(grep -c . "$work/rows.txt" 2>/dev/null || true)
[ -n "$total" ] || total=0
if [ "$total" -eq 0 ]; then
  echo "key=$KEY"
  echo "occurrences=0"
  echo "detail: no tracked session log writes this key -- read the spelling before the reading"
  echo "verdict=absent"
  exit 0
fi

awk -F'\t' -v key="$KEY" -v mode="$MODE" -v maxscopes="$MAX_SCOPES" '
  {
    n++
    scope = $3; kind = $4
    if (scope == "-") { undeclared++; next }
    if (!(scope in scope_n)) scope_order[++nscopes] = scope
    scope_n[scope]++
    scope_kind[scope] = kind
    if (!(kind in kind_n)) nkinds++
    kind_n[kind]++
    declared++
  }
  END {
    printf "key=%s\n", key
    printf "occurrences=%d\n", n
    printf "declared=%d undeclared=%d\n", declared + 0, undeclared + 0

    # invariant: a key every line leaves undeclared has no population to compare, which is a
    # reading in itself rather than a zero to print beside confident verdicts.
    if (declared + 0 == 0) {
      printf "kinds=0 scopes=0\n"
      printf "top_kind= top_kind_ppt=0\n"
      printf "scope_evidence=unmeasured\n"
      printf "verdict=undeclared_only\n"
      exit 0
    }

    # top kind share, in parts per thousand of the declared occurrences
    topk = ""; topn = -1
    for (k in kind_n) if (kind_n[k] > topn || (kind_n[k] == topn && k < topk)) { topn = kind_n[k]; topk = k }
    ppt = int((topn * 1000) / declared)

    printf "kinds=%d scopes=%d\n", nkinds, nscopes
    printf "top_kind=%s top_kind_ppt=%d\n", topk, ppt

    if (mode == "--explain") {
      shown = 0
      for (i = 1; i <= nscopes && shown < maxscopes; i++) {
        s = scope_order[i]
        printf "scope %s kind=%s occurrences=%d\n", s, scope_kind[s], scope_n[s]
        shown++
      }
      if (nscopes > shown) printf "scopes_unlisted=%d\n", nscopes - shown
    }

    if (nscopes == 1)      verdict = "name_scopes"
    else if (nkinds == 1)  verdict = "kind_scopes"
    else                   verdict = "name_shared"

    # invariant: a key written once has one scope by arithmetic rather than by naming, so the
    # single-occurrence reading is named UNMEASURED in its own FIELD, for the same reason the
    # sitting scan names its singleton sittings -- a confident word over a population of one is
    # the trap. A field rather than a prose line, because a reading nobody can count is a reading
    # no pass can hold, which is the rota-field lesson one room over.
    printf "scope_evidence=%s\n", (declared == 1 ? "unmeasured" : "measured")
    if (declared == 1)
      printf "detail: one occurrence, so `name_scopes` is arithmetic rather than evidence -- this key has never had the chance to be shared\n"
    printf "verdict=%s\n", verdict
  }
' "$work/rows.txt"
