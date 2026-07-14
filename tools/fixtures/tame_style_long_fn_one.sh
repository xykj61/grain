#!/bin/sh
# tame_style_long_fn_one.sh — >70-line fn ledger for one .rye file (awk seam).
f="$1"
awk -v F="$f" '
    /^( *)?(pub )?fn /{ if (infn && n > 70) printf "  %s: %s = %d lines\n", F, name, n;
        infn = 1; n = 0; name = $0; sub(/\(.*/, "", name); sub(/.*fn /, "", name) }
    infn { n++ }
    /^}$|^    }$/{ if (infn && n > 70) printf "  %s: %s = %d lines\n", F, name, n; infn = 0 }
' "$f" 2>/dev/null
