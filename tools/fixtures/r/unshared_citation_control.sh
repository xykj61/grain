#!/bin/sh
# unshared_citation_control.sh -- the unshared-citation census proven in a pen.
#
# Every refusal is planted and then LIFTED, because a gate proven only in the passing direction
# cannot be told from a gate that never fires.
#
#   sh tools/fixtures/r/unshared_citation_control.sh
#
# Prints `pass=N fail=N`. Bounded: 10 cases, one pen holding a stub spine.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
real="$root/tools/fixtures/r/unshared_citation_scan.sh"
pen=${TMPDIR:-/tmp}/unshared-cite-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures/r" "$pen/construction/archive" "$pen/context/date/20260101"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cp "$real" "$pen/tools/fixtures/r/unshared_citation_scan.sh"

# A STUB SPINE, so the pen never reaches a network and the shared boundary is a number this control
# chooses. The real scan reads the real spine; here the reading under test is what it does WITH it.
cat > "$pen/tools/fixtures/r/reds_spine_derive_scan.sh" <<'SPINE'
#!/bin/sh
[ "${SPINE_MUTE:-0}" = 1 ] && exit 0
echo "shared_max=${SPINE_SHARED:-500}"
SPINE
chmod +x "$pen/tools/fixtures/r/reds_spine_derive_scan.sh"

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

ask() { ( cd "$pen" && SPINE_SHARED="${SPINE_SHARED:-500}" sh tools/fixtures/r/unshared_citation_scan.sh "${1:-count}" 2>&1 ); }

# A living file citing a number above the shared boundary is the fault this census names.
printf 'The repair is booked as %%505 and stands.\n' > context/living.md
git add -A >/dev/null; git commit -qm seed
out=$(ask list)
check "an unshared citation is counted"   yes "$(has "$out" 'unshared_citations=1')"
check "and it is named with the boundary" yes "$(has "$out" 'bound only up to %500')"

# A number the spine has already bound is an ordinary citation.
printf 'The elder fault is %%499 and closed.\n' > context/shared.md
git add -A >/dev/null; git commit -qm shared
out=$(ask)
check "a shared citation is free"         yes "$(has "$out" 'unshared_citations=1')"

# The ledger ASSIGNS a number; a row header is not a citation of one.
printf '**REDS %%505 (`20260906.000000`) -- a fault.** OPEN.\n' > construction/REDS.md
printf 'Row %%505 folded here.\n' > construction/archive/shelf.md
git add -A >/dev/null; git commit -qm ledger
out=$(ask)
check "the ledger is not a citer"         yes "$(has "$out" 'unshared_citations=1')"

# Dated testimony records what the number was when it was written.
printf 'Booked %%506 this lap.\n' > context/date/20260101/20260101-120000_note.md
printf 'Booked %%507 this lap.\n' > context/20260101-130000_stamped.md
git add -A >/dev/null; git commit -qm dated
out=$(ask)
check "a dated room is read past"         yes "$(has "$out" 'unshared_citations=1')"
check "a stamped basename is read past"   yes "$(has "$out" 'unshared_citations=1')"

# A hex colour is not a row number, whatever its first three digits say.
printf 'a very dark red %%200000 reads black\n' > context/colour.md
git add -A >/dev/null; git commit -qm colour
out=$(ask)
check "a five-digit run is not a row"     yes "$(has "$out" 'unshared_citations=1')"

# Lifting the one unshared citation clears the count.
rm context/living.md
git add -A >/dev/null; git commit -qm lift
out=$(ask)
check "lifting it returns zero"           yes "$(has "$out" 'unshared_citations=0')"
check "and no file is affected"           yes "$(has "$out" 'files_affected=0')"

# A spine that cannot answer refuses rather than calling everything shared, or everything unshared.
out=$( ( cd "$pen" && SPINE_MUTE=1 sh tools/fixtures/r/unshared_citation_scan.sh 2>&1 || true ) )
check "a mute spine refuses"              yes "$(has "$out" 'refused: the anointed spine')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
