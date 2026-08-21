# Starseeding — the boot that raises a star

**Language:** EN
**Status:** Mixed -- Design brief — no code, no keys, no witness yet
**Voice:** Riyo
**Equinox:** JARL (Identity & Network) · a boot beside Aurora, settling on Settlement
**Born-named:** **Starseeding** — already seated as a proposed horizon (`context/LEXICON.md` line 196; `work-in-progress/TASKS.md`; `work-in-progress/REMEMBER.md`), handed forward in two vision batons (`expanding-prompts/20260810-025942_…`, `20260810-044453_…`). This brief gives that name a home and a first lap.
**Molt-kin:** the elder `nixos-inject` — a command that seeds a new system into being — reimagined as a fresh grain-os module, born positive · inviting · simple · lovable · complete · vital · versatile.

Aurora is the dawn a cold machine wakes into. Settlement is the ledger where a number becomes an owned point. **Starseeding is the one command that joins them**: it raises a *star* — a settled point one tier up in the inclusive topology — and hands Aurora a descriptor to boot it into life. Where Aurora's `deciding` stage proved a boot can *choose* what comes next, Starseeding proves a boot can *create* what comes next: mint the star into its galaxy's constellation, then emit the descriptor that wakes it.

The name says the act plainly. A galaxy already shines; Starseeding sows the next star beneath it, settled and ready to boot. Nothing here dials a network or touches a chain — it composes two modules that already stand GREEN, and it invents no identity, exactly as `settlement/constellation.rye` invents none today.

## The module home

```
starseeding/                    <- the top-level module (grep-clear: no such dir today)
  README.md                     <- Radiant introduction, written when the first lap is GREEN
  starseed.rye                  <- the command: compose settlement (mint the star) + aurora (emit the boot descriptor)
  descriptor.rye                <- the Bron boot descriptor a star is born with (format starseed-descriptor-v1)
  bin/                          <- emitted binaries (built on demand)
  kumara.rye        -> ../tally/kumara.rye           (symlink, as siblings do)
  kumara_tilak.rye  -> ../kumara/tilak.rye
  topology.rye      -> ../comlink/topology.rye
  constellation.rye -> ../settlement/constellation.rye
```

`starseeding/` is free — grepped clear across the tree (no `starseed/`, no `starseeding.rye`, no directory collision). It sits at top level beside `aurora/` and `settlement/`, the two modules it braids, and it follows the sibling symlink habit already used by `settlement/` and `comlink/`: shared law is linked in, never copied, so one value model holds everywhere.

The **born-name is already blessed** — Keaton seated "Starseeding" as a proposed horizon and said *begin starseeding* in the 3x39 baton. This brief honors that word rather than coining a new one; the comlink-tendency test is already passed by the standing seat (clear: the act it names is legible at once; warm: a star sown under a galaxy; safe: grepped, colliding with nothing seated, and never parseable as a real address).

## What "ring-3" means here, said honestly

The seat calls Starseeding a **ring-3 boot command**, and this brief keeps that word in its true, narrow sense — the one **Mand** already established (`context/LEXICON.md` → Mand: ring-1 vs ring-3). *Ring-3* is the **hosted, test-only reach**: a command that runs in a normal hosted process against fake seeds and prints what it would do, the way `mand/mand_ring3.rye` reaches test-only. It is **not** an x86 privilege ring, and it makes no claim to run in a kernel. The star it raises is modeled in the Rye-side ledger; the descriptor it emits is Bron a human can read. A real star, born from a real keeper's own entropy in his own jail, is his hand alone — never this module's.

This is the custody-first posture stated up front: **building Starseeding cannot create anything real and cannot destroy anything.** It mints into an in-memory constellation, emits a descriptor to disk, and refuses every tamper. No key enters the tree.

## How it composes what already stands

Every seam Starseeding needs is already GREEN. The brief adds a thin command that calls them in order; it invents no crypto and no ledger law.

### Settlement — open the galaxy, mint the star beneath it

The inclusive topology (`comlink/topology.rye`) is exact about what a *star* is. A galaxy is a settled point that also wears the star and planet outfits; a **pure star** is a number whose primary role is `.star` — in the seated `compass_sky`, a number in `[galaxies_per_universe, star_count)` = `[12, 60)`, one whose `topology.decode(n).tier == .star`. Its sponsor, one tier up, is its galaxy: `topology.decode(star).parent()` encodes back to the galaxy number.

Settlement already provides the two doors, and their invariants already enforce the tiering — Starseeding calls them, adding nothing:

