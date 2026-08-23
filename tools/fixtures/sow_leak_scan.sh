#!/bin/sh
# sow_leak_scan.sh — the negative that matters most: no maintainer identity
# string survives into the projected seed. Prints IDENT_CLEAN or IDENT_LEAK.
# The withheld log naturally names paths, so it is excluded from the scan.
set -eu
# Every maintainer identity string, prior name, family surname, club, personal
# handle, and contact identifier. Case-insensitive so a lowercase handle cannot
# slip a leak past a name meant with a capital. Expanded 20260810 (privacy).
IDENT='Keaton|Kaeden|Livermore|Reyklah|Dunsford|Mayacama|xykj61|autoproject96|groupproject405|bandun|pacpet-solreb|keatonsiya|xnkg30|veganreyklah|cherry996|415.?915.?6666|npub1[a-z0-9]{40}|6Rb5E|AHs34|siyafund|bitscape|thebittradingcompany|xykj61atgmail|xykld2|xy96gen-z|DJINN|DJINN|groupproject36|grain_energy|grain.energy|Grain Energy|Siya Fund|Vultr|Wenatchee|Sabey|Washoe County|Daylight DC-1|Tlon Corporation|0646 2132 D3E6|DBF8 5343 7A93|keatondun|keatonlivermore|teamcarry11|xwb122m|b122mnet|xnflor3|kaexvx9|kj3x39|b122m|construction3x39|vegancpa|veganaccountant|veganarchitect|veganbookkeeper|@gmail.com|Sealy|Zendex|CC8BA671|06462132|DxE|Direct Action Everywhere|wayne-hsiung|helen-atthowe|sarah-guo|kyler-murray|ariana-grande|kamala-harris|Pacific Time|Pacific time|66041JEA306288|bhagavan851c05a|kae3g|Brooke|Alexandra Livermore|Smart Access|maicmalamurr'
hits=$(grep -riIlE "$IDENT" seed 2>/dev/null | grep -vE '\.sow-(withheld|scrubbed|excluded)\.log' || true)
if [ -z "$hits" ]; then
  echo IDENT_CLEAN
else
  echo IDENT_LEAK
  echo "$hits"
fi
