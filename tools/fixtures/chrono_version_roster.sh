# chrono_version_scan.sh — roster helper for chrono_version_scan.rish (glob expansion).
#!/usr/bin/env sh
set -eu
for f in \
  manual/*.md manual/reference/*.md manual/tutorials/*.md \
  context/*.md context/specs/*.md \
  active-designing/*.md \
  foundations/*.md \
  work-in-progress/*.md \
  external-research/*.md \
  pond/README.md linengrow/*.md \
  classical-vedic-astrology/*.md classical-vedic-astrology/studies/*.md \
  CLAUDE.md ORGANIZING.md
do
  [ -f "$f" ] || continue
  case "$f" in */yonder/*|*/archive/*) continue ;; esac
  echo "$f"
done
