#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_LIB:?}/platform.sh"

if ! dotfiles_is_macos || xcode-select -p >/dev/null 2>&1; then
  exit 0
fi

echo "==> Requesting Xcode Command Line Tools installation"
xcode-select --install
echo "Complete the installation dialog, then run dot install again." >&2
exit 1
