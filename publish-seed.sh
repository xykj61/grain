#!/usr/bin/env sh
# publish-seed.sh -- the POSIX launch edge for the seed publisher.
#
# The steps live in publish-seed.rish. This file stays a shell because the
# custody card names it, and because the push transport is an environment
# variable: a core.sshCommand value would write this host's path into seed/.git.
#
#   sh publish-seed.sh            # project, prove, commit -- and STOP
#   sh publish-seed.sh --push     # the same, then force-push ww
#
# The bare form cannot publish. Custody gate %1 is the maintainer's word.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT"
[ -f construction/ITINERARY.md ] || { echo "publish-seed: $ROOT is not the field root" >&2; exit 2; }

SSH_CONF="$ROOT/.git/ssh_config_jail"
[ -f "$SSH_CONF" ] || SSH_CONF="$ROOT/.git/ssh_config_urbit"
export GIT_SSH_COMMAND="ssh -F $SSH_CONF"
exec rishi/bin/rishi run publish-seed.rish "$@"
