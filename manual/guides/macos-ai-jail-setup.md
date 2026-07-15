# Setting Up the Sandbox on macOS

**Language:** EN
**Version:** `20260714.190500`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — witnessed on this fork's own macOS host, including a real jailed-GUI launch and a live write-fence probe from inside a running jailed agent window; the Rish scripts below are the primary path, with their bash elders kept beside them
**Versions, all enduring:** `20260714.052900` first page (bash launcher) · `060500` Rish-native pair · `070500` the GUI launch actually proven (app binary direct, `--no-sandbox`, Mach/IPC section) and upstream ai-jail's own new macOS backend adopted for CLI agents · `073300` two more findings from a live agent session: the multi-account SSH `IdentitiesOnly` collision and the GPG trustdb quirk · `081500` `--harden-home` closes the read side of the private-`$HOME` gap for named credential stores, with a dedicated jail-local key generator and an honest limit on self-testing from inside an already-jailed window · `085000` jail-local keys carry real identity from `GLOW_PROFILE.bron`, and a scoped-`GH_TOKEN` path lets `gh` work under `--harden-home` without the real broad token · `183000` the key generator now wires git itself and creates a jail-local `known_hosts` automatically; the harden witness checks `known_hosts` denial mechanically instead of only in prose · `190500` `--private-home` ships a full private-`$HOME` equivalent, enumerated fresh at each launch, correcting a first design that would have been fatal on this host's own layout

---

You are on macOS, and `SOURCE.md`'s Step 6 describes ai-jail. When this guide was first written, that was a Linux-only tool — `bwrap`, namespaces, Landlock — and macOS needed its own path. Two things are true now, and this guide covers both:

1. **Upstream ai-jail itself now runs on macOS.** It grew a native `sandbox-exec` backend, and it is the right tool here for what it was always for: wrapping **terminal agents and shells** (`ai-jail claude`, `ai-jail bash`). Installed and witnessed on this host, v1.13.0.
2. **This project's own launcher jails the Cursor GUI app** — something upstream does not aim at. It is a Rish script generating a Seatbelt profile and launching Cursor.app inside it, with project-local state. The research behind the approach lives in [`external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md`](../../external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md); the gratitude note for upstream's macOS arrival is [`gratitude/20260714-070200_ai-jail-macos-backend.md`](../../gratitude/20260714-070200_ai-jail-macos-backend.md).

**The primary launcher and witness are written in Rish** — [`tools/cursor_jail_macos.rish`](../../tools/cursor_jail_macos.rish) and [`tools/cursor_jail_macos_witness.rish`](../../tools/cursor_jail_macos_witness.rish). The witness now tests the launcher's own emitted profile (one source of truth, no drifting copy). The original bash pair, [`tools/cursor-jail-macos.sh`](../../tools/cursor-jail-macos.sh) and [`tools/cursor_jail_macos_witness.sh`](../../tools/cursor_jail_macos_witness.sh), stays as the elder — same policy, for a host without Rishi built yet.

## What You Get, Plainly

- **Writes are fenced** to this project's own directory, plus `/tmp` and its usual macOS relatives. Anywhere else on disk, a write is denied by the kernel itself — not by convention, not by a linter, by Seatbelt.
- **Reads stay open everywhere.** This is a deliberate, named trade-off (see the study above): enumerating every path your toolchain needs to read from is a maintenance trap no serious sandbox-exec-based tool takes on. The write fence is the real boundary.
- **Network is allowed by default**, and can be denied outright with one flag. There is no partial, per-host filtering at this layer — that would need a proxy in front, a separate later step.
- **A full macOS `--private-home` exists now, alongside `--harden-home`.** `--harden-home` denies reads specifically to the named credential stores (`~/.ssh`, `~/.gnupg`, `~/.aws`, and the rest — see "Denying the Real Credential Stores" below); `--private-home` goes further, denying every top-level entry under the real `$HOME` except this project's own directory. Combine them freely — `--harden-home`'s named list becomes harmlessly redundant once `--private-home` covers the same ground, and each still works fine alone.
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

## Denying the Real Credential Stores (`--harden-home`)

