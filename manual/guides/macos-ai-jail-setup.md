# Setting Up the Sandbox on macOS

**Language:** EN
**Version:** `20260714.070500`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — witnessed on this fork's own macOS host, including a real jailed-GUI launch; the Rish scripts below are the primary path, with their bash elders kept beside them
**Versions, all enduring:** `20260714.052900` first page (bash launcher) · `060500` Rish-native pair · `070500` the GUI launch actually proven (app binary direct, `--no-sandbox`, Mach/IPC section) and upstream ai-jail's own new macOS backend adopted for CLI agents

---

You are on macOS, and `SOURCE.md`'s Step 6 describes ai-jail. When this guide was first written, that was a Linux-only tool — `bwrap`, namespaces, Landlock — and macOS needed its own path. Two things are true now, and this guide covers both:

1. **Upstream ai-jail itself now runs on macOS.** It grew a native `sandbox-exec` backend, and it is the right tool here for what it was always for: wrapping **terminal agents and shells** (`ai-jail claude`, `ai-jail bash`). Installed and witnessed on this host, v1.13.0.
2. **This project's own launcher jails the Cursor GUI app** — something upstream does not aim at. It is a Rish script generating a Seatbelt profile and launching Cursor.app inside it, with project-local state. The research behind the approach lives in [`external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md`](../../external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md); the gratitude note for upstream's macOS arrival is [`gratitude/20260714-070200_ai-jail-macos-backend.md`](../../gratitude/20260714-070200_ai-jail-macos-backend.md).

**The primary launcher and witness are written in Rish** — [`tools/cursor_jail_macos.rish`](../../tools/cursor_jail_macos.rish) and [`tools/cursor_jail_macos_witness.rish`](../../tools/cursor_jail_macos_witness.rish). The witness now tests the launcher's own emitted profile (one source of truth, no drifting copy). The original bash pair, [`tools/cursor-jail-macos.sh`](../../tools/cursor-jail-macos.sh) and [`tools/cursor_jail_macos_witness.sh`](../../tools/cursor_jail_macos_witness.sh), stays as the elder — same policy, for a host without Rishi built yet.

## What You Get, Plainly

- **Writes are fenced** to this project's own directory, plus `/tmp` and its usual macOS relatives. Anywhere else on disk, a write is denied by the kernel itself — not by convention, not by a linter, by Seatbelt.
- **Reads stay open everywhere.** This is a deliberate, named trade-off (see the study above): enumerating every path your toolchain needs to read from is a maintenance trap no serious sandbox-exec-based tool takes on. The write fence is the real boundary.
- **Network is allowed by default**, and can be denied outright with one flag. There is no partial, per-host filtering at this layer — that would need a proxy in front, a separate later step.
- **There is no macOS `--private-home`.** Your real `$HOME` stays readable inside the sandbox. If that matters for a specific session, ask for that as its own next step; this guide names the gap rather than pretending it is closed.
- **The jailed Cursor opens signed out on first run.** Your normal login lives in `~/Library/Application Support/Cursor` — the default profile, *outside* the fence — so the jail boots from its own fresh `.cursor-state/` instead. That is the isolation working, not a bug. Sign in once inside the jail; the state persists in `.cursor-state/` (gitignored), inside the fence.

## Launch the Jailed Cursor

From any terminal — Terminal.app or otherwise, with or without another Cursor already running:

```bash
cd ~/urbit
rishi/bin/rishi run tools/cursor_jail_macos.rish
```

Cursor opens with its own state under `.cursor-state/`, and every write it or its extensions attempt lands only inside `~/urbit` (or fails). The launcher returns immediately; the jailed app keeps running on its own, independent of the terminal that started it.

**Prove the fence before you trust it** (worth doing once per host, and cheap enough to run any time):

```bash
rishi/bin/rishi run tools/cursor_jail_macos_witness.rish
```

Two green lines: a write inside the project succeeding, and a write outside it (to your real `$HOME`) denied. Not simulated — the kernel enforcing the actual profile the launcher emits.

**Deny network for a session** (a review pass with no reason to reach the internet):

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --no-network
```

**Inspect the policy** without launching anything:

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --print-profile
```

