#!/bin/sh
# sow_leak_scan.sh -- the negative that matters most: no maintainer identity
# string survives into the projected seed. Prints IDENT_CLEAN or IDENT_LEAK.
# The withheld log naturally names paths, so it is excluded from the scan.
set -eu
# Every maintainer identity string, prior name, family surname, club, personal
# handle, and contact identifier. Case-insensitive so a lowercase handle cannot
# slip a leak past a name meant with a capital. Expanded 20260810 (privacy).
# THE PSEUDONYM IS NOT ON THIS LIST, and that is deliberate. Two entries here read literally
# DJINN until 20260826: they were two different maintainer strings, and the 20260825 deep debride
# rewrote every occurrence of them in the whole history with `--replace-text` -- including inside
# this guard, whose entire content is a list of strings to look for. So the wall began hunting the
# public pseudonym, which is the one name the debride created precisely so it could be shipped,
# and 22 projected files failed a privacy check that had nothing to do with privacy. A blanket
# text rewrite has no exception for the tool that names the thing being rewritten; that is REDS
# %244.
#
# BOTH ENTRIES ARE BACK, SPELLED SO A REWRITE CANNOT REACH THEM. Two piers repaired this within
# hours of each other and reached different answers: this one removed the pair and leaned on
# `sow_scrub.sed` one layer up, while the macOS bench restored them with a bracketed character
# class -- the same technique the scrub itself was re-spelled with in the debride's own commit.
# The bracketed form is strictly stronger, because it keeps the wall catching what it was built to
# catch AND survives the next blanket rewrite, so it is the one kept. Do not flatten a bracket
# here into a plain letter: the bracket is what makes the entry outlive the name.
IDENT='Keaton|Kaeden|Livermore|Reyklah|Dunsford|Mayacama|xykj61|autoproject96|groupproject405|bandun|pacpet-solreb|keatonsiya|xnkg30|veganreyklah|cherry996|415.?915.?6666|npub1[a-z0-9]{40}|6Rb5E|AHs34|siyafund|bitscape|thebittradingcompany|xykj61atgmail|xykld2|xy96gen-z|S[a]bin|H[e]rtz|groupproject36|grain_energy|grain.energy|Grain Energy|Siya Fund|Vultr|Wenatchee|Sabey|Washoe County|Daylight DC-1|Tlon Corporation|0646 2132 D3E6|DBF8 5343 7A93|keatondun|keatonlivermore|teamcarry11|xwb122m|b122mnet|xnflor3|kaexvx9|kj3x39|b122m|construction3x39|vegancpa|veganaccountant|veganarchitect|veganbookkeeper|@gmail.com|Sealy|Zendex|CC8BA671|06462132|DxE|Direct Action Everywhere|wayne-hsiung|helen-atthowe|sarah-guo|kyler-murray|ariana-grande|kamala-harris|Pacific Time|Pacific time|66041JEA306288|bhagavan851c05a|kae3g|Brooke|Alexandra Livermore|Smart Access|maicmalamurr|Siya'
hits=$(grep -riIlE "$IDENT" seed 2>/dev/null | grep -vE '\.sow-(withheld|scrubbed|excluded)\.log' || true)
if [ -z "$hits" ]; then
  echo IDENT_CLEAN
else
  echo IDENT_LEAK
  echo "$hits"
fi
