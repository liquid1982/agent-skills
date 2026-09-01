# This file is sourced by bin/apply. Use shell values only.

FLEET_IMAGE="ubuntu:noble"
FLEET_TEMPLATE="dev-vm-template"
FLEET_WORKERS=(
  "dev-vm-1"
  "dev-vm-2"
  "dev-vm-3"
  "dev-vm-4"
  "dev-vm-5"
)

# Provisioners run in this order. Remove a name to omit that package.
FLEET_PROVISIONERS=(
  "git"
  "mise"
  "skills"
  "herdr"
  "opencode"
  "codex"
  "claude"
  "grok"
  "pi"
)

# This Mac path is visible inside OrbStack machines.
FLEET_HOST_SKILLS_ROOT="$HOME/.agents/skills"
