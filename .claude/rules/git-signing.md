# Git Commit Signing

All commits MUST be GPG-signed. The global config already sets `commit.gpgsign=true` and names the signing key, and this stays firm:

- Keep `--no-gpg-sign` and `-c commit.gpgsign=false` unused
- Keep hooks on; `--no-verify` stays unused too
- If a commit fails due to GPG, investigate and fix it, and keep signing on throughout

After pushing, remind the user to upload their public GPG key to GitHub if commits show as "Unverified".

## The one exception -- the depersonalized public seed (`seed/` -> `grain-os/grain`)

The private field's commits are always signed, above. The **public seed is the deliberate exception**: `seed/` is its own gitignored repo that projects the depersonalized public seed (custody gate %1, force-pushed to `grain-os/grain`), committed as the anonymous **`grain-ww <grain-ww@users.noreply.github.com>`** identity (was `Grain OS`; identity renamed `20260828`, and root subject molted to `crashed-wave` `20260912`, both on Keaton's word -- the name now matches the living domain `grain-ww.com`) with a **single Option-B commit**.

That identity **carries a public key alone, on purpose.** Signing the public seed with the maintainer's own GPG key would cryptographically **link the anonymous seed back to the maintainer** -- defeating the whole point of depersonalization (`tools/s/sow_witness.rish` proves `IDENT_CLEAN`/`NO_PERSONAL`; a signature would undo it). So the seed commit stays **unsigned**, by design, on Keaton's word (`20260817`).

