#!/bin/sh
# checkable_binding_scan.sh -- a page claims the checkable room; what binds the claim?
#
# WHY. `context/TWO_ROOMS.md` seats exactly one crossing: "A claim crosses from the vision room to
# the checkable room by exactly one door -- it earns a witness." `tools/t/two_rooms_doorway.rish`
# reads whether a page NAMES a room and stops there, by design. So a page declaring the checkable
# room while naming no evidence at all reads, to every guard in this tree, exactly like a page bound
# by six witnesses. The doorway asks whether the door is labelled; this asks whether the label is
# earned.
#
# WHAT IT READS, over the doorway's OWN roster rather than a second spelling of it --
# `tools/fixtures/t/two_rooms_doorway_roster.sh`, so a room added there is read here. Each page whose
# `**Status:**` or `**Room:**` line names `checkable` is sorted on two axes:
#
#   LIFECYCLE, from the same line. `settled` on Living, Landed or Seated; `proposed` on Design,
#   Proposed, Draft or Horizon. The law itself makes this split matter -- "A design a witness will
#   bind next week is a proposed checkable claim" -- so a proposal naming no instrument is honest and
#   walks free, and only a SETTLED page owes evidence.
#
#   BINDING, from the body, in falling strength:
#     instrument  a `tools/` path or an instrument-suffixed name (_witness, _scan, _control, _probe,
#                 _census, _guard) -- the law's own word, a witness.
#     artifact    a tracked module source, `.rye` `.rish` `.glow` `.brix` `.kyri` -- the program the
#                 claim is about.
#     record      a tracked `construction/` pin -- `foundations/20260816-214652_standfast-the-stopped-line.md`
#                 binds itself this way on its own face, naming `construction/REDS.md` as what
#                 "records each stop it bought", and that is evidence rather than an instrument.
#     delegated   no evidence here, and a link to another page in the roster. See below.
#     none        the finding.
#
# EVERY NAMED PATH IS ASKED OF THE INDEX, NEVER THE DISK (`%457`, and the same reasoning
# `tools/fixtures/t/tracked_link_scan.sh` gives): a filesystem answers "is this here on this
# machine" and the repository answers "does a clone get this". Only the second is a promise.
#
# WHY `delegated` IS ITS OWN CLASS AND IS REPORTED RATHER THAN GATED. The widenings above were run
# one at a time and each dissolved part of a raw finding -- 61 settled pages naming nothing became
# 35 once module sources counted, and 17 once construction pins did. The class that survived is the
# one no widening could reach: `foundations/20260905-154954_the-clock-and-the-mark.md` declares the
# checkable room and says on its own face that both halves are "bound by a witness THE PAGES BELOW
# NAME". That is honest, and it is a promise one hop away that nothing follows. A delegation that
# lands is correct as written, so the gate would be wrong; what is worth seeing is a delegation
# whose hop is DRY -- every page it names being itself unbound.
#
# THE HOP IS FOLLOWED ONE STEP AND NO FURTHER, deliberately. Two steps needs a cycle guard and buys
# a weaker claim: a reader following evidence gives up after one hop, so the reading measures what a
# reader would actually find.
#
#   sh tools/fixtures/c/checkable_binding_scan.sh            # the counts
#   sh tools/fixtures/c/checkable_binding_scan.sh list       # settled_unbound pages, named
#   sh tools/fixtures/c/checkable_binding_scan.sh delegated  # settled_delegated, with its hop verdict
#
# BOUNDS. `MAX_PAGES` caps the roster read; `HEAD_LINES` caps the door read at the same 25 lines the
# doorway scan uses, so the two agree on where a door ends.
set -eu

ROOT=${CHECKABLE_BINDING_ROOT:-}
if [ -z "$ROOT" ]; then
  ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
fi
cd "$ROOT"

MAX_PAGES=${MAX_PAGES:-8192}
HEAD_LINES=25
CEILING=${CHECKABLE_BINDING_CEILING:-8}

MODE=${1:-count}

