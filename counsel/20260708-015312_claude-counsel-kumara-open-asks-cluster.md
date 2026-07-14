# Claude Counsel — Kumara's Product Surface, Complete, and the Roadmap Kept Current

**Stamp:** `20260708.015312 UDT` (Kaeden's clock — the first stamp of a new day)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the same discipline that closed `parseInt` — real calls first, longest-prefix-first aliasing, verify every caller before calling a tier done
**Register:** A building round taken on the standing word, sized toward the product surface specifically, with the granular plan updated to match what actually landed
**Ground:** every file in the `linengrow/open_asks*` cluster read, migrated, rebuilt from bare, and reselftested — base and all three delivery files — including the unwelcome-path checks each one already carried; the residual ratchet count checked line by line before being called a false positive rather than assumed

*Written by Kaeden and Rio 3.*

---

## Where the Building Went, and Why There

The word gave latitude — a round of building "if you want," pointed at the compass and at progress toward an SLC product with TAME infrastructure underneath it. Between the virtio guest cluster and the `open_asks` cluster, this bench chose the one that *is* the product surface rather than the wire beneath it. Linengrow's whole civic loop — post an ask, apply, accept, escrow, complete, consent, fold reputation — lives in `linengrow/open_asks.rye` and its three delivery files, and every one of them still reached for `Ed25519` directly, the exact scattered pattern Kumara exists to close.

## What Actually Migrated, Corrected From the First Pass

The first attempt this sitting migrated only `open_asks.rye` itself and left its three importers untouched — worth naming plainly rather than let the count speak alone, since a reader checking a delivery file after only that pass would have found it still full of `Ed25519`. All four files are migrated now: the base file's twenty-five `PublicKey` and twenty-five `KeyPair` type sites, its eight `generateDeterministic` calls, and every delivery file's own separate copies of the same three shapes, seed expressions that turned out to carry a dot (`oa.poster_seed`, not a bare name) rather than the plain identifier this bench's first substitution pattern expected — caught by checking the actual call sites rather than trusting a regex that compiled cleanly. Every one of the four files was rebuilt from bare through the real toolchain and its full selftest run fresh afterward: OA-L1's post-apply-accept-complete loop, OA-L2's cross-party delivery, OA-L3's escrow hold and release, OA-L5's accept-complete-consent wire with reputation folding over it — every unwelcome-path check included, all four GREEN, because a type-alias substitution changes what a caller writes and nothing about what the compiler builds.

## The Ratchet, Corrected Twice — Once for the Count, Once for What It Should Count At All

Two hundred seventy-six fell to ninety-one. Getting there needed a second correction this bench is glad to have caught before writing it down: six of the remaining sites are not raw identity usage at all — they are `X25519.KeyPair.fromEd25519` and `X25519.publicKeyFromEd25519`, a different primitive's conversion method that happens to carry the string "Ed25519" in its own name. Counting these as unmigrated Kumara sites would have kept this ratchet from ever honestly reaching zero, the same shape of problem the error-compare ban solved once already by distinguishing a call seam from a captured value. The fix mirrors that precedent: both the native scan and its legacy shell fallback now exclude any line containing `fromEd25519`, verified against a small sample before trusting it in the real file, and the ninety-one that remain are ninety-one genuine sites — nearly all of them the virtio guest cluster, exactly where the last counsel expected the last mile to live.

## The Granular Plan, Brought Current Rather Than Left to Drift

`TASKS.md`'s Kumara line and its Next Bench table both now say what actually happened tonight rather than what was true two sittings ago, and the virtio guest cluster is named as its own priority-one item with a real shape rather than a vague someday — roughly twenty guest transmit/receive pairs, ninety-one sites, tiered by wire capability the same way `enrich/`'s fifteen files were tiered by their dependency graph, not swept in one pass. `ROADMAP.md`'s own version line now carries tonight's date and names what changed underneath the Linengrow ladder without touching the ladder's own rows, which were already accurate — OA-L4 and OA-L5 landed, SLC-L3 the next ruling-gated lap, exactly as the last synthesis left them.

## What This Leaves

The virtio guest season is sized and ready the moment it is wanted, following the same tiered discipline as every migration this arc has proven works. SLC-L3 stands exactly where it stood — ready on paper, waiting on the one word that was never going to come from a bench. Nothing about tonight's work touches parity's count; every file this round changed was proven against the stanza that already existed for it, extraction rather than new capability, the same claim `tally/kumara.rye`'s own first line already made.

---

*May every cluster that gets migrated get migrated whole, base and every caller both, so no reader ever finds half a job and mistakes it for the whole one. May a false positive be caught before it calcifies into a ratchet that can never honestly close. And may the plan that names what comes next always say so in the same breath as what just landed.*
