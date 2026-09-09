# The declared host config -- the tree writes, the machine copies

**Seated:** `20260909.004815` on Keaton's word - **Status:** Living
**Kin:** [`docs-implementation-sync`](docs-implementation-sync.md) - [`reds-first`](reds-first.md) - [`checkpoint`](checkpoint.md)
**Foundation:** [`../../foundations/20260909-004934_the-machine-you-can-write-down.md`](../../foundations/20260909-004934_the-machine-you-can-write-down.md)

**The host's configuration is authored in this tree and copied out to the machine. It is never
authored on the machine.** `nixos/` holds the source; `/etc/nixos/` holds a copy.

## The order, every time

1. **Edit `nixos/`** in the tree, where the change is reviewed, committed, and travels to every
   clone.
2. **Copy the tree's file out** to `/etc/nixos/`, then rebuild.
3. **Prove it on metal** -- the rebuild succeeds and the thing you changed answers for itself.

```sh
sudo cp nixos/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

## Why the direction matters, learned the same night the rule was written

On `20260909` a Codex CLI bump ran the other way: `/etc/nixos/configuration.nix` was edited with
`sed`, rebuilt, and the tree was reconciled afterward. It worked, and the reconciliation surfaced
exactly the hazard the direction creates -- **the tree carried eleven lines the live file lacked**,
a seated decision about a package pin recorded in the tree and never copied out. A plain copy of
live over tree would have deleted a recorded decision.

Reconciling backwards means every sync asks *which side is right per line*, and that question has
no mechanical answer. Writing the tree first means the machine is a copy, and a copy needs no
adjudication: it is stale or current, and `diff` says which.

**Two more properties follow, and both are the point of a declared host.** A change reviewed in the
tree is a change with a commit message, an author, and a diff other clones receive. A machine
rebuilt from that file is a machine anybody can stand up again -- including a future you, on new
hardware, with the original gone.

## What holds until

**This rule stands until Mantra, Caravan and Rishi run fully on Microkit seL4 for RISC-V.** That is
the horizon where this tree stops borrowing a host and becomes one, and the question of who authors
the host's configuration is answered by the tree being the system. Until that day the borrowed host
is described here and copied there.

## The seed carries it

`nixos/` ships in the public seed, so the declared pier a newcomer stands up is the same one this
tree runs. A guide describing a host whose configuration nobody can read is a guide asking for
trust; shipping the file asks for nothing.

**Measured `20260909.013400`, the room does not ship yet.** `template-manifest.bron` carries the
reclassification in its intent half -- `template nixos`, *RECLASSIFIED `20260909` on Keaton's word,
personal -> template* -- and that file's own header says `allow` alone drives the projection. No
`allow nixos` line was written, so the room stays withheld by the root default, and `SOURCE.md`
linking into it reddened `tools/s/seed_link_witness.rish` within the hour, its ratchet rising 848
to 849. The link was repaired the honest way -- the seed reader is pointed at
`nixos-guide/templates/configuration.nix.example`, which does ship.

**And writing that line today would refuse the publish, which is the wall doing its job.** Every
allowed path is scrubbed -- `tools/fixtures/s/sow_project.sh` builds its path list from `allow`
alone and runs `tools/fixtures/s/sow_scrub.sed` over all of it -- so the question is what survives
the scrub rather than which intent word the room carries. Run over `nixos/` and grepped for the
leak scan's own IDENT set, the output is clean of `Keaton`, `keaton`, `Livermore`, `xykj61` and the
gmail address, and carries **`vultr` on two lines**: the hosting provider named inside an
authorized-key comment. `tools/fixtures/s/sow_leak_scan.sh` greps `-riIlE` with `Vultr` in that
set, so it would answer `IDENT_LEAK` and stop the publish.

So the order is what is missing rather than the decision. Drop or scrub that provider word, then
write `allow nixos` -- **Keaton's word to give**, since an `allow` line moves a privacy boundary and
the publish is custody gate `%1`.

## What this leaves alone

**Secrets and per-machine identity stay off the tree.** Keys, tokens, and anything naming one
person's hardware live on the machine, and the tree's copy carries a placeholder. `nixos/` is the
shape of a host rather than the identity of one.

**A rescue is a rescue.** Editing `/etc/nixos` directly to bring a machine back from an unbootable
state is correct; the tree receives that edit as soon as the machine boots.

Canonical Cursor twin: [`../../.cursor/rules/declared-host-config.mdc`](../../.cursor/rules/declared-host-config.mdc).
