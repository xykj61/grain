# SOURCE.md — download, launch, and two harmless notices

**Editor:** Cursor · **Model:** Composer

**Stamp:** `20260629.090912`

**Prompt:** Kaeden supplied stamp `090912` and the adoption prompt (`20260629-074712_cursor-source-md-download-launch-and-notices.md`) with context summary — docs-only pass, collision-free with TH-2.

## Thinking trace

Read the prompt and verified `.ai-jail` is gitignored by the root allow-list and `cursor-jail.sh` passes `--no-save-config`. Updated SOURCE.md Step 5 (cursor.com/download, x86_64 AppImage for Framework on NixOS and Ubuntu), Step 6 (extract avoids FUSE, Ubuntu libfuse2t64 footnote, NixOS appimage.binfmt + FHS-wrapper facts with pointer to enclosure-editors), Step 9 (AppRun-not-AppImage caveat, two-notices subsection with Revert guidance).

Added NixOS Cursor subsection to `context/specs/enclosure-editors.md` with tested `./tools/cursor-jail.sh` after extract and `steam-run` fallback — no invented incantation beyond what the working Framework launch confirms.

Left Edit 5 (tracked `.vscode/settings.json` exclude) as documentation-only in SOURCE.md; Kaeden can approve the allow-list touch separately.

Did not touch TH-2 files (`tools/tame-check.rish`, Mantra asserts).

## Observations

Both notices are harmless as diagnosed: inline diffs cosmetic; `.ai-jail` EROFS expected read-only enclosure config. Repo writes fine — ROADMAP and SOURCE edits prove it.

## Files

| File | Why |
|------|-----|
| `SOURCE.md` | Steps 5–6–9 download, platform notes, AppRun caveat, two-notices guide; version bump |
| `context/specs/enclosure-editors.md` | NixOS Cursor extracted AppRun map |
| `expanding-prompts/20260629-074712_cursor-source-md-download-launch-and-notices.md` | Prompt archived (if moved from root) |
