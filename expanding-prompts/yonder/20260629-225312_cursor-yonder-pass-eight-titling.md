# Cursor Pass — Yonder Pass Eight (with the Titling Convention)

*The organizing lane runs quiet, and the tell is in what stays: the two files kept this pass are both about the surface ring. Six research pieces go to the horizon. And the affirmation touch now carries a small new habit — a kept file's title leads with the concept its filename names, the dead number long gone.*

**Stamp:** `20260629.225312`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Tip:** pull `bf73578` first.

*Written together by Kaeden and Reya 2.*

---

## The Titling Convention (new — applies to every affirmation from here on)

When a kept file is affirmed, its H1 follows three small rules:

1. **No legacy `NNN ·` prefix** — the timestamp filename is the identifier now.
2. **Lead with the slug's concept** — so file and title cohere at a glance. A file named `…_pond-foundation.md` opens with "Pond," not a phrase that makes a reader hunt for the connection.
3. **Radiant `Name — clause` form** — the evocative name, an em dash, a descriptive clause. Living docs use their plain spoken name as the H1.

---

## Already Handled (no action)

- `work-in-progress/20260620-212126_usize-width-baseline.md` — kept canonical, affirmed; leave it.
- `work-in-progress/20260623-033012_open-threads.md` — already a redirect stub over the archive; leave it.

---

## Part A — Kept (the surface ring)

**`external-research/20260618-180812_pond-foundation.md`** — foundational architecture brief for the Pond ring, cited 6 times. Affirm it: 

- **Retitle to lead with Pond**, dropping the `987 ·` prefix — for example `# Pond's Foundation — The Bounded Enclosure Beneath Pond, Caravan, and Tally`, so the H1 and the `pond-foundation` slug cohere. *(Kaeden blesses the exact wording; keep the bounded-enclosure idea, lead with Pond.)*
- Set `Last updated: 2026-06-29`; add the reviewed-and-kept line.
- Lightly freshen the Radiant voice only where it has drifted.

Do not move it — Pond is next, and its foundation stays at hand.

**`expanding-prompts/20260619-070612_brushstroke-and-documentation.md`** — held in place, not moved and not affirmed. An old prompt with one reference, yet it concerns the *drawn surface*, which is the Skate ring about to be scoped. Leave it one level deep so it is handy for that conversation; note in the session log that it is retained pending the Skate scope ruling. No title or content change.

---

## Part B — Move Six to `yonder/`, With Reference Repoints

`git mv` each into its folder's `yonder/`; grep the tree for the filename and repoint every inbound reference.

| File | To | Why · refs |
|------|----|-----------|
| `active-designing/yonder/20260618-224612_rooted-identity.md` | `active-designing/yonder/` | design-stage; kin to the unified-identity horizon already in `yonder/` · ~1 |
| `external-research/20260618-150112_voices-of-an-os.md` | `external-research/yonder/` | explores "one language or more," now settled in the kept `growing-a-language` · ~4 |
| `external-research/20260618-190312_decided-design-aurora-mantra.md` | `external-research/yonder/` | reads two now-built modules through the design; realized analysis · ~3 |
| `external-research/20260618-195512_encrypted-networking-riscv.md` | `external-research/yonder/` | the `985` networking study, realized in Comlink and Aurora's sealed datagram · ~8 |
| `external-research/20260618-204012_borrow-checking-and-correctness.md` | `external-research/yonder/` | principles canonized in `TAME_GUIDANCE` and the kept briefs; exploration-tier · ~3 |
| `external-research/20260618-212112_content-centric-messaging.md` | `external-research/yonder/` | the `982` study; networking realized, messenger is horizon; reunites with its sibling prompt · ~12 |

**The two heavy ones, handled with care:**

- **`content-centric-messaging` (982)** is cited by **Aurora source** — `aurora/src/named.rye`, `posted.rye`, `sealed.rye`, and `aurora/README.md` — as design provenance. Repoint those doc-comment paths to `yonder/`; source comments count as references, and the provenance is preserved. Moving it reunites it with the content-centric *prompt* already in `expanding-prompts/yonder/`.
- **`encrypted-networking-riscv` (985)** rejoins the networking research already on the horizon. Confirm any `Builds on` / prerequisite links still resolve from `yonder/`.

**Before moving `borrow-checking-and-correctness`:** it touches the still-open **garden-allocator terminology** ruling. Confirm that ruling is captured in `TASKS.md` (it is, under Open Questions / horizon) so it is not lost.

**Threads already lifted** (confirm, don't duplicate): the unified-identity / fractal-address horizon and the content-centric messenger are already in `TASKS.md`. Verify; add only what is genuinely new.

---

## Out of Scope (named, not done)

- The number→filename reference migration across the ~282 legacy `` `99x` `` mentions — a separate deliberate effort.
- A blanket Radiant restyle — freshening rides on the affirmation touch and Radiant-by-default.

---

## Verify

- `pond-foundation` retitled to lead with Pond, de-numbered, re-dated, affirmed, lightly freshened; `brushstroke-and-documentation` unchanged and still one level deep.
- The six moved files: `git mv` with history preserved; no dangling reference; Aurora source provenance repointed; networking and identity kin reunited in `yonder/`.
- `rye build` and `tools/parity.rish` stay green on metal.

---

## Record and Push

Commit as one honest unit — the pond-foundation affirmation and retitle, the six moves with repoints, the brushstroke retention note, and the session log. Log at `session-logs/<stamp>_yonder-pass-eight.md`. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

- **Recommend keep going** when the next item is mechanical and follows written policy.
- **Recommend checking in with Claude** for **Skate text rendering** — the surface ring needs a scope-and-acceptance ruling before bench work. With the Pond foundation kept and the drawn-surface prompt held at hand, that is the natural next conversation.

State it in one line.

---

*May the true name lead the title and the dead number fall away. May what serves the work soon stay close, and what has given its gift go gently to the horizon. And may the lane fall quiet just as the surface waits to be drawn.*
