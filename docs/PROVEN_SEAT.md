# Proven-seat — borrowed ground ladder

*Genode/Sculpt as teacher seat; Rye proves the claim; witnesses pin every rung.*

**Status:** Checkable — proven-seat operator guide
**Depth:** guide
**Ceiling:** ≤300 lines
**Last updated:** 2026-07-12
**Compresses:** [`proven-seat-guest-hammock.md`](../active-designing/proven-seat-guest-hammock.md) · [`20260712-195339_proven-seat-g1-crossing-pin.md`](../active-designing/20260712-195339_proven-seat-g1-crossing-pin.md) · [`20260712-204549_proven-seat-g1-claude-close.md`](../active-designing/20260712-204549_proven-seat-g1-claude-close.md) · [`20260712-214200_proven-seat-signed-kumara-monocypher.md`](../active-designing/20260712-214200_proven-seat-signed-kumara-monocypher.md) · [`20260712-214900_signed-kumara-monocypher-pin.md`](../active-designing/20260712-214900_signed-kumara-monocypher-pin.md) · [`20260712-220400_proven-seat-seam-c-and-rye-body.md`](../active-designing/20260712-220400_proven-seat-seam-c-and-rye-body.md) · [`20260712-113900_lane-kvm-retire-dbus-escape.md`](../active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md)

---

## Thesis — borrowed proven ground

The proven-seat ladder proves the **seat** before the house claims it. Each rung adds one honest claim on teacher metal (Sculpt image, Genode toolchain, posix/libc guest, jailed serial) while **meaning stays in Rye** — generators, witnesses, Kumara keys, pair law.

**Guest, never merger.** No Genode or seL4 code in `caravan/`. No AGPL teacher link into Rye binaries we ship. Guest artifacts live under `tools/.cache/proven-seat/` (gitignored).

**Cache versus vendor:** workbench droppings stay in cache; teacher sources pin in `vendor/` submodules. Fetch witnesses assert HEAD equals pin — see [`VENDORING.md`](VENDORING.md) when seated.

---

## Rung table

| Rung | Grade | Primary witness | Serial / artifact words | State |
|------|-------|-----------------|-------------------------|-------|
| **G0** | environment | `tools/proven_seat_g0.rish` | SeaBIOS → disk → **GRUB loading** (TCG) | GREEN |
| **G0-complete** | kvm path | `tools/lane_kvm_onpath_host.rish` | Leitzentrale **Components** graph · GRUB on COM1 | GREEN `140403` |
| **G1** | **digest-grade** | `tools/proven_seat_g1.rish` (after fetch chain) | *fixture holds; seat speaks* | **closed** `204549` |
| **signed-Kumara** | **signed-Kumara** | `tools/proven_seat_signed_kumara.rish` | verify GREEN + tamper-refuse GREEN | **resting** `220400` |

**Pair law (signed-Kumara):** guest must call `crypto_ed25519_check` at least twice (good + tampered) and must never reference `crypto_eddsa_`. Proved by `tools/proven_seat_signed_kumara_fetch.rish` assert 2.

**META trio (G1):** toolchain · sources · ground — fields and pins live in [`20260712-195339`](../active-designing/20260712-195339_proven-seat-g1-crossing-pin.md) and cache META files written by fetch witnesses (`g1-sources-meta.txt`, `g1-toolchain-meta.txt`). Do not trust this page for byte pins; run the fetch witness.

---

## Crossing — which path reaches the seat

| Candidate | Verdict |
|-----------|---------|
| Host `vendor/zig-toolchain` + `rye build` alone | **Refuse** as Genode crossing — Linux/wasm ABI, not Genode libc |
| Genode toolchain (prebuilt tarball) | **Teacher for compile** — pin in fetch witness |
| Genode sources @ submodule `vendor/genode` | **Required to link** posix/libc — HEAD assert in fetch witness |
| Genode `posix` + `libc` | **Runtime shape** — `Libc::Component::construct` entry |
| Goa SDK | Same toolchain family when versions align |

**Pinned G1 path:** smallest honest `receipt_core` verify-witness as **posix/libc** component, **25.05** toolchain + **26.05** sources, jailed TCG serial (`KERNEL=nova`). Probe: `tools/proven_seat_g1_crossing_probe.rish`.

Full spike record: [`20260712-195339`](../active-designing/20260712-195339_proven-seat-g1-crossing-pin.md).

---

## Seam-C law — when C is the thinnest plank

Rye already runs freestanding on bare metal (Aurora). A Genode component **links a runtime** — there is no language-agnostic syscall door. Zig has no `genode` target; the proven-seat ladder therefore uses the teacher's **C + patched GCC** entry shape for the guest ABI gap.

**Seam C is not the model.** Kumara signs; Rye generates fixtures; Rishi orchestrates; the guest C layer carries two `crypto_ed25519_check` calls across the ABI. Same law as `sh` at POSIX seams.

**Rye-body horizon (parked):** freestanding Rye objects + ~10-line C shim owning `construct`. **Trigger:** guest logic outgrows seam-C, or a second Genode guest wants Rye authoring. Counsel: [`20260712-220400`](../active-designing/20260712-220400_proven-seat-seam-c-and-rye-body.md).

