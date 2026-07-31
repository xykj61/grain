# Census Control — One True H1 Outside Fences

**Language:** EN  
**Kind:** planted positive · H1 fence discrimination  
**Planted:** true=1 · naive=4  
**Law:** a duty that counts H1 must mask fenced blocks before it reports a total

This file carries exactly one real title heading. Three additional `# ` lines live only inside fenced code, so a naive line scan that ignores fences reads four, and a fence-aware scan reads one.

```
# fenced decoy one
# fenced decoy two
# fenced decoy three
```

The planted numbers are the instrument: true proves the count, naive proves the fence mask fired. A scanner that only checks true=1 without also seeing naive=4 has not proven discrimination.
