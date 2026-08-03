# Standing a Declared Pier

**Language:** EN
**Last updated:** 2026-08-03
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Voice:** Riyo
**Status:** Living — witnessed once, end to end, on a Seattle instance; reached and driven from a Daylight DC-1 tablet via Termux, Cursor CLI signed in (Keaton, 20260803)
**Home:** `nixos-guide/` — seated by Keaton's word, guide 0 of the series
**Gratitude:** first drafted whole by a sibling counsel session; reworked here with thanks

---

A pier is a small public machine that belongs entirely to its keeper: declared in a handful of files, reachable from anywhere, and rebuildable in minutes because its whole character lives in text rather than in the accumulated history of a disk. This guide stands one such pier from a tablet alone — no laptop within reach, no desk, no second machine. A terminal in one hand, a browser in the other, and a road walked in ten movements.

The finished machine runs NixOS from a flake of about sixty lines, answers over both IPv4 and IPv6, greets a roaming terminal through a session that survives sleep, and carries an agent that keeps thinking while the tablet rests. The whole road takes something near an hour, and the metered cost of the instance while it is walked comes to roughly forty cents.

---

## The Shape of the Road

The pier arrives in three chapters, and seeing them whole makes each command obvious.

First we prepare the hands: a key born on the tablet, a public half carried to the cloud account, and a terminal taught to hold the passphrase once rather than at every knock.

Then we raise a springboard. The cloud panel offers Ubuntu, so we take a well-witnessed release and use it for exactly one purpose: to fetch a NixOS installer that runs entirely from memory and to leap into it. The springboard's own filesystem never matters, because the disk beneath it is about to be shaped fresh.

Finally, from inside that memory-held installer, we declare the machine we actually want, partition the disk to match, and write the whole system down. The pier reboots into its own name, and everything we asked for — the firewall lane, the packages, the keys — arrives already true, because the flake said so before the system ever booted.

---

## Movement 1 — The Key at Home

The key is born on the tablet and stays there. Only its public half ever travels.

```
pkg install openssh
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_dc1 -C "keaton@dc1"
ssh-keygen -lf ~/.ssh/id_ed25519_dc1.pub
```

The ed25519 family gives short keys with strong guarantees; the hundred rounds harden the passphrase that protects the private half; the comment names which hand holds it, which matters the day three keys share one server.

That third line prints the fingerprint — a short witness, safe to send through any channel, useful later for confirming the right key landed. The cloud panel, however, asks for the key itself:

```
cat ~/.ssh/id_ed25519_dc1.pub
```

One line beginning `ssh-ed25519 AAAA…` and ending with the comment. That line is what gets pasted into the account, under SSH Keys, where every future instance can draw from it.

---

## Movement 2 — The Instance

The deploy form asks a dozen questions, and for this mission most of them want the quiet answer. A shared-CPU plan with two cores and four gigabytes of memory clears every floor the install asks for, with headroom. The operating system is Ubuntu at a mature long-term release — the springboard's only task is to hold still for a single leap, so an elder release beats a fresh one. Select every SSH key that should reach the machine.

Startup Script stays empty and Firewall Group stays unselected, and this pair deserves a sentence. With no firewall group attached, the provider places no filter in front of the instance, which leaves the SSH port open for the install and the roaming-terminal lane open afterward. The guard returns later as configuration you can read, declared in the flake, brought up by the new system itself.

Public IPv4 carries the road; IPv6 is free and worth taking when the work wants a real dual-stack endpoint. Private networking, automatic backups, attack protection, the limited-user option, and first-boot automation all stay off. A machine whose entire shape lives in a flake in version control keeps its own backup by definition, and the rest belongs to other missions.

The hostname field can rest empty, since it dies at the wipe and the flake declares the lasting name. The label, however, is panel-side metadata that survives every operating-system change, so a clear label is ten seconds well spent.

---

## Movement 3 — First Knock, and the Agent That Remembers

Two small pieces of configuration on the tablet turn every later knock into silence. First, names for the pier, in `~/.ssh/config`:

```
Host pier
    HostName <instance-ip>
    User root
    IdentityFile ~/.ssh/id_ed25519_dc1
    IdentitiesOnly yes
    AddKeysToAgent yes

Host pier6
    HostName <instance-ipv6>
    User root
    IdentityFile ~/.ssh/id_ed25519_dc1
    IdentitiesOnly yes
    AddKeysToAgent yes
```

Then an agent that lives for the whole run of the terminal app, appended to `~/.bashrc`:

```
# one ssh-agent per Termux run, shared by every session
export SSH_AUTH_SOCK=$PREFIX/var/run/ssh-agent.sock
ssh-add -l >/dev/null 2>&1
if [ $? -eq 2 ]; then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" >/dev/null
fi
```

