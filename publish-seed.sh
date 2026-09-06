#!/usr/bin/env sh
# publish-seed.sh -- project the public seed, prove it clean, and publish it to both doors.
#
# UNTRACKED AT THE ROOT BY DESIGN. `.gitignore` blanket-ignores `/*` and un-ignores named files, so
# this script never enters the field's history. When a clone lacks it, it is reconstructed from
# `.claude/rules/git-signing.md` and the guard's own greps -- which happened on `20260827`, and
# again on `20260905` after the Dallas pier was born without it. `tools/co/commit_message_guard_witness.rish`
# proves the reconstruction before it ships, and it is the authority on the one line that matters.
#
#   sh publish-seed.sh            # project, prove, commit -- and STOP, printing the push
#   sh publish-seed.sh --push     # the same, then force-push both doors
#
# THE BARE FORM CANNOT PUBLISH, and that is deliberate. The seed force-push is **custody gate %1**:
# it force-updates two public repositories and is irreversible. `construction/ITINERARY.md` says an
# autonomous agent stops there and surfaces, never crosses. A script whose bare invocation cannot
# cross a custody gate is the shape that law asks for; `--push` is the maintainer's explicit word,
# typed once, at the moment they mean it.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT"
[ -f construction/ITINERARY.md ] || { echo "publish-seed: $ROOT is not the field root" >&2; exit 2; }

DO_PUSH=no
case "${1:-}" in
  --push) DO_PUSH=yes ;;
  "") ;;
  *) echo "publish-seed: unknown argument: $1 (want --push, or nothing)" >&2; exit 2 ;;
esac

# --- 1. the .git is wiped FIRST, so nothing of a prior publish is in scope -----------------
#
# The publisher deletes and re-creates `seed/.git` on every run, which is why every arming below
# lives in this script rather than in a config a fresh init would inherit. It is wiped BEFORE the
# witness so the scan reads exactly the bytes that ship and nothing beside them -- learned when a
# leak scan refused a publish over a path that lived only in the git directory.
rm -rf seed/.git

# --- 2. project, then prove ----------------------------------------------------------------
#
# The projection is agent-doable and the push is not; that line is drawn in the card's own custody
# section. Both halves run here so a publish can never ship a projection nobody proved.
echo "publish-seed: projecting the seed from template-manifest.bron ..."
rishi/bin/rishi run tools/s/sow.rish || { echo "publish-seed: the projection refused -- nothing published" >&2; exit 1; }

echo "publish-seed: proving the seed clean ..."
rishi/bin/rishi run tools/s/sow_witness.rish || {
  echo "publish-seed: THE SEED IS NOT PROVABLY CLEAN -- nothing published, nothing initialised" >&2
  exit 1
}

# --- 3. arm the fresh repository -----------------------------------------------------------
#
# Every line here is armed in the script because step 1 wiped what a hand might have set.
#
# THE BRANCH IS NAMED, not inherited. `git init` takes its default branch from the host's config,
# which on this pier is `master`, while both doors serve `main` -- so a bare init produced a repo
# whose only branch the push could not find, and the dry run answered `src refspec main does not
# match any`. `-b main` where git is new enough, a rename where it is not, and the push below
# spells `HEAD:main` so the remote is right whatever the local branch is called.
git init -q -b main seed 2>/dev/null || { git init -q seed; git -C seed symbolic-ref HEAD refs/heads/main; }

# The one line tools/fixtures/c/commit_message_guard_scan.sh greps for. The wall that refuses a
# forbidden commit message lives in the field's tracked hooks, and a fresh seed/.git inherits none
# of it -- so the seed is pointed at the same hooks the field uses. There is no bypass: `--no-verify`
# is forbidden by the same rule, and a wall with a door beside it is a habit again.
git -C seed config core.hooksPath "$ROOT/tools/hooks"

# UNSIGNED ON PURPOSE, and this is the only place in the tree where signing is off. Signing the
# public seed with the maintainer's own key would cryptographically link the anonymous seed back to
# them, undoing the whole point of a depersonalised projection. Local to seed/ alone; the field's
# own commit.gpgsign is never touched.
git -C seed config commit.gpgsign false

