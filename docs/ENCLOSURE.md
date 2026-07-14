# Enclosure — custody, lanes, and Pond supersede

*ai-jail holds the daily seat today; Pond earns it by out-refusing the jail — witnessed, never by feature list.*

**Status:** Checkable — enclosure and Pond supersede guide
**Depth:** guide
**Ceiling:** ≤300 lines
**Last updated:** 2026-07-12
**Compresses:** [`counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md`](../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md) · [`20260712-210800_pond-enclosure-scorecard-two-column.md`](../active-designing/20260712-210800_pond-enclosure-scorecard-two-column.md) · [`20260712-210800_pond-supersede-exit-criteria.md`](../active-designing/20260712-210800_pond-supersede-exit-criteria.md) · [`20260712-212412_pond-scorecard-claude-second-walk.md`](../active-designing/20260712-212412_pond-scorecard-claude-second-walk.md) · [`20260712-213600_pond-freeze-affirm-master-seal.md`](../active-designing/20260712-213600_pond-freeze-affirm-master-seal.md) · [`20260712-113900_lane-kvm-retire-dbus-escape.md`](../active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md) · [`context/specs/enclosure-editors.md`](../context/specs/enclosure-editors.md)

---

## Thesis — custody split

An enclosure with an unnamed hole is thinner than either a jail with one named device lane or a finished Pond. The house disposition is **A-narrow interim → B supersede-by-witness**:

| Phase | Meaning |
|-------|---------|
| **A-narrow** | Repair the wall in *our* config — teacher **ai-jail stays unmodified** |
| **B** | Pond supersedes ai-jail the day it beats the jail at its own refusals |

**Custody today:** master signing key on host only · sandbox OpenPGP inside jail · lane key in cloud · KVM grants no key access. Every authorized escape becomes a refusal-assert of the next enclosure.

**What not to widen in ai-jail:** host session buses (D-Bus, systemd transient units), host `$HOME` beyond project bind, shared `/tmp`, broadened network, USB/raw disk, docker socket. Wayland/GPU pass stays as-is; KVM is **display-less by design** (`-display none` + QMP screendump).

Full ruling: [`counsel/20260712-090512`](../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md).

---

## Wrapper surfaces — `tools/enclosure.conf`

Personal `tools/enclosure.conf` is gitignored; [`tools/enclosure.conf.example`](../tools/enclosure.conf.example) is the tracked template. Setup law: [`context/specs/enclosure-editors.md`](../context/specs/enclosure-editors.md).

| Surface | Default | Role |
|---------|---------|------|
| **`AIJAIL_FLAGS`** | `--private-home --no-docker` | Passed to teacher ai-jail by `cursor-jail.sh` / `launch-zed.sh` |
| **`AIJAIL_BIN`** | optional | Pin teacher binary — v1.12.0 pin proved in example comments; tarball sha256 in witness header |
| **`USE_GPU`** | `true` (Zed on Wayland) | `/dev/dri` passthrough when true |
| **`LANE_KVM`** | `false` | A-narrow gate — `/dev/kvm` only when on |
| **`ENCLOSURE`** | `ai-jail` | Retreat flag — flip to `pond` only past master-signed exit bron |

Wrappers honor `ENCLOSURE` before launch. `ENCLOSURE=pond` **refuses** unless exit bron is present-with-content **and** master-signed — verified by `tools/pond_exit_bron_master_seal.sh`.

---

## `lane_kvm` — refuse / permit pair

**Off by default.** When off, the gate refuses QEMU runs that need KVM. When on (one-shot or conf), grants **`/dev/kvm` only** — no D-Bus, no systemd host escapes, no session buses.

| Witness | When |
|---------|------|
| `rishi/bin/rishi run tools/lane_kvm_refuse.rish` | Lane off — daily editor default |
| `rishi/bin/rishi run tools/proven_seat_g0_complete_jailed.rish` | Lane on inside jail |
| `rishi/bin/rishi run tools/lane_kvm_onpath_host.rish` | Host one-shot Framework sitting |

**Retired:** D-Bus + systemd transient units as KVM doorway — [`113900`](../active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md).

Proven-seat metal detail: [`PROVEN_SEAT.md`](PROVEN_SEAT.md).

**Route two (parked):** nest `bwrap` + `--dev-bind /dev/kvm` for proven-seat only. **Graduation trigger:** open when G1's QEMU cadence makes the hand one-shot the bottleneck (lane's second consumer), or at the autonomous-pipeline word — whichever first. Do not patch teacher ai-jail.

---

## Six bars — two-column scorecard

Column one **incumbent-measured** (ai-jail today) freezes honest baseline. Column two **pond-required** is the supersede floor. **Gap rows** stay visible until column two holds.

| # | Bar | Column one (frozen) | Column two gap? |
|---|-----|---------------------|-----------------|
| 1 | Durable project tree | `.git` · writable root · cache persists | — |
| 2 | Home/tmp reset | Sparse HOME · `/tmp` writable | — |
| 3 | Wayland/GPU | `WAYLAND_DISPLAY` · `/dev/dri` when granted | Lane customs not yet Pond policy |
| 4 | KVM lane | `lane_kvm` off · refuse OK · teacher pin | — |
| 5 | Signing separation | Sandbox secret present · master absent · exactly one `sec:` | — |
| 6 | Bus / negative space | Three-door bus **open** under incumbent | **Yes — all three doors** |

### Bar 6 — three-door bus (gap row)