The shape is deliberate: every session exports one fixed socket, asks the agent whether it lives, and starts a new one only when the answer is truly *unreachable* — exit code two, captured before anything else touches it. An agent already running with an empty keyring answers one and is left in peace.

Seat it, then speak the passphrase once for the whole run:

```
source ~/.bashrc
ssh-add ~/.ssh/id_ed25519_dc1
ssh-add -l
```

That last line should print the same fingerprint Movement 1 recorded. Then the first knock:

```
ssh pier
```

A note for the roaming terminal, should you want it on the springboard as well: this provider's Ubuntu images commonly ship with the host firewall already awake, allowing only the SSH port, so a roaming session there wants `ufw allow 60000:61000/udp` first. The leaner road skips that entirely, because the guard that truly matters arrives in Movement 5, and the roaming terminal comes home to the finished pier in Movement 10.

---

## Movement 4 — The Leap

The installer we want runs from memory and touches no disk, which is exactly why it can shape the disk beneath it. Three commands on the springboard:

```
curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz -o /root/kexec.tar.gz
tar -xzf /root/kexec.tar.gz -C /root
/root/kexec/run
```

The last one replaces the running kernel with the installer's, carrying the network settings and the authorized keys across on its own.

Expect one small illusion here. The old kernel vanishes mid-flight without sending a farewell, so the terminal keeps holding a socket with no one on the other end — a prompt that looks alive and is a ghost. Close it deliberately with **Enter**, then **`~`**, then **`.`**, wait a minute, and knock again. The host key is newborn, so retire the old one first:

```
ssh-keygen -R <instance-ip>
ssh pier
hostname
```

The prompt will claim to be the installer; ask the machine anyway. `nixos-installer` in that answer means the leap landed, and the disk below is untouched and waiting.

---

## Movement 5 — The Guard

Before any work at all, raise a session that outlives the connection. A tablet sleeps, a network roams, and a long install has no business dying for either.

```
NIX_CONFIG="experimental-features = nix-command flakes" nix shell nixpkgs#tmux --command tmux new -A -s install
```

Everything from here lives inside that guard. Should the connection drop at any point, this returns you to the living run:

```
ssh pier
nix shell nixpkgs#tmux --command tmux attach -t install
```

One habit belongs beside the guard, and it saves more time than it costs: **one command per paste**. A command that asks a question will read whatever follows it as the answer, so a witness pasted below a prompt becomes a silent abort. Send one line, read what it says, then send the next.

---

## Movement 6 — The Three Files

Here the machine gets described. Three files, written once, and then the directory is left alone — a point Movement 7 explains.

```
mkdir -p /root/pier && cd /root/pier

cat > flake.nix << 'EOF'
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations.pier = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./disk-config.nix
        ./configuration.nix
      ];
    };
  };
}
EOF
```

The disk layout aims at the virtio device these instances present, and it carries seats for both firmware styles — a one-megabyte partition for legacy boot beside a five-hundred-megabyte EFI partition — so the same file boots whichever firmware the host offers:

```
cat > disk-config.nix << 'EOF'
{
  disko.devices.disk.main = {
    device = "/dev/vda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = { size = "1M"; type = "EF02"; };
        esp = {
          size = "512M"; type = "EF00";
          content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
        };
        root = {
          size = "100%";
          content = { type = "filesystem"; format = "ext4"; mountpoint = "/"; };
        };
      };
    };
  };
}
EOF
```

Then the character of the machine itself:

```
cat > configuration.nix << 'EOF'
{ modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "pier";
  networking.useDHCP = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  users.users.root.openssh.authorizedKeys.keys = [
    "<every public key line that should reach this machine>"
  ];

  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [ tmux git cursor-cli ];

  system.stateVersion = "26.05";
}
EOF
```

Four lines in that file carry more weight than their length suggests. The guest profile brings the host's virtio disk drivers into the early boot image, so the new system can find its own root filesystem on the first try. The two bootloader lines seat both handoffs. The authorized-keys list is the door itself, and the law behind it is absolute: **the wipe keeps only what the flake declares**, so every key that should still work tomorrow belongs in that list today. And the roaming-terminal line opens its own lane in the new system's firewall, so the guard and the door arrive in the same breath.

---

## Movement 7 — Partition and Mount

One command shapes the disk and mounts it where the installer expects:

```
NIX_CONFIG="experimental-features = nix-command flakes" nix run 'github:nix-community/disko/latest' -- --mode destroy,format,mount --yes-wipe-all-disks --flake .#pier
```

Then ask the disk, rather than the log:

```
findmnt -R /mnt
```

The answer should show the root partition mounted at `/mnt` as ext4 with the EFI partition at `/mnt/boot` as vfat. That witness, and only that witness, means the ground is ready.

One line follows, and it earns its own paragraph:

```
rm -rf /root/.cache/nix
```

The command above wrote a lock file into `/root/pier`, and a flake directory's contents are part of its identity — so the hash remembered from the moment *before* the lock existed no longer matches the directory that now holds it. Clearing that memory lets the next command read the flake as it truly is. This single line replaces a whole evening of confusion, and it costs nothing.

---

## Movement 8 — Room to Build

The installer lives in memory, and so does its package store until the disk is mounted. Give the build real room before asking it to work. First reclaim whatever the fetching has already consumed:

```
nix-collect-garbage -d
free -h
```

Then seat swap on the disk that now has a hundred gigabytes to spare:

```
dd if=/dev/zero of=/mnt/.swap bs=1M count=4096 status=progress
chmod 600 /mnt/.swap
mkswap /mnt/.swap
swapon /mnt/.swap
free -h
```

Four gigabytes of memory with four of swap beside it turns a wall into a corridor. The `free` witness confirms it plainly.

---

## Movement 9 — The Install, and the Law of the Witnessed Zero

Point the build's scratch space at the real disk, so every byte it fetches lands on the platter rather than in memory:

```
mkdir -p /mnt/tmp
```

```
TMPDIR=/mnt/tmp NIX_CONFIG="experimental-features = nix-command flakes" nixos-install --flake /root/pier#pier --no-root-passwd
```

It narrates for several minutes, and the closing lines are the ones to read: the boot loader installed for both platforms, then *installation finished*. Then the law:

```
echo "status=$?"
```

**Reboot only on a witnessed zero.** A prompt that has returned proves nothing; the status proves everything, and it must be captured before any other command touches it. With the zero in hand, lift the scaffolding and go:

```
swapoff /mnt/.swap && rm /mnt/.swap
```

```
reboot
```

---

## Movement 10 — The Pier Answers

The host key is reborn one last time, so retire the old one and knock:

```
ssh-keygen -R <instance-ip>
ssh pier
nixos-version
```

The version line should name the release the flake requested. Then the homecoming, on a desk that survives every sleep and every roam:

```
mosh pier -- tmux new -A -s pier
```

The roaming terminal works from the very first minute, because the flake opened its lane before the system ever booted. Inside that session, the agent wakes:

```
cursor-agent login
cursor-agent
```

The login prints a URL to open in the tablet's browser. From then on the agent thinks on the pier while the tablet rests, and any terminal that reaches the same session finds the work exactly where it was left.

Two accretions close the road well. The three files belong in version control, because with them in hand a rebuild is minutes rather than an evening. And the tablet's new fingerprint earns its line in the canonical key record, so the file and the keys out in the world stay in agreement.

---

## The Laws This Road Taught

Ten movements, and beneath them a handful of disciplines that generalize far past this one machine.

**Measurement beats memory.** A prompt can lie, a log can mislead, and the machine always tells the truth when asked directly. `hostname` after the leap, `findmnt` after the partitioning, `free` after the swap, `ssh-add -l` after the agent: each witness costs a second and settles a question that guessing would leave open for an hour.

**Capture the status before anything else touches it.** `echo $?` is the cheapest correctness check available, and it belongs immediately after any command whose success gates the next step.

**Raise the guard before the work.** A session that outlives its connection turns a sleeping tablet from a catastrophe into a pause.

**One command per paste.** A question consumes whatever follows it, so a witness sent too early becomes an answer nobody meant to give.

**Declare what must survive.** Keys, network, firewall lanes, packages: anything that should be true after the wipe belongs in the configuration, never only on the disk.

**Prefer fresh ground to inherited ground.** Shaping a disk from a declared layout carries no assumptions forward. Converting a system in place inherits every identifier the old system wrote down, and a single stale reference can leave a machine waiting on a device that will never appear.

**Keep an out-of-band eye.** The provider's console window shows the machine's actual screen with no network involved, which turns every dark moment from a guess into a plain reading.

**Nothing precious aboard means every branch ends well.** A machine whose whole character lives in three files can be wiped and rebuilt without hesitation, so the honest response to a deep failure is often the rebuild rather than the surgery — minutes rather than an evening, and the flake makes that trade sound.

---

## Gratitude

This road rests on work generously given by others: the NixOS project and its package collection, whose declarative model makes a machine describable in text at all; the disko project, for turning a disk layout into something a flake can state; the nixos-images work, for an installer that runs from memory and asks nothing of the disk it is about to shape; the terminal, roaming-shell, and session-multiplexer projects that let a tablet hold a real desk; and the hosting provider whose console window and one-click reinstall made every dark moment cheap to read and cheap to leave.

---

*May the guard hold through every sleep. May each witness answer plainly on the first ask. May the pier stand steady through many seasons, described so faithfully that rebuilding it is never a worry.*
