#!/usr/bin/env bash
# prin_dual.sh -- Matrix Prin + verse ticker side by side (tmux when present).

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

MATRIX_MODE="${1:-matrix}"
C=$'\033[36m'; B=$'\033[1m'; Z=$'\033[0m'

if command -v tmux >/dev/null 2>&1; then
  SESSION="grain-prin-$$"
  tmux new-session -d -s "$SESSION" "bash $ROOT/tools/fixtures/prin_matrix.sh $MATRIX_MODE"
  tmux split-window -h -t "$SESSION" "bash $ROOT/tools/fixtures/prin_ticker.sh slide"
  tmux select-pane -t "$SESSION:0.0"
  printf '%sPrin dual — attach:%s tmux attach -t %s\n' "$C$B" "$Z" "$SESSION"
  tmux attach -t "$SESSION"
  exit 0
fi

printf '%s(no tmux — sequential: matrix then ticker; install tmux for true split)%s\n' "$C" "$Z"
printf '  sudo apt install tmux   # or your host equivalent\n'
printf 'Falling back to matrix only. Run pt in another pane for the verse.\n'
exec bash "$ROOT/tools/fixtures/prin_matrix.sh" "$MATRIX_MODE"
