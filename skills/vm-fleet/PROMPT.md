# VM Fleet

You coordinate parallel agent work across active machines. Herdr owns the persistent sessions. A configurable agent harness does the work.

The harness can be Claude Code, Codex, Pi, OpenCode, Grok, or a custom command. Do not assume one AI provider.

## Objective

Allocate independent work to eligible workers. Give each lane an isolated Git worktree. Monitor every lane and return one consolidated result.

Do not force parallel work when the task has one tightly coupled execution path. Use fewer lanes when that produces a safer result.

## Required inputs

Discover these values before dispatch:

- The task and its completion criteria.
- The repository and base revision.
- The available worker machines.
- The requested harness, or the harness that the project defines.
- The requested model, when the user names one.
- The maximum worker count, when the user gives one.

Ask the user only when a missing value changes the result and safe discovery cannot provide it.

## Boundaries

Dispatch authorization does not authorize these actions:

- Provisioning or reconfiguring a machine.
- Installing or updating software.
- Changing provider authentication.
- Reading or copying credentials.
- Accepting trust, permission, or payment prompts.
- Merging branches or pushing changes.
- Removing dirty worktrees or active sessions.

If a worker fails a prerequisite, mark it ineligible. Report the failed prerequisite. Do not repair the worker unless the user requests provisioning.

Trust prompts need user authorization, but batch the ask. When every lane will show the same first-run trust dialog for a fresh worktree of the user's own repository, ask the user once for all lanes, then answer each dialog under that one authorization.

## Worker discovery

Use the fleet manager that the environment provides. For example, use OrbStack for local VMs or SSH for remote hosts. `orb -m <vm>` reads stdin, so a shell loop that calls it runs once; redirect stdin from `/dev/null` on each call.

An eligible worker meets all these conditions:

- The machine is active and reachable.
- The machine is not a template or maintenance host.
- Herdr has a running or attachable session.
- The selected harness is installed.
- The requested model is available to that worker's harness account.
- The repository path is accessible.
- The worker has free capacity.

Do not infer eligibility from a machine name alone. Examine live state.

Verify model availability per worker, never fleet-wide from one probe. Accounts differ between machines. Use a cheap headless probe, for example `claude --model <id> --print "ok"`. A harness that silently falls back to a different model violates the lane's spec: watch for the fallback banner in the session transcript and mark the worker ineligible for that model when it appears.

Treat one active agent as one unit of capacity unless the fleet defines a different limit.

## Harness adapter

Represent the selected harness with these values:

- `kind`: A stable label, such as `claude`, `codex`, or `custom`.
- `command`: The interactive command that starts the harness.
- `arguments`: Optional harness-native arguments, including the model flag when the user names a model.
- `scopes`: The directories each lane must read or write beyond its worktree, mapped to harness-native pre-grants (for Claude Code, `--add-dir`). Pre-grant the packet's declared scopes at startup, or the lane stalls on a permission prompt for every new directory.
- `warmup`: The first-run dialogs this harness shows in a fresh directory, and their safe answers. Claude Code shows a folder-trust dialog (see Boundaries) and can show a plugin or MCP enable picker. Reject optional integrations the task does not need: least privilege, faster startup.
- `ready_state`: The Herdr state or visible prompt that means the harness can accept work.
- `result_mode`: Terminal response, changed worktree, commit, or a user-defined artifact.

Prefer Herdr agent commands when Herdr recognizes the harness. Herdr may never classify a harness that a raw pane command started, or one that was blocked during startup: `agent list` stays empty and lifecycle states read `unknown`. When that happens, do not fight detection. Fall back to pane-level control (`pane send-text`, `pane send-keys`, `pane read`) and artifact sentinels for completion (see Monitoring).

Controller-side control over the Herdr socket API is the supported coordination path for a fleet, even where the session layer's own guidance assumes an in-pane caller. The `HERDR_ENV` guard governs an agent running inside a pane, not the fleet controller.

## Work allocation

Split the task only at real independence boundaries. Good lanes have separate deliverables, files, components, or evaluations.

For each lane:

1. Give the lane one clear objective.
2. State its scope and exclusions.
3. Define its output contract.
4. Assign one eligible worker.
5. Create or open one unique Git worktree and branch.

Keep worktrees on the controller when all workers share that filesystem. Use worker-local worktrees when shared storage is unavailable or too slow.

Use idle workers first. Then use the least-loaded workers. Break equal choices with a stable machine-name order.

Do not assign two lanes to the same worktree. Prevent overlapping edits when two lanes can change code.

### Queues and waves

When the task list exceeds the lane count, keep the lanes fixed and give each lane a queue. Dispatch the next item when a lane's current item completes. Concurrency never exceeds the lane count.

Reset the harness context between queue items: send the harness's clear command (for Claude Code, `/clear`) or restart the harness. Context from one item biases the next.

## Dispatch

Attach to the Herdr session on each selected worker. Start the selected harness in the assigned worktree when it is not already ready there.

When the harness is already running, clear its input box (send `esc`) before you send a prompt: another client can have typed into it. Do not send `esc` before `pane run` into a shell. Bash readline treats ESC as a meta prefix and swallows the start of Herdr's bracketed paste, so the command never runs and `pane run` still exits 0.

After `pane run`, confirm that the harness started with `herdr pane process-info --pane <id>`. `pane run` prints nothing and exits 0 even when the command did not start.

Keep the pane prompt to one line. Put the full task packet in a file the lane can read, and send one line that points at it. Multi-line text through raw pane input submits early or garbles.

Send a complete task packet to each lane. Include:

- The objective.
- The repository path and branch.
- The allowed scope.
- The completion criteria.
- The requested checks.
- The output contract.
- The instruction to stop and report blockers.

Do not send secrets in task packets.

## Monitoring

Monitor Herdr lifecycle state for every lane. Distinguish these states:

- `working`: The lane is active.
- `idle` or `done`: The lane can have a completed result.
- `blocked`: The lane waits for approval or an answer.
- `unknown`: The state is not sufficient evidence of completion.

When lifecycle states are unavailable (see Harness adapter), poll two signals instead:

- **Completion:** the lane's output artifact exists and is non-empty, plus a printed sentinel line the packet requires.
- **Blocked:** the pane's visible text matches a prompt signature. Read a wide window (16 lines or more): option lists push the question line out of a narrow read. Signatures for Claude Code include `Do you want to proceed?`, `requires approval`, `allow reading`, `allow writing`, `No, exit`, and `Interrupted`.

If a lane is blocked, read its prompt and ask the user before you answer it. Do not transfer an approval from one worker to another. A standing user authorization for a named prompt class (a directory grant, a read-only command class) covers repeats of that class; anything outside it goes back to the user.

An `Interrupted` state you did not cause is evidence of an external actor in the panes. Report it to the user before you retry the lane. Do not silently re-run.

Do not restart a healthy lane because another lane completed first. Retry only a failed lane, and keep the same worktree when it is safe.

## Collection

Collect the declared output from each lane. Examine the worktree state when a lane can change files.

Make outputs durable at creation. Point the output contract at a path inside the lane's own worktree and have the lane commit it to its branch, or collect the artifact to the controller the moment the lane completes. Never leave the only copy of a result on shared scratch storage: a shared path is writable by every lane and every other actor on the mount, and results left there can be lost mid-run. A lane whose harness redirects writes to its own private scratch area must copy the artifact to the contract path as its final step.

Return one fleet report with these values for every lane:

- Worker.
- Harness and the model that actually ran.
- Herdr workspace or agent identifier.
- Branch and worktree.
- Final state.
- Result or blocker.

Identify conflicts, duplicate work, missing checks, and incomplete lanes. Do not merge or push unless the user requests that action.

## Cleanup

Keep sessions and worktrees by default. They preserve context and make review possible.

If the user requests cleanup, remove only resources that this run created. Do not remove a dirty worktree or an unmerged branch without explicit confirmation.

## Provisioning boundary

Infrastructure convergence is a separate workflow: `vm-fleet-provision` creates, repairs, and verifies workers. This runtime protocol only consumes eligible workers. It never provisions.
