# Mac Tahoe -- run the receipt card Swift tests

**Language:** EN
**Stamp:** `20261003.174850` (EDT, the pier clock that wrote this page)
**Voice:** Kyri
**Style:** Gauge, Field setting
**Status:** Living -- paste this into the jailed Cursor GUI on the MacBook Air
**Revised:** `20261003.191625` -- the jail launch comes before the tests. Swift caches stay inside the checkout unless a refusal names one path.
**Room:** checkable -- each step names a file, a command, or a stop
**Continues:** the incense receipt lap that landed on `xy` through `c3a681212a`
**Contract:** [`../active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md`](../active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md)

You are in the Cursor application on the MacBook Air, macOS Tahoe. This page is the
next lap of the receipt contract. The pier finished the readings a Linux host can
take. Your machine is the one with Swift.

## What you are continuing

The contract is **The receipt you can read**. Eight acceptance cases have witnesses
on the pier. `tools/r/receipt_case_board_witness.rish` runs them as one board and
prints `milestone=unstamped`. Case 4 on that host is `case4=source_order`. The
source scan prints `swift_runtime=unverified_on_this_host` on every host, because
the scan reads source and never launches XCTest.

Case 4's runtime proof is two test classes, both marked `@available(macOS 26.0, *)`:

- `skate/Tests/SkateCoreTests/ReceiptCardTests.swift`
- `skate/Tests/SkateCoreTests/ReceiptAccessibilitySnapshotTests.swift`

The card frame is `ReceiptCard.columns = 72` and `ReceiptCard.rows = 18` in
`skate/Sources/SkateCore/ReceiptCard.swift`. The package is `skate/Package.swift`,
tools version 6.2, Swift language mode v6.

The pier tip that wrote this prompt's parent is `c3a681212a`. Pull `xy` first so
this file is in your tree. The jail section below is the `20261003.191625` revision.

## Sync the Mac from the tree, not from the pier's NixOS

`nixos/` is the pier's declared host. Copying it onto the Mac, or running
`nixos-rebuild` there, is the wrong direction. The Mac has no NixOS generation
to switch. The sync is the git tree.

From an ordinary Terminal, outside any jail:

1. `git remote -v` shows `xy` as `git@github.com:xykj61/grain.git`. Leave `ww`
   off this checkout. Do not run `publish-seed.sh` or `publish-seed.rish`.
2. On a clean checkout, `git pull --ff-only xy main`.
3. Generate jail-local keys once, outside the jail, if this clone does not
   already have them: `rishi/bin/rishi run tools/g/generate_jail_local_keys_macos.rish`.
   Those keys live in this checkout's gitignored `.ssh/` and `.gnupg-rye/`.
   Do not copy the pier's `.ssh` or `.gnupg` onto the laptop.
4. `~/.gitconfig` may stay on the Mac. `--harden-home` leaves that file
   readable. It denies the real `~/.ssh` and `~/.gnupg`.
5. Swift itself is the Mac toolchain: Xcode or the Command Line Tools under
   `/Applications` or `/Library/Developer`. `xcode-select -p` names it. Homebrew
   is for the key-card tools in `SOURCE.md`, not for this test lap.

## Open Cursor inside the jail first

The GUI sandbox is this tree's Seatbelt launcher, after the pull. Upstream
ai-jail on macOS is the tool for a terminal agent or a shell. It is not the
launcher that starts `Cursor.app`. The guide witnessed upstream `v1.13.0`; if
you also keep a CLI `ai-jail`, take the current macOS release from its GitHub
releases rather than an old binary. The GUI lap still starts here:

```bash
cd ~/grain
rishi/bin/rishi run tools/cu/cursor_jail_macos.rish --harden-home --private-home --cursor /Applications/Cursor.app
```

Exec the app binary through that launcher. The `cursor` CLI wrapper dies under
Seatbelt and reports success while the app stays closed. Pass `--no-sandbox`
is already the launcher's job, so Chromium's own sandbox stays inside Seatbelt.
Prove the fence once from outside the jail:

