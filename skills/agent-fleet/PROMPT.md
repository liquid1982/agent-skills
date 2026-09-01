# Agent Fleet

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

## Worker discovery

Use the fleet manager that the environment provides. For example, use OrbStack for local VMs or SSH for remote hosts.

An eligible worker meets all these conditions:

- The machine is active and reachable.
- The machine is not a template or maintenance host.
- Herdr has a running or attachable session.
- The selected harness is installed.
- The repository path is accessible.
- The worker has free capacity.

Do not infer eligibility from a machine name alone. Examine live state.

Treat one active agent as one unit of capacity unless the fleet defines a different limit.

## Harness adapter

Represent the selected harness with these values:

- `kind`: A stable label, such as `claude`, `codex`, or `custom`.
- `command`: The interactive command that starts the harness.
- `arguments`: Optional harness-native arguments.
- `ready_state`: The Herdr state or visible prompt that means the harness can accept work.
- `result_mode`: Terminal response, changed worktree, commit, or a user-defined artifact.

Prefer Herdr agent commands when Herdr recognizes the harness. Use raw pane commands only for intentional terminal control.

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

## Dispatch

Attach to the Herdr session on each selected worker. Start the selected harness in the assigned worktree when it is not already ready there.

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

If a lane is blocked, read its prompt and ask the user before you answer it. Do not transfer an approval from one worker to another.

Do not restart a healthy lane because another lane completed first. Retry only a failed lane, and keep the same worktree when it is safe.

## Collection

Collect the declared output from each lane. Examine the worktree state when a lane can change files.

Return one fleet report with these values for every lane:

- Worker.
- Harness.
- Herdr workspace or agent identifier.
- Branch and worktree.
- Final state.
- Result or blocker.

Identify conflicts, duplicate work, missing checks, and incomplete lanes. Do not merge or push unless the user requests that action.

## Cleanup

Keep sessions and worktrees by default. They preserve context and make review possible.

If the user requests cleanup, remove only resources that this run created. Do not remove a dirty worktree or an unmerged branch without explicit confirmation.

## Provisioning boundary

Infrastructure convergence is a separate workflow. An Ansible skill can install packages, configure Herdr, and validate workers.

This runtime protocol only consumes eligible workers. It never invokes Ansible automatically.
