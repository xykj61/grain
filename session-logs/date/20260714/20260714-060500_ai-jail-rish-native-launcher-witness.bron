stamp: 20260714.060500
zone: PDT (Reno, NV convention)
model: Sonnet 5 1M Medium
voice: Rio 3

what: >
  Converted the macOS ai-jail enclosure launcher and witness from bash to
  Rish, at Keaton's request before opening the next Neth build lap.

why: >
  The bash pair (tools/cursor-jail-macos.sh, tools/cursor_jail_macos_witness.sh)
  worked and stayed as a witnessed elder, but TASKS.md already named the
  Rish-native version as a future item once Rishi's own hosted build was
  proven on this Mac's arm64 -- which it was, days ago. Keaton asked for the
  reminder of how to run ai-jail, then asked for the Rish conversion first,
  before starting the Neth build lap.

did:
  - "tools/cursor_jail_macos.rish": >
      New primary launcher. Builds the identical SBPL profile (version 1,
      deny default, open reads, fenced writes to $repo/tmp/private-tmp/
      private-var-folders, the /dev/null write allowance, process/signal/
      sysctl/mach/iokit allowances, network allow-or-deny) using Rish's own
      `join`/`read-file` primitives instead of a heredoc. Supports
      --print-profile and --no-network, matching the bash elder's contract.
      Spawns (not run) so the launcher returns immediately and Cursor keeps
      running detached, matching the bash elder's `exec` intent.
  - "tools/cursor_jail_macos_witness.rish": >
      New primary witness. Builds its own copy of the profile (network-open,
      no flag plumbing needed for a witness), then runs the same
      permit-inside / refuse-outside pair the bash witness proved, using
      assert instead of bash's if/exit. Both green on this host.
  - "tools/fixtures/dquote.txt": >
      New one-byte fixture (a bare `"`), same shape as the existing
      tools/fixtures/newline.txt. Rish string literals have no `\"` escape
      -- a real, already-named language gap -- so SBPL's own quoted-path
      syntax (`(subpath "...")`) is built by `join`-ing fragments around
      this fixture's single character rather than escaping inline. Confirmed
      `join [a b c] ""` performs plain concatenation (no separator) via the
      existing rw1_exact_probe.rish fixture's own use of the same pattern.
  - "manual/guides/macos-ai-jail-setup.md": >
      Rewritten Set It Up section to lead with the Rish commands; the bash
      elders now appear as an explicit fallback path, not the primary one.
      Version bumped to 20260714.060500.
  - "work-in-progress/TASKS.md": >
      The macOS ai-jail granular list's open Rish-seed row marked done,
      pointing at both new files and this stamp.

witness: |
  $ rishi/bin/rishi run tools/cursor_jail_macos.rish --print-profile
  → emits the SBPL profile, byte-identical in structure to the bash elder's
  $ rishi/bin/rishi run tools/cursor_jail_macos_witness.rish
  → PASS: write inside the project succeeded
  → PASS: write outside the project was denied
  → GREEN: cursor-jail-macos enclosure -- permit and refuse both hold.
  $ rishi/bin/rishi run tools/cursor_jail_macos.rish
  → launched inside the sandbox-exec enclosure, returned immediately

named_gap: >
  The Rish launcher does not yet read tools/enclosure.conf for CURSOR_BIN --
  it calls `cursor` directly. A named simplification, not an oversight;
  the bash elder still honors that file if a different binary is ever
  needed.

next: >
  Open the Neth build ladder's next lap -- small serial core -- per the
  direction Keaton chose right before this detour.