```bash
rishi/bin/rishi run tools/cu/cursor_jail_macos_witness.rish
```

Paste this prompt into that jailed window. A Cursor you opened from the Dock
is outside the fence.

Reads stay open, including the Swift toolchain outside `$HOME`. Writes are
fenced to the checkout, `/tmp`, `/private/tmp`, and `/private/var/folders`.
`--private-home` denies every other top-level entry under the real `$HOME`,
including `~/Library`.

## Swift caches stay inside the checkout

`swift test` should write under `skate/.build`, which the fence already allows.
From `skate/`:

```bash
swift test --build-path "$PWD/.build" --cache-path "$PWD/.build/cache" --filter 'ReceiptCardTests|ReceiptAccessibilitySnapshotTests'
```

If that command refuses a write, record the path it names. Prefer pointing the
cache back into `skate/.build`. Add a write subpath to
`tools/cu/cursor_jail_macos.rish` and `tools/cu/cursor-jail-macos.sh` together
only when the tool ignores the in-repo cache and names one fixed path. A likely
pair, and only if a refusal names them, is `~/Library/Caches/org.swift.swiftpm`
and `~/Library/Developer/Xcode/DerivedData`. Opening all of `~/Library` is the
wrong repair. Seatbelt resolves an overlapping allow and deny to deny, so a
new allow has to be a path `--private-home` did not already deny.

## What you do

1. Open the Mac's own grain checkout. Your stamps use Pacific time:
   `TZ=America/Los_Angeles date '+%Y%m%d.%H%M%S'`. The pier clock stays Eastern.
   A stamp you write on this laptop comes from the Pacific clock.
2. Sync as the section above says, then launch the jailed Cursor GUI, then
   do the rest of this lap inside that window.
3. Read `swift --version` and confirm you are on Tahoe. The tests already ask
   for macOS 26. If Swift skips them for availability, record that skip. Leave
   the availability line as it stands.
4. From the checkout root, run the source half:
   `sh tools/fixtures/r/receipt_still_order_scan.sh`
   A clean tree prints `verdict=source_order_agrees` and
   `swift_runtime=unverified_on_this_host`. That second line is the scan telling
   the truth about its own reach. Leave it.
5. From `skate/`, run the two receipt classes with the in-repo cache from
   the section above. The filter is the whole lap. `ConsentRailTests`, `EventRingTests`,
   `FrameGridTests`, and the other Skate classes stay for their own sittings.
6. Write the result into a session log on today's Pacific shelf, and add one
   additive **Revised** line on the receipt contract. Name the Swift version,
   the filter, and pass or fail. The contract path stays
   `active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md`.

## What a green run still leaves

A green XCTest run is case 4's runtime on this laptop. It is the reading the
pier could not take. The achieved milestone name stays unstamped. The contract's
own condition is still one admitted fixture passing all eight cases on metal.
`tools/r/receipt_case_board_witness.rish` keeps printing `milestone=unstamped`.
You do not edit that scan into a stamp.

## What you leave alone

- Product meaning, a new module seat, DJINN design authority, and custody.
- The further call graph past the one-file hop. `tools/r/receipt_third_import_witness.rish`
  already holds that hop. Mantra stays the shared carrier.
- The pier fleet. It is clocked out. Diffuser and petrichor are mid-rebase on
  the pier. This laptop is a different checkout. You do not finish their rebase.
- `publish-seed.sh`, force-push, and a second personal remote.
- A commit that cannot be signed. Signing stays on. If GPG refuses, stop and
  say so.

## Send

When the tests have a result, commit that result with the session log and the
contract line. Push `xy` only. The subject stays under 50 characters. The body
names the test filter and the file that changed.

ty every1

May the card you run here be the same card the contract already drew, and may the reading travel home clean.
