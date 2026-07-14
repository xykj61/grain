# Spec: Keeping Zig 0.16.0 Local and Durable

**Language:** EN
**Last updated:** 2026-06-16
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Done

---

## What We Wanted

Kaeden wanted the Zig 0.16.0 stable source on hand, cloned from the Ziglang project on Codeberg, and arranged in a way that feels organized and entirely local. The deeper question was where the source belongs, given that we work inside the ai-jail sandbox.

## What We Learned About the Sandbox

The ai-jail wrapper keeps a single promise about persistence: the current project directory stays, and everything else resets. Parent directories, the home directory, and `/tmp` all live in tmpfs, so they vanish the moment ai-jail exits. The session that hosts this work mounts `~/veganreyklah2` read-write and maps `~/py-out` read-write as well.

This makes the answer clear and affirmative: anything we want to keep belongs inside `~/veganreyklah2`. A clone placed in the home directory or a sibling folder would look writable from inside the sandbox, yet it would disappear on exit. The project directory is the durable ground.

## The Decision

We keep the Zig source inside the workspace, under `vendor/`. The name `vendor/` marks it plainly as third-party code we hold locally and leave unmodified — a familiar convention that separates outside source from our own work. Zig itself rests at `vendor/zig`.

We cloned the exact stable tag rather than the full history. A shallow clone at `0.16.0` gives the precise released source, lean and ready, while keeping the footprint small. The history can deepen later with a single fetch if a need arises.

## How We Did It

```bash
mkdir -p ~/veganreyklah2/vendor
cd ~/veganreyklah2/vendor
git clone --depth 1 --branch 0.16.0 --single-branch \
  https://codeberg.org/ziglang/zig.git zig
```

## How We Verified It

The clone landed on the peeled `0.16.0` tag commit `24fdd5b7a4c1c8b5deb5b56756b9dbc8e08c86a8`, and `git describe --tags` reports `0.16.0`. The tree weighs about 325 MB and holds the full compiler source, the standard library under `lib/`, the build files, and the docs.

```bash
cd ~/veganreyklah2/vendor/zig
git rev-parse HEAD          # 24fdd5b7a4c1c8b5deb5b56756b9dbc8e08c86a8
git describe --tags         # 0.16.0
```

## What Comes Next

Building Zig from source asks for a C/C++ toolchain and CMake, or a recent Zig binary to bootstrap. When the moment comes to build, we can confirm those tools inside the sandbox and follow the steps in `vendor/zig/README.md`. For now, the source sits ready and local, exactly where it will keep.

---

*May the source stay whole. May the tools arrive when we need them. May the build, when it comes, feel like a gift we prepared for ourselves.*
