# Termux to the pier: the Cursor CLI lane

**Status:** Living — operational guide, CLI only

The intended shape is simple: the Daylight DC-1 is a terminal client, the pier holds the checkout
and Cursor Agent CLI, Mosh carries the roaming terminal, and tmux holds the process.

## First setup in Termux

Install Termux from a maintained source, then install the terminal tools:

```sh
pkg update
pkg install openssh mosh tmux
ssh-keygen -t ed25519 -C 'dc1-termux'
```

Place the public key on the pier through the normal, human-controlled SSH key workflow. Do not
paste private key material into Cursor, a prompt, a log, or this repository.

## Connect and hold the work

```sh
mosh keeper@<PIER_HOST>
tmux new -A -s grain
cd /path/to/grain-incense
./tools/ag/agent-jail.sh cursor-agent
```

The exact account and host are deployment facts, so this document keeps placeholders. The existing
NixOS/Mosh firewall operations live in [`../../tools/p/pier_mosh_udp_open.sh`](../../tools/p/pier_mosh_udp_open.sh)
and require a deliberate root action on the pier; Cursor CLI does not perform that operation.

If the tablet changes networks, reconnect with Mosh and run `tmux attach -t grain`. Check the
working tree and the agent's visible session before restarting anything.

## Session modes

Use interactive mode for a conversation, `--continue` or `--resume` to return to an existing CLI
session, and `-p`/print mode for a bounded, non-interactive request. Begin a risky task with a
read-only inspection prompt. Let the project's permission file stop common irreversible commands,
and treat any additional approval prompt as a real boundary.

## State and recovery

The repository launcher maps Cursor's durable auth/config state into ignored project-local runtime
storage when the pier's enclosure requires it. That state is not portable documentation. If login
is lost, authenticate once through the normal Cursor CLI flow on the pier; never repair it by
committing `loops/cursor/`, `~/.cursor/`, or `~/.config/cursor/`.

For a broken transport, recover in this order:

1. Reconnect Mosh.
2. Attach to `tmux`.
3. Inspect `git status` and the agent session.
4. Resume the existing agent session if it is still present.
5. Only then start a new session.

The Bluetooth ergonomic keyboard and trackball are input devices, not a second execution surface;
their GUI pairing details are intentionally outside this guide.
