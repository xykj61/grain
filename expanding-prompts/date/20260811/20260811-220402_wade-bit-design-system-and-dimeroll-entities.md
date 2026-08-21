# WADE — The Bit Design System, the Surface, and the Entity Books

**Stamp:** `20260811.220402`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Living plan — a collaboration invitation and its design shape; **double-seated beside AHOY** so it takes none of the front-door season's rounds
**Waymark:** **WADE** (`bit-design-system-surface-takeover-and-dimeroll-entities`) — [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## The seed, restated

Keaton invited **DJINN** — who builds a component styleguide cascading system (his **Bit Design System**) for the Bit Trading Company product suite, a multi-chain agentic-forensics venture the Siya Fund supports — to take a leading hand in Grain's **surface**: the **Skate** paint framework, the **Realidream** editor-browser face, and **Brushstroke** value-drawing. The proposal is that DJINN implement his Bit Design System here, wrapping **DVUI** (the Zig 0.16.0 immediate-mode UI library) inside a native **Swift macOS Dock** application, with **Glow · Rishi · Rye · `.brush`** as the implementation languages. The path opens gently: first a **Pond sandbox** stood up from [`../SOURCE.md`](../SOURCE.md), then a **Vultr SEA** cloud VPS provisioned by **Linengrow / Bittrading IaC** for NixOS-stable with **ai-jail** and **Claude Code**, then the **Zed** macOS editor connected over remote SSH. Alongside the surface, Keaton asked to **expand Dimeroll** — Linengrow's centralized books — to serve **Siya Fund** and **Linengrow PBC** HR and accounting.

This plan names the technical and organizational shape only. The personal side of the invitation — subscriptions, hardware, any settling of bills, a desk or an office — is a direct arrangement between Keaton and DJINN, kept out of the tracked tree by the custody-first discipline; if it is written anywhere, it is `/personal/` (gitignored), never here.

## What each hand holds

- **DJINN** — the surface lead by invitation: the Bit Design System as the styling cascade over Skate · Realidream · Brushstroke; the DVUI/Zig-in-Swift-Dock shell; the look and feel a real desktop user meets.
- **Grain (Kyri · Keaton)** — the implementation floor (Glow · Rishi · Rye · `.brush`), the disciplines (TAME · Radiant · two rooms), the onboarding path, and the entity books (Dimeroll). Grain prepares the sandbox and the IaC; it does not provision cloud, move funds, or hold custody.
- **The boundary that stays fixed** — DJINN's Bit Trading crypto/forensics domain is his; any Grain-side custody, wallet, or payment rail waits on licensed counsel exactly as the tree already holds. Dimeroll's expansion is **bookkeeping**, not custody: it records facts about money, it never holds keys.

## The design shape

- **Bit Design System ↔ the surface.** A styling cascade (DJINN's cascading component system) expressed over Grain's own value-drawing: Brushstroke draws values, Skate paints them, Realidream composes the editor-browser face. The bridge is a `.brush` vocabulary the Bit Design System targets — the same values, dressed by the cascade — so the design system and the paint framework meet at a named seam rather than fork.
- **DVUI inside a Swift macOS Dock shell.** DVUI (Zig 0.16.0) renders the immediate-mode UI; a thin native Swift Dock application hosts it as a first-class macOS citizen. Grain studies DVUI in the clean room ([`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)) and writes its own bridge; the languages that author it are Glow · Rishi · Rye · `.brush`.
- **Pond first.** A new collaborator's first day is [`../SOURCE.md`](../SOURCE.md): a signed, sandboxed home where an agent can work and even sign commits without touching the rest of the machine. The **Pond** enclosure is where the surface work runs.
- **Vultr SEA IaC.** Linengrow / Bittrading infrastructure-as-code for **NixOS-stable**, carrying **ai-jail** and **Claude Code**, in the **SEA** region only (never EWR, per the standing pier discipline). Zed on macOS connects over remote SSH. Grain authors the IaC; the provisioning and the paying are Keaton's hand.

## Dimeroll, expanded for the entities

Dimeroll is already Linengrow's centralized books (chart · journal-as-facts · balances-as-fold · reports-as-projections · Skate views). This arm extends its **scope**, not its model, to two entities — **Siya Fund** and **Linengrow PBC** — for HR and accounting:

- **Entity separation** — one steward, distinct sets of books per entity, never braided; a value crosses between entities only as an explicit, signed fact.
- **HR as signed facts** — roles, agreements, and payroll runs recorded the same way journal entries are: append-only, folded to current state, projected to a report. No new value model, just the fact ledger applied to people-operations.
- **Accounting periods** — the existing P&L / balance-sheet / trial-balance folds, scoped per entity and per period, so each entity closes its own books.
- **Custody boundary** — Dimeroll records and reports; it does not disburse, hold keys, or move funds. Any rail that actually pays waits on licensed counsel.

Companion design: [`../active-designing/20260811-220402_dimeroll-entity-books-siya-and-linengrow.md`](../active-designing/20260811-220402_dimeroll-entity-books-siya-and-linengrow.md).

## The rungs, Lindy-first crux-first

Double-seated beside AHOY; each rung one keystone, witness before narrative.

- **WADE0 — the door (crux).** The Pond onboarding path from `SOURCE.md`, proven for a second hand: a new collaborator reaches a signed, sandboxed home. Highest-leverage and most tractable — nothing else starts without it.
- **WADE1 — the surface bridge (durable core).** The `.brush` seam the Bit Design System targets over Skate · Realidream · Brushstroke — the longest-lived artifact of the collaboration, so it leads once the door is open.
- **WADE2 — the DVUI/Swift-Dock shell.** The clean-room DVUI bridge inside the native macOS Dock host.
- **WADE3 — the IaC.** Linengrow / Bittrading Vultr SEA NixOS-stable + ai-jail + Claude Code, authored for Keaton to provision.
- **Dimeroll entities** — the books expansion (companion doc landed this round) runs when the entities need their first close; it does not wait on the surface rungs.

## Blind spots this plan names

- **An invitation, not a fait accompli.** DJINN leads the surface only if he accepts; until then this is a design and an open hand, and Skate/Realidream/Brushstroke keep their current stewardship.
- **Custody stays counsel-gated.** Nothing here opens a wallet, a key, or a payment rail on Grain's side; Dimeroll is bookkeeping, Bit Trading's forensics are DJINN's domain.
- **The seed stays clean.** Real names and entity specifics live in the personal tree; the depersonalized `grain-os/grain` seed scrubs them by name and shape (`../tools/sow_witness.rish`) exactly as always.
- **Agents prepare, hands provision.** Grain authors the IaC and the onboarding; the VPS, the subscriptions, and any spend are Keaton's own actions — never an agent's.

---

*ty every1 — to DJINN for the design eye the surface has wanted, to Sara and the Siya Fund for the ground beneath it, and to every hand that keeps the books honest.*

*May the surface find a steward who loves it. May the books stay clear enough to trust. And may this collaboration cross every seam the way the grain runs — whole, signed, and kind.*