| Door | Incumbent (record) | Pond-required |
|------|-------------------|---------------|
| Env | `$DBUS_SESSION_BUS_ADDRESS` empty or set | **Empty** |
| Socket | `$XDG_RUNTIME_DIR/bus` absent or present | **Absent** |
| Netns | Shared (host links visible) | **Unshared** |

**Policy law:** unreachable is the floor. A refusing broker is a **door** (named custom + paired witness), never ambient absence dressed as a daemon.

Full table: [`20260712-210800` scorecard](../active-designing/20260712-210800_pond-enclosure-scorecard-two-column.md).

---

## Witnesses — how to run

```bash
# Column one baseline (incumbent sixbar)
rishi/bin/rishi run tools/pond_enclosure_sixbar.rish

# Two-column living measure (col1 GREEN · gaps named · season-closed)
rishi/bin/rishi run tools/pond_enclosure_scorecard.rish

# Column-two probes (refuse-until-candidate · no season open)
rishi/bin/rishi run tools/pond_enclosure_col2_probes.rish

# Master-seal policy / season-closed / require
tools/pond_exit_bron_master_seal.sh --policy
tools/pond_exit_bron_master_seal.sh --season-closed
tools/pond_exit_bron_master_seal.sh --require   # only when exit bron + .asc present
```

**Incumbent-anchored cells** record behavior — never migrate literal ai-jail filenames or teacher binaries into Pond's required column.

---

## Exit criteria — six at once

Held in a **single signed scorecard bron** at fixed path `bron-resins/pond-supersede-exit.bron` — not a checklist in arbitrary order. **Absent** while season sleeps.

| # | Criterion | Measure |
|---|-----------|---------|
| 1 | Bar parity | Two-column scorecard green; incumbent cells **translated**, not inherited |
| 2 | Gap closed | Bus unreachable on all three doors |
| 3 | Daily-driver proof | Full parity suite inside Pond + one real bench session |
| 4 | Customs parity | KVM and GPU as named lanes with refuse-permit pairs |
| 5 | Durability | **N** — see below |
| 6 | Retreat path | `ENCLOSURE=ai-jail` launchable one full season past flip |

Full card: [`20260712-210800` exit criteria](../active-designing/20260712-210800_pond-supersede-exit-criteria.md).

---

## N — durability (six-over-seven)

**One-line:** six consecutive green sittings spanning at least seven calendar days.

**Rider 1 — breadth:** six must include daily editor sitting · full parity suite · QEMU leg · cold start after host reboot.

**Rider 2 — soak clock:** count begins when column two first goes all-green on a **frozen** candidate; `soak_start_nib <hash>` on exit bron and soak log. **Enforcing-code-resets:** changes to enclosure-enforcing code reset the count (namespaces, mounts, device nodes, seccomp/landlock, lane grant-refuse — not launch ergonomics).

**Rider 3 — red law:** one red resets count; two reds on one witness **parks** the season.

---

## Master seal and ceremony

**Presence alone does not open the season.** An agent inside the jail could write and sandbox-sign the sentinel. Exit bron **counts only when master-signed** — detached `.asc` verifies against master fingerprint proved in `tools/pond_exit_bron_master_seal.sh` (isolated keyring holding only `context/keys/gpg_signing_06462132.pub.asc`).

**Season states:**

| State | Measured by |
|-------|-------------|
| **Closed** | Exit bron and `.asc` absent · `--season-closed` GREEN |
| **Soaking** | Named build word · frozen candidate · N in progress |
| **Open** | Exit bron contentful + master `.asc` · `--require` GREEN |

**Affirmation path (remaining):** Kaeden's **named supersede build word** → freeze release candidate → record `soak_start_nib` → soak under N → write exit bron → master-sign on host (cold key only). Ceremony command lives in exit card witness — run from card, not from this page.

Freeze affirmed: [`213600`](../active-designing/20260712-213600_pond-freeze-affirm-master-seal.md).

---

## Season latch — what is parked

| Item | State |
|------|-------|
| Supersede build season | **Held** for named build word only |
| Signed-Kumara deepen | Resting · Monocypher teacher seated |
| Column-two Pond candidate | Probes landed refuse-until-candidate — **no build yet** |
| libsodium | Parked behind named trigger |

**Enforcing seam** (accretion `212412`): convenience vs enforcing code — default remains enforcing-code-resets until demonstrated need.

---

## Puddle doorway — horizon

**Pond** is the enclosure aspect inside one running whole. **Puddle** hosts many Ponds — snapshot semantics, fleet orchestration, Amber-compatible export. Exploration only: [`external-research/20260702-035018_puddle-sandboxed-rye-containers.md`](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md).

The same `lane_kvm` fact graduates to Pond customs at supersede — same gate, policy-as-value moves home (Gall's Law on the wall).

---

## argv-direct law (witness builds)

Rishi `run` is argv-direct — assert `.ok` first; GREEN on the stream the tool speaks (`.err` for `std.debug.print`, `.out` for `say`). `sh` wrappers are convenience seams, not the model. Affirmed `144519` — see session logs and RTAC; enclosure witnesses follow the same discipline.

---

## Dependencies

| Teacher | Role |
|---------|------|
| **ai-jail** (Akita On Rails) | Daily enclosure teacher — v1.12.0 pin in example; study in `gratitude/ai-jail` |
| **bubblewrap / landlock** (implicit) | Wall muscle Pond ring one will drive |
| **QEMU** | KVM lane guest boots — display-none + QMP glass |

---

*May every hole become a named lane, every lane a paired witness, and the master seal the season's only key.*
