# Expanded Prompt — A Separate ai-jail Identity for `urbit` on the Framework/Ubuntu Host

**Language:** EN
**Version:** `20260715.163900` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** **Landed and run** `20260716.115927` — `tools/generate_jail_local_keys_linux.rish` was written `20260716.110152`, then run by Keaton's own hands at a plain host terminal outside the jail, exactly as this prompt specified. The read-side isolation this depends on (`ai-jail --private-home`) was already real and default; the write-side (dedicated signing keys) is now real too — `.ssh/id_ed25519_jail_github`, `.ssh/id_ed25519_jail_codeberg`, and a `.gnupg-rye/` signing key all live and git-wired, public halves recorded in `../PUBKEYS.md` and `../keys/jail_signing_linux_CC8BA6.pub.asc`. Register: checkable in full. Still open: pasting the two SSH keys and the GPG key into GitHub's and Codeberg's own key-management pages, if not already done by Keaton's hand — this pass recorded the keys, it did not confirm forge-side registration.

---

## The Seed (what was asked, across this pass)

Two threads on the macOS host, then a pivot to a second machine. First: adapting the NixOS plan to this Mac in the meantime, and settling plainly whether Pixel phones target postmarketOS, GrapheneOS, or something else for the SLC line — answered directly (GrapheneOS, Pixel-exclusive, never postmarketOS; postmarketOS stays the Fairphone-class Glowphone's own phase-two target) and folded into a new G0–G3 ladder in `context/specs/two-dev-environments-and-mobile-emulation.md`. Attempting `brew install --cask android-commandlinetools` for G0 hit a real, unrelated Homebrew ownership problem (`/opt/homebrew` owned by a different user); Keaton fixed it with `sudo chown -R $(whoami) /opt/homebrew` in a real terminal, run correctly. Checking the fix from inside this jailed window surfaced a *second*, expected blocker underneath — the jail's own write fence has never allowed writes to `/opt/homebrew`, chown or not, by design.

Rather than widen this Mac's own jail policy, Keaton pivoted the whole thread: set him up with a **new ai-jail environment on the Framework computer** — an existing Ubuntu host that already runs the separate `veganreyklah2` project, with its own real GPG and SSH keys. The new `urbit` jail there must not compete with or touch those.

## The Lens Applied

- `SOURCE.md` Step 6 and Step 9 — the Linux/NixOS ai-jail path already documented, `tools/cursor-jail.sh` defaulting `AIJAIL_FLAGS` to `--private-home --no-docker`.
- `tools/generate_jail_local_keys_macos.rish` — the macOS jail-local key generator, the direct pattern this Linux twin mirrors: identity from `GLOW_PROFILE.bron`, dedicated SSH deploy keys per forge, a jail-local `known_hosts`, a passphrase-free signing-only GPG key, all wired into git config directly, all gitignored.
- `.cursor/rules/send-word.mdc` — the `send` word this very prompt closes with.

## Why Linux's Own Isolation Story Is Simpler Than macOS's

Worth naming plainly, since it changes what this pass actually needs to build. Upstream `ai-jail`'s `--private-home` on Linux uses real kernel namespaces (`bwrap`) to give the jailed process a genuinely separate `$HOME` — not an enumerated deny-list the way macOS's Seatbelt required (`tools/cursor_jail_macos.rish --private-home`, landed the prior session, needed to enumerate every top-level `$HOME` entry by hand because Seatbelt has no namespace-level private-home primitive at all). `tools/cursor-jail.sh` already defaults to `--private-home`, so **the read-side of this ask is already solved, today, with no code change** — `veganreyklah2`'s real `~/.ssh` and `~/.gnupg` are already invisible from inside any `urbit` jail launched with the existing default flags on that Ubuntu host.

What is *not* yet solved: `urbit`'s own jailed Cursor session, inside its real private `$HOME`, has no working forge identity of its own to push or sign with — `SOURCE.md` Step 8b/8c only ever gave copy-paste snippets for this, never a script, unlike the polished macOS generator.

## The Deliverable (scoped, half-drafted, not yet landed)

**`tools/generate_jail_local_keys_linux.rish`** — a near-direct port of `tools/generate_jail_local_keys_macos.rish`: same `GLOW_PROFILE.bron` identity source, same `.ssh/id_ed25519_jail_github` / `id_ed25519_jail_codeberg` / `known_hosts_jail` / `.git/ssh_config_urbit` / `.gnupg-rye/` shape, same direct `git config --local` wiring for `core.sshCommand`, `gpg.program`, and `user.signingkey`. The macOS-only pieces drop cleanly: no `sandbox-exec` self-check (Linux has no equivalent one-liner to detect "already inside `bwrap`" from a plain shell test — worth naming as a real, smaller gap rather than faking a check), no macOS-specific comment fluff. `ssh-keygen`, `gpg`, and `ssh-keyscan` behave identically on both hosts, so the bulk of the script's own logic ports close to verbatim.

**Run from Keaton's own hands on the Framework host, outside any jail** — the same non-negotiable discipline as the macOS generator: key *creation* never happens inside the process that will later use the keys.

**A parallel SOURCE.md note**, mirroring the existing "macOS, when one host holds more than one Codeberg or GitHub identity" passage under Step 7 — a "Linux, when this host already runs another project's own identity" section naming `veganreyklah2` by the pattern (not the name, per the Acme-employee-voice convention for generic instructional prose) and confirming `--private-home` already closes the read side by default.

## What This Pass Did Not Reach

The script above is scoped in full but not yet written to disk, tested, or committed — this prompt exists so the next pass (on this Mac, or picked back up once Keaton is at the Framework machine) has a durable, citable starting point rather than only a chat thread. Nothing about the macOS host's own jail, keys, or `--private-home`/`--harden-home` work changes; this is purely additive, a second, separate machine's own separate identity.

## Related

- `context/specs/two-dev-environments-and-mobile-emulation.md` — names the NixOS Framework host as the eventual sovereign dev machine; this prompt's Ubuntu-today, NixOS-eventually framing extends that same host's own timeline.
- `session-logs/20260715-163500_macos_interim_env_grapheneos_ladder.bron` — the GrapheneOS/postmarketOS settlement and this Mac's own G-ladder, landed just before this pivot.
- `tools/generate_jail_local_keys_macos.rish` — the direct pattern this Linux twin will mirror.
- `SOURCE.md` Step 6 (Linux ai-jail install), Step 7 (the macOS multi-identity precedent this Linux note will mirror), Step 8b/8c (the copy-paste snippets this script replaces with a real tool).

---

Two machines, two identities, one clean rule: `veganreyklah2` keeps its own real keys untouched on the Framework host's real `$HOME`, already invisible from inside any `urbit` jail there by `--private-home`'s own default — and this pass names exactly the one small script still needed to give that jail a working identity of its own.