**Crypto teacher (signed-Kumara):** **Monocypher** with `monocypher-ed25519` / `crypto_ed25519_check` (RFC 8032 / SHA-512). Default BLAKE2b EdDSA is the named red-to-avoid. Pin proved by `tools/proven_seat_signed_kumara_fetch.rish`.

---

## How to run every rung

Run from repository root. Teacher images and builddirs stay under `tools/.cache/proven-seat/`.

### G0 — TCG boot milestone (jail-runnable)

```bash
rishi/bin/rishi run tools/proven_seat_g0.rish
```

Stage `sculpt-26-04.img` per witness header (sha256 asserted in witness).

### G0-complete — `lane_kvm` on Framework host

**Refuse floor** (lane off, inside jail):

```bash
rishi/bin/rishi run tools/lane_kvm_refuse.rish
```

**On-path host one-shot** (outside ai-jail, `/dev/kvm` present):

```bash
rishi/bin/rishi run tools/lane_kvm_onpath_host.rish
```

Optional same-sitting parity: add `--parity`. Jailed boot alone: `LANE_KVM=true rishi/bin/rishi run tools/proven_seat_g0_complete_jailed.rish`.

D-Bus/systemd host escape is **retired** — [`113900`](../active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md).

### G1 — digest-grade serial (jail-runnable · no KVM)

Chain in order (each witness GREEN before the next):

```bash
rishi/bin/rishi run tools/proven_seat_g1_fetch_toolchain.rish
rishi/bin/rishi run tools/proven_seat_g1_fetch_sources.rish
rishi/bin/rishi run tools/proven_seat_g1_prepare_libc.rish
rishi/bin/rishi run tools/proven_seat_g1_create_builddir.rish
rishi/bin/rishi run tools/proven_seat_g1_build_guest.rish
rishi/bin/rishi run tools/proven_seat_g1.rish
```

Crossing sanity: `rishi/bin/rishi run tools/proven_seat_g1_crossing_probe.rish`.

Guest sources: `tools/proven_seat_g1_guest/`. Grade **digest-grade** — verify-content rides as passenger; name the grade on the Status line so no reader over-reads.

### signed-Kumara — verify + refuse pair (jail-runnable · no KVM)

```bash
rishi/bin/rishi run tools/proven_seat_signed_kumara_fetch.rish
rishi/bin/rishi run tools/proven_seat_signed_kumara_build_guest.rish
rishi/bin/rishi run tools/proven_seat_signed_kumara.rish
```

Expected serial lines (verbatim):

- `GREEN: signed-Kumara — signature holds; seat verifies (amount 100)`
- `GREEN: signed-Kumara — tampered signature refused; seat stands guard`

Fixture generator: `tools/proven_seat_signed_kumara_gen.rye` through `tally/kumara`. Test seed only — **seed never crossed** onto the seat claim.

**Resting** — no one-line before the ladder sleeps. Morning word (Kaeden): whether fetch · build · serial join a parity chapter.

### Metal parity (suite nib **433**)

Chapter 1 prints `living_docs_lint` ratchet advisory beside `tame_style`. Chapter 2 appends `proven_seat_signed_kumara_parity.rish` (fetch gates; build+serial when bench staged; jail-safe ADVISE skip).

Separate from the ladder rungs — Wasm receipt-verify under Env ceiling:

```bash
rishi/bin/rishi run tools/parity.rish
```

Host re-pin landed `20260712.193958`. See `work-in-progress/TASKS.md` for suite nib and chapter claims.

---

## How to add a rung

1. **Name the claim** in `active-designing/` (dated, Checkable) — raw layer first.
2. **Spike crossing** — refuse bad paths explicitly (crossing probe pattern).
3. **SLC witness chain** — fetch · prepare · build · serial; one GREEN lap at a time.
4. **Grade honestly** — digest-grade vs signed-Kumara vs future grades; Status line carries the word.
5. **Compress here** when facts scatter across many notes — update this page, cite witnesses, never duplicate load-bearing pins.
6. **Check in with Claude** before G2 capability-shaped guest or Caravan-as-parent — hammock names those as seam crossings.

Horizon rungs (parked): G2 capability component · G3 Caravan seed as Genode parent · libsodium behind named trigger · Rye-body shim on seam-C trigger.

---

## Enclosure cross-ref

Proven-seat metal runs inside **ai-jail** by default; `lane_kvm` grants `/dev/kvm` only on host one-shot. Full enclosure scorecard and pond season: [`ENCLOSURE.md`](ENCLOSURE.md) when seated.

Living hammock ledger: [`proven-seat-guest-hammock.md`](../active-designing/proven-seat-guest-hammock.md).

---

## Dependencies

| Teacher | Role |
|---------|------|
| **Genode / Sculpt** | Seat image · toolchain · posix/libc guest shape (AGPL teacher artifacts in cache only) |
| **Monocypher** (Loup Vaillant) | Ed25519 verify surface for signed-Kumara — CC0/BSD dual |
| **QEMU** | TCG serial path · `lane_kvm` glass under `-display none` |

---

*May every rung name its witness before the binary claims the seat. May meaning stay in Rye while the thinnest seam carries the ABI. May the teachers rest pinned in the vendor row and thanked in the gratitude room.*
