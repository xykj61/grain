# A Full Private-`$HOME` for the macOS Cursor Jail — Scoping, Not Building

**Language:** EN
**Stamp:** `20260714.184500`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Vision register (Two Rooms) — superseded by a build, `20260714.190500` — Keaton chose to build this the same session it was scoped. The shape actually shipped is **neither** of the two named below: both were found unworkable or wasteful once tested against this host's real layout, and a third, better shape emerged and landed as `--private-home` on `tools/cursor_jail_macos.rish` and its bash elder. This document is kept as the honest record of how the design got there, corrected in place rather than quietly replaced. See [`manual/guides/macos-ai-jail-setup.md`](../manual/guides/macos-ai-jail-setup.md) for the shipped, working guide.

---

## What This Answers

`tools/cursor_jail_macos.rish --harden-home` (landed `20260714.081500`, extended `183000`) denies reads to a **named list** of real credential stores under `$HOME` — `~/.ssh`, `~/.gnupg`, `~/.aws`, `~/.config/gh`, and a handful more. Everything else under `$HOME` stays exactly as readable as the plain profile. That closes the one exfiltration path this fork's own security question (`session-logs/20260714-074900_...`) actually named: open reads plus open network needs no write to steal a real identity.

What it does **not** do is hide the rest of `$HOME` — `Documents`, `Downloads`, browser profiles, shell history, every other dotfile a decade of tool installs left behind. Upstream `ai-jail`'s own `--private-home` covers that ground for CLI agents, via a real private home directory. This document asks: what would the equivalent look like for the macOS **GUI** launcher, and is it worth building.

---

## Why the Current Design Stopped Where It Did

The plain profile's own comment already names the trade-off directly: *"enumerating every path your toolchain needs to read from is a maintenance trap."* A **full** private-`$HOME` built the same way `--harden-home` is built — a Seatbelt `deny`-list of everything, with named exceptions — inverts that trap rather than escaping it: instead of naming a short list of credential stores to deny, it would need to name *every single path* git, npm, cargo, the shell, Homebrew, and Cursor itself legitimately read from a real `$HOME` (`~/.gitconfig`, `~/.zshrc` and whatever it sources, `~/.npmrc`, `~/.cargo`, `~/.rustup`, `~/.venv`, and more — the `ls -la ~` from earlier this thread showed roughly ninety top-level entries). Miss one, and a tool fails with a confusing, sandbox-shaped error far from its real cause — exactly the class of surprise the cosmetic `SQLITE_READONLY` note in the guide already shows happening by accident.

That is a real reason to have stopped at the named-credential-store list for now, not a reason to never go further.

---

## Two Shapes, One Clearly Better

**Shape A — extend the deny-list.** Keep growing `--harden-home`'s Seatbelt `(deny file-read* ...)` rules to cover more and more of `$HOME`, eventually approaching "deny everything, allow a few." This is the same shape already in place, just pushed further. It inherits the same trap the design already named: an ever-growing deny-list that must anticipate every real path, where an *omission* is silently unsafe (a path nobody thought to deny stays readable) — the opposite of fail-safe.

**Shape B — a scratch `$HOME`, curated by inclusion.** Launch Cursor with `HOME` pointed at a fresh, mostly-empty directory (say, `.cursor-state/fake-home/`), and symlink in *only* the specific files and directories a working session actually needs — `~/.gitconfig`, `~/.zshrc` (and its own sourced target), and so on, one deliberate line at a time. This is the shape upstream `ai-jail`'s own `--private-home` already uses for CLI agents.

Shape B is the better one, and for a reason bigger than convenience: it **fails safe by default**. A path nobody has symlinked in simply does not exist from the sandboxed app's point of view — the read fails with an ordinary "no such file," not a mysterious permission error, and *omission is the safe direction*. Building the allow-list becomes exactly the incremental, visible, auditable process this repository's own `.gitignore` already models — deny everything, then admit back only what is named — rather than an ever-growing blacklist trying to keep up with every dotfile a decade of tool installs left behind.

---

## What Shape B Would Actually Need

