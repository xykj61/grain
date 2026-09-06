# Git Commit Signing

All commits MUST be GPG-signed. The global config already sets `commit.gpgsign=true` and names the signing key. Never bypass this:

- Never use `--no-gpg-sign` or `-c commit.gpgsign=false`
- Never skip hooks with `--no-verify`
- If a commit fails due to GPG, investigate and fix -- do not disable signing

After pushing, remind the user to upload their public GPG key to GitHub if commits show as "Unverified".

## The one exception -- the depersonalized public seed (`seed/` -> `grain-os/grain`)

The private field's commits are always signed, above. The **public seed is the deliberate exception**: `seed/` is its own gitignored repo that projects the depersonalized public seed (custody gate %1, force-pushed to `grain-os/grain`), committed as the anonymous **`grain-ww <grain-ww@users.noreply.github.com>`** identity (was `Grain OS`; renamed with the crashed-meteor bump, `20260828` on Keaton's word -- the name now matches the living domain `grain-ww.com`) with a **single Option-B commit**.

That identity **has no secret key on purpose.** Signing the public seed with the maintainer's own GPG key would cryptographically **link the anonymous seed back to the maintainer** -- defeating the whole point of depersonalization (`tools/s/sow_witness.rish` proves `IDENT_CLEAN`/`NO_PERSONAL`; a signature would undo it). So the seed commit is **unsigned**, by design, on Keaton's word (`20260817`).

