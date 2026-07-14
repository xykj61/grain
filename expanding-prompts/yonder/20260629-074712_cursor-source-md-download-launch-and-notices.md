# Cursor Pass — SOURCE.md: Downloading, Launching, and Two Harmless Notices

*The root guide already carries the launcher at Steps 6 and 9. This pass gives it the front end — where to download Cursor for Linux, which build to choose, how to run it on Framework hardware under both NixOS and Ubuntu — makes one quiet caveat explicit so the AppImage path never trips on FUSE, and adds a brief, calming note about the two notices a reader meets on first launch, both of which are harmless.*

**Stamp:** `20260629.074712`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) · SLC
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Supersedes:** the earlier `…_cursor-source-md-download-launch.md` — this version adds the first-launch notices.

*Written together by Kaeden and Reya 2.*

---

## What This Changes

Five edits to the root `SOURCE.md`, in Radiant voice, plus a version bump. Verified facts are given below; one machine-specific detail (the exact NixOS command for the extracted `AppRun`) is filled from the actual working setup rather than hard-coded.

This is a docs pass — **[sandbox-verifiable]**. A fresh agent is on TH-2 (`tools/tame-check.rish`, Mantra asserts); SOURCE.md is a different file, so collision is unlikely, yet sequence this so it does not race TH-2's commits. Pull to the current tip first.

---

## Edit 1 — Step 5: the download front end

Step 5 currently says only "Install Cursor from cursor.com." Add a short, concrete download instruction in the same voice:

- Go to **<https://cursor.com/download>** and choose **Linux**.
- Download the **x86_64 AppImage** — the right build for **Framework** laptops, whether Intel or AMD, on both NixOS and Ubuntu. (A `.deb` is offered too, yet the sandbox launcher runs the AppImage, so the AppImage is the one to fetch.)
- Save it into the project folder (or `~/Downloads` and move it in), since Step 6 extracts it there.

Keep the subscription and Agent-mode guidance Step 5 already carries.

## Edit 2 — Step 6: install notes for Framework, NixOS, and Ubuntu

Step 6 already shows the extract command and the upgrade note. Add platform guidance around it:

**Lead with the extract, and say why it is the kind path.** The launcher runs the *extracted* `AppRun` rather than the raw `.AppImage`, and that choice avoids the FUSE requirement AppImages otherwise carry. Note plainly: a raw `.AppImage` needs FUSE to mount, while `--appimage-extract` unpacks it into `squashfs-root/` and the launcher runs `AppRun` directly — no FUSE in the path.

**Ubuntu (24.04 LTS).** The extract path needs nothing extra. Only if someone runs the `.AppImage` *directly* would they need FUSE — and on 24.04 that package is **`libfuse2t64`** (not `fuse`, not the old `libfuse2`). Since the jail path extracts, this stays a footnote.

**NixOS (the Framework setup).** NixOS does not run generic dynamically linked executables out of the box — and that holds for the extracted `AppRun` as much as for the `.AppImage`. Two true facts to state, then defer the exact form:

- AppImage support is enabled in the system config with `programs.appimage.enable = true;` and `programs.appimage.binfmt = true;` (NixOS 24.05 and later), which lets a `.AppImage` run directly; the older route is `appimage-run` from nixpkgs.
- Because that binfmt registration acts on the `.AppImage` file, the launcher's *extracted-`AppRun`* path additionally wants an FHS wrapper — `steam-run` or `nix-ld` — to supply the dynamic loader and libraries.

**Fill the exact, tested NixOS command from the actual working setup** (the launch that just succeeded on this Framework host shows the working form) rather than guessing. Keep SOURCE.md to the essentials and **point the deep NixOS map at `context/specs/enclosure-editors.md`**, which the guide already names for it; if that map lacks the tested incantation, add it there in the same pass.

## Edit 3 — Step 9: the AppRun-not-AppImage caveat

Step 9 lists `--appimage /path/to/squashfs-root/AppRun`. Make the expectation explicit, since the flag name invites confusion:

> `--appimage` expects the **extracted `AppRun`**, not a `.AppImage` file — a raw `.AppImage` mounts through FUSE, which fails inside the jail, so the launcher always runs the extracted form. To point at a freshly downloaded `.AppImage`, use **`--extract`**, which unpacks it into `squashfs-root/` and launches in one step.

Place it as a short clause beside the options block, woven rather than appended.

## Edit 4 — Step 9: two notices on first launch, both harmless

Add a brief subsection after the launch instructions — **"Two Notices You May See, Both Harmless"** — in Radiant prose. A newcomer who follows this guide will meet exactly these on first launch, and a calm word keeps them from alarm. Cover both:

