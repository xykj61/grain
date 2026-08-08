# sow_scrub.sed — the name -> role transform for the public seed.
#
# Handles the dominant case the witness found: maintainer NAMES appearing in
# prose and comments as decision-authority ("on Keaton's word", "Kaeden's
# word", "held for Keaton"). It turns them into the generic role the
# Acme-employee-voice rule prescribes (.claude/rules/acme-employee-voice.md).
#
# Ordered longest-first so compound names resolve before their parts.
#
# DELIBERATELY ABSENT: the functional handles (xykj61, autoproject96) and the
# real Azimuth ship names (bandun, pacpet-solreb). Those are identifiers and
# code literals, not prose — blind replacement could change behavior, so any
# file still carrying them after this pass is WITHHELD for human judgment, not
# silently rewritten.
s/Keaton Livermore/the maintainer/g
s/Kaeden Reyklah/the maintainer/g
s/Keaton's/the maintainer's/g
s/Kaeden's/the maintainer's/g
s/Keaton/the maintainer/g
s/Kaeden/the maintainer/g
s/Livermore/the maintainer/g
s/Reyklah/the maintainer/g
