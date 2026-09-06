#!/bin/sh
# publish_template_scan.sh -- the shipped publisher names nobody and no host.
#
# WHY. `publish-seed.template.sh` is the one file this tree ships that a newcomer RUNS against
# their own forge. Its whole value is that the five things which differ between one publisher and
# the next stand as stubs rather than as this field's answers -- and the failure mode is quiet: a
# leftover literal reads as a working default, so a reader fills four stubs, leaves the fifth, and
# pushes a projection to somebody else's repository.
#
# TWO READINGS, and each is a different fault.
#   leaked  -- a literal this field owns survives in the template: a remote, an identity, the root
#              subject, a host path, or the maintainer's name. Gated at zero.
#   orphan  -- a stub in the script with no matching field in GLOW_PROFILE.template.kyri. The
#              template's promise is that an agent can fill it FROM the profile, and a stub the
#              profile cannot answer breaks that promise silently. Gated at zero.
#
#   sh tools/fixtures/p/publish_template_scan.sh
#
# Prints `stubs=N fields=N leaked=N orphan=N`. Both gates read zero.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

TPL=${PUBLISH_TEMPLATE:-publish-seed.template.sh}
PROFILE=${PUBLISH_PROFILE:-GLOW_PROFILE.template.kyri}

[ -f "$TPL" ] || { echo "refused: no template at $TPL"; exit 2; }
[ -f "$PROFILE" ] || { echo "refused: no profile at $PROFILE"; exit 2; }

# The literals this field owns. Each is spelled here rather than derived, because the point is to
# name what must NOT travel -- and a derivation would read them out of the very file being checked.
leaked=0
for lit in 'grain-os/grain' 'grain-ww/grain' 'grain-ww@users' 'crashed-meteor' 'xykj61' 'groupproject405' 'Keaton' 'Dunsford' '/home/keeper'; do
  if grep -qF "$lit" "$TPL"; then
    echo "leaked: $lit"
    leaked=$((leaked + 1))
  fi
done

# A stub is a shell assignment whose name begins SEED_ and whose value is quoted. The profile field
# is the same name lowercased. One for one, so an agent reads one and writes the other.
stubs=0
orphan=0
for name in $(grep -oE '^SEED_[A-Z_]+=' "$TPL" | sed 's/=$//' | sort -u); do
  stubs=$((stubs + 1))
  field=$(printf '%s' "$name" | tr 'A-Z' 'a-z')
  grep -qE "^$field( |\$)" "$PROFILE" || { echo "orphan: $name has no $field in $PROFILE"; orphan=$((orphan + 1)); }
done
fields=$(grep -cE '^seed_[a-z_]+( |$)' "$PROFILE" || true)

echo "stubs=$stubs"
echo "fields=$fields"
echo "leaked=$leaked"
echo "orphan=$orphan"
