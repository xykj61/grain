# docs-geode / templates

**Stamp:** `20260728.031722`  
**Last refreshed:** `20260801.033305` · e149 Acme personalize pointer crush  
**Status:** Room living — source templates stay in `tools/gen/season/` and repo root; this page is the shipping index.  
**Parent:** [`../README.md`](../README.md)  
**Voice:** Riyo

Shipping genre: **templates**. Bidirectional relative links · Radiant lint · Geode Season rounds.

## Acme Corporation — clone and personalize

| Tracked template | Gitignored instance | Guide |
| --- | --- | --- |
| [`../../tools/gen/season/personalize.template.brix`](../../tools/gen/season/personalize.template.brix) | `PERSONALIZE.brix` (repo root) | [`../../manual/guides/first-season-personalize.md`](../../manual/guides/first-season-personalize.md) |
| [`../../tools/gen/season/first_season_answers.template.brix`](../../tools/gen/season/first_season_answers.template.brix) | `first_season_answers.brix` | same guide |
| [`../../GLOW_PROFILE.template.bron`](../../GLOW_PROFILE.template.bron) | `GLOW_PROFILE.bron` | [`../../SOURCE.md`](../../SOURCE.md) · [`../../context/specs/20260714-015200_glow-profile-and-acme-generic-voice.md`](../../context/specs/20260714-015200_glow-profile-and-acme-generic-voice.md) |
| [`../../GLOW_HOST.template.bron`](../../GLOW_HOST.template.bron) | `GLOW_HOST.bron` | host seam (`uname` · paths) |
| [`../../PUBKEYS.template.md`](../../PUBKEYS.template.md) | `PUBKEYS.md` when used | Part Two keys |

**Root `.gitignore`** denies everything at the pier root, then allow-lists project trees. Personal identity files stay **out of git** by design — copy from the tracked templates; never commit the filled instances.

**Cloud sync of gitignored personal files** (recommended): sync the *instance* files with a folder sync tool (Dropbox, Syncthing, iCloud Drive, Nextcloud — pick one you already trust), **not** by forcing them into git. See the personalize guide § “Sync personal files without git.” The repository itself stays on GitHub (`xykj61/grain` beginner clone); Dropbox is for the small set of pier-local Bron/Brix identity files that gitignore holds back.

## Brix law (reminder)

Declarative only · one field per line · single space between key and value · `#` comments name what each field *is*. Sibling baton shapes: [`../../context/baton-museum/`](../../context/baton-museum/). Season shapes: [`../../tools/gen/season/`](../../tools/gen/season/).

## Baton museum (shapes, not instances)

Thirteen halls under [`../../context/baton-museum/`](../../context/baton-museum/) — including **cell** (counsel printout). Mint instances in session logs / relays; the museum holds only shapes.
