# SOURCE — From Nothing to a Signed, Sandboxed Home

**Language:** EN
**Version:** `20260714.190500` (Glow warm-aura date atom — chronological, later-is-larger)
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**By:** Rio 3, in the radiant voice, with **Keaton Dunsford** as coauthor
**Status:** Living guide — last touched `20260714.190500` (Step 6 gains `--private-home`, a full private-`$HOME` equivalent alongside `--harden-home`)

---

## What This Is

This is the whole path, start to finish, for someone brand new to coding who wants to stand where we stand: two homes for their code, a key to knock with at each, a seal that signs their name, an editor with a thoughtful AI at its side, and a gentle sandbox where that AI can work — and even sign commits — without ever touching the rest of the machine.

You do not need prior experience. Each step says what to do, and why it matters, so the shape of the thing makes sense as you build it. Wherever you see a placeholder like `youruser` or `you@example.com` or an `EXAMPLE…` fingerprint, put your own value in its place.

By the end you will have a repository that an AI agent can grow and **commit to, signed and verified, entirely from inside the sandbox** — nothing to sign by hand, nothing leaking out.

---

## The Shape of the Destination

Eight pieces fit together:

1. **Two accounts** — Codeberg (home) and GitHub (mirror).
2. **Two SSH keys** — one per forge, for authenticating pushes.
3. **One GPG key** — your signing seal, trusted by both forges.
4. **Fingerprint QR codes** — your keys turned into shareable art.
5. **Cursor** — the editor, with Claude in Agent mode.
6. **ai-jail** — the sandbox (becoming **Pond**, our TAME-style reimplementation in Rye).
7. **gitconfig + ssh config** — teaching the tools who you are.
8. **In-sandbox signing** — the quiet machinery that lets the agent sign for you.

Take them in order. Each rests on the one before.

---

## Step 1 — Two Homes for Your Code

Make two accounts. They are free.

- **Codeberg** — <https://codeberg.org> — a community-run, nonprofit forge. We treat it as home.
- **GitHub** — <https://github.com> — the largest forge. We keep a mirror here for reach.

Pick one handle and use it on both if you can, so your identity reads the same everywhere — for example, `youruser`. Verify your email on each account; the Verified badge later depends on it.

---

## Step 2 — Two Keys to Knock With (SSH)

An SSH key is how a forge knows it is really you pushing code. You make a **pair**: a private half that stays secret on your machine, and a public half you hand to the forge. We make one pair per forge, so each can be rotated on its own.

```bash
ssh-keygen -t ed25519 -C "you@example.com codeberg" -f ~/.ssh/id_ed25519_codeberg
ssh-keygen -t ed25519 -C "you@example.com github"   -f ~/.ssh/id_ed25519_github
```

Press Enter to accept the location; set a passphrase if you like (an agent can remember it for you). Now read each **public** half and add it to the matching account — Codeberg: *Settings → SSH/GPG Keys → Add Key*; GitHub: *Settings → SSH and GPG keys → New SSH key*:

```bash
cat ~/.ssh/id_ed25519_codeberg.pub   # paste into Codeberg
cat ~/.ssh/id_ed25519_github.pub     # paste into GitHub
```

Confirm each key's fingerprint any time with:

```bash
ssh-keygen -lf ~/.ssh/id_ed25519_codeberg.pub
# SHA256:EXAMPLEcodebergFINGERPRINTexampleEXAMPLEexample00
```

---

## Step 3 — One Seal for Your Name (GPG)

Where an SSH key proves *you may push*, a GPG key proves *you wrote this* — it signs your commits so each one carries your name with cryptographic weight. One signing key serves both forges.

```bash
gpg --quick-generate-key "Your Name <you@example.com>" ed25519 sign 2y
gpg --list-secret-keys --keyid-format=long      # note the 40-character fingerprint
```

Export the **public** half and add it to *both* forges' **GPG Keys** sections (the same place as SSH keys on Codeberg; *SSH and GPG keys* on GitHub):

```bash
gpg --armor --export EXAMPLEGPGFINGERPRINT0000000000000000000000
```

Your signing fingerprint, for your records, reads like:

```
EXA1 0756 6D9E 2793 AFD9  FF2A B078 5BAB 4DBF C172
```

