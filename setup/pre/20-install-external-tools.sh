#!/usr/bin/env bash
set -euo pipefail

if command -v pi >/dev/null 2>&1; then
  echo "==> Pi coding agent already installed"
  exit 0
fi

eval "$(fnm env --shell bash)"
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
