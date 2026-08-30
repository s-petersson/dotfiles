#!/usr/bin/env bash
set -euo pipefail

# Install tools that are not managed by the package-manager helper in
# setup/pre/10-install-utilities.sh. Keep each installer idempotent so this
# script remains safe to re-run during normal dotfiles setup.

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "error: $command_name is required" >&2
    exit 1
  fi
}

install_herdr() {
  # Herdr's upstream install method is a shell installer rather than a
  # Homebrew/pacman package, so it lives in this external-tools script.
  if command -v herdr >/dev/null 2>&1; then
    return 0
  fi

  require_command curl

  echo "==> Installing herdr"
  curl -fsSL https://herdr.dev/install.sh | sh
}

# Add future external-tool installers above and call them here.
install_herdr
