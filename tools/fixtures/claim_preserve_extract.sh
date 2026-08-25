#!/bin/sh
# claim_preserve_extract.sh -- emit sorted unique claim tokens from a file.
#
# Token classes:
#   NUM     -- integers and decimals
#   HEX     -- hex digests (≥8 hex chars, optional 0x)
#   FP      -- OpenPGP-ish fingerprint clumps (4+ hex groups)
#   PATH    -- repo-relative or rooted paths with a slash and extension-ish segment
#   STAMP   -- YYYYMMDD.HHMMSS or YYYYMMDD-HHMMSS
#   PROPER  -- Capitalized proper nouns (ASCII), length ≥2, not all-caps acronyms ≤3
#
# Usage: sh tools/fixtures/claim_preserve_extract.sh <path>
# stdout: one token per line, sorted unique, prefixed with CLASS:
set -eu

path=${1:?"usage: claim_preserve_extract.sh <path>"}
[ -f "$path" ] || { echo "missing $path" >&2; exit 1; }

# perl, not python -- this pier has no python3 on PATH (Python -> Rishi molt 20260809).
# Perl's regex engine matches the elder Python `re` semantics token-for-token here.
perl -CSD -0777 -ne '
    my %t;
    while (/\b\d{8}\.\d{6}\b/g) { $t{"STAMP:$&"}=1 }
    while (/\b\d{8}-\d{6}\b/g)  { $t{"STAMP:$&"}=1 }
    while (/\b(?:0x)?[0-9a-fA-F]{8,}\b/g) {
        my $g=$&; (my $s=$g)=~s/[.-]//g;
        next if $s=~/^\d{8}\d{6}$/;
        $t{"HEX:".lc($g)}=1;
    }
    while (/\b(?:[0-9A-F]{4}\s+){3,}[0-9A-F]{4}\b/g) { my $g=$&; $g=~s/\s+/ /g; $t{"FP:".uc($g)}=1 }
    while (/\b\d+(?:\.\d+)?\b/g) { my $g=$&; next if (length($g)==8 && $g=~/^\d+$/); $t{"NUM:$g"}=1 }
    while (/(?<![A-Za-z0-9_])(?:\.\.\/)?(?:context|tools|counsel|foundations|waymarks|linengrow|session-logs|work-in-progress|docs|glow|rye|rishi|keys|vendor|gratitude|active-designing|external-research)\/[A-Za-z0-9_.\/+*-]+/g) { $t{"PATH:$&"}=1 }
    my %skip = map {$_=>1} qw(Language Status Stamp Voice Style Bound Room Counsel Related Ground May And The This That With From Into Over Under After Before Every Each When Where What How Why For Our Your);
    while (/\b[A-Z][a-z]{1,}(?:\s+[A-Z][a-z]{1,}){0,3}\b/g) { my $g=$&; next if $skip{$g}; $t{"PROPER:$g"}=1 }
    print "$_\n" for sort keys %t;
' "$path"
