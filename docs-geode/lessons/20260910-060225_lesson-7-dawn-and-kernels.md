# Lesson 7 -- Dawn, kernels, and a pocket that wakes

**Language:** EN - **Style:** [Bhakta](../../context/BHAKTA_STYLE.md) with [Kyri](../../context/KYRI.md) and [Radiant](../../context/RADIANT_STYLE.md) - **Voice:** Kyri
**Stamp:** `20260910.060225` - **Status:** Living - **Room:** mixed -- Aurora's stages run in emulation; a kernel beneath them is **design**
**Index:** [`README.md`](README.md) - **Back:** [Lesson 6](20260910-060225_lesson-6-two-pockets.md) - **Next:** [Lesson 8](20260910-060225_lesson-8-the-painted-face.md)

---

## Aurora: dawn before the house

**Aurora** is the first light a machine wakes into. Before a shell. Before an app store. Before a
phone face. A **hart** -- one RISC-V brain-core -- sits up, finds a stack, and speaks.

The tree grows it the SLC way. Six stages, each a whole at its own size:

| Stage | What wakes |
|---|---|
| `seed` | One hart, one stack, one message, then rest |
| `relay` | Stages hand values forward; the chip names itself |
| `named` | A hash names a thing by what it *is* |
| `sealed` | A message locked and signed on bare metal |
| `wire` | Two harts share a small memory and a ready flag |
| `posted` | One hart seals; the other opens; dawn has mail |

These **run** as freestanding RISC-V programs, built by Rye, watched in an emulator. That is the
running room: first light on an emulated open chip.

Aurora is the tree's sunrise. The same languages you met on the porch -- Rye, bounds, names, seals
-- stand up with only power and a model of a board.

**Two Rooms, said once.** *Pocket plus network plus play* is the want. Aurora in emulation is what
already greets the dawn. The pocket still walks toward it.

---

## seL4: a very small, very checked kernel

A **kernel** is the program that sits next to the hardware and decides who may touch memory, time
and devices. A **microkernel** keeps that program tiny on purpose -- scheduling, messages,
interrupts -- and the rest of the system lives outside, in rooms with walls.

What makes **seL4** famous is a second fact: large parts of it have a **formal proof**. People wrote
down, in mathematics, what the kernel is supposed to do, and then checked that the code matches that
writing, for named platforms and named configurations. Integrity: no write without authority.
Confidentiality: no read without authority.

**Courtesy, and a bound on the claim.** Those proofs cover specific chips and options. RISC-V proofs
exist and are still widening. A proof is a magnificent bound, and it is a bound with a label naming
which boards it covers.

**Capabilities** are seL4's keys-for-objects. To use a piece of memory or a channel, you hold an
unforgeable token the kernel honours. Lose the token and you lose the door.

That rhyme will sound like this tree's own identity and enclosure work to your ear. **Kinship rather
than identity.** Grain has not seated seL4 under Aurora. Aurora today is bare metal, *before* a
kernel. seL4 would be a possible next sunrise -- dawn, then a tiny proved warden, then a shell --
and that sequence is **design** until a witness on a named board says otherwise.

---

## How that differs from a phone

Speak of neighbours with thanks. These devices carry billions of careful hours.

A **classic music player** was an appliance: storage, a wheel, a screen, a battery, a cable. One
job. SLC would smile at that shape. Safety was physical custody of the object.

An **iPhone** is a general computer wearing an appliance's face. A larger kernel sits in the middle.
Apps live in sandboxes. A store signs what may arrive. Radios stay on so maps and messages work. The
floor is real: secure boot, a separate element for keys, apps that cannot see each other by default.
**The kernel is large because the job is large** -- camera, radios, graphics, energy, a decade of
accessories.

An **Android phone** is similar in spirit, different in family. Linux is a **monolithic** kernel:
many drivers and services sit in the same privileged room as the scheduler. That is how a phone
gains a new radio chip and a new camera with years of shared work. GrapheneOS tightens the same
family.