roster_cmd="tools/fixtures/t/two_rooms_doorway_roster.sh"
if [ ! -f "$roster_cmd" ]; then
  echo "detail=RED_roster_helper_absent path=$roster_cmd"
  echo "verdict=cannot_read"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

sh "$roster_cmd" 2>/dev/null | head -n "$MAX_PAGES" > "$tmp/roster.txt" || true
pages=$(wc -l < "$tmp/roster.txt" | tr -d ' ')

# A ROSTER ENTRY THE DISK LACKS SILENCES THE WHOLE READING, and the pen found it. `git ls-files`
# answers from the INDEX, so a file staged-and-deleted, or removed without the removal staged, is
# returned and absent. `awk ... $(cat roster)` handed one such path ABORTS -- not that file alone,
# the run -- so the door reading returned nothing for every page after it and the scan reported a
# clean zero. That is the `narrowed glob goes green` shape one room over: the failure that announces
# itself is safe, and this one does not. The present files are separated here and the absent ones
# are COUNTED and printed, so a silence has a number beside it.
: > "$tmp/present.txt"
absent=0
while IFS= read -r p; do
  if [ -f "$p" ]; then printf '%s\n' "$p" >> "$tmp/present.txt"; else absent=$((absent+1)); fi
done < "$tmp/roster.txt"
present=$(wc -l < "$tmp/present.txt" | tr -d ' ')
if [ "$pages" -eq 0 ]; then
  echo "detail=RED_roster_empty"
  echo "verdict=cannot_read"
  exit 0
fi

# The tracked index, read once. A path is a promise only if a clone receives it.
git ls-files > "$tmp/tracked.txt"

# Door reading and lifecycle, one awk over every page rather than one grep per page. A per-file
# process here costs minutes on a roster this size; copal measured the same shape at 6,624 ms
# against 186 ms over 500 paths.
awk -v head_lines="$HEAD_LINES" '
  FNR <= head_lines && /\*\*(Status|Room)[^:]*:\*\*/ {
    l = tolower($0)
    if (l ~ /(^|[^a-z])checkable([^a-z]|$)/) { ck[FILENAME] = 1 }
    if (l ~ /(^|[^a-z])(living|landed|seated)([^a-z]|$)/) { st[FILENAME] = 1 }
    if (l ~ /(^|[^a-z])(proposed|design|draft|horizon)([^a-z]|$)/) { pr[FILENAME] = 1 }
  }
  END {
    for (f in ck) {
      # A door naming both words is read as PROPOSED: the weaker claim is the honest one, and a
      # page saying "Living design" is telling a reader the witness has yet to arrive.
      if (pr[f]) { print f "\tproposed" }
      else if (st[f]) { print f "\tsettled" }
      else { print f "\tunstated" }
    }
  }
' $(cat "$tmp/present.txt") 2>/dev/null | sort > "$tmp/checkable.txt"

checkable=$(wc -l < "$tmp/checkable.txt" | tr -d ' ')

cut -f1 "$tmp/checkable.txt" > "$tmp/pagelist.txt"

# Binding classes, each one batched grep over the checkable set alone.
if [ -s "$tmp/pagelist.txt" ]; then
  grep -lE '(^|[^a-z0-9_])tools/[a-z]{1,3}/[a-z0-9_.-]+|[a-z0-9_]+_(witness|scan|control|probe|census|guard)([^a-z0-9_]|$)' \
    $(cat "$tmp/pagelist.txt") 2>/dev/null | sort -u > "$tmp/instrument.txt" || true
  grep -lE '[a-z0-9_-]+/[a-z0-9_/.-]+\.(rye|rish|glow|brix|kyri|brush)' \
    $(cat "$tmp/pagelist.txt") 2>/dev/null | sort -u > "$tmp/artifact.txt" || true
  grep -lE 'construction/[A-Za-z0-9_.-]+\.(md|kyri|kyri)' \
    $(cat "$tmp/pagelist.txt") 2>/dev/null | sort -u > "$tmp/record.txt" || true
else
  : > "$tmp/instrument.txt"; : > "$tmp/artifact.txt"; : > "$tmp/record.txt"
