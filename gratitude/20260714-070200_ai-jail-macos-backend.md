# ai-jail Went Multi-OS — a Dated Note of Thanks

**Stamp:** `20260714.070200` (Pacific)

When this project's macOS enclosure study was written (`20260713.202929`),
[akitaonrails/ai-jail](https://github.com/akitaonrails/ai-jail) was a
Linux-only tool — `bwrap`, namespaces, Landlock — and `SOURCE.md` Step 6
could only be adapted to macOS by building our own Seatbelt launcher.

Upstream has since grown a native macOS backend (`src/sandbox/seatbelt.rs`),
a Homebrew tap, and prebuilt `aarch64` release binaries. Version **1.13.0**
was installed on this host today from the official release artifact and its
write fence witnessed directly: a write inside the project succeeded, a
write to `$HOME` outside it was denied by the kernel.

Two debts this project's own launcher owes it, named plainly:

- The **static SBPL section shape** in `tools/cursor-jail-macos.sh` and
  `tools/cursor_jail_macos.rish` (Mach registration, POSIX shm, pseudo-tty,
  standard devices) follows the proven set in upstream's `seatbelt.rs` —
  the exact allowances that let an Electron app boot at all under
  `(deny default)`.
- Its honest framing — "legacy containment," approximate parity across
  hosts, kernel escapes out of scope — matches the posture our own guide
  takes, and reads like it was written by someone who actually shipped it.

Our own launcher remains the path for jailing the *Cursor GUI app*
specifically (upstream wraps terminal agents and browsers); upstream
`ai-jail` is now also first-class on this Mac for jailing CLI agents and
shells, exactly as `SOURCE.md` always intended on Linux.

*(This note lives at the gratitude root because `gratitude/ai-jail/` is
the whole-copy submodule of upstream itself — the thanks should not sit
inside the thing being thanked.)*
