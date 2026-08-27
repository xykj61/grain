# Codex CLI on macOS Tahoe -- the first hour to a Sound outer loop

**Stamp:** `20260826.182611`
**Language:** EN
**Style:** New Gauge Style, Field setting, Civic Tame (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** External research and a personalized setup runbook -- verified against this MacBook and the cited official sources on `2026-08-26`; every installation, sign-in, power, launch, and lane-custody action stays with the reader
**Host reading:** Apple silicon `arm64` - macOS Tahoe `26.6` build `25G5065a` - Homebrew zsh - Grain remote `xy`
**Kin:** [`../SOURCE.md`](../SOURCE.md) (whole-project onboarding, not the Sound prompt) - [`../tools/l/launch-sound-fixed-chapter.rish`](../tools/l/launch-sound-fixed-chapter.rish) (living Sound prompt printer) - [`../active-designing/20260826-151528_the-three-stars-of-the-aether-row.md`](../active-designing/20260826-151528_the-three-stars-of-the-aether-row.md) (lane charter)

## The decision

Install or update the **standalone Codex CLI** with OpenAI's supported installer. Use the copy
inside ChatGPT Desktop only as evidence that this Mac can already execute Codex, or as a temporary
interactive fallback. An application-bundle path is private implementation detail. The standalone
path is the stable command path for a supervised outer loop.

OpenAI gives one supported macOS and Linux command for both installation and update:

```zsh
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

That command downloads and runs OpenAI's installer, so it belongs under your hand in an ordinary
Terminal. This research leaves it for you to run. OpenAI says the first `codex` invocation opens the
interactive sign-in choice, while `codex exec` is the supported surface for repeatable workflows.
([Codex CLI](https://learn.chatgpt.com/docs/codex/cli))

The first hour ends with **one supervised, explicitly armed `once` at most**, and only after the
repository has a Sound-owned Codex wrapper with the same bounded checks the living MIND wrapper
already proves. A 24/7 loop belongs to a later rung.

## What this Mac says today

These are host-specific observations from `2026-08-26`.

- `sw_vers` reports macOS `26.6` build `25G5065a`. Apple's current Tahoe update page names
  **macOS Tahoe 26.6.2**, published `2026-08-17`, and recommends Tahoe updates for stability,
  performance, or compatibility. Back up, then use System Settings to review the offered update.
  ([Apple: What's new in the updates for macOS Tahoe 26](https://support.apple.com/en-us/122868))
- `uname -m` reports `arm64`, so this is Apple silicon. OpenAI's supported macOS installer above is
  the architecture-independent first path.
- The login shell is `/opt/homebrew/bin/zsh`. The current PATH includes Homebrew and
  `/Applications/ChatGPT.app/Contents/Resources`.
- `command -v codex` currently resolves to
  `/Applications/ChatGPT.app/Contents/Resources/codex`, version
  `codex-cli 0.150.0-alpha.8`. This is the bundled copy. Standalone installation remains unverified,
  and the official installer plus its post-install version reading determines the supported path.
- `ai-jail` resolves to `/opt/homebrew/bin/ai-jail`, version `1.13.0`.
- The safe fields in `~/.codex/config.toml` read `model = "gpt-5.6-sol"`,
  `model_reasoning_effort = "ultra"`, and `service_tier = "priority"`. The product displays the
  priority tier as **Fast**. These are configured defaults for later runs; active serving identity
  remains a separate, presently unverified reading.
- The MacBook is on AC power. `pmset -g custom` reports AC `sleep 0` and `displaysleep 0` at this
  reading. `pmset -g assertions` also shows temporary assertions held by running applications.
  Recheck at launch time so the power guarantee is current.
- This worktree is clean, tracks personal remote `xy`, and is six signed local commits ahead of the
  fetched `xy/main`. `rishi/bin/rishi` is absent here. Two other worktrees are active, including
  Sound and Dream/Glow changes. These facts alone place this checkout in **do not arm** state.

## The name that sounded like `source.md`

The case-sensitive search found `SOURCE.md`, the Sound launcher, and related dated records; it found
neither a lowercase `source.md` nor a `Sound.md`.

The case-sensitive [`SOURCE.md`](../SOURCE.md) is a whole-project guide titled *From Nothing to a
Signed, Sandboxed Home*. It teaches a new contributor how to build a Grain home. Reserve it for
onboarding; feed Codex the rendered Sound prompt instead.

Sound's living prompt surface is
[`tools/l/launch-sound-fixed-chapter.rish`](../tools/l/launch-sound-fixed-chapter.rish). It prints
the Sound lap prompt and points to the living three-star charter. On the synchronized branch used
for this reading, it is a prompt printer; a Sound-owned Codex outer-loop supervisor remains to be
seated. A separate active worktree contains unpublished Sound edits, which stay with their owner
until they land.

The practical translation is simple: where spoken instructions say "prepare `source.md`," prepare
and review the **real Sound prompt rendered by the Sound launcher**. Keep `SOURCE.md` in its actual
onboarding role.

## Zero to sixty minutes

Every block says whether it only reads or whether **you run it** to change something.

### Minute zero to ten -- earth, backup, and readings

1. Finish a current backup before an operating-system or CLI update. Use your normal Time Machine
   or other trusted backup path.
2. In System Settings, open **General -> Software Update**. The host reports Tahoe 26.6 while
   Apple's current page names 26.6.2. Review the offered update and release notes; the decision to
   install it remains yours.
3. In an ordinary Terminal, collect a fresh read-only card:

```zsh
sw_vers
uname -m
printf 'shell=%s\n' "$SHELL"
printf 'path=%s\n' "$PATH"
pmset -g batt
pmset -g custom
pmset -g assertions
```

`pmset -g` reads power state and leaves settings unchanged. Tahoe's local `pmset` manual says settings may
also be temporarily overridden by process power assertions, which is why the last command matters.

**Checkpoint:** the backup is current, the OS offer is understood, the host says `arm64`, and the
Mac is connected to AC before any long supervised run.

### Minute ten to twenty -- distinguish, install, update

Read every discoverable `codex` while leaving the machine unchanged:

```zsh
whence -a codex
command -v codex || true
codex --version 2>/dev/null || true
test -x /Applications/ChatGPT.app/Contents/Resources/codex \
  && /Applications/ChatGPT.app/Contents/Resources/codex --version
```

If the only path is under `ChatGPT.app`, the standalone CLI remains unavailable on PATH. If a standalone
path is present, the same official installer updates it. **You run this next command** when you are
ready; its effect is to download and install or update Codex CLI:

```zsh
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

OpenAI intentionally makes the post-install version check authoritative. A documentation screenshot
shows an example rather than a latest-version promise. Start a fresh login shell, then read the
result:

```zsh
exec "$SHELL" -l
whence -a codex
command -v codex
codex --version
```

`exec "$SHELL" -l` replaces only this Terminal shell. If the standalone executable remains
unresolved, read the installer's printed destination and PATH instruction. Apply its exact directory
for the current shell first:

```zsh
export PATH="<installer-reported-bin-directory>:$PATH"
command -v codex
codex --version
```

The placeholder is deliberate because the installer stayed under the reader's hand in this research
lap. Add that directory to a shell profile only after the current-shell check succeeds; profile
editing belongs to that separate, reviewed step.

**Checkpoint:** `command -v codex` names a standalone path outside ChatGPT.app, and
`codex --version` succeeds. Record and interpret the standalone reading on its own terms; the
bundled alpha number belongs to ChatGPT.app.

### Minute twenty to thirty -- sign in and read the configured defaults

**You run this command** in the ordinary Terminal. Its effect is to open Codex's interactive first
run and sign-in choice:

```zsh
codex
```

Complete the sign-in flow yourself. Keep every credential outside Grain. OpenAI says
`~/.codex/auth.json` contains access tokens and must be treated like a password: never commit it,
paste it into an issue, or place it in a prompt or log.
([OpenAI: Non-interactive mode](https://learn.chatgpt.com/docs/non-interactive-mode))

Exit the interactive session, then read only the three safe configured-default fields:

```zsh
awk -F ' *= *' \
  '/^(model|model_reasoning_effort|service_tier) *=/ { print $1 " = " $2 }' \
  "$HOME/.codex/config.toml"
```

Expected on this Mac today:

```text
model = "gpt-5.6-sol"
model_reasoning_effort = "ultra"
service_tier = "priority"
```

Call these **configured defaults**. Leave active runtime identity unverified unless the run itself
emits authoritative runtime metadata. `priority` is the configuration identifier; Fast is its
user-facing name.

**Checkpoint:** interactive sign-in succeeded, the auth file stayed outside the repository, and the
three default fields were read while the rest of the configuration remained private.

### Minute thirty to forty -- Grain, remote, custody, and build product

Use the persistent checkout you intend to supervise, normally `~/grain`, rather than a temporary
editor worktree:

```zsh
cd "$HOME/grain"
git status --short --branch
git remote -v
git worktree list
git rev-list --left-right --count xy/main...HEAD
git submodule status gratitude/grain-sketchbook
```

These are read-only. **You run the next command** only when you want a current personal-remote
reading; it contacts GitHub and updates the local `xy/main` tracking reference, without merging,
rebasing, or pushing:

```zsh
git fetch xy main
git rev-list --left-right --count xy/main...HEAD
```

Proceed only when all worktree changes are understood and Sound's files have no active sibling
owner. Read `construction/ITINERARY.md` whole. Stop at every custody gate, especially DJINN gate
`%6`. Verify the Sound printer and Rishi build product:

```zsh
test -x rishi/bin/rishi && echo 'RISHI READY' || echo 'RISHI MISSING'
test -f tools/l/launch-sound-fixed-chapter.rish && echo 'SOUND PROMPT PRESENT'
test -f active-designing/20260826-151528_the-three-stars-of-the-aether-row.md \
  && echo 'SOUND CHARTER PRESENT'
```

This worktree currently prints `RISHI MISSING`. Restore or build the repository's Rishi product by
its seated build instructions before rendering Sound. The environment owes that product; the Sound
prompt remains source-complete.

**Checkpoint:** `xy` is the personal remote, divergence is known, the tree is clean, no sibling owns
the target files, custody gates are read, and `rishi/bin/rishi` exists.

### Minute forty to fifty -- prove the enclosure, then print

First read the tools and the jail plan:

```zsh
ai-jail --version
ai-jail --dry-run --exec --private-home --no-save-config sh -c true
```

The plan must select the macOS Seatbelt backend, deny by default, name the intended repository as a
write allowance, and deny private key stores. Then run a live write-fence from an **ordinary
Terminal**, with Codex Desktop's existing Seatbelt fully outside the process chain. The probe must
write inside the repository and receive a denial outside it. Use a fresh, explicit path and inspect both outcomes; remove the
inside probe afterward. A Sound-owned wrapper should automate this exact invariant before it can
arm.

**You run this probe** only from the Grain root in ordinary Terminal. Its effect is to make and
remove one temporary file inside Grain while asking the jail to deny one temporary file in your
home directory:

```zsh
inside_probe="$PWD/.sound-jail-probe.$$"
outside_probe="$HOME/.grain-sound-jail-probe.$$"
test ! -e "$inside_probe" && test ! -e "$outside_probe" || exit 1
ai-jail --exec --private-home --no-save-config \
  sh -c 'printf "inside\n" > "$1" || exit 70
         if printf "escape\n" > "$2" 2>/dev/null; then exit 71; fi
         test ! -e "$2" || exit 72' \
  sound-jail-preflight "$inside_probe" "$outside_probe"
test "$(cat "$inside_probe")" = inside
test ! -e "$outside_probe"
rm -f "$inside_probe"
```

A zero exit and a clear outside path are the paired proof. Any other result closes the gate;
inspect the two explicit paths rather than broad-cleaning the tree.

Unrestricted Codex permissions mean only the **inner** command:

```text
codex exec --sandbox danger-full-access
```

OpenAI says `danger-full-access` belongs only in a controlled environment, and that `--full-auto`
is deprecated. For Grain, the controlled environment is the proven outer `ai-jail` write-fence.
An ordinary host stops at the outer gate. Keep user and project rules enabled; omit
`--ignore-user-config` and `--ignore-rules`.
([OpenAI: Non-interactive permissions and safety](https://learn.chatgpt.com/docs/non-interactive-mode))

After Rishi exists, render the real Sound prompt for review:

```zsh
rishi/bin/rishi run tools/l/launch-sound-fixed-chapter.rish \
  > /private/tmp/grain-sound.prompt
wc -c /private/tmp/grain-sound.prompt
sed -n '1,240p' /private/tmp/grain-sound.prompt
```

This writes one temporary prompt file outside the repository. Read it all. Confirm that it names
Sound's lane and refuses MIND, Dream, seed cadence, and gate `%6`.

**Checkpoint:** the real jail write-fence passes in ordinary Terminal, Rishi renders the current
Sound prompt, and the prompt is reviewed. This checkpoint remains preparation.

### Minute fifty to sixty -- dry plan, one supervised once, then inspect

The repository presently has a MIND-owned Codex supervisor and a Sound prompt printer. A landed,
Sound-owned Codex supervisor with single-instance locking, a STOP file, bounded logs, a failure
ceiling, and post-lap commit verification remains a prerequisite. The MIND launcher stays with MIND;
seat or land the Sound-owned wrapper under Sound custody first.

When that wrapper exists, its interface should make the sequence visible:

```text
<sound-wrapper> check
<sound-wrapper> once --dry-run
<sound-wrapper> once --arm-once
```

`check` makes zero model calls. `once --dry-run` prints the enclosed command locally. Only the final
line may invoke Codex, and only after a human reviews both earlier results.
OpenAI documents `codex exec -` as the form that reads the whole prompt from standard input, and
`--ephemeral` as the form that avoids saving rollout files. The Sound wrapper may therefore use
this inner shape only after its outer jail proof:

```text
codex exec --sandbox danger-full-access --ephemeral --strict-config -
```

([OpenAI: advanced stdin piping](https://learn.chatgpt.com/docs/non-interactive-mode))

After one supervised once, inspect before another run:

```zsh
git status --short --branch
git log -1 --show-signature --stat
git rev-list --left-right --count xy/main...HEAD
find . -maxdepth 2 -type f -name '*.log' -size +1M -print
```

Read the wrapper's bounded stdout, stderr, and final-message files. Confirm one coherent signed local
commit at most, a clean tree, zero push, zero sibling-lane edits, and clear credential hygiene. A
red check stops the run. A successful once earns a small capped loop trial later; repeated clean
trials earn consideration of 24/7.

## The Sound contract after the first hour

A Sound Codex outer loop is ready only when its own prompt and wrapper enforce all of these:

- **Owned lane:** Caravan, Tally, Scribe, and Sound's own prompt and witness surfaces.
- **Denied lanes:** MIND's Brushstroke and Surf/Skate; Dream's Glow lowering and seed cadence.
- **Sibling findings:** one factual ITINERARY line only when that file is free and living law permits;
  otherwise a handback. Never a sibling repair.
- **Custody:** DJINN gate `%6`, credentials, releases, power changes, remotes, and other named gates
  stop the lap.
- **Repository state:** a clean tree, zero commits behind fetched `xy/main`, known local-ahead count,
  intact submodule gitlinks, and no automatic pull, rebase, or push inside the model invocation.
- **One bounded lap:** one concrete crux, one signed local commit at most, and a clean descendant
  history. No commit is also acceptable when a named custody stop explains why.
- **Resources:** one instance; explicit prompt, log, lap, failure, and backoff ceilings; a STOP file;
  a CUSTODY file; signal cleanup; and a circuit breaker rather than endless restart.
- **Outer and inner safety:** a live `ai-jail` write-fence first, then
  `codex exec --sandbox danger-full-access`. The inner flag never blesses an ordinary host.
- **Rules and identity:** project and user rules remain enabled. Configured model, effort, and tier
  stay separate from active runtime identity.
- **Authentication:** stored outside Grain, absent from prompts, logs, commits, and environment dumps.
- **No seed cadence:** Sound surfaces it to Dream and does not run it.

This contract rewards small complete laps a person can review. Completed, reviewable outcomes are
the measure of progress.

## The decision tree

### Codex is absent

Run the official installer under your hand, start a fresh login shell, then verify
`command -v codex` and `codex --version`. Sign in interactively once. An installer red or a path
still inside ChatGPT.app closes this checkpoint.

### Codex resolves only inside ChatGPT.app

Treat the bundled version as observed fallback evidence. Run the standalone installer/update
command, follow its printed PATH instruction, and verify again. Keep the application-bundle path
out of every long-running launcher.

### A standalone Codex already resolves

Record its path and version. The same official installer performs an update. Verify the path and
version afterward; the displayed number is the installed reading, while official release guidance
determines support.

### Apple silicon or Intel

This Mac is Apple silicon. OpenAI provides the same supported macOS installer command, so no
architecture branch belongs in the first-hour happy path. If an installer reports an unsupported
architecture, preserve the exact message and stop rather than selecting an unofficial package.

### Sign-in fails

Keep the browser and CLI in the ordinary user session. Confirm date, network, and the resolved
standalone path. Credentials stay in their private store, outside Grain. Interactive `codex` must
work before automation begins.

### `ai-jail` dry plan passes and live proof fails

Confirm the proof is running from ordinary Terminal rather than Codex Desktop. Preserve the jail
output, remove any probe residue, and stop. A rendered profile is evidence of intent; only the live
inside-write/outside-refusal pair proves the fence.

### Rishi is missing

Restore or build `rishi/bin/rishi` by repository law. Render the prompt from the synchronized
checkout, and classify the build product as an environment prerequisite.

### The tree is dirty, behind, or actively owned

Stop. Finish or hand back the existing work, synchronize under the repository's normal human-led
process, and rerun every check. A first outer-loop lap should begin from boring Git state.

## Tahoe while the display rests

The first hour stays in the foreground. A screensaver or display sleep may coexist with work when
the Mac remains awake on AC. Apple places display timers under **System Settings -> Lock Screen**
and the laptop option **Prevent automatic sleeping on power adapter when the display is off** under
**System Settings -> Battery -> Options**. Apple also recommends Activity Monitor's CPU view when a
background process unexpectedly prevents sleep.
([Apple: If your Mac sleeps or wakes unexpectedly](https://support.apple.com/guide/mac-help/if-your-mac-sleeps-or-wakes-unexpectedly-mchlp2995/mac))

This guide leaves those settings unchanged. Read them in Terminal with:

```zsh
pmset -g batt
pmset -g custom
pmset -g assertions
```

Tahoe's local `caffeinate(8)` manual says `-i` prevents idle system sleep, while `-s` prevents
system sleep only on AC. When a utility follows the flags, the assertion lasts for that utility's
life. After successful supervised once runs, **you may run** a small capped trial under:

```zsh
caffeinate -s <sound-wrapper> loop --arm-loop --max-laps <small-count>
```

This command starts the wrapper and holds an AC-only system-sleep assertion for its duration. Its
guarantee covers that assertion alone; lid closure, power loss, wrapper exit, and custody remain
separate boundaries. Keep the first trial visible and supervised.

A per-user LaunchAgent is a later hardening step. Apple's archived launchd guide describes
`~/Library/LaunchAgents` as the logged-in user's job domain and recommends on-demand launch over a
continuously running job. It also notes that jobs exiting too quickly may be suspended. That makes
blind `KeepAlive` a poor first move: use a bounded wrapper, backoff, and a failure ceiling before
considering supervision.
([Apple archived guide: Creating launchd jobs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html))

When a later, reviewed LaunchAgent exists, recovery should be simple: request the wrapper's STOP,
use `launchctl bootout` for that exact per-user label, inspect its bounded logs and tree state, then
fix the cause before another bootstrap. LaunchAgent state remains unchanged in this research lap.

## Ready to arm

All boxes must be true at the same reading:

- [ ] Backup current; Tahoe update decision completed under your hand.
- [ ] Standalone `codex` path resolves outside ChatGPT.app; version recorded.
- [ ] Interactive sign-in succeeds; credentials remain outside Grain.
- [ ] Configured defaults read safely; active runtime identity remains separately labeled.
- [ ] Persistent Grain checkout clean; `xy/main` freshly fetched; divergence known and acceptable.
- [ ] No active sibling owns Sound, ITINERARY, or the intended wrapper surfaces.
- [ ] Rishi build product present; Sound prompt renders and has been read whole.
- [ ] Sound-owned Codex wrapper exists with lock, STOP/CUSTODY, ceilings, backoff, signature and
  clean-tree checks, and no push or seed cadence.
- [ ] `ai-jail` dry plan and live write-fence both pass from ordinary Terminal.
- [ ] `check` and `once --dry-run` pass without contacting Codex.
- [ ] Mac on AC; current sleep reading acceptable; first once stays supervised.

## Do not arm

Any one of these closes the gate:

- Codex resolves only to ChatGPT.app, sign-in is unproven, or auth is exposed.
- Rishi is absent, the Sound prompt cannot render, or the prompt came from an unpublished sibling.
- The tree is dirty, behind, beyond its local-ahead ceiling, or another worktree owns a target.
- Jail plan or live fence fails, or the command is already inside another Seatbelt.
- A Sound wrapper is absent, borrows the MIND launcher, uses deprecated `--full-auto`, disables
  rules, auto-pulls, auto-pushes, runs seed cadence, or has unbounded logs, laps, or retries.
- The lap needs gate `%6`, a credential, a release, a power mutation, a lane transfer, or a model
  setting choice.

The present Mac and branch remain **do not arm** for six measured reasons:

- standalone CLI and sign-in are unproven in this task;
- Rishi is absent in this worktree;
- active sibling work exists;
- six local commits are unpushed;
- a Sound-owned Codex supervisor awaits a landed seat; and
- a supervised once inside the real outer jail awaits its first proof.

## Rollback and recovery

1. Stop after the current supervised command. If a wrapper exists, create its STOP marker; send
   `TERM` only to its recorded process when it does not stop between laps.
2. Preserve bounded stdout, stderr, and final-message files. Search them for credentials before
   sharing any excerpt.
3. Read `git status`, the last signed commit, and divergence. Keep reset, clean, rebase, and push
   under direct human review.
4. If a lap left edits before its one coherent signed commit, return custody to a person for
   inspection. Preserve the evidence.
5. Remove only known temporary prompt and probe files after they have served the diagnosis:

```zsh
rm -f /private/tmp/grain-sound.prompt
```

6. If LaunchAgent supervision is added later, unload that exact label before changing its property
   list. Fix the bounded wrapper first; a slower reviewed restart carries more truth than a rapid
   restart storm.

## The shortest honest road from here

Install or update the standalone CLI. Sign in interactively. Restore or build Rishi. Seat a
Sound-owned wrapper that proves the real jail and the contract above. Run its local `check`, then
its dry plan, then one supervised once. Inspect logs, commit, custody, and divergence. Only then run
a small capped trial on AC. A 24/7 service is the final rung, after repeated clean trials and a
reviewed LaunchAgent -- the first hour's prize is a trustworthy stop.

The first hour is successful when every boundary is visible and the loop is still waiting for your
word.
