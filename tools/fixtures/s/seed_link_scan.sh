#!/bin/sh
# tools/fixtures/s/seed_link_scan.sh -- a link in a shipped document lands in the shipped tree.
#
# WHY. This tree publishes two ways from one set of files. The maintainer's field carries every
# room; the public seed is an ALLOWLIST projection of it, named path by path in
# template-manifest.kyri and pushed to grain-os/grain. One README serves both. So a link that
# resolves perfectly in the field -- `gratitude/Rust.md`, `construction/ITINERARY.md` -- resolves NOWHERE
# for the reader who arrives at the seed, because the seed never carried that room.
#
# tools/t/tracked_link_witness.rish asks "is this in the repository." That is the right question
# for the field and the wrong question for the seed, which is a different repository with fewer
# rooms. Measured on 20260823, the front door alone shipped nineteen links into rooms the seed
# does not carry, and 867 stood across every living shipped document. No guard read this at all.
#
# WHAT IS GATED, hard. Every relative link in a FRONT-DOOR document lands on a path the seed
# also ships. The front door is the set a first-time visitor actually opens, and it is named
# below rather than discovered, so a new root document cannot join it by accident.
#
# THE ROSTER WIDENED 20260916, AND THE REASON IS A WALK RATHER THAN A FILENAME. The elder set
# was the four root files GitHub itself recognises -- README, SECURITY, CODE_OF_CONDUCT,
# CHANGELOG -- which is one honest answer to "what does a visitor open first" and a poor answer
# to "what do they open second." README.md stood gated and clean while linking straight into
# MAP.md, ORGANIZING.md, SOURCE.md and docs-geode/README.md, which between them carried 27 links
# into rooms the seed leaves behind. So the promise held for one page and the hand passed
# through at step two, on the exact walk that page is built to start. Those four are the doors
# README names, they are all `scrub`-verdict pages the manifest deliberately ships, and they are
# gated from this stamp -- still named rather than discovered.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. The same reading across
# every other living seed-shipped document. The repair is per-document and wants a hand -- a
# withheld room is NAMED IN PROSE rather than linked, which is a rewrite rather than a repoint --
# so it falls on touch instead of in one sweep.
#
# WHAT PASSES FREE, by named rule.
#   Dated testimony -- a file whose own basename carries a one-clock stamp, or that stands in a
#   closed stack (date/, archive/, yonder/, anywhere in its path), keeps every reference it ever
#   wrote (accrete-never-break, read-scope.md). It is read past, never rewritten. Widened 20260926:
#   528 sites stood under external-research/yonder/ alone, carried by retired countdown-prefix
#   research notes (`9911_mem_concat.md`) that predate the one-clock law and so never matched the
#   basename check -- ceiling fell 908 (over its own 820) to 380.
#   Absolute links, anchors, `http`, and `mailto:`, none of which name a path in this tree.
#   Any document the seed does not ship. It cannot break a link for a reader who never sees it.
#   A link to a room the projection MAKES. The manifest allows files rather than directories in
#   twenty-one `context/` rows, and the projection creates each destination room to hold the
#   pages it ships, so `[the rooms under](./)` opens in the seed as surely as in the field. A
#   room no allow row reaches is still a room that is not there, and is still counted.
#
# WHAT IS NOT PROVEN. That a link points at the RIGHT file -- tools/t/tracked_link_witness.rish and
# tools/l/living_docs_lint.rish own resolution in the field. This scan asks only the narrower and
# more surprising question: does it survive the projection.
#
# USAGE
#   sh tools/fixtures/s/seed_link_scan.sh              # the reading, five sites named
#   sh tools/fixtures/s/seed_link_scan.sh --list       # every ratchet site, one per line
#
# Driven by tools/s/seed_link_witness.rish. Run from the repository root.

set -u

MANIFEST=${SEED_LINK_MANIFEST:-template-manifest.kyri}

# The front door: what a first-time visitor opens. Named, never discovered -- a guard whose
# enforced set grows by itself is a guard that reds on work it never agreed to cover.
# The four GitHub-convention root files, and the four doors README.md itself opens next.
FRONT_DOOR="README.md SECURITY.md CODE_OF_CONDUCT.md CHANGELOG.md MAP.md SOURCE.md ORGANIZING.md docs-geode/README.md"

