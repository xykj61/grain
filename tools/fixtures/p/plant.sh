# tools/fixtures/p/plant.sh -- a plant is a claim about a file, and this proves the claim.
#
# WHAT THIS IS FOR. A control breaks a module on purpose and watches its witness refuse. The break
# is almost always a `sed` naming one literal line of the real source, copied into a pen. That
# naming is a CLAIM -- "this line, spelled this way, is in that file today" -- and it is the one
# part of a control nothing was checking. When the line moves, the sed matches nothing, the pen is
# copied byte for byte, and the phase builds and runs the UNMUTATED module. It exits 0, which is
# the same reading a law that holds gives. Source this file and call one of the three functions
# below, and a plant that plants nothing says so by name instead:
#
#   . "$_fd_root/tools/fixtures/p/plant.sh"
#
#   plant_write  "$src" "$pen/mod.rye" "$program" lcs_equality   # read one file, write another
#   plant_apply  "$pen/mod.rye" "$program" lcs_equality          # rewrite in place, mode kept
#   plant_landed "$before" "$after" lcs_equality                 # the reading alone
#
# Each answers 0 when the plant landed and 1 when it did not, printing the literal
# `plant_matched_nothing:<label>` on standard error. A WORD rather than a number, so it can never
# be mistaken for an exit code -- the distinction REDS %519 learned by having its verdict loop read
# the exit code of a run that tested nothing.
#
# WHY IT EXISTS, MEASURED. On `20260906` a type in `mantra/src/diff.rye` changed from `u32` to
# `LineId`, and `tools/fixtures/m/mantra_diff_control.sh` went on naming the elder spelling. The
# phase read `elder_arraylist_exit=0` -- healthy -- against a module it had never broken. Three
# Mantra controls were repaired in place that day; **94 controls carried no such check**, and
# `run_pen` is written fresh in each, so the next type change disarms whichever plant names the
# line it moved. One implementation, imported, is what stops that recurring.
#
# WHY IT IS NOT A SCAN OVER CONTROL TEXT. The obvious meter -- count the controls carrying
# `cmp -s` -- reads a proxy, and the proxy is wrong three ways. Measured at `e567cbc128` over the
# seven controls that carried `cmp -s` then: four use it to prove a plant landed
# (`rye_compile_reach`, `tlb_reach`, `topology_attained`, `topology_point_metric`) and **three use
# it to prove the opposite** -- that a file did NOT change. `reds_ledger_headline_control.sh`
# proves every line but the headline stands byte-identical; `remember_git_nib_write_control.sh`
# proves refusal-before-mutation leaves the card intact; `shell_portable_control.sh` proves
# `sed_inplace` matching nothing leaves a file alone. Reading the word `planted` instead fails the
# same way from the other side: two of those three carry it, once in a comment and once for pen
# rows the control authored itself. One operator, three claims. So adoption is counted by what a
# control IMPORTS, which is exact, rather than by what its text resembles.

# A PLANT NEEDS A PROGRAM, A SOURCE, AND A DIFFERENCE. Each of the four refusals below names which
# of those was missing, because "it did not work" sends a reader back to the pen with no clue which
# end to look at. The label is the caller's phase name and rides on every refusal.

# plant_landed BEFORE AFTER [LABEL] -- the reading alone, for a caller holding both files already.
# Answers 0 when the two differ (the plant landed) and 1 when they are byte-identical.
plant_landed() {
  _pl_before=$1
  _pl_after=$2
  _pl_label=${3:-plant}
  if [ ! -f "$_pl_before" ]; then
    echo "plant_source_absent:$_pl_label -- $_pl_before" >&2
    return 1
  fi
  if [ ! -f "$_pl_after" ]; then
    echo "plant_source_absent:$_pl_label -- $_pl_after" >&2
    return 1
  fi
  if cmp -s "$_pl_before" "$_pl_after"; then
    echo "plant_matched_nothing:$_pl_label -- the pen is byte-identical, so the phase tests the unmutated file" >&2
    return 1
  fi
  return 0
}

