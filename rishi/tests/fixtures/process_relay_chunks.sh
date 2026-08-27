#!/bin/sh
# Deterministic split-stream child for bounded live-relay controls.

printf '%s\n' 'relay stdout one'
printf '%s\n' 'relay stderr one' >&2
printf '%s\n' 'relay stdout two'
printf '%s\n' 'relay stderr two' >&2
exit 7