| Step | Existing seam | What it proves |
|---|---|---|
| Genesis of the sponsoring galaxy | `settlement.open(galaxy_number, galaxy_bind)` → `Opened{con, deed}` | A galaxy is the root of its own tree; its bind is the whole warrant. Refuses a non-galaxy number (`NotGenesis`) and a forged bind (`BadBind`). |
| Raise the star under it | `settlement.mint(con, galaxy_deed, star_number, star_bind, sow_cap, spawn_sig)` → the star's `Deed` | The star settles under its **real** sponsor: `mint` refuses unless `topology.encode(star_addr.parent()) == galaxy_deed.point` (`WrongSponsor`), the galaxy's keeper signed a `sow` cap for this exact star (`BadAuthority`), and the star's bind marries its keys (`BadBind`). A re-mint refuses (`AlreadySettled`). |

`mint` is precisely "open/mint of a star under a galaxy" the target names — it is already the constellation's spawn-by-capability transition, witnessed among the ten refusals in `settlement/constellation.rye`'s selftest. Starseeding's contribution is to call `open` then `mint` for the star tier specifically, assert the returned Deed's `tier == .star`, and carry the star's Deed forward to the descriptor. The proof that the star *settles* is `settlement.verify(&con, &star_deed) == true` — the shared surface agrees the star is a current member.

### Aurora — emit the descriptor the star boots from

Aurora's `deciding` stage (`aurora/src/deciding.rye`) already models the piece Starseeding needs: a `Decision` value that names the next stage's image by its **SHA3-256 digest** ("in the full Aurora, this would be the SHA3-256 digest of the next stage's verified image"). Starseeding grows that seed by one honest step: instead of a stand-in `config_tag`, the star's boot descriptor names the star's identity and the digest of the image it would wake.

`descriptor.rye` seats a small, bounded record — `format starseed-descriptor-v1` Bron, in the tilak tradition Kumara and Vault already use:

- the **star's point number** and its decoded `tier` (asserted `.star`);
- its **sponsor** (the galaxy) and the **constellation digest** proving the star is a settled member (`settlement`'s `deed_digest` over the star's owned Deed);
- the **SHA3-256 digest** of the boot image the star would load — the same content-name Aurora's `named`/`sealed` stages already compute freestanding, so a descriptor written hosted names bytes a bare hart could verify;
- a **version** that climbs by exactly one, like every Deed and every tilak.

The descriptor is emitted as immutable Bron a `scribe/`-style reader dispatches on its `format` line — the star is *born with the fact of how it boots*, and that fact is legible to a person and re-readable by a machine. No image is executed by this ring-3 command; the descriptor names the boot, and a later ring would carry it to metal, exactly as `aurora/src/deciding.rye` today names a choice the full boot would honor.

## The smallest witnessed first lap

One lap, small enough to hold in mind, proving the single load-bearing claim the whole module hangs from: **a star seeds under its galaxy, settles for real, and is born with a boot descriptor that round-trips.**