# plant_write SRC DEST PROGRAM [LABEL] -- run SRC through the sed PROGRAM into DEST, and prove the
# rewrite landed. DEST is left absent when the plant fails, so a caller that ignores the return
# value still cannot build an unmutated pen and read it as broken.
plant_write() {
  _pw_src=$1
  _pw_dest=$2
  _pw_program=$3
  _pw_label=${4:-plant}
  if [ ! -f "$_pw_src" ]; then
    echo "plant_source_absent:$_pw_label -- $_pw_src" >&2
    return 1
  fi
  # An empty program can never change a byte, so it is a caller fault rather than a stale line.
  # Named apart from plant_matched_nothing because the repair is different: one is a typo here,
  # the other is a line that moved in the module.
  if [ -z "$_pw_program" ]; then
    echo "plant_program_empty:$_pw_label -- a plant with no program mutates nothing" >&2
    return 1
  fi
  _pw_tmp="$_pw_dest.plant.$$"
  if ! sed "$_pw_program" "$_pw_src" > "$_pw_tmp" 2>/dev/null; then
    # sed refusing leaves a partial or empty file, which DIFFERS from the source and would read as
    # a landed plant under a bare byte comparison. Checking the exit code is what tells a broken
    # expression from a real break.
    echo "plant_program_failed:$_pw_label -- sed refused the program" >&2
    rm -f "$_pw_tmp"
    return 1
  fi
  if cmp -s "$_pw_tmp" "$_pw_src"; then
    echo "plant_matched_nothing:$_pw_label -- the pen is byte-identical, so the phase tests the unmutated file" >&2
    rm -f "$_pw_tmp"
    return 1
  fi
  # The mode travels with the write. A plant aimed at a fixture or a launcher is aimed at a file
  # whose exec bit is tracked content (.claude/rules/exec-bit.md), and `mv` would carry the
  # temporary's mode instead -- which is how a repoint pass dropped 100755 on thirty-nine files.
  # A destination that does not exist yet is seeded with `cp`, which carries the source's mode by
  # definition, and then written through that inode. Reading the mode to re-apply it would want
  # `stat`, whose field-format flag is GNU's `-c` and BSD's `-f` -- one more dialect question
  # (`shell_dialect` holds `stat -c` at zero) that `cp` answers without asking.
  [ -f "$_pw_dest" ] || cp "$_pw_src" "$_pw_dest"
  cat "$_pw_tmp" > "$_pw_dest"
  rm -f "$_pw_tmp"
  return 0
}

# plant_apply FILE PROGRAM [LABEL] -- rewrite FILE in place through the sed PROGRAM, proving the
# rewrite landed and leaving FILE untouched when it did not. Writing through the original inode
# keeps the file's mode, which `mv` would not.
plant_apply() {
  _pa_file=$1
  _pa_program=$2
  _pa_label=${3:-plant}
  if [ ! -f "$_pa_file" ]; then
    echo "plant_source_absent:$_pa_label -- $_pa_file" >&2
    return 1
  fi
  if [ -z "$_pa_program" ]; then
    echo "plant_program_empty:$_pa_label -- a plant with no program mutates nothing" >&2
    return 1
  fi
  _pa_tmp="$_pa_file.plant.$$"
  if ! sed "$_pa_program" "$_pa_file" > "$_pa_tmp" 2>/dev/null; then
    echo "plant_program_failed:$_pa_label -- sed refused the program" >&2
    rm -f "$_pa_tmp"
    return 1
  fi
  if cmp -s "$_pa_tmp" "$_pa_file"; then
    echo "plant_matched_nothing:$_pa_label -- the pen is byte-identical, so the phase tests the unmutated file" >&2
    rm -f "$_pa_tmp"
    return 1
  fi
  cat "$_pa_tmp" > "$_pa_file"
  rm -f "$_pa_tmp"
  return 0
}
