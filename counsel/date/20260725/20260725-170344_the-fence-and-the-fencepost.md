# The Fence and the Fencepost

**Language:** EN  
**Stamp:** `20260725.170344`  
**Voice:** Quin  
**Status:** Propose-never-seat — counsel memo (Claude relay · Pond in Glow)  
**Room:** Mixed — founding law (vision) · six-bar mechanics (checkable)  
**Ground:** main `9c0d7f8bff` · Framework Ubuntu 26.04 · living session under brew ai-jail 1.8.0 · teacher pin v1.12.0 restored at `tools/.cache/bin/ai-jail`  
**Companion hammock:** [`../active-designing/20260725-170344_pond-hammock-fence-and-fencepost.md`](../active-designing/20260725-170344_pond-hammock-fence-and-fencepost.md)

---

## Title sense

The **fence** is the Linux kernel — user namespaces, Landlock, mount and network namespaces — reached today through bubblewrap. The **fencepost** is Pond: policy, refusals, and supervision that *stand next to* the fence and never pretend to be the wire.

---

## Founding law (seat these as Pond's first words)

### 1. Pond replaces orchestration, never enforcement

Pond authors policy, refusals, and supervision **above** the syscall. It never invents an isolation mechanism.

**Why beside the rule:** adversarial attention is the safety in isolation code, and a fresh mechanism begins with none. Teacher ai-jail (and bubblewrap beneath it) already carries years of that attention. Pond earns trust by composing them honestly.

### 2. Single-stranded as a security law

One strand. No shared mutable policy state. Every check adjacent to its use and bounded.

**Why beside the rule:** concurrency in a boundary is where time-of-check-to-time-of-use escapes live. One strand closes that class by construction — not as a style preference, as a refuse class.

### 3. Higher bar

Pond must hold and fail in the **same places** the incumbent does, rather than merely passing its own witnesses. Six green bars are necessary and nowhere near sufficient.

---

## What this sitting already proved (checkable)

| Probe | Result |
|-------|--------|
| Tree dirty send | Clean at start — prior send already on `9c0d7f8bff` |
| Teacher pin missing | Restored v1.12.0 (sha256 matched) under gitignored `tools/.cache/bin/ai-jail` |
| Enclosure-neutral Landlock probe | Dual accept `.enclosure-landlock` \| `.ai-jail-landlock` · sixbar GREEN vs living jail |
| Bar5 sandbox fingerprint | Updated to Framework jail-local `CC8B…` (PUBKEYS) — elder `DBF8…` was a false measure here |
| Living session vs pin | Session runs brew **ai-jail 1.8.0**; pin file is **1.12.0** for bar4 — named honestly |
| `glow/README.md` pin | Refreshed past STOA228 → STOA333 · text_floor · advisory mold-header count **11** |
| Cold stranger | Runs this sitting after parity (REPORT, not gate) |

No bar required Pond to touch enforcement. The hammock may proceed.

---

## Nesting shape (proposal)

Prefer **nest-then-remove** over flip-with-retreat:

1. Pond runs **inside** ai-jail for a season — authoring policy and reporting the six bars.  
2. ai-jail remains the **outer wall** (executor).  
3. Nested literal bwrap is refused inside the jail today (`proven_seat_g1` notes this). So the shape is **Pond-as-author · ai-jail-as-executor**, not two bwrap layers.  
4. Exit becomes **removing** the outer fence after a season of evidence. Retreat stays trivial: keep what is already running (`ENCLOSURE=ai-jail`).

---

## Seven decisions for Keaton

1. **Seat founding law** §§1–3 above as Pond's charter (yes / amend / hold).  
2. **Nest-then-remove** as the supersede shape (yes / prefer classic flip / hold).  
3. **Framework bar5** — living jail-local `CC8B…` as incumbent sandbox measure (affirm / restore DBF8-only card).  
4. **Teacher pin vs brew 1.8.0** — daily launches should prefer pinned 1.12.0 via `AIJAIL_BIN` (yes / document dual / hold).  
5. **Syscall seam for Glow** — C shim under seam-C law, or Rye-body call first (name one). Hammock leans C shim for Landlock/bwrap edges.  
6. **glow mold-header on-touch** — advisory 11 stands; no campaign (affirm).  
7. **Cold stranger REPORT** — accept as OQ #4 closed on both paths once this sitting records the number (affirm after printout).

---

*May the fence stay the kernel's, and the fencepost stay ours — soft enough to remove, honest enough to measure.*
