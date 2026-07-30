# First Season Personalize — Brix inheritance for a new Grain pier

**Language:** EN  
**Status:** Living guide — Acme / new-steward walk  
**Voice:** Riyo  
**Last updated:** `20260730.154230` · SUNN11  
**Data:** [`tools/gen/season/personalize.template.brix`](../../tools/gen/season/personalize.template.brix) · [`first_season_journeys.brix`](../../tools/gen/season/first_season_journeys.brix) · [`first_season_questions.brix`](../../tools/gen/season/first_season_questions.brix)

---

## What this is

Grain’s shared tree still carries the source pier’s living face in places — names, handles, clone URLs. The living beginner clone is [`xykj61/grain`](https://github.com/xykj61/grain); the agentic lane `autoproject96` stays named in [`REMOTE_ROSTER.md`](../../context/REMOTE_ROSTER.md). This walk gives you a **Brix template** whose filled, **gitignored** instance holds *your* identity and a find/replace map, plus a **first 256-round season** shape: four equinoxes of 64, sixteen journeys of 16.

**Equinox A** opens with two journeys:

1. **personalize-grain** — make the pier yours.  
2. **open-questions-compass** — answer open questions about compass, universals, goals, personality, and interests.

---

## Steps

1. Clone the living public tree or your fork — beginner path [`SOURCE.md`](../../SOURCE.md) (`https://github.com/xykj61/grain.git`).  
2. Copy and fill identity files:
   ```bash
   cp tools/gen/season/personalize.template.brix PERSONALIZE.brix
   cp tools/gen/season/first_season_answers.template.brix first_season_answers.brix
   cp GLOW_PROFILE.template.bron GLOW_PROFILE.bron
   cp GLOW_HOST.template.bron GLOW_HOST.bron
   ```
3. Edit `PERSONALIZE.brix`: set every `your_*` field and every `replace_N_to` value.  
4. Ask Cursor (Agent mode) to apply the replace map to **your living pier papers only** — not to rewrite upstream dated counsel.  
5. Paste the large recursion prompt from [`expanding-prompts/20260730-144833_first-season-256-recursion-template.md`](../../expanding-prompts/20260730-144833_first-season-256-recursion-template.md), inheriting your Brix fields.  
6. Walk journey 0 (personalize) until a signed Verified commit lands under your name.  
7. Walk journey 1 one question at a time; store answers in `first_season_answers.brix` (never commit it).

---

## What stays shared

- Upstream dated testimony (Dunsford, Kaeden seasons) — accrete-never-break.  
- Quin as OS variant and Q-vane.  
- Universals, compass, TAME, Radiant Style.

## What becomes yours

- Name, email, handles, voice, clone URL, timezone.  
- Season name and handback bookmarks.  
- Answers to the open-question bank.

---

*May find/replace be kind. May your first season open in daylight. May asking stay easier than guessing.*
