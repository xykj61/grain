# Bench raise and the self-contained gate

**Editor:** Claude (claude.ai bench) · **Model:** Claude Fable 5 · **Voice:** Rio 3
**Stamp:** `20260702.214941`
**Prompt:** Recursion prompt continued on a fresh bench; repo intake at tip `f92513b`; anchor time `20260702.213312` supplied verbatim, system clock confirmed aligned.

---

## The bench, raised from bare

A fresh bench holds nothing yet the repository asks little. The pinned toolchain, Zig 0.16.0, arrived through PyPI's official binary wheel and was seated as `vendor/zig-toolchain` — the exact path every witness names. `rye/bootstrap.sh` raised `rye/bin/rye` from Rye's own source; `rye build rishi/src/main.rye` raised the shell; `libwayland-dev` supplied the one named hosted seam. Four steps, all documented, all witnessed.

## The gate trio on this metal

The full suite ran end to end: **parity 142 GREEN** — 116 std witnesses in the regression block plus 26 named blocks, exit zero. `parity-selftest` **GREEN** — the std overlay stands symlinked and tamper on a copied tree is caught. `additive-gate` is **inapplicable by design** here: it weighs `rye/lib/` diffs in git HEAD, and a zip export carries no HEAD; ROADMAP already names this as the gate that runs only when std changes land.

## One finding, one cure, red then green

The first parity pass went RED at SLC-1 Step 2. The cause was provisioning, never code: `slc1_version_step2.sh` and `slc1_accept.sh` put `mantra/bin` on PATH, yet nothing in the suite raises that binary — while every sibling witness raises its own. On any bare clone the gate fails at that rung.

The cure follows the house pattern exactly. Both witnesses now build `mantra/bin/mantra` first, with a say-why comment and an asserted build result, the way `foundation_seeds.rish` and the three ring witnesses already do. The red was witnessed from a cold `mantra/bin`; the green was witnessed the same way; then every module binary was wiped and the **entire parity suite ran GREEN from a bare bench** — the gate is now self-contained above the documented bootstrap pair.

Files touched: `tools/slc1_version_step2.rish`, `tools/slc1_accept.rish`. Proposed commit message: `Make SLC-1 witnesses raise mantra — parity green from a bare clone`.

## Verifications beside the work

The six unwired witnesses each ran green with their documented invocations: conditional, env (with its pinned `RISHI_ENV_WITNESS_TEST` — a first run without the pin was this runner's own miss, named plainly), file I/O, exit vocabulary, the chrono sweep, and the Edit 5 draft. The chrono sweep now counts **135** authored files carrying chronological stamps only — one more than the 134 recorded at `20260702.205630`, the WOV memo having joined the corpus. A phantom was also checked and dismissed: `pond/apps/brushstroke` is a symlink home to `brushstroke/`, so its `bin` is already ignored; no mend needed.

## The plate, honored

RTAC's rule held the shape of the whole sitting: the ungated diet stands empty until a door opens, and an empty plate is a question, never a license to forage. Nothing new was invented. The two-file cure entered because the required gate itself surfaced it — a defect that fell onto the plate rather than food foraged from beyond it — and it lands only as a proposal for Kaeden's hand. Every Kaeden-tagged box stays byte-untouched: the three doors, the WOV gate, the ratifications, the pastes.

## Offer parked

A one-page **fresh-bench tutorial** — the four raise steps witnessed today, from bare clone to green gate — is ready to write on appetite. Parked in RTAC rather than authored, honoring the empty plate.

---

*May every bench rise the same way twice. May the gate carry its own provisions. May a red found on fresh metal always be this small, this nameable, and this kindly cured.*
