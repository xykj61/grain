#!/bin/sh
# tools/fixtures/f/fleet_login_scan.sh -- one command for "why did every ship stop at once?"
#
#   sh tools/fixtures/f/fleet_login_scan.sh
#
# WHY THIS EXISTS. On 20260906 seven of eight ships died three laps apiece inside ten seconds,
# each printing `Failed to authenticate: OAuth session expired and could not be refreshed`, and
# the only way to learn that was to read seven transcripts in seven tmux windows. The fleet seeds
# ONE credential -- `agent-jail.sh` says so in its own words, *one login per pier* -- so a fault in
# that single credential is a fleet-wide outage, and it should be readable in one line rather than
# reconstructed from eight.
#
# WHAT IT READS, and what each reading means:
#   pier_access_valid    the host access token is unexpired -- renewed hourly by design, so `no`
#                        is ordinary and not itself a fault
#   pier_refresh_valid   the host REFRESH token is unexpired. This is the one that matters: an
#                        access token renews itself, and a dead refresh token can only be replaced
#                        by a hand running /login. `no` means the pier is logged out.
#   trees_seeded         how many ship trees hold their own copy of the credential
#   trees_sharing_token  of those, how many carry the SAME refresh token as the pier
#
# THE READING THAT IS NOT A GATE, and the reason. `trees_sharing_token` above 1 is the fleet's
# normal shape today and also its outage mechanism, so it is REPORTED rather than refused: the
# repair is one login per ship, which is a hand at custody gate 3, and a guard that reds on the
# only shape the fleet can currently take is a guard someone turns off.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
PIER_CRED="${HOME}/.claude/.credentials.json"
now_ms=$(( $(date +%s) * 1000 ))

field() { LC_ALL=C sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\([0-9]\{10,\}\).*/\1/p" "$1" 2>/dev/null | head -1; }
tok()   { LC_ALL=C sed -n "s/.*\"refreshToken\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$1" 2>/dev/null | head -1; }

# THE READING THIS SCAN CANNOT TAKE FROM INSIDE A JAIL (REDS %458). `agent-jail.sh` binds the
# ship's own `loops/claude` over `$HOME/.claude`, so inside the enclosure `$HOME/.claude/` IS the
# ship's copy -- same device, same inode -- and calling it *the pier's* names one file twice. The
# first version of this scan did exactly that, reported `trees_sharing_token=1` from comparing a
# file with itself, and every conclusion drawn about the pier's credential was drawn about this
# tree's. An agent runs this from inside the jail, which is precisely where the reading is wrong.
#
# So the seam is DETECTED rather than assumed, by asking the filesystem whether the two paths are
# one file, and a scan that cannot see the pier says so and refuses that half. The tree readings
# below stand either way -- peer trees are bound in read-only and their `loops/` rooms are real.
own_copy="$ROOT/loops/claude/.credentials.json"
jailed=no
if [ -e "$PIER_CRED" ] && [ -e "$own_copy" ] && [ "$PIER_CRED" -ef "$own_copy" ]; then
  jailed=yes
fi
echo "pier_visible=$( [ "$jailed" = yes ] && echo no || echo yes )"

if [ "$jailed" = yes ]; then
  echo "detail: \$HOME/.claude is this ship's own loops/claude, bind-mounted -- the pier's credential"
  echo "detail: is not reachable from inside the enclosure, so no pier reading is taken here"
  echo "detail: run this from an unjailed host shell for the pier half"
fi

if [ ! -f "$PIER_CRED" ]; then
  echo "pier_credential=absent"
  echo "detail: no credential at \$HOME/.claude/.credentials.json -- run claude and /login on the host"
  echo "verdict=pier_logged_out"
  exit 1
fi
echo "pier_credential=present"

acc=$(field "$PIER_CRED" expiresAt)
ref=$(field "$PIER_CRED" refreshTokenExpiresAt)
pier_tok=$(tok "$PIER_CRED")

if [ "$jailed" = yes ]; then
  echo "pier_access_valid=unreadable"
  echo "pier_refresh_valid=unreadable"
else
  [ -n "${acc:-}" ] && { [ "$acc" -gt "$now_ms" ] && echo "pier_access_valid=yes" || echo "pier_access_valid=no"; } || echo "pier_access_valid=unknown"
  [ -n "${ref:-}" ] && { [ "$ref" -gt "$now_ms" ] && echo "pier_refresh_valid=yes" || echo "pier_refresh_valid=no"; } || echo "pier_refresh_valid=unknown"
fi

# NAMED, NEVER ONLY COUNTED. A count answers "did it work?" with a number that looks the same
# whether the right ship or the wrong one changed, and the whole point of a per-ship login is that
# ONE named tree got its own session. So each tree prints its own line and the counts follow.
seeded=0; sharing=0; own=0
for d in "$(dirname "$ROOT")"/grain-*; do
  [ -d "$d" ] || continue
  t=${d##*/grain-}
  c="$d/loops/claude/.credentials.json"
  if [ ! -f "$c" ]; then
    echo "tree $t no_copy -- seeds from the pier at launch"
    continue
  fi
  seeded=$((seeded + 1))
  if [ "$jailed" = yes ] && [ "$c" -ef "$PIER_CRED" ]; then
    # This ship's own copy, reached through the bind. Comparing it to itself can only ever say
    # equal, which is a tautology rather than a reading.
    echo "tree $t own_copy_self -- this ship; no comparison possible from inside its own jail"
  elif [ "$(tok "$c")" = "$pier_tok" ]; then
    sharing=$((sharing + 1)); echo "tree $t shares_pier_token"
  else
    own=$((own + 1)); echo "tree $t own_session"
  fi
done
echo "trees_seeded=$seeded"
echo "trees_sharing_token=$sharing"
echo "trees_own_session=$own"

if [ "$jailed" = yes ]; then
  echo "verdict=pier_unreadable_from_jail"
  exit 0
fi
if [ "${ref:-0}" -le "$now_ms" ] 2>/dev/null; then
  echo "detail: the pier's refresh token has expired -- every ship seeds from it, so every ship is out"
  echo "detail: run claude on the HOST and /login; the ships heal on their next round-open"
  echo "verdict=pier_logged_out"
  exit 1
fi
if [ "$sharing" -gt 1 ]; then
  echo "detail: $sharing trees carry one refresh token -- a rotation by any one can strand the rest"
fi
echo "verdict=ok"
