# Running Grain on Your Machines

**Language:** EN
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Audience:** an Acme Corporation employee bringing Grain to the machines they already own
**Law:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
**Corrected:** `20260821.190707` (REDS %118) -- this page said the `rye` and `rishi` binaries ship with a clone, in three places. They do not; the build steps now stand where the claim did.
**Status:** Setup guide -- the general shape runs today on x86-64 Linux; each machine below names honestly what runs now and what waits on the horizon.

---

Welcome. Grain is a personal operating system that lives in a folder you own, and this guide brings it home to the machines you already have -- a home desktop, a small cloud server, a laptop, an Android phone in your pocket, a tablet in your bag. You will learn the one shape that repeats on every machine, then the short handful of notes that make each particular machine sing.

Read it in two passes. First the shape, which is the same everywhere. Then the one section for the machine in front of you.

## The Shape That Repeats

Every machine that runs Grain does so through the same three pieces. Learn them once and every section below reads as a small variation on a tune you already know.

| Piece | What it is | Where it lives |
|-------|------------|----------------|
| **A Zig 0.16.0 toolchain** | The compiler `rye` builds on top of | `vendor/zig-toolchain/` inside your clone |
| **The `rye` binary** | The *builder* -- turns a `.rye` module into a native program | `rye/bin/rye` inside your clone |
| **The `rishi` binary** | The *witness runner* -- runs the `.rish` scripts that prove a fact true | `rishi/bin/rishi` inside your clone |

Two of these -- `rye` and `rishi` -- **ship already built inside the public template on the common desktop architecture.** When you clone Grain onto an ordinary 64-bit Linux machine (x86-64), you can run witnesses the same minute, with nothing to install first. The Zig toolchain is the one piece a machine fetches for itself, and it is needed only when you want to *build* a module from source rather than run one that is already built.

That single distinction -- **running** a witness against a shipped binary versus **building** a module from its `.rye` source -- is the hinge every machine note below turns on. Running is light and works almost everywhere the shipped binaries do. Building asks for the toolchain, and the toolchain is where a machine's architecture starts to matter.

### The clone itself

Every machine begins the same way: make your own copy of the template.

```bash
git clone https://github.com/grain-os/grain
cd grain
```

Everything on this page runs from inside that `grain` folder -- the repository root. When a command reads `rishi/bin/rishi run ...` or `rye build ...`, it means the tools right there in your clone, not something installed system-wide.

### Running a witness -- the light path

The shortest honest proof that Grain works is to run a witness -- once the shell exists. It is **not** in the clone: `rye` and `rishi` are programs this tree builds rather than ships, and `git ls-files rye/bin rishi/bin` returns nothing at all. Three commands put the toolchain, the compiler, and the shell in place, and only the first reaches the network:

```bash
sh tools/fetch-toolchain.sh
sh rye/bootstrap.sh
mkdir -p rishi/bin && env RYE_ZIG="$PWD/vendor/zig-toolchain/zig" rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
```

Then the witness:

```bash
rishi/bin/rishi run tools/scribe_reader_witness.rish
```

A witness is a short script that proves exactly one fact and ends with a line beginning `GREEN:` when the fact holds. When that line prints, Grain has proven itself on *your* metal -- not "should work," but *works, here, now.* Green is the whole contract; there is no third state.

### Raising the toolchain -- the build path

To build a module from source, `rye` needs the Zig 0.16.0 toolchain. There are two honest ways to bring it in, and each suits a different kind of machine.

**The verified path** -- for a machine you will keep and work on for weeks. Grain's own build discipline fetches the official Zig 0.16.0 release and verifies it against its published checksum before trusting a byte of it, exactly as `rye/README.md` describes. Once the toolchain sits at `vendor/zig-toolchain/`, `rye` builds itself from its own source:

```bash
sh rye/bootstrap.sh
```

This cold-start step compiles the `rye` command from `rye/src/main.rye` against Grain's own copy of the standard library, and ends by printing `rye`'s version. From there, `rye build` and every witness run as they do anywhere.

