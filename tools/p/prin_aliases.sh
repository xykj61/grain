#!/usr/bin/env bash
# prin_aliases.sh -- outer-terminal shortcuts for %prin / Prin.
#
#   cd ~/grain && source tools/p/prin_aliases.sh
#   p / pm     matrix live view (twin ledgers + rishi workers)
#   pr         denser green rain
#   pl         bhakti / devoted accents
#   pt / pv    verse ticker (foundations + edu)
#   pw / pd    dual panel (needs tmux)
#   po         one matrix frame
#   pnib       git nib
#   phelp      help
#
# Watch a long agent loop from a second outer terminal while Cursor works:
#   source tools/p/prin_aliases.sh && pw
# Or two panes without tmux:
#   pane A: p
#   pane B: pt
#
# Live TTY path uses bash fixtures directly (rishi run captures stdout;
# interactive clear/refresh needs a real terminal).

GRAIN_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "${GRAIN_ROOT:-$HOME/grain}")"
_PRIN_M="$GRAIN_ROOT/tools/fixtures/prin_matrix.sh"
_PRIN_T="$GRAIN_ROOT/tools/fixtures/prin_ticker.sh"
_PRIN_D="$GRAIN_ROOT/tools/fixtures/prin_dual.sh"
_PRIN_X="$GRAIN_ROOT/tools/fixtures/prin_dispatch.sh"

alias prin='(cd "$GRAIN_ROOT" && bash tools/fixtures/prin_dispatch.sh)'
alias p='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" matrix)'
alias pm='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" matrix)'
alias pr='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" rain)'
alias pl='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" love)'
alias pt='(cd "$GRAIN_ROOT" && bash "$_PRIN_T" slide)'
alias pv='(cd "$GRAIN_ROOT" && bash "$_PRIN_T" slide)'
alias pw='(cd "$GRAIN_ROOT" && bash "$_PRIN_D" matrix)'
alias pd='(cd "$GRAIN_ROOT" && bash "$_PRIN_D" matrix)'
alias po='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" once)'
alias pnib='(cd "$GRAIN_ROOT" && git rev-parse --short=10 HEAD)'
alias phelp='(cd "$GRAIN_ROOT" && bash "$_PRIN_X" help)'

# Magical / devoted shorthand
alias p♥='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" love)'
alias 'p*'='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" rain)'
alias 'p::'='(cd "$GRAIN_ROOT" && bash "$_PRIN_D" matrix)'
alias 'p.'='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" once)'
alias px='(cd "$GRAIN_ROOT" && bash "$_PRIN_M" matrix)'

# Rishi entry (non-interactive: help - nib - once)
alias prinr='(cd "$GRAIN_ROOT" && rishi/bin/rishi run tools/gen/season/prin.rish)'

echo "Prin aliases seated from ${GRAIN_ROOT}"
echo "  p pm pr pl pt pv pw pd po pnib phelp prinr   ·   p♥ p* p:: p. px"
echo "Live watch: open a second terminal → source tools/p/prin_aliases.sh && pw"
