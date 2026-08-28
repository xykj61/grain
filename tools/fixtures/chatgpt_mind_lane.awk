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
  if (path !~ /^(brushstroke|surf|skate)\/[A-Za-z0-9._\/-]+$/)
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