Concretely, the seed repo sets `commit.gpgsign false` in its **own** `seed/.git/config` (never the private field's), and the projection commits + force-pushes unsigned:

```
cd ~/grain/seed
git config commit.gpgsign false          # local to seed/ only
git add -A
git commit --amend -m "crashed-meteor"
git push --force origin main             # origin here IS grain-os/grain
```

This is the **only** place `commit.gpgsign` is false anywhere in the tree, and it is a privacy safeguard, not a lapse.

**The transport is armed inside the script too** (learned `20260827.223500`, when a publish from a
fresh clone failed at the push): the field routes SSH through its own repo-local config
(`.git/ssh_config_jail`, the jail deploy key), and a freshly initialized `seed/.git` inherits none
of it -- so `publish-seed.sh` arms the push with a `GIT_SSH_COMMAND` environment variable, under the same
clause: anything a wipe would disarm is armed in the script. An environment variable rather than
seed config **on purpose** (corrected `20260828`, when the leak scan refused a publish): a config
value writes the field's absolute path -- host username included -- into `seed/.git/config`, and
nothing identity-bearing touches `seed/` at all. The publisher also wipes `seed/.git` **before**
the witness runs, so the scan reads exactly the bytes that ship and nothing beside them. The pushing account is transport only; the
commit identity stays the anonymous, keyless **Grain OS**. And the script itself is **untracked**, though
not for the reason this rule gave until `20260905.224117`: `.gitignore` does **not** name it.
`git check-ignore -v publish-seed.sh` answers `.gitignore:8:/*` -- the root wildcard that this tree
points at every unlisted root path, because the repository sits inside a sandboxed home holding the
editor, credentials, and personal files, and denies by default. So the file is untracked
**incidentally**, by a blanket deny nobody aimed at it, rather than by a decision about its
contents. Measured the same day, it carries no secret and no baked host path: `$ROOT` is resolved at
runtime, the only literals are the two public GitHub remotes and the anonymous noreply address, and
a grep for a name, a home directory, key material, or a personal address finds nothing. When a
clone lacks it, it is reconstructed from this rule and the guard's own greps -- which happened on
`20260827`, and the guard witness proved the reconstruction before it shipped. **It is tracked from `20260905.230357`, on Keaton's word** (REDS `%444`): `.gitignore` carries the
allow-back `!/publish-seed.sh` and `template-manifest.bron` the verdict `personal` -- *the field's
own projector; the seed is its OUTPUT, never its carrier* -- so every ship in the private field
carries it and the public seed carries it no more than before. `sow_witness` is GREEN with the
verdict in place, which is how a privacy boundary is moved: proven, not asserted.

**Living remotes** (`20260730.030553` -- Keaton's word): always push **both** `gp405` (GitHub `groupproject405/grain`) and `xy` (GitHub `xykj61/grain`). Codeberg stays retired from living push. Canonical count: `context/REMOTE_ROSTER.md`.

## Our own record numbers wear `%`, never `#` -- seated `20260820.005250`

**`%` is the sigil for a number this tree assigns itself.** Write **`REDS %89`**, `gate %1`, `errata %75`, `OQ %4`, `study %24`, `rows %1, %2`. Reserve **`#`** for a genuine GitHub issue or pull request -- `PR #76` keeps its hash, because there it is telling the truth.

GitHub's commit-message renderer turns any `#<number>` into a link to the issue or PR of that number, exactly as it does for `@name` above. This is **not** a hypothetical: `xykj61/grain` carries pull requests numbered into the eighties, so `REDS %80` in a commit body has been rendering as a link to an unrelated equinox PR. A reader following it lands somewhere the sentence never meant.

**Where it bites, and where it does not.** GitHub's own documentation is explicit -- *"Autolinked references are not created in wikis or files in a repository."* So `REDS %89` inside `construction/REDS.md` was never a broken link; only **commit messages** (and issue, PR, and release text) linkify. The convention is nonetheless written the same way everywhere, because a ledger row quoted out of a file and into a commit message must already be safe when it arrives.

**Why `%` and not a plain hyphen.** In Glow, as in the Hoon it descends from, `%` marks a **constant term** -- a value that is exactly itself and never varies. A REDS row number is precisely that: an immutable name for a fact recorded once and never edited, which is the ledger's own first law. So the sigil is not an arbitrary dodge of a renderer; it says what the number is. It also resolves an ambiguity a bare space would leave, where *REDS 89* could be read as eighty-nine reds rather than the eighty-ninth. The modulo `%` of Rye and Zig is no collision: that form is `x%8`, bound tight to an expression, never `REDS %89`.

**The wall, not just the habit.** Both this rule and the `@name` clause below are enforced by [`../../tools/hooks/commit-msg`](../../tools/hooks/commit-msg), armed on a clone by `rishi/bin/rishi run tools/i/install_hooks.rish` (which points `core.hooksPath` at the tree's own tracked hooks, so they travel with it rather than living in one machine's untracked `.git/hooks`). The hook refuses the commit and leaves the message untouched on disk. It welcomes `PR #76`, `issue #12`, and Urbit's own `Resolves #34.` form, and never mistakes an email's `@` for a mention. Proven by [`../../tools/co/commit_message_guard_witness.rish`](../../tools/co/commit_message_guard_witness.rish) over 25 planted cases -- both the refusals and, just as hard, the welcomes -- and sung by the era suite. The **public seed arms the same wall**: `publish-seed.sh` deletes and re-creates `seed/.git` on every publish, so the arming lives in the script rather than in a config a fresh init would wipe -- and the witness proves it by doing, arming a throwaway repository the publisher's way, watching it refuse a forbidden message and welcome a clean one, and feeding the hook the message `publish-seed.sh` actually ships. There is no bypass: `--no-verify` is already forbidden above, and a wall with a door beside it is a habit again. A **third** rule joined the same hook on `20260822.014628` -- the [mechanism sentence](mechanism-sentence.md), which refuses a body that names no mechanism a reader could rebuild the change from, and carries the one named seed-root exemption described there. A **fourth** joined on `20260824.161948`: **a path named in the body is a path that exists.** A commit body cited a session log by a stamp written from memory, the log on disk carried a different one, and no standing guard reached it -- `tracked_link_scan.sh` reads links inside *files*, and a commit body is never a file in the tree. The check reads only what looks like one of this tree's own paths (a slash, and an extension this tree writes) and asks the filesystem; a bare word, a URL, and anything below the scissors are read past. Five more planted cases prove it, refusals and welcomes alike (REDS %202).

**Accrete-never-break.** Dated testimony -- session logs, counsel, waymarks, dated design notes -- keeps every `#` it ever wrote. This governs living surfaces and everything written from here forward.

## Commit message hygiene -- no bare `@name` in subject or body

GitHub's commit-message renderer linkifies any `@word` that happens to match a real username or org, regardless of backticks -- this is different from file content, issue bodies, and comments, where full Markdown correctly treats a backtick-wrapped `@word` as code. Zig builtins are the live risk here: `@memcpy`, `@import`, `@intCast`, `@sizeOf`, `@typeInfo`, `@bitSizeOf`, `@offsetOf`, `@field`, `@This`, and any other `@`-prefixed builtin can coincidentally match a real GitHub account, as `@memcpy` confirmed on this repo.

**In commit subject and body text specifically:** write the builtin's name without the leading `@` -- "the memcpy builtin," "migrate memcpy sites," "import sites" -- never a bare `@memcpy`. **In file content, counsel, and documentation:** keep the `@` and the backticks exactly as TAME's own style already does (`` `@memcpy` ``); this is correct there and needs no change, since GitHub's file-content and Markdown rendering already handles it properly.

GitHub removed the *notification* side-effect of commit-message mentions in November 2025 -- no one is actually being pinged -- so this is a clarity fix, not an urgent one, and it applies going forward. Existing commit messages are dated artifacts and are not rewritten to fix this; the one-clock law already protects them.
