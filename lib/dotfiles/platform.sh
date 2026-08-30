#!/usr/bin/env bash

# Platform helpers for setup scripts.
#
# Usage from pre/*.sh or post/*.sh:
#
#   source "${DOTFILES_LIB:?}/platform.sh"
#
#   if dotfiles_is_macos; then
#     ...
#   fi
#
# These functions return shell success/failure and do not print output unless
# their name says otherwise.

if [ -n "${DOTFILES_PLATFORM_SH_LOADED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
DOTFILES_PLATFORM_SH_LOADED=1

dotfiles_uname() {
  uname -s
}

dotfiles_is_macos() {
  [ "$(dotfiles_uname)" = "Darwin" ]
}

dotfiles_is_arch() {
  [ "$(dotfiles_uname)" = "Linux" ] && [ -f /etc/arch-release ]
}

dotfiles_platform() {
  if dotfiles_is_macos; then
    echo "macos"
  elif dotfiles_is_arch; then
    echo "arch"
  else
    echo "unknown"
  fi
}
