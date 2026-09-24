#!/bin/sh
# Hold the six stages, then list the store without naming a stage path.

set -eu

cd "$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)"
sh tools/fixtures/a/aurora_stage_store_lasting.sh >/dev/null
if grep -q 'aurora/src' tools/fixtures/a/aurora_stage_store_list.sh; then
  exit 1
fi
sh tools/fixtures/a/aurora_stage_store_list.sh
