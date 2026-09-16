#!/bin/sh
# claim_preserve_scan.sh -- before/after claim-token and modality identity for a Radiant pass.
# Missing Rishi verb: accumulate - filter chained - read bounded -- harvest ledger (counsel 20260725.040247)
# Modality seated 20260725.110354 -- counsel the-runway; obligation drift stops the wave.
#
# Env:
#   CLAIM_PRESERVE_FILES -- newline-separated relative paths (required for a pass)
#   CLAIM_PRESERVE_BASE  -- git ref for BEFORE (default: HEAD)
#
# Also asserts pinned digests in known homes are unchanged vs BASE:
#   tools/w/waymark_derive.rish corpus_digest / corpus_count_pin
#   linengrow/seva_b0_fold.rye expected_demo_root_hex
#
# Exit 1 on any mismatch -- STOP the wave; do not resolve.
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"

BASE=${CLAIM_PRESERVE_BASE:-HEAD}
# The extractor now speaks Rishi (Python -> perl -> Rishi molt 20260809): its own
# match/find/sort/unique, no shell or perl. Before and after use the same extractor,
# so the claim comparison holds regardless of the ASCII/Unicode edge on rare non-ASCII.
#
# The PATH class needs the roster of this tree's rooms, and it is DERIVED here rather
# than spelled in the extractor. It used to be a hardcoded list of 17 names, which saw
# context/ and tools/ and was blind to src/, construction/, .claude/rules/, caravan/,
# comlink/, constel/ and 59 more -- 65 of 82 tracked rooms, measured 20260828. Longest
# first, so docs-geode/ wins the alternation over docs/; a leading dot is escaped so
# .claude/ is a room rather than a wildcard.
ROOTS=$(git ls-files | awk -F/ 'NF>1 {print $1}' | sort -u \
  | awk '{print length"\t"$0}' | sort -rn | cut -f2- | sed 's/\./\\./g' | paste -sd'|' -)
[ -n "$ROOTS" ] || { echo "FAIL room roster derived empty -- git ls-files answered nothing"; exit 1; }
# THE MODALITY READING CARRIES TWO POPULATIONS, and until 20260915 it named neither.
# Its eighteen terms are diffed as one bag, so a lap reading a refusal learns that
# something moved and never which kind of thing. Two kinds live in there:
#
#   OBLIGATION -- must, shall, should, may, require, recommend, propose, seat,
#   hold, parked. A pass that turns "may" into "must" has changed what the tree
#   owes, which is the drift this guard was seated for.
#
#   REGISTER -- never, none, always, every, all. These are the words the register
#   law asks a lap to RECAST. Lead with what is; prefer a restated positive over a
#   heavy negation. So a lawful register sweep moves them by doing as it is told.
#
# MEASURED ON THIS TREE'S OWN SWEEP. Commit f258e5f58 restated fourteen negatives
# in skate/README.md under that law and moved `may` 5 -> 4 and `all` 10 -> 12, the
# second purely from the restatement idiom "A, B and C all stay outside". The
# reading counts that exactly as it counts a weakened obligation.
#
# WHAT CHANGES HERE IS THE DIAGNOSIS, never the refusal: any drift still exits 1.
# Each drifted term now prints its class, and the two counts print beside the
# failure, so a sweep can show `obligation_drift=0` and a reviewer can read what
# the guard actually caught. Whether a register-only drift should ever pass is a
# door for Keaton rather than a loosening a lap may take for itself.
#
# THE REGISTER CLASS IS DERIVED, never spelled twice. Its negation half is read out
# of tools/fixtures/p/prose_register_scan.sh's own `neg` vocabulary, so the word a
# register sweep is asked to recast and the word this guard calls register are one
# list; a term added there is classified here on the next run. Its restatement half
# -- always, every, all -- is named below, since those are what a recast reaches FOR
# rather than what it reaches away from, and no meter counts them today.
NEG_RE=$(sed -n 's/^[[:space:]]*neg = "\(.*\)"$/\1/p' tools/fixtures/p/prose_register_scan.sh | head -1)
[ -n "$NEG_RE" ] || { echo "FAIL negation vocabulary unreadable in tools/fixtures/p/prose_register_scan.sh"; exit 1; }
RESTATE_WORDS=" always every all "

