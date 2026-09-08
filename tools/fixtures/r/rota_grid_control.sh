#!/bin/sh
# rota_grid_control.sh -- the rota-grid guard proven on a grid built for the purpose, in a pen.
#
# Each gated reading is shown from BOTH sides: planted so it reds, then lifted so it returns to
# green, because a refusal proven only in the passing direction cannot be told from a bypass.
#
# EVERY PLANT PROVES IT LANDED (REDS %519). A plant is a claim about a file, and a `sed` whose
# pattern no longer matches rewrites nothing while the phase that follows reads exactly like a law
# that holds. So each mutation is compared against the file it replaced and answers the literal word
# `plant_matched_nothing` -- a word rather than a number, so it can never be mistaken for a count.
#
#   sh tools/fixtures/r/rota_grid_control.sh
#
# Prints `pass=N fail=N`. Bounded: 14 cases, one pen under TMPDIR, no network, no git.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/r/rota_grid_scan.sh"
[ -f "$scan" ] || { echo "refused: no scan at $scan" >&2; exit 2; }

# `sed -i` is GNU-only and the two dialects disagree about what follows the flag, so the tree writes
# neither spelling and reaches for its own cure instead (`shell_dialect_scan.sh`, REDS %282's family).
. "$root/tools/fixtures/s/shell_portable.sh"

pen=${TMPDIR:-/tmp}/rota-grid-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/recursion-prompts/seed" "$pen/foundations" "$pen/context"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

# A mutation that changes nothing is a plant that never fired.
plant() { # plant <file> <sed-expression> <name>
  cp "$1" "$pen/.before" || return 1
  sed_inplace "$2" "$1"
  if cmp -s "$pen/.before" "$1"; then
    printf 'plant_matched_nothing: %s on %s\n' "$3" "$1" >&2
    fail=$((fail+1))
    return 1
  fi
  return 0
}
unplant() { cp "$pen/.before" "$1"; }

seed="$pen/recursion-prompts/seed/loop.md"
elements="Aether Air Fire Water Earth"
planets="Jupiter Saturn Mars Venus Mercury"

# Five threshold pages and fifteen seats, each a real file, each named the way the tree names them.
i=0
for e in $elements; do
  i=$((i + 1))
  low=$(printf '%s' "$e" | tr 'A-Z' 'a-z')
  thr="$pen/foundations/2026010$i-000000_${low}-threshold.md"
  {
    printf '# %s -- the threshold\n\n' "$e"
    printf '**Kin:** [`20260101-000000_the-panchanga.md`](20260101-000000_the-panchanga.md) -- `kyri/receipt.rye` -- [`2026010%s-000001_%s-cardinal.md`](2026010%s-000001_%s-cardinal.md) -- [`2026010%s-000002_%s-fixed.md`](2026010%s-000002_%s-fixed.md) -- [`2026010%s-000003_%s-dual.md`](2026010%s-000003_%s-dual.md)\n\n' \
      "$i" "$low" "$i" "$low" "$i" "$low" "$i" "$low" "$i" "$low" "$i" "$low"
    for m in Cardinal Fixed Dual; do
      printf '## %s: the %s seat\n\n' "$m" "$m"
      printf 'This seat reads `foundations/2026010%s-00000%s_%s-%s.md`, which seats the row.\n\n' \
        "$i" "$(case $m in Cardinal) echo 1;; Fixed) echo 2;; *) echo 3;; esac)" "$low" "$(printf '%s' "$m" | tr 'A-Z' 'a-z')"
    done
  } > "$thr"
  for m in Cardinal Fixed Dual; do
    n=$(case $m in Cardinal) echo 1;; Fixed) echo 2;; *) echo 3;; esac)
    ml=$(printf '%s' "$m" | tr 'A-Z' 'a-z')
    printf '# %s %s seat\n' "$e" "$m" > "$pen/foundations/2026010$i-00000${n}_${low}-${ml}.md"
  done
done

write_grid() { # write_grid <how-many-rows>
  want=$1
  {
    printf '# pen seed\n\n'
    printf '| | **Cardinal** | **Fixed** | **Dual** |\n'
    printf '|---|---|---|---|\n'
    j=0
    for e in $elements; do
      j=$((j + 1))
      [ "$j" -le "$want" ] || break
      low=$(printf '%s' "$e" | tr 'A-Z' 'a-z')
      p=$(printf '%s' "$planets" | cut -d' ' -f"$j")
      printf '| **%s - %s** *a row* -- threshold [`foundations/2026010%s-000000_%s-threshold.md`](../../foundations/2026010%s-000000_%s-threshold.md) | `foundations/2026010%s-000001_%s-cardinal.md` | `foundations/2026010%s-000002_%s-fixed.md` | `foundations/2026010%s-000003_%s-dual.md` |\n' \
        "$e" "$p" "$j" "$low" "$j" "$low" "$j" "$low" "$j" "$low" "$j" "$low"
    done
  } > "$seed"
}
write_grid 5