The private half never leaves your keeping. The public half travels freely.

---

## Step 4 — Fingerprints as Art (QR Codes)

A fingerprint is meant to be shared and checked. It is also, quietly, beautiful — so this repository carries a small tool that turns yours into a card: three QR codes — SSH for Codeberg, SSH for GitHub, and your OpenPGP signing key — gathered under your name in the typeface that loves code, rendered once tall and once wide.

The tool reads your details from a config file, so it works for anyone. Copy the template, fill in your own values, and run it:

```bash
cp tools/key-card.conf.example tools/key-card.conf   # then edit with your details
# macOS (Homebrew qrencode + imagemagick), audited end to end in Rish:
rishi/bin/rishi run tools/make_key_card.rish
# Linux (vendored libqrencode + apt fonts):
./tools/make-key-card.sh
```

Your `tools/key-card.conf` holds only **public** information — your name, your forge handle, your email, and the three fingerprints you already gathered in Steps 2 and 3. Even so, it stays out of git (the committed `.example` is the only version tracked), so the repository ships the template and you keep the fill-in. To read your fingerprints back at any time:

```bash
ssh-keygen -lf ~/.ssh/id_ed25519_codeberg.pub    # the SHA256:... line
ssh-keygen -lf ~/.ssh/id_ed25519_github.pub
gpg --fingerprint you@example.com                 # the spaced 40-hex string
```

On **macOS**, the Rish orchestrator ([`tools/make_key_card.rish`](tools/make_key_card.rish)) is the recommended path: it first audits every declared fingerprint against the real key on your host (so a card can never ship a wrong fingerprint), renders the cards with Homebrew's `qrencode` and ImageMagick, then audits the output PNGs — a green run proves the whole chain. Install its two dependencies once with `brew install qrencode imagemagick`; the font is **Menlo**, pinned — it ships on every Mac, so there is no font-install step at all. On **Linux**, `./tools/make-key-card.sh` builds `qrencode` from the vendored `gratitude/libqrencode` submodule and uses `apt`-installed Fira Code (`sudo apt install gcc libpng-dev pkg-config imagemagick fonts-firacode`) — the two hosts keep their own settled font choice.

The result is two images at the repository root, `keys_<font>_<yourhandle>_landscape.png` and `…_portrait.png`, in a **plain white-background, black-text palette** that prints cleanly and scans reliably (override `BG`/`FG` in the config for a themed card). Pin them to a profile, print them, keep them: they prove your identity to anyone who scans. The full walkthrough, written for any contributor, is [`manual/guides/key-cards-setup.md`](manual/guides/key-cards-setup.md).

Alongside the composited PNG card, `rishi/bin/rishi run tools/make_key_qr_svg.rish` writes each of the three QR codes again as a small, standalone **SVG** — fully textual, diffable, no binary blob, since `qrencode` emits SVG directly for free. The PNG card stays the one to print; the SVGs exist for anywhere a checkable, text-native form fits better.

If Cursor is already set up (Step 5), you can simply ask the agent to do all of this for you — *"fill in my key-card config and render my cards"* — and it will, entirely from inside the sandbox.

> A note on the horizon: both halves of this tool lean on others' work we are grateful for — `libqrencode` for the codes, ImageMagick for the composition. In time, both are candidates to be re-grown in Rye, our own language, the same way **Pond** re-grows the sandbox.

---

## Step 5 — Your Hands and Eyes (Cursor + Claude)

Go to **<https://cursor.com/download>**, choose **Linux**, and download the **x86_64 AppImage** — the right build for **Framework** laptops, whether Intel or AMD, on both NixOS and Ubuntu. A `.deb` is offered too, yet the sandbox launcher runs the AppImage, so the AppImage is the one to fetch. Save it into the project folder (or into `~/Downloads` and move it in), since Step 6 extracts it there.

Subscribe to **Cursor Pro** or **Cursor Ultra** — the plans that give you generous access to the strongest models.

Open Cursor, enter **Agent mode**, and choose a **Claude** model (the Opus and Sonnet families are excellent partners for this kind of work). Agent mode lets the model read your project, run commands, and make changes with your blessing — which is exactly what the rest of this guide leans on.

---

## Step 6 — A Gentle Enclosure (ai-jail, becoming Pond)

