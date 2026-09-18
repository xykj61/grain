#!/bin/sh
# tools/fixtures/g/glow_shape_capacity_scan.sh -- CAN GLOW WRITE THE PRODUCT'S OWN TYPES? Glow's
# multi-field `$:` shape holds at most `max_fields` faces, declared in glow/rune_shape.rye. That
# number was frozen at NINE on `20260720` by a seated capacity ruling
# (active-designing/date/20260720/20260720-231857_closed-field-capacity-freeze-and-framework-next.md),
# on a reason that was true when it was written: the ladder had walked pair, triple, quad, penta,
# hexa, hepta, octa, nona, and another face name taught no new nest law. Nothing asked for a tenth.
#
# Something asks now. The receipt contract Keaton accepted on `20260913`
# (active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md) declares four public
# types, and this seat's own ladder rung reads *express the receipt facts in the smallest Glow
# form already owned*. A form that holds nine faces cannot hold a type that names fifteen.
#
# So this scan reads BOTH SIDES FROM THEIR OWN FILES and reports the gap per type:
#
#   THE CAPACITY comes from glow/rune_shape.rye's `pub const max_fields`, and the admitted field
#   auras from the `admitted_shape_auras` table beside it. Both are read rather than spelled here,
#   because a reader carrying its own copy of a number answers about itself.
#
#   THE DEMAND comes from the contract page's own `## Public types` block. A line at column zero
#   inside that block names a type; the indented lines under it name its fields, comma-separated,
#   and a field written `name: Type` counts as the one field left of the colon.
#
# WHAT IT GATES, AND WHAT IT ONLY REPORTS. It gates that the INSTRUMENT ANSWERED -- both files
# read, a capacity found, and at least one type parsed -- because a scan that silently reads zero
# types prints a perfect `types_over_capacity=0` about a page it never opened. It REPORTS the gap
# and gates nothing about it: closing the gap means widening a ceiling the capacity freeze
# reserves for Keaton's word, and a gate that reds every ship for a decision no lap may take is a
# gate somebody turns off.
#
# WHAT IT DOES NOT READ. Whether each field's own aura is one Glow admits. The contract names
# field NAMES rather than types, so no reader can derive that from the page; it was read by hand
# on `20260916` and all fifteen of ReceiptOfferFact's fields map onto the four admitted auras,
# with `value_amount` needing `@u64` because the contract's ceiling of 9,000,000,000 stands above
# what `@u32` holds, and `product_digest` fitting `@ux` exactly at 32 bytes.
#
# Style: Gauge at Meter. Every figure is derived on each run.
set -u

GLOW_SHAPE="${SHAPE_CAPACITY_GLOW:-glow/rune_shape.rye}"
CONTRACT="${SHAPE_CAPACITY_CONTRACT:-active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md}"
MODE="${1:-}"

if [ ! -f "$GLOW_SHAPE" ]; then
  echo "glow_readable=no"
  echo "detail: $GLOW_SHAPE is absent -- the capacity half of this reading has no source"
  echo "verdict=unreadable"
  exit 0
fi
echo "glow=$GLOW_SHAPE"
echo "glow_readable=yes"

max_fields=$(sed -n 's/^pub const max_fields: u32 = \([0-9][0-9]*\);.*$/\1/p' "$GLOW_SHAPE" | head -1)
if [ -z "$max_fields" ]; then
  echo "capacity_found=no"
  echo "detail: $GLOW_SHAPE declares no pub const max_fields -- the ceiling moved or was renamed"
  echo "verdict=uncapacitated"
  exit 0
fi
echo "capacity_found=yes"
echo "shape_max_fields=$max_fields"

auras=$(sed -n 's/^pub const admitted_shape_auras = \[_\]\[\]const u8{\(.*\)};$/\1/p' "$GLOW_SHAPE" | head -1)
aura_count=$(printf '%s' "$auras" | tr ',' '\n' | grep -c '"')
echo "shape_admitted_auras=$aura_count"

if [ ! -f "$CONTRACT" ]; then
  echo "contract_readable=no"
  echo "detail: $CONTRACT is absent -- the demand half of this reading has no source"
  echo "verdict=uncontracted"
  exit 0
fi
echo "contract=$CONTRACT"
echo "contract_readable=yes"

# The `## Public types` block. A fenced block opens and closes with three backticks; the type
# names sit at column zero inside it and their fields are indented under them.
block=$(awk '
  /^## Public types/ { inseg = 1; next }
  inseg && /^```/    { fence = fence + 1; if (fence == 2) exit; next }
  inseg && fence == 1 { print }
' "$CONTRACT")

if [ -z "$block" ]; then
  echo "types_block_found=no"
  echo "detail: $CONTRACT carries no fenced block under a Public types heading"
  echo "verdict=unblocked"
  exit 0
fi
echo "types_block_found=yes"

# One record per type: `type <Name> <field_count>`. A field written `name: Type` counts as the
# one name left of the colon, so ReceiptState's two lines read as two fields rather than four.
types=$(printf '%s\n' "$block" | awk '
  function flush() { if (name != "") printf "type %s %d\n", name, n }
  /^[A-Za-z][A-Za-z0-9_]*[ \t]*$/ { flush(); name = $1; n = 0; next }
  /^[ \t]+[^ \t]/ {
    if (name == "") next
    line = $0
    # A line carrying a colon is ONE field, named left of the colon, and the text right of it is
    # that field type -- which may itself carry commas. Splitting first would count `map<a, b>`
    # as two. A line without a colon is a comma-separated list of field names.
    if (index(line, ":") > 0) {
      f = line
      sub(/:.*$/, "", f)
      gsub(/[ \t]/, "", f)
      if (f != "") n = n + 1
      next
    }
    cnt = split(line, parts, ",")
    for (i = 1; i <= cnt; i++) {
      f = parts[i]
      gsub(/[ \t]/, "", f)
      if (f != "") n = n + 1
    }
    next
  }
  END { flush() }
')

types_read=$(printf '%s\n' "$types" | grep -c '^type ' || true)
echo "types_read=$types_read"
if [ "$types_read" -eq 0 ]; then
  echo "detail: the Public types block parsed to no type at all -- the block's shape moved"
  echo "verdict=untyped"
  exit 0
fi

printf '%s\n' "$types" | grep '^type ' | while read -r _ name n; do
  if [ "$n" -gt "$max_fields" ]; then
    echo "type $name fields=$n expressible=no over=$((n - max_fields))"
  else
    echo "type $name fields=$n expressible=yes over=0"
  fi
done

over=$(printf '%s\n' "$types" | grep '^type ' | awk -v cap="$max_fields" '$3 > cap { c = c + 1 } END { print c + 0 }')
widest=$(printf '%s\n' "$types" | grep '^type ' | awk 'BEGIN{m=0} $3 > m { m = $3; nm = $2 } END { print m + 0 }')
widest_name=$(printf '%s\n' "$types" | grep '^type ' | awk 'BEGIN{m=0} $3 > m { m = $3; nm = $2 } END { print nm }')

echo "widest_type=$widest_name"
echo "widest_type_fields=$widest"
echo "types_over_capacity=$over"
gap=0
if [ "$widest" -gt "$max_fields" ]; then gap=$((widest - max_fields)); fi
echo "capacity_gap=$gap"

if [ "$MODE" = "--explain" ]; then
  echo "detail: the capacity is a seated freeze -- widening it is Keaton's word, so this reading"
  echo "detail: reports the gap and gates only that both sides were actually read"
fi

if [ "$over" -gt 0 ]; then
  echo "verdict=over_capacity"
else
  echo "verdict=within_capacity"
fi
