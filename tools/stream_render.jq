# tools/stream_render.jq — render Claude Code's --output-format stream-json as a
# readable live text stream for the season loop.
#
# Usage (needs jq — install with tools/pier_jq_install.sh):
#   ... claude --output-format stream-json --verbose -p '...' | jq -Rrj -f tools/stream_render.jq
#
# -R reads each line as a raw string; fromjson? parses it, ignoring any non-JSON
# line rather than crashing. -r raw output, -j no auto-newline (we place our own).
# It shows assistant text as it lands, marks each tool call, and rules off each
# lap. If your Claude Code version emits a different event shape and this shows
# nothing, the full raw stream is still saved by the loop's `tee` to
# /tmp/claude_lap.jsonl — inspect it and adjust the paths below.
fromjson?
| if .type == "assistant" then
    ( .message.content[]?
      | if .type == "text" then .text
        elif .type == "tool_use" then "\n[tool: " + (.name // "?") + "]\n"
        else empty end )
  elif .type == "stream_event" then
    ( .event.delta.text // empty )
  elif .type == "result" then "\n--- lap complete ---\n"
  else empty end
