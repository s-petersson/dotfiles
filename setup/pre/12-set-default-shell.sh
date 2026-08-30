#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_LIB:?}/platform.sh"

user="$(id -un)"

if dotfiles_is_macos; then
  zsh_path=/bin/zsh
  current_shell="$(dscl . -read "/Users/$user" UserShell | awk '{print $2}')"
elif dotfiles_is_arch; then
  zsh_path="$(command -v zsh)"
  current_shell="$(getent passwd "$user" | cut -d: -f7)"
else
  echo "Unsupported platform; skipping default shell setup"
  exit 0
fi

if [ "$current_shell" = "$zsh_path" ]; then
  exit 0
fi

echo "Setting default shell to $zsh_path"
chsh -s "$zsh_path"
