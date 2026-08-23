#!/bin/sh
# tools/fixtures/seed_link_scan.sh -- a link in a shipped document lands in the shipped tree.
#
# WHY. This tree publishes two ways from one set of files. The maintainer's field carries every
# room; the public seed is an ALLOWLIST projection of it, named path by path in
# template-manifest.bron and pushed to grain-os/grain. One README serves both. So a link that
# resolves perfectly in the field -- `gratitude/Rust.md`, `crux/REMEMBER.md` -- resolves NOWHERE
# for the reader who arrives at the seed, because the seed never carried that room.
#
# tools/tracked_link_witness.rish asks "is this in the repository." That is the right question
# for the field and the wrong question for the seed, which is a different repository with fewer
# rooms. Measured on 20260823, the front door alone shipped nineteen links into rooms the seed
# does not carry, and 867 stood across every living shipped document. No guard read this at all.
#
# WHAT IS GATED, hard. Every relative link in a FRONT-DOOR document lands on a path the seed
# also ships. The front door is the set a first-time visitor actually opens, and it is named
# below rather than discovered, so a new root document cannot join it by accident.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. The same reading across
# every other living seed-shipped document. The repair is per-document and wants a hand -- a
# withheld room is NAMED IN PROSE rather than linked, which is a rewrite rather than a repoint --
# so it falls on touch instead of in one sweep.
#
# WHAT PASSES FREE, by named rule.
#   Dated testimony -- a file whose own basename carries a one-clock stamp keeps every reference
#   it ever wrote (accrete-never-break). It is read past, never rewritten.
#   Absolute links, anchors, `http`, and `mailto:`, none of which name a path in this tree.
#   Any document the seed does not ship. It cannot break a link for a reader who never sees it.
#
# WHAT IS NOT PROVEN. That a link points at the RIGHT file -- tools/tracked_link_witness.rish and
# tools/living_docs_lint.rish own resolution in the field. This scan asks only the narrower and
# more surprising question: does it survive the projection.
#
# USAGE
#   sh tools/fixtures/seed_link_scan.sh
#
# Driven by tools/seed_link_witness.rish. Run from the repository root.

set -u

MANIFEST=${SEED_LINK_MANIFEST:-template-manifest.bron}

# The front door: what a first-time visitor opens. Named, never discovered -- a guard whose
# enforced set grows by itself is a guard that reds on work it never agreed to cover.
FRONT_DOOR="README.md SECURITY.md CODE_OF_CONDUCT.md CHANGELOG.md"

# The ratchet's ceiling only ever falls. Measured 20260823 after the front door was cleared.
ceiling=848   # no override exists: the control proves both sides by planting, never by a flag

[ -f "$MANIFEST" ] || { echo "detail: absent ($MANIFEST)"; echo "verdict=missing_manifest"; exit 2; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

grep -E '^allow ' "$MANIFEST" | awk '{print $2}' | grep -vxE 'gratitude|vendor' | sort -u > "$work/allow"
grep -E '^sub_exclude ' "$MANIFEST" | awk '{print $2}' | sort -u > "$work/deny"

git ls-files '*.md' > "$work/md"

awk -v allowf="$work/allow" -v denyf="$work/deny" -v front="$FRONT_DOOR" '
  function inseed(p,   c) {
    if (p == "" || p ~ /^\.\./ || p ~ /^\//) return 0
    for (d in deny) if (p == d || index(p, d "/") == 1) return 0
    c = p
    while (c != "" && c != ".") {
      if (c in allow) return 1
      if (c !~ /\//) return 0
      sub(/\/[^\/]*$/, "", c)
    }
    return 0
  }
  # posix-style normalise: collapse "a/b/../c" and "./"
  function norm(p,   n, i, parts, out, k) {
    gsub(/\/\.\//, "/", p); sub(/^\.\//, "", p)
    n = split(p, parts, "/"); k = 0
    for (i = 1; i <= n; i++) {
      if (parts[i] == "." || parts[i] == "") continue
      if (parts[i] == "..") { if (k > 0) k--; else { out[++k] = ".." } ; continue }
      out[++k] = parts[i]
    }
    p = ""
    for (i = 1; i <= k; i++) p = (p == "" ? out[i] : p "/" out[i])
    return p
  }
  BEGIN {
    while ((getline l < allowf) > 0) allow[l] = 1
    while ((getline l < denyf) > 0) deny[l] = 1
    split(front, fd, " "); for (i in fd) isfront[fd[i]] = 1
    shipped = 0; checked = 0; gated = 0; ratchet = 0
  }
  {
    f = $0
    if (!inseed(f)) next
    shipped++
    # Dated testimony keeps every reference it ever wrote.
    base = f; sub(/^.*\//, "", base)
    testimony = (base ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_/)
    dir = f; if (dir ~ /\//) sub(/\/[^\/]*$/, "", dir); else dir = ""
    while ((getline line < f) > 0) {
      rest = line
      while (match(rest, /\]\([^)]+\)/)) {
        tok = substr(rest, RSTART + 2, RLENGTH - 3)
        rest = substr(rest, RSTART + RLENGTH)
        sub(/#.*$/, "", tok); gsub(/^[ \t]+|[ \t]+$/, "", tok)
        if (tok == "" || tok ~ /^https?:/ || tok ~ /^mailto:/ || tok ~ /^\//) continue
        checked++
        t = norm(dir == "" ? tok : dir "/" tok)
        if (inseed(t)) continue
        if (testimony) continue
        if (isfront[f]) { gated++; print "gated: " f " -> " tok }
        else { ratchet++; if (ratchet <= 5) print "ratchet: " f " -> " tok }
      }
    }
    close(f)
  }
  END {
    print "seed_shipped_docs=" shipped
    print "relative_links_checked=" checked
    print "front_door_links_outside_seed=" gated
    print "other_living_links_outside_seed=" ratchet
  }
' "$work/md" > "$work/out"

sed -n 's/^seed_shipped_docs=/seed_shipped_docs=/p;s/^relative_links_checked=/relative_links_checked=/p' "$work/out" >/dev/null
gated=$(sed -n 's/^front_door_links_outside_seed=//p' "$work/out")
ratchet=$(sed -n 's/^other_living_links_outside_seed=//p' "$work/out")

grep -E '^(seed_shipped_docs|relative_links_checked|front_door_links_outside_seed|other_living_links_outside_seed)=' "$work/out"
echo "front_door_guarded=$(echo "$FRONT_DOOR" | wc -w | tr -d ' ')"
echo "other_living_ceiling=$ceiling"
grep -E '^(gated|ratchet):' "$work/out" || true
[ "${ratchet:-0}" -le "$ceiling" ] || echo "detail: the ratchet rose above its ceiling -- it only ever falls"

if [ "${gated:-1}" -eq 0 ] && [ "${ratchet:-0}" -le "$ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=link_outside_seed"
echo "refused: a shipped document links into a room the seed does not carry -- name it in prose instead" >&2
exit 1