# The ratchet's ceiling only ever falls. Measured 20260823 after the front door was cleared at
# 848; lowered to 820 on 20260916 when the four second-step doors were cleared and gated; lowered
# to 380 on 20260926 when the testimony reading widened to the closed-stack directory shape
# (date/, archive/, yonder/) and 528 sites -- retired countdown-prefix research notes under
# external-research/yonder/ that carried no one-clock stamp -- stopped being miscounted as living.
# Lowered to 342 the same day, per-document, after the 38-site "Cursor twin retired" footer
# (`.claude/rules/*.md`, CLAUDE.md, context/specs/enclosure-editors.md) named its withheld room
# in prose -- a backticked path with no link -- rather than linking into `.cursor-archive/`, which
# the manifest marks `personal` and never ships.
# Lowered to 272 on 20260926 after context/LEXICON.md's own 55 rows, carrying 70 link occurrences
# into `personal`-verdict counsel/, were rewritten the same way -- each `[`path`](path)` link's
# text already named the path, so the conversion drops the brackets and keeps the backtick.
# Lowered to 224 on 20260926 after every remaining link into `gratitude/` (19 files, 48 sites) was
# rewritten the same way -- the scan treats gratitude/ and vendor/ as unverified rather than shipped
# (line 96's exclusion), since a per-file scrub/sub_exclude split cannot be certified at this check's
# granularity, so a link into that room counts here whether or not the specific file survives the
# projection.
# Lowered to 208 on 20260926 after context/LEXICON.md's remaining 16 links into `.cursor-archive/`
# were rewritten the same way -- each link's text already named the path, so the conversion drops
# the brackets and keeps the backtick, matching the `.claude/rules/*.md` footer sweep two commits
# earlier in the same remainder.
ceiling=208   # no override exists: the control proves both sides by planting, never by a flag

# The ratchet named five of its sites and counted the rest, so a lane could not find its own
# share of a debt whose whole repair model is "falls on touch". --list prints every one.
list_all=no
for a in "$@"; do
  case $a in
    --list) list_all=yes ;;
    *) echo "detail: unknown argument ($a)"; echo "verdict=bad_argument"; exit 2 ;;
  esac
done

[ -f "$MANIFEST" ] || { echo "detail: absent ($MANIFEST)"; echo "verdict=missing_manifest"; exit 2; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

grep -E '^allow ' "$MANIFEST" | awk '{print $2}' | grep -vxE 'gratitude|vendor' | sort -u > "$work/allow"
grep -E '^sub_exclude ' "$MANIFEST" | awk '{print $2}' | sort -u > "$work/deny"

git ls-files '*.md' > "$work/md"

awk -v allowf="$work/allow" -v denyf="$work/deny" -v front="$FRONT_DOOR" -v listall="$list_all" '
  function inseed(p,   c) {
    if (p == "" || p ~ /^\.\./ || p ~ /^\//) return 0
    for (d in deny) if (p == d || index(p, d "/") == 1) return 0
    c = p
    while (c != "" && c != ".") {
      if (c in allow) return 1
      if (c !~ /\//) break
      sub(/\/[^\/]*$/, "", c)
    }
    # A room the seed MAKES is a room the seed carries. The manifest allows `context/` twenty-one
    # named pages and never the directory, so the projection creates `context/` to hold them --
    # step 6 of sow_project.sh derives every destination room from the kept list. A link to that
    # room therefore opens in the seed exactly as it opens in the field. Walking upward alone
    # asks the right question about a FILE and the wrong one about a ROOM.
    if (p in carried) return 1
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
    while ((getline l < allowf) > 0) {
      allow[l] = 1
      # Every room an allowed path passes through is a room the projection makes.
      a = l
      while (sub(/\/[^\/]*$/, "", a)) carried[a] = 1
    }
    while ((getline l < denyf) > 0) deny[l] = 1
    split(front, fd, " "); for (i in fd) isfront[fd[i]] = 1
    shipped = 0; checked = 0; gated = 0; ratchet = 0
  }
  {
    f = $0
    if (!inseed(f)) next
    shipped++
    # Dated testimony keeps every reference it ever wrote -- by its own one-clock basename, or by
    # standing in a closed stack (date/, archive/, yonder/), the same directory shape read-scope.md
    # and ascii_document_scan.sh already read past. A retired countdown-prefix research note under
    # external-research/yonder/ carries no one-clock stamp and is testimony all the same.
    base = f; sub(/^.*\//, "", base)
    testimony = (base ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/) \
      || (f ~ /(^|\/)(date|archive|yonder)\//)
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
        else { ratchet++; if (listall == "yes" || ratchet <= 5) print "ratchet: " f " -> " tok }
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
if [ "$list_all" = no ] && [ "${ratchet:-0}" -gt 5 ]; then
  echo "advice: $ratchet sites stand and five are named -- sh tools/fixtures/s/seed_link_scan.sh --list names them all"
fi
[ "${ratchet:-0}" -le "$ceiling" ] || echo "detail: the ratchet rose above its ceiling -- it only ever falls"

if [ "${gated:-1}" -eq 0 ] && [ "${ratchet:-0}" -le "$ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=link_outside_seed"
echo "refused: a shipped document links into a room the seed does not carry -- name it in prose instead" >&2
exit 1
