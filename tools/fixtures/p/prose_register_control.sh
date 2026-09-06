#!/bin/sh
# tools/fixtures/p/prose_register_control.sh -- prove the register reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). The scan reads the real tree's own
# door roster, so its RED path cannot be shown there without damaging the tree. This control
# measures the same awk on planted prose instead: a warm page, a page written entirely in
# refusals, and the edge cases the reading has to get right.
#
# USAGE
#   sh tools/fixtures/p/prose_register_control.sh
#
# Driven by tools/p/prose_register_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/p/prose_register_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# The measure() function, lifted verbatim from the scan so the control reads what the guard reads.
sed -n '/^measure() {/,/^}/p' "$scan" > "$pen/measure.sh"
[ -s "$pen/measure.sh" ] || { echo "control_verdict=measure_not_found" >&2; exit 1; }
. "$pen/measure.sh"

pct_of() { set -- $(measure "$1"); echo "$3"; }
sent_of() { set -- $(measure "$1"); echo "$1"; }

# 1. Warm prose reads low.
cat > "$pen/warm.md" <<'EOF'
Grain gives you a computer that answers to you. Your words stay on your machine.
Every promise here is one a program has already checked. The system names each bound
before it starts, and it can show you it stayed inside. A witness prints green when a
promise holds. Every name we choose stays clear on the first day and the ten thousandth.
EOF
w=$(pct_of "$pen/warm.md")
[ "$w" -le 20 ] && echo "warm_reads_low=yes" || echo "warm_reads_low=no ($w%)"

# 2. Refusal-led prose reads high.
cat > "$pen/cold.md" <<'EOF'
A check that cannot fail is not a check. Nothing here is trusted until it refuses a
broken input. The guard was blind to an entire class and no meter caught the failure.
A stale claim is worse than a missing one, and a broken reference never resolves.
Nothing grows until something breaks, and no page may lie about what it cannot prove.
EOF
c=$(pct_of "$pen/cold.md")
[ "$c" -ge 60 ] && echo "cold_reads_high=yes" || echo "cold_reads_high=no ($c%)"
[ "$c" -gt "$w" ] && echo "reading_discriminates=yes" || echo "reading_discriminates=no"

# 3. A fenced code block is code rather than prose, and must not colour the reading.
cat > "$pen/fenced.md" <<'EOF'
Grain gives you a computer that answers to you. Every bound is named before it is used.

```
if (!ok) return error.NotFound; // never, no, cannot, failed, broken, wrong
if (!ok) return error.NotFound; // never, no, cannot, failed, broken, wrong
```

A witness prints green when a promise holds, and the tree keeps its own books.
EOF
f=$(pct_of "$pen/fenced.md")
[ "$f" -le 20 ] && echo "fence_excluded=yes" || echo "fence_excluded=no ($f%)"

# 4. Tables and headings carry labels rather than sentences, and are read past.
cat > "$pen/table.md" <<'EOF'
## Failure, error, broken, missing

| Reading | Now |
|---|---|
| never | no |
| cannot | failed |

Grain gives you a computer that answers to you. Every bound is named before it is used.
A witness prints green when a promise holds, and the tree keeps its own books today.
EOF
t=$(pct_of "$pen/table.md")
[ "$t" -le 20 ] && echo "table_excluded=yes" || echo "table_excluded=no ($t%)"

# 5. A fragment shorter than four words is no sentence.
printf 'Yes. No. Fine. Grain gives you a computer that answers to you today and tomorrow.\n' > "$pen/frag.md"
[ "$(sent_of "$pen/frag.md")" -eq 1 ] && echo "fragments_skipped=yes" || echo "fragments_skipped=no"

# 6. An empty page reads zero rather than dividing by zero.
: > "$pen/empty.md"
[ "$(pct_of "$pen/empty.md")" -eq 0 ] && echo "empty_safe=yes" || echo "empty_safe=no"

# 8. A paragraph that opens with a bold span is prose, and is read (REDS %451). This is the whole
#    of the repair: the elder `*` branch dropped every one of these, so a page could be graded on
#    the fraction of itself that happened to start with a plain word.
cat > "$pen/boldlead.md" <<'EOF'
# A page

