#!/bin/sh
# tools/fixtures/reds_ledger_headline_control.sh -- the headline writer, proven from both sides.
#
# A writer proven only in the writing direction cannot be told from a tool that rewrites whatever
# it is handed. So this plants ledgers in a throwaway pen and proves seven behaviors: three
# repairs it must make, two refusals it must bite, and two properties it must leave alone.
#
#   repairs   a drifted headline is repaired to the measured spine
#             the spine spans the fold shelves and the living pin together
#             a correct headline is left byte-identical, so the tool is idempotent
#   refusals  check mode reports the drift and writes nothing
#             a ledger carrying no headline is refused by name, and left alone
#   leaves    the rows are byte-identical after a repair
#             the file mode the repository tracks survives the rewrite
#
# EXPECTED: repaired=yes, spans_shelves=yes, idempotent=yes, check_writes_nothing=yes,
#           no_headline_refused=yes, rows_untouched=yes, mode_survives=yes.
#
# Driven by tools/r/reds_ledger_headline_witness.rish. Run from the repository root.
set -eu

root="$(pwd)"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

# A ledger in the shape the real one carries: a headline reciting three numbers, then prose rows.
# The planted rows run past the opening census of 20 on purpose, so the derived remainder stays a
# natural number and the control exercises the arithmetic the real ledger actually carries.
plant_ledger() {
  out=$1; total=$2; remainder=$3; span=$4; first=$5; last=$6
  {
    echo "# REDS -- a planted ledger"
    echo
    echo "**Rows: $total - in the tree before the ledger: 6 - recovered by opening it: 14 - added under the reds-first law: $remainder** -- counted from the ledger and its archives on \`20260101.000000\` by a witness. Every number from 1 to $span is used."
    echo
    n=$first
    while [ "$n" -le "$last" ]; do
      echo "**REDS %$n (\`20260825.000000\`) -- a planted row $n.** *What went wrong:* a thing. *What caught it:* a guard. *What it taught:* a rule. CLOSED."
      n=$((n + 1))
    done
  } > "$out"
}

rows_of() { grep -c '^\*\*REDS %' "$1"; }
body_of() { grep -v '^\*\*Rows: ' "$1"; }

W="$pen/w.sh"
cp "$root/tools/fixtures/reds_ledger_headline_write.sh" "$W"

run_writer() {
  ledger=$1; mode=$2
  ( cd "$root" && LEDGER="$ledger" ARCHIVE_GLOB="$pen/shelf-*.md" sh "$W" "$mode" )
}

# 1 -- a drifted headline is repaired to the measured spine.
plant_ledger "$pen/a.md" 22 2 22 1 23
out=$(run_writer "$pen/a.md" write) || true
if echo "$out" | grep -q '^changed=yes' \
   && grep -q '^\*\*Rows: 23 ' "$pen/a.md" \
   && grep -q 'reds-first law: 3\*\*' "$pen/a.md" \
   && grep -q 'from 1 to 23 is used' "$pen/a.md"; then
  echo "OK  repaired            drifted 22/2/22 rewritten to the measured 23"
  repaired=yes
else
  echo "RED repaired            the writer left the headline where it stood"
  repaired=no
fi

# 2 -- the spine spans the fold shelves and the living pin together, rather than the pin alone.
plant_ledger "$pen/shelf-1.md" 9 9 9 1 12
plant_ledger "$pen/b.md" 9 9 9 13 24
out=$(run_writer "$pen/b.md" write) || true
if grep -q '^\*\*Rows: 24 ' "$pen/b.md" && grep -q 'reds-first law: 4\*\*' "$pen/b.md"; then
  echo "OK  spans_shelves       twelve rows on a shelf and twelve in the pin measure 24"
  spans_shelves=yes
else
  echo "RED spans_shelves       the writer counted the living pin alone"
  spans_shelves=no
fi
rm -f "$pen/shelf-1.md"

# 3 -- a correct headline is left byte-identical. A tool that rewrites a page it need not touch
#      makes every commit noisy and teaches the bench to route around it.
before=$(cksum < "$pen/a.md")
out=$(run_writer "$pen/a.md" write) || true
after=$(cksum < "$pen/a.md")
if [ "$before" = "$after" ] && echo "$out" | grep -q '^changed=no'; then
  echo "OK  idempotent          a correct headline is left byte-identical"
  idempotent=yes
else
  echo "RED idempotent          the writer rewrote a page that already agreed"
  idempotent=no
fi

