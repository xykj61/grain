#!/usr/bin/env sh
# lap_vocabulary_sweep.sh — word-boundary ring→lap on forward-facing prose only.
# Thin-ring testing vocabulary becomes thin edge. Frozen witness path basenames stay
# (slc2a_ring3_metal.rish, amber_first_ring.rish, additive-gate.rish).
# Run from repo root via: rishi/bin/rishi run tools/lap_vocabulary_sweep.rish
set -eu

DRY="${1:-}"

sweep_file() {
  f="$1"
  if [ -n "$DRY" ]; then
    if grep -qE '\bring\b|\bRing\b|\bthin ring\b|\bthin-ring\b|first-ring-goes-green|the-happy-zone-and-the-thin-ring' "$f" 2>/dev/null; then
      echo "WOULD_SWEEP $f"
    fi
    return 0
  fi
  before=$(cksum "$f" | awk '{print $1}')
  perl -i -pe '
    s/first-ring-goes-green/first-lap-goes-green/g;
    s/the-happy-zone-and-the-thin-ring/the-happy-zone-and-the-thin-edge/g;
    s/\bthin-ring\b/thin-edge/g;
    s/\bFirst Ring Goes Green\b/First Lap Goes Green/g;
    s/\bfirst ring goes green\b/first lap goes green/gi;
    s/\bthin integrated ring\b/thin integrated edge/gi;
    s/\bthin ring\b/thin edge/gi;
    s/\bthick ring\b/thick edge/gi;
    s/\bintegrated ring\b/integrated edge/gi;
    s/\bRing by ring\b/Lap by lap/gi;
    s/\bring by ring\b/lap by lap/gi;
    s/\bin-session ring\b/in-session rerun/gi;
    s/\bsession ring\b/session buffer/gi;
    s/\breturning ring\b/returning lap/gi;
    s/\bhygiene ring\b/hygiene lap/gi;
    s/\bdesign ring\b/design lap/gi;
    s/\breceipt ring\b/receipt lap/gi;
    s/\bapplication ring\b/application lap/gi;
    s/\bproduct ring\b/product lap/gi;
    s/\binfrastructure rings\b/infrastructure laps/gi;
    s/\bapplication rings\b/application laps/gi;
    s/\bharbor rings\b/harbor laps/gi;
    s/\bSLC rings\b/SLC laps/gi;
    s/\bthree SLC rings\b/three SLC laps/gi;
    s/\bconcept word like ring\b/concept word like lap/gi;
    s/\bbounded ring of descriptors\b/bounded descriptor queue/gi;
    s/\bRing one\b/Lap one/g;
    s/\bring one\b/lap one/gi;
    s/\bRing two\b/Lap two/g;
    s/\bring two\b/lap two/gi;
    s/\bRing three\b/Lap three/g;
    s/\bring three\b/lap three/gi;
    s/\bRing 3\b/Lap 3/g;
    s/\bRing 2\b/Lap 2/g;
    s/\bRing 1\b/Lap 1/g;
    s/\bring 3\b/lap 3/g;
    s/\bring 2\b/lap 2/g;
    s/\bring 1\b/lap 1/g;
    s/\bRings 1/Laps 1/g;
    s/\bRings 1–3\b/Laps 1–3/g;
    s/\bRings 1-3\b/Laps 1-3/g;
    s/\brings 1–3\b/laps 1–3/gi;
    s/\bfirst ring\b/first lap/gi;
    s/\bFirst ring\b/First lap/g;
    s/\bThe First Ring\b/The First Lap/g;
    s/\bthe first ring\b/the first lap/gi;
    s/\b### Ring\b/### Lap/g;
    s/\b## The First Ring\b/## The First Lap/g;
    s/\b## Why the Ring Stays Thin\b/## Why the Edge Stays Thin/g;
    s/\bTAME Order on the Day a Ring Closes\b/TAME Order on the Day a Lap Closes/g;
    s/\bThe Rare Resource and the Small Ring\b/The Rare Resource and the Small Edge/g;
    s/\bring-one\b/lap-one/gi;
    s/\bring green\b/lap green/gi;
    s/\bring closed\b/lap closed/gi;
    s/\bring closes\b/lap closes/gi;
    s/\bnext ring\b/next lap/gi;
    s/\blater rings\b/later laps/gi;
    s/\bevery ring\b/every lap/gi;
    s/\beach ring\b/each lap/gi;
    s/\bproduct rings\b/product laps/gi;
    s/\bSLC ring\b/SLC lap/gi;
    s/\bSLC Ring\b/SLC Lap/g;
    s/\bSLC-2a ring\b/SLC-2a lap/gi;
    s/\bSLC-2a Ring\b/SLC-2a Lap/g;
    s/\bAmber ring\b/Amber lap/gi;
    s/\bAmber Ring\b/Amber Lap/g;
    s/\bring-1\b/lap-1/gi;
    s/\bRing-1\b/Lap-1/g;
    s/\|\s*Ring\s*\|/| Lap |/g;
    s/\*\*Ring\*\*/**Lap**/g;
    s/\*\*Rings\*\*/**Laps**/g;
    s/\bRings\b/Laps/g;
    s/\brings\b/laps/g;
    s/\bRing\b/Lap/g;
    s/\bring\b/lap/g;
  ' "$f"
  after=$(cksum "$f" | awk '{print $1}')
  if [ "$before" != "$after" ]; then
    echo "SWEPT $f"
  fi
}

count=0
for f in \
  context/*.md context/specs/*.md \
  foundations/*.md \
  work-in-progress/*.md \
  active-designing/*.md active-designing/yonder/*.md \
  external-research/*.md \
  amber/README.md pond/README.md rishi/README.md manual/*.md manual/reference/*.md \
  linengrow/*.md linengrow/README.md \
  ORGANIZING.md CLAUDE.md SIMPLE_LOVABLE_COMPLETE.md \
  brushstroke/*.rye pond/apps/drawn_terminal.rye pond/apps/brushstroke/wayland_seed.rye \
  tools/parity.rish tools/slc2a_ring*.rish tools/amber_first_ring.rish \
  tools/designed_not_built_witness.rish \
  .claude/rules/*.md .cursor/rules/*.mdc
do
  case "$f" in
    */yonder/*|*/archive/*|*/session-logs/*|*/gratitude/*) continue ;;
  esac
  [ -f "$f" ] || continue
  sweep_file "$f"
  count=$((count + 1))
done

echo "LAP_VOCAB_SWEEP: scanned $count candidate paths"
