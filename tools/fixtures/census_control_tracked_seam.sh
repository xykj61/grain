#!/bin/sh
# Census control -- tracked-inventory seam (POSIX). git ls-files, never find.
# No backtick characters in patterns.
#
#   sh tools/fixtures/census_control_tracked_seam.sh
set -eu

MD_N=$(git ls-files '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
echo "duty3_tracked_md=${MD_N}"
case "$MD_N" in
  ''|0)
    echo "CONTROL=present"
    echo "verdict=misread"
    echo "detail=git_ls_files_md_empty"
    exit 1
    ;;
esac
CACHE_N=$(git ls-files 'glow/.cache/*' 2>/dev/null | wc -l | tr -d '[:space:]')
echo "duty3_glow_cache_tracked=${CACHE_N}"
if test "$CACHE_N" != "0"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=glow_cache_must_stay_untracked"
  exit 1
fi
echo "duty3=honored"
exit 0
