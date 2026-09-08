# Sound Chapter -- breach instrument shelf

**Language:** EN  
**Stamp:** `20260727.221508`  
**Status:** Checkable -- round 0 raised `link_witness` ROUND MODE as the Sound breach instrument  
**Where this sits:** home is [`../../../README.md`](../../../README.md) - a first hour in your hands is
[`../../../docs-geode/tutorials/the-first-hour.md`](../../../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../../SOURCE.md`](../../../SOURCE.md)
**Chapter:** [`../../../counsel/date/20260727/20260727-220947_the-sound-season-and-the-seated-breach.md`](../../../counsel/date/20260727/20260727-220947_the-sound-season-and-the-seated-breach.md)

---

## Instrument

**`tools/l/link_witness.rish`** proves three things: the fixtures stay toothful, the tree baseline is allowed, and the ROUND MODE self-check holds -- equal GREEN, deliberate break RED, `ALLOW_BASELINE` ignored in compare.

Per-motion protocol (six promises, promise 4):

```sh
# before first git mv / reference turn
mkdir -p session-output
LINK_WITNESS_SNAPSHOT=session-output/sound-breach-before.txt \
  sh tools/fixtures/l/link_witness_scan.sh

# ... yonder + re-point inside declared scope ...

# after -- must GREEN (no new missing targets)
LINK_WITNESS_COMPARE=session-output/sound-breach-before.txt \
  sh tools/fixtures/l/link_witness_scan.sh
```

A snapshot belongs on the bench, in this checkout's own untracked window `session-output/`. Eight
ships share one TMPDIR, so a constant name under `/tmp` is one file for all of them, and a compare
taken there reads a peer's tree as this one (REDS %549). The shelf itself holds the protocol and
leaves the dumps on the bench, since paths in the snapshot format are absolute today.

## Red / green plan

| Side | Expectation |
|------|-------------|
| **Red (before a bad motion)** | Introducing a newly missing destination fails COMPARE even when `LINK_WITNESS_ALLOW_BASELINE=1` |
| **Green (after a good motion)** | AFTER missing-targets is a subset of BEFORE; relocated dangling *keys* may advise, while new missing *targets* stay absent |
| **Baseline debt** | Tree may carry historical dangling under allow; ROUND MODE forbids *new* missing targets only |

Two companion homes share this path-family. `gen_home_witness.rish` covers desk-home breaches, and this instrument covers markdown relative-link completeness across any yonder or re-point.

## Round 0 measured (this stamp)

| Fact | Value |
|------|------:|
| relative_links_checked | 7979 |
| dangling keys (baseline) | 2381 |
| missing targets (baseline) | 1991 |
| ROUND MODE self-check | GREEN |
| COMPARE vs fresh snapshot | GREEN (0 added targets) |

---

*May every yonder take its snapshot first, and every re-point leave no new missing home.*
