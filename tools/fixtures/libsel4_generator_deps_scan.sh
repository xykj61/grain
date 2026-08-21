#!/bin/sh
# tools/fixtures/libsel4_generator_deps_scan.sh -- how many of seL4's own
# header-generator dependencies this pier is missing.
#
# seL4's libsel4 generates part of its userlevel core at build time with Python
# tools that import jinja2 (syscall_header_gen.py, invocation_header_gen.py)
# and ply (bitfield_gen.py). The reach witness reports the count so the gate
# stays a measurement: on a pier that carries them, this prints 0 and the rest
# of the userlevel surface opens without any change to the witness.
#
# Prints a single integer, 0 through 2.
missing=0
for m in jinja2 ply; do
  python3 -c "import $m" >/dev/null 2>&1 || missing=$((missing + 1))
done
printf '%s' "$missing"
