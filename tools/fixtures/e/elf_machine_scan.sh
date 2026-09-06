#!/bin/sh
# tools/fixtures/e/elf_machine_scan.sh -- which architecture is this binary, read from its own bytes?
#
#   sh tools/fixtures/e/elf_machine_scan.sh <path> [<path> ...]
#
# WHY THIS EXISTS. Glow's two cross-target witnesses proved the architecture of what they built by
# reading `file`'s prose -- `run ["sh" "-c" "file ${bin}"]`, then a substring assert on the output.
# Neither checked whether the call succeeded. This pier has no `file(1)`, so the call exited 127
# with empty output and the substring assert fired with the message *cross-built binary is not
# aarch64*, which is a claim about the binary. The binary was correct: built that minute, 4,719,664
# bytes, and AArch64 by its own header. A guard that cannot run its instrument said the subject
# was broken.
#
# WHAT IT READS. The ELF header, whose first twenty bytes have been fixed since 1999: the four
# magic bytes, EI_CLASS and EI_DATA at offsets 4 and 5, and the two-byte e_machine at offset 18,
# decoded in the byte order the header itself declares. `od` is POSIX, so this asks the host for
# nothing it is not required to have -- the granted tier, where `file` was a borrowed one.
#
# WHY THE BYTES RATHER THAN A PROBE-AND-FALL-BACK. A missing utility has two honest answers:
# refuse and name it, or stop needing it. Architecture is a two-byte field at a fixed offset in a
# published format, so the second answer was available -- and it moves the reading out of the thin
# edge, where only the world can tell the truth, into the happy zone, where a planted header is a
# complete test (foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md).
#
# WHAT IT REFUSES, each by name: a path that is not there, a file too short to carry the field, a
# file whose magic is not ELF, a header declaring a byte order this reader cannot decode, and an
# e_machine no one here builds for. The last is a refusal rather than a guess, because inventing a
# name for an unfamiliar number is how a reader starts lying quietly.
#
# Exit 0 when every named path read as an ELF this tree knows; 1 on any refusal; 2 on misuse.
set -eu

[ $# -ge 1 ] || { echo "detail: name at least one path"; echo "verdict=no_path"; exit 2; }

# The e_machine values this tree actually builds for, plus the four a reader is likeliest to meet
# by accident. Bounded on purpose -- see the refusal note above.
machine_name() {
  case "$1" in
    3)   echo x86 ;;
    8)   echo MIPS ;;
    20)  echo PowerPC ;;
    21)  echo PowerPC64 ;;
    40)  echo ARM ;;
    62)  echo x86-64 ;;
    183) echo AArch64 ;;
    243) echo RISC-V ;;
    *)   echo unknown ;;
  esac
}

# Decimal bytes, space separated. Redirection rather than a path operand, so a filename that
# begins with a dash can never be read as an option.
read_bytes() { # path offset count
  od -An -tu1 -j "$2" -N "$3" < "$1" 2>/dev/null | tr -s ' \n' ' ' | sed 's/^ //; s/ *$//'
}

# An ELF header carries e_machine in bytes 18 and 19, so twenty is the least a file can be and
# still answer the question this scan asks.
elf_header_min=20

absent=0; not_elf=0; unnamed=0; read_ok=0

for p in "$@"; do
  if [ ! -f "$p" ]; then
    echo "binary $p elf=no reason=absent"
    echo "detail: $p is not a file here"
    absent=$((absent + 1))
    continue
  fi

  size=$(wc -c < "$p" | tr -d ' ')
  if [ "$size" -lt "$elf_header_min" ]; then
    echo "binary $p elf=no reason=truncated bytes=$size"
    echo "detail: $p is $size bytes; an ELF header needs $elf_header_min to carry e_machine"
    not_elf=$((not_elf + 1))
    continue
  fi

  magic=$(read_bytes "$p" 0 4)
  if [ "$magic" != "127 69 76 70" ]; then
    echo "binary $p elf=no reason=magic bytes0_3=\"$magic\""
    echo "detail: $p does not open 0x7f E L F"
    not_elf=$((not_elf + 1))
    continue
  fi

  ident=$(read_bytes "$p" 4 2)
  cls=${ident%% *}; dat=${ident##* }
  case "$cls" in 1) class=32 ;; 2) class=64 ;; *) class=unknown ;; esac
  case "$dat" in 1) endian=little ;; 2) endian=big ;; *) endian=unknown ;; esac

  if [ "$endian" = unknown ]; then
    echo "binary $p elf=yes class=$class endian=unknown ei_data=$dat"
    echo "detail: $p declares EI_DATA=$dat, so e_machine cannot be decoded in a known byte order"
    not_elf=$((not_elf + 1))
    continue
  fi

  mb=$(read_bytes "$p" 18 2)
  b18=${mb%% *}; b19=${mb##* }
  if [ "$endian" = big ]; then
    em=$((b18 * 256 + b19))
  else
    em=$((b18 + b19 * 256))
  fi

  name=$(machine_name "$em")
  echo "binary $p elf=yes class=$class endian=$endian e_machine=$em machine=$name"
  if [ "$name" = unknown ]; then
    echo "detail: $p carries e_machine=$em, which this reader does not name"
    unnamed=$((unnamed + 1))
  else
    read_ok=$((read_ok + 1))
  fi
done

echo "read=$read_ok absent=$absent not_elf=$not_elf unnamed=$unnamed"

[ "$absent" -eq 0 ]         || { echo "verdict=absent"; exit 1; }
[ "$not_elf" -eq 0 ]        || { echo "verdict=not_elf"; exit 1; }
[ "$unnamed" -eq 0 ] || { echo "verdict=unknown_machine"; exit 1; }
echo "verdict=read"