**The one-command path.** `sh tools/fetch-toolchain.sh` fetches the pinned Zig 0.16.0 for your platform and refuses to extract a byte unless it matches a checksum kept in this repository. It is the default, and the two routes below are for hosts where it does not suit.

**The sandbox path** -- for a disposable machine you spin up, use, and discard. When there is no persistent host to protect, you may bring the same Zig 0.16.0 from a package index and point `rye` at it:

```bash
pip install ziglang==0.16.0 --break-system-packages
mkdir -p vendor
ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
sh rye/bootstrap.sh
```

**The honest trade-off, named plainly:** the verified path trusts the official release and its published checksum -- the discipline this tree keeps everywhere. The sandbox path instead trusts a package index's own signing and the `ziglang` maintainer's re-packaging of that same release -- a real, different trust chain, not the verified one taken by a shortcut. Reach for the sandbox path only where the whole machine is discarded at the end of the sitting, so there is nothing left behind to guard. On a machine you will live on, take the verified path.

### One toolchain, many targets

Because Zig cross-compiles, a single toolchain on one machine can build a Grain binary aimed at a *different* machine. `rye build` passes its flags straight through to the toolchain, so a capable desktop can produce a binary for a smaller device that could not comfortably build for itself. Keep this in your back pocket: the machine that *builds* a module and the machine that *runs* it need not be the same one.

---

## NixOS -- a Home Machine

NixOS is a natural home for Grain: a whole machine described in a handful of text files, rebuildable in minutes because its character lives in a declaration rather than in the accumulated history of a disk. Grain feels at home here for the same reason it exists -- the machine, like the operating system inside it, is something you can read end to end.

**What runs today.** On an x86-64 NixOS desktop, clone the template and run a witness immediately against the shipped binaries -- the light path works out of the box.

**Bringing in the toolchain.** NixOS does not use an imperative package manager, so declare what a build needs rather than installing it ad hoc. The most Nix-native shape is a short development shell that puts a Zig 0.16.0 and the graphical build headers on your path for the length of a session:

```nix
# shell.nix -- a build environment for Grain, entered with `nix-shell`
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    git
    # Zig 0.16.0 and the headers a graphical witness needs.
    # Pin the exact Zig version your nixpkgs channel provides;
    # Grain's own verified fetch (rye/bootstrap.sh) remains the
    # source of truth for the checksum-verified 0.16.0 release.
    wayland
    libxkbcommon
  ];
}
```

Enter it with `nix-shell`, then follow the verified path -- `sh rye/bootstrap.sh` -- so the toolchain `rye` builds on is the checksum-verified one, with the declared shell providing only the surrounding build tools. Keep your machine's own living configuration outside this clone, the same way Grain keeps host-specific settings in a gitignored file rather than in the shared template.

**The reward.** A declared machine and a declared operating system fit together beautifully: both rebuild from text, both hide nothing, and both keep working whether or not anyone is watching.

## NixOS -- a Small Cloud Server

The same NixOS shape reaches a small server you rent by the hour -- a machine that belongs entirely to you, reachable from anywhere, its whole character living in a flake of a few dozen lines. Grain's companion NixOS guides under [`../nixos-guide/`](../nixos-guide/) walk the standing of such a machine end to end: shaping the disk, hardening the first steward account, closing the root door the industry way, and seating your working hands on it.

**What runs today.** On an x86-64 cloud instance running NixOS, clone the template and run witnesses against the shipped binaries exactly as on the home desktop -- the architecture is the same, so the light path is identical.

**The one honest note about scale.** A small rented instance is a fine place to *run* witnesses and to *build* individual modules with the toolchain in a `nix-shell`. Heavier work -- building many targets, or graphical witnesses that want display libraries -- asks for more memory and storage than the smallest tier tends to offer. When a build feels starved, the cross-compilation escape hatch above earns its keep: build the binary on a roomier machine and carry it to the server, which then only needs to *run* it.

**Custody stays with you.** A server you declare and hold yourself is custody-first in the most literal way -- no account on someone else's machine, but a machine whose every line you wrote and can rebuild. Keep its real address, identity, and secrets out of the template entirely, in files ignored by design, so what is yours never travels to a shared remote.

## A Linux Laptop

