# The Glowphone — Firmware Freedom, the Two-Body Strategy, and the Honest Hardware Fork

**Language:** EN
**Version:** `20260715.182500` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Design → hardware research, siloed. Register: design/research (Two Rooms — a strategy proposal, no device built; every current-hardware fact is dated July 2026 and cited, so it can be re-checked as the field moves). Addressed to a generic Acme Corporation employee.
**Companion:** `../foundations/20260629-020012_mantrapod-venture-pitch.md` (the calm carried device); `20260710-133500_local-forge-minisforum-inference.md` (the sovereign home forge); `20260712-093812_mesh-inference-study.md` (the seam that joins them)

---

## What This Answers

How to fuse the sovereign-home-compute dream (the Minisforum forge) with the calm-carried-device dream (the Mantrapod) into a **Glowphone** — the best phone Glow OS could design and build — using open-market ARM chips and whichever mobile AI silicon has the freest firmware, a durable low-blue-light true-black display, and the best available base among GrapheneOS or its peers. The finding, stated first and honestly: **no single phone maximizes all three of firmware freedom, hardened security, and open on-device AI today.** The right strategy is not one device that pretends to; it is a **two-body design** — a firmware-free calm client carried in the hand, and the AMD-class forge at home — joined by Comlink, which is exactly the fusion the seed already reached for.

## The Honest Three-Way Fork (July 2026, dated and cited)

Three goods pull toward three different silicon choices, and pretending otherwise would be the kind of claim this tree exists to refuse:

1. **Firmware freedom** points to **Rockchip** (RK3588 / RK3576) or **mainline Qualcomm**. Rockchip now boots a fully mainline stack — Rockchip itself upstreamed the UFS driver and the RK3576 ARM Trusted Firmware BL31, so even the low-level boot firmware is open-source, with Vulkan 1.4 on the Mali GPU and an open NPU ("Rocket") driver (Collabora, FOSDEM 2026). Qualcomm's recent flagships (Snapdragon 8 Gen 3 / SM8650) reach mainline within months of launch and run postmarketOS, though camera and some power-management pieces lag and Qualcomm's firmware-upload habits still make integration harder (linux-msm, FOSDEM 2026).

2. **Hardened security** points to **GrapheneOS**, which is **Pixel-only** — because it depends on hardware memory tagging (ARMv9 MTE), verified boot, and Google's 7-year support guarantee on 8th-gen-and-later Pixels (grapheneos.org/faq, 2026). The irony is exact and worth naming: the most *hardened* phone runs on some of the *least firmware-free* silicon (closed Titan-class secure element, closed baseband). Broader GrapheneOS hardware support is not expected until 2027.

3. **Open on-device AI** points to **AMD Ryzen AI (Strix Halo)** — whose Linux stack is now unusually open: mainline `amdgpu`/`amdxdna` drivers, ROCm 7 as regular distro packages, and firmware updatable through `fwupd` (Phoronix, 2026). But that is a mini-PC / laptop-class x86 part with 128 GB unified memory — the **Minisforum forge**, not a phone SoC.

No device is all three. That is the real finding, and it is what makes the two-body strategy honest rather than a compromise.

## The Two-Body Strategy — Calm Client, Home Forge, One Seam

The seed's own instinct — combine the Minisforum dream with the Mantrapod dream — resolves the fork by refusing to force it onto one object:

- **The carried body (the Glowphone proper):** a firmware-free, low-power, low-blue-light client on **Rockchip-class or mainline-Qualcomm** silicon, running a Glow-direction OS over a postmarketOS-style mainline base. It holds the root key (Rhyz), speaks Comlink, renders Sala, runs Rishi. Its job is presence and carriage, not heavy inference. This is the Mantrapod's soul with a glowing screen instead of e-ink — a *sibling* to the Mantrapod, not a replacement (the Mantrapod stays the reflective, radio-free, forgetting device; the Glowphone is the connected, low-blue-light one).
- **The home body (the forge):** the **AMD Strix Halo** Minisforum node already scoped, running Lattice/Quin/Anvil for real inference, reached by the carried body over **Comlink / the compute mesh**. Heavy AI never has to live in the pocket; it lives on the freest-AI-firmware silicon at home and comes to the hand over a sealed, key-addressed channel.
- **The seam:** Comlink and the mesh-inference design already join them — a phone that asks its own home forge for inference, addressed by Kumara/Rhyz key, gated by capability, every unit of work a signed fact. Sala broadcasts the session over the same seam.

This is the whole fusion: **the phone is thin and free; the forge is powerful and open; the seam is sovereign.** Firmware freedom lives in the carried body, open AI in the home body, and neither has to compromise for the other.

## The Display — a Different Device From the Mantrapod, on Purpose

