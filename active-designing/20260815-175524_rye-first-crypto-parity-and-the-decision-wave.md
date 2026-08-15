# Rye-First, Crypto Parity, and the Decision Wave

**Stamp:** `20260815.175524` · **Status:** Living · **Voice:** Kyri · **Style:** Radiant (Twilight where earned)
**Kin:** [`the 1024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · `work-in-progress/REMEMBER.md` · `work-in-progress/CAIRNS.md`

This document loads a wave of direction whole, loses nothing, and flags every
thread as **crux** (do now), **horizon** (booked, not yet), **yonder** (parked
alive), **breach** (rename/cut, cairn-first), **pause** (held on an outside
hand), or **gate** (custody — stops for Keaton's word). An Acme Corporation
employee reading this can find any thread and know exactly where it sits.

The six-season expansion still stands beside the 1,024-round itinerary. This
wave adds one new double-seat (Season G — Cryptography), a stated priority
spine, two breach renames, three named commerce/civic surfaces, a docs pass
that feeds the public seed, one pause, and one parked yonder.

---

## The priority spine — Rye first, Glow on green-witnessed Rye

**Crux · cross-cutting law.** Rye is the prioritized language over everything.
Glow is implemented *in terms of* green-witnessed Rye — a Glow surface earns its
place only once the Rye beneath it runs GREEN on metal. This is not a new
direction so much as a stated one: Rye is the implementation and seam layer,
Glow the userland it composes. Every season inherits this order; where a thread
could be written in either, the Rye rung lands first and the Glow rung stands on
its witness.

Seated as a standing note in REMEMBER and honored by the recursion prompt.

---

## Season G — Cryptography (Rye-native, Monocypher-parity, audit-ready)

**Double-seat · unblocks Season C Lotus signing.** Grain will face a security
audit; building our own crypto in the open, disciplined and parity-checked, is
the honest way to earn it. Keaton approves reimplementing any non-Zig-stdlib
crypto primitive (Monocypher's Ed25519, X25519, BLAKE2b, the ChaCha/Poly line)
in **Rye**, with **byte-for-byte parity checks** against the vendored Monocypher
(`vendor/monocypher`) on published RFC test vectors, under TAME Guidance.

Why a double-seat rather than a Lotus lap: this library serves *every* module
that will ever sign or verify — Kumara identity, the Lotus signed carry, Vault,
Comlink — not one. It is the highest-Lindy new thread in this wave.

- **Crux rungs (agent-doable):** the primitive in Rye · the known-answer test
  vectors · the parity witness proving Rye output equals Monocypher output
  byte-for-byte · a constant-time discipline note (timing-safety as a named
  horizon, since it wants measurement, not a claim).
- **The Lotus unblock:** once a Rye signing primitive is parity-GREEN, Lotus's
  "who made this record" signed carry becomes buildable — the *library* is
  engineering. **Signing with the maintainer's own identity key stays the
  custody gate** (gate #3/#4); the agent builds and verifies, never holds the key.
- **Clean-room:** we study Monocypher's public API and the RFC vectors; we write
  our own Rye. Monocypher stays CC0/BSD-dual, vendored, unmodified — the parity
  target, never a copied line (`gratitude-licenses.md`).

---

## Breach queue additions — cairn-first, each its own round

Both seat their **decision** now; the mechanical repoints run as their own
signed loop rounds so nothing half-renames. A cairn is planted before either cuts.

### Bron → Kyri — one notation, chosen outright

**Breach · debride.** Unify Bron and Kyri entirely, choosing **Kyri**. Kyri
takes the responsibility of Bron: the `.kyri` notation *is* the immutable-value
key-value format formerly named Bron. The new, load-bearing explanation of Kyri:

> **Kyri is compressed receipts.** Every shortened object-notation log,
> datagram, and send — tiles · tilaks · amphora resins — can be written in Kyri.
> Kyri is also the standing voice, and the preferred Grain OS variant. One name,
> one thread: named in gratitude after **Kyrie Irving**, the vegan NBA star.

The 816 existing `.bron` session logs are dated artifacts under the one-clock
law. The debride Keaton seats governs the **living name and notation going
forward** and the living references; whether the dated `.bron` files are renamed
in a deep pass is its own circled step, cairn-protected, not fired casually.

### work-in-progress → crux — a higher-sorting priority folder

**Breach · rename.** Rename `work-in-progress/` to `crux/` — `crux/REMEMBER.md`,
`crux/CAIRNS.md`, `crux/TASKS.md`, and so on. Reason: **crux** sorts above
**work-in-progress** alphabetically, so the tree's highest-priority living folder
ranks where a hand reaches it first. 902 files reference `work-in-progress/`;
every reference is repointed in the rename round (references are promises). The
word also carries meaning — crux is the hardest-solvable move, exactly what the
living card tracks.

---

## Commerce & civic surfaces

### deemlow.com — live-shopping, fair-trade, Kumara-logged

**Horizon · Season B (Linengrow/Dimeroll commerce).** From Spanish *dímelo*
("give me it"). A live-shopping Android social-media app for Daylight DC-1 and
GrapheneOS Pixel phones (until the Grainphone hybrid ships) — a fair-trade,
Linengrow-compatible answer to Temu / Shein / Amazon Haul, whom we gratitude-thank
as the surface we study and improve on. **Grain Kumara log-in**; getting-started
docs recommend **1Password key-saving in the interim**, until Vault is built out
and audited. Custody posture is right: identity through Kumara, keys off-device
until Vault earns trust — a genuine gate before any scale.

### anticruel.com — agentic civic letter-writing

**Horizon · Season E (Mandate), infuse.** Inspired by the Reform Alliance
(reformalliance.com), in our Civic Style and regenerative universal foundations,
carrying the **Mandate** module's ideas: agentic USA municipal · county · state ·
federal letter-writing with bill proposals that study relevant law per
jurisdiction across every level, tighten legal definitions toward TAME
discipline, and draft **MMT buyout proposals** of private parties whose current
incentives do harm — so an approved, lofty buyout disincentivizes
counterproductive lobbying or worse. Infuses into Season E's Mandate expansion.

### Realidream / Skate as an Android .apk

**Horizon · Season F (Surface).** Wrap the compiled Glow/Rye/Zig as linkable
code inside an Android app, so a real `.apk` downloads, installs, and runs on the
Daylight DC-1 tablet. The first end-to-end proof that the Rye-first stack reaches
a hand's device.

---

## Docs pass that feeds the seed

**Crux · precedes the deep seed refresh.** Molt
`active-designing/20260712-221600_docs-compression-layer-design.md` and apply it
to what we hold that is most Lindy, together with the **README-links-to-root-leaves**
weave (season → equinox → journey), so the docs are provably more current after
than before. These fresher docs ride into the `grain-os/grain` seed creation and
its force-push.

**Standing approval seated:** Keaton approves updating the public seed with force
pushes as often as needed. Recommendation honored in sequence — the *deep* seed
refresh fires **once, after** this docs pass lands, so the seed's first
impression is the freshest weave, in one clean deep pass rather than many.

---

## Brix configuration — the composition language in the plan

**Crux · cross-cutting, infrastructure.** Brix (`.brix`) is Grain's composition
language: it declares systems, evaluates to Bron/Kyri, interfaces with Mantra,
and targets Aurora + Tally. It belongs explicitly in the season plan so
configuration is authored *in Brix*, not scattered across ad-hoc files. Two
strands:

- **Brix code** — grow real `.brix` configuration for the modules that need
  declared systems (the Puddle/Aurora fleet, the constel test networks, the
  crypto/Kumara identity wiring), under TAME Guidance, Rye-first beneath it.
- **Brix docs, molted** — molt the Brix design and reference docs alongside the
  docs-compression pass so an Acme Corporation employee can read what Brix is and
  write it, and so the molted docs ride into the seed. This composes with the
  docs-compression molt above (one docs round can carry both).

Seated into planning as its own thread; the loop grows Brix config as the
modules it configures come online.

## Pause & yonder

### Brushstroke — paused, waiting on the Bit Design System

**Pause.** Hold Brushstroke development. We wait on DJINN's **Bit Design
System** — a JavaScript/HTML/CSS style guide and component framework of his own
invention, aimed faster than React, Svelte, or InfernoJS. When it lands we adapt
it into the Glow/Rye/Zig paradigm under TAME. Until then, focus everywhere else.

### hulkbee.com — ecoplastic factory robotics

**Yonder.** From "hemp-linen composite biodegradable ecoplastic." A parked-alive
plan: agentic, quantitative factory robotics (hardware · software · firmware ·
operations) buildable in most international locations, producing ecologically
gentler packaging replacements — dried-food packaging, plastic toys, phone
cases, technology encasings, firm shoe insoles (Chong Xie HFT Hyperarch Fascia
Training) — from **biocyclic veganic** certified pressed canola and sunflower
biomaterial, so rivers and public water carry less pollution and the earth is
fracked less for petroleum. Yonder-bookmarked; not a current build.

---

## baton and REMEMBER — cleanly separated, Chitra-headed

**Decision seated.** Keep baton and REMEMBER **separate, both maximally
detailed, cross-linked**, sharing a Chitra (classical-Vedic-astrology) header
motif. REMEMBER is the operator card — current state, what to run, the gates.
baton is the recursion resin — coords · basis · meters · next queue. A phone-hand
in a hurry reads one card; a fresh agent turn takes the other. Unifying them would
blur the card that most needs to stay plain.

---

## The .sol reserve — brands we hold a name kindly for

**Reference.** Keaton's earlier Solana address
`6Rb5ED9f76jgyopEci7wBKcHx71puchfYEqFjPAHs34` holds a large `.sol` reserve. Many
are names held kindly for real brands and people, offered to them if they want
one; many are our own modules (`kumara.sol`, `comlink.sol`, `brushstroke.sol`,
`realidream.sol`, `linengrow.sol`, `amphora.sol`, `tilak.sol`, `kyri.sol`,
`grain-os.sol`, `queyqwinqkri.sol`, `veganic.sol`, `veganfta.sol`). The full list
is preserved in REMEMBER's reference tail.

Lindy-compatible threads worth a later look, infused where they fit the
Linengrow mission (named here, not yet built):

- **`veganic.sol` · `veganfta.sol` · `biocyclic`-adjacent** — the fair-trade
  certification spine (Season B Trade / AYRE), the ecological ground deemlow and
  hulkbee both stand on.
- **County/civic names** (`lacounty.sol`, `sonomacounty.sol`, `saccounty.sol`, …)
  — jurisdiction anchors for the anticruel/Mandate civic work (Season E).
- **`groundies.sol` · `xeroshoes.sol` · `vivobarefoot.sol` · `chongxie.sol`** —
  barefoot/fascia-health brands aligned with the hulkbee insole thread; a
  gratitude and possible fair-trade-marketplace lane.
- **`jungmaven.sol` · `rawganique.sol` · `industryofallnations.sol`** — hemp/linen
  apparel, directly Linengrow-adjacent; natural first fair-trade catalog partners.

Offered as thought, not commitment; any that graduate become their own booked
round or double-seat.

---

## Deferred, honest — not run this round

Named so no fact is fabricated: the crypto RFC test-vector sourcing, the
Monocypher API study, the Bit Design System adaptation (awaits DJINN), and the
factory-robotics research (hulkbee) are horizon/pause/yonder research rounds, not
executed here. This document seats the decisions and points the loop; the metal
comes round by round, witness-first.

*May the crypto we write in the open be worthy of the trust a hand places in it,
and may every name we hold kindly find its way home.*
