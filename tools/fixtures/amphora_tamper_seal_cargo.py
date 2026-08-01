#!/usr/bin/env python3
"""Flip one nibble in the seal_cargo field of an Amphora vessel file."""
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
out = []
for line in text.splitlines(True):
    if line.startswith("seal_cargo "):
        ending = "\n" if line.endswith("\n") else ""
        body = line[len("seal_cargo ") :].rstrip("\n")
        if body:
            flip = "a" if body[0] != "a" else "b"
            line = "seal_cargo " + flip + body[1:] + ending
    out.append(line)
path.write_text("".join(out))
