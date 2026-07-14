# Setting Up the Sandbox on macOS

**Language:** EN
**Version:** `20260714.060500`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — witnessed on this fork's own macOS host; the Rish scripts below are now the primary path, with their bash elders kept beside them for reference

---

You are on macOS, and `SOURCE.md`'s Step 6 describes ai-jail — a Linux tool, built on `bwrap`, namespaces, and Landlock, none of which exist on macOS. This guide is the macOS path: `sandbox-exec`, the native Seatbelt mechanism every serious macOS sandboxing tool (Bazel, Nix, Homebrew, Docker, Claude Code, Codex) already stands on. The research behind this choice lives in [`external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md`](../../external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md); this guide is the practical follow-through.

**The primary launcher and witness are now written in Rish** — [`tools/cursor_jail_macos.rish`](../../tools/cursor_jail_macos.rish) and [`tools/cursor_jail_macos_witness.rish`](../../tools/cursor_jail_macos_witness.rish) — matching the same SBPL profile byte for byte (same fence, same `/dev/null` allowance, same trade-offs named below). The original bash pair, [`tools/cursor-jail-macos.sh`](../../tools/cursor-jail-macos.sh) and [`tools/cursor_jail_macos_witness.sh`](../../tools/cursor_jail_macos_witness.sh), stays as the elder — a working reference and a fallback for a host without Rishi built yet.

## What You Get, Plainly

- **Writes are fenced** to this project's own directory, plus `/tmp` and its usual macOS relatives. Anywhere else on disk, a write is denied by the kernel itself — not by convention, not by a linter, by Seatbelt.
- **Reads stay open everywhere.** This is a deliberate, named trade-off (see the study above): enumerating every path your toolchain needs to read from is a maintenance trap no serious sandbox-exec-based tool takes on. The write fence is the real boundary.
- **Network is allowed by default**, and can be denied outright with one flag. There is no partial, per-host filtering at this layer — that would need a proxy in front, a separate later step.
- **There is no macOS `--private-home`.** Your real `$HOME` stays readable inside the sandbox. If that matters for a specific session, ask for that as its own next step; this guide names the gap rather than pretending it is closed.

## Set It Up

You need nothing beyond what is already on this Mac — `sandbox-exec` ships with macOS itself, Rishi is already built at `rishi/bin/rishi` (see `SOURCE.md` / the parity witness run if not), and the Cursor CLI is already on `PATH` (confirm with `which cursor`).

```bash
cd ~/urbit
```

**Prove it before you trust it:**

```bash
rishi/bin/rishi run tools/cursor_jail_macos_witness.rish
```

You should see two green lines — a write inside the project succeeding, and a write outside it (to your real `$HOME`) being denied. This is not a simulated result; it is the sandbox actually enforcing the fence, checked fresh every time you run it.

**Launch Cursor inside the sandbox:**

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish
```

Cursor opens with its own state under `.cursor-state/` — separate from your normal, unsandboxed Cursor profile — and every write it or its extensions attempt lands only inside `~/urbit` (or fails). The launcher spawns Cursor and returns immediately; Cursor keeps running on its own.

**To deny network entirely for a session** (useful for a review pass that has no reason to reach the internet):

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --no-network
```

**To inspect the generated policy** before trusting it, without launching anything:

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --print-profile
```

**The bash elders still work identically**, if you ever need them (a host without Rishi built, or just to compare):

```bash
chmod +x tools/cursor-jail-macos.sh tools/cursor_jail_macos_witness.sh
./tools/cursor_jail_macos_witness.sh
./tools/cursor-jail-macos.sh [--no-network|--print-profile]
```

## When Something Goes Wrong

- **`sandbox-exec: command not found`** — this script is macOS-only; you are not on macOS, or something is unusually broken about this install.
- **`'cursor' not found on PATH`** — install the Cursor CLI (it ships with Cursor.app; `which cursor` should already resolve to `/opt/homebrew/bin/cursor` or similar on a Homebrew-managed Mac). The bash elder honors `CURSOR_BIN` in `tools/enclosure.conf`; the Rish launcher does not read that file yet and calls `cursor` directly — a named simplification, not an oversight.
- **A write you expected to work is denied** — the profile only allows writes under this project's own path, `/tmp`, and macOS's usual temp directories. Anything else needs its own named allowance, added deliberately, not opened wide.

## What Is Still Open

- No network egress *filtering* (only allow-all or deny-all) — a proxy-based follow-up, not built yet.
- No private-`$HOME` substitute — reads of your real home directory stay open inside the sandbox.
- This guide covers Cursor specifically; a Zed-in-Seatbelt equivalent, mirroring `SOURCE.md`'s Step 9b, is a natural next guide once this one is proven in daily use.

---

*May the fence hold exactly where it says it holds, and may every gap stay named rather than quietly assumed closed.*
