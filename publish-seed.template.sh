#!/usr/bin/env sh
# publish-seed.template.sh -- project YOUR public seed, prove it clean, and publish it.
#
# WHY THIS FILE SHIPS AND ITS SIBLING DOES NOT. This tree's own publisher, `publish-seed.sh`, is
# `personal` in `template-manifest.bron` by law: the field is the seed's PROJECTOR, never its
# carrier. So a newcomer who clones the public seed inherits every room except the one that would
# let them publish their own. This template is that room, with the maintainer's five literals
# standing as fillable stubs.
#
#   cp publish-seed.template.sh publish-seed.sh   # then fill the five FILL_ME values below
#   sh publish-seed.sh                            # project, prove, commit -- and STOP
#   sh publish-seed.sh --push                     # the same, then force-push
#
# THE BARE FORM CANNOT PUBLISH, and keep it that way. A force-push to a public repository is
# irreversible; `--push` is your own explicit word, typed once, at the moment you mean it.
#
# FILLING IT FROM YOUR PROFILE. Every stub below has a matching field in `GLOW_PROFILE.bron` (copy
# `GLOW_PROFILE.template.kyri` and fill it). An agent asked to "fill my publisher from my profile"
# reads those five fields and writes these five lines, which is the whole reason the field names
# match the shell names one for one.
set -eu

# ---- THE FIVE STUBS -----------------------------------------------------------------------
#
# SEED_REMOTE_PRIMARY / SEED_REMOTE_SECOND -- the public door or doors your seed is pushed to.
#   Profile fields: seed_remote_primary, seed_remote_second. Leave SECOND empty for one door.
#   This tree publishes two peer names for a single projection, never two seeds.
SEED_REMOTE_PRIMARY='FILL_ME:git@github.com:your-handle/your-seed.git'
SEED_REMOTE_SECOND=''

# SEED_IDENTITY_NAME / SEED_IDENTITY_EMAIL -- the identity the seed commit is authored as.
#   Profile fields: seed_identity_name, seed_identity_email.
#   MAKE IT KEYLESS AND ANONYMOUS ON PURPOSE. Signing a depersonalized seed with your own key
#   cryptographically links it back to you, undoing the projection. A GitHub noreply address is
#   the ordinary shape: <handle>@users.noreply.github.com.
SEED_IDENTITY_NAME='FILL_ME:your-seed-identity'
SEED_IDENTITY_EMAIL='FILL_ME:your-seed-identity@users.noreply.github.com'

# SEED_ROOT_SUBJECT -- the subject of the seed's single root commit.
#   Profile field: seed_root_subject.
#   IF YOU RUN A COMMIT-MESSAGE WALL, THIS IS THE WORD IT MUST EXEMPT. A root commit describes a
#   repository rather than a change, so a wall asking every body to name a mechanism will refuse it
#   forever otherwise. Pick one word, spell it in the wall's exemption, and never reuse it.
SEED_ROOT_SUBJECT='FILL_ME:one-word-root-subject'

# ---- the rest is the same five steps, and needs no editing --------------------------------
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT"

case "${1:-}" in
  --push) DO_PUSH=yes ;;
  "") DO_PUSH=no ;;
  *) echo "publish-seed: unknown argument: $1 (want --push, or nothing)" >&2; exit 2 ;;
esac

# A stub left unfilled refuses BEFORE anything is projected, because a half-filled publisher that
# reaches the push is the one failure mode this template exists to prevent.
for v in "$SEED_REMOTE_PRIMARY" "$SEED_IDENTITY_NAME" "$SEED_IDENTITY_EMAIL" "$SEED_ROOT_SUBJECT"; do
  case "$v" in
    FILL_ME:*|'') echo "publish-seed: a stub is unfilled -- read the five FILL_ME values at the head of this file" >&2; exit 2 ;;
  esac
done

# 1. the .git is wiped FIRST, so nothing of a prior publish is in scope, and so every arming below
# lives in this script rather than in a config a fresh init would inherit.
rm -rf seed/.git

# 2. project, then prove. The projection is ordinary work; the push is not.
rishi/bin/rishi run tools/s/sow.rish || { echo "publish-seed: the projection refused" >&2; exit 1; }
rishi/bin/rishi run tools/s/sow_witness.rish || {
  echo "publish-seed: THE SEED IS NOT PROVABLY CLEAN -- nothing published" >&2; exit 1; }

# 3. arm the fresh repository. The branch is NAMED rather than inherited: `git init` takes its
# default from the host's config, and a bare init on a host defaulting to `master` produces a repo
# whose only branch the push cannot find.
git init -q -b main seed 2>/dev/null || { git init -q seed; git -C seed symbolic-ref HEAD refs/heads/main; }
git -C seed config core.hooksPath "$ROOT/tools/hooks"
git -C seed config commit.gpgsign false
git -C seed config user.name  "$SEED_IDENTITY_NAME"
git -C seed config user.email "$SEED_IDENTITY_EMAIL"
git -C seed remote add seed "$SEED_REMOTE_PRIMARY" 2>/dev/null || true
[ -n "$SEED_REMOTE_SECOND" ] && git -C seed remote add second "$SEED_REMOTE_SECOND" 2>/dev/null || true

# 4. one parentless commit carrying the whole projection, so the public repository inherits no
# history from the private field.
git -C seed add -A
printf '%s\n' "$SEED_ROOT_SUBJECT" > "$ROOT/seed/.commit-msg-tmp"
git -C seed commit -q -F "$ROOT/seed/.commit-msg-tmp"
rm -f "$ROOT/seed/.commit-msg-tmp"

HEAD_SHA=$(git -C seed rev-parse HEAD)
echo "publish-seed: committed $HEAD_SHA"
echo "publish-seed:   files=$(git -C seed ls-tree -r HEAD --name-only | wc -l | tr -d ' ')"
echo "publish-seed:   author=$(git -C seed log -1 --format='%an <%ae>')"

# 5. the transport. If your field routes SSH through a repo-local config, a fresh seed/.git
# inherits none of it, so the push carries it in the ENVIRONMENT rather than in seed config -- a
# config value would write this host's absolute path, username included, into seed/.git/config.
SSH_CONF="$ROOT/.git/ssh_config_jail"
SSH_ENV=""
[ -f "$SSH_CONF" ] && SSH_ENV="ssh -F $SSH_CONF"

if [ "$DO_PUSH" != yes ]; then
  echo ""
  echo "publish-seed: STOPPING BEFORE THE PUSH -- your own hand. To publish:"
  echo "  sh publish-seed.sh --push"
  exit 0
fi

if [ -n "$SSH_ENV" ]; then
  GIT_SSH_COMMAND="$SSH_ENV" git -C seed push --force seed HEAD:main
  [ -n "$SEED_REMOTE_SECOND" ] && GIT_SSH_COMMAND="$SSH_ENV" git -C seed push --force second HEAD:main
else
  git -C seed push --force seed HEAD:main
  [ -n "$SEED_REMOTE_SECOND" ] && git -C seed push --force second HEAD:main
fi
echo "publish-seed: published $HEAD_SHA"