fi

# A class counts only where the path it named is one the repository carries.
keep_tracked() {
  _pat="$1"; _in="$2"; _out="$3"
  : > "$_out"
  [ -s "$_in" ] || return 0
  while IFS= read -r p; do
    [ -f "$p" ] || continue
    if grep -ohE "$_pat" "$p" 2>/dev/null \
       | sed 's/^[^a-zA-Z0-9]*//; s/[^a-zA-Z0-9_./-]*$//' \
       | sort -u \
       | grep -qxFf - "$tmp/tracked.txt" 2>/dev/null; then
      printf '%s\n' "$p" >> "$_out"
    fi
  done < "$_in"
}

keep_tracked 'tools/[a-z]{1,3}/[a-z0-9_.-]+\.(rish|sh|rye)' "$tmp/instrument.txt" "$tmp/instrument.tracked"
keep_tracked '[a-z0-9_-]+/[a-z0-9_/.-]+\.(rye|rish|glow|brix|kyri|brush)' "$tmp/artifact.txt" "$tmp/artifact.tracked"
keep_tracked 'construction/[A-Za-z0-9_.-]+\.(md|kyri|kyri)' "$tmp/record.txt" "$tmp/record.tracked"

# An instrument named by BARE NAME rather than by path still binds: the tree writes
# `nib_honesty_scan.sh` in prose constantly, and refusing that spelling would report a naming
# convention rather than a binding. Such a page joins the instrument class when the bare name
# resolves to a tracked file anywhere under tools/.
if [ -s "$tmp/instrument.txt" ]; then
  grep -E '^tools/' "$tmp/tracked.txt" | sed 's|.*/||' | sort -u > "$tmp/instrument_names.txt"
  while IFS= read -r p; do
    grep -qxF "$p" "$tmp/instrument.tracked" 2>/dev/null && continue
    [ -f "$p" ] || continue
    grep -ohE '[a-z0-9_]+_(witness|scan|control|probe|census|guard)(\.(rish|sh|rye))?' "$p" 2>/dev/null \
      | sort -u > "$tmp/cand_raw.txt" || true
    [ -s "$tmp/cand_raw.txt" ] || continue
    if awk 'NR==FNR { n[$0]=1; next }
            { if ($0 in n || ($0 ".rish") in n || ($0 ".sh") in n || ($0 ".rye") in n) { found=1; exit } }
            END { exit(found ? 0 : 1) }' \
           "$tmp/instrument_names.txt" "$tmp/cand_raw.txt"; then
      printf '%s\n' "$p" >> "$tmp/instrument.tracked"
    fi
  done < "$tmp/instrument.txt"
  sort -u "$tmp/instrument.tracked" -o "$tmp/instrument.tracked"
fi

for f in instrument artifact record; do
  [ -f "$tmp/$f.tracked" ] || : > "$tmp/$f.tracked"
  sort -u "$tmp/$f.tracked" -o "$tmp/$f.tracked"
done

sort -u "$tmp/instrument.tracked" "$tmp/artifact.tracked" "$tmp/record.tracked" > "$tmp/bound.txt"
comm -23 "$tmp/pagelist.txt" "$tmp/bound.txt" > "$tmp/nobinding.txt"

