# VM fleet

This project creates one clean OrbStack template and five independent development workers.

## First setup

Review [config/fleet.sh](config/fleet.sh), then run:

```bash
./bin/apply plan
./bin/apply apply
```

The apply command requests confirmation. It creates missing machines and synchronizes managed packages.

## Connect

```bash
ssh dev-vm-1@orb
ssh dev-vm-2@orb
ssh dev-vm-3@orb
ssh dev-vm-4@orb
ssh dev-vm-5@orb
```

OrbStack supplies the SSH server and host configuration. The project does not install `sshd` inside the machines.

## Authenticate providers

Authenticate each worker separately. Do not authenticate the template.

The provisioner never reads or copies credentials. You can use different Anthropic, OpenAI, xAI, or other accounts in each worker.

## Synchronize software

Edit the pinned version in a script under `provision/`. Then rerun:

```bash
./bin/apply apply
```

The scripts manage declared packages only. They do not reset other files in existing workers.

## Share Mac skills

Add one skill directory name per line to [config/skills.txt](config/skills.txt). The source defaults to `~/.agents/skills` on the Mac.

OrbStack mounts Mac files into every machine. The provisioner creates links for supported harness skill directories.

Keep `vm-fleet` and `vm-fleet-provision` on the Mac. These operational skills do not need to run inside workers.
