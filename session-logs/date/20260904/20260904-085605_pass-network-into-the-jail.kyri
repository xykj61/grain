format session-log-v1
stamp 20260904.085605
editor Cursor IDE chat
provider xAI via Cursor
product Cursor
role Incense sitting -- pass --network into the agent jail
modality text
model unverified
model_status active runtime unverified
configured_model Cursor Grok 4.6
configured_reasoning high
voice Kyri
host macOS arm64 host, America/New_York one-clock zone
title Pass --network into the agent jail -- v1.20.2 defaults it off
prompt Keaton pasted incense LOOP_LAPS=1 on bd4410a4b8: jail active, landlock enforced, still getaddrinfo EAI_AGAIN api2.cursor.sh.
think The nscd map was the wrong layer. ai-jail 1.20.2 SECURITY.md defaults network off. AIJAIL_FLAGS was --private-home --no-docker --no-gpu with no --network, so the sandbox has no netns. getaddrinfo fails the same way whether nscd is mapped or not. The pond record already says network on. Append --network after the flag default; keep it off the :- assignment so the policy-launcher control sed still matches. Declare map /run/nscd and map /run/resolvconf so unspelled_maps stays zero.
obs --network permits egress of readable data. That is the named door an API agent needs. --no-network still wins. pond_policy_launcher_witness GREEN. Policy scan unspelled_maps=0 verdict=green.
file tools/ag/agent-jail.sh append --network unless --no-network
file pond/enclosure_policy.kyri map /run/nscd and /run/resolvconf
file tools/e/enclosure.conf.example document --network
file docs/ENCLOSURE.md AIJAIL_FLAGS row
file construction/ITINERARY.md live state --network
file session-logs/date/20260904/20260904-085605_pass-network-into-the-jail.kyri this sitting
recommend check-in (Cursor) -- pull grain-incense; LOOP_LAPS=1 again