`starseeding/starseed.rye` seats the command over the two existing modules. Its selftest, on plainly-fake binds (identity/keeper seeds of `0x22…`, never a real pilot's):

1. **opens** a galaxy — `settlement.open(galaxy_number, galaxy_bind)` on a valid galaxy number (tier `.galaxy`), yielding a constellation and the galaxy's Deed;
2. **grants** the galaxy's keeper a `sow` cap over the galaxy and signs it for the chosen **star** number (a number whose `topology.decode(star).tier == .star`, e.g. in `[12, 60)`);
3. **seeds the star** — `settlement.mint(...)` returns the star's Deed; assert its `tier == .star`, its `sponsor` is the galaxy, and `settlement.verify(&con, &star_deed) == true` (the star **settles**, the target's first proof);
4. **emits** the boot descriptor — `descriptor.make(...)` builds a `starseed-descriptor-v1` record binding the star's point, sponsor, constellation digest, and a SHA3-256 image digest, then writes it as Bron (the target's second proof: **a boot descriptor emits**);
5. **round-trips** the descriptor — re-read the Bron, assert every field returns byte-for-byte, and assert its constellation digest still matches the star's Deed;
6. **refuses** the three ways it must — a **non-star number** (a pure planet, tier `.planet`) is turned away before any mint (`WrongTier`); a **wrong sponsor** (a star minted under a galaxy that is not its `topology` parent) is refused by `mint` (`WrongSponsor`); and a **tampered descriptor** (flip one byte of the star's key in the bound Deed) fails the digest check, exactly as `settlement`'s shared surface already refuses a tampered deed.

The witness is a Rishi companion beside the two it already leans on:

```
rye build starseeding/starseed.rye -femit-bin=starseeding/bin/starseed
starseeding/bin/starseed selftest
rishi/bin/rishi run tools/starseeding_witness.rish
```

It composes, never duplicates: `tools/settlement_constellation_witness.rish` already proves the mint and its refusals; `tools/aurora_run_witness.rish` already proves the boot stages build and wake. Starseeding's own witness proves only the **new** seam — the star tier chosen, settled, and born with a descriptor that survives a round trip and a tamper.

## TAME discipline the code will keep

- **Opening triad** on `starseed.rye` and `descriptor.rye`: `const std`, `const assert = std.debug.assert`, `const print = std.debug.print`; the composed modules imported by symlink (`@import("constellation.rye")`, `@import("topology.rye")`, `@import("kumara_tilak.rye")`).
- **Explicit widths**: point numbers, tiers, and counts are `u32`; the descriptor's version and any wire-persistent digest length are `u64` where they cross to disk; `usize` never appears in an authored field or signature — only, if ever, at an inherited std seam, cast at the edge.
- **Bounded everything**: the descriptor names a `max_image_digest_len` and a `descriptor_wire_len` constant once, at construction; the constellation bound is already `constellation_max` (66) from Settlement, enforced at mint.
- **Asserts with reasons**: each `// invariant:` names why — the minted point's tier is `.star`; the sponsor encodes back to the galaxy; the descriptor's version climbs by exactly one; `verify` holds after the mint. Aim two or more contract asserts per function.
- **No `@memcpy`**: descriptor serialization uses `tally/copy.rye` `copy_disjoint` (linked as `tally_copy.rye`), as the wire files already do.
- **snake_case** throughout; named errors with `try`; short verb-named functions.

## Risks, named plainly

- **The inclusive-topology subtlety is the sharp edge.** Because the number spaces nest (a galaxy number *is also* a star and a planet), "raise a star" must mean a number whose **primary** role is `.star` — `topology.decode(n).tier == .star`, the range `[12, 60)` in `compass_sky`. If a caller hands number 5 expecting "a star," it settles as a **galaxy** (5 is primarily a galaxy wearing the star outfit). The first lap must assert `tier == .star` and refuse otherwise (`WrongTier`), and the README must teach the outfit distinction — this is the one place a newcomer will trip. `topology.plays(n, .star)` answers "may it wear the star outfit"; `decode(n).tier` answers "is it primarily a star." Starseeding wants the second.
- **Sky-dependence.** The star range `[12, 60)` is `compass_sky`'s. Under a loaded `council_sky` (15·3·9) the star space is `[15, 45)`. Starseeding must read the tier from `topology.decode` (which reads the active sky) rather than hardcode a range, so it stays correct when Pond loads a different sky. The brief's ranges are illustrative of the seated sky only.
- **"Boot descriptor" is a promise, not yet a boot.** Ring-3 Starseeding emits a descriptor naming an image digest; it does not build, verify, or execute an image. Calling the descriptor "the boot" would overstate — the honest claim is "the star is born knowing how it would boot." The ring that carries the descriptor to metal (verify the image against the digest, hand it to Aurora's stages) is a later, named lap, and this brief does not pretend to it. This mirrors `deciding.rye`, which names a choice the full boot would honor without executing it.
- **The galaxy must already stand.** `mint` requires the sponsoring galaxy's Deed and a `sow` cap its keeper signed. Starseeding cannot raise a star under a galaxy that has not settled, and cannot forge the galaxy's consent — which is correct (the refusals `ParentNotSettled` and `BadAuthority` guard it), yet means the first lap must `open` the galaxy itself, so the selftest holds the galaxy's keeper key. That is fine for a fake-seed selftest; a real deployment would present a real galaxy keeper's signature, by that keeper's own hand.
- **Digest algorithm seam.** Settlement's Deed digest is SHA-256; Aurora's content-name is SHA3-512; `deciding.rye` names SHA3-256 for the next-image digest. The descriptor touches two of these (the constellation digest it binds, and the image digest it names). The brief keeps them explicitly separate fields with named lengths so no one conflates a Deed digest with an image digest — a mismatch here would be a silent correctness bug, so each is asserted to its own length at construction.
- **Consent is the gate on every real name.** No company, collective, or person named in the surrounding batons (b122m, Siya, Linengrow, Bitscape, and the rest) is a dependency of this module or is claimed to have agreed to anything. Starseeding composes only in-tree modules; every real-world tie is an **invitation**, consent-gated, and lives in the batons' worldbuilding, not in this code.

---

*A galaxy already shines; Starseeding sows the next star beneath it — settled once under its rightful place, born knowing how it would wake, and never a single real key touched in the making. May the first star seed gently and sure.*