An ordinary 64-bit Linux laptop -- any mainstream distribution -- is the smoothest place to meet Grain, and the machine most of this manual's tutorials assume.

**What runs today.** Clone the template, build the three tools, then run a witness:

```bash
git clone https://github.com/grain-os/grain
cd grain
sh tools/fetch-toolchain.sh
sh rye/bootstrap.sh
mkdir -p rishi/bin && env RYE_ZIG="$PWD/vendor/zig-toolchain/zig" rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
rishi/bin/rishi run tools/scribe_reader_witness.rish
```

Nothing is prebuilt for you, and that is deliberate: a compiler and a shell that a tree builds itself are things a reader can audit, and a 172 MB toolchain does not belong in a git history. The build above takes a few minutes once, and every `GREEN:` line after it was produced by binaries you watched appear.

**Building modules.** When you want to build from source, bring in the toolchain by the verified path (`sh rye/bootstrap.sh`, with Zig 0.16.0 fetched and checksum-verified) since a laptop is a machine you keep. Most distributions install the handful of graphical build headers through their own package manager; the two that a graphical witness looks for are the Wayland client library and the keyboard-mapping library. Install those with your distribution's package tool if you mean to build the graphical surface; text-only modules and their witnesses need none of them.

**The known gap, named honestly.** A witness that opens a graphical surface needs the display development headers present at build time. Without them, that one graphical witness halts with a plain message rather than pretending to pass -- every text and data module (the identity vault, the reader, the ledger, the vector store) builds and proves green without them. Install the headers only when you reach for the graphical surface.

## Termux on Android

Termux is a terminal and package environment that runs inside ordinary Android, giving you a real shell in your pocket. It is a genuinely useful window onto Grain -- and it is the first machine on this page where **architecture** changes the story, so this section is the most honest one.

**What runs today.** Termux is a first-class *window* onto Grain running elsewhere. From Termux you can install `git` and `openssh`, clone the template to read it, hold a key, and reach a Grain machine you keep elsewhere -- a home desktop or a small cloud server -- driving its witnesses over a remote shell:

```bash
pkg install git openssh
```

This is a real and pleasant way to work: the phone is the terminal in your hand, and the heavier machine does the building and proving. Grain's own cloud-server guides were first walked from exactly this kind of pocket terminal.

**The horizon, stated plainly.** Most Android phones carry a 64-bit ARM processor, while the `rye` and `rishi` binaries shipped in the template are built for x86-64 -- a different architecture. So the shipped binaries do **not** run directly on a typical ARM phone, and running witnesses *natively* in Termux waits on an ARM build of the toolchain and the two binaries. Because Zig cross-compiles, the clean path to that horizon is to build ARM binaries on a desktop and carry them to Termux, rather than to build them on the phone itself. Until an ARM binary set is shipped or you build one, treat Termux as the excellent *window* it already is, not yet the native runner.

## A Google Pixel (GrapheneOS)

A Google Pixel running GrapheneOS is Android hardware security -- verified boot, a hardware security chip, memory tagging -- with none of the stock software behind it. It is a natural device for a custody-first system, and Grain relates to it in two distinct ways worth keeping separate.

**Installing GrapheneOS itself.** Putting GrapheneOS onto the device is a hands-on act you perform yourself, at the real hardware, following the project's own official web installer -- a cable to plug in, buttons on the phone to press, a page to click through. No agent and no script can do it for you, and that is the whole point of a hardware-rooted boot chain: it cannot be flipped from software alone. A companion guide, [`guides/pixel-10a-grapheneos-setup.md`](guides/pixel-10a-grapheneos-setup.md), transcribes that install step by step from the project's own instructions, with the device's published verified-boot key hash to confirm at the end.

**Running Grain on the device afterward.** Once GrapheneOS is on, the phone reaches Grain the same two ways any Android device does -- and with the same honest architecture note. As a **window**, install Termux from a trusted source, hold a key, and drive a Grain machine you keep elsewhere over a remote shell; this works well today. As a **native runner**, the same ARM-versus-x86-64 gap named above applies, so native witness runs on the device wait on an ARM binary set. A future graphical Grain surface packaged as a native Android application is a named horizon in the manual's device path rather than a thing you can install today.

