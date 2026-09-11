#!/bin/sh
# tools/fixtures/f/front_door_claim_control.sh -- the front-door claim scan proven from both sides.
#
# WHAT IT PROVES. Every reading `front_door_claim_scan.sh` gates stands here twice: planted, so the
# refusal is seen, and then lifted, so the welcome is seen beside it. Each leg runs on a real git
# repository built in a throwaway pen, whose answer is known by construction before the scan reads
# it. A welcome is asserted as hard as a refusal, because a gate shown only in the passing direction
# reads exactly like a gate with a door beside it.
#
# WHY A PEN OF REAL REPOSITORIES. The scan asks `git ls-files` whether a page is tracked, so the
# question it answers only exists inside a repository. A pen of plain directories would let a leg
# pass for a reason the living tree never supplies.
#
# WHAT EACH PEN HOLDS. One room of pages, one front door, and a claim between them -- the smallest
# tree where the promise this guard reads is either kept or broken.
#
# THE LEGS
#   kept_accepted            a front door that names the claiming page reads ok
#   backlink_refused         a front door that never names it refuses under no_backlink
#   backlink_named           and the refusal names page, target and cause, so a hand can repair it
#   backlink_lift            adding the back link lifts the refusal -- the reading did the work
#   absent_refused           a claim naming a path the tree does not carry refuses under absent
#   absent_lift              and tracking that page lifts it
#   no_target_refused        a key carrying no Markdown link refuses under no_target
#   keyless_page_read_past   a page with no key is never counted as a claim
#   no_claims_refused        a tree where nobody declares the key refuses rather than reading green
#   no_pages_refused         a room holding no page refuses rather than counting zero claims
#   no_repo_refused          outside a git repository the scan refuses rather than reading the disk
#   dotdot_resolved          an interior `..` is resolved textually, so ../README.md finds the root
#   two_targets_counted      two links on one key are two claims
#   testimony_shelf_read_past a page on a date/ shelf keeps its words and is never read
#   basename_any_path        the back link is read by basename, so any relative form keeps the claim
#
# Run from the repository root:
#   sh tools/fixtures/f/front_door_claim_control.sh

set -eu

scan=$(pwd)/tools/fixtures/f/front_door_claim_scan.sh
pen=${TMPDIR:-/tmp}/fdcc-pen-$$
mkdir -p "$pen" || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
note() {
  if [ "$2" = yes ]; then pass=$((pass + 1)); echo "ok   $1"; else fail=$((fail + 1)); echo "FAIL $1"; fi
}

newrepo() {
  d="$pen/$1"
  mkdir -p "$d"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen ) >/dev/null 2>&1
  printf '%s\n' "$d"
}

track() { ( cd "$1" && git add -A . >/dev/null 2>&1 ); }

runscan() { ( cd "$1" && shift && sh "$scan" "$@" 2>&1 ) || true; }

# --- a repository whose front door keeps the claim --------------------------------------------
r=$(newrepo kept)
mkdir -p "$r/why"
printf '# page\n\n**Front door:** the root [`../README.md`](../README.md) names this page.\n' > "$r/why/20260101-000001_a-page.md"
printf '# door\n\nsee [the page](why/20260101-000001_a-page.md)\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"verdict=ok"*) k=yes ;; *) k=no ;; esac
case "$out" in *"claims=1"*) : ;; *) k=no ;; esac
note "a front door that names the claiming page reads ok" "$k"

# the same repository with the back link removed
printf '# door\n\nnothing here\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"verdict=claim_unkept"*) k=yes ;; *) k=no ;; esac
note "a front door that never names it refuses under claim_unkept" "$k"
case "$out" in *"unkept: why/20260101-000001_a-page.md -> README.md no_backlink"*) k=yes ;; *) k=no ;; esac
note "and the refusal names page, target and cause" "$k"

# and lifting it again
printf '# door\n\nsee [the page](./why/20260101-000001_a-page.md)\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"verdict=ok"*) k=yes ;; *) k=no ;; esac
note "adding the back link lifts the refusal -- the reading did the work" "$k"
note "the back link is read by basename, so any relative form keeps the claim" "$k"

# --- a claim naming a path the tree does not carry ---------------------------------------------
r=$(newrepo absent)
mkdir -p "$r/why"
printf '# page\n\n**Front door:** [`../DOOR.md`](../DOOR.md)\n' > "$r/why/20260101-000002_a-page.md"
printf '# root\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"no_backlink"*) k=no ;; *"DOOR.md absent"*) k=yes ;; *) k=no ;; esac
note "a claim naming a path the tree does not carry refuses under absent" "$k"
printf '# door\n\nnames 20260101-000002_a-page.md\n' > "$r/DOOR.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"verdict=ok"*) k=yes ;; *) k=no ;; esac
note "and tracking that page lifts it" "$k"