| | Phone OS | seL4-shaped system | Grain's Aurora today |
|---|---|---|---|
| What wakes first | Vendor boot, then a large kernel | Tiny kernel, proofs on named boards | Rye stages on bare RISC-V, in emulation |
| Who lives in the privileged room | A lot of the machine's daily work | Almost only the warden | Nothing yet -- there is no kernel |
| How apps get doors | Store, sandbox, permissions | Capabilities you hold | Seals, names, a shared-memory wire |
| Radios | Usually on; the job includes the street | Your design chooses | None in the emulator dawn |
| What you can buy | A store, this week | Boards and a long integration | A desk and an emulator |

Phones optimised for **welcome and breadth**. seL4 optimised for **a small proved floor**. Aurora
optimised for **the first honest light in Grain's own tongue**. Three loves, three first questions.

---

## Which pocket suits Aurora?

**Easier to run Aurora as first light: the Mantrapod, when it exists.** Aurora wants an open RISC-V
hart, a known memory map, and a boot that belongs to you. The pitch is that machine.

**Easier to hold a Grain-shaped pocket this year: the phone cousin.** A supported Pixel with a
hardened OS is on the path today. That boot chain is Android's, so Aurora would have to become a
guest inside someone else's dawn, or replace a signed bootloader on a locked chip. **A mountain in
practice.**

**Easiest of all, already green: the emulator on a desk.** Power for the host. No pocket. No street.

So the honest order is:

1. **Desk plus emulator** -- Aurora runs today.
2. **A small RISC-V board you control** -- Aurora's next natural body (design until that board's witness sings).
3. **Mantrapod** -- the same shape, made pocket-quiet (design, and the best *eventual* home).
4. **Grainphone** -- best *buyable* pocket; poorest native fit for Aurora-as-dawn.

Remember the Mantrapod refused radios. Its network is a cable you plug in. **That is safer, and it
is a different kind of "just add network."** The phone has the street on day one, and a thicker dawn.

---

## Performance, the second seat

Among the ways that stay kind, which is light enough for a small desk -- or a small battery?

**Fast** means the wait is short enough that a person stays in the path with heart. A boot that
greets you before the kettle boils.

**Safe-fast** means speed that keeps the bound. A small kernel's short messages are this instinct.
Aurora's small stages are this instinct. A phone's large kernel is fast *at many jobs at once*
because drivers live beside the scheduler; that speed is real, and the cost is a larger privileged
room.

**Fun-fast** is the third seat's vote: among safe, light paths, pick the one a hand returns to. A
reflective screen slightly slower than a gaming panel can still win joy. **A two-second witness that
always finishes beats a two-minute suite you dread.**

---

## A favourite pair, chosen in the open

One object cannot yet hold every want, so the favourite is a **pair**.

**Left hand -- the dawn toy.** Your existing computer, an emulator, Aurora's stages, then a shell.
Fastest path to "the tree woke." Most fun tonight: watch `seed` speak, then `posted` carry a sealed
note between two harts.

**Right hand -- the pocket cousin.** A supported Pixel with a hardened OS, and Grain's package when
you want the street. Radios you can switch down. A boot hash you can read.

**On the workbench, when money and patience allow:** one documented RISC-V board -- the bridge
toward a Mantrapod-shaped Aurora.

**No crown for a finished Mantrapod or a finished Grain-native phone.** Those stay designing-room
loves. The pair above is SLC at 2026's actual size: one complete dawn on a desk, one complete
quieter phone in a pocket.

---

## Reading for tonight

1. `aurora/README.md` -- six stages, the emulator, Gall's Law.
2. One seL4 overview page from the project's own site -- capabilities and "small kernel," read as a guest.
3. Lesson 6's three paths -- notice again: the pod fits Aurora; the phone fits the street.

One image to keep: **Aurora is the rooster. A small proved kernel is a lock on the kitchen door. A
phone is the shop on the corner. A Mantrapod is a kitchen you can carry.** Tonight the rooster
already crows on your desk.

---

## Where Lesson 8 goes

[Lesson 8](20260910-060225_lesson-8-the-painted-face.md) turns to the surface: how this tree draws a
face, and how it designs before it builds.