ask() { ROTA_GRID_ROOT="$pen" ROTA_GRID_SEED="recursion-prompts/seed/loop.md" sh "$scan" "${1:-count}" 2>&1; }

out=$(ask)
check "a whole grid parses five rows"      yes "$(has "$out" 'rows=5')"
check "and fifteen cells"                  yes "$(has "$out" 'cells=15')"
check "a whole grid reads ok"              yes "$(has "$out" 'verdict=ok')"
check "with nothing unresolved"            yes "$(has "$out" 'unresolved=0')"
check "no section missing"                 yes "$(has "$out" 'sections_missing=0')"
check "and no seat undeclared"             yes "$(has "$out" 'seat_undeclared=0')"
check "every Kin line names its seats"     yes "$(has "$out" 'kin_seat_absent=0')"
check "and names nothing beside them"      yes "$(has "$out" 'kin_extra=0')"

# A seat the grid names and disk does not hold.
gone="$pen/foundations/20260103-000002_fire-fixed.md"
cp "$gone" "$pen/.gone"; rm -f "$gone"
out=$(ask)
check "a missing seat reds"                yes "$(has "$out" 'unresolved=1')"
check "and the verdict turns"              yes "$(has "$out" 'verdict=drift')"
out=$(ask list)
check "and the missing seat is named"      yes "$(has "$out" '20260103-000002_fire-fixed.md')"
cp "$pen/.gone" "$gone"
out=$(ask)
check "restoring it returns to green"      yes "$(has "$out" 'verdict=ok')"

# A threshold whose Cardinal section names a seat the grid retired -- the fault that opened this row.
thr="$pen/foundations/20260105-000000_earth-threshold.md"
if plant "$thr" 's|20260105-000001_earth-cardinal\.md|20260105-000009_earth-retired.md|' "the retired seat"; then
  out=$(ask)
  check "a retired seat reds"              yes "$(has "$out" 'seat_undeclared=1')"
  out=$(ask list)
  check "and the drifted door is named"    yes "$(has "$out" 'Earth Cardinal names no path')"
  unplant "$thr"
  out=$(ask)
  check "repointing it returns to green"   yes "$(has "$out" 'verdict=ok')"
fi

# A threshold missing one of its three modality headings.
if plant "$thr" 's|^## Dual: |## A room of its own: |' "the dropped heading"; then
  out=$(ask)
  check "a dropped heading reds"           yes "$(has "$out" 'sections_missing=1')"
  unplant "$thr"
fi

# A grid whose shape moved refuses rather than measuring the parser (REDS %170).
write_grid 4
if ask >/dev/null 2>&1; then
  check "a four-row grid refuses"          refused accepted
else
  check "a four-row grid refuses"          refused refused
fi
write_grid 5

# An absent seed refuses rather than reporting three zeros.
if ROTA_GRID_ROOT="$pen" ROTA_GRID_SEED="recursion-prompts/seed/absent.md" sh "$scan" >/dev/null 2>&1; then
  check "an absent seed refuses"           refused accepted
else
  check "an absent seed refuses"           refused refused
fi

# THE FOURTH SITE, the one that drifted twice unseen: a threshold's `**Kin:**` line.
# A Kin line that stops naming a live seat -- exactly Water's `20260908` drift, where the grid, the
# heading and the section path were all correct and only this line pointed at the released page.
thr="$pen/foundations/20260104-000000_water-threshold.md"
if plant "$thr" '/^\*\*Kin:\*\*/s|20260104-000001_water-cardinal\.md|20260104-000009_water-retired.md|g' "the released seat on the Kin line"; then
  out=$(ask)
  check "a Kin line dropping a seat reds"  yes "$(has "$out" 'kin_seat_absent=1')"
  check "and drift is the verdict"         yes "$(has "$out" 'verdict=drift')"
  check "the section itself stays clean"   yes "$(has "$out" 'seat_undeclared=0')"
  unplant "$thr"
fi
out=$(ask)
check "lifting it returns to green"        yes "$(has "$out" 'verdict=ok')"

# A Kin line that gains a page the grid does not seat is REPORTED and never gated, because a retired
# seat and a deliberate new kin link are the same shape from here and only a reader tells them apart.
if plant "$thr" 's|^\(\*\*Kin:\*\*.*\)$|\1 -- [`20260101-000000_a-friendly-page.md`](20260101-000000_a-friendly-page.md)|' "an extra kin page"; then
  out=$(ask)
  check "an extra Kin page is reported"    yes "$(has "$out" 'kin_extra=1')"
  check "and it does not red"              yes "$(has "$out" 'verdict=ok')"
  unplant "$thr"
fi

# A threshold carrying no Kin line at all names none of its three seats, and says so as three.
if plant "$thr" 's|^\*\*Kin:\*\*.*$||' "the whole Kin line"; then
  out=$(ask)
  check "no Kin line reds for all three"   yes "$(has "$out" 'kin_seat_absent=3')"
  unplant "$thr"
fi

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
