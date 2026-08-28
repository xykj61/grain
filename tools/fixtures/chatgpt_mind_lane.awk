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
  # The product lane, plus two narrow grants seated 20260828 on the user's
  # word after the candidate-proof-boundary custody stop: a lap may write its
  # own session log onto its day shelf (an addition under session-logs/date/,
  # and the day-index row beside it), and may carry the SkateCore witness
  # forward when its candidate adds a test that witness must name. Every
  # other wall stands: A or M only, no dot-dot, no sibling root.
  if (path !~ /^((brushstroke|surf|skate)\/[A-Za-z0-9._\/-]+|session-logs\/date\/[A-Za-z0-9._-]+(\/[A-Za-z0-9._-]+)?|tools\/s\/skate_native_core_witness\.rish)$/)
    held = 0
  if (path ~ /(^|\/)\.\.?($|\/)/)
    held = 0
  if (path == "brushstroke/xdg-shell-client-protocol.h" ||
      path == "brushstroke/xdg-shell-protocol.c")
    held = 0
}

END {
  if (seen < 1 || held != 1)
    exit 1
  exit 0
}
