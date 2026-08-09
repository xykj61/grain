# The NixOS Guides — Standing and Keeping a Declared Pier

*A home for the cloud pier's documentation, seated by Keaton's word. Each guide is one witnessed road, numbered in walking order and stamped like every dated artifact. The pier these guides stand is the horizon home for Comlink, Tablecloth, Murr Mycelium, and whatever networked craft follows — so the series begins with the machine itself and hardens it before anything listens on it.*

**Language:** EN · **Style:** Radiant · **Voice:** Riyo

| # | Guide | Status |
|---|-------|--------|
| 0 | `20260803-164117_0-standing-a-declared-pier.md` — tablet to running NixOS pier in ten movements | Witnessed end to end (Seattle instance); driven from a Daylight DC-1 via Termux, Cursor CLI signed in |
| 1 | `20260803-164117_1-first-steward-and-root-hardening.md` — the first sudo steward; root's door closed the industry way | **Witnessed end to end** `20260808.033555` — steward `keeper` · root network door closed · `sshd -T` GREEN · root SSH refused |
| 2 | `20260803-165931_2-github-hands-and-a-thinking-pier.md` — gh PAT-classic handshake; Claude Code seated on the pier, Termux the window | **Witnessed end to end** `20260808.040720` — `gh` + Claude on pier · tmux `pier` standing |
| 3 | `20260808-041912_3-cli-agents-in-ai-jail.md` — `cursor-agent` + `claude` inside ai-jail for `~/grain` | **Witnessed** `20260808.041912` — agent-jail witness GREEN · jailed pong GREEN |

**Personal knock:** a real-address `ssh` config lives at `.ssh/config` inside this folder — ignored by design (`.gitignore` carries `/.ssh/`), so addresses and identities stay off every remote while the form itself remains in guide 0, placeholders only. **First Framework knock GREEN** `20260805.000001` (`ssh pier` → hostname `pier`).

**Horizon:** service lanes — one honest firewall port per hosted craft — open as Comlink, Tablecloth, and Murr Mycelium each earn their witness.

## Living flake vs tracked templates

| Layer | Path | In grain? |
|-------|------|-----------|
| **Tracked templates** | [`templates/`](templates/) | Yes — placeholder keys only |
| **Living machine config** | `/etc/nixos/` | No — what `nixos-rebuild switch --flake /etc/nixos#pier` reads |
| **Optional private mirror** | separate `pier-flake` repo | No — rebuild-from-nothing off-machine without mixing pier identity into public grain |

Copy from `templates/` (see [`templates/README.md`](templates/README.md)), fill keys, and keep the living files outside this tree. Same house law as `GLOW_HOST.template.bron` → gitignored `GLOW_HOST.bron`.

## Virt horizon on the cloud pier

See [`20260803-194743_virt-horizon-on-the-cloud-pier.md`](20260803-194743_virt-horizon-on-the-cloud-pier.md) — no nested KVM on this Vultr guest; s6 packages for study; SixOS / Genode QEMU TCG parked; Framework owns proven-seat KVM.

*May every machine in this house be a sentence someone can read.*