Reads staying open everywhere (above) is a real trade-off, not a free one: combined with network allowed by default, an agent that reads your real `~/.ssh` or `~/.gnupg` and then reaches the network has an exfiltration path that needs no write at all. `--harden-home` closes exactly that path, without touching the general "reads stay open" trade-off for everything else:

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --harden-home
```

It denies reads to a named list of real credential stores under `$HOME` — `~/.ssh`, `~/.gnupg`, `~/.aws`, `~/.config/gh`, `~/.terraform.d`, `~/.docker`, `~/.kube`, `~/.azure`, `~/.gcloud`, `~/.codeberg-token`, `~/.netrc`, `~/.git-credentials`, `~/.npmrc` — and leaves every other read exactly as open as the default profile. It is a **deny-only list of specific paths**, not a blanket "deny all dotfiles, allow back a few" rule: Apple's Seatbelt on this host resolves an overlapping allow/deny pair to **deny, no matter which rule is written first or which is more specific** (proven directly — an `(allow file-read* (literal ...))` placed *before* an overlapping `(deny file-read* (regex ...))` still denies). A blanket-deny-then-allow-back shape would have silently also denied `~/.gitconfig` and every shell rc file it tried to allow back; naming only the credential stores themselves sidesteps that trap entirely.

**Before your first `--harden-home` launch**, generate and register dedicated jail-local keys — from an ordinary terminal, **outside any jail**:

```bash
cd ~/urbit
rishi/bin/rishi run tools/generate_jail_local_keys_macos.rish
```

This makes a fresh SSH deploy key per forge, a jail-local `known_hosts` (fetched fresh via `ssh-keyscan`, since `--harden-home` denies the real `~/.ssh/known_hosts` too — it lives inside the same denied `~/.ssh` subpath, and without a jail-local replacement every push fails with `Host key verification failed` before it ever gets to checking your key), and a passphrase-free, signing-only GPG key — all living under this project's own gitignored `.ssh/` and `.gnupg-rye/`, never your master identity, always revocable, always this one small scope (the same shape `SOURCE.md` Step 8c already names for the Linux launcher). It prints exactly what to paste into GitHub's and Codeberg's key settings; you do the pasting yourself, on purpose. Running key *generation* from outside any jail, rather than delegating it to the agent that will later use the keys, is a deliberate choice — a "dedicated, revocable" key means less if the same agent that will wield it also minted it.

**Git wiring is automatic.** The script itself sets `core.sshCommand` (pointing at a repo-local `.git/ssh_config_urbit` it writes, naming both the identity files and the jail-local `known_hosts`), `gpg.program` (a tiny wrapper exporting `GNUPGHOME`, per `SOURCE.md` Step 8c's own pattern), and `user.signingkey` — nothing to configure by hand afterward. Rerunning the script is safe: it leaves existing key material alone and only refreshes the SSH comment and the repo-local config, so editing `GLOW_PROFILE.bron` and rerunning re-stamps identity without minting new keys.

**Prove it, from outside the jail.** `tools/cursor_jail_macos_harden_witness.rish` checks that `~/.ssh` and `~/.gnupg` are denied while `~/.gitconfig` and the project stay readable, yet only when the shell running it is not already inside a jail:

```bash
rishi/bin/rishi run tools/cursor_jail_macos_harden_witness.rish
```

This is a real, named limit, not a convenience note: proven directly on this host, once a process is already `sandbox_apply`'d, a *second*, nested `sandbox_apply` carrying an explicit `(deny ...)` rule fails outright — `sandbox-exec: sandbox_apply: Operation not permitted` — even though the identical profile applies cleanly as a first, non-nested call, and even though an allow-only nested profile (the plain write-fence witness above) nests without issue. An agent already working inside a jailed window cannot fully self-certify `--harden-home` from within that same window; the witness says so plainly rather than reporting a false pass.

## Using `gh` Inside the Hardened Jail

`--harden-home` denies `~/.config/gh`, so the `gh` CLI cannot even start from inside — it reads that config directory before anything else and gets `operation not permitted` rather than a clean "not found," so it hard-fails. That is the fence doing its job: `~/.config/gh` holds a broad-scope account token, exactly the kind of credential the hardening exists to keep out.

You do not lose `gh`, though — you point it at jail-local state and a **scoped** token instead of your real one:

```bash
export GH_CONFIG_DIR="$PWD/.gh"                  # gitignored; a fresh dir gh owns
export GH_TOKEN="$(cat tools/gh-token.secret)"   # a fine-grained PAT, gitignored
gh ssh-key add .ssh/id_ed25519_jail_github.pub --title "jail-only github"
gh pr create --fill        # PRs, issues, CI checks, releases — all work
```

`GH_TOKEN` provides auth directly, so `gh` never touches the denied real config; `GH_CONFIG_DIR` gives it a jail-local place to keep its own settings. Create the token as a **fine-grained personal access token scoped to this one repository** with only the permissions the task needs (Contents and Administration read/write covers key uploads, pushes, and PRs), store it in the gitignored `tools/gh-token.secret`, and revoke it when the work is done. This keeps everything `--harden-home` bought: a compromised jail sees a single-repo, revocable token, never your whole GitHub account. Copying `~/.config/gh` wholesale still works, yet it drags your real broad token inside the fence — the scoped `GH_TOKEN` is the better trade.

What you genuinely lose by *not* setting this up at all: `gh`'s conveniences — opening PRs, triaging issues, watching CI runs, cutting releases, managing keys — all from the terminal. None of it is irreplaceable (the web UI and plain `git` cover the essentials, and key uploads are a one-time paste), so whether the scoped-token setup is worth it depends on how much of your workflow runs through `gh`. For a mostly-`git` workflow, manual key pastes and the web UI are enough; for heavy PR/issue work, the scoped token pays for itself quickly.

## A Full Private-`$HOME` (`--private-home`)

`--harden-home` denies a short, named list of credential stores. `--private-home` denies the *rest* of your real `$HOME` too — every top-level entry except this project's own directory, enumerated fresh at every launch:

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --private-home
```

