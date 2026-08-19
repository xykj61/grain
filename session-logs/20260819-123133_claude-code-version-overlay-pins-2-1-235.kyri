format session-log-v1
stamp 20260819.123133
editor Claude Code
model claude-opus-4-8
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title claude-code version overlay pins 2.1.235, hash verified on metal
prompt Keaton asked me to set up the overlay fetch so the pier builds the latest Claude Code
think Read the real nixpkgs claude-code derivation: stdenvNoCC native binary from downloads.claude.ai/claude-code-releases/<version>/<platformKey>/claude, sha256 = the per-platform checksum in a vendored manifest.json. platformKey for x86_64-linux is linux-x64.
think The LOCKED flake nixpkgs (rev 531670d, claude-code 2.1.187) holds manifest as a LET-BINDING, not an overridable argument -- so .override { manifest = ...; } fails there. overrideAttrs (version + src) is packaging-agnostic and works on both the locked rev and the branch HEAD, mirroring the existing cursor-cli overlay exactly.
think Latest is 2.1.235 (2026-08-18) -- confirmed by the official changelog AND the downloads.claude.ai/.../latest pointer. Pulled Anthropic's own 2.1.235 manifest.json for the linux-x64 checksum bfcf0ae2...d5d5.
obs VERIFIED ON METAL: downloaded the real 2.1.235 linux-x64 binary (330946864 bytes) and sha256sum'd it -- bfcf0ae2dbf94b2b6a106074aabf3938b9a10889c3b678e4cb5a00c03274d5d5, byte-identical to the manifest checksum. Not trust, a witness. Cleaned the 330MB scratch after.
obs The build self-verifies twice regardless: fetchurl fails loudly on any hash mismatch, and versionCheckHook runs claude --version against the pinned 2.1.235. A wrong hash is a failed build, never a silent bad system.
file nixos/configuration.nix claude-code overlay added beside cursor-cli, overrideAttrs version 2.1.235 + src fetchurl with the metal-verified sha256, why-commented (locked-rev let-binding reason, bump recipe)
file nixos/rebuild-outer.sh step-5 note updated -- the witness now confirms the overlay took effect (expect 2.1.235)
recommend keep-going -- Keaton runs rebuild-outer.sh in the outer host shell (it will fetch + build claude-code 2.1.235, ~330MB) then continues the outer loop; if a later bump is wanted, read .../latest then that version's manifest.json for the linux-x64 checksum
