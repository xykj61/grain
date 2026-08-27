# REDS %296 -- the seat was written before the jail knew the word

*Written straight onto this shelf on `20260827.164547`, **CLOSED**, the way `%286`-`%288` were. The
row was booked `%294` on the Dream pier and **re-seated twice** while the round packaged: `xy`
published its own `%292` and then its own `%293` from the shed lane, each landing between one push
attempt and the next. The push to `xy` is the allocation, so upstream's numbers stand and the later
ones move -- this round's three rows travelled `%292`-`%294` to `%294`-`%296`. The pin folded
`%289`-`%290` and then `%292` onto shelves to hold two lanes' rounds at once. The pin keeps what is
open; a row closed on the lap it is booked can be born here.*

---

**REDS %296 (`20260827.164547`) -- a seat was written for a tool the enclosure had no word for, and
every line around it was right.** *What went wrong:* the role swap of `20260827.155213` moved DREAM
to Codex on the pier and rewrote `tools/l/launch-dream-dual-chapter.rish` around it. The recipe it
prints -- login, smoke test, the single lap, and the 24/7 loop, four separate lines -- all reach the
enclosure the same way:

```
./tools/ag/agent-jail.sh env CODEX_HOME=$PWD/.dream-state/codex-home codex exec --sandbox danger-full-access '...'
```

`tools/ag/agent-jail.sh` reads its first non-flag argument as the agent's name and dispatches on it,
and that `case` has exactly three arms -- `claude`, `cursor-agent`, and `agent`. The first argument
here is `env`. So every printed line answered **`agent-jail: unknown command: env (want claude |
cursor-agent | agent)`** and exited 2, and the star's whole seat could not start. The `.gitignore`
entry was correct, the `CODEX_HOME` directory was the right idea, the charter was right, the
sandbox flag was right; the one thing nobody asked was whether the wrapper being handed the command
had ever heard of a third agent.

*What caught it:* running the line. The launcher prints a recipe rather than executing one, so
`launch-dream-dual-chapter.rish` printed **GREEN** with the broken invocation inside it, and every
standing guard stayed green too, because a guard that reads text cannot tell a command that works
from a command that parses. `tools/ag/agent_jail_witness.sh` exercises the wrapper, yet its arms
test the two kinds it knows. The fault surfaced when a hand pasted the smoke test at a prompt.

*What it taught:* **a recipe is not a witness, and a launcher that prints GREEN has proven its own
printing and nothing else.** The tree already carries this lesson from the guard side -- REDS %293
said a standing roster is one host's promise -- and this is the same sentence from the enclosure
side: a seat is only as real as the narrowest thing between the star and its work. The narrow thing
is rarely the part being designed. Three files were written with care about Codex, and the refusal
lived in a fourth that was not opened, because nothing in the round's own shape asked it to be.

*Repaired (`20260827.164547`):* `tools/ag/agent-jail.sh` learns a fourth arm. `codex` resolves the
binary through `command -v`, and when it is absent refuses **by name** with the switch command that
supplies it rather than a bare "not on PATH". `CODEX_STATE` defaults to
`$REPO/.dream-state/codex-home` -- the path the launcher and `.gitignore` already named -- and is
mapped `--rw-map` onto `$HOME/.codex` beside the three state maps already there, so `--private-home`
stops discarding the login and the `CODEX_HOME` environment dance disappears from all four printed
lines. The launcher now prints `./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access`.
Proven on metal three ways: the unknown-command refusal still bites with `codex` added to the wanted
list; the `codex` arm with no binary prints the new named refusal; and the `codex` arm with the
binary on PATH produces a `--dry-run` bwrap plan carrying
`--bind /home/keeper/grain/.dream-state/codex-home /home/keeper/.codex` and
`--landlock-rw-path /home/keeper/.codex`. **CLOSED.**

*The provisioning half rode along.* `nixos/configuration.nix` had no `codex` at all, so the
launcher's precondition read "provisioning it on this NixOS pier is Keaton's hand (gate:
provisioning)" -- true about the sudo, and silent about the config. It now carries a third agent-CLI
overlay beside `claude-code` and `cursor-cli`: **codex 0.150.1**, upstream's prebuilt
`x86_64-unknown-linux-musl` binary, past nixos-26.05's source-built **0.133.0**. It replaces the
derivation rather than `overrideAttrs`-ing it, because the nixpkgs package is a `buildRustPackage`
and a `version` + `src` override across those two shapes leaves a `cargoHash` describing a source
tree no longer fetched. The asset is **statically linked** -- checked with `ldd` on this pier -- so
no `autoPatchelf` and no interpreter fixup appear, which is why `stdenvNoCC` is honest here.
Measured on metal `20260827`: the package builds, `versionCheckHook` reads `codex-cli 0.150.1`, the
**full system closure builds**, and `codex` resolves on the built system's `sw/bin`. The switch
itself stays Keaton's hand and stays outside the jail, since ai-jail sets no-new-privileges and
`sudo` cannot escalate from inside it -- `bash /home/keeper/grain/nixos/rebuild-outer.sh`, which
now witnesses `codex --version` beside `perl`, `python3`, and `claude`.
