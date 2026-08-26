# tools/s/stream_render.jq -- render Claude Code's --output-format stream-json as a
# readable live text stream for the season loop.
#
# Usage (needs jq -- install with tools/p/pier_jq_install.sh):
#   ... claude --output-format stream-json --verbose -p '...' | jq -Rrj -f tools/s/stream_render.jq
#
# -R reads each line as a raw string; fromjson? parses it, ignoring any non-JSON
# line rather than crashing. -r raw output, -j no auto-newline (we place our own).
# It shows assistant text as it lands and one informative line per tool call:
# the Bash description a call already carries, the path an edit or read touches,
# the pattern a search runs -- so the livefeed reads as a narrated round rather
# than a column of bare tool names (Keaton's word, 20260825). Long values clip
# at 160 characters so one call stays one line. If your Claude Code version
# emits a different event shape and this shows nothing, the full raw stream is
# still saved by the loop's `tee` to /tmp/claude_lap.jsonl -- inspect it and
# adjust the paths below.

def clip: tostring | if length > 160 then .[0:157] + "..." else . end;

def toolline:
  .name as $n
  | .input as $i
  | if $n == "Bash" then
      "[Bash] " + (($i.description // $i.command // "?") | clip)
    elif $n == "Edit" or $n == "Write" or $n == "Read" or $n == "NotebookEdit" then
      "[" + $n + "] " + (($i.file_path // "?") | clip)
    elif $n == "Grep" then
      "[Grep] " + (($i.pattern // "?") | clip)
        + (if $i.path then " in " + ($i.path | clip) else "" end)
    elif $n == "Glob" then
      "[Glob] " + (($i.pattern // "?") | clip)
    elif $n == "Task" or $n == "Agent" then
      "[" + $n + "] " + (($i.description // $i.prompt // "?") | clip)
    elif $n == "TodoWrite" then
      "[Todo] " + (([$i.todos[]? | .content] | join(" | ")) | clip)
    elif $n == "WebFetch" or $n == "WebSearch" then
      "[" + $n + "] " + (($i.url // $i.query // "?") | clip)
    else
      "[" + $n + "] " + (($i | del(.content) | tostring) | clip)
    end;

fromjson?
| if .type == "assistant" then
    ( .message.content[]?
      | if .type == "text" then .text
        elif .type == "tool_use" then "\n" + toolline + "\n"
        else empty end )
  elif .type == "stream_event" then
    ( .event.delta.text // empty )
  elif .type == "result" then "\n--- lap complete ---\n"
  else empty end
