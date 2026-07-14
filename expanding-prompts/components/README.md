# Prompt Components — a Library for Glow

**Language:** EN
**Version:** `20260713.235800` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Living — starter library; grows a component each time a prompt shape proves itself

---

## The Idea

Brushstroke is a component library for drawn surfaces — reusable, composable pieces you assemble into a web or mobile face. **This is the same idea for prompts.** A prompt component is a reusable, tokenized template for a recurring kind of request, written in the same TAME-guided, Radiant, Acme-employee-addressed voice this fork already keeps for all instructional writing. You copy a component, fill its tokens, and run it — the way you copy a UI component and fill its props.

Just as Brushstroke serves Glow, this library serves Glow: a **prompt component library for TAME-guided Glow**. When a prompt shape proves useful more than once, it graduates here as a component so the next person (a generic Acme Corporation employee, per the acme-employee-voice rule) does not re-derive it.

## How a Component Is Shaped

Each component is a `_<name>.prompt.md` file with:

- **A one-line purpose** — what request this component serves.
- **Tokens** — `{{LIKE_THIS}}` placeholders the user fills.
- **The expanded prompt body** — written so that, once tokens are filled, it can be handed to an agent as-is and produce work in this fork's own discipline (research before code, name the fork honestly, log to bron, cite the silo not the original, address the generic employee).
- **A "produces" line** — what artifacts a good run leaves behind.

Components are prefixed `_` (like a template partial) so they sort together and read as skeletons, not finished prompts.

## The Starter Set

- [`_fusion-design.prompt.md`](_fusion-design.prompt.md) — design a fusion of a Glow OS module with an Urbit/other concept, in Glow under the proposed names.
- [`_naming-proposal.prompt.md`](_naming-proposal.prompt.md) — propose a name with collision research and a reference-cost estimate.

## Why It Is Shaped This Way

This fork has, in a single season, run the same few prompt shapes many times: "design a fusion," "propose a name," "silo a source," "scope a module." Writing each as a component means the discipline (secular voice, held-whole gratitude, bounded TAME, honest open-questions, bron logging) is carried in the template rather than remembered each time — the same reason a UI library exists. In time these generalize into the shared prompt vocabulary a mature Glow OS hands to every contributor.

---

*May the good shapes be kept, so no one has to find them twice.*