# The anonymous, keyless identity. Renamed from `Grain OS` on `20260828` to match the living domain.
git -C seed config user.name  'grain-ww'
git -C seed config user.email 'grain-ww@users.noreply.github.com'

# Two doors, one seed. `grain-os/grain` and `grain-ww/grain` are peer names for a single projection,
# never two seeds, so both are force-updated from the same commit in the same run.
git -C seed remote add seed git@github.com:grain-os/grain.git 2>/dev/null || true
git -C seed remote add ww   git@github.com:grain-ww/grain.git   2>/dev/null || true

# --- 4. the single Option-B root commit ----------------------------------------------------
#
# One parentless commit carrying the whole projection: the public repository has no history to
# inherit, which is what keeps the field's own 2,900-commit lineage out of it. The subject is
# exactly `crashed-meteor` -- the one named exemption the mechanism-sentence wall recognises, since
# this body describes a repository rather than a change. Any other subject is refused by the hook,
# which is the wall doing its job rather than an obstacle.
git -C seed add -A
printf 'crashed-meteor\n' > "$ROOT/seed/.commit-msg-tmp"
git -C seed commit -q -F "$ROOT/seed/.commit-msg-tmp"
rm -f "$ROOT/seed/.commit-msg-tmp"

HEAD_SHA=$(git -C seed rev-parse HEAD)
FILES=$(git -C seed ls-tree -r HEAD --name-only | wc -l | tr -d ' ')
PARENTS=$(git -C seed rev-list --parents -1 HEAD | wc -w | tr -d ' ')

echo "publish-seed: committed $HEAD_SHA"
echo "publish-seed:   files=$FILES parents=$((PARENTS - 1)) signed=$(git -C seed log -1 --format='%G?')"
echo "publish-seed:   author=$(git -C seed log -1 --format='%an <%ae>')"

# --- 5. the transport, armed as an environment variable ------------------------------------
#
# The field routes SSH through its own repo-local config and a fresh seed/.git inherits none of it,
# so the push carries the config in the environment. An environment variable rather than
# `git -C seed config core.sshCommand` ON PURPOSE: a config value would write this host's absolute
# path -- username included -- into seed/.git/config, and nothing identity-bearing touches seed/ at
# all. The pushing account is transport only; the commit identity stays anonymous and keyless.
SSH_CONF="$ROOT/.git/ssh_config_jail"
[ -f "$SSH_CONF" ] || SSH_CONF="$ROOT/.git/ssh_config_urbit"

if [ "$DO_PUSH" != yes ]; then
  echo ""
  echo "publish-seed: STOPPING BEFORE THE PUSH -- custody gate %1, the maintainer's own hand."
  echo "publish-seed: the seed is projected, proven clean, and committed. To publish both doors:"
  echo ""
  echo "  sh publish-seed.sh --push"
  echo ""
  echo "publish-seed: or by hand, dry-run first:"
  echo "  cd $ROOT/seed"
  echo "  GIT_SSH_COMMAND='ssh -F $SSH_CONF' git push --dry-run --force seed HEAD:main"
  echo "  GIT_SSH_COMMAND='ssh -F $SSH_CONF' git push --force seed HEAD:main"
  echo "  GIT_SSH_COMMAND='ssh -F $SSH_CONF' git push --force ww main"
  exit 0
fi

[ -f "$SSH_CONF" ] || { echo "publish-seed: no repo-local ssh config at $SSH_CONF -- the push would use the host's" >&2; exit 1; }

echo "publish-seed: force-pushing both doors ..."
GIT_SSH_COMMAND="ssh -F $SSH_CONF" git -C seed push --force seed HEAD:main
GIT_SSH_COMMAND="ssh -F $SSH_CONF" git -C seed push --force ww   HEAD:main
echo "publish-seed: published $HEAD_SHA to grain-os/grain and grain-ww/grain"
