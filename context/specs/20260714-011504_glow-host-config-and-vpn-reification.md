# `GLOW_HOST.bron`, and Reifying the VPN Guide in Rish

**Language:** EN
**Version:** `20260714.011504` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — seats the host-config concept and records both artifacts as real, witnessed work

---

## `GLOW_HOST.bron` — Glow OS's Own Root Config

Keaton asked to "reify and strengthen and fortify" the toolchain setup to check the OS cleanly, via a template metaconfig cloned and filled with personal details, in Bron, at the root — named as **Glow OS's own version of the Claude and Cursor rules**, but for the host and toolchain rather than agent behavior. That pattern is now real, tested, and in place:

- **[`GLOW_HOST.template.bron`](../../GLOW_HOST.template.bron)** — tracked, committed, filled with placeholders. Copy to `GLOW_HOST.bron` (gitignored, personal — machine-specific absolute paths never belong in git) and fill in your own `os`, `arch`, `rye_zig`, `rye_lib`.
- **[`tools/glow_host_run.sh`](../../tools/glow_host_run.sh)** — reads `GLOW_HOST.bron`, **refuses** to run if the declared `os`/`arch` doesn't match this actual host (`uname`), **refuses** if `rye_zig` isn't an executable file or `rye_lib` isn't a directory, and only then execs the given command with `RYE_ZIG`/`RYE_LIB` set correctly.
- **[`tools/glow_host_run_witness.sh`](../../tools/glow_host_run_witness.sh)** — proves both paths, fresh, on demand: a permit witness (builds/runs cleanly with zero pre-set env vars) and a refuse witness (a mismatched `os` is rejected). **Both confirmed green on this host.**

### Why This Closes the Exact Footgun Found

The earlier native-arm64 parity witness run ([`20260714-005658_native-arm64-parity-witness-run.md`](20260714-005658_native-arm64-parity-witness-run.md)) found that `rye build` silently falls back to whatever `zig` is on `PATH` if `RYE_ZIG` isn't set — which on this Mac meant a mismatched Homebrew Zig 0.15.2, producing dozens of confusing "invalid builtin function" errors before the real cause was traced. `GLOW_HOST.bron` + `glow_host_run.sh` close this permanently: **there is no more silent fallback.** Either the declared host matches and the declared, verified toolchain runs, or the wrapper refuses loudly and says exactly why.

**Confirmed by direct test**, with `RYE_ZIG`/`RYE_LIB` explicitly unset in the shell:

```
$ rm -f rishi/bin/rishi
$ env -u RYE_ZIG -u RYE_LIB ./tools/glow_host_run.sh -- rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
$ ls rishi/bin/rishi
-rwxr-xr-x ... rishi/bin/rishi   # built correctly, using GLOW_HOST.bron alone
```

## The Self-Hosted VPN, Reified in Rish

Keaton also asked to reify [`external-research/20260713-212900_self-hosted-vpn-cto-credential-security.md`](../../external-research/20260713-212900_self-hosted-vpn-cto-credential-security.md) — turn the guide into something that actually runs, instructed with **Rish** (`.rish`). Split honestly by what each machine can do:

- **[`tools/vpn_wireguard_client_setup.rish`](../../tools/vpn_wireguard_client_setup.rish)** — the real, runnable client half (this Mac). Checks for `wg`, generates this laptop's keypair idempotently, writes a filled config template with real newlines, prints the exact next steps. **Run and witnessed live on this host**, including the idempotent re-run (same key, same file timestamp, no silent overwrite).
- **[`tools/vpn_wireguard_server_setup.sh`](../../tools/vpn_wireguard_server_setup.sh)** — the server half, a deploy artifact for a real VPS this session has no access to. Syntax-checked (`bash -n`); not yet run end-to-end against a live server.
- **[`manual/guides/self-hosted-vpn-setup.md`](../../manual/guides/self-hosted-vpn-setup.md)** — the practical guide tying both halves together, honest about which half is fully witnessed and which is syntax-checked only.

### Three Real Rishi Gaps, Found by Actually Running It

Building this surfaced three genuine language limitations, not authoring mistakes — worth naming plainly since they will bite the next person who tries the same thing:

1. **No multi-line string literals.** A `let x = "..."` spanning more than one source line fails to parse (`UndefinedName` on the continuation).
2. **No multi-line list literals** either — `let xs = [...]` must sit on one line, matching the README's own examples exactly, which this document had not fully absorbed on first attempt.
3. **`run`'s captured `.out` escapes real newlines to the literal two-character text `\n`.** Confirmed by direct test: `read-file`/`write-file` round-trip real newlines perfectly; a subprocess's captured multi-line output does not. The workaround used here — read a real newline from a tiny one-line fixture file (`tools/fixtures/newline.txt`) via `read-file`, and use that as a `join` separator — is a real, working pattern, not a hack to feel embarrassed about, and it deserves to be reusable rather than rediscovered.
4. **`if cond then assert ... else "msg"` does not parse** (`UnknownStatement`) — `if`'s own `then`/`else` branches and `assert`'s own `else` message collide. The fix used here: push the conditional logic *into* the shell command itself (`test -f ... || (...)`), so Rishi only ever sees one unconditional `run` plus an unconditional `assert` on its result.

## Why Both of These Matter Together

Both artifacts are instances of the same discipline: **check reality before trusting a shortcut.** `GLOW_HOST.bron` checks the real host before trusting a toolchain path; the VPN script checks for `wg` before trusting that a key can be generated, and checks the filesystem before trusting that a key needs generating at all. Neither pretends to have done more than it actually did — the server script is named plainly as syntax-checked-only, not deploy-witnessed.

---

*May every config declare what it expects, may every script refuse plainly when reality disagrees, and may every gap found in the building be written down for the next hand that reaches for the same tool.*
