# Pond enclosure scorecard — two columns

*Claude `210800`: incumbent-measured freezes today’s GREEN; pond-required is the supersede floor. Gaps are rows.*

**Stamp:** `20260712.210800`
**Language:** EN
**Style:** Radiant
**Voice:** Rio 3
**Last updated:** `20260712.213600` — freeze affirmed · master-seal custody
**Status:** Checkable — column one frozen · column two gaps named · season-closed **measured** (exit bron and `.asc` absent · master-seal policy ready)
**Ground:** Claude shape [`20260712-210800_pond-sixbar-claude-shape-exit.md`](20260712-210800_pond-sixbar-claude-shape-exit.md) · baseline pin [`20260712-205600_pond-enclosure-sixbar-baseline.md`](20260712-205600_pond-enclosure-sixbar-baseline.md) · counsel [`../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md`](../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md)

**Witness (column one):** `rishi/bin/rishi run tools/pond_enclosure_sixbar.rish`  
**Witness (two-column living):** `rishi/bin/rishi run tools/pond_enclosure_scorecard.rish` — column one GREEN · gaps named · exit bron and `.asc` absent · master-seal policy · `ENCLOSURE=ai-jail` grepped  
**Witness (column-two probes):** `rishi/bin/rishi run tools/pond_enclosure_col2_probes.rish` — refuse-until-candidate · measured truth · claim nothing  
**Master-seal helper:** `tools/pond_exit_bron_master_seal.sh` — `--season-closed` · `--require` (VALIDSIG `0646 2132…` alone)

---

## Scorecard

| # | Bar | Incumbent-measured (ai-jail today · column one) | Pond-required (supersede floor · column two) | Gap row |
|---|-----|--------------------------------------------------|----------------------------------------------|---------|
| 1 | Durable project tree | `.git` · writable root · cache probe persists | Project tree durable across enclosure lifetime; writes persist inside the bound work tree | — |
| 2 | Home and tmp reset | Sparse HOME (no Documents/Downloads) · `/tmp` writable · **incumbent-anchored:** `/tmp/.ai-jail-landlock` present | Private home/tmp that reset on exit; host clutter absent — **behavior**, not the landlock filename | — |
| 3 | Wayland/GPU lane | Always-on today: `WAYLAND_DISPLAY` set · `/dev/dri` present (incumbent wrapper) | GPU present when granted · absent when not — refuse-permit pair like KVM | Lane customs (grant/refuse) not yet Pond policy |
| 4 | KVM lane | `lane_kvm` off by default · refuse-probe OK · **incumbent-anchored:** teacher `ai-jail 1.12.0` binary pin | Named KVM lane off by default; on grants `/dev/kvm` only — **behavior**, not the ai-jail artifact | — |
| 5 | Signing-lane separation | Sandbox secret `DBF8…` present · master secret absent · lane key file absent · **exactly one** `sec:` in sandbox keyring | Same custody shape: sandbox signing present · master absent · lane absent · exactly one secret | — |
| 6 | Bus / negative space | kvm-off refuse OK · no D-Bus KVM path in living tools · host home refuse OK · **three-door bus:** env=`set` · socket=`present` · netns=`shared` | Bus unreachable on all three doors; policy-path refuse is opt-in customs only, never ambient | **Yes — all three doors open under incumbent** |

---

## Bar6 — three-door bus measure (gap row)

| Door | Incumbent-measured (record) | Pond-required |
|------|----------------------------|---------------|
| Env | `$DBUS_SESSION_BUS_ADDRESS` empty or set | Empty |
| Concrete socket | `$XDG_RUNTIME_DIR/bus` absent or present | Absent |
| Network namespace | Shared (host links visible) or unshared | **Unshared** — closes abstract-namespace sockets Pond does not inherit |

**Policy law:** unreachable is the floor. A refusing broker is a **door** (named custom + paired witness), never ambient absence dressed as a daemon.

Meta lines from the witness: `bus_env` · `bus_socket` · `bus_netns` · gap flagged while any pond-required cell fails.

---

## How to read

- Column one GREEN ⇒ baseline honest; supersede has not begun.
- Gap rows stay visible until column two holds.
- Incumbent-anchored cells never migrate into Pond’s required column as literal filenames or teacher binaries.

---

*May column one stay true, column two stay strict, and every gap keep its own row until absence earns the close.*
