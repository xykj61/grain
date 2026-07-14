#!/bin/sh
# aurora/run.sh — build an Aurora stage with Rye, and wake it in an emulator.
#
# Usage: aurora/run.sh [stage]     (stage defaults to "seed")
#
# Orchestration lives in tools/aurora_run.rish; this entry point keeps the
# stable path named in aurora/README.md and design docs.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/aurora_run.rish "$@"
