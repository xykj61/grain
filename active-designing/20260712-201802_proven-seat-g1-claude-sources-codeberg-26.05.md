# Proven-seat G1 — Claude sources revise (Codeberg 26.05)

*Claude answered Kaeden’s Codeberg question and revised the evening sources pin. Verified before answering: Codeberg is canonical; VERSION 26.05 at `492a5102…` (2026-05-29, Christian Helmuth); migration commits remove the GitHub check and retarget docs.*

**Stamp:** `20260712.201802`
**Language:** EN
**Style:** Radiant
**Voice:** Rio 3 recording Claude · Kaeden’s clock from the 20:17 paste
**Status:** Checkable — revise seated · fetch witness retargeted · commit pin is the floor
**Ground:** three asks [`20260712-201200_proven-seat-g1-claude-three-asks.md`](20260712-201200_proven-seat-g1-claude-three-asks.md) · crossing pin [`20260712-195339_proven-seat-g1-crossing-pin.md`](20260712-195339_proven-seat-g1-crossing-pin.md) · Codeberg [genodelabs/genode](https://codeberg.org/genodelabs/genode)

---

## Revise (Claude)

**Pin G1 sources at 26.05, fetched from Codeberg.** The `201200` counsel named 25.05 — tested-pair reasoning was sound yet pointed at the wrong “current.” With 26.05 verified on the canonical forge, the same reasoning selects **26.05**.

**Toolchain 25.05 stands.** Biennial word: GCC 14.2 serves from 25.05 for 24 months. Tree at migration day still pins `TOOL_CHAIN_VERSION = 25.05`, GCC 14.2.0 — matching cached `genode-x86-g++`. Equal-or-next-smaller satisfied; nothing re-fetches.

**Why 26.05 is better for this rung:** G1 boots its *own* Genode image under jailed TCG (Sculpt 26.04 stays the untouched G0 artifact); next Sculpt ground sits nearer 26.05; current Goa/docs/community; Codeberg-first honors the teacher’s forge and the house’s origin.

**Pinning recipe:** prefer **commit pin over tarball hash**. Witness: shallow-clone `--branch 26.05` from `codeberg.org/genodelabs/genode.git`, assert `git rev-parse HEAD` equals `492a51024217fe74ccee1ebdfb81be97046b43eb`. Try `git verify-tag 26.05` and record; commit pin is the floor either way.

**META trio (updated):**

| Field | Pin |
|-------|-----|
| toolchain | **25.05** |
| sources | **26.05** @ `492a51024217fe74ccee1ebdfb81be97046b43eb` |
| ground | **Sculpt 26.04** |

25.05 release notes remain the teacher for the API-hardening / sum-types story on the study shelf. `prepare_port libc` advice unchanged.

---

*May the sources arrive at their true address, the pin hold to the byte, and the guest’s first words be compiled from the teacher’s living tree.*
