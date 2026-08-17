# active-designing/ rename mapping — reorg chunk 2 preview

**Branch:** `reorg/one-clock`  **Gate:** preview only — no `git mv` yet

**Count:** 33 tracked files → 2 living + 31 stamped briefs

---

## Living documents (2)

| Old | New | Role |
|-----|-----|------|
| `999_DESIGN.md` | `README.md` | Foundation + reverse-chron index (content updated on apply) |
| `998_strengthening_strategy.md` | `STRATEGY.md` | Standing strengthening charter (`Version: 20260618.085812`) |

---

## Stamp collision (1 pair) — slug disambiguation

Both carry header `Version: 20260618.184912`:

| Old | New | Slug from filename |
|-----|-----|-------------------|
| `996_growing_a_language.md` | `20260618-184912_growing-a-language.md` | `# 996 · … how we grow a language` |
| `997_recommended_architecture.md` | `20260618-184912_recommended-architecture.md` | `# 997 · The Recommended Path for the Core Names` |

---

## Dated briefs (29) — stamp from header **Version**

| Old | New |
|-----|-----|
| `995_single_stranded.md` | `20260618-182412_single-stranded.md` |
| `994_rooted_identity.md` | `20260618-224612_rooted-identity.md` |
| `993_bounded_network.md` | `20260618-224712_bounded-network.md` |
| `992_shape_casting.md` | `20260618-224812_shape-casting.md` |
| `991_aurora.md` | `20260618-225712_aurora.md` |
| `990_correctness_by_construction.md` | `20260619-051212_correctness-by-construction.md` |
| `989_the_faithful_hand.md` | `20260619-051312_the-faithful-hand.md` |
| `988_brushstroke.md` | `20260619-072600_brushstroke.md` |
| `987_the_first_seeds.md` | `20260619-084412_the-first-seeds.md` |
| `986_living_desktop.md` | `20260619-154912_living-desktop.md` |
| `985_native_system_interface.md` | `20260619-160312_native-system-interface.md` |
| `984_caravan_microkernel.md` | `20260619-223712_caravan-microkernel.md` |
| `983_the_whole_system.md` | `20260619-225712_the-whole-system.md` |
| `982_the_forge.md` | `20260620-005112_the-forge.md` |
| `981_the_desktop.md` | `20260620-011412_the-desktop.md` |
| `980_the_editor.md` | `20260620-012012_the-editor.md` |
| `979_comlink_remoting.md` | `20260620-012112_comlink-remoting.md` |
| `978_scribble_lantern_and_lattice.md` | `20260620-020712_scribble-lantern-and-lattice.md` |
| `977_flow_of_values.md` | `20260620-021212_flow-of-values.md` |
| `975_virtio_the_device_wire.md` | `20260620-041412_virtio-the-device-wire.md` |
| `974_harts_parallel_on_one_machine.md` | `20260620-041512_harts-parallel-on-one-machine.md` |
| `973_sealed_datagrams.md` | `20260620-041612_sealed-datagrams.md` |
| `972_who_executor_sealer_opener.md` | `20260620-042612_who-executor-sealer-opener.md` |
| `971_tally_and_who.md` | `20260620-042812_tally-and-who.md` |
| `970_explicit_width_in_rye.md` | `20260621-051312_explicit-width-in-rye.md` |
| `969_bron_notation.md` | `20260621-063912_bron-notation.md` |
| `968_the_compiler_fork.md` | `20260621-070712_the-compiler-fork.md` |
| `967_caravan_kernel_improvements.md` | `20260622-232912_caravan-kernel-improvements.md` |
| `976_what_we_mean_by_seed.md` | `20260622-235012_what-we-mean-by-seed.md` |

All stamps from header `**Version:**` line; none required first-commit derivation.

---

## Redirect stubs (0 within this folder)

Per `999_DESIGN.md` § Redirect stubs: **this stack revises briefs in place** rather than leaving duplicate architecture docs. No within-folder supersession flagged.

**Deferred to chunk 3:** `external-research/992_recommended_architecture.md` → pointer to `active-designing/997` (cross-folder dedup).

---

## On apply

- Rewrite `README.md` header/index for one-clock (retire countdown-convention section).
- Build reverse-chron table of all stamped briefs.
- Update internal markdown links across repo pointing at old `NNN_*.md` paths (grep before commit).
