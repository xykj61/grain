# Module Surfaces Index — the Tree at One Line per Surface

**Stamp:** `20260707.011412 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — living reference map; canon `20260707.011812`; rows correct through parity **182** + I2 snapshot lap 2
**Register:** Reference — the looking-up room; meanings in our own words, one line each

*Written by Kaeden and Rio 3.*

---

This index answers one question fast: **what exists, where does it live, and what proves it.** Status pins come from the tree's own records on Cursor's metal. A row marked *designed* names a seated meaning whose build waits for its season — named honestly rather than implied built.

## Rye OS — the System

| Surface | One line | Home | Proof |
|---------|----------|------|-------|
| **Rye** | The carrier language: `.rye` files, stock-std toolchain, width laws | `rye/` | parity trio gates every push |
| **Rishi** | The shell: typed pipelines, run-results as values, asserts as gates | `rishi/` | SLC-1 witnesses; runs the suite itself |
| **Mantra** | The referential namespace: recall, bolts, revisions, sync — see its own reference spec | `mantra/` | parity **159–180**; [`20260707-011412_mantra-referential-namespace-reference.md`](20260707-011412_mantra-referential-namespace-reference.md) |
| — Weave (aspect) | Text-buffer line history under `diff.rye`; namespace "Weave" = metaphor for `BoltCatalog` accretion — sovereign slice is I2 `catalog/` export (Kaeden `030412`) | `mantra/src/weave.rye` | graduation trigger when Comlink serves named data from Weave |
| **Comlink** | Sealed carriage: one datagram shape over hosted UDP and device virtio | `comlink/` | parity **154**; wire labs 1556x |
| — wire_format | The 528-byte sealed envelope, 340-byte message | `comlink/wire_format.rye` | every wire witness |
| — hosted / device / virtio_net | The three substrates one logic rides | `comlink/*.rye` | `run_*_lab.sh` |
| **Tally** | Bounds as a discipline: gardens, budgets, named ceilings | `tally/` | foundation seeds in parity (138+) |
| **Caravan** | Supervision: exit vocabulary + poll service + SIGTERM → sentinel at loop top | `caravan/` | `supervisor_exit` **177**; stop sentinel **178**; `supervisor_signal` + SIGTERM witness **179** |
| **Brushstroke** (+ Skate aspect) | Drawing to a surface; Skate is the grid | `brushstroke/` | seed in parity |
| **Pond** (+ drawn terminal; Dexter aspect) | The enclosure where composed things run; Lap-3 metal-closed terminal | `pond/` | Doors 1–2 closed on GNOME |
| **Aurora** | The freestanding RISC-V seed toward verified boot | `aurora/` | freestanding relay witnesses |
| **Amber** | Cellar software: sealed, signed resins on deep storage, verified by folding | `amber/` | lap 1 in parity; spec `20260701-221512` |

## Linengrow — the First Whole Built on It

| Surface | One line | Home | Proof |
|---------|----------|------|-------|
| **receipt_core / receipt** | A verifiable receipt: keypair + log + projection, no chain | `linengrow/` | SLC-L1 parity **152** |
| **delivery** | The receipt crossing identity-to-identity under seal, hosted + device | `linengrow/delivery.rye` | SLC-L2 parity **155** |
| **open_asks** | The closed ask loop: post → apply → accept → complete → verify | `linengrow/open_asks.rye` | OA-L1 parity **156** |
| — cross-party delivery | Request and application hops over both wires | `open_asks_delivery.rye` | OA-L2 parity **157** |
| — escrow (Nyasa) | Hold at acceptance, release at completion; conservation and no-double paths proven; wire lap 2 | (aspect of open_asks) | OA-L3 parity **158** |
| **OA-L4 / MALA** | Reputation-as-fold lap 1 landed parity **167**; MALA graduates at escrow's second consumer | `linengrow/open_asks.rye` | `tools/open_asks_lap4.rish`; ruling `20260706.232812` |
| **Settlement rail** | Sui seated, held pending two-lane witness; SLC-L3's own gate | — | verdict `20260706-005512` |

## Ground — Shared Discipline

| Surface | One line | Home | Proof |
|---------|----------|------|-------|
| **Parity trio** | `parity.rish` · `parity-selftest.rish` · `additive-gate.rish` — run from bare before any claim | `tools/` | **175** witnesses green on metal |
| **Width gate** | Seam-aware roster: fixed widths, no naked `usize`, no tabs | `tools/width-check.rish` + TH stanzas | in the trio |
| **Witness bolts** | Pinned fixtures each lap proves against | convention `20260706-185112` | every namespace witness |
| **Two rooms / silo** | Outside names in external-research; owned vocabulary carries design | `context/TWO_ROOMS.md` | doorway witness (153) |

## Named, Not Yet Built (honest markers)

**Brix** (composer; bricks/courses/bonds seated) · **Tablecloth** (Brix-facing application store — separate from **Tablecloth query** at parity 175; reconciled `20260707.011812`) · **Bron** (`.bron` notation; role open) · **Puddle** (sandboxed containers; first lap = snapshot export/verify/restore) · **Mycelium** (ordering aspect, gated to MALA M4) · **Dexter / Kumara-as-module** (graduation triggers recorded) · **I2 snapshot export** — lap 1 seated [`20260707-021512_snapshot-export-lap1.md`](20260707-021512_snapshot-export-lap1.md); lap 2 horizon bundles [`20260707-024712_snapshot-export-lap2.md`](20260707-024712_snapshot-export-lap2.md); weave/Brix slices open.

---

*May this map stay one honest line per surface, edited the day a surface moves. May "designed" never dress as "built," and every "built" point at its witness. And may whoever opens this page next find the whole tree at a glance, exactly as true as the metal says.*
