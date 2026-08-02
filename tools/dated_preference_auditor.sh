#!/bin/sh
# dated_preference_auditor.sh — thin wrapper → dated_amendment_audit.sh (e239).
# Kept so earlier seats that named this path still run. Canonical auditor:
#   sh tools/dated_amendment_audit.sh
exec sh "$(CDPATH= cd -- "$(dirname "$0")" && pwd)/dated_amendment_audit.sh" "$@"
