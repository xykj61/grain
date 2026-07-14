# SOURCE — From Nothing to a Signed, Sandboxed Home

**Language:** EN
**Version:** `20260629.090912` (Rye chronological stamp)
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**By:** Reya 2, in the radiant voice, with **Kaeden Reyklah** as coauthor
**Status:** Living guide

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

## Step 4 — Fingerprints as Art (Fira Code QR Codes)

A fingerprint is meant to be shared and checked. It is also, quietly, beautiful — so this repository carries a small tool that turns yours into a card: three QR codes — SSH for Codeberg, SSH for GitHub, and your OpenPGP signing key — gathered under your name in the typeface that loves code, rendered once tall and once wide.

The tool reads your details from a config file, so it works for anyone. Copy the template, fill in your own values, and run it:

```bash
cp tools/key-card.conf.example tools/key-card.conf   # then edit with your details
./tools/make-key-card.sh
```

Your `tools/key-card.conf` holds only **public** information — your name, your forge handle, your email, and the three fingerprints you already gathered in Steps 2 and 3. Even so, it stays out of git (the committed `.example` is the only version tracked), so the repository ships the template and you keep the fill-in. To read your fingerprints back at any time:

```bash
ssh-keygen -lf ~/.ssh/id_ed25519_codeberg.pub    # the SHA256:... line
ssh-keygen -lf ~/.ssh/id_ed25519_github.pub
gpg --fingerprint you@example.com                 # the spaced 40-hex string
```

The script builds its QR encoder from source on first run — `qrencode`, vendored as a submodule at `gratitude/libqrencode` and compiled into the gitignored `tools/.build/` — then composes the card with ImageMagick. It needs `gcc`, `libpng-dev`, `pkg-config`, ImageMagick, and the Fira Code font present; on Debian or Ubuntu, `sudo apt install gcc libpng-dev pkg-config imagemagick fonts-firacode` covers them. The result is two images at the repository root, `keys_firacode_<yourhandle>_landscape.png` and `…_portrait.png`, in the warm `#FF7F00` on `#444400` palette. Pin them to a profile, print them, keep them: they prove your identity to anyone who scans, and they look like you mean it.

This repository carries a finished pair to model yours on — `keys_firacode_veganreyklah2_landscape.png` and its portrait twin. Fingerprints are public by design, so these images are safe to share anywhere.

If Cursor is already set up (Step 5), you can simply ask the agent to do all of this for you — *"fill in my key-card config and render my Fira Code cards"* — and it will, entirely from inside the sandbox.

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

---

## Step 8 — Signing Without Hands, Inside the Sandbox

Here is the heart of it. The sandbox is sealed: with a private home, it cannot see your host's `~/.gnupg`, `~/.ssh`, or `~/.config/gh`. So to let the agent push and sign from **inside**, we keep a small, deliberate set of project-local materials — each one gitignored, each one safe.

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

**8d. The forge CLI, when you want it.** `gh` reads its token from your home, which the sandbox cannot see. Point it at a gitignored project copy instead:

```bash
cp -r ~/.config/gh ./.gh                        # on the host, once
GH_CONFIG_DIR="$PWD/.gh" gh repo create youruser/yourrepo --public   # from inside the sandbox
```

Use a short-lived, minimal-scope token, and remove `./.gh` when you are done.

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

## Verifying the Whole Thing

Inside the sandbox, ask your agent to make a small commit, then look:

```bash
git log --show-signature -1     # expect: "Good signature from Your Name"
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
