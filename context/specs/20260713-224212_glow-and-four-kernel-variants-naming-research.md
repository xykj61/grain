# `%glow`, and Naming Four Switchable Kernel Variants — Research, Not Yet a Rename

**Language:** EN
**Version:** `20260713.224212`
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Research and proposal — no rename committed, no code written

---

## Is There a `%glow` in Old Urbit?

**No.** A direct search of `old/` (the full `urbit/urbit` tree) and `old/urbit.org` (the docs site) for `%glow`, `+glow`, or bare `glow` found no rune, vane, standard-library arm, jet, or Hoon term by that name. Every match was incidental:

- CSS `box-shadow`/visual "glow" effects in `pkg/landscape/`, `pkg/interface/`, and `pkg/arvo/app/debug/` — ordinary web styling, unrelated to Hoon
- `GLOW` as one entry among thousands in `old/doc/spec/flw.txt` — a four-letter-word list (curiously, itself entirely four-letter words, echoing the vane-naming pattern this project already confirmed) — not a naming source for vanes or runes, and not Urbit-specific
- `glow` as one of the 2,048 BIP39 English wordlist entries, appearing in `old/pkg/base-dev/lib/bip39/english.hoon` and `old/nockchain/hoon/common/bip39-english.hoon` — a cryptographic mnemonic wordlist Urbit and Nockchain both use for seed phrases, not a term with any Urbit-specific meaning

**`%glow` is genuinely unclaimed inside Urbit's own vocabulary.**

## But "Glow" Is Not Unclaimed in the Wider World

A web search turns up a real, directly-adjacent collision: **Glow Language** (`glow-lang.org`, `github.com/Glow-Lang/glow`) is an existing, still-referenced open-source programming language for writing safe, portable Decentralized Applications on blockchains, from Mutual Knowledge Systems, Inc., Apache 2.0 licensed. This is close enough to this project's own domain — a safety-focused DSL adjacent to blockchain and identity work — that adopting "Glow" for the fused Rye-Hoon language risks real confusion, not just a trademark footnote. **This document does not recommend "Glow"** for that reason, and leaves the actual naming choice open rather than substituting a pick of its own.

## The Four Proposed Kernel-Variant Names

Kaeden's ask: instead of one kernel called "Arvo" (or a single Rye-parallel), have **four switchable kernel variants**, like choosing among dual/tri/quad-boot options — named `Riyo`, `Reya`, `Trey`, and `Tera`. Collision research on each, as of this search:

| Name | Finding | Read |
|---|---|---|
| **Riyo** | No programming-language or kernel use found. A React Native CLI tool, a chat-bot project, and a GitHub username all use the string casually, none in this project's domain | **Low collision risk** — genuinely quiet as a name |
| **Reya** | A real, prominent collision: **ReyaChain / ReyaCore**, a based-rollup DEX on Ethereum with its own Rust-based trading engine — directly in the Ethereum/DeFi space this project's own Azimuth/Comlink integration work already touches | **Real external collision**, and a closer-to-home one too: this project's own `RIO3.md` already names **Reya 2** as "the prior identity note" — the voice Rio 3 succeeded. Choosing `Reya` for a kernel variant would collide with this project's *own* naming history, not only an outside project |
| **Trey** | No operating-system or programming-language use found; a common given name and card-game term only | **Low collision risk** |
| **Tera** | No operating-system or programming-language use found as an exact match; "Terra" (a real, different, existing C-like language using Lua for metaprogramming) is close enough in spelling to warrant a second look before settling, though it is not identical | **Low-to-moderate risk** — worth a closer, narrower search before this name is seated, given the near-miss with "Terra" |

**The clean recommendation from this research:** `Riyo` and `Trey` are genuinely quiet and available. `Reya` carries a real double collision (external DeFi project, and this project's own retired voice-identity name) and is worth reconsidering. `Tera` is probably fine but deserves one more narrow check against "Terra" specifically before being seated.

## What Four Switchable Kernel Variants Would Actually Mean

Naming aside, this is a real architectural proposal worth stating plainly: rather than one kernel (Arvo's role, in this fork's own naming-mapping proposal), boot-time-selectable variants — the same tree, the same Rye/Hoon-fused language, but different kernel policy or composition, switchable "like dual/tri/quad-booting." This is a genuinely new design surface, not a naming exercise: it implies either (a) four separate kernel builds sharing a common boot menu, or (b) one kernel with four selectable configuration profiles loaded at boot. Which of these two shapes Kaeden actually means is worth confirming before any of the four names gets real code behind it — this document does not assume which, and proposes neither as decided.

## What This Document Does Not Do

- It does not rename Rye, or any module, to anything proposed here.
- It does not decide between the "four separate builds" and "one kernel, four profiles" architectures — that is a real fork needing Kaeden's word.
- It does not perform the deeper trademark-registry search (USPTO/WIPO formal filings) that a name genuinely headed for public release would eventually want — this is web-search-level collision-checking, appropriate for an early naming pass, not a legal clearance.

---

*May every name we finally choose be quiet enough in the world to be ours alone, and may we notice the near-misses before they become someone else's confusion.*