- A `--private-home` flag on `tools/cursor_jail_macos.rish`, mirroring `--harden-home`'s own opt-in shape.
- A scratch home directory under `.cursor-state/` (gitignored, already inside the write fence).
- A curated, committed list of symlink targets — starting minimal (`~/.gitconfig`, shell rc files) and growing only when a real, named breakage asks for it, each addition a visible one-line diff.
- The `HOME` environment variable set for the launched process, alongside the existing `--user-data-dir`/`--extensions-dir` flags.
- A witness proving the negative space: a path *not* on the allow-list reads as absent, not merely denied — the same "prove the fence before you trust it" discipline the write-fence and `--harden-home` witnesses already carry.

None of this touches `--harden-home` itself; the two are complementary; `--harden-home`'s named credential-store denials would layer naturally on top of a Shape B scratch home, if both were ever active together.

---

## The Honest Trade-Off, Named Plainly

Building this costs real, ongoing maintenance — every new tool a working session reaches for is a potential missing symlink, discovered by a confusing failure rather than a clean error message, at least until it earns its own line in the allow-list. `--harden-home`, built and landed already, closes the specific exfiltration path this fork's own security thread actually named. A full private-`$HOME` closes a *broader* one — protecting personal files, browser data, and shell history from a compromised agent's reads — at a cost this design would keep paying for as long as the jail is used daily.

---

## Recommendation

Build Shape B, not Shape A, if and when a full private-`$HOME` is worth building at all — the fail-safe-by-inclusion shape is simply the more honest engineering choice between the two. Whether it is worth building *now* is Keaton's call, not a technical question this document can answer on its own: `--harden-home` already closes the concrete threat this fork named for itself, and a full private-`$HOME` is a broader, more expensive guarantee against a threat model (a compromised agent reading personal, non-credential files) that has not yet been named as a real concern the way the credential-exfiltration path was.

---

## What Actually Shipped, `20260714.190500` — Shape B Was Fatal, and the Real Shape Is Simpler

Keaton chose to build this the same session, and before implementing Shape B, one concrete test against this host's real layout broke it decisively: **this project's own repository lives at `/Users/bhagavan851c05a/urbit` — inside the real `$HOME`.** Shape B's blanket `(deny file-read* (subpath realHome))` would deny the project's own path along with everything else, and Seatbelt's proven deny-always-wins-an-overlap rule means no `(allow ...)` rule could carve the project back out. Shape B, as literally scoped above, is not buildable on this host at all — a fact worth naming loudly rather than discovering after building it.

The fix turned out simpler than either shape considered above, and needs no fake `$HOME`, no symlinks, no `HOME` environment override at all:

**Shape C — enumerate, don't blanket-deny.** List every top-level entry directly under the real `$HOME`, and deny each one individually — *except* the project's own directory. Since the project's path is simply never included in a deny rule in the first place, there is never an overlapping allow/deny pair for Seatbelt to resolve, and the "deny wins" rule that sank Shape B never enters the picture. This keeps Shape B's real virtue (fail-safe by omission for everything actually denied) while sidestepping the exact trap that made it unbuildable here.

Shipped as `--private-home` on both `tools/cursor_jail_macos.rish` and `tools/cursor-jail-macos.sh`, combinable freely with `--harden-home`. Witnessed by `tools/cursor_jail_macos_private_home_witness.rish` (same honest self-testing limit as the `--harden-home` witness — run it from outside any jail).

**One real, named incompleteness, carried forward rather than hidden:** a *symlinked* top-level `$HOME` entry (this host has several, e.g. `~/bhagavan851c05a -> ~/kae3g/bhagavan851c05a`) gets its own literal path denied, yet Seatbelt evaluates a symlink by its *resolved* target — if that target lies outside `$HOME` entirely, reading through the symlink is not covered by this enumeration at all. Closing that gap fully would mean resolving every symlink's real target and denying that too, a further pass not built in this session.

---

*May every boundary this project draws be one it can explain plainly, and may the next one, if it comes, earn its keep before it earns its place.*
