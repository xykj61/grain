# Cloud Agent Toolchain Setup — Raising `rye`/`rishi` Inside Cursor's Own Sandbox

**Language:** EN
**Version:** `20260715.054500` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Living guide
**Builds on:** `../../rye/README.md`, `../../rye/bootstrap.sh`, `../../GLOW_HOST.template.bron`
**Companion:** `../../context/specs/enclosure-editors.md` covers the persistent-host, ai-jail-enclosed path (Ubuntu/NixOS/macOS, an editor you keep open for days). This guide covers the opposite case — an ephemeral **Cursor Cloud Agent** or **Cursor for iOS** session, ai-jail-free by construction, that needs `rye`/`rishi` for the length of one sitting.

---

## Why This Path Is Different

A Cursor Cloud Agent (including sessions launched from Cursor for iOS) runs inside its own already-sandboxed VM — there is no host `$HOME` to leak into, and ai-jail's whole purpose (carving a boundary out of a shared, persistent machine) has nothing to add here. The environment itself *is* the enclosure; a session that starts fresh, does its work, and ends leaves nothing behind to guard. This is worth naming plainly rather than defaulting to jail tooling out of habit — a fresh sandbox already meets the bar `--private-home` exists to build by hand on a shared host.

What such a session still needs, though, is the same `rye`/`rishi` build chain every witness in this tree depends on — and `vendor/zig-toolchain/` is gitignored and Mac-host-built in every dated session log so far, so a cloud session starts with none of it.

## The Recipe (Confirmed Working, `20260715.054500`)

This is the same recipe an earlier Cursor for iOS round used against a persistent ai-jail host (`work-in-progress/20260703-021412_counsel-and-confirmation-tests.md`, Step 1) — pip's `ziglang` package stands in for the checksum-verified official-release fetch `rye/README.md` names for a persistent host. Confirmed fresh on a Cursor Cloud Agent's own Linux x86_64 sandbox:

```bash
cd /workspace   # or wherever the clone root is

pip install ziglang==0.16.0 --break-system-packages
mkdir -p vendor
ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain

export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
sh rye/bootstrap.sh

mkdir -p rishi/bin
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
```

A healthy raise ends with `rye` printing its chronological version and backend line, then `rishi --help` answering:

```
rye 20260618.193812  (chronological: YYYYMMDD.HHMMSS, later is larger)
backend: zig 0.16.0  (Rye clock: 20260413.181917; live value via builtin.zig_version)
rishi 20260621.062112 — the shell of the Rye ecosystem (first version)
```

From here, any `.rish` witness runs exactly as it would on a persistent host:

```bash
rishi/bin/rishi run tools/neth_root_witness.rish
rishi/bin/rishi run tools/neth_serial_core_witness.rish
rishi/bin/rishi run tools/neth_root_install_witness.rish
```

All three ran **GREEN** on this cloud host at `20260715.054500` — the first time any Neth witness has run GREEN outside a Mac-hosted or Ubuntu-desktop sitting.

## The One Honest Trade-Off Named

`rye/README.md`'s own building section fetches the official Zig 0.16.0 release tarball and verifies it against its published checksum before trusting a byte of it — the discipline this whole tree holds everywhere else ("never trust an unverified toolchain," `GLOW_HOST.template.bron`'s own header comment). The `pip install ziglang` path instead trusts PyPI's own package signing and the `ziglang` maintainer's own re-packaging of the official release — a real, different trust chain, not the same one merely taken by a shortcut.

This is acceptable for a same-sitting cloud agent for the reasons named above (no persistent host to protect, no credential store nearby to leak, the whole VM discarded at session end) and is **not** a substitute for the checksum-verified fetch on a persistent host that a session's own tooling and identity will live on for weeks. `GLOW_HOST.bron` stays the source of truth for a *persistent* host's pinned, verified toolchain path; this pip recipe is this guide's own, narrower thing — a same-sitting convenience for an environment that is disposable by design.

## What This Does Not Set Up

- **No ai-jail.** Not needed here, per the reasoning above; this guide is the honest alternative to `context/specs/enclosure-editors.md`; it does not extend it.
- **No Wayland.** `libwayland-dev`/`libxkbcommon-dev` are not installed by this recipe, so SLC-2a Lap 1's Brushstroke viewer witness (and anything downstream of it in `tools/parity_ch01.rish`'s full sequential run) still halts here — the same named gap as the macOS-host runs, for a different underlying reason (missing dev headers on a minimal cloud image, rather than Wayland being Linux-only). A future pass could `apt-get install libwayland-dev libxkbcommon-dev` to close this specific gap on a cloud host; not attempted in this guide's own witnessed run.
- **No persistence across sessions.** Each fresh Cursor Cloud Agent VM starts over; this recipe is a same-sitting raise, not a one-time setup. A future environment-config pass (via `cursor.com/onboard`) could bake this into the base image directly, if cloud-hosted witness runs become a standing need rather than an occasional one.

## Related

- `../../rye/README.md` — the persistent-host build path this recipe stands beside.
- `../../context/specs/enclosure-editors.md` — the ai-jail-enclosed persistent-host path this guide is not a replacement for.
- `../../work-in-progress/20260703-021412_counsel-and-confirmation-tests.md` — the earlier Cursor for iOS round that first used this exact pip recipe, against a persistent ai-jail host rather than a disposable cloud VM.
- `../../session-logs/20260715-062000_cloud-toolchain-raised-neth-green.bron` — the session that confirmed this recipe fresh and ran the Neth witnesses GREEN on it.

---

A disposable sandbox raises its own toolchain in four commands; the one trust-chain trade-off it leans on is named plainly above rather than assumed.
