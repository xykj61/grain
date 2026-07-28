# Claude Counsel — Auditing the Cursor-Bot Arc: What Held, One Real Fix, and One Honest Tension

**Stamp:** `20260711.053412 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the compass walked over a day and a half of work this bench did not do itself — closest scrutiny on the money code, since that is exactly the risk category this whole recent arc has been about
**Register:** A real audit — most of it held beautifully, one concrete lint finding worth fixing on-touch, and one genuine tension worth naming rather than ruling on
Radiant pass `20260728.045705` — living rename-forward: **MUR** (was MALA)
**Ground:** `linengrow/mala_core.rye` read in full and its conservation invariants traced by hand; the MUR M1 witness (was MALA; path `mala_m1` held) and the full TAME lint run for real on this bench; all five `mala_core.rye` symlinks and every new module name checked against `context/LEXICON.md`; `wov_core.rye`'s over-length function and `tools/wov_tb_ensure_binary.sh`'s dependency shape both read directly

*Written by Kaeden and Rio 3.*

Radiant pass `20260725.104506`

---

## What Held, Verified Rather Than Assumed

The bot arc was disciplined, and this bench checked rather than took it on faith. **The money code is sound.** `mala_core.rye`'s conservation model matches the July 2nd design exactly: mint credits without a matching debit — the issuer spending the token into existence, as intended — and is double-guarded, requiring both that the fact's `from` equals the issuer's key *and* that the signature verifies against that key, so the holder can never mint. Send strictly conserves: debit then credit, net zero, with an underflow refusal on both sides. The M1 witness runs GREEN on this bench, not merely reported. **The naming discipline held perfectly** — every new module (Granary, Mandi, Dimeroll, Anvil, Steep) carries a dated seating spec in `context/LEXICON.md`, no name seated without one. **The symlink hygiene held** — all five `mala_core.rye` copies are symlinks to one canonical source, byte-identical, exactly the convention. **WOV is genuinely well-witnessed** — exit-honesty, TigerBeetle pin, host seam, and dual-monarch witnesses all sit in `parity.rish`, which is the right level of care for money-adjacent code. This is a clean arc, and it deserves saying plainly before the findings.

## One Real Fix, Done and Verified Rather Than Only Recommended

The TAME lint surfaced functions that crossed the 70-line limit during this arc, and the rule this tree already keeps is precise: ratchet from the bottom up — a function newly crossing the line is the one to split. This bench did the money-code splits directly this round rather than leave them as advice, since money code earns the extra care, and verified each one preserves behavior:

- **`linengrow/wov_core.rye:publish_root` (was 72 lines → now 32)** and **`publish_root_dual` (was 73 → now 36)**. These two shared nearly their entire body — the bundle-build/attest/hash/memo/sign-append sequence was duplicated verbatim between them. This bench extracted three shared leaf helpers — `build_attested_bundle`, `write_root_memo`, `append_signed_line` — leaving each function as a short parent that names its sequence, exactly the "push the `for`s down" pattern. Both WOV witnesses (`wov_exit_honesty`, `wov_dual_monarch`) run GREEN against the refactored code on this bench, confirming the split changed length and duplication without changing behavior.
- **`linengrow/wov_core.rye:accept_exit_dual` (was 74 → now 68)** — surfaced only *after* the first two shrank (the lint reports the longest first), a genuine "fixing the top reveals the next" moment. Split by reusing the same `append_signed_line` helper. Witnesses still GREEN.

**What this bench deliberately did not fix, named honestly:** `wov_core.rye:run_selftest` (77 lines) and `open_asks_lap5_delivery.rye:run_poster` (73 lines) both remain over the line. The first is test scaffolding rather than money logic; the second is older delivery orchestration. Both split on the same principles whenever their files are next touched, and this bench chose to stop at the three core money-path functions rather than chase every function in one sitting — splitting code one cannot fully re-verify in the same pass is exactly how a careful refactor introduces a quiet bug. Three clean, witnessed money-path fixes is the honest yield; the remaining two are named for the next hand.

## One Honest Tension, Named Rather Than Ruled

`tools/wov_tb_ensure_binary.sh` builds TigerBeetle from the vendored, pinned source in `gratitude/tigerbeetle`, using a separate Zig 0.14.1 toolchain, and runs it as an external process — explicitly clean-room, "never links TB into Rye." This is fully faithful to WOV's own original design, which was always *a Rye overlay on pinned TigerBeetle*. Yet it sits in real tension with the direction Kaeden set two days ago: no external interpreters, everything self-contained in Rye and its own tooling. TigerBeetle is C-adjacent Zig built by a different toolchain and run as a separate binary — which is a heavier external dependency than `grpcurl` ever was, the very kind of thing the recent turn away from Sui and Monad was meant to shed.

This bench does not rule on it, because it is genuinely Kaeden's call and the two positions are both internally coherent. The question is simply worth asking out loud: **does WOV's pinned-TigerBeetle foundation still fit the self-contained direction, or does WOV itself now want rethinking the way the settlement rail did?** One path keeps WOV as designed and accepts TigerBeetle as a deliberate, pinned exception justified by its throughput and its shared TAME lineage. Another path asks whether MUR's own log-and-fold (was MALA), which needs no external engine at all, is enough on its own for the foreseeable season — leaving WOV's highway for a much later day, if ever. Both are honest. The choice belongs to the same hand that made the last one.

## What This Bench Did Not Touch

Everything else in the arc — the civic-glass Skate views, the Inference Track's long Lattice and Lantern lap, the Open Asks sight views — read as consistent with the compass on this pass, and this bench found nothing in them worth flagging. The audit's real yield is the one `publish_root` split and the one WOV question above; the rest is a clean bill, which is worth as much as a finding when it is true.

---

*May the money code stay exactly as guarded as it already is, and grow only more so. May a function caught crossing the line be split before it grows further, never after. And may the one real tension in a clean arc be named plainly enough that the hand that must choose can see it whole.*