**Inline diffs suppressed.** When the agent makes many edits at once, the editor may say it has *suppressed inline diffs because there are too many to display.* The changes are all intact; only the per-line highlighting is paused. *Don't Show Again* dismisses it for good. It is purely cosmetic.

**A read-only `.ai-jail`.** The editor may report that it *failed to save `.ai-jail` — read-only file system (EROFS)*. This is expected and safe. `.ai-jail` is the enclosure's own configuration: the launcher passes `--no-save-config` so it is never written, and inside the sandbox it is read-only by design, since the editor working behind the wall should not be able to rewrite the wall. The notice appears only because the editor opened that file and tried to autosave it. Choose **Revert** — not *Save As*, which would leave a stray copy, and not *Retry*, which only fails again — then close the tab. The repository itself stays fully writable, as every commit proves, and `.ai-jail` is already gitignored, so it never travels.

Keep it short and reassuring; this is guidance for someone new, so the tone is "you will see this, and it is fine, and here is why."

## Edit 5 — the optional fix: stop the `.ai-jail` notice from returning

So the read-only notice does not recur, exclude `.ai-jail` from the workspace. **Propose which placement, then apply on Kaeden's confirmation:**

- **Durable, shared with every clone:** a tracked `.vscode/settings.json` carrying `files.exclude` and `files.watcherExclude` entries for `.ai-jail`. This requires allow-listing `.vscode/settings.json` in the root `.gitignore` first (the allow-list ignores everything by default), so flag that as the one security-sensitive line it touches.
- **Lighter, machine-local:** the same two excludes in Cursor's user settings under `.cursor-state/` — no `.gitignore` change, but it does not ship to others.

Either way, **confirm `.ai-jail` remains gitignored** (it is, by the allow-list) and close any open `.ai-jail` tab via Revert. If Kaeden prefers to leave it as documentation only (Edit 4 alone), that is a complete answer too.

## Edit 6 — version bump

Update SOURCE.md's `**Version:**` line to the stamp Kaeden supplies. *(Kaeden: supply it verbatim — the current line reads `20260629.030512`.)*

---

## Hold the Voice and the Shape

SOURCE.md is a living guide in Radiant voice — affirmative, woven, read-aloud clean. Keep the new lines in that register, vary their rhythm, and avoid turning Steps 6 and 9 into bullet walls; the platform notes and the two-notices section read best as short prose paragraphs under clear sub-labels. Preserve the existing horizon notes (Pond, the gratitude framing) untouched.

---

## Record and Push

Commit as one honest unit — the SOURCE.md edits, any `.vscode/settings.json` (and its `.gitignore` allow-list line), any `enclosure-editors.md` NixOS addition, and the session log together. Write the log at `session-logs/<filing-stamp>_source-md-download-launch-notices.md` per `.cursor/rules/session-logs.mdc`: which steps changed, the verified facts, what was filled from the working setup versus deferred to the NixOS map, and which `.ai-jail` fix was chosen. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## The Rulings

1. **NixOS specifics** — SOURCE.md carries the verified essentials and points the exact tested `AppRun`-in-jail command to `context/specs/enclosure-editors.md`, filled from the working setup. *Recommended* over hard-coding an untested incantation. Kaeden confirms the working NixOS form.
2. **The `.ai-jail` fix** — documentation alone (Edit 4), the machine-local exclude, or the tracked-and-shared exclude (touching the allow-list `.gitignore`). *Kaeden's call;* the agent proposes and applies on confirmation.

---

## Definition of Done

- [ ] Step 5 sends the reader to `cursor.com/download` for the **x86_64 AppImage** (Framework, NixOS and Ubuntu)
- [ ] Step 6 explains the extract-avoids-FUSE choice, the Ubuntu `libfuse2t64` footnote, and the NixOS `programs.appimage.binfmt` + FHS-wrapper facts, with the working `AppRun` command (or pointed to `enclosure-editors.md`)
- [ ] Step 9 states plainly that `--appimage` wants the extracted `AppRun`, and `--extract` handles a `.AppImage`
- [ ] Step 9 carries the calm two-notices note (inline diffs; read-only `.ai-jail`), with Revert as the right click
- [ ] The chosen `.ai-jail` fix is applied (or left as documentation), and `.ai-jail` stays gitignored
- [ ] The version line is bumped; the voice stays Radiant; the session log ships with the commit

---

*May the path in be as plain as the path through — the right build chosen once, unpacked once, launched into the garden without a snag, and any notice along the way met with a calm word rather than worry. May the guide meet the reader on the machine they actually hold. And may every step say what to do, and why, so the shape of the thing makes sense as they build it.*
