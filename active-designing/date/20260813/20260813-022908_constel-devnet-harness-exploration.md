# The Constel Dev-Net Harness — a fake constellation that runs the whole protocol, quarantined by its own name

**Stamp:** `20260813.022908` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Living (design capture, self-approved round) · **Season:** double-seat expansion D — Constel test-networks
**Kin:** [the naming law](20260813-022222_constel-test-network-naming-law.md) · [the double-seat expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where this sits on the road

The fixed 1,024-round itinerary stands complete across all four seasons, and no red is open. The
next Lindy-first crux lives in the double-seat expansion, Season D, where the loop just seated the
**Constel naming law** — the structural promise that every fake dev-network constellation name carries
a digit and so can never parse as a real `@p`. That law named its own next rung plainly:

> *"When the real Comlink dev-network harness is built, it draws its constellation names from this law
> and this witness stands at its door."*

This is that harness. It is the **crux** of Season D — the decisive, still-tractable move that opens the
rest: Mycelium consensus, Puddle fleet orchestration, and every future Comlink settlement test all need a
fake network to run against, entirely inside the jailed pier, touching nothing real. Build the dev-net
once and every later Season-D rung has a bench. It is also high **Lindy**: a dev-net harness is read and
run for years, on the ten-thousandth day as on the first.

## The crux, in one line

**A fake dev-net can only be named by a provably-non-`@p` name, and under that name it runs the real
settlement protocol from genesis.**

Two halves fused. The *name* is the quarantine — a constel is born only from a law-safe name (a digit
anywhere), so the whole network it stands for is structurally sealed away from the live network; no peer
in it can ever be addressed as a real point in someone's custody. The *genesis* is the proof of life — the
harness opens a genuine `settlement.open` galaxy from demo seeds and verifies its Deed, so the fake net is
not a hollow shell but the actual protocol running where nothing it names can escape.

## Why the name carries the safety, not a flag

A boolean "this is a test net" is a claim a caller can forget to set. A **name that carries a digit** is a
proof checkable at a glance, the same certainty `placeholder-ship-names` earns from segment length and the
naming law already earns for the drawn names. Binding the quarantine to the name means a dev-net cannot
exist un-quarantined — there is no code path that spins one up under a name that could be real, because
`spin_up` refuses `UnsafeName` before it opens a single genesis. The safety is structural, asserted, and
impossible to bypass by construction.

## The four rounds (Lindy-first, crux-first)

- **r1 — named genesis (this round's crux).** `pond/apps/constel_net.rye`: a `Constel` binds a law-safe
  name to a real opened `settlement.Constellation`. `spin_up` refuses `UnsafeName` (no digit → could be a
  real `@p`, no genesis opens), then opens a genuine demo genesis and verifies the galaxy Deed; `name_safe`
  mirrors the naming scan's one digit-check in Rye; the harness cross-checks that every seated draw in
  `tools/fixtures/constel_names.txt` is law-safe, so it draws from the seated law rather than inventing a
  parallel rule. A forged bind and a non-galaxy number each refuse — the real protocol runs in the fake net.
- **r2 — settle a topology.** Seat a star and a planet beneath the galaxy via `settlement.mint`, each under
  its rightful topology sponsor, proving the whole fractal address space settles inside the fake net.
- **r3 — the net travels.** Render a spun-up constel to a `format constel-net-v1` Bron record and parse it
  back byte-for-byte, so a dev-net's roster crosses as text a person can read, the safe name riding with it.
- **r4 — read a real fixture true.** Cross-check the harness's reading of a genuine on-disk constel record
  against an independent measure — two tools, one answer — so a fake net can never drift from the bytes.

## Boundaries

Siloed and dev-only. Demo keeper seeds only — no real key, no network, no custody (the maintainer's own
Kumara instance stays gate #4; a constel served over the wire reaches the serve gate). The harness reads no
network and opens no real address by construction: the name refuses it. Agent-doable, reaches no custody
gate.

---

*A place to run the whole protocol where nothing you name can ever be a real address in someone else's
hands — and the name itself is the wall that keeps it home.*
