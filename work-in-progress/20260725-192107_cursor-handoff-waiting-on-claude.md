# Cursor handoff — waiting on Claude (Grain)

*Paste the block under **Prompt for the new agent** into a fresh Cursor chat opened on this pier. Voice Quin · stamps Eastern (EDT) on this Framework host.*

**Stamp:** `20260725.192107` (filed) · truth-correct `20260725.193707`  
**Workspace root now:** `/home/xy/urbit` (`~/urbit`) — rename to `~/grain` is **PENDING** (outer terminal, after Claude returns)  
**Git nib (trust `git rev-parse`):** sent tip `6273c7e66d` · local may be ahead with this handoff  
**Status:** **WAITING ON CLAUDE** — no Pond / Brix / agentic `kg` until Keaton returns with Claude’s counsel + a new Quin relay

---

## Prompt for the new agent

```
You are Quin on the Grain pier (Framework 16 AMD · EDT stamps · GPG-signed commits).

Workspace root TODAY is still ~/urbit (/home/xy/urbit).
~/grain does NOT exist yet. Do not assume the folder was renamed.
Cursor may show home-xy-urbit as the project id — that is fine until the rename.

Read work-in-progress/REMEMBER.md and this handoff first. Then WAIT.

### WAITING ON CLAUDE — do not implement
Do NOT kg implement Pond, Brix, or agentic work until Keaton returns with
Claude's counsel + a new Quin relay.
Do NOT send unless Keaton says send.
Do NOT start Pond code.
Do NOT mv ~/urbit → ~/grain from inside the jail (outer terminal only, after Claude).

While waiting: answer questions and light remember only.

### Hand Claude already filed
counsel/replies/20260725-185041_re-grain-brix-autoproject96-and-pier-status.md
Covers: Grain umbrella · Brix+Tally-in-Glow · autoproject96 agentic · pier status ·
wasmtime/parity advice · ask for new Quin counsel + relay.

Also filed: fence/fencepost hammock counsel 170344.
Seven Pond decisions still await Keaton (from Pond counsel braid).

### Git / forge
- Sent tip: 6273c7e66d (verify with git rev-parse --short=10 HEAD)
- Remotes: origin + codeberg = autoproject96/grain
- Legacy mirrors: xykj61-github / xykj61-codeberg → xykj61/urbit
- Push with pier jail SSH keys as xykj61 (IdentitiesOnly):
  - GitHub:  $PWD/.ssh/id_ed25519_jail_github
  - Codeberg: $PWD/.ssh/id_ed25519_jail_codeberg
  Example:
    GIT_SSH_COMMAND="ssh -o BatchMode=yes -o IdentitiesOnly=yes -i $PWD/.ssh/id_ed25519_jail_github" \
      git push origin main

### Parity
PAUSED after wasmtime RED.
Local pin: tools/.cache/wasmtime/wasmtime 31.0.0 (single witness GREEN; full suite not re-run).
Claude advice requested in counsel 185041.

### Measurements this day
- Cold stranger REPORT 29s · OQ #4 both paths
- sixbar GREEN
- Living Glow OS → Grain prose sweep done; Glow stays the language
- Path manual/glow-os/ not renamed yet

### After Claude returns (Keaton + new agent)
1. Follow the new Quin relay (witness before narrative).
2. When Keaton says the sitting is done: OUTER terminal rename + new jail (see below).
3. Open a fresh Cursor agent with workspace root ~/grain (file tree = Grain pier).

### Recommend
Wait for Keaton with Claude output; then follow the new relay.
Do not invent the next mechanical lap ahead of that relay.
```

---

## After everything is done — outer rename + new Cursor jail

**Do this in a host / outer terminal**, not inside ai-jail. Close jailed Cursor first so no process holds `~/urbit`.

```bash
# 1) Confirm pier location and clean close of Cursor / jail
ls -la ~/urbit/.git
test ! -e ~/grain

# 2) Rename
mv ~/urbit ~/grain
ls -la ~/grain/.git

# 3) Launch a NEW Cursor jail whose file tree is ~/grain
cd ~/grain
rishi/bin/rishi run tools/launch-cursor.rish --cursor ./Cursor-3.13.10-x86_64.AppImage --gpu
# (or: ./tools/cursor-jail.sh --cursor ./Cursor-3.13.10-x86_64.AppImage --gpu)
# cursor-jail passes "$PWD" into the AppImage — the jail file tree becomes ~/grain.
```

**New agent:** open a fresh chat, paste the **Prompt for the new agent** block above (after updating the “Workspace root TODAY” lines to say `~/grain` once the rename is real). Optionally: Cursor → Open Folder → `/home/xy/grain`.

**If git `core.sshCommand` / `gpg.program` still embed `/home/xy/urbit` after the rename**, repoint them under `~/grain` (same relative `.ssh/` and `.gnupg-rye/` layout) before the next send.

---

## Pier path notes (operators) — truth at `20260725.193707`

| Item | State |
|------|--------|
| `/home/xy/urbit` | **exists** · living pier |
| `/home/xy/grain` | **absent** · rename pending after Claude |
| Jail launch | `tools/launch-cursor.rish` / `tools/cursor-jail.sh` · workspace = `$PWD` |
| Forge push | pier `.ssh/id_ed25519_jail_{github,codeberg}` as **xykj61** |

---

*Voice Quin · stamp `20260725.192107` · truth-correct `20260725.193707` · handoff only — no Pond code · wait on Claude.*