We run the editor and its agent inside a sandbox, so they touch only the project folder — never your wider home, your keys, or your secrets. The tool is **ai-jail**.

> A note on the horizon: ai-jail is a Rust project we are grateful for, and our work in progress is **Pond** — a TAME-style reimplementation in our own language, Rye. A pond is a bounded, living enclosure rather than a cell: water held kindly within clear edges, where work can flourish in safety. Until Pond is ready, ai-jail is the enclosure.

Install ai-jail (it uses `bwrap` on Linux):

```bash
cargo install ai-jail            # or build from source; see github.com/akitaonrails/ai-jail
```

> **Host OS:** we recommend the **latest stable NixOS** for new setups — bubblewrap and ai-jail install cleanly via nixpkgs or the project's Nix flake (`nix profile install github:akitaonrails/ai-jail`). This guide still documents **Ubuntu 24.04 LTS** first while our own hosts are **in transition**; see `context/specs/enclosure-editors.md` for the NixOS map and dual-editor templates.

Cursor ships as an AppImage; unpack it once in the project folder so the sandbox can launch it. The launcher runs the **extracted `AppRun`**, not the raw `.AppImage` file — a kind choice, because a raw AppImage mounts through FUSE, while `--appimage-extract` unpacks into `squashfs-root/` and the launcher runs `AppRun` directly, with no FUSE in the path.

```bash
cd ~/yourrepo
./Cursor-3.9.16-x86_64.AppImage --appimage-extract   # once → squashfs-root/
```

When you upgrade Cursor, extract the new AppImage the same way (or use `./tools/cursor-jail.sh --extract ./Cursor-*.AppImage`). The AppImage and `squashfs-root/` stay in the project directory and are not committed — only the launch scripts ship in git.

**Ubuntu (24.04 LTS).** The extract path needs nothing extra. Only if someone runs the `.AppImage` *directly* would they need FUSE — and on 24.04 that package is **`libfuse2t64`** (not `fuse`, not the old `libfuse2`). Since the jail path extracts, this stays a footnote.

**NixOS (Framework and similar).** NixOS does not run generic dynamically linked executables out of the box — and that holds for the extracted `AppRun` as much as for the `.AppImage`. Enable AppImage support in system config with `programs.appimage.enable = true;` and `programs.appimage.binfmt = true;` (NixOS 24.05 and later), which lets a `.AppImage` run directly when you choose that path; the older route is `appimage-run` from nixpkgs. Because binfmt registration acts on the `.AppImage` file, the launcher's **extracted-`AppRun`** path may additionally want an FHS wrapper — `steam-run` or `nix-ld` — to supply the dynamic loader and libraries. On a tested Framework host, extract once, then `./tools/cursor-jail.sh` from the repo root is the working form; if `AppRun` fails with loader errors, wrap the launch with `steam-run` from nixpkgs. The full NixOS map lives in **`context/specs/enclosure-editors.md`**.

**macOS.** There is no AppImage and no `bwrap` here; Cursor already ships as `Cursor.app`, and the enclosure is Apple's own Seatbelt (`sandbox-exec`), driven by this project's own launcher rather than `cargo install ai-jail`. Two tools share the work: upstream **ai-jail** grew a native macOS backend and is the right choice for jailing a **terminal agent or shell** (`ai-jail bash`, `ai-jail claude`); this project's own [`tools/cursor_jail_macos.rish`](tools/cursor_jail_macos.rish) (Rish-native) and [`tools/cursor-jail-macos.sh`](tools/cursor-jail-macos.sh) (bash elder) jail the **Cursor GUI app itself**, which upstream does not aim at. Both are witnessed live — a write inside the project succeeds, a write to the real `$HOME` is denied by the kernel, proven from inside a running jailed window, not just by a scripted witness. The full walkthrough, including three hard-won launch traps (never exec the `cursor` CLI wrapper; pass `--no-sandbox` since Chromium cannot nest inside Seatbelt any more than inside `bwrap`; detach stdio with `nohup` so the app survives the launching script exiting) is [`manual/guides/macos-ai-jail-setup.md`](manual/guides/macos-ai-jail-setup.md). One named gap carries forward from Linux's `--private-home`: the macOS GUI launcher has no private-`$HOME` substitute yet, so your real home directory stays *readable* inside the jail even though it stays *unwritable* — Steps 7 and 8 below say what that means in practice.

