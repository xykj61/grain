#!/bin/sh
# waymark_registry_verify.sh -- prove the sealed waymark registry.
# Prints SEAL_OK, DERIVE_OK <n>, and finally REGISTRY_GREEN; exits non-zero on any
# failure. Invoked by tools/waymark_registry_witness.rish. Self-contained: resolves
# openssl, regenerates the pinned corpus, checks the corpus digest, verifies the
# SHA3-512 seal over the sealed body, and re-derives every corpus-drawn row.
set -eu

REG=crux/waymark-registry.bron
CORP=tools/.cache/waymark/corpus.txt
FIX=tools/fixtures/flw-four-letter.txt

[ -f "$REG" ] || { echo "REG_MISSING"; exit 2; }
# SHA3-512 from this tree's own Keccak, not from an openssl the host may or may not carry. The
# seal and every re-derived mark below are unchanged, because the algorithm is unchanged.
SHA3="$(CDPATH= cd "$(dirname "$0")" && pwd)/sha3.sh"

sh tools/fixtures/waymark_corpus_extract.sh "$FIX" "$CORP" >/dev/null 2>&1 || { echo "CORPUS_FAIL"; exit 2; }
SIZE=$(wc -l < "$CORP" | tr -d ' ')

# 1) corpus digest must match the registry's recorded pin
DIG=$(sh "$SHA3" 512 "$CORP")
REGDIG=$(grep '^corpus_digest ' "$REG" | awk '{print $2}')
[ "$DIG" = "$REGDIG" ] || { echo "DIGEST_FAIL"; exit 1; }

# 2) seal: SHA3-512 of the sealed body (rows after the marker) must equal `seal`
awk '/^# ---- sealed body ----/{f=1;next} f' "$REG" > /tmp/wreg_body.txt
COMP=$(sh "$SHA3" 512 /tmp/wreg_body.txt)
SEAL=$(grep '^seal ' "$REG" | awk '{print $2}')
[ "$COMP" = "$SEAL" ] || { echo "SEAL_FAIL want $SEAL got $COMP"; exit 1; }
echo "SEAL_OK"

# 3) re-derive every corpus row (skip hand-seated)
n=0; bad=0
while IFS= read -r line; do
  case "$line" in "mark "*) : ;; *) continue ;; esac
  st=$(printf '%s' "$line" | sed -n 's/.*| status \([a-z-]*\).*/\1/p')
  [ "$st" = "hand-seated" ] && continue
  mk=$(printf '%s' "$line" | sed -n 's/^mark \([A-Z][A-Z][A-Z][A-Z]\) .*/\1/p')
  inp=$(printf '%s' "$line" | sed -n 's/.*| input \([a-z0-9-]*\) |.*/\1/p')
  idx=$(printf '%s' "$line" | sed -n 's/.*| index \([0-9]*\) |.*/\1/p')
  H=$(printf '%s' "$inp" | sh "$SHA3" 512 - | cut -c1-8)
  D=$(printf '%d' 0x"$H")
  I=$(( D % SIZE + 1 ))
  W=$(awk -v k="$I" 'NR==k' "$CORP")
  n=$((n+1))
  if [ "$W" != "$mk" ] || [ "$I" != "$idx" ]; then echo "DERIVE_FAIL $mk want $idx/$mk got $I/$W"; bad=$((bad+1)); fi
done < "$REG"
[ "$bad" = 0 ] || exit 1
echo "DERIVE_OK $n"
echo "REGISTRY_GREEN"