# 4 -- check mode reports the drift and writes nothing. This is the refusal direction: without it,
#      a green reading proves only that the tool ran.
plant_ledger "$pen/c.md" 1 1 1 1 23
before=$(cksum < "$pen/c.md")
if run_writer "$pen/c.md" check > "$pen/c.out" 2>&1; then status=0; else status=1; fi
after=$(cksum < "$pen/c.md")
if [ "$status" -eq 1 ] && [ "$before" = "$after" ] && grep -q 'verdict=headline_drift' "$pen/c.out"; then
  echo "OK  check_writes_nothing check mode refused and the file stands byte-identical"
  check_writes_nothing=yes
else
  echo "RED check_writes_nothing check mode wrote, or passed a drifted headline"
  check_writes_nothing=no
fi

# 5 -- a ledger carrying no headline is refused by name rather than grown one.
{ echo "# REDS -- no headline here"; echo; echo "**REDS %1 (\`20260825.000000\`) -- a row.** CLOSED."; } > "$pen/d.md"
before=$(cksum < "$pen/d.md")
if run_writer "$pen/d.md" write > "$pen/d.out" 2>&1; then status=0; else status=1; fi
after=$(cksum < "$pen/d.md")
if [ "$status" -eq 1 ] && [ "$before" = "$after" ] && grep -q 'verdict=no_headline' "$pen/d.out"; then
  echo "OK  no_headline_refused  a ledger with no headline is refused, and left alone"
  no_headline_refused=yes
else
  echo "RED no_headline_refused  the writer invented a headline or passed silently"
  no_headline_refused=no
fi

# 6 -- the rows are byte-identical after a repair. The ledger's first law is that rows are never
#      edited, so the tool that touches the page must be shown not to touch them.
plant_ledger "$pen/e.md" 7 7 7 1 25
body_of "$pen/e.md" > "$pen/e.body.before"
rows_before=$(rows_of "$pen/e.md")
run_writer "$pen/e.md" write > /dev/null 2>&1 || true
body_of "$pen/e.md" > "$pen/e.body.after"
rows_after=$(rows_of "$pen/e.md")
if cmp -s "$pen/e.body.before" "$pen/e.body.after" && [ "$rows_before" = "$rows_after" ]; then
  echo "OK  rows_untouched      every line but the headline stands byte-identical"
  rows_untouched=yes
else
  echo "RED rows_untouched      the rewrite reached past the headline"
  rows_untouched=no
fi

# 7 -- the file mode the repository tracks survives. A `mv` over the original cost this tree
#      thirty-nine exec bits in one commit (.claude/rules/exec-bit.md), so the shape is proven
#      rather than described.
plant_ledger "$pen/f.md" 1 1 1 1 21
chmod 755 "$pen/f.md"
run_writer "$pen/f.md" write > /dev/null 2>&1 || true
mode=$(ls -l "$pen/f.md" | cut -c1-10)
if [ "$mode" = "-rwxr-xr-x" ]; then
  echo "OK  mode_survives       the rewrite wrote through the original inode"
  mode_survives=yes
else
  echo "RED mode_survives       the mode changed across the rewrite -- read as $mode"
  mode_survives=no
fi


# 8 -- THE DATE MOVES WITH THE NUMBERS. A figure carries a unit, a date, and a source, and this
# writer refreshed two of the three: the living headline read 259 -> 263 while still claiming it
# was counted two hours and four rows earlier (REDS %264). The plant carries a stamp from the far
# past, so a stamp left alone is unmistakable.
plant_ledger "$pen/h.md" 22 2 22 1 23
out=$(run_writer "$pen/h.md" write) || true
planted_stamp_left=$(grep -c 'archives on `20260101.000000`' "$pen/h.md" || true)
fresh_stamp=$(sed -n 's/.*archives on `\([0-9]\{8\}\.[0-9]\{6\}\)`.*/\1/p' "$pen/h.md" | head -1)
today=$(TZ=America/New_York date +%Y%m%d)
if [ "$planted_stamp_left" -eq 0 ] && [ "${fresh_stamp%%.*}" = "$today" ]; then
  echo "OK  stamp_moves         the counted-on date left 20260101 and reads $fresh_stamp"
  stamp_moves=yes
else
  echo "RED stamp_moves         the headline still claims it was counted on '${fresh_stamp:-none}'"
  stamp_moves=no
fi

echo "repaired=$repaired"
echo "spans_shelves=$spans_shelves"
echo "idempotent=$idempotent"
echo "check_writes_nothing=$check_writes_nothing"
echo "no_headline_refused=$no_headline_refused"
echo "rows_untouched=$rows_untouched"
echo "mode_survives=$mode_survives"
echo "stamp_moves=$stamp_moves"
echo "behaviors=8"

for v in "$repaired" "$spans_shelves" "$idempotent" "$check_writes_nothing" \
         "$no_headline_refused" "$rows_untouched" "$mode_survives" "$stamp_moves"; do
  [ "$v" = yes ] || { echo "verdict=control_red"; exit 1; }
done
echo "verdict=ok"
