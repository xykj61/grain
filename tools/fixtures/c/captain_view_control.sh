#!/bin/sh
# Proves the captain's view on metal: a real sandbox, a real peer tree, real credentials denied.
#
# WHY A REAL SANDBOX RATHER THAN A DRY RUN. The dry run prints the flags, and flags are an intention.
# What matters is what the kernel does with them, so every leg below enters an actual enclosure and
# tries the thing -- reading a peer's work, writing into its tree, and reaching for its keys.
#
# WHAT THE VIEW IS FOR. The captain holds law and review, and review wants a peer's WORKING tree,
# including what it has not committed -- the one thing the anointed remote cannot show. What it must
# never reach is a peer's credentials: `.gnupg-rye` is that ship's signing key, `.ssh` its deploy
# key, and `loops/` its agent auth. Denial rather than masking, because an empty directory reads
# like a ship with no keys rather than one whose keys are none of the captain's business.
set -u
AJ="${AIJAIL_BIN:-ai-jail}"
command -v "$AJ" >/dev/null 2>&1 || { echo "captain_view: REFUSED -- $AJ is absent" >&2; exit 2; }
pier=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)/..
pier=$(CDPATH= cd -- "$pier" && pwd)
pass=0; fail=0
ck() { if printf '%s' "$2" | grep -q -- "$3"; then pass=$((pass+1)); else
  fail=$((fail+1)); echo "  FAIL $1: wanted '$3' in: $2"; fi; }

# A peer with a real tree, real keys, and something uncommitted to look at.
peer=""
for c in grain-petrichor grain-pheromone grain-copal grain-patchouli; do
  [ -d "$pier/$c/.git" ] && [ -d "$pier/$c/.gnupg-rye" ] && { peer="$pier/$c"; break; }
done
[ -n "$peer" ] || { echo "captain_view: REFUSED -- no peer tree with a keyring on this pier" >&2; exit 2; }

out=$(timeout 120 "$AJ" --no-save-config --private-home --no-gpu --no-docker --no-tailscale --no-display \
  --map "$peer" --deny-path "$peer/.gnupg-rye" --deny-path "$peer/.ssh" --deny-path "$peer/loops" \
  -- sh -c "
    printf 'work=%s\n'  \"\$(head -c 8 '$peer/README.md' >/dev/null 2>&1 && echo readable || echo denied)\"
    printf 'write=%s\n' \"\$(touch '$peer/.captain_probe' 2>/dev/null && echo ALLOWED || echo refused)\"
    printf 'gpg=%s\n'   \"\$(ls '$peer/.gnupg-rye' >/dev/null 2>&1 && echo ALLOWED || echo denied)\"
    printf 'ssh=%s\n'   \"\$(ls '$peer/.ssh' >/dev/null 2>&1 && echo ALLOWED || echo denied)\"
  " 2>&1) || true

ck "peer work is readable"      "$out" "work=readable"
ck "peer tree refuses a write"  "$out" "write=refused"
ck "peer signing key is denied" "$out" "gpg=denied"
ck "peer deploy key is denied"  "$out" "ssh=denied"

# The probe must not exist afterward -- a refused write that landed anyway is the worst outcome.
if [ -e "$peer/.captain_probe" ]; then
  fail=$((fail+1)); echo "  FAIL the refused write actually landed"; rm -f "$peer/.captain_probe"
else pass=$((pass+1)); fi

# And the launcher refuses the variable from any tree but the captain's.
here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
case "$(basename "$here")" in
  grain-incense) pass=$((pass+1)) ;;   # this control runs in the captain's own tree
  *) out2=$(FLEET_CAPTAIN_VIEW=1 sh "$here/tools/ag/agent-jail.sh" --dry-run claude --version 2>&1 || true)
     ck "non-captain tree refuses" "$out2" "refusing" ;;
esac

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