# Delegation: an unbound page linking another page the roster carries.
: > "$tmp/delegated.txt"; : > "$tmp/unbound.txt"; : > "$tmp/hop_dry.txt"
while IFS= read -r p; do
  [ -f "$p" ] || { printf '%s\n' "$p" >> "$tmp/unbound.txt"; continue; }
  dir=$(dirname "$p")
  grep -ohE '\]\([^)#]+\.(md|mdc)\)' "$p" 2>/dev/null | sed 's/^](//; s/)$//' | sort -u > "$tmp/links.txt" || true
  hop_found=no; hop_bound=no
  while IFS= read -r l; do
    [ -n "$l" ] || continue
    case "$l" in /*|http*) continue ;; esac
    tgt=$(cd "$dir" 2>/dev/null && cd "$(dirname "$l")" 2>/dev/null && printf '%s/%s' "$(pwd)" "$(basename "$l")" || true)
    [ -n "$tgt" ] || continue
    tgt=${tgt#"$ROOT"/}
    grep -qxF "$tgt" "$tmp/tracked.txt" 2>/dev/null || continue
    hop_found=yes
    if grep -qE '(^|[^a-z0-9_])tools/[a-z]{1,3}/[a-z0-9_.-]+\.(rish|sh|rye)|[a-z0-9_]+_(witness|scan|control|probe|census|guard)([^a-z0-9_]|$)' "$tgt" 2>/dev/null; then
      hop_bound=yes
      break
    fi
  done < "$tmp/links.txt"
  if [ "$hop_found" = yes ]; then
    printf '%s\t%s\n' "$p" "$hop_bound" >> "$tmp/delegated.txt"
    [ "$hop_bound" = no ] && printf '%s\n' "$p" >> "$tmp/hop_dry.txt"
  else
    printf '%s\n' "$p" >> "$tmp/unbound.txt"
  fi
done < "$tmp/nobinding.txt"

lifecycle_of() { grep -F "$(printf '%s\t' "$1")" "$tmp/checkable.txt" 2>/dev/null | head -1 | cut -f2; }

settled_unbound=0; proposed_unbound=0
: > "$tmp/settled_unbound.txt"
while IFS= read -r p; do
  [ -n "$p" ] || continue
  case "$(lifecycle_of "$p")" in
    settled) settled_unbound=$((settled_unbound+1)); printf '%s\n' "$p" >> "$tmp/settled_unbound.txt" ;;
    *) proposed_unbound=$((proposed_unbound+1)) ;;
  esac
done < "$tmp/unbound.txt"

settled_delegated=0; settled_hop_dry=0
: > "$tmp/settled_delegated.txt"
while IFS= read -r line; do
  [ -n "$line" ] || continue
  p=$(printf '%s' "$line" | cut -f1); hb=$(printf '%s' "$line" | cut -f2)
  [ "$(lifecycle_of "$p")" = settled ] || continue
  settled_delegated=$((settled_delegated+1))
  printf '%s\t%s\n' "$p" "$hb" >> "$tmp/settled_delegated.txt"
  [ "$hb" = no ] && settled_hop_dry=$((settled_hop_dry+1))
done < "$tmp/delegated.txt"

settled=$(cut -f2 "$tmp/checkable.txt" | grep -c '^settled$' || true)
proposed=$(cut -f2 "$tmp/checkable.txt" | grep -c '^proposed$' || true)
unstated=$(cut -f2 "$tmp/checkable.txt" | grep -c '^unstated$' || true)

case "$MODE" in
  list)
    while IFS= read -r p; do [ -n "$p" ] && echo "settled_unbound: $p"; done < "$tmp/settled_unbound.txt"
    ;;
  delegated)
    while IFS= read -r line; do
      [ -n "$line" ] || continue
      echo "settled_delegated: $(printf '%s' "$line" | cut -f1) hop_bound=$(printf '%s' "$line" | cut -f2)"
    done < "$tmp/settled_delegated.txt"
    ;;
esac

echo "roster_pages=$pages roster_present=$present roster_absent=$absent"
echo "checkable=$checkable settled=$settled proposed=$proposed unstated=$unstated"
echo "bound_instrument=$(wc -l < "$tmp/instrument.tracked" | tr -d ' ')"
echo "bound_artifact=$(wc -l < "$tmp/artifact.tracked" | tr -d ' ')"
echo "bound_record=$(wc -l < "$tmp/record.tracked" | tr -d ' ')"
echo "settled_unbound=$settled_unbound ceiling=$CEILING"
echo "proposed_unbound=$proposed_unbound"
echo "settled_delegated=$settled_delegated settled_hop_dry=$settled_hop_dry"
if [ "$settled_unbound" -le "$CEILING" ]; then
  echo "ceiling_ok=yes"
else
  echo "ceiling_ok=no"
fi
echo "verdict=read"