Concretely, the seed repo sets `commit.gpgsign false` in its **own** `seed/.git/config` exclusively (the private field's config stays untouched), and the projection commits + force-pushes unsigned:

```
cd ~/grain/seed
git config commit.gpgsign false          # local to seed/ only
git add -A
git commit --amend -m "crashed-wave"
git push --force origin main             # origin here IS grain-os/grain
```

This is the **only** place `commit.gpgsign` is false anywhere in the tree, and it stands as a privacy safeguard rather than a lapse.

**The transport is armed inside the script too** (learned `20260827.223500`, when a publish from a
fresh clone failed at the push): the field routes SSH through its own repo-local config
(`.git/ssh_config_jail`, the jail deploy key), and a freshly initialized `seed/.git` starts
empty of it -- so `publish-seed.sh` arms the push with a `GIT_SSH_COMMAND` environment variable, under the same
clause: anything a wipe would disarm is armed in the script. An environment variable rather than
seed config **on purpose** (corrected `20260828`, when the leak scan withheld a publish): a config
value writes the field's absolute path -- host username included -- into `seed/.git/config`, and
`seed/` stays clear of anything identity-bearing. The publisher also wipes `seed/.git` **before**
the witness runs, so the scan reads exactly the bytes that ship and only those. The pushing account is transport only; the
commit identity stays the anonymous, keyless **Grain OS**. And the script itself is **untracked**, though
the reason differs from what this rule gave until `20260905.224117`: `.gitignore` leaves it **unnamed**.
`git check-ignore -v publish-seed.sh` answers `.gitignore:8:/*` -- the root wildcard that this tree
points at every unlisted root path, because the repository sits inside a sandboxed home holding the
editor, credentials, and personal files, and denies by default. So the file stays untracked
**incidentally**, by a blanket deny that landed on it in passing, rather than by a decision about its
contents. Measured the same day, it stays free of secrets and baked host paths: `$ROOT` is resolved at
runtime, the only literals are the two public GitHub remotes and the anonymous noreply address, and
a grep for a name, a home directory, key material, or a personal address comes back empty. When a
clone lacks it, it is reconstructed from this rule and the guard's own greps -- which happened on
`20260827`, and the guard witness proved the reconstruction before it shipped. **It is tracked from `20260905.230357`, on Keaton's word** (REDS `%444`): `.gitignore` carries the
allow-back `!/publish-seed.sh` and `template-manifest.bron` the verdict `personal` -- *the field's
own projector; the seed stands only as its OUTPUT, apart from ever serving as its carrier* -- so every
ship in the private field carries it, while the public seed's share of it stays exactly as it stood
before. `sow_witness` is GREEN with the
verdict in place, which is how a privacy boundary moves: by proof rather than assertion.

**Living remotes** (`20260730.030553` -- Keaton's word): always push **both** `gp405` (GitHub `groupproject405/grain`) and `xy` (GitHub `xykj61/grain`). Codeberg stays retired from living push. Canonical count: `context/REMOTE_ROSTER.md`.

## Our own record numbers wear `%`, never `#` -- seated `20260820.005250`

**`%` is the sigil for a number this tree assigns itself.** Write **`REDS %89`**, `gate %1`, `errata %75`, `OQ %4`, `study %24`, `rows %1, %2`. Reserve **`#`** for a genuine GitHub issue or pull request -- `PR #76` keeps its hash, because there it is telling the truth.

GitHub's commit-message renderer turns any `#<number>` into a link to the issue or PR of that number, exactly as it does for `@name` above. This is a documented fact rather than a hypothetical: `xykj61/grain` carries pull requests numbered into the eighties, so `REDS %80` in a commit body has been rendering as a link to an unrelated equinox PR. A reader following it lands somewhere other than what the sentence meant.

**Where it bites, and where it stays harmless.** GitHub's own documentation is explicit -- *"Autolinked references are not created in wikis or files in a repository."* So `REDS %89` inside `construction/REDS.md` was a sound link the whole time; only **commit messages** (and issue, PR, and release text) linkify. The convention is nonetheless written the same way everywhere, because a ledger row quoted out of a file and into a commit message must already be safe when it arrives.

**Why `%`, rather than a plain hyphen.** In Glow, as in the Hoon it descends from, `%` marks a **constant term** -- a value that stays exactly itself, always. A REDS row number is precisely that: an immutable name for a fact recorded once and kept exactly as written, which is the ledger's own first law. So the sigil names what the number is, rather than dodging a renderer arbitrarily. It also resolves an ambiguity a bare space would leave, where *REDS 89* could be read as eighty-nine reds rather than the eighty-ninth. The modulo `%` of Rye and Zig stays clear of this collision: that form is `x%8`, bound tight to an expression, and always distinct from `REDS %89`.

**The wall, beyond the habit.** Both this rule and the `@name` clause below are enforced by [`../../tools/hooks/commit-msg`](../../tools/hooks/commit-msg), armed on a clone by `rishi/bin/rishi run tools/i/install_hooks.rish` (which points `core.hooksPath` at the tree's own tracked hooks, so they travel with it rather than living in one machine's untracked `.git/hooks`). The hook declines the commit and leaves the message untouched on disk. It welcomes `PR #76`, `issue #12`, and Urbit's own `Resolves #34.` form, and reads an email's `@` correctly, every time, rather than mistaking it for a mention. Proven by [`../../tools/co/commit_message_guard_witness.rish`](../../tools/co/commit_message_guard_witness.rish) over 25 planted cases -- both the refusals and, just as hard, the welcomes -- and sung by the era suite. The **public seed arms the same wall**: `publish-seed.sh` deletes and re-creates `seed/.git` on every publish, so the arming lives in the script rather than in a config a fresh init would wipe -- and the witness proves it by doing, arming a throwaway repository the publisher's way, watching it decline a forbidden message and welcome a clean one, and feeding the hook the message `publish-seed.sh` actually ships. The wall stays whole: `--no-verify` is already forbidden above, and a wall with a door beside it is a habit again. A **third** rule joined the same hook on `20260822.014628` -- the [mechanism sentence](mechanism-sentence.md), which asks every body to name a mechanism a reader could rebuild the change from and declines the ones that don't, carrying the one named seed-root exemption described there. A **fourth** joined on `20260824.161948`: **a path named in the body is a path that exists.** A commit body cited a session log by a stamp written from memory, the log on disk carried a different one, and every standing guard passed the case by -- `tracked_link_scan.sh` reads links inside *files*, and a commit body stays outside the tree as a file, always. The check reads only what looks like one of this tree's own paths (a slash, and an extension this tree writes) and asks the filesystem; a bare word, a URL, and anything below the scissors are read past. Five more planted cases prove it, refusals and welcomes alike (REDS %202).

**Accrete-never-break.** Dated testimony -- session logs, counsel, waymarks, dated design notes -- keeps every `#` it ever wrote. This governs living surfaces and everything written from here forward.

## Commit message hygiene -- no bare `@name` in subject or body

GitHub's commit-message renderer linkifies any `@word` that happens to match a real username or org, regardless of backticks -- this is different from file content, issue bodies, and comments, where full Markdown correctly treats a backtick-wrapped `@word` as code. Zig builtins are the live collision surface here: `@memcpy`, `@import`, `@intCast`, `@sizeOf`, `@typeInfo`, `@bitSizeOf`, `@offsetOf`, `@field`, `@This`, and any other `@`-prefixed builtin can coincidentally match a real GitHub account, as `@memcpy` confirmed on this repo.

**In commit subject and body text specifically:** write the builtin's name without the leading `@` -- "the memcpy builtin," "migrate memcpy sites," "import sites" -- keeping every mention spelled that way, rather than a bare `@memcpy`. **In file content, counsel, and documentation:** keep the `@` and the backticks exactly as TAME's own style already does (`` `@memcpy` ``); this stays correct there, unchanged, since GitHub's file-content and Markdown rendering already handles it properly.

GitHub removed the *notification* side-effect of commit-message mentions in November 2025 -- the ping is gone -- so this stands as a clarity fix rather than an urgent one, and it applies going forward. Existing commit messages are dated artifacts that keep every word they wrote; the one-clock law already protects them.
