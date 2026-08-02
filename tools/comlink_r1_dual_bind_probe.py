#!/usr/bin/env python3
"""Host dual-stack bind probe for Comlink R1 — outside comlink/, loopback only."""
import socket
import sys

s6 = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
s6.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s6.bind(("::1", 0))
s4 = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s4.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s4.bind(("127.0.0.1", 0))
s6.close()
s4.close()
print("dual-bind-ok", flush=True)
sys.exit(0)
