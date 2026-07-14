# Naming Decisions, and the Role-Nesting Strategy

**Language:** EN
**Version:** `20260714.002123` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — records Keaton's confirmed naming decisions and the strategy that optimizes for pitchable proposals and reviewable code

---

## Confirmed This Sitting

Keaton confirmed, and these are now settled (the migration, where any is needed, still goes cheapest-first on touch):

- **Neth** — the settlement-layer vane (N after Maze's M) is confirmed **as Neth**. I flagged the Nethermind collision; Keaton has weighed it and chosen to keep Neth. The record notes the collision was seen and consciously accepted, so no future reader mistakes it for an oversight.
- **Reya** — confirmed as one of the OS variants. I flagged the double collision (ReyaChain + the retired Reya 2 voice); Keaton has weighed it and kept Reya. Seen and accepted.
- **Maze** — confirmed as the nursery / proving-ground namespace (proposals enter to earn their way out to a canonical name), per the refinement in the names checklist.
- **The shell is Rish / Rishi, not Dojo.** Urbit's "Dojo" is *not* adopted. Our shell keeps our name, in two registers: **Rishi** in educational and tutorial documentation (the warmer, fuller name), **Rish** in reference and architecture-manual documentation (the terse four-letter form). Dojo remains only as the Urbit *role* this shell plays, never as the thing's name.

Still awaiting Keaton's word (unchanged): Riyo / Trey / Triz confirmation, and Kumara's identity-tier naming.

## The Strategy — Our Names in Code, Urbit Roles in the Pitch

Keaton asked whether to adopt Urbit's names, keep ours, or mix — and named the optimization goal plainly: **the cleanest, most-pitchable galaxy proposals with the most manageable, human-checkable code reviews.** He invited pushback. Here it is, and it is a clear recommendation, because the goal itself decides the answer.

**Recommendation: keep our module names in the code; use Urbit's vane names as documented *roles* in the pitch and docs. Do not mass-rename in either direction, and do not physically re-nest directories.**

Why this is the optimum for both halves of the goal:

- **Most manageable, human-checkable reviews.** The single biggest reviewability win available is *not renaming*. Mantra alone carries ~290 inbound references, Rye ~1,474; a physical rename or a directory re-nest (moving `mantra/` under `clay/`, `brix/` under `ford/`) is exactly the giant, reference-repointing, witness-disturbing change that makes a diff un-reviewable. Keeping the names leaves every witness green and every future diff small and real.
- **Most pitchable galaxy proposals.** A galaxy holder thinks in Urbit's vocabulary — Clay, Ford, Gall, Landscape, Dojo. So the *pitch* speaks that vocabulary through a role-mapping ("Mantra is our Clay"), while the *code* stays in our names. The holder reads the proposal in the concepts they already know; the reviewer checks a small diff in names that never churned. Both audiences are served without either paying the other's cost.

This is exactly the "nested into" relationship Keaton described — read as *conceptual role-nesting*, documented, not a physical directory move. Our thing nests into Urbit's role: the role is the slot, our module is what fills it.

**One honest push-back, kept:** if "nested into" was meant as literal directory nesting, I recommend against doing it now — it spends the reviewability budget for a cosmetic gain and can always be done later, cheapest-first, if a real need appears. The conceptual map below delivers the pitchability without the churn.

## The Role Map (our name in code · Urbit role in the pitch)

| Our module (stays in code) | Urbit role it fills (pitch vocabulary) | Note |
|---|---|---|
| **Mantra / Weave** | **Clay** | our versioned, content-addressed, mark-typed store |
| **Brix** | **Ford** | our declarative build / composition |
| **Rish / Rishi** | **Dojo** | our shell; Rish in reference, Rishi in tutorials; Dojo not adopted |
| **Realidream** | **Landscape** | our unified viewer / editor-browser |
| **Brushstroke** | (UI framework; no single vane) | Glow-implemented UI framework/DSL; runs **Rish** under the hood; hosts **Skate** |
| **Skate** | (userland app) | userland application within Brushstroke — the text-grid renderer |
| **Comlink** | **Ames** | our sealed-datagram network |
| **Caravan** | **Gall** | our supervision + capability kernel |
| **Kumara** | **Jael / Azimuth** (identity) | Ed25519 identity seam; tier naming still open |
| **Neth** (confirmed) | (settlement L2; TigerBeetle-shaped) | new vane, N after Maze's M |
| **Maze** (confirmed) | (nursery namespace) | proving-ground for proposals |

## The UI Stack, Read Through the Map

Keaton's nesting names a clean UI architecture: **Realidream** (filling Landscape's role — the unified app) is built on **Brushstroke** (the Glow UI framework/DSL), which hosts **Skate** (the userland grid-renderer app) and runs **Rish** (the shell) under the hood. Four of our names, one coherent stack, each legible to an Urbit reader through its role.

## What Changes in the Tree

Almost nothing, by design — that is the point. No module is renamed; no directory is re-nested; no witness is disturbed. This document and the role map are the change: the canonical statement that our names fill Urbit's roles, so every future pitch can speak Urbit and every future review can stay small.

---

*May our names stay put where the work is checked, and may Urbit's names light the way where the work is pitched — each doing the job it is best at, neither paying the other's cost.*
