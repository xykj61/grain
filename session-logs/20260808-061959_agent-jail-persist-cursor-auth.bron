format session-log-v1
stamp 20260808.061959
editor Cursor
model Cursor Grok 4.5 300k High Fast
voice Riyo
host NixOS 26.05 x86_64 cloud pier (Vultr SEA) — Eastern (EDT) time convention
title agent-jail persists cursor-agent OAuth auth.json
prompt the resume worked, but we have to log in each time via browser link. is that normal?
think not the steady state — traced cursor-agent status on host (logged in) vs jail maps
think token lives at ~/.config/cursor/auth.json; agent-jail only mapped ~/.cursor → .cursor-agent-state, so private-home tmpfs dropped OAuth each exit
obs map .cursor-agent-state/xdg-config → ~/.config/cursor; one-time seed from host auth when durable store empty; seeded now
obs dry-run GREEN shows the config bind; refuse silent fall-through when AIJAIL_BIN is set but missing (nix profile link flapped after rebuild)
obs nested live bwrap still Operation not permitted inside this Cursor sandbox — host tmux verifies whoami without re-login
file tools/agent-jail.sh CURSOR_CONFIG_STATE map + seed + AIJAIL_BIN missing refuse
file tools/agent_jail_witness.sh assert .config/cursor in dry-run
file nixos-guide/20260808-041912_3-cli-agents-in-ai-jail.md auth table + not-steady-state note
file context/specs/enclosure-editors.md · tools/enclosure.conf.example xdg-config note
recommend keep-going from host tmux — ./tools/agent-jail.sh agent status should stay logged in without browser
