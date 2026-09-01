---
name: vm-fleet-provision
description: "Create and synchronize a provider-agnostic development VM fleet on macOS with OrbStack. Use when a user wants to bootstrap, provision, repair, or verify one template and several matching Linux workers. The generated project uses shell scripts, not Ansible. Do not use for routine task dispatch or provider authentication."
---

# /vm-fleet-provision — build an OrbStack development fleet

Read [PROMPT.md](PROMPT.md) in full. Follow its discovery, approval, provisioning, and verification rules.

The skill creates an inspectable project at `~/Projects/vm-fleet` by default. The project contains all ongoing fleet configuration.

## Usage

```text
/vm-fleet-provision Create my local development fleet
/vm-fleet-provision Check my fleet and repair managed software drift
/vm-fleet-provision Use three workers named project-vm-1 through project-vm-3
```

Treat names and counts as user intent. Update the generated configuration before provisioning.

## Boundaries

- Use OrbStack only.
- Use the generated shell provisioners. Do not introduce Ansible.
- Never authenticate an AI provider on the template.
- Never copy provider credentials between machines.
- Do not delete, rename, or replace machines without explicit approval.
- Use `vm-fleet` for routine parallel task dispatch after setup.