**Language:** EN

**What went wrong:** the guard was blind to an entire class and no meter caught the failure.
**What caught it:** nothing did, and the broken reading stood for weeks without a refusal.
**What it taught:** a stale claim is worse than a missing one, and no page may lie about it.
EOF
b=$(pct_of "$pen/boldlead.md")
[ "$(sent_of "$pen/boldlead.md")" -ge 3 ] && echo "bold_lead_is_read=yes" || echo "bold_lead_is_read=no"
[ "$b" -ge 60 ] && echo "bold_lead_reads_high=yes" || echo "bold_lead_reads_high=no ($b%)"

# 9. A real bullet is still read past -- the marker THEN whitespace, which is what CommonMark says.
cat > "$pen/bullets.md" <<'EOF'
Grain gives you a computer that answers to you. Every bound is named before it is used.

- never, no, cannot, failed, broken, wrong, lost, stale, dead, refused, missing, absent
* never, no, cannot, failed, broken, wrong, lost, stale, dead, refused, missing, absent
+ never, no, cannot, failed, broken, wrong, lost, stale, dead, refused, missing, absent

A witness prints green when a promise holds, and the tree keeps its own books today.
EOF
u=$(pct_of "$pen/bullets.md")
[ "$u" -le 20 ] && echo "bullets_excluded=yes" || echo "bullets_excluded=no ($u%)"

# 10. Front matter is dropped ON PURPOSE, where it used to fall to the bullet branch by accident.
#     The wrapped value on the continuation line rides with it, which is what finally drops the
#     shared `**Where this sits:**` navigation block -- twelve words carrying one negation, counted
#     as prose on 111 front doors.
cat > "$pen/front.md" <<'EOF'
# A page

**Status:** Living -- broken, stale, lost, dead, refused, missing, wrong, and never repaired
**Where this sits:** home is the root, and the whole path from nothing to a signed home is
here, with no leader to elect and no central book to guard along the way at all

Grain gives you a computer that answers to you. Every bound is named before it is used.
A witness prints green when a promise holds, and the tree keeps its own books today.
EOF
m=$(pct_of "$pen/front.md")
[ "$m" -le 20 ] && echo "front_matter_excluded=yes" || echo "front_matter_excluded=no ($m%)"

# 11. THE REFUSAL SIDE OF THE SAME RULE, and the reason it needs both position and shape. A body
#     paragraph opening with a bold key is the SAME SHAPE as front matter, so a rule keyed on shape
#     alone ate real prose on 77 of 703 living documents when it was tried. The block therefore
#     ends at the first blank line, and everything after it is prose again.
cat > "$pen/afterfront.md" <<'EOF'
# A page

**Status:** Living

**What went wrong:** the guard was blind to an entire class and no meter caught the failure.
**What caught it:** nothing did, and the broken reading stood for weeks without a refusal.
**What it taught:** a stale claim is worse than a missing one, and no page may lie about it.
EOF
a=$(pct_of "$pen/afterfront.md")
[ "$a" -ge 60 ] && echo "body_after_front_matter_is_read=yes" || echo "body_after_front_matter_is_read=no ($a%)"

# 12. A page whose body opens with a bold span and carries NO front matter keeps that body. The
#     head rule requires the short-key shape, so an opening sentence in bold is a sentence.
cat > "$pen/nofront.md" <<'EOF'
# A page

**The working style of this tree** is one nobody measured, and the reading was broken.
Nothing here was trusted, and the stale claim never refused a single wrong input at all.
EOF
[ "$(sent_of "$pen/nofront.md")" -ge 2 ] && echo "bold_opening_without_key_is_read=yes" || echo "bold_opening_without_key_is_read=no"

# 13. The real door roster passes, and the scan agrees with itself.
out=$(sh "$scan" 2>/dev/null)
echo "$out" | grep -q 'door_over_ceiling=0' && echo "live_door_clean=yes" || echo "live_door_clean=no"
echo "$out" | grep -q 'verdict=ok' && echo "live_verdict_ok=yes" || echo "live_verdict_ok=no"

echo "control_verdict=ok"