**Why not a blanket deny of the whole real `$HOME`?** Because this project's own repository lives *inside* the real `$HOME` on a standard macOS layout — a blanket `(deny file-read* (subpath $HOME))` would deny the project's own path along with everything else, and Apple's Seatbelt resolves an overlapping allow/deny pair to deny, no exceptions, no way to carve the project back out (the same rule `--harden-home` already proved). `--private-home` sidesteps that trap entirely: it lists every top-level `$HOME` entry *except* the project's own directory and denies each individually, so there is never an overlap to resolve in the first place. The full design reasoning, including the shape that was tried and found unbuildable before this one, lives in [`active-designing/20260714-184500_macos-full-private-home-design.md`](../../active-designing/20260714-184500_macos-full-private-home-design.md).

Combine freely with `--harden-home` — the two overlap harmlessly where `--harden-home`'s named credential stores also happen to be top-level `$HOME` entries:

```bash
rishi/bin/rishi run tools/cursor_jail_macos.rish --harden-home --private-home
```

**Prove it, from outside the jail** — same honest self-testing limit as `--harden-home`'s own witness (a nested `sandbox_apply` carrying a `deny` rule fails on this host even when the identical profile applies cleanly as a first, non-nested call):

```bash
rishi/bin/rishi run tools/cursor_jail_macos_private_home_witness.rish
```

**One real, named incompleteness.** A *symlinked* top-level `$HOME` entry gets its own literal path denied, yet Seatbelt evaluates a symlink by its resolved target — if that target lies outside `$HOME` entirely, reading through the symlink is not covered. Closing that fully would mean resolving and denying every symlink's real target too, not built yet.

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

## Two Findings From a Live Jailed Agent Session

A running Cursor agent, working from inside the jail on this repo's own git remotes, hit two rough edges worth naming plainly — neither is a fence failure, both are ordinary tool behavior meeting a write-fenced `$HOME`.

**SSH pushes fail with a wrong-key error, even though the right key exists.** If this Mac's `~/.ssh/config` already carries a `Host github.com` / `Host codeberg.org` block from an earlier, unrelated project — with `IdentitiesOnly yes` and a different `IdentityFile` — that global block wins for *every* repo on the host, this one included, and the push fails with `Permission denied (publickey)` even with the correct key sitting in `~/.ssh/` and already loaded in the agent. The global file is unwritable from inside the jail by design (Step 6's write fence), so fix it per-repo instead, entirely inside the fence:

```bash
cat > .git/ssh_config_urbit <<'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_urbit_github
  IdentitiesOnly yes

Host codeberg.org
  HostName codeberg.org
  User git
  IdentityFile ~/.ssh/id_ed25519_urbit_codeberg
  IdentitiesOnly yes
EOF
git config --local core.sshCommand "ssh -F $PWD/.git/ssh_config_urbit"
```

`.git/` is never tracked, so this file and this config change need no gitignore entry — they simply never leave this one clone.

**`git log --show-signature` and `gpg --list-secret-keys` can hang or fail, even though signing itself works.** Both operations try to update `~/.gnupg/trustdb.gpg`, and the jail's write fence denies that — sometimes as a fast `Operation not permitted`, sometimes as a hang waiting on `gpg-agent`. Plain `gpg --sign` and `git commit` do not hit the same path and complete normally; every signed commit made from inside this jail proves it. Guard any signature-inspecting command with `timeout` so a trustdb stall cannot block a session:

```bash
timeout 10 git --no-pager log --show-signature -1 | cat
```

## When Something Goes Wrong

- **`sandbox-exec: command not found`** — this script is macOS-only; you are not on macOS, or something is unusually broken about this install.
- **`Cursor.app not found`** — install Cursor to `/Applications`, or point `CURSOR_BIN` in `tools/enclosure.conf` at the app's real binary (`…/Cursor.app/Contents/MacOS/Cursor` — not the CLI wrapper) and use the bash elder, which reads that file.
- **A write you expected to work is denied** — the profile only allows writes under this project's own path, `/tmp`, and macOS's usual temp directories. Anything else needs its own named allowance, added deliberately, not opened wide. (A known cosmetic instance: a `SQLITE_READONLY` complaint from an analytics service on first boot — an outside-the-fence write being correctly refused.)
- **The window never appears, yet the script printed success** — this was the CLI-wrapper trap (fact 1 above); if you see it again, confirm the launcher is executing the app binary directly (`--print-profile` and the `spawn` line in the script name it).

## What Is Still Open

- No network egress *filtering* (only allow-all or deny-all) — a proxy-based follow-up, not built yet.
- `--private-home` denies real, symlinked top-level entries only by their own literal path, not by their resolved target — a symlink pointing outside `$HOME` can still leak through. Named above, not yet closed.
- `--harden-home`'s and `--private-home`'s witnesses cannot self-certify from inside an already-jailed window (named above) — both need a human, or a CI runner, on the outside.
- This guide covers Cursor specifically; a Zed-in-Seatbelt equivalent, mirroring `SOURCE.md`'s Step 9b, is a natural next guide once this one is proven in daily use.

---

*May the fence hold exactly where it says it holds, and may every gap stay named rather than quietly assumed closed.*