The Mantrapod's calm is a reflective e-ink page with amber blue-light-free light. The Glowphone is a *connected* device that wants live rendering, so it takes a different, honestly-named path: an **OLED LTPO** panel for true blacks (per-pixel off, the deepest contrast and the lowest power on dark surfaces) with an **adaptive refresh** floor for battery, plus an **eye-safety mode** — 2026 flagship OLEDs (e.g. Pixel 10 Pro's "adjust brightness for sensitive eyes") now manage emission frequency to soften the low-brightness PWM flicker that troubles sensitive eyes, and Glow's UI leans dark-first with warm night shift to keep blue light low. The honest trade: OLED's true blacks and low blue light come with burn-in risk that dark-first UI and adaptive brightness mitigate rather than eliminate. Where durability outranks contrast for a given build, a matte low-blue-light LCD is the cheaper, tougher fallback — named as an option, not hidden.

## The OS Fusion — Two Real Paths, Named With Their Trades

Fusing Glow OS + Urbit + Rye OS onto a phone base has two honest routes, and the choice is a real fork rather than a default:

- **Path A — mainline / postmarketOS base (freest firmware).** Build the Glow client over a mainline-kernel postmarketOS-style base on Rockchip or mainline-Qualcomm. **Gain:** genuine firmware freedom, reflashable, 10-year-longevity ethos, our own stack all the way down where the silicon allows. **Cost:** no GrapheneOS-grade hardened sandbox or memory tagging; security is ours to build, which is a real, large body of work.
- **Path B — GrapheneOS-on-Pixel base (hardest security).** Run the Glow surfaces as a hardened userland over GrapheneOS on a Pixel. **Gain:** memory tagging, verified boot, 7-year updates, the strongest mobile threat model available. **Cost:** the least firmware-free silicon, Pixel-locked, and Glow rides *on* Android rather than replacing it. CalyxOS (adds Fairphone/Shift, more repairable hardware) and DivestOS (~170 devices, older hardware) are the middle-ground peers if Pixel-lock or reparability is the deciding factor.

**Recommendation, stated plainly:** lead with **Path A** for the Glowphone's own identity — firmware freedom and reflashability are the values that make it *ours* and that match the Mantrapod's repair-and-longevity ethic — and keep **Path B** as the hardened-client option for anyone whose threat model demands memory tagging today, since it exists and works now while Path A's security story is still being built. This is the same "both enclosure values live one season past the flip" honesty the enclosure work already keeps.

## Another Strategy for the Advanced-Firmware Target

The seed asked whether a different strategy might be needed to target the most advanced hardware firmware. The honest one: **do not chase a single perfect phone SoC; ride the openest silicon in each body and let Comlink join them.** The freest AI firmware (AMD Strix Halo) is not a phone and does not need to be — it is the forge. The freest phone firmware (Rockchip mainline) is not the strongest AI part and does not need to be — it is the client. Trying to collapse both into one pocket device fights the market instead of using it. The rhizome move (per the market-position study) applies here too: own the *seam* nothing can route around — a sovereign, capability-gated, signed-fact channel between a free client and a free forge — rather than trying to own a single miracle chip that does not exist.

## Civic-Style Integrity Audit

- **Outcome wanted:** a phone a person owns wholly — free firmware where the silicon allows, repairable, low-blue-light, connected to their own home compute rather than a cloud, holding their own key.
- **What the reward measures:** longevity and sovereignty (years of reflashable life, a root key held in hand, inference served from one's own forge) — never data harvested, never attention captured, never a locked store's rent.
- **Alignment held:** the two-body design keeps the incentive and the ethic pointing the same way, exactly as the Mantrapod pitch does — the margin lives in the well-made repairable thing and the sovereign seam, not in surveillance.
- **Honest limits named:** firmware freedom and hardened security genuinely trade off today; on-device AI is modest and the forge carries the heavy work; OLED durability is a real caveat. None of these are hidden to make the vision sound bigger than it is.

## What This Doc Does Not Claim

- No device is built, sourced, or benchmarked; this is a strategy and a dated hardware survey, gated behind Keaton's word and, realistically, a dedicated machine and budget.
- Every hardware fact is dated July 2026 and cited; the field moves fast, and this doc is a snapshot to re-check, not a settled spec.
- It does not claim Path A's security parity with GrapheneOS today — the opposite: it names that gap as Path A's largest real cost.

## With Gratitude

The mainline-hardware progress is studied with thanks to the **Rockchip mainline** community (Collabora and contributors), the **linux-msm / postmarketOS** Qualcomm-mainline effort, **AMD's** open ROCm/`amdxdna` stack, and the **GrapheneOS, CalyxOS, and DivestOS** projects for the hardened-Android lineage. Every fact is cited to its dated source and re-expressed in our own words; the sovereign two-body synthesis is ours to carry.

## Related

- `../foundations/20260629-020012_mantrapod-venture-pitch.md` — the calm carried device the Glowphone is sibling to.
- `20260710-133500_local-forge-minisforum-inference.md` — the AMD forge the Glowphone leans on for heavy AI.
- `20260712-093812_mesh-inference-study.md` — the sovereign seam joining hand and forge.
- `20260715-181500_sala-broadcast-live-session-fold.md` — what the Glowphone broadcasts over that seam.

---

The freest phone and the freest forge are two different machines in July 2026; the Glowphone is the calm free client, the Minisforum is the open forge, and the sovereign seam between them is the thing worth owning.
