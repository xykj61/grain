# Call-site harvest — std surfaces seeds actually use

**Stamp:** `20260628-044200`
**Parent:** [`active-designing/20260628-043542_thin-frontend-slc-direction.md`](../active-designing/20260628-043542_thin-frontend-slc-direction.md)

Under the thin frontend, invariants worth keeping are re-asserted at **seed call sites** when those seeds are next touched — not in a forked `std`. Each row needs **verify** before harvest (`9941` is a known mismatch).

**Scanned:** 180 authored `.rye`/`.rish` files · **101** distinct `std` surfaces · **0** with lexicon pass docs

| Surface | Callers | Pass(es) | Doc | Verify | Example callers |
|---------|---------|----------|-----|--------|-----------------|
| `debug.assert` | 130 | — | — | no pass — assert at call site if needed | `aurora/src/seed.rye`, `brushstroke/seed.rye`, `brushstroke/skate_grid.rye` (+127) |
| `debug.print` | 129 | — | — | no pass — assert at call site if needed | `brushstroke/skate_grid_test.rye`, `brushstroke/wayland_seed.rye`, `caravan/bounded.rye` (+126) |
| `mem.eql` | 49 | — | — | no pass — assert at call site if needed | `aurora/src/posted.rye`, `aurora/src/sealed.rye`, `brushstroke/wayland_seed.rye` (+46) |
| `mem.Allocator` | 30 | — | — | no pass — assert at call site if needed | `brushstroke/skate_grid.rye`, `brushstroke/wayland_seed.rye`, `caravan/bounded.rye` (+27) |
| `Io.Dir` | 18 | — | — | no pass — assert at call site if needed | `mantra/src/main.rye`, `mantra/src/store.rye`, `rishi/src/main.rye` (+15) |
| `process.Init` | 18 | — | — | no pass — assert at call site if needed | `brushstroke/seed.rye`, `brushstroke/wayland_seed.rye`, `caravan/bounded.rye` (+15) |
| `mem.indexOf` | 15 | — | — | no pass — assert at call site if needed | `rishi/src/main.rye`, `rishi/tests/contains_string.rish`, `rishi/tests/index_of.rish` (+12) |
| `crypto.hash` | 14 | — | — | no pass — assert at call site if needed | `aurora/src/named.rye`, `aurora/src/posted.rye`, `aurora/src/sealed.rye` (+11) |
| `fmt.allocPrint` | 14 | — | — | no pass — assert at call site if needed | `mantra/src/main.rye`, `rishi/src/main.rye`, `rye/src/main.rye` (+11) |
| `fs.path` | 13 | — | — | no pass — assert at call site if needed | `rye/src/main.rye`, `rye/tests/path_basename_test.rye`, `rye/tests/path_dirname_test.rye` (+10) |
| `mem.startsWith` | 11 | — | — | no pass — assert at call site if needed | `mantra/src/main.rye`, `rishi/src/main.rye`, `rye/src/main.rye` (+8) |
| `heap.page_allocator` | 10 | — | — | no pass — assert at call site if needed | `brushstroke/skate_grid_test.rye`, `rye/tests/alloc_print_test.rye`, `rye/tests/allocator_alloc_test.rye` (+7) |
| `mem.endsWith` | 10 | — | — | no pass — assert at call site if needed | `rishi/src/main.rye`, `rishi/tests/ends_with.rish`, `rye/src/main.rye` (+7) |
| `mem.indexOfScalar` | 9 | — | — | no pass — assert at call site if needed | `mantra/src/main.rye`, `rishi/src/main.rye`, `rye/tests/call_paths_test.rye` (+6) |
| `mem.trim` | 9 | — | — | no pass — assert at call site if needed | `mantra/src/main.rye`, `rishi/src/main.rye`, `rye/tests/call_paths_test.rye` (+6) |
| `fmt.bufPrint` | 7 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye`, `mantra/src/main.rye`, `mantra/src/store.rye` (+4) |
| `mem.splitScalar` | 7 | — | — | no pass — assert at call site if needed | `mantra/src/diff.rye`, `mantra/src/main.rye`, `rishi/src/main.rye` (+4) |
| `math.maxInt` | 6 | — | — | no pass — assert at call site if needed | `brushstroke/skate_grid.rye`, `caravan/bounded.rye`, `caravan/chain.rye` (+3) |
| `process.spawn` | 6 | — | — | no pass — assert at call site if needed | `caravan/bounded.rye`, `caravan/chain.rye`, `caravan/seed.rye` (+3) |
| `Io.File` | 5 | — | — | no pass — assert at call site if needed | `brushstroke/seed.rye`, `brushstroke/wayland_seed.rye`, `rishi/src/main.rye` (+2) |
| `crypto.aead` | 5 | — | — | no pass — assert at call site if needed | `aurora/src/posted.rye`, `aurora/src/sealed.rye`, `comlink/hosted_wire.rye` (+2) |
| `crypto.dh` | 5 | — | — | no pass — assert at call site if needed | `aurora/src/posted.rye`, `aurora/src/sealed.rye`, `comlink/hosted_wire.rye` (+2) |
| `crypto.sign` | 5 | — | — | no pass — assert at call site if needed | `aurora/src/posted.rye`, `aurora/src/sealed.rye`, `comlink/hosted_wire.rye` (+2) |
| `fmt.parseInt` | 4 | — | — | no pass — assert at call site if needed | `caravan/seed.rye`, `mantra/src/main.rye`, `rishi/src/main.rye` (+1) |
| `mem.sort` | 4 | — | — | no pass — assert at call site if needed | `mantra/src/main.rye`, `mantra/src/weave.rye`, `rye/tests/mantra_weave_test.rye` (+1) |
| `ascii.isAlphanumeric` | 3 | — | — | no pass — assert at call site if needed | `tools/enrich/scan_text.rye`, `tools/enrich/zig_lookup.rye`, `tools/tame_usize_audit.rye` |
| `mem.copyForwards` | 3 | — | — | no pass — assert at call site if needed | `brushstroke/skate_grid.rye`, `rishi/src/main.rye`, `rye/tests/mem_copy_forwards_test.rye` |
| `mem.Alignment` | 2 | — | — | no pass — assert at call site if needed | `rye/tests/mem_alignment_byte_units_test.rye`, `rye/tests/mem_alignment_methods_test.rye` |
| `mem.concat` | 2 | — | — | no pass — assert at call site if needed | `tools/enrich/sections.rye`, `tools/enrich_strengthening_docs.rye` |
| `mem.count` | 2 | — | — | no pass — assert at call site if needed | `rye/tests/mem_count_test.rye`, `tools/enrich_strengthening_docs.rye` |
| `mem.indexOfPos` | 2 | — | — | no pass — assert at call site if needed | `tools/enrich/scan_text.rye`, `tools/enrich/zig_lookup.rye` |
| `mem.indexOfScalarPos` | 2 | — | — | no pass — assert at call site if needed | `rishi/src/main.rye`, `rye/tests/call_paths_test.rye` |
| `mem.join` | 2 | — | — | no pass — assert at call site if needed | `rye/tests/mem_join_test.rye`, `tools/tame_usize_audit.rye` |
| `mem.span` | 2 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye`, `rye/tests/mem_span_test.rye` |
| `mem.trimEnd` | 2 | — | — | no pass — assert at call site if needed | `rishi/src/main.rye`, `rye/tests/alloc_print_test.rye` |
| `process.run` | 2 | — | — | no pass — assert at call site if needed | `rishi/src/main.rye`, `rye/tests/process_run_test.rye` |
| `SemanticVersion.format` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/semantic_version_format_test.rye` |
| `SemanticVersion.order` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/semantic_version_order_test.rye` |
| `SemanticVersion.parse` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/semantic_version_parse_test.rye` |
| `ascii.isDigit` | 1 | — | — | no pass — assert at call site if needed | `tools/tame_usize_audit.rye` |
| `ascii.isLower` | 1 | — | — | no pass — assert at call site if needed | `tools/enrich/scan_text.rye` |
| `c.close` | 1 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye` |
| `c.ftruncate` | 1 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye` |
| `crypto.secureZero` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/crypto_secure_zero_test.rye` |
| `crypto.timing_safe` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/crypto_timing_safe_eql_test.rye` |
| `fs.max_path_bytes` | 1 | — | — | no pass — assert at call site if needed | `tools/enrich/root.rye` |
| `mem.absorbSentinel` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_absorb_sentinel_test.rye` |
| `mem.alignForward` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_align_forward_backward_test.rye` |
| `mem.alignForwardAnyAlign` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_align_any_align_test.rye` |
| `mem.alignForwardLog2` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_align_log2_any_align_test.rye` |
| `mem.alignInBytes` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_align_in_bytes_slice_test.rye` |
| `mem.alignPointer` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_align_pointer_test.rye` |
| `mem.allEqual` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_all_equal_test.rye` |
| `mem.asBytes` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_as_bytes_test.rye` |
| `mem.byteSwapAllElements` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_byte_swap_all_elements_test.rye` |
| `mem.byteSwapAllFields` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_byte_swap_all_fields_test.rye` |
| `mem.bytesAsSlice` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_bytes_as_slice_test.rye` |
| `mem.bytesAsValue` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_bytes_as_value_test.rye` |
| `mem.bytesToValue` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_bytes_to_value_test.rye` |
| `mem.containsAtLeast` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_contains_at_least_test.rye` |
| `mem.containsAtLeastScalar` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_contains_at_least_scalar_test.rye` |
| `mem.copyBackwards` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_copy_backwards_test.rye` |
| `mem.cut` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/cut_test.rye` |
| `mem.cutLast` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/cut_last_test.rye` |
| `mem.cutPrefix` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/cut_prefix_suffix_test.rye` |
| `mem.doNotOptimizeAway` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_do_not_optimize_away_test.rye` |
| `mem.findAnyPos` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_any_pos_test.rye` |
| `mem.findDiff` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_find_diff_test.rye` |
| `mem.findLast` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_last_test.rye` |
| `mem.findLastAny` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_last_any_test.rye` |
| `mem.findLastLinear` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_last_linear_test.rye` |
| `mem.findLastNone` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_last_none_test.rye` |
| `mem.findNonePos` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_none_pos_test.rye` |
| `mem.findPos` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_pos_test.rye` |
| `mem.findPosLinear` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_pos_linear_test.rye` |
| `mem.findScalarLast` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_scalar_last_test.rye` |
| `mem.findScalarPos` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/find_scalar_pos_test.rye` |
| `mem.isAligned` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_is_aligned_test.rye` |
| `mem.isValidAlign` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_is_valid_align_test.rye` |
| `mem.len` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_len_test.rye` |
| `mem.nativeToBig` | 1 | — | — | no pass — assert at call site if needed | `comlink/hosted_wire.rye` |
| `mem.order` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_order_test.rye` |
| `mem.orderZ` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_order_z_test.rye` |
| `mem.readInt` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_read_write_int_test.rye` |
| `mem.readPackedInt` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_read_write_packed_int_test.rye` |
| `mem.readVarInt` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_read_varint_test.rye` |
| `mem.readVarPackedInt` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_read_write_var_packed_int_test.rye` |
| `mem.reverse` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_reverse_test.rye` |
| `mem.sliceAsBytes` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_slice_as_bytes_test.rye` |
| `mem.sliceTo` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_slice_to_test.rye` |
| `mem.sortContext` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_sort_context_test.rye` |
| `mem.splitSequence` | 1 | — | — | no pass — assert at call site if needed | `rishi/src/main.rye` |
| `mem.toBytes` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_to_bytes_test.rye` |
| `mem.trimRight` | 1 | — | — | no pass — assert at call site if needed | `mantra/src/store.rye` |
| `mem.trimStart` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/trim_start_test.rye` |
| `mem.zeroInit` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_zero_init_test.rye` |
| `mem.zeroes` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_zeroes_test.rye` |
| `posix.POLL` | 1 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye` |
| `posix.poll` | 1 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye` |
| `posix.pollfd` | 1 | — | — | no pass — assert at call site if needed | `brushstroke/wayland_seed.rye` |
| `sort.isSorted` | 1 | — | — | no pass — assert at call site if needed | `rye/tests/mem_sort_test.rye` |

## Surfaces strengthened but not called by seeds

The lexicon holds ~113 passes; most surfaces have **no** seed caller. After std re-fork they remain **chronicle record only** — no overlay maintenance.

## Next

When touching a seed row above: read the pass doc, confirm the strengthened fn matches, then add TAME assertions in the `.rye` caller — not in `std`.

## Seventeen divergent files — captured before symlink (Move 3)

Read before `rye/lib/std` becomes a symlink. Strengthening assertions in these files **do not** graduate to overlay — harvest to call sites when touching seeds.

| File | Diff stat | Chronicle / notes | Harvest |
|------|-----------|-------------------|---------|
| `Io/Dir.zig` |  1 file changed, 31 insertions(+), 2 deletions(-) | 9991 | verify pass doc vs diff; assert at call site |
| `Io/File.zig` |  1 file changed, 2 insertions(+) | 9984–9985 | verify pass doc vs diff; assert at call site |
| `Random/benchmark.zig` |  1 file changed, 2 insertions(+), 2 deletions(-) | benchmark or ancillary | verify pass doc vs diff; assert at call site |
| `SemanticVersion.zig` |  1 file changed, 51 insertions(+), 11 deletions(-) | 9946–9948 | verify pass doc vs diff; assert at call site |
| `crypto/benchmark.zig` |  1 file changed, 4 insertions(+), 4 deletions(-) | benchmark or ancillary | verify pass doc vs diff; assert at call site |
| `crypto/keccak_p.zig` |  1 file changed, 28 insertions(+) | 9997 | verify pass doc vs diff; assert at call site |
| `crypto/sha3.zig` |  1 file changed, 29 insertions(+) | 9994,9998 | verify pass doc vs diff; assert at call site |
| `crypto/timing_safe.zig` |  1 file changed, 7 insertions(+), 2 deletions(-) | 9937 | verify pass doc vs diff; assert at call site |
| `crypto.zig` |  1 file changed, 12 insertions(+), 1 deletion(-) | 9995 | verify pass doc vs diff; assert at call site |
| `debug.zig` |  1 file changed, 12 insertions(+) | comments only | verify pass doc vs diff; assert at call site |
| `fmt.zig` |  1 file changed, 13 insertions(+), 2 deletions(-) | 9986 | verify pass doc vs diff; assert at call site |
| `fs/path.zig` |  1 file changed, 24 insertions(+), 4 deletions(-) | 9980–9983 | verify pass doc vs diff; assert at call site |
| `hash/benchmark.zig` |  1 file changed, 2 insertions(+), 2 deletions(-) | benchmark or ancillary | verify pass doc vs diff; assert at call site |
| `mem/Allocator.zig` |  1 file changed, 4 insertions(+), 1 deletion(-) | 9987 | verify pass doc vs diff; assert at call site |
| `mem.zig` |  1 file changed, 1258 insertions(+), 127 deletions(-) | 9913–9998 (many mem passes) | ⚠ many surfaces — verify each (9941 mismatch known) |
| `process.zig` |  1 file changed, 14 insertions(+), 2 deletions(-) | 9981 | verify pass doc vs diff; assert at call site |
| `start.zig` |  1 file changed, 5 insertions(+), 5 deletions(-) | init seam | verify pass doc vs diff; assert at call site |