**The bash elder works identically** if Rishi is not built yet:

```bash
./tools/cursor-jail-macos.sh [--no-network|--print-profile]
```

## Jail a Terminal Agent Instead (Upstream ai-jail)

For CLI agents and shells — the thing upstream ai-jail wraps natively — install it and use it directly. The Homebrew tap needs no SSH key; the release binary is simplest:

```bash
curl -fsSL https://github.com/akitaonrails/ai-jail/releases/latest/download/ai-jail-macos-aarch64.tar.gz | tar xz
sudo mv ai-jail /usr/local/bin/   # or anywhere on PATH

cd ~/urbit
ai-jail bash        # a fenced shell in this project
ai-jail --dry-run claude   # see the policy without running
```

Witnessed on this host: inside-write succeeded, `$HOME` write denied with `Operation not permitted`. It prints its own honest banner — "macOS backend uses deprecated sandbox-exec; treat this as legacy containment" — which matches this guide's own posture.

## Three Launch Facts, Hard-Won

Each of these cost a real debugging pass on this host (`20260714`, full trail in the session logs); they are why the launcher looks the way it does:

1. **Exec the app binary, never the `cursor` CLI wrapper.** The wrapper (`ELECTRON_RUN_AS_NODE` + `cli.js`) spawns the real app in a detached dance that dies silently under Seatbelt — `bootstrap_check_in … Permission denied` — while the wrapper itself exits 0. It looks like success and launches nothing.
2. **Pass `--no-sandbox`.** Chromium's own internal sandbox cannot nest inside Seatbelt: the GPU and network helpers abort and take the whole app down ("GPU process isn't usable. Goodbye."). This is the same law `SOURCE.md` Step 9 names on Linux, where Chromium's sandbox cannot nest inside `bwrap` either. The real boundary is the outer jail.
3. **Detach stdio.** A spawned child inherits pipes that die with the launching script, and Electron logs constantly — the app boots, then takes a `SIGPIPE` seconds later and vanishes (alive at 12s, gone by 20s, observed). The launcher's one host seam (`nohup … >/dev/null 2>&1 </dev/null`) makes the jailed app independent of both the script's lifetime and the terminal's.

The profile's Mach/IPC/pty section follows the static section of upstream ai-jail's own macOS backend — the proven minimum for an Electron app to boot at all under `(deny default)` — with `mach-register` (Electron's `MachPortRendezvousServer` aborts without it) and `mach-task-name` (its codesign self-check) called out by name.

## When Something Goes Wrong

- **`sandbox-exec: command not found`** — this script is macOS-only; you are not on macOS, or something is unusually broken about this install.
- **`Cursor.app not found`** — install Cursor to `/Applications`, or point `CURSOR_BIN` in `tools/enclosure.conf` at the app's real binary (`…/Cursor.app/Contents/MacOS/Cursor` — not the CLI wrapper) and use the bash elder, which reads that file.
- **A write you expected to work is denied** — the profile only allows writes under this project's own path, `/tmp`, and macOS's usual temp directories. Anything else needs its own named allowance, added deliberately, not opened wide. (A known cosmetic instance: a `SQLITE_READONLY` complaint from an analytics service on first boot — an outside-the-fence write being correctly refused.)
- **The window never appears but the script printed success** — this was the CLI-wrapper trap (fact 1 above); if you see it again, confirm the launcher is executing the app binary directly (`--print-profile` and the `spawn` line in the script name it).

## What Is Still Open

- No network egress *filtering* (only allow-all or deny-all) — a proxy-based follow-up, not built yet.
- No private-`$HOME` substitute for the GUI launcher — reads of your real home directory stay open inside the sandbox. (Upstream ai-jail's `--private-home` covers this for CLI agents, via Seatbelt read-deny lists.)
- This guide covers Cursor specifically; a Zed-in-Seatbelt equivalent, mirroring `SOURCE.md`'s Step 9b, is a natural next guide once this one is proven in daily use.

---

*May the fence hold exactly where it says it holds, and may every gap stay named rather than quietly assumed closed.*
