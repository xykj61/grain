#!/bin/sh
# tools/fixtures/tracked_link_control.sh -- prove the tracked-link meter can red, and where it stays free.
#
# WHY. A guard that cannot red guards nothing -- the grain seats that strand
# (foundations/20260702-184312_the-grain-and-the-crossing.md, REDS row 59). And a guard that reds
# on honest input teaches the bench to route around it, which is worse than no guard, so every
# refusal here is proven beside the free passes that bound it.
#
# WHAT IS PROVEN, each on a throwaway repository built in a temporary pen.
#   A tree whose every link is tracked passes free.
#   A living link resolving only through an untracked directory is refused.
#   A tracked symlink landing outside the tracked tree is refused.
#   A link resolving NOWHERE passes free -- that duty belongs to living_docs_lint.
#   A dated-named document carrying the same link passes free -- testimony keeps its words.
#   A symlink into vendor/ passes free -- provisioned rather than tracked.
#   A yonder link counts as a ratchet under its ceiling, and refuses once over it.
#
# USAGE
#   sh tools/fixtures/tracked_link_control.sh
#
# Driven by tools/tracked_link_witness.rish. Run from the repository root.

set -eu

scan="$(pwd)/tools/fixtures/tracked_link_scan.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# One throwaway repository, rebuilt from a clean index for each planting.
plant() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree"
  ( cd "$pen/tree"
    git init -q .
    git config user.email control@example.invalid
    git config user.name Control
    git config commit.gpgsign false
    mkdir -p crux docs
    printf '# the living card\n' > crux/REMEMBER.md
    printf '# a front door\n\nA good link: [card](../crux/REMEMBER.md)\n' > docs/FRONT.md
  )
}

seal() {
  ( cd "$pen/tree" && git add -A && git commit -q -m "control: plant" )
}

run_scan() {
  ceiling="${1:-219}"
  ( cd "$pen/tree" && TRACKED_LINK_CEILING="$ceiling" sh "$scan" 2>/dev/null ) || true
}

# --- the agreeing tree, so the gate is proven to have a green side ---------------------
plant; seal
out=$(run_scan)
case "$out" in *"verdict=ok"*) echo "agreeing_free=yes" ;; *) echo "agreeing_free=no" ;; esac
case "$out" in *"living_links_outside_tree=0"*) echo "clean_reads_zero=yes" ;; *) echo "clean_reads_zero=no" ;; esac

# --- a living link resolving only through an untracked directory ----------------------
# This is the shape that cost twenty-six references: the room exists on THIS machine and
# is absent from the repository, so the link works here and breaks in every clone.
plant
mkdir -p "$pen/tree/elsewhere"
printf '# an untracked room\n' > "$pen/tree/elsewhere/OLD.md"
printf 'ignored\nelsewhere/\n' > "$pen/tree/.gitignore"
printf '# a front door\n\nA stale link: [old](../elsewhere/OLD.md)\n' > "$pen/tree/docs/FRONT.md"
seal
out=$(run_scan)
case "$out" in *"verdict=link_outside_tree"*) echo "untracked_target_refused=yes" ;; *) echo "untracked_target_refused=no" ;; esac
case "$out" in *"living_links_outside_tree=1"*) echo "untracked_target_counted=yes" ;; *) echo "untracked_target_counted=no" ;; esac

# --- a link resolving nowhere at all, which is another guard's duty --------------------
plant
printf '# a front door\n\nA link to nothing: [gone](../no/such/file.md)\n' > "$pen/tree/docs/FRONT.md"
seal
out=$(run_scan)
case "$out" in *"verdict=ok"*) echo "nowhere_link_free=yes" ;; *) echo "nowhere_link_free=no" ;; esac

# --- the same stale link inside dated testimony, which keeps every word it wrote -------
plant
mkdir -p "$pen/tree/elsewhere"
printf '# an untracked room\n' > "$pen/tree/elsewhere/OLD.md"
printf 'ignored\nelsewhere/\n' > "$pen/tree/.gitignore"
printf '# a dated note\n\nA stale link: [old](../elsewhere/OLD.md)\n' > "$pen/tree/docs/20260101-000000_a-dated-note.md"
seal
out=$(run_scan)
case "$out" in *"verdict=ok"*) echo "dated_testimony_free=yes" ;; *) echo "dated_testimony_free=no" ;; esac

# --- a tracked symlink landing outside the tracked tree --------------------------------
plant
mkdir -p "$pen/tree/elsewhere"
printf '# an untracked room\n' > "$pen/tree/elsewhere/OLD.md"
printf 'ignored\nelsewhere/\n' > "$pen/tree/.gitignore"
ln -s ../elsewhere/OLD.md "$pen/tree/docs/stray.md"
seal
out=$(run_scan)
case "$out" in *"verdict=link_outside_tree"*) echo "stray_symlink_refused=yes" ;; *) echo "stray_symlink_refused=no" ;; esac
case "$out" in *"symlinks_outside_tree=1"*) echo "stray_symlink_counted=yes" ;; *) echo "stray_symlink_counted=no" ;; esac

# --- a symlink into vendor/, provisioned by submodule or fetch rather than tracked -----
plant
mkdir -p "$pen/tree/vendor/toolchain"
printf '# a provisioned toolchain\n' > "$pen/tree/vendor/toolchain/lib.md"
printf 'ignored\nvendor/\n' > "$pen/tree/.gitignore"
ln -s ../vendor/toolchain/lib.md "$pen/tree/docs/lib.md"
seal
out=$(run_scan)
case "$out" in *"verdict=ok"*) echo "vendor_symlink_free=yes" ;; *) echo "vendor_symlink_free=no" ;; esac

# --- a yonder link counts as a ratchet, and refuses only once over its ceiling ---------
plant
mkdir -p "$pen/tree/external-research/yonder" "$pen/tree/elsewhere"
printf '# an untracked room\n' > "$pen/tree/elsewhere/OLD.md"
printf 'ignored\nelsewhere/\n' > "$pen/tree/.gitignore"
printf '# a deferred note\n\nA stale link: [old](../../elsewhere/OLD.md)\n' > "$pen/tree/external-research/yonder/NOTE.md"
seal
out=$(run_scan 1)
case "$out" in *"verdict=ok"*) echo "yonder_under_ceiling_free=yes" ;; *) echo "yonder_under_ceiling_free=no" ;; esac
case "$out" in *"yonder_links_outside_tree=1"*) echo "yonder_counted=yes" ;; *) echo "yonder_counted=no" ;; esac
out=$(run_scan 0)
case "$out" in *"verdict=link_outside_tree"*) echo "yonder_over_ceiling_refused=yes" ;; *) echo "yonder_over_ceiling_refused=no" ;; esac

echo "control_verdict=ok"
