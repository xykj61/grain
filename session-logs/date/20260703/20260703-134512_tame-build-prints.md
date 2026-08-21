# TAME-guided build prints — drawn-terminal fixture

**Editor:** Cursor · **Model:** Composer
**Stamp:** 20260703.134512

## Thinking trace

Kaeden asked to strengthen build prints under TAME guidance. Extended `pond_build_drawn_terminal.sh` with explicit prepare → compile → prove phases: toolchain and source checks, host link seam notes, heartbeat during silent Zig compile, byte-size proof before GREEN. Updated `.rish` and Ring 3 / SLC-2b / metal witnesses to assert staged output and route through the fixture script.

## Observations

Fixed `sh`-safe echo (no bash `${var//}` substitution). Build witness and parity paths unchanged in arithmetic.

## Files

| File | Why |
|------|-----|
| `tools/fixtures/pond_build_drawn_terminal.sh` | TAME three-phase staged echo |
| `tools/fixtures/pond_build_drawn_terminal.rish` | Assert prepare/compile/prove/GREEN |
| `tools/slc2a_ring3_session.rish` | Use staged build |
| `tools/slc2b_keyboard.rish` | Use staged build |
| `tools/slc2a_ring3_metal.rish` | Assert GREEN in build output |
