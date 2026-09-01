# Mac host dependencies

## Required

Use a Mac that can run OrbStack.

Install and open OrbStack. The app supplies the `orb` command and the built-in SSH server.

Choose one installation method:

```bash
brew install orbstack
```

Or download OrbStack from <https://orbstack.dev/download> and open the app.

Then confirm these commands:

```bash
orb status
orb version
ssh -V
```

The initial apply also needs internet access. It downloads the Ubuntu image and pinned Linux tools.

## Skill installation

Node.js and `npx` are required only to install this skill with the `skills` CLI.

```bash
npx skills add liquid1982/agent-skills --skill vm-fleet-provision -g -y
```

The provisioner itself does not require Node.js, Homebrew, Ansible, Python, `jq`, or `yq` on the Mac.

## OrbStack features used

- `orb create` creates the clean template.
- `orb clone` creates independent workers from the template.
- `orb -m NAME` runs each provisioner in one machine.
- OrbStack exposes Mac paths inside each machine.
- OrbStack adds the `orb` SSH host to the Mac SSH configuration.
- `ssh MACHINE@orb` connects from the Mac to one worker.

OrbStack only accepts local SSH connections by default. This skill does not enable remote network access.
