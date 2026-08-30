#!/usr/bin/env bash
set -euo pipefail

eval "$(fnm env --shell bash)"
fnm install --lts --use
fnm default "$(node --version)"
