#!/bin/sh
# nixos/infuse.sh -- compose the host config from its template and this pier's own values.
#
#   sh nixos/infuse.sh            # write the composed config to stdout
#   sh nixos/infuse.sh --check    # compare the composition against /etc/nixos, say nothing else
#   sh nixos/infuse.sh --install  # compose, then copy out and rebuild
#
# SINGLE-STRANDED SAMENESS. There is ONE host configuration, and it has two names:
# `configuration.nix` is that configuration written as a template, and the live machine's file is
# the same configuration with this pier's values infused. The second is DERIVED from the first, so
# neither is a copy of the other and there is no pair to keep in agreement.
#
# WHY A TEMPLATE RATHER THAN A SCRUB. The elder plan shipped the real file through a `sed` that
# replaced key material at publish time. That works until the day a new personal value arrives in a
# shape the scrub does not match, and then it ships. A template holds no personal value at any
# moment, so there is nothing to catch on the way out -- the difference between a wall and a filter.
#
# THE DIRECTION IS THE TREE'S (`.claude/rules/declared-host-config.md`): the tree is written, the
# machine receives a copy. `--install` runs that direction and refuses to run it backwards.
set -eu

here=$(cd "$(dirname "$0")" && pwd -P)
tmpl="$here/configuration.nix"
local_file="${GRAIN_NIXOS_LOCAL:-$here/local.bron}"
live=${GRAIN_NIXOS_LIVE:-/etc/nixos/configuration.nix}

[ -f "$tmpl" ] || { echo "infuse: no template at $tmpl" >&2; exit 2; }

compose() {
  if [ -f "$local_file" ]; then
    # Each `NAME value` row replaces its placeholder. A row absent from the file leaves its
    # placeholder standing, which is visible in the output rather than silently empty -- a newcomer
    # who has written no local file yet SEES `GRAIN_HOST_KEY_1` and knows what to fill.
    sed_args=""
    while read -r name value; do
      case "$name" in ''|\#*|format) continue ;; esac
      [ -n "$value" ] || continue
      sed_args="$sed_args -e s|$name|$value|g"
    done < "$local_file"
    # shellcheck disable=SC2086
    sed $sed_args "$tmpl"
  else
    cat "$tmpl"
  fi
}

case "${1:---write}" in
  --check)
    if [ ! -f "$live" ]; then echo "infuse: no live file at $live"; exit 1; fi
    if compose | diff -q - "$live" >/dev/null 2>&1; then
      echo "infuse: the composition matches $live"
    else
      echo "infuse: the composition differs from $live"
      compose | diff - "$live" | head -20
      exit 1
    fi
    ;;
  --install)
    tmp=$(mktemp)
    compose > "$tmp"
    sudo cp "$tmp" "$live"
    rm -f "$tmp"
    echo "infuse: wrote $live -- now run: sudo nixos-rebuild switch"
    ;;
  *)
    compose
    ;;
esac