---

## Step 7 — Teaching the Tools Who You Are

Two small config files tie your identity to your work. On your **host** machine:

**`~/.ssh/config`** — which key opens which forge:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes

Host codeberg.org
    HostName codeberg.org
    User git
    IdentityFile ~/.ssh/id_ed25519_codeberg
    IdentitiesOnly yes
```

**`~/.gitconfig`** — your name, your email, and your signing seal:

```
[user]
    name = Your Name
    email = you@example.com
    signingkey = EXAMPLEGPGFINGERPRINT0000000000000000000000
[commit]
    gpgsign = true
[gpg]
    format = openpgp
[init]
    defaultBranch = main
```

With these in place, every commit you make on the host signs itself, and pushes find the right key.

**macOS, when one host holds more than one Codeberg or GitHub identity.** `~/.ssh/config`'s `Host github.com` block matches by hostname alone, so if this same Mac already has a *different* `IdentityFile` set for `github.com` (an older personal key, say) from some earlier project, `IdentitiesOnly yes` forces that wrong key for this repo too — the push fails with `Permission denied (publickey)` even though the right key sits right there in `~/.ssh/`, already loaded in the agent. Since the macOS jail's write fence keeps `~/.ssh/config` unwritable from inside a jailed window (Step 6's named gap), fix it with a **repo-local override** instead of editing the global file — this lives in `.git/`, which git never tracks, so it needs no gitignore entry at all:

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
ssh -F .git/ssh_config_urbit -T git@github.com     # expect: "You've successfully authenticated"
ssh -F .git/ssh_config_urbit -T git@codeberg.org
```

`core.sshCommand` is per-repo (stored in `.git/config`, itself untracked), so this touches nothing global and nothing another project on the same Mac relies on.

---

## Step 8 — Signing Without Hands, Inside the Sandbox

Here is the heart of it. The sandbox is sealed: with a private home, it cannot see your host's `~/.gnupg`, `~/.ssh`, or `~/.config/gh`. So to let the agent push and sign from **inside**, we keep a small, deliberate set of project-local materials — each one gitignored, each one safe.

**macOS now has a real answer to this step, not just a gap.** Reading your real `~/.ssh` and `~/.gnupg` from inside the jail is convenient, yet it is also the weaker posture: with reads open and network allowed by default (Step 6), a compromised agent could exfiltrate your real master identity without ever needing a write. `tools/cursor_jail_macos.rish --harden-home` (and the bash elder, `tools/cursor-jail-macos.sh --harden-home`) closes exactly that hole — it denies reads to the real credential stores under `$HOME` (`~/.ssh`, `~/.gnupg`, `~/.aws`, `~/.config/gh`, and the rest of the named list in the launcher itself), while everything else stays open, unchanged. Apple's Seatbelt resolves an overlapping allow/deny pair to **deny, regardless of order or specificity** — proven on this host — so the launcher denies only the specific credential-store paths themselves rather than attempting a blanket dotfile deny with an allow-back (that shape silently loses the allow-back here).

Before your first `--harden-home` launch, generate dedicated, jail-only keys and register them with both forges — from an **ordinary terminal, outside any jail**, on purpose: a "dedicated, revocable" key is a weaker promise if the same agent that will use it also generated it.

```bash
rishi/bin/rishi run tools/generate_jail_local_keys_macos.rish
# paste the printed SSH and GPG public keys into GitHub and Codeberg
```

This mirrors **8b**–**8c** exactly, just generated by your own hands rather than copied from an already-shared real key: a dedicated SSH deploy key per forge, a jail-local `known_hosts` (fetched via `ssh-keyscan`, since `--harden-home` denies the real one too), and a passphrase-free, signing-only GPG key, all living under this project's own gitignored `.ssh/` and `.gnupg-rye/`. The generator reads your name, forge handle, and email from `GLOW_PROFILE.bron` (the tree's one gitignored identity source — copy `GLOW_PROFILE.template.bron` and fill it first), so the GPG key's UID and the SSH key comments carry your real identity. The GPG **email in particular is load-bearing**: a forge shows a signature as *Verified* only when the signing key's email matches a verified address on the account and the commit's committer email, so it must be your real forge email, not a placeholder. The script also wires git itself — `core.sshCommand`, `gpg.program`, and `user.signingkey` all point at the new files before it finishes, nothing left to configure by hand — so the next `--harden-home` launch can no longer read your real identity at all, read or write.

