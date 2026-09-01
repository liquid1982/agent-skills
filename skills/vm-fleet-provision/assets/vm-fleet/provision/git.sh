#!/usr/bin/env bash
set -euo pipefail

missing=0
for command_name in curl git gzip install sha256sum tar; do
  command -v "$command_name" >/dev/null 2>&1 || missing=1
done

if ((missing)); then
  sudo apt-get update
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates coreutils curl git gzip tar
fi

git --version
