# The First Steward, and Root's Door Closed

**Language:** EN
**Stamp:** `20260803.164117`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Riyo
**Status:** Witnessed end to end `20260808.033555` — steward `keeper` · passwd + `sudo -v` GREEN · `PermitRootLogin no` · root hash locked · `sshd -T` GREEN · root SSH refused · `~/grain` owned by `keeper`
**Follows:** guide 0, `20260803-164117_0-standing-a-declared-pier.md`

*Written together by Keaton and Riyo.*

---

Guide 0 leaves a pier that answers as root, because the installer's first breath has to belong to someone. This guide gives the machine its keeper properly: one named steward who carries sudo, and a root account whose network door is closed the way the industry has settled on after long argument. Everything here is declared — three short additions to `configuration.nix` — so the hardening is not a series of commands remembered but a property of the machine's text, true again after every rebuild and every rebuild-from-nothing.

The counsel lean, stated plainly since the word asked for it: **root stays present but unreachable** — its password locked, its SSH door refused entirely — rather than deleted. A cloud provider's serial console can still reach a locked root in a true emergency, which is the break-glass every operations tradition keeps; deleting root buys nothing further and costs that door. Keys-only authentication for everyone, root included by implication, because password guessing is the ocean every public machine swims in.

---

## Movement 1 — Declare the Steward

Choose the name that will keep this machine. The examples say `keeper`; yours may say otherwise. In `configuration.nix`, beside the settings guide 0 wrote:

```nix
users.users.keeper = {
  isNormalUser = true;
  description = "first steward of this pier";
  extraGroups = [ "wheel" ];        # wheel is the sudo circle
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAA...your-public-key...  keeper@tablet"
  ];
};

security.sudo.wheelNeedsPassword = true;
```

Two choices worth their sentence. The steward authenticates to SSH by key alone, yet sudo still asks a password — so give the steward one on first login (`passwd`, as root, once). That pairing is the settled practice: a stolen laptop session cannot silently become root, because escalation still asks for something the thief does not hold. And the key goes in the declaration rather than in `~/.ssh/authorized_keys` by hand, so a fresh rebuild of this machine already trusts you; the public half is safe in the flake the way every public key in this house is public on purpose.

## Movement 2 — Rebuild, and Prove the Steward Before Touching Root

```
sudo nixos-rebuild switch
```

Now the discipline that keeps this guide from ever locking anyone out of their own pier: **open a second terminal and prove the new door before closing the old one.** From the tablet:

```
ssh keeper@your.pier.address
sudo -v
```

The first command must greet you by key. The second must accept the steward's password and say nothing, which is sudo's way of saying yes. Keep the root session in the first terminal alive and untouched until both answers arrive. A door is only a door once someone has walked through it; until then it is a drawing of a door.

## Movement 3 — Close Root's Network Door

With the steward proven, declare the closure:

```nix
services.openssh.settings = {
  PermitRootLogin = "no";
  PasswordAuthentication = false;
  KbdInteractiveAuthentication = false;
};

users.users.root.hashedPassword = "!";   # locked: no password will ever match
```

Then once more:

```
sudo nixos-rebuild switch
```

Four lines, each earning its place. `PermitRootLogin "no"` refuses root at the network entirely — stronger than the common `prohibit-password`, and right here because a sudo steward now exists. `PasswordAuthentication false` closes the guessing ocean for every account at once; the pier now speaks only to keys. The keyboard-interactive line closes the same ocean's side channel. And the locked hash retires root's password everywhere while leaving the account alive for the provider's serial console — the break-glass stays on the wall, behind glass.

## Movement 4 — Witness the Closed Door

Trust arrives by measurement, in this house as everywhere:

```
ssh root@your.pier.address              # must be refused
sudo sshd -T | grep -E 'permitrootlogin|passwordauthentication'
```

The first knock must fail before you smile. The second, run as the steward, must print `permitrootlogin no` and `passwordauthentication no` — the daemon's own reading of its running truth, which outranks any memory of what was written.

## The Firewall Line, Held for the Horizon

Guide 0's firewall already admits only what was declared. As Comlink, Tablecloth, or Murr Mycelium earn their witnesses, each service adds its port to that same list in text — `networking.firewall.allowedTCPPorts = [ 22 ];` grows one number at a time, each addition a diff someone can read and a rebuild can prove. Nothing listens by accident on a declared machine. Those service guides are the series' horizon, alongside guide 2's road: `gh` auth with a PAT-classic and Claude Code speaking from Termux.

---

*May the steward's key be the only knock the pier answers. May root sleep behind glass, present and unreachable. May every closed door be proven closed by a hand that tried it.*