The GPG trustdb quirk named below still applies either way — `git log --show-signature` and `gpg --list-secret-keys` can hang against a write-denied trust cache, real or jail-local, so guard signature inspection with `timeout`:

```bash
timeout 10 git --no-pager log --show-signature -1 | cat
```

**A real, honest limit on self-testing.** `tools/cursor_jail_macos_harden_witness.rish` proves `--harden-home`'s read-deny logic, yet only when run from a terminal that is not already inside a jail. Proven on this host: a *nested* `sandbox_apply` carrying an explicit `(deny ...)` rule fails outright, even though the identical profile applies cleanly as a first, non-nested call, and even though an allow-only nested profile (the plain write-fence witness) nests just fine. An agent already working inside a jailed window cannot fully self-certify `--harden-home` from within that same window — run its witness from Terminal.app instead.

**8a. An allow-listing `.gitignore`.** When a repo lives inside a sandbox home shared with the editor and your files, ignore everything by default and allow back only the project. This guarantees keys and tokens can never be committed by accident:

```gitignore
/*
!/.gitignore
!/.gitmodules
!/SOURCE.md
!/keys_*.png
!/context/
!/rye/
# ...your project directories (add each new top-level one here)...
/rye/bin/
*.rye.zig
.zig-cache/
```

**8b. SSH keys the sandbox can reach.** Place a copy of your forge SSH keys in a gitignored project folder (e.g. `.ssh/`), and point git at them — so pushes work from inside without your host keys:

```bash
git config --local core.sshCommand \
  "ssh -i $PWD/.ssh/id_ed25519_codeberg -i $PWD/.ssh/id_ed25519_github -o IdentitiesOnly=yes"
git remote add origin git@codeberg.org:youruser/yourrepo.git
git remote add github git@github.com:youruser/yourrepo.git
```

**8c. A dedicated, passphrase-free signing key — never your master.** Generate a small signing key that lives only in a gitignored sandbox keyring, so the agent can sign unattended. Your real master key stays on your host, untouched:

```bash
export GNUPGHOME="$PWD/.gnupg-rye"; mkdir -p "$GNUPGHOME"; chmod 700 "$GNUPGHOME"
gpg --batch --pinentry-mode loopback --passphrase '' \
    --quick-generate-key "Your Name <you@example.com>" ed25519 sign 2y
gpg --armor --export <NEW_SANDBOX_FPR> > "$GNUPGHOME/sandbox-pub.asc"   # upload to both forges' GPG keys
```

Wire git to sign with it through a tiny wrapper that always finds the sandbox keyring (so it survives restarts):

```bash
printf '#!/bin/sh\nexport GNUPGHOME=%s\nexec gpg "$@"\n' "$PWD/.gnupg-rye" > .gnupg-rye/gpg.sh
chmod +x .gnupg-rye/gpg.sh
git config --local user.name "Your Name"
git config --local user.email "you@example.com"
git config --local user.signingkey <NEW_SANDBOX_FPR>
git config --local commit.gpgsign true
git config --local gpg.program "$PWD/.gnupg-rye/gpg.sh"
```

Upload that sandbox key's **public** half to both forges' GPG Keys, and your in-sandbox commits will read **Verified** under your name.

**8d. The forge CLI, when you want it.** `gh` reads its token from `~/.config/gh`, which the sandbox cannot see — and on macOS, `--harden-home` denies that path outright, so `gh` fails to even start (`failed to read configuration: … operation not permitted`) rather than merely running unauthenticated. Two env vars unblock it without ever copying your real, broad-scope token into the jail:

```bash
# A jail-local config dir gh CAN read, plus a minimal-scope token from a
# gitignored secret — never a copy of your real ~/.config/gh.
export GH_CONFIG_DIR="$PWD/.gh"                  # gitignored; gh reads/writes only here
export GH_TOKEN="$(cat tools/gh-token.secret)"   # a fine-grained PAT, gitignored
gh ssh-key add .ssh/id_ed25519_jail_github.pub --title "jail-only github"
```

