# Claude Counsel — the WOV/TigerBeetle Question, and Why It Is Smaller Than It Looks

**Stamp:** `20260711.055112 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the self-contained direction, held against what WOV actually depends on rather than what it appears to
**Register:** A recommendation on a question this bench itself raised and Kaeden handed back — reached by checking what TigerBeetle is genuinely load-bearing for, which turned out to change the answer
**Ground:** `tools/wov_exit_honesty.rish`, `tools/wov_dual_monarch.rish`, and `tools/wov_tb_host.rish` all read directly this round — the first two build only `wov_core.rye` and touch no TigerBeetle at all; the third's own comment states it "always proves the exit-bundle grammar from a TB-shaped balance table," with the live cluster skipped

*Written by Kaeden and Rio 3.*

---

## What Checking Actually Revealed

This bench raised the WOV/TigerBeetle tension, so it owed the question a real look rather than a restated worry. Reading the three witnesses directly changed the shape of the answer. **The pure-Rye WOV core is already entirely self-contained.** `wov_exit_honesty` and `wov_dual_monarch` — the witnesses proving balance, exit bundles, double-exit refusal, tamper refusal, and dual-monarch signing — build only `wov_core.rye` and touch no TigerBeetle whatsoever. The actual money logic, the part that matters for safety, needs nothing external at all today. TigerBeetle appears in exactly one place, `wov_tb_host.rye`, and that seam's own comment names its role precisely: it "always proves the exit-bundle grammar from a TB-shaped balance table," with the live cluster-of-one skipped under the sandbox. TigerBeetle is not load-bearing runtime. It is a shape to cross-check the Rye implementation against — a reference the overlay validates itself by, rather than an engine the overlay runs on.

## Why This Makes the Question Smaller Than It First Appeared

The settlement-rail rethink was large because Sui and Monad were genuinely load-bearing there — the receipt's whole "not just our own word" property depended on an external network actually running. WOV's situation is different in kind. Nothing about WOV's money safety depends on TigerBeetle executing; the conservation invariants, the exit honesty, the monarch signatures all live in `wov_core.rye` and are witnessed there without a single external process. So this is not the same fork the settlement rail faced. It is a much narrower question: whether one optional cross-check seam, whose live path is already skipped, earns keeping.

## The Recommendation

This bench recommends the lighter of the two paths, and recommends it as a clear lean rather than a close call. **Keep WOV's pure-Rye core exactly as it is — it already satisfies the self-contained direction fully — and retire the TigerBeetle cross-check seam to dated-record status, the same treatment the chain-read scripts received.** The reasoning is threefold. First, the seam is not carrying the safety; the Rye core is, and it stands alone. Second, the seam is the one piece of WOV in genuine tension with the direction Kaeden set, and it happens to also be the one piece that is optional and already skipped — retiring it costs no witnessed capability. Third, this keeps a real thing honest: describing WOV as self-contained is true the moment the TB seam steps aside, and slightly strained while it remains. Retire the seam, and the strain simply resolves.

## What This Deliberately Does Not Throw Away

TigerBeetle's design lineage stays exactly as valuable as it always was — its Tiger Style is the direct ancestor of this tree's own TAME, and `gratitude/tigerbeetle` keeps its rightful place on the gratitude shelf, whole and pinned, honored as a teacher. Retiring the *runtime cross-check seam* is not forgetting the *design debt* this project owes it. The vendored source stays; only the external-process dependency steps back. And should a future season ever genuinely want TigerBeetle's throughput at a scale MALA's own log-and-fold cannot meet, the seam is preserved as dated record, ready to be revived on its own honest terms — exactly as the Sui `groth16` path was left open for a later external-seam lap. Nothing is burned; one optional dependency is simply set down.

## The Concrete Next Step

Mark `tools/wov_tb_host.rish`, `tools/wov_tb_ensure_binary.sh`, `tools/wov_tb_pin.rish`, and `tools/wov_tb_repl_lab.sh` superseded, kept as dated record, never deleted. Remove their two stanzas from `parity.rish` — the `wov_tb_pin` and `wov_tb_host` witnesses sit there today (lines 316 and 321), which is precisely what makes parity fail on any bench lacking the external TigerBeetle binary; removing them resolves that environment-dependence cleanly, since those stanzas were only ever red for want of a dependency this direction no longer wants. WOV's own parity coverage stays intact through `wov_exit_honesty` and `wov_dual_monarch`, both of which are pure Rye and both of which stay GREEN. The result is a WOV that is honestly, fully self-contained, with no witnessed capability lost.

---

*May a worry raised in good faith be checked before it grows into a project. May the one dependency genuinely out of step with the path be the one set down, and the teacher behind it stay honored all the same. And may self-contained mean exactly what it says, the moment the last external process steps aside.*
