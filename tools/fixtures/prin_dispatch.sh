#!/usr/bin/env bash
# prin_dispatch.sh — single argv router for tools/prin.rish

set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
mode="${1:-matrix}"

case "$mode" in
  help|-h|--help)
    cat <<'EOF'
Prin (%prin) — Grain matrix printer · live outer-terminal view of loops & parity

  matrix | p | pm     twin ledgers + live rishi workers (refreshing)
  rain   | pr         denser green rain between frames
  love   | pl | p♥    devoted / bhakti accents
  once   | po | p.    one frame, then exit
  ticker | pt | pv    foundations + edu verse slideshow
  scroll              verse as a single-line ticker
  dual   | pw | pd    matrix | verse side-by-side (tmux)
  nib    | pnib       print git nib
  scope  | outer | inner   print seated season scope (six nests · tools/gen/season/prin_scope.rish)
  sundial| psun       recursion-prompt confidence 0–100 (red→green)
  ranking| rota       the 27-slot rankings rota tended round by round (context/rankings.kyri)

Round open:
  prin ranking        # the emphasis rota — the one living thing each round tends
  itinerary.rish <r>  # a specific round's whole day (coords · theme · ranking · carry)

Outer terminal:
  cd ~/grain && source tools/prin_aliases.sh
  pw                  # dual live view while an agent loop runs
  # or two panes:  p   |   pt
  prin scope          # outer pause · inner season standing
  prin sundial        # prompt fidelity percent · color band

Env: PRIN_INTERVAL=1  PRIN_TICKER_INTERVAL=8
EOF
    ;;
  nib|pnib) git rev-parse --short=10 HEAD ;;
  scope|outer|inner) exec "$ROOT/rishi/bin/rishi" run tools/gen/season/prin_scope.rish ;;
  sundial|psun) exec sh tools/fixtures/sundial.sh ;;
  ranking|rank|rankings|rota)
    echo "Rankings — the 27-slot emphasis rota; round N tends rankings[N mod 27]:"
    grep -E '^rank ' context/rankings.kyri
    echo ""
    echo "This round tends the slot for its round index; for a round's whole day: rishi/bin/rishi run tools/gen/season/itinerary.rish <r>"
    ;;
  ticker|pt|pv|slide) exec bash tools/fixtures/prin_ticker.sh slide ;;
  scroll) exec bash tools/fixtures/prin_ticker.sh scroll ;;
  dual|watch|pw|pd|p::) exec bash tools/fixtures/prin_dual.sh matrix ;;
  rain|pr|p\*) exec bash tools/fixtures/prin_matrix.sh rain ;;
  love|pl|p♥) exec bash tools/fixtures/prin_matrix.sh love ;;
  once|po|p.) exec bash tools/fixtures/prin_matrix.sh once ;;
  matrix|p|pm|px|*) exec bash tools/fixtures/prin_matrix.sh matrix ;;
esac
