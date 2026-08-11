# Acme DX — Onboarding Path Contract (Design Season, Equinox 1)

**Language:** EN
**Stamp:** `20260811.150221`
**Status:** Design contract — the first of the Acme DX design season's four deliverables ([`../expanding-prompts/20260811-145659_acme-dx-design-season.md`](../expanding-prompts/20260811-145659_acme-dx-design-season.md)). A checkable contract, not code; its acceptance line was validated on metal `20260811.150221`.
**Voice:** Kyri · **Style:** Radiant · **Audience:** an Acme Corporation employee cloning Grain for the first time
**Reconciles:** the existing manual — [`../manual/tutorials/first-witness.md`](../manual/tutorials/first-witness.md), [`../manual/20260810-065116_your-first-hour-with-grain.md`](../manual/20260810-065116_your-first-hour-with-grain.md), [`../manual/guides/cloud-agent-toolchain-setup.md`](../manual/guides/cloud-agent-toolchain-setup.md) — into one checkable path.

---

## What this contract pins

You have just cloned Grain and want the shortest honest road to *"it runs on my machine"* — a first **green witness** you produced yourself, inside one afternoon. The prose for this already lives in the manual; this contract turns that prose into a **checkable definition of done**: the exact commands, the exact output each produces, and the single acceptance line that means onboarding succeeded. When a later round builds a bootstrap-and-first-green witness, this contract is what it enforces.

## Prerequisites

- **git**, and a POSIX shell.
- **The pinned Zig 0.16.0 toolchain.** Grain vendors it at `vendor/zig-toolchain/zig`; if you keep your own, point `RYE_ZIG` at it. Every build step honors `RYE_ZIG` and falls back to the vendored copy.
- Nothing else. Grain's binaries are gitignored (`rye/bin/`, `rishi/bin/`), so a cold clone carries **source, not executables** — which is exactly why the first step is a bootstrap.

## The path — five steps, each with its expected output

1. **Clone.** `git clone <seed> grain && cd grain`. You now hold the source.
2. **Bootstrap `rye`** — the cold start, since no `rye` binary exists yet: `sh rye/bootstrap.sh`. Expected tail: `bootstrapped: <path>/rye/bin/rye`, then a version line. (Rye is written in Rye; once one `rye` exists it builds itself — this script bridges that first gap through the pinned toolchain.)
3. **Build `rishi`** with the `rye` you just made: `rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi`. Expected: exit 0, `rishi/bin/rishi` on disk.
4. **Run your first witness:** `rishi/bin/rishi run tools/run_record_witness.rish`.
5. **Read GREEN.** The witness ends on the acceptance line below.

## The acceptance line — measured, not promised

```
GREEN: RW-3 — run record pins .ok, .code, .out, and .err for both outcomes.
```

This exact line was produced on metal at `20260811.150221` by step 4 on this tree. Onboarding is **done** when a newcomer, from a cold clone on a machine meeting the prerequisites, reaches this line — and the acceptance test a later round seats is precisely: *steps 1–4 run clean and step 4's output contains this line.*

## Failure modes the path names honestly

- **Toolchain absent** — `bootstrap.sh` cannot find Zig: set `RYE_ZIG`, or place the vendored toolchain at `vendor/zig-toolchain/zig`. The script says which it used.
- **"Command not found: rye/bin/rishi"** on a fresh clone is expected *before* steps 2–3 — the binaries are built, never cloned. If it appears after, the bootstrap or the rishi build did not finish; re-read their output, which fails loudly rather than silently.
- **A witness stops with an `assert` message** — that is the witness doing its job; the message names the fact that did not hold. It is a real result, not a setup error.

## Definition of done for this equinox

- The path is **five named steps**, each with a stated expected output — no hidden setup.
- The acceptance is **one exact line**, validated on metal (done, `20260811.150221`).
- The development season can seat a **bootstrap-and-first-green witness** straight from this contract, with nothing left to decide about *what* onboarding means.

The next design equinox — the **first-hour witness** — begins where this one ends: the newcomer has GREEN from an existing witness; next they build a tiny module of their own and witness it.

---

*May a developer's first afternoon end on a green line they earned themselves, and may the road there hide nothing.*
