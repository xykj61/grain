# FOSSIL -- Class M, prepped 20260906.114734 for the mitra shed; the cut stays RED until circled.
# Living mutant: tools/f/fleet-loop.sh reading construction/fleet-roster.kyri, with
# tools/f/fleet_watch.sh above it. Row and reasons: construction/SHRED_PREP.md.
BEGIN {
  held = 1
  seen = 0
}

{
  seen++
  oldmode = substr($1, 2)
  newmode = $2
  status = $5
  path = $6

  if (NF != 6)
    held = 0
  if (status != "A" && status != "M")
    held = 0
  if (newmode != "100644" && newmode != "100755")
    held = 0
  # The campaign lane, seated 20260829 on the user's word with the fleet re-map:
  # MYSTERY tends the booked maintenance campaigns -- doorway Status lines,
  # LEXICON row condenses on touch, counsel mutants and banners, shred-prep and
  # QA rows, index rows, and its own session log on its day shelf. The rooms
  # below are the prose and ledger surfaces those campaigns touch. A or M only,
  # exactly as the cardinal wall keeps it: a fold or shed DELETES, and deletion
  # stays a hand's act -- a campaign lap that needs one parks it. Agent rules
  # and the root doors stay outside; a candidate wanting them parks its
  # question rather than widening its own wall.
  #
  # WIDENED 20260829.222718 on the user's word: the CION rung-mark molt campaign
  # (expanding-prompts/20260829-221841_cion-resumes-the-rung-mark-molt-campaign.md)
  # converts landed-rung citations to stamp-and-name inside code rooms, so glow,
  # lotus, tools, linengrow, and brushstroke join the roots. A or M only still
  # holds, so the campaign's rename tiers (A and B) stay a hand's act, and the
  # per-lap witness-GREEN discipline rides in the campaign page rather than here.
  if (path !~ /^(session-logs|construction|context|foundations|active-designing|active-development|external-research|counsel|docs|docs-geode|expanding-prompts|waymarks|glow|lotus|tools|linengrow|brushstroke)\/[A-Za-z0-9._\/-]+$/)
    held = 0
  if (path ~ /(^|\/)\.\.?($|\/)/)
    held = 0
}

END {
  if (seen < 1 || held != 1)
    exit 1
  exit 0
}
