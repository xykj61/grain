# tools/fixtures/md_truth.awk — GISM Journey 5 (Real corpora), Rung 4.
#
# An independent, fence-aware measurement of a real markdown document, so a reading
# voice's report can be cross-checked against a second tool. Counts headings and
# fenced-code kinds while respecting code fences — a '#' line INSIDE a fence is
# code, not a heading (exactly the trap a naive `grep -cE '^#'` falls into, and the
# reason Scribble's fence-aware reading is truer to the bytes than a line prefix).
#
#   awk -f tools/fixtures/md_truth.awk <file>
# prints: headings <h> rye <r> rish <s> plain <p> words <w>
#   h — heading lines outside any fence
#   r/s/p — fenced blocks opened by ```rye / ```rish / anything else
#   w — total words across heading texts (fields after the marker), outside fences

BEGIN { infence = 0; h = 0; rye = 0; rish = 0; plain = 0; words = 0 }

# A fence marker toggles in/out of a fenced block. On entry, classify by info string.
/^```/ {
    if (infence) { infence = 0; next }
    infence = 1
    if ($0 ~ /^```rye/) rye++
    else if ($0 ~ /^```rish/) rish++
    else plain++
    next
}

# A heading is a '#'-run followed by a space, only when we are not inside a fence.
{
    if (!infence && $0 ~ /^#+ /) {
        h++
        words += NF - 1   # every field after the leading marker is a heading word
    }
}

END { print "headings " h " rye " rye " rish " rish " plain " plain " words " words }
