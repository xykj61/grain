# Setting Up the Sandbox on macOS

**Language:** EN
**Version:** `20260714.052900`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — witnessed on this fork's own macOS host

---

You are on macOS, and `SOURCE.md`'s Step 6 describes ai-jail — a Linux tool, built on `bwrap`, namespaces, and Landlock, none of which exist on macOS. This guide is the macOS path: `sandbox-exec`, the native Seatbelt mechanism every serious macOS sandboxing tool (Bazel, Nix, Homebrew, Docker, Claude Code, Codex) already stands on. The research behind this choice lives in [`external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md`](../../external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md); this guide is the practical follow-through.

## What You Get, Plainly

- **Writes are fenced** to this project's own directory, plus `/tmp` and its usual macOS relatives. Anywhere else on disk, a write is denied by the kernel itself — not by convention, not by a linter, by Seatbelt.
- **Reads stay open everywhere.** This is a deliberate, named trade-off (see the study above): enumerating every path your toolchain needs to read from is a maintenance trap no serious sandbox-exec-based tool takes on. The write fence is the real boundary.
- **Network is allowed by default**, and can be denied outright with one flag. There is no partial, per-host filtering at this layer — that would need a proxy in front, a separate later step.
- **There is no macOS `--private-home`.** Your real `$HOME` stays readable inside the sandbox. If that matters for a specific session, ask for that as its own next step; this guide names the gap rather than pretending it is closed.

## Set It Up

You need nothing beyond what is already on this Mac — `sandbox-exec` ships with macOS itself, and the Cursor CLI is already on `PATH` (confirm with `which cursor`).

```bash
cd ~/urbit
chmod +x tools/cursor-jail-macos.sh tools/cursor_jail_macos_witness.sh
```

**Prove it before you trust it:**

```bash
./tools/cursor_jail_macos_witness.sh
```

You should see two green lines — a write inside the project succeeding, and a write outside it (to your real `$HOME`) being denied with `Operation not permitted`. This is not a simulated result; it is the sandbox actually enforcing the fence, checked fresh every time you run it.

**Launch Cursor inside the sandbox:**

```bash
./tools/cursor-jail-macos.sh
```

Cursor opens with its own state under `.cursor-state/` — separate from your normal, unsandboxed Cursor profile — and every write it or its extensions attempt lands only inside `~/urbit` (or fails).

**To deny network entirely for a session** (useful for a review pass that has no reason to reach the internet):

```bash
./tools/cursor-jail-macos.sh --no-network
```

**To inspect the generated policy** before trusting it, without launching anything:

```bash
./tools/cursor-jail-macos.sh --print-profile
```

## When Something Goes Wrong

- **`sandbox-exec: command not found`** — this script is macOS-only; you are not on macOS, or something is unusually broken about this install.
- **`'cursor' not found on PATH`** — install the Cursor CLI (it ships with Cursor.app; `which cursor` should already resolve to `/opt/homebrew/bin/cursor` or similar on a Homebrew-managed Mac), or set `CURSOR_BIN` in `tools/enclosure.conf`.
- **A write you expected to work is denied** — the profile only allows writes under this project's own path, `/tmp`, and macOS's usual temp directories. Anything else needs its own named allowance, added deliberately, not opened wide.

## What Is Still Open

- No network egress *filtering* (only allow-all or deny-all) — a proxy-based follow-up, not built yet.
- No private-`$HOME` substitute — reads of your real home directory stay open inside the sandbox.
- This guide covers Cursor specifically; a Zed-in-Seatbelt equivalent, mirroring `SOURCE.md`'s Step 9b, is a natural next guide once this one is proven in daily use.

---

*May the fence hold exactly where it says it holds, and may every gap stay named rather than quietly assumed closed.*
