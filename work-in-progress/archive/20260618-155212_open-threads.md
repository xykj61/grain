# 998 · Open Threads — As of 2026-06-18

*A faithful gathering of where the work stands: one task in hand, a few questions waiting on Kaeden, a roadmap offered and not yet walked, and one old bit of housekeeping still ajar. Funneled from a stock-taking on this date, so nothing slips.*

**Language:** EN
**Version:** `20260618.155212` (Rye chronological stamp)
**Last updated:** 2026-06-18
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Status:** Snapshot (the newest open-threads gathering)

---

## One Task Chosen, Still in Hand

- **The negative self-test for the parity gate.** When the parity gate (`tools/parity.sh`) was built, this was chosen as the next step — deliberately perturb a value so the gate turns **red**, proving that its green means something — and then the work wandered happily into shells and voices before it was done. It remains the smallest, highest-trust next move: a gate we have not seen fail is a gate we do not yet fully trust.

---

## Questions Awaiting Kaeden

- **The name `9999_STRENGTHENING`.** Kaeden proposed `TAME_STRONG` and asked "like that name?"; Reya chose `STRENGTHENING` for stack-consistency and promised to rename on a word. That word has not come. Keep `STRENGTHENING`, or switch to `TAME_STRONG`? A one-line rename either way.
- **`Brook`, and the unnamed orchestration language.** In `989`, *Brook* was floated for the interactive shell "to argue over, not a decree," and the execline-spirit orchestration language was left unnamed. Both await a blessing or a fresh coinage.
- **The strategic fork.** Raised in the compiler critique and still undecided: is Rye's destination *a hardened Zig dialect* or *a genuinely separate language*? The recent direction (the `989` family) leans toward "separate," yet it has not been said outright — and the choice relocates where the real compiler work lives.

---

## Roadmap Offered, Not Yet Walked

- **The additive-only gate** (#1) — prove a strengthening pass changes only `assert` / `maybe` / comments, never behavior. The structural half is cheap; the semantic half wants a small language-aware check.
- **Vendor execline** — the near-term TAME bridge for our build scripts, per `990` / `991`; the path off Bash for the small, non-interactive tooling.
- **A minimal Mantra weave** — overlay, always-succeeding merge, and line-provenance. By the earlier reasoning, possibly the single highest-leverage thing for strengthening *at scale*, because it de-risks drift against the evolving baseline.
- **Promote the language family into active-designing.** The `989` family (Rye, Tablecloth, an orchestration language, Brook, Mantra, one value model) feels ready to cross from open research into the siloed design space — once the fork above is decided.

---

## Housekeeping Still Ajar

- **The `.gh` token.** A decision left open long ago: keep `./.gh` for future `gh` operations, or remove it and revoke the personal access token. Pure security hygiene — worth closing one way or the other.

---

## Resolved Lately, No Action Needed

- **The Verified badge.** The earlier worry about uploading the sandbox signing key for forge verification is settled: every commit shows green **Verified** on both forges, signed by `DBF853…`.

---

*May this gathering be honest, and soon out of date — because the way an open thread leaves this page is by being done. Until then, here it waits, plainly, so the next step is never lost.*
