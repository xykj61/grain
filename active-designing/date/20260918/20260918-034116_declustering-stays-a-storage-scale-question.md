# Declustering stays a storage-scale question -- Caravan's small tables read whole already

**Stamp:** `20260918.034116`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. A survey and its finding; nothing here runs today.
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`../../20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md`](../../20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
(round two, openings 1 and 2 landed as `3e1396475` and `b58e508d1`/`a56d50a0a`; opening 3 stands at
one ship of eight reporting), [`20260918-015906_discovery-room-checked-no-torus-eighth-negative.md`](20260918-015906_discovery-room-checked-no-torus-eighth-negative.md)
(the sibling negative finding this note continues in spirit)

## What this note checks, and why

Round one and round two's first two openings measured **declustering** -- how a ring or torus
placement scheme spreads replicas so that at least one copy of every cell survives the loss of a
contiguous run of storage. The metric has a home: `mantra/beading.rye`'s content store,
`tally/pedersen.rye` and friends, any population large enough that a reader chooses WHERE among
many slots a thing lands.

Before drafting a third opening, this note asked a plainer question: does the same metric say
anything useful about **Caravan's supervision tables**? Three tables carry the candidate population:
the dependent slots in `caravan/boot.rye`, the domain-to-region grants in `caravan/regions.rye`, and
the per-dependent capability rows in `caravan/capabilities.rye`. A restart storm that took out
several dependents at once would be Caravan's own version of the storage thread's "contiguous run
whose loss destroys every copy." That makes the transfer a fair one to check, before writing it up
as a fourth opening.

## What the three tables actually are

Read directly rather than assumed:

- `caravan/capabilities.rye` bounds `max_dependents` at **4** and `max_caps_per_dependent` at **8**
  (`caravan/capabilities.rye:19-21`).
- `caravan/regions.rye` bounds `max_domains` at **8** and `max_regions` at **12**
  (`caravan/regions.rye:32-38`), each grant **explicitly declared** at construction -- "sharing is
  deliberate and visible, never ambient," in the module's own words.
- `tally/gardens.rye` names exactly **three** gardens by hand (`blob`, `diff`, `frame`) -- a small,
  fixed, named set rather than a large indexable population.
- `caravan/boot.rye`'s own restart bound (`max_restarts_per_dependent: u32 = 3`) is per-dependent
  and independent; the read file counts each dependent's restarts on its own, with no coupling to
  a neighbor's count.

## The finding: the metric needs a population these tables do not have

Declustering asks a placement question -- **given many items and a scheme for spreading them across
few slots, how far does the scheme's structure keep every cell's surviving copy from the slots that
are lost.** It is a question about an algorithm choosing among many possible layouts.

Caravan's tables are the opposite shape. Four dependents, eight domains, twelve regions: a human
declares each grant by name. Each table is small enough to "read in one sitting and assert over
completely," in `regions.rye`'s own words. The four rows ARE the layout, chosen once by a person and
readable whole. Too little population stands here for a placement algorithm to choose among. Every
adjacency between two slots is already the grant a person wrote down, plain to a witness's read. So
a "contiguous run of slots whose loss destroys every copy" question, put to a table of four rows,
becomes a question about which four dependents the operator already named. That is a design
decision a reader sees directly, rather than a structural property a search or a ring topology could
sharpen.

**Restart isolation adds a second, independent reason.** Each dependent's restart budget counts only
its own crashes. That is exactly the isolation a "blast radius" reading would need to break before
it could mean anything here. The regions module's explicit-grant discipline carries the same shape
from the other direction: two dependents share a region exactly when a person wrote that grant. So
"adjacency" is already a fact stated in the declaration, plain to read, rather than a consequence an
indexing scheme hides.

## What this finding is scoped to

This finding holds for today's tables at today's scale, and stays there on purpose. Picture a system
with hundreds of dependents and a scheduler choosing which physical core or protection domain each
one lands on. That system meets a real version of this question -- Microkit's own protection-domain
model, which `regions.rye`'s header cites, is built for exactly that scale. The finding earns its
place by staying narrow. **At the size and declaration discipline these three tables hold today,
every slot is a decision already visible on the page.** A fourth opening built on the declustering
transfer would measure a design choice one can already read directly in the source.

## Falsifier, named so this stands as a checkable claim rather than an impression

This finding holds only while the tables stay small and hand-readable. It is worth rechecking the
day `max_dependents`, `max_domains`, or `max_regions` rises an order of magnitude past its current
value. It is also worth rechecking if a future ring ties two dependents' restart counts to one
shared, exhaustible resource. Either change reopens the question this note closes.

**Horizon.** This note is a survey, and its product is the finding above rather than a build.

**Confidence.** High on the read (all four bounds and the restart-independence claim are cited
lines in tracked source); medium on the generalization that "small and declared" is the right test
for when a placement metric transfers, since only one module family was checked.

## What remains open in the round-two ladder

Opening 3 -- reading locally observable power signals across seven hosts as one composed answer --
stands at one ship of eight reporting (`session-logs` commit `7633a5880`). Completing it depends on
the other seven ships' own hosts, past what a single lane can build alone. This lane holds it rather
than repeating the ask.
