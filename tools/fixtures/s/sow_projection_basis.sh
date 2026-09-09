#!/bin/sh
# Hash the tracked inputs a seed projection reads, from the caller's repository.
# The index records tracked paths and modes; the binary diff records staged and
# unstaged content. HEAD keeps the receipt tied to its commit as well.
# Ignored build output is outside the input set. Callers compare this reading
# before and after copying so a changed input leaves no completion receipt.
set -eu
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
{
  git rev-parse --verify HEAD || exit 1
  git ls-files --stage || exit 1
  git diff --no-ext-diff --no-textconv --binary HEAD -- || exit 1
} > "$pen/basis" || exit 1
git hash-object "$pen/basis"
