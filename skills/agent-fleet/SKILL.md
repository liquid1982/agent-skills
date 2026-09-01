---
name: agent-fleet
description: "Distribute independent agent work across active machines through Herdr, with one isolated Git worktree per lane and a configurable agent harness. Use when a user asks to parallelize work across a VM fleet, balance agent tasks across machines, or coordinate several remote coding sessions. Do not use for machine provisioning or routine single-agent work."
---

# /agent-fleet — parallel agent work across machines

Read [PROMPT.md](PROMPT.md) in full. Follow its allocation, dispatch, monitoring, and safety rules.

The protocol uses Herdr as the session layer. The agent harness can be Claude Code, Codex, Pi, OpenCode, Grok, or a custom command.

## Usage

```text
/agent-fleet <task>
/agent-fleet --harness codex <task>
/agent-fleet --workers 3 <task>
```

Treat these flags as intent, not as a fixed parser. Use equivalent natural-language instructions when the harness does not support slash-command arguments.

## Agent integration

1. Read the fleet details from the request, project files, or local machine manager.
2. Ask only for a value that cannot be discovered safely.
3. Use the native Herdr skill when it is available.
4. Use explicit workspace, pane, and agent identifiers from command output.
5. Report the worker, branch, worktree, harness, and final state for each lane.

Do not provision machines, change authentication, accept trust prompts, merge branches, or remove worktrees without explicit authorization.