classify_term() {
  case "$RESTATE_WORDS" in
    *" $1 "*) echo register; return 0 ;;
  esac
  if printf ' %s ' "$1" | grep -qE "$NEG_RE"; then
    echo register
  else
    echo obligation
  fi
}

EXTRACT="rishi/bin/rishi run tools/fixtures/c/claim_preserve_extract.rish"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/claim-preserve.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

if [ -z "${CLAIM_PRESERVE_FILES:-}" ]; then
  echo "FAIL CLAIM_PRESERVE_FILES empty -- name every file the pass touches"
  exit 1
fi

printf '%s\n' "$CLAIM_PRESERVE_FILES" | sed '/^$/d' >"$TMP/files"
reds=0

# Drop Radiant-pass, Erratum, and Living-pointer lines so recorded Tier-2
# doors can open without pretending the new stamp or pointer was always there.
normalize_body() {
  # stdin -> stdout
  grep -viE 'Radiant pass|[Ee]rratum|[Ll]iving pointer' || true
}

while IFS= read -r path; do
  [ -n "$path" ] || continue
  if [ ! -f "$path" ]; then
    echo "FAIL missing working tree: ${path}"
    reds=$((reds + 1))
    continue
  fi
  if ! git cat-file -e "${BASE}:${path}" 2>/dev/null; then
    echo "FAIL ${path}: not in ${BASE} -- claim_preserve compares an existing file"
    reds=$((reds + 1))
    continue
  fi
  git show "${BASE}:${path}" >"$TMP/before_raw"
  normalize_body <"$TMP/before_raw" >"$TMP/before_body"
  normalize_body <"$path" >"$TMP/after_body"
  $EXTRACT "$TMP/before_body" "$ROOTS" | sort -u >"$TMP/before"
  $EXTRACT "$TMP/after_body" "$ROOTS" | sort -u >"$TMP/after"
  # THE TWO DIRECTIONS ARE ONE READING UNTIL THEY ARE COUNTED APART, and until 20260916
  # they were. A claim token standing in BEFORE and absent from AFTER is a claim the pass
  # DROPPED -- the loss this guard is named for, and the fault a reader pays for, since the
  # fact they depended on has left the page with nothing saying so. A token standing only in
  # AFTER is a claim the pass ADDED, which under a register pass is still a content change
  # worth seeing and is never a loss.
  #
  # MEASURED ON THIS TREE'S OWN SWEEP. Commit 6e001803b recast `settlement/README.md` under
  # the register law and this guard refused it with `claim_lost=0 claim_added=3` -- a Style
  # line's path and two proper nouns, `PATH:../context/GAUGE_STYLE.md`, `PROPER:Door` and
  # `PROPER:Gauge`. The elder reading printed `claim tokens drifted` and two headed lists,
  # so a reviewer had to read the lists to learn which direction had moved.
  #
  # WHAT CHANGES HERE IS THE DIAGNOSIS, never the refusal -- the same clause the modality
  # split above kept. Any drift in either direction still exits 1. Whether an addition-only
  # drift should pass is a door for Keaton rather than a loosening a lap may take.
  comm -23 "$TMP/before" "$TMP/after" >"$TMP/lost"
  comm -13 "$TMP/before" "$TMP/after" >"$TMP/added"
  # `awk END{print NR}` rather than `grep -c ""`: grep answers an empty file by EXITING 1,
  # which `set -e` reads as the instrument failing rather than as the count being zero, and
  # a clean page is exactly the case that produced it. Silencing grep with `|| true` would
  # swallow a real failure, which `tools/fixtures/i/instrument_refusal_scan.sh` gates.
  lost_n=$(awk 'END {print NR}' "$TMP/lost")
  added_n=$(awk 'END {print NR}' "$TMP/added")
  if [ "$lost_n" -gt 0 ] || [ "$added_n" -gt 0 ]; then
    echo "FAIL claim tokens drifted: ${path} claim_lost=${lost_n} claim_added=${added_n}"
    echo "--- only in BEFORE (${BASE}) -- claims the pass dropped ---"
    head -40 "$TMP/lost"
    echo "--- only in AFTER (worktree) -- claims the pass added ---"
    head -40 "$TMP/added"
    reds=$((reds + 1))
  else
    echo "OK   claim tokens identical: ${path} claim_lost=0 claim_added=0"
  fi
  # Modality -- per-file obligation counts must hold (recommend->require is red).
  # The counter now speaks Rishi (Python -> Rishi molt 20260809): compare its
  # before/after counts, each file normalized inside the counter.
  git show "${BASE}:${path}" >"$TMP/before_mod_raw"
  rishi/bin/rishi run tools/fixtures/c/claim_preserve_modality.rish count "$TMP/before_mod_raw" >"$TMP/mod_before" 2>/dev/null
  rishi/bin/rishi run tools/fixtures/c/claim_preserve_modality.rish count "$path" >"$TMP/mod_after" 2>/dev/null
  # The counter emits `term=count` in one fixed order, so the two readings pair by
  # line. The pairing asserts the term names agree, and that assert CANNOT FIRE
  # today -- both readings come from one counter in one run, so their order is the
  # same order by construction. It is kept as a bound on a future restructure: the
  # moment a BEFORE reading is cached, adopted, or produced by a peer copy, an
  # unasserted pairing would compare `may` against `never` and report a drift
  # nobody made. Named here rather than left to look like a proven refusal.
  paste "$TMP/mod_before" "$TMP/mod_after" >"$TMP/mod_pair"
  : >"$TMP/mod_drift"
  ob_drift=0
  reg_drift=0
  order_red=0
  while IFS="$(printf '\t')" read -r bpair apair; do
    [ -n "$bpair" ] || continue
    bterm=${bpair%%=*}
    aterm=${apair%%=*}
    if [ "$bterm" != "$aterm" ]; then
      echo "FAIL modality term order disagreed: ${bterm} vs ${aterm}"
      order_red=1
      break
    fi
    bcount=${bpair#*=}
    acount=${apair#*=}
    [ "$bcount" = "$acount" ] && continue
    cls=$(classify_term "$bterm")
    echo "  ${cls} ${bterm}: ${bcount} -> ${acount}" >>"$TMP/mod_drift"
    if [ "$cls" = obligation ]; then
      ob_drift=$((ob_drift + 1))
    else
      reg_drift=$((reg_drift + 1))
    fi
  done <"$TMP/mod_pair"
  if [ "$order_red" -eq 1 ]; then
    reds=$((reds + 1))
  elif [ "$ob_drift" -gt 0 ] || [ "$reg_drift" -gt 0 ]; then
    echo "FAIL modality drift: ${path} obligation_drift=${ob_drift} register_drift=${reg_drift}"
    cat "$TMP/mod_drift"
    reds=$((reds + 1))
  else
    echo "OK   modality held: ${path} obligation_drift=0 register_drift=0"
  fi
  # Wrong beliefs stay visible -- silent five->four rewrites are red.
  if grep -Fq 'five remotes' "$TMP/before_raw"; then
    if ! grep -Fq 'five remotes' "$path"; then
      echo "FAIL ${path}: removed historical 'five remotes' -- use an erratum line instead"
      reds=$((reds + 1))
    fi
  fi
done <"$TMP/files"

# Pinned digests must not move
pin_check() {
  file=$1
  pattern=$2
  label=$3
  if [ ! -f "$file" ]; then
    echo "FAIL pin home missing: ${file}"
    reds=$((reds + 1))
    return
  fi
  if ! git cat-file -e "${BASE}:${file}" 2>/dev/null; then
    echo "OK   pin home new at ${BASE}: ${file} (skip)"
    return
  fi
  before=$(git show "${BASE}:${file}" | grep -E "$pattern" | head -1 || true)
  after=$(grep -E "$pattern" "$file" | head -1 || true)
  if [ "$before" != "$after" ]; then
    echo "FAIL pinned digest moved (${label}): ${file}"
    echo "  before: ${before}"
    echo "  after:  ${after}"
    reds=$((reds + 1))
  else
    echo "OK   pinned digest held (${label}): ${file}"
  fi
}

pin_check "tools/w/waymark_derive.rish" 'corpus_digest[[:space:]]*=' "flw corpus"
pin_check "tools/w/waymark_derive.rish" 'corpus_count_pin[[:space:]]*=' "flw count"
pin_check "linengrow/seva_b0_fold.rye" 'expected_demo_root_hex[[:space:]]*=' "HAWM root"

if [ "$reds" -gt 0 ]; then
  echo "FAIL claim_preserve count=${reds}"
  exit 1
fi
echo "OK   claim_preserve clean -- tokens and modality identical; pins held"
exit 0