`GH_TOKEN` supplies auth directly, so `gh` never needs the real config at all; scope the token to just this repository and just the permissions the task needs (a "Contents + Administration: read/write" fine-grained PAT covers key management and pushes), and revoke it when done. This keeps the whole point of `--harden-home` intact: no full-account credential ever enters the jail. Copying `~/.config/gh` wholesale (`cp -r ~/.config/gh ./.gh`) also works, yet it drags your real broad token inside the fence — prefer the scoped `GH_TOKEN`.

---

## Step 9 — The Launch

From inside your project folder, start Cursor in the sandbox. This grants the editor only the current directory, closes the Docker socket, and keeps the GPU and your wider home out:

```bash
cd ~/yourrepo
./tools/cursor-jail.sh
```

That runs the same command by hand:

```bash
ai-jail --private-home --no-docker -- ./squashfs-root/AppRun --no-sandbox \
  --user-data-dir="$PWD/.cursor-state/user-data" \
  --extensions-dir="$PWD/.cursor-state/extensions" "$PWD"
```

**Options** (the tracked `tools/cursor-jail.sh` script). The `--appimage` flag expects the **extracted `AppRun`**, not a `.AppImage` file — a raw `.AppImage` mounts through FUSE, which fails inside the jail, so the launcher always runs the extracted form. To point at a freshly downloaded `.AppImage`, use **`--extract`**, which unpacks it into `squashfs-root/` and launches in one step.

```bash
./tools/cursor-jail.sh --extract ./Cursor-3.9.16-x86_64.AppImage   # unpack + launch
./tools/cursor-jail.sh --appimage /path/to/squashfs-root/AppRun    # custom AppRun
./tools/cursor-jail.sh --gpu                                        # GPU on GNOME Wayland
```

**From Rishi** — edit `apprun` at the top of `tools/launch-cursor.rish`, then:

```bash
rishi/bin/rishi run tools/launch-cursor.rish
```

`--no-sandbox` here disables Chromium's own sandbox, which cannot nest inside `bwrap`; the real boundary is ai-jail's namespaces plus Landlock and seccomp. The display passes through so the window appears; everything else stays sealed.

For a **copy-and-fill** launch with `tools/enclosure.conf` (optional paths and `AIJAIL_BIN`):

```bash
cp tools/enclosure.conf.example tools/enclosure.conf   # edit HANDLE, REPO, binary paths
./tools/cursor-jail.sh
```

The older personal-copy pattern still works if you prefer it:

```bash
cp tools/launch-cursor.sh.example tools/launch-cursor.sh
chmod +x tools/launch-cursor.sh
./tools/launch-cursor.sh
```

`tools/launch-cursor.sh` stays gitignored; `tools/cursor-jail.sh` and `tools/launch-cursor.rish` are tracked for everyone who clones the repo.

### Two Notices You May See, Both Harmless

When Cursor first opens inside the jail, two messages may appear. Both are safe, and neither means your work failed.

**Inline diffs suppressed.** When the agent makes many edits at once, the editor may say it has *suppressed inline diffs because there are too many to display.* The changes are all intact; only the per-line highlighting is paused. *Don't Show Again* dismisses it for good. It is purely cosmetic.

**A read-only `.ai-jail`.** The editor may report that it *failed to save `.ai-jail` — read-only file system (EROFS)*. This is expected and safe. `.ai-jail` is the enclosure's own configuration: the launcher passes `--no-save-config` so it is never written, and inside the sandbox it is read-only by design, since the editor working behind the wall should not be able to rewrite the wall. The notice appears only because the editor opened that file and tried to autosave it. Choose **Revert** — not *Save As*, which would leave a stray copy, and not *Retry*, which only fails again — then close the tab. The repository itself stays fully writable, as every commit proves, and `.ai-jail` is already gitignored by the allow-list, so it never travels. To stop the notice from returning, exclude `.ai-jail` from the workspace in Cursor settings, or add a tracked `.vscode/settings.json` with `files.exclude` — propose that change when you want it shared with every clone.

---

## Step 9b — A Second Editor (Zed + Claude, alongside Cursor)

