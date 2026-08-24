# GitHub's Handshake, and a Pier That Thinks

**Language:** EN
**Stamp:** `20260803.165931`
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Riyo
**Status:** Witnessed end to end `20260808.040720` -- `gh` as `xykj61` - Claude Code on pier (`claude.ai` - ping GREEN) - standing tmux session `pier` holds the long thought
**Follows:** guide 1, `20260803-164117_1-first-steward-and-root-hardening.md`

*Written together by Keaton and Riyo.*

---

Guide 1 left a hardened pier with one proven steward. This guide gives that steward two working hands: a GitHub identity that can clone and push the house's own repos, and Claude Code living on the pier itself -- reachable from the tablet, thinking after the tablet sleeps. One honest architectural sentence up front, learned from the official platform list rather than assumed: the agent's npm road ships native binaries for every Linux and none for Android, so the DC-1's Termux stays what guide 0 made it -- the window -- while the agent's feet stand on the pier's `linux-x64`, where it is first-class. That division was already the series' promise; the platform list simply agrees with it.

---

## Movement 1 -- Declare the Tools

Both hands arrive the declared way, in `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  gh        # GitHub's own CLI
  tmux      # the standing session, if guide 0's roaming shell is not already declared
];
```

Then `sudo nixos-rebuild switch`, and the machine knows `gh` forever after, on this build and every rebuild from nothing.

## Movement 2 -- Mint the Token, Lean and Classic

On the tablet's browser: GitHub -> Settings -> Developer settings -> Personal access tokens -> **Tokens (classic)** -> Generate new. Give it a name that says whose hand it is (`pier-keeper`), an expiry you will actually revisit, and the leanest scopes that do the work: **`repo`** for cloning and pushing the house's repositories, and `read:org` only if an organization's private repos need reading. Every scope left unchecked is a door that never needs watching.

The token is a secret and stays in Keaton's hands alone -- spoken once to the pier in the next movement, held nowhere else, never written into any file this tree carries.

## Movement 3 -- The Handshake

As the steward, on the pier:

```
gh auth login --hostname github.com --with-token
```

Paste the token at the silent prompt and press enter, then ctrl-d. Then let `gh` teach git to use it:

```
gh auth setup-git
```

And witness the hand before trusting it:

```
gh auth status
gh repo view autoproject96/grain --json name
git ls-remote https://github.com/autoproject96/grain.git HEAD
```

The first must greet the account by name and show the scopes you minted -- read what it prints, because the daemon's word outranks memory here as everywhere. The second and third must answer without asking for anything, which is the whole point of the handshake.

## Movement 4 -- The Agent Takes Its Seat

Ask NixOS what it already carries, then declare what it answers:

```
nix search nixpkgs claude-code
```

When the package stands in nixpkgs -- the expected case -- add `claude-code` to the same `systemPackages` list and rebuild; the declared road stays unbroken. If your channel lacks it, the npm road is the honest fallback on this fully supported platform: declare `nodejs_22` (the package's floor is Node 22), set `npm_config_prefix=$HOME/.npm-global` in the steward's environment, and `npm install -g @anthropic-ai/claude-code`, adding `~/.npm-global/bin` to the path.

Sign in from where you are: run `claude` inside a repo on the pier; on a headless machine it offers a sign-in address -- open it in the tablet's browser, approve, and return. Then the witnesses:

```
claude --version
claude doctor
```

## Movement 5 -- Thinking While the Tablet Rests

The agent earns its keep inside guide 0's standing session:

```
tmux new -s counsel
cd ~/grain && claude
```

Detach, close the tablet, walk away. The session -- and the agent's long thought inside it -- survives the sleep that ends ordinary shells; `tmux attach -t counsel` from the next knock resumes mid-sentence. This is the pier keeping guide 0's original promise with a mind inside it.

## Held for the Horizon

The service lanes -- one honest firewall port per hosted craft as Comlink, Tablecloth, and Murr Mycelium each earn their witness -- remain the series' next guides, and each will follow this same shape: declare, rebuild, witness, and only then trust.

---

*May the token stay lean and the hand it names stay steady. May the agent think longest exactly when the tablet rests. May every road in this series end, as it began, in a witness.*
