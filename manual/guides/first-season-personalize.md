# First Chapter Personalize — Brix inheritance for a new Grain pier

**Language:** EN  
**Status:** Living guide — Acme / new-steward walk  
**Voice:** Kyri  
**Last updated:** `20260801.033305` · e149 personal sync · gitignore  
**Data:** [`tools/gen/chapter/personalize.template.brix`](../../tools/gen/chapter/personalize.template.brix) · [`first_season_journeys.brix`](../../tools/gen/chapter/first_season_journeys.brix) · [`first_season_questions.brix`](../../tools/gen/chapter/first_season_questions.brix)  
**Shipping index:** [`docs-geode/templates/README.md`](../../docs-geode/templates/README.md)

---

## What this is

Grain’s shared tree still carries the source pier’s living face in places — names, handles, clone URLs. The living beginner clone is [`xykj61/grain`](https://github.com/xykj61/grain); the agentic lane `groupproject405` stays named in [`REMOTE_ROSTER.md`](../../context/REMOTE_ROSTER.md). This walk hands you a **Brix template** whose filled, **gitignored** instance holds *your* identity and a find/replace map, plus a **first 256-round season** shape: four equinoxes of 64, sixteen journeys of 16.

**Equinox A** opens with two journeys:

1. **personalize-grain** — make the pier yours.  
2. **open-questions-compass** — answer open questions about compass, universals, goals, personality, and interests.

---

## Steps

1. Clone the living public tree or your fork — beginner path [`SOURCE.md`](../../SOURCE.md) (`https://github.com/xykj61/grain.git`).  
2. Copy and fill identity files:
   ```bash
   cp tools/gen/chapter/personalize.template.brix PERSONALIZE.brix
   cp tools/gen/chapter/first_season_answers.template.brix first_season_answers.brix
   cp GLOW_PROFILE.template.kyri GLOW_PROFILE.kyri
   cp GLOW_HOST.template.kyri GLOW_HOST.kyri
   ```
3. Edit `PERSONALIZE.brix`: set every `your_*` field and every `replace_N_to` value.  
4. Ask Cursor (Agent mode) to apply the replace map to **your living pier papers only** — not to rewrite upstream dated counsel.  
5. Paste the large recursion prompt from [`expanding-prompts/date/20260730/20260730-144833_first-season-256-recursion-template.md`](../../expanding-prompts/date/20260730/20260730-144833_first-season-256-recursion-template.md), inheriting your Brix fields.  
6. Walk journey 0 (personalize) until a signed Verified commit lands under your name.  
7. Walk journey 1 one question at a time; store answers in `first_season_answers.brix` (never commit it).

---

## Sync personal files without git

Root [`.gitignore`](../../.gitignore) is deny-all with an allow-list: filled identity files stay **local**, out of every commit. Sync them to the cloud with a **folder sync** tool, rather than by weakening gitignore.

**Recommended set to sync** (copy these paths into Dropbox, Syncthing, iCloud Drive, Nextcloud, or equivalent — one tool, one folder):

| File | Why |
| --- | --- |
| `PERSONALIZE.brix` | Your find/replace map and season inheritance |
| `first_season_answers.brix` | Open-question answers |
| `GLOW_PROFILE.kyri` | Model · voice · timezone |
| `GLOW_HOST.kyri` | Host seam facts |
| `PUBKEYS.md` | When you keep a local pubkeys sheet |
| `tools/key-card.conf` | When present — treat as secret-adjacent |

**How:**

1. Keep the git clone at `~/grain` (or your `your_repo_dir`).  
2. Create a sync folder (e.g. `~/Dropbox/grain-personal/` or a Syncthing folder).  
3. Place **symlinks or copies** of only the gitignored instances above into that sync folder — or sync a small `~/grain-personal/` directory and symlink those files back into `~/grain`.  
4. Keep the whole repository out of Dropbox as the primary git working tree — Dropbox and git both rewrite files; they fight. GitHub (or your forge) owns the tracked tree; Dropbox owns the small personal overlay.

**Why cloud sync rather than git for these:** they carry your name, email, model choices, and sometimes key paths. The deny-all gitignore is the fence; cloud folder sync is the backup and multi-machine carry for what the fence holds out.

---

## What stays shared

- Upstream dated testimony (Dunsford, Kaeden seasons) — accrete-never-break.  
- Quin as OS variant and Q-vane.  
- Universals, compass, TAME, Radiant Style.

## What becomes yours

- Name, email, handles, voice, clone URL, timezone.  
- Chapter name and handback bookmarks.  
- Answers to the open-question bank.

---

*May find/replace be kind. May your first season open in daylight. May asking stay easier than guessing.*
