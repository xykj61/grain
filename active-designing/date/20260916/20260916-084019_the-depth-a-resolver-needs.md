# The depth a resolver needs, and who gets to name it

**Stamp:** `20260916.084019` (EDT) - **Status:** Landed - **Room:** checkable -- every figure below is
read by `tools/fixtures/s/shell_portable_control.sh` or reproducible by the command beside it
**Style:** Gauge at Field - **Voice:** Kyri - **Lane:** diffuser (moonshots and research)
**Closes:** REDS `%762` - **Touches:** [`tools/fixtures/s/shell_portable.sh`](../tools/fixtures/s/shell_portable.sh) - [`tools/fixtures/a/aurora_placement_scan.sh`](../tools/fixtures/a/aurora_placement_scan.sh)

## The sentence that stopped a repair for a day

`resolve_path` is this tree's portable answer to `readlink -f`. It followed exactly one symlink hop,
and its own header said why a loop was declined:

> A full resolver has to bound its own recursion or hang on a symlink cycle, and bounding it means
> naming a maximum depth nobody here can justify from measurement.

That reasoning is sound and its premise was untested. Nobody had measured. Three readings taken on
this pier on `20260916` name the number between them, and this page is those three readings and what
follows from each.

## Reading 1 -- the tree's own population

**Scope:** every symlink in this working tree with `.git` pruned, chains walked to their fixed point.
**Method, free to re-run:**

```sh
find . -path ./.git -prune -o -type l -print | while IFS= read -r p; do
  d=0; cur=$p
  while [ -L "$cur" ] && [ $d -lt 64 ]; do
    hop=$(readlink "$cur")
    case "$hop" in /*) cur=$hop ;; *) cur=$(dirname "$cur")/$hop ;; esac
    d=$((d + 1))
  done
  printf '%s\n' "$d"
done | sort -n | uniq -c
```

| Chain depth | Links | Share |
|---|---|---|
| 1 hop | 793 | 95.1% |
| 2 hops | 40 | 4.8% |
| 3 hops | 1 | 0.1% |
| **Total** | **834** | |

The single deepest chain is `pond/apps/granary/parse_int.rye`, three hops to `tally/parse_int.rye`.
Restricting to the 285 tracked symlinks gives the same shape: 276, 8, and 1.

**Observation:** the deepest chain this tree has ever filed is 3. **Inference:** one hop suffices for 793 of
834 links and falls short on the remaining 41, which is 4.9% of them. **This figure is FREE** -- the tree grows, and a
lap filing a fourth-order link moves it. Run the command rather than trusting the table.

## Reading 2 -- the host's own limit

**Scope:** this pier's kernel, probed with a built chain and an ordinary `cat`.

| Chain | Kernel path resolution |
|---|---|
| 40 hops | opens |
| 41 hops | refuses, `ELOOP` |

That is POSIX `SYMLOOP_MAX` at 40. **Inference:** a chain longer than 40 names a path this machine
declines to open, read, or execute, so resolving one hands a caller a path it cannot then use.
**This figure is PINNED** to the kernel's constant; a different kernel is a different reading, and
the probe travels in the control.

## Reading 3 -- the elder tool does not honor it

**Scope:** GNU coreutils `readlink -f` on the same built chains.

| Chain | `readlink -f` |
|---|---|
| 60 hops | resolves |
| 200 hops | resolves |
| 2-link cycle | refuses |

**Observation:** `readlink -f` walks the chain in userspace and continues past the depth where the
kernel stops. **Inference:** the elder spelling is the liberal one. It answers confidently about
paths the machine declines to serve, and a caller that trusts the answer meets `ELOOP` one line
later.

## What the three readings decide

**40 hops**, which is the depth the host itself enforces and thirteen times the deepest chain the
tree holds. The bound is borrowed rather than invented, which is the whole of the argument: a
resolver that refuses exactly where the operating system refuses adds no new refusal to reason
about. A cycle spends the budget and reports, instead of hanging.

The elder header asked for a depth justifiable from measurement. Two measurements bracket it -- 3
from below, 40 from above -- and the gap between them is the margin.

## The fourth reading, which arrived uninvited

Making the walk multi-hop surfaced a dialect fault that one hop had hidden. A relative hop produces
a target like `pond/apps/rishi/../../tally/parse_int.rye`, and `pond/apps/rishi` is itself a link.
Resolving that path:

| Shell | `cd "$dir" && pwd -P` | `cd -P "$dir" && pwd -P` |
|---|---|---|
| bash | `/home/.../tally` | `/home/.../tally` |
| dash (`sh` here) | **refuses** | `/home/.../tally` |

A bare `cd` is *logical*: it collapses `..` textually before resolving symlinks, so `a/link/../../b`
names a directory other than the one the link stands in. The two shells disagree about whether that is an error.
Every guard in this tree runs under `sh`, and every interactive check of one runs under `bash` --
so this fault reads healthy in exactly the place a person would look for it. `cd -P` resolves each
component physically, which is what `readlink -f` does and what a caller asking for a real path
means.

**Observation:** the cost of the bare `cd` was one silently dropped edge in
`aurora_placement_scan.sh` -- `room_edges` 225 against a true 226-1, `top_pair pond -> tally` at 14
where the tree holds 15. **Inference:** a resolver returning empty on a legal path is the failure
mode a counting guard cannot see, because an empty answer and an absent edge are the same reading.

## The falsifier

**This page is wrong if a symlink chain in this tree, or in a tree a guard runs over, exceeds 40
hops while remaining openable.** That would mean the kernel bound is not 40 on the host in question,
and the measurement to take is the `cat` probe of Reading 2 on that host. A chain between 4 and 40
falsifies nothing here -- the margin exists for exactly that -- and a chain past 40 that the kernel
also refuses confirms the choice rather than upsetting it.

**Second falsifier, cheaper:** if `cd -P` and `cd` are found to agree on every shell a guard here
runs under, Reading 4's repair is unnecessary. The probe is three lines and sits in the table above.

**Horizon:** until this tree runs a guard on a host whose `SYMLOOP_MAX` differs from 40, or files a
symlink chain deeper than 3. **Confidence:** high for Readings 1, 2, and 4, each of which is a direct
measurement reproducible by the command printed beside it; high for Reading 3, which is a property of
the coreutils implementation rather than of this bench.

## What this does not reach

**Whether `resolve_path` is correct about anything else.** These readings settle its depth. Its
handling of a last component that has yet to exist, a relative input, and a path carrying a space
stands proven already, by the same control.

**The seven remaining `readlink -f` sites.** Five are in the helper's own control, calling the elder
spelling on purpose to compare against it; one is host-bound in `agent-jail.sh` by the Pond quest's
boundary; one is host-bound in `pier_nixos_track.sh`, which addresses `/etc/nixos` alone.
Two is the honest floor for this family today.

**Whether a shared helper should carry the walk at all.** `aurora_placement_scan.sh` spells it inline
because its control plants mutations by copying the scan into a pen, so the git root and a walk
up from `$0` both land inside that pen, leaving the helper out of reach. A control that mutates by copying forbids its
subject from sourcing -- a constraint on the mutation style rather than on either file, and one
worth a lap of its own.