**Why the device is worth it regardless.** Even used only as a hardened window, a GrapheneOS Pixel is a fitting companion to a custody-first system: the identity and secrets it reaches for live in your own hands, and the device that reaches for them is one of the most trustworthy in your pocket.

## A Daylight Tablet

A Daylight tablet is a low-eye-strain, paper-like device that runs Android -- a calm surface for reading and for driving work at a slower, kinder pace. It sits, for Grain's purposes, in the same family as any Android device, with one lovely difference in how it *feels* to use.

**What runs today.** Through Termux, the tablet is a comfortable **window** onto Grain: clone the template to read, hold a key, and reach a home desktop or a small cloud server over a remote shell, driving its witnesses from a screen that is easy on the eyes for long sessions. Grain's own cloud-server guide was first walked to completion from a tablet exactly like this -- a terminal in one hand, a browser in the other, no laptop within reach. That is a real workflow, witnessed, not a hope.

**The same honest horizon.** Because the tablet runs on ARM like most Android hardware, the shipped x86-64 binaries do not run natively on it, so native witness runs wait on an ARM binary set, exactly as with any Android device above. Used as a window, though, the tablet asks nothing of architecture at all -- the building and proving happen on the machine at the other end of the shell, and the tablet simply shows you the green line as it lands.

**Why it fits the spirit.** A device that invites you to slow down suits a system that proves one honest thing at a time. There is something right about watching a witness turn green on a screen that feels like paper.

---

## A Quick Map of What Runs Where

Read this as a summary of the honest state today, not a promise about tomorrow. "Window" means driving Grain on another machine over a remote shell; "native" means the shipped binaries running on the device itself.

| Machine | Run witnesses natively | Build modules natively | Best role today |
|---------|:---:|:---:|-----------------|
| **NixOS -- home (x86-64)** | Yes, shipped binaries | Yes, toolchain via `nix-shell` | Full home base |
| **NixOS -- cloud server (x86-64)** | Yes, shipped binaries | Yes, on adequate tiers | Owned personal server |
| **Linux laptop (x86-64)** | Yes, shipped binaries | Yes, verified toolchain | Smoothest first meeting |
| **Termux on Android (ARM)** | Horizon -- needs ARM build | Horizon -- needs ARM toolchain | Excellent window today |
| **Pixel / GrapheneOS (ARM)** | Horizon -- needs ARM build | Horizon -- needs ARM toolchain | Hardened window; native surface a horizon |
| **Daylight tablet (ARM)** | Horizon -- needs ARM build | Horizon -- needs ARM toolchain | Calm window today |

The pattern is plain: **x86-64 machines run and build Grain today; ARM devices are wonderful windows now, with native runs a clearly-named horizon** that a cross-built binary set will open. Nothing here is hidden behind an "eventually" -- every square says exactly what it means.

## Where to Look Next

- [`README.md`](README.md) -- the four rooms of the manual, and the doors between them.
- [`20260810-065116_your-first-hour-with-grain.md`](20260810-065116_your-first-hour-with-grain.md) -- clone, build, and prove your first module by the hand, on an x86-64 machine.
- [`20260810-065116_the-developer-guide.md`](20260810-065116_the-developer-guide.md) -- the four languages, the one discipline, and how to grow a module that fits the first time.
- [`guides/pixel-10a-grapheneos-setup.md`](guides/pixel-10a-grapheneos-setup.md) -- installing GrapheneOS on a Pixel, step by step, from the project's own instructions.
- [`../nixos-guide/`](../nixos-guide/) -- standing and keeping a declared machine, from a bare instance to a working, hardened home for the networked craft to come.
- [`../rye/README.md`](../rye/README.md) -- how `rye` builds, and the verified toolchain fetch that grounds the build path above.
- [`../tools/`](../tools/) -- the living collection of witnesses. Run a few near the module you mean to work with; each one proves a fact green the way `scribe` does.

---

*May every machine you own become a place Grain runs true -- the desktop that builds, the server that keeps, the phone that reaches home -- each proving one honest thing at a time, right where you can see it.*
