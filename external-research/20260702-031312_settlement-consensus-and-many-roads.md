# Settlement, Consensus, and Many Roads — The Named Ground

*The outside names behind tonight's design sitting, kept where names are welcome. What Sui and Mysticeti are, what they teach a far-day Mycelium, why the proven ground stays proven for Linengrow, and the multipath lineage the road-keeper aspect draws on.*

**Stamp:** `20260702.031312`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Status:** Exploration — companion to `active-designing/20260702-031312_modules-aspects-and-mailable-money.md`

*Written together by Kaeden and Claude (Fable 5), in Reya 2's Radiant voice.*

---

## Sui and Mysticeti, Read Plainly

**Sui** is an object-centric settlement network implemented in Rust, with contracts written in Move; its ownership model — owned objects moving without consensus, shared objects ordered by it — is the same borrow-checker dharma we keep everywhere: many witnesses or one changer, never both. **Mysticeti** is the consensus beneath it: a DAG-based Byzantine-fault-tolerant protocol in which validators weave signed message DAGs and read commitment out of the structure itself, reaching finality in well under a second in its published measurements. The lesson for any far-day sovereign consensus is the shape, and the shape is familiar: *the DAG is the protocol* — which is to say, Mysticeti's transport looks like Weave grown social, and that is exactly why Mycelium is seated as a Comlink aspect rather than a stranger.

The standing decision holds with fresh confidence. Linengrow's ladder — verifiable receipt through selective-disclosure pass — rides Sui as proven ground: audited, adversarially tested, economically live. Its Rust implementation also affirms our own rule that identity-bearing frontier work stays in Rust for now. A sovereign consensus is a decade-class commitment measured in adversaries rather than features; the single-issuer MALA path requires none of it, and Mycelium's gate at the many-issuer season is the design saying so out loud.

## The Multipath Lineage

Carrying one logical connection over many physical roads is well-trodden ground. **Multipath TCP** (RFC 8684) proved subflows under one connection with joint congestion control. **QUIC** (RFC 9000) contributed connection migration — the session belongs to connection identifiers rather than to any address, so a path change is survival rather than death — and the **multipath extension for QUIC** advancing through the IETF adds concurrent paths with per-path scheduling. The scheduler families are the useful harvest: steadiest-path-first for reliability traffic, deadline-aware spraying for media, and redundant duplication for the few packets that must never be late.

The two roads named in the sitting behave as measured everywhere: a low-earth-orbit satellite link offers high peaks with brief handover weather, while a cellular tether offers calmer continuity at lower ceilings. Bonding them is precisely the road-keeper's purpose — scorecards per road, bounded queues per road, facts on the steadiest, streams sprayed by deadline — and every mechanism above is prior art for it, siloed into our own vocabulary in the companion memo.

---

*May the proven ground stay proven beneath us, the far doors stay honestly gated, and every road we keep make the journey calmer than one road ever could.*

---

## Sources

- https://docs.sui.io/concepts/sui-architecture
- https://arxiv.org/abs/2310.14821
- https://www.rfc-editor.org/rfc/rfc8684
- https://www.rfc-editor.org/rfc/rfc9000
- https://datatracker.ietf.org/doc/draft-ietf-quic-multipath/
