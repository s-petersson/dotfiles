#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_LIB:?}/platform.sh"

command -v dotfiles-theme >/dev/null 2>&1 || exit 0

if dotfiles_is_arch && command -v omarchy >/dev/null 2>&1; then
  theme=$(omarchy theme current)
  OMARCHY_THEME_SKIP_BACKGROUND=1 dotfiles-theme set "$theme"
elif theme=$(dotfiles-theme current 2>/dev/null); then
  dotfiles-theme set "$theme"
else
  dotfiles-theme set gruvbox
fi
