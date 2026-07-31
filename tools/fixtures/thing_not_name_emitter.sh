#!/bin/sh
# Planted emitter for thing-not-name law.
# Filename carries no "demo_meter" token. The THING is the emitted key.
#
#   sh tools/fixtures/thing_not_name_emitter.sh
#
# Law: look for the thing, not for the name of the thing.
set -eu
echo "emitter=thing_not_name"
echo "demo_meter=7"
echo "verdict=ok"
