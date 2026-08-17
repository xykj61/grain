# external-research/ rename mapping — reorg chunk 3 preview

**Branch:** `reorg/one-clock`  **Gate:** preview only — no `git mv` yet

**Count:** 37 files → 1 `README.md` + 30 stamped explorations + 3 stub renames + 3 living-status (pending ruling)

---

## Foundation (1)

| Old | New |
|-----|-----|
| `999_RESEARCH.md` | `README.md` |

No `STRATEGY.md` — anchor-plus-dated-notes folder.

---

## Living-status review — **pending Kaeden ruling**

| Old | Header | Recommended path | Notes |
|-----|--------|------------------|-------|
| `996_TAME_STYLE.md` | `**Status:** Living` — coding style canon | **Promote → `context/TAME_STYLE.md`** | `context/TAME_STYLE.md` today is the *operational supplement* pointing at 996; promotion needs a merge plan (voiced canon + supplement, or replace). Update `context/specs/tame-style.md` redirect. |
| `997_SYSTEM.md` | `**Status:** Gratitude` — honors essay | **Lean: stamp** `20260620-014412_system.md` | Alternative: living gratitude home under `context/` (not folder charter). |
| `991_useful_utilities.md` | `**Status:** Living roadmap` | **Lean: stamp** `20260617-201612_useful-utilities.md` | Alternative: keep living with plain name if still actively edited. |

Nothing in this trio moves until ruled.

---

## Redirect stubs (3) — rename only, bodies unchanged

Already deprecation redirects; cross-folder `992` duplicate already collapsed.

| Old | New | Slug source |
|-----|-----|-------------|
| `988_rishi_shell.md` | `20260621-051612_rishi-shell-redirect.md` | `# 988 · Rishi — Redirect` |
| `990_shell_scripting_tame.md` | `20260621-051612_shell-scripting-tame-redirect.md` | `# 990 · Shells Through the TAME Lens — Redirect` |
| `992_recommended_architecture.md` | `20260621-051612_recommended-architecture-redirect.md` | `# 992 · The Recommended Path — Redirect` |

### Stub stamp judgment — **needs confirm**

| File | First-add (`git log -A`) | Stub moment (`999_RESEARCH`, `Status: Deprecated (051612)`) |
|------|--------------------------|---------------------------------------------------------------|
| `988_rishi_shell.md` | `20260618-161515` | `20260621-051612` |
| `990_shell_scripting_tame.md` | `20260618-151840` | `20260621-051612` |
| `992_recommended_architecture.md` | `20260618-003359` | `20260621-051612` |

First-add is when each file entered as a full exploration; `051612` is when they became redirect stubs (recorded in `999_RESEARCH`). **Proposed:** use **`20260621-051612`** as the honest stub-event stamp (per naming-law “when it was written” for this artifact’s current form), with distinct `-redirect` slugs for the shared second. Confirm over first-add.

---

## Dated explorations (30) — stamp from header `**Version:**`

No stamp collisions (the `968` number pair resolves: `050312` vs `063112`).

| Old | New |
|-----|-----|
| `998_MANTRA.md` | `20260617-195312_mantra.md` |
| `995_ownerboot_riscv_caravan.md` | `20260617-195612_ownerboot-riscv-caravan.md` |
| `994_caravan_tally_networking.md` | `20260617-195712_caravan-tally-networking.md` |
| `993_aurora_boot_riscv.md` | `20260617-195812_aurora-boot-riscv.md` |
| `989_voices_of_an_os.md` | `20260618-150112_voices-of-an-os.md` |
| `987_pond_foundation.md` | `20260618-180812_pond-foundation.md` |
| `986_decided_design_aurora_mantra.md` | `20260618-190312_decided-design-aurora-mantra.md` |
| `985_encrypted_networking_riscv.md` | `20260618-195512_encrypted-networking-riscv.md` |
| `984_devotional_social_layer.md` | `20260618-195612_devotional-social-layer.md` |
| `983_borrow_checking_and_correctness.md` | `20260618-204012_borrow-checking-and-correctness.md` |
| `982_content_centric_messaging.md` | `20260618-212112_content-centric-messaging.md` |
| `981_unified_keys_and_address_space.md` | `20260619-035912_unified-keys-and-address-space.md` |
| `980_brushstroke_and_the_docs_surface.md` | `20260619-070612_brushstroke-and-the-docs-surface.md` |
| `979_where_building_met_design.md` | `20260619-153212_where-building-met-design.md` |
| `978_stack_toward_a_living_desktop.md` | `20260619-153612_stack-toward-a-living-desktop.md` |
| `977_posix_and_tame_style.md` | `20260619-155612_posix-and-tame-style.md` |
| `976_microkernel_vs_monolith_for_caravan.md` | `20260619-171112_microkernel-vs-monolith-for-caravan.md` |
| `975_tablecloth_tame_datastore.md` | `20260619-220012_tablecloth-tame-datastore.md` |
| `974_s6_sixos_nix_infuse.md` | `20260619-225212_s6-sixos-nix-infuse.md` |
| `973_mantra_forge_and_group_projects.md` | `20260620-001412_mantra-forge-and-group-projects.md` |
| `972_wayland_compositor_tame.md` | `20260620-010412_wayland-compositor-tame.md` |
| `971_editors_remoting_tame.md` | `20260620-010712_editors-remoting-tame.md` |
| `970_formats_editors_inference_and_tensors.md` | `20260620-020712_formats-editors-inference-and-tensors.md` |
| `969_dual_editors_and_priorities.md` | `20260620-040112_dual-editors-and-priorities.md` |
| `968_usize_boundary_not_design.md` | `20260621-050312_usize-boundary-not-design.md` |
| `967_literal_usize_ban_language_fork.md` | `20260621-051312_literal-usize-ban-language-fork.md` |
| `968_prompt_caching_zon_brix.md` | `20260621-063112_prompt-caching-zon-brix.md` |
| `966_brix_vs_bron.md` | `20260621-064612_brix-vs-bron.md` |
| `965_rye_compiler_fork.md` | `20260621-070712_rye-compiler-fork.md` |
| `964_sel4_redox_through_tame_rye.md` | `20260622-232912_sel4-redox-through-tame-rye.md` |

---

## On apply

- Build `external-research/README.md` reverse-chron index (include redirects marked).
- Repo-wide link hygiene; skip `vendor/`; leave historical narration honest.
- `996` promotion: reconcile with existing `context/TAME_STYLE.md` operational supplement.