You can run **Zed** in its own ai-jail enclosure while **Cursor** stays open — on the host or in a second sandbox — sharing the same repository. Each editor keeps **separate state** under `.zed-state/` and `.cursor-state/` so settings and agent credentials do not collide.

Zed's **Claude Agent** bills through **Anthropic's API** (export `ANTHROPIC_API_KEY` before launch, or use `/login` in a Claude thread). That is independent of Cursor's subscription.

```bash
cp tools/launch-zed.sh.example tools/launch-zed.sh
chmod +x tools/launch-zed.sh
export ANTHROPIC_API_KEY="sk-ant-..."    # your Anthropic console key
./tools/launch-zed.sh
```

On **GNOME Wayland** (Ubuntu 24.04), ai-jail passes the display through; set **`USE_GPU=true`** in `tools/enclosure.conf` so Zed can reach `/dev/dri` (Vulkan/WebGPU). Without it, Zed may print `Landlock: fully enforced` and exit with no window. Full concurrency models, troubleshooting, and NixOS notes live in **`context/specs/enclosure-editors.md`**.

---

## Step 9c — Hardening the Host (FileVault + Firewall)

The sandbox in Steps 6–9 protects the *project* from the agent. This step protects the *machine* — the disk itself, and the network — since a work laptop holding real SSH keys, a real GPG signing key, and forge tokens deserves both, not just the enclosure. Two settings, both in **System Settings**, both worth doing before you treat this machine as a real work machine.

**Turn on FileVault (disk encryption).** Without it, anyone who gets the physical drive can read every private key on it directly, bypassing your login password entirely. **System Settings → Privacy & Security → FileVault → Turn On…** — choose **Create a recovery key and do not use my iCloud account** for the stricter, no-third-party-holds-a-copy choice, and save that recovery key to a password manager's secure note the moment it appears (never a plain file on the same disk). The full walkthrough, step by step, is [`manual/guides/filevault-setup.md`](manual/guides/filevault-setup.md). Confirm it took:

```bash
fdesetup status
# FileVault is On.
```

**Turn on the Application Firewall, with Block all incoming connections.** **System Settings → Network → Firewall** — toggle it on, then **Options… → Block all incoming connections**. If this machine only ever runs as a client (reaching out to forges, a VPN, an API) and never deliberately hosts an inbound service, block-all is the strictest, cleanest choice — it overrides any app-specific "allow" entry that might already be listed, permitting nothing beyond basic network services like DHCP. Consider **Enable stealth mode** too, so the machine does not even acknowledge a ping. Confirm from the shell:

```bash
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
# Firewall is blocking all non-essential incoming connections. (State = 2)
/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode
# Firewall stealth mode is on
```

Neither setting needs a password stored anywhere in this repository — both are your own hands, your own Touch ID or login password, done once. A living record of this host's own security posture, kept honestly (what was checked, what was found, what was fixed) lives at [`context/specs/20260713-211800_local-host-system-hardware-anonymized.md`](context/specs/20260713-211800_local-host-system-hardware-anonymized.md).

---

## Verifying the Whole Thing

Inside the sandbox, ask your agent to make a small commit, then look:

```bash
git log --show-signature -1     # expect: "Good signature from Your Name"
                                 # on macOS, prefer: timeout 10 git --no-pager log --show-signature -1 | cat
                                 # (Step 8's trustdb note — a hang here is cosmetic, not a signing failure)
git push origin main            # to Codeberg
git push github main            # to GitHub
```

Open the commit on each forge. When the green **Verified** appears, every piece is in place: your accounts, your keys, your seal, your sandbox, and an AI partner who can build and sign in your name without ever reaching past the garden wall.

---

## Why It Is Shaped This Way

- **SSH proves you may push; GPG proves you wrote it.** Two jobs, two keys, two uploads.
- **The master key never enters the sandbox.** A dedicated, revocable signing key does the daily work; if the sandbox were ever harmed, you revoke one small key, not your whole identity.
- **Everything sensitive is gitignored by an allow-list.** The repo cannot leak a key or a token, because it commits only what you name.
- **The sandbox is the boundary.** The agent works freely within the project and reaches nothing beyond it.

---

*May your keys hold steady. May each commit carry your name in good faith. May the enclosure keep you free — bounded, alive, and entirely your own.*