# --- a key carrying no Markdown link ------------------------------------------------------------
r=$(newrepo notarget)
mkdir -p "$r/why"
printf '# page\n\n**Front door:** the root README, named in prose alone.\n' > "$r/why/20260101-000003_a-page.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"no_target"*) k=yes ;; *) k=no ;; esac
note "a key carrying no Markdown link refuses under no_target" "$k"

# --- a page with no key is never counted --------------------------------------------------------
r=$(newrepo keyless)
mkdir -p "$r/why"
printf '# page\n\n**Front door:** [`../README.md`](../README.md)\n' > "$r/why/20260101-000004_claims.md"
printf '# quiet\n\nno key at all, and it names nothing.\n' > "$r/why/20260101-000005_quiet.md"
printf '# door\n\nsee [it](why/20260101-000004_claims.md)\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"claiming_pages=1"*) k=yes ;; *) k=no ;; esac
case "$out" in *"verdict=ok"*) : ;; *) k=no ;; esac
note "a page with no key is never counted as a claim" "$k"

# --- a tree where nobody declares the key -------------------------------------------------------
r=$(newrepo noclaims)
mkdir -p "$r/why"
printf '# page\n\nplain prose.\n' > "$r/why/20260101-000006_a-page.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"verdict=no_claims"*) k=yes ;; *) k=no ;; esac
note "a tree where nobody declares the key refuses rather than reading green" "$k"

# --- a room holding no page ---------------------------------------------------------------------
out=$(runscan "$r" absent-room)
case "$out" in *"verdict=no_pages"*) k=yes ;; *) k=no ;; esac
note "a room holding no page refuses rather than counting zero claims" "$k"

# --- outside a git repository -------------------------------------------------------------------
mkdir -p "$pen/bare/why"
out=$( cd "$pen/bare" && sh "$scan" why 2>&1 || true )
case "$out" in *"verdict=no_repo"*|*"verdict=no_git"*) k=yes ;; *) k=no ;; esac
note "outside a git repository the scan refuses rather than reading the disk" "$k"

# --- an interior .. is resolved ------------------------------------------------------------------
r=$(newrepo dotdot)
mkdir -p "$r/why/deep"
printf '# page\n\n**Front door:** [`../../README.md`](../../README.md)\n' > "$r/why/deep/20260101-000007_a-page.md"
printf '# door\n\nsee [it](why/deep/20260101-000007_a-page.md)\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"verdict=ok"*) k=yes ;; *) k=no ;; esac
note "an interior .. is resolved textually, so ../../README.md finds the root" "$k"

# --- two links on one key are two claims ---------------------------------------------------------
r=$(newrepo two)
mkdir -p "$r/why"
printf '# page\n\n**Front door:** [`../README.md`](../README.md) and [`../MAP.md`](../MAP.md)\n' > "$r/why/20260101-000008_a-page.md"
printf '# door\n\nsee [it](why/20260101-000008_a-page.md)\n' > "$r/README.md"
printf '# map\n\nsee [it](why/20260101-000008_a-page.md)\n' > "$r/MAP.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"claims=2"*) k=yes ;; *) k=no ;; esac
case "$out" in *"verdict=ok"*) : ;; *) k=no ;; esac
note "two links on one key are two claims" "$k"

# --- a dated shelf page keeps its words ----------------------------------------------------------
r=$(newrepo shelf)
mkdir -p "$r/why/date/20260101" "$r/why"
printf '# page\n\n**Front door:** [`../../README.md`](../../README.md)\n' > "$r/why/date/20260101/20260101-000009_old.md"
printf '# page\n\n**Front door:** [`../README.md`](../README.md)\n' > "$r/why/20260101-000010_live.md"
printf '# door\n\nsee [it](why/20260101-000010_live.md)\n' > "$r/README.md"
track "$r"
out=$(runscan "$r" why)
case "$out" in *"claims=1"*) k=yes ;; *) k=no ;; esac
case "$out" in *"verdict=ok"*) : ;; *) k=no ;; esac
note "a page on a date/ shelf keeps its words and is never read" "$k"

echo "pass=$pass"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=control_green"; exit 0; fi
echo "verdict=control_red"
exit 1
