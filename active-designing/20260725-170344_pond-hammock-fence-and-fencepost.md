# Pond hammock — the fence and the fencepost

**Language:** EN  
**Stamp:** `20260725.170344`  
**Voice:** Quin  
**Status:** Mixed — hammock only; **no code path for Pond enforcement**; `ENCLOSURE` stays `ai-jail`  
**Room:** Mixed — founding law (vision) · six bars and nesting (checkable against incumbent)  
**Counsel:** [`../counsel/20260725-170344_the-fence-and-the-fencepost.md`](../counsel/20260725-170344_the-fence-and-the-fencepost.md)  
**Ground:** exit [`20260712-210800_pond-supersede-exit-criteria.md`](20260712-210800_pond-supersede-exit-criteria.md) · sixbar [`20260712-205600_pond-enclosure-sixbar-baseline.md`](20260712-205600_pond-enclosure-sixbar-baseline.md) · scorecard [`20260712-210800_pond-enclosure-scorecard-two-column.md`](20260712-210800_pond-enclosure-scorecard-two-column.md) · proven_seat_g1 nested-bwrap note

---

## Seat first — founding law

Copied into counsel; restated here so the hammock carries its own charter.

1. **Pond replaces orchestration, never enforcement.** The fence is the Linux kernel (user namespaces, Landlock, mount and network namespaces) by way of bubblewrap. Pond authors policy, refusals, and supervision above the syscall. **Why:** adversarial attention is the safety in isolation code; a fresh mechanism begins with none.  
2. **Single-stranded as a security law.** One strand; no shared mutable policy state; every check adjacent to its use and bounded. **Why:** TOCTOU lives in concurrent boundaries; one strand closes that class by construction.  
3. **Higher bar.** Pond must hold and fail where the incumbent does. Six green bars are necessary and nowhere near sufficient.

**Finding this sitting:** no sixbar required Pond to invent enforcement. Proceed.

---

## Mechanical enabler (landed this sitting)

Landlock probe in `tools/pond_enclosure_sixbar.rish` is **enclosure-neutral**:

- Accept `/tmp/.enclosure-landlock` **or** elder `/tmp/.ai-jail-landlock`
- Sixbar **GREEN** against the living jail after the rename
- Scorecard / baseline pins updated to name the dual marker

Bar5 sandbox fingerprint now measures Framework jail-local `CC8B…` (PUBKEYS), so the card matches this host's incumbent.

---

## The six bars — what each measures at the kernel

| # | Bar | Kernel / host fact measured | Incumbent today |
|---|-----|-----------------------------|-----------------|
| 1 | Durable project tree | Bind-mount of pier survives; writes persist on the real project fs | `.git` · writable root · cache probe |
| 2 | Home and tmp reset | Private `$HOME` tmpfs · private `/tmp` · Landlock/exec marker present | Sparse HOME · dual Landlock marker |
| 3 | Wayland/GPU lane | Display and DRM device nodes passed through deliberately | `WAYLAND_DISPLAY` · `/dev/dri` |
| 4 | KVM lane | Device node gated by *our* policy, not ambient | `LANE_KVM=off` · teacher binary pin |
| 5 | Signing-lane separation | Secrets in jail keyring are exactly the sandbox set | One jail-local secret · master absent |
| 6 | Three refusals + bus | Named refuse paths; session bus exposure **recorded** | kvm-off · no D-Bus KVM · host home · three-door gap |

Pond-required column (still open): same behaviors without ai-jail-only artifact names; bus env empty · socket absent · netns unshared.

---

## ai-jail flag set as specification

Read living launch (`cursor-jail.sh` / process cmdline this host) as decisions. Each flag earns a why.

| Flag / posture | Decision | Why |
|----------------|----------|-----|
| `--private-home` | Empty sparse `$HOME` | Host credentials stay out of the agent view |
| `--no-docker` | No Docker socket | Socket is a host root escape |
| `--gpu` / `--display` | Wayland + DRM passed | Editors need a window; GPU is a named lane |
| `--landlock` / `--landlock-exec` | Filesystem and exec Landlock | Defense in depth on top of namespaces |
| `--no-save-config` (wrapper) | Do not merge run into `.ai-jail` | One-shot flags stay one-shot |
| `--no-sandbox` (Chromium) | Disable nested Chromium sandbox | Cannot nest inside bwrap; outer jail is the boundary |
| No `--kvm` on teacher | KVM never ambient | Our `LANE_KVM` gate owns that device |
| Project bind only | Pier is the durable ground | Host `$HOME` / parent paths reset on exit |

Pond must **name equivalents** for each decision as policy, then ask bubblewrap/ai-jail (executor) to apply them — never reimplement the primitives.

---

## Session-bus gap (already named)

Bar6 three-door measure on this host (example sitting): `bus_env=set` · `bus_socket=present` · `bus_netns=shared`. Pond-required wants all three closed. This remains the honest gap row — not forced red on baseline, not papered over.

---

## Where Glow must reach a syscall

| Need | Lean | Why |
|------|------|-----|
| Landlock / namespace / bwrap edges | **C shim under seam-C law** | Kernel ABI and `liblandlock`/`bwrap` spawn are C's home; Glow stays policy + witnesses |
| Policy tables · refuse names · bar reports | **Glow → Zig → Rye witnesses** | Language and inventary stay Glow; no kernel ABI in desks |
| Thin host helpers | Existing `.rish` / bash elders | Outer-terminal only when USB/KVM/host tools require it |

**Ruled out for ring-0:** Glow inventing a second isolation library.

---

## Nesting shape — nest-then-remove

```
┌─────────────────────────────────────────┐
│  host (Framework · GNOME Wayland)       │
│  ┌───────────────────────────────────┐  │
│  │ ai-jail (outer wall · executor)   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │ Pond (author · reporter)    │  │  │
│  │  │  policy · refusals · bars   │  │  │
│  │  │  Glow desks · Rish witnesses│  │  │
│  │  └─────────────────────────────┘  │  │
│  │  Cursor / Zed / agents            │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

**Constraint:** nested bwrap is refused inside the jail today (`tools/proven_seat_g1.rish` notes this). Therefore **do not** design two literal bwrap layers. Pond authors argv/policy; ai-jail (or a future Pond wrapper that *is* the single bwrap) executes.

**Exit re-read with the enforcement line drawn:**

- Flip becomes **removing** the outer fence after a season of evidence (exit bron · master seal · N durability).  
- Retreat means **keeping** `ENCLOSURE=ai-jail` — something already running. Trivial by construction.  
- Criterion 6 on the exit card still holds; the *story* of the flip changes from “swap walls” to “remove scaffolding.”

---

## What would stop the hammock

If a future bar can only go green by Pond implementing Landlock/namespaces itself, **STOP** and reply — that finding outranks any spec. This sitting found no such bar.

---

## Explicit non-goals this lap

- No Pond binary  
- No `ENCLOSURE=pond`  
- No first ring build  
- No campaign across `glow/` mold headers (advisory 11 · on-touch)

---

*May the hammock hold until the season earns its seal, and may the fencepost never pretend to be the wire.*
