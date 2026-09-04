format session-log-v1
stamp 20260904.084108
editor Cursor IDE chat
provider xAI via Cursor
product Cursor
role Incense sitting -- map nscd into the agent jail
modality text
model unverified
model_status active runtime unverified
configured_model Cursor Grok 4.6
configured_reasoning high
voice Kyri
host macOS arm64 host, America/New_York one-clock zone
title Map nscd into the agent jail -- EAI_AGAIN was missing /run/nscd
prompt Keaton pasted incense LOOP_LAPS=1: jail active, landlock enforced, then cursor-agent Error unavailable getaddrinfo EAI_AGAIN api2.cursor.sh, lap exited 1.
think The jail replaced /run with tmpfs. glibc getaddrinfo on NixOS talks to nscd at /run/nscd/socket. The launcher already remapped /run/current-system for PATH and left nscd behind. Map /run/nscd and /run/resolvconf when they exist. Do not map all of /run.
obs FLEET_BARE=1 still skips the jail and uses host DNS if a watched lap wants that door. Standing door is the nscd map. Pull incense and LOOP_LAPS=1 again. One writer.
file tools/ag/agent-jail.sh map /run/nscd and /run/resolvconf
file tools/ag/agent_jail_witness.sh same maps
file construction/ITINERARY.md live state EAI_AGAIN
file session-logs/date/20260904/20260904-084108_map-nscd-into-the-jail.kyri this sitting
recommend check-in (Cursor) -- pull grain-incense; LOOP_LAPS=1 again
