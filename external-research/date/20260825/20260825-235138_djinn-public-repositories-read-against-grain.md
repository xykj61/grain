# DJINN's public repositories, read against Grain

**Stamp:** `20260825.235138`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding, read `2026-08-25` via the GitHub API and the live pages; the design lead these findings serve is DJINN's (custody gate %6)
**Kin:** [`../active-designing/20260825-233309_the-bit-design-system-season-opens.md`](../active-designing/20260825-233309_the-bit-design-system-season-opens.md) -- [`../active-designing/20260825-235725_the-ascii-cloth-front-door.md`](../active-designing/20260825-235725_the-ascii-cloth-front-door.md) -- [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

## What this is

DJINN -- the pseudonymous collaborator who leads the Bit Design System, writing publicly as
GitHub [`@bit-trading-company-administrator`](https://github.com/bit-trading-company-administrator)
-- keeps four public repositories, all in the **Bit-Trading-Company** organization (a
GitHub-verified domain, created 2025-08-23). Every read below was taken `2026-08-25`. The
account and every commit identity are company-branded throughout; the profile carries no
personal name, which is its own small proof that the pseudonym discipline holds end to end.

One resonance worth keeping: on `2026-08-23` DJINN wrote publicly that they add *"and don't be
too smart about it"* to their own prompts -- the exact sentence that is Gauge Style's first rule
here. Two trees, one taste.

## The four repositories

| Repository | What it is (pushed `2026-08`) |
|---|---|
| `Bit-Trading-Company.github.io` | The company site, `bit-trading-company.com` -- a single 22 KB page rendered largely in ASCII art, with layered character chrome and careful no-JS fallbacks. The copy is placeholder, a work in progress by DJINN's own word. |
| `ase.lat` | A gated front door for an internal AI-research surface: canvas-rendered ASCII wordmark, a hidden tuning panel with dotted-key parameters, and a boot path that restores the page unconditionally after 2.5 s so a failed script can never leave it blank. |
| `shadow-v2` | A read-only prediction-market signal terminal on a character grid. Fully static; the browser fetches public APIs directly; no keys anywhere, and nothing on the page can place an order. |
| `scape.com.de` | SCAPE, a mountable ASCII/canvas intro-animation component -- the one un-minified repo. A grouped, defaulting config file; press T to tune live, export, and paste the result over the whole file. |

## Where each fits Grain

**SCAPE -> Brushstroke** is the best code-level fit: a self-contained, heavily parameterized
paint component whose grouped config reads like a draft `.brush` tunable schema, and whose
tune-then-export loop is a lovable design-iteration mechanism worth studying for Brushstroke
tooling. **shadow-v2 -> Skate** is the closest living cousin of a Skate surface: a read-only
character-grid terminal end to end. **ase.lat -> Pond** is a front-door lesson -- the
never-blank boot guarantee is exactly the first-contact resilience an onboarding door wants.
**The company site -> Linengrow** rhymes in its language: instrumentation as things both
parties look at on one screen, continuation repriced on a fixed cadence -- visible receipts
and transparent mechanism, publicly worded.

**Honestly no fit yet:** Comlink, Mantra, Caravan, Tally, Tablecloth, Rye, Rishi, Amphora,
Brix, Dimeroll. The portfolio is surface work -- brand worlds, terminals, motion systems --
and the systems side of Grain takes nothing from it today. That is a clean seam, and a happy
one: the collaboration meets exactly where the WADE ladder points, at the surface.

## The one caution

None of the four repositories carries a license, so the code is all-rights-reserved by
default. Under the clean-room discipline these are **read-for-concepts sources at most** --
the SCAPE config vocabulary, the boot-fallback pattern, the trust-by-construction copy --
and never code to copy. Concepts enter through the clean room; bytes stay home.
