#!/bin/sh
# sow_project.sh — project the clean public seed from the private field.
#
# POSIX seam (cp / sed / git-ls-files) per ORGANIZING's .sh boundary; driven by
# tools/sow.rish, which reads template-manifest.bron. The mechanism named in
# external-research/20260808-045124 (Movement I), pinned to the seed/ target by
# 20260808-062500 (field + seed layout).
#
# Discipline (safety first, TAME order):
#   - `template` and `scrub` paths are candidates; `personal` is never iterated
#     and `sub_exclude` whole-paths are skipped, so neither can leak.
#   - The two submodules (gratitude, vendor) are withheld from the copy; the
#     seed re-adds them via .gitmodules rather than vendoring gigabytes.
#   - A file with no maintainer identity is copied verbatim.
#   - A file that names the maintainer is run through the name->role scrub
#     (tools/fixtures/sow_scrub.sed). If it comes out identity-clean it is
#     kept scrubbed; if it still carries a functional handle or a code literal
#     (xykj61, autoproject96, bandun, pacpet-solreb) it is WITHHELD for human
#     judgment. So the seed is clean by construction, not by trust.
#   - Only git-tracked files move (git ls-files), so build output under
#     gitignored bin/.cache dirs never reaches the seed.
#
# NOTE: the witness this feeds proves no identity STRING and no personal PATH
# survive. It does not prove a full editorial privacy review — that is the
# human read that gates M4 (publish), never this mechanism alone.
set -eu

MANIFEST="template-manifest.bron"
SEED="seed"
SCRUB="tools/fixtures/sow_scrub.sed"
# Maintainer identity: real names, the retired copyright name, the forge
# handles, and the real Azimuth points. One place; the witness reuses it.
IDENT='Keaton|Kaeden|Livermore|Reyklah|Dunsford|Mayacama|xykj61|autoproject96|bandun|pacpet-solreb|keatonsiya|xnkg30|veganreyklah|cherry996|415.?915.?6666|npub1[a-z0-9]{40}|6Rb5E|AHs34|siyafund|bitscape|thebittradingcompany|xykj61atgmail|xykld2|xy96gen-z|DJINN|DJINN'

[ -f "$MANIFEST" ] || { echo "sow: $MANIFEST missing" >&2; exit 1; }
[ -f "$SCRUB" ]    || { echo "sow: $SCRUB missing" >&2; exit 1; }

mkdir -p "$SEED"
# Clear prior projection content; preserve the seed repo's own .git if present.
find "$SEED" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} + 2>/dev/null || true
: > "$SEED/.sow-withheld.log"
: > "$SEED/.sow-scrubbed.log"
: > "$SEED/.sow-excluded.log"

# sub_exclude entries: either a whole path (e.g. linengrow) or a single file
# inside a scrub directory (e.g. a foundations biography essay). A file is
# excluded when it equals a sub_exclude entry or lives under one.
SUBEX=$(grep -E '^sub_exclude ' "$MANIFEST" | awk '{print $2}' || true)
# Candidate paths: template + scrub verdicts, minus the two submodules.
PATHS=$(grep -E '^(template|scrub) ' "$MANIFEST" | awk '{print $2}' | grep -vxE 'gratitude|vendor' || true)

is_subex() {
  for x in $SUBEX; do
    case "$1" in "$x"|"$x"/*) return 0;; esac
  done
  return 1
}

for p in $PATHS; do
  is_subex "$p" && continue   # whole-path exclusion (e.g. linengrow)
  for f in $(git ls-files -- "$p"); do
    [ -f "$f" ] || continue
    # File-granular exclusion — deliberate personal withhold inside a shared dir
    # (a foundations biography essay); the doctrine beside it still ships.
    if is_subex "$f"; then
      printf '%s\n' "$f" >> "$SEED/.sow-excluded.log"; continue
    fi
    dest="$SEED/$f"
    # Key-material guard — refuse anything shaped like a key or a fingerprint
    # roster, whatever its verdict. context/PUBKEYS.md is the canonical committed
    # fingerprint file and lives inside a scrub dir; a name-scrub cannot catch a
    # fingerprint, so this basename guard is what withholds it. PUBKEYS.template.md
    # (placeholders) does NOT match the exact `PUBKEYS.md` glob and ships.
    case $(basename "$f") in
      PUBKEYS.md|keys_*|*.pem|*.key|*.asc|*.gpg|*.sec|*.secret)
        printf '%s\n' "$f" >> "$SEED/.sow-withheld.log"; continue;;
    esac
    # Embedded key material — a real pubkey or PGP block in any file, whatever
    # its name. Withheld for the M3 pass, which swaps real keys for placeholders.
    if grep -IqE 'ssh-(ed25519|rsa) AAAA|BEGIN (OPENSSH|PGP|RSA|EC) (PRIVATE|PUBLIC) KEY' "$f" 2>/dev/null; then
      printf '%s\n' "$f" >> "$SEED/.sow-withheld.log"; continue
    fi
    if grep -Iqi -E "$IDENT" "$f" 2>/dev/null; then
      mkdir -p "$(dirname "$dest")"
      sed -f "$SCRUB" "$f" > "$dest"
      if grep -Iqi -E "$IDENT" "$dest" 2>/dev/null; then
        rm -f "$dest"
        printf '%s\n' "$f" >> "$SEED/.sow-withheld.log"
      else
        printf '%s\n' "$f" >> "$SEED/.sow-scrubbed.log"
      fi
    else
      mkdir -p "$(dirname "$dest")"
      cp -a "$f" "$dest"
    fi
  done
done

COPIED=$(find "$SEED" -type f ! -name '.sow-withheld.log' ! -name '.sow-scrubbed.log' | wc -l | tr -d ' ')
SCRUBBED=$(grep -c '' "$SEED/.sow-scrubbed.log" 2>/dev/null || echo 0)
WITHHELD=$(grep -c '' "$SEED/.sow-withheld.log" 2>/dev/null || echo 0)
echo "SOW_OK copied=$COPIED scrubbed=$SCRUBBED withheld=$WITHHELD"
