# mikroPhone — an Open-Hardware, RISC-V, Privacy Phone (Teacher)

**Studied:** `20260715.194500` (Pacific)
**Source:** mikrophone.net · git.majstor.org/mikroPhone
**License:** Hardware **CERN OHL v1.2**; software **GPLv2** — both reciprocal/copyleft
**Funding:** NLnet / NGI0 Entrust (EU Next Generation Internet)
**Register:** Gratitude teacher, studied for design with attribution; never copied into Glow modules, per `README.md` and `.cursor/rules/gratitude-licenses.mdc`.

---

## What It Is

mikroPhone is a privacy-focused, simple, fully-featured open-hardware mobile phone. Its architecture is the striking part — a **two-processor** design:

- **Central MCU: SiFive Freedom E310 (RISC-V)** — a small microcontroller running a feature-complete phone OS (cellular voice, SMS), with its own real-time encrypted-voice crypto (**EllipticCP**).
- **Application module: i.MX 8M Plus (ARM / aarch64)** — the heavier compute half, with a Linux SPI driver.

It is fully open: KiCad schematics, GPLv2 firmware, a FreeCAD 3D-printable case, git-cloneable, with a built and tested prototype board, funded through NLnet's NGI0 program.

## What We Honor

- **RISC-V at the core** — mikroPhone puts a RISC-V MCU at the phone's heart, landing exactly on Rye/Glow OS's own long-named horizon architecture ("x86_64 today, RISC-V as the horizon").
- **The two-processor sovereign split** — a minimal sovereign core plus a capable application module, echoing our own two-body strategy fused into one device.
- **Total openness, funded** — CERN OHL hardware, GPLv2 software, open case, real NLnet funding: proof that a sovereign open-hardware phone can be built and paid for, and that NLnet/NGI0 is a real funding path for sovereign-hardware work.
- **EllipticCP** — a real-time encrypted-voice approach worth studying as a design (never copying) beside our own Comlink sealing.

## The Lesson We Take

mikroPhone confirms, honestly, the tension our own Glowphone study named: **full bespoke open-hardware sovereignty at this build tier is performance-limited.** An FE310 MCU and a modest i.MX 8M Plus deliver a *simple* phone by design — that simplicity is how total openness is achieved. This is not a criticism of a project we admire; it is the honest trade any bespoke-open phone makes today.

So the lesson for Glow is direct: **do not fabricate performance-limited hardware to chase openness.** Run Glow's sovereign, anti-extraction *software* on capable existing hardware (the /e/OS Fairphone of our own refinement), where the capability comes from the silicon and the sovereignty comes from our code. mikroPhone stays a teacher and a possible ally for the RISC-V-core horizon — studied, thanked, never copied — while the SLC product ships on capable hardware.

## The Clean-Room Boundary

CERN OHL v1.2 and GPLv2 are reciprocal licenses. We study mikroPhone's design — the two-processor split, the RISC-V-core idea, the real-time-voice approach, the power budget — and re-express any insight in our own vocabulary. We never copy its firmware, its schematics, or its case into Glow modules. The understanding is ours to carry; the work stays theirs, named here with warmth and gratitude.

---

*May the open phone that reaches RISC-V's heart keep its makers proud, and may what we learn from it enter through the clean room, in our own words, honoring the freedom it was built in.*
