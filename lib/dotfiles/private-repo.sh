#!/usr/bin/env bash

# Resolve the optional private dotfiles repository.
#
# By default it is expected next to the public repository with a "-private"
# suffix. Set DOTFILES_PRIVATE_REPO to another path, or to an empty value to
# disable private dotfiles explicitly.
dotfiles_resolve_private_repo() {
  local public_repo="$1"
  local candidate

  DOTFILES_RESOLVED_PRIVATE_REPO=""

  if [ "${DOTFILES_PRIVATE_REPO+x}" = x ]; then
    [ -n "$DOTFILES_PRIVATE_REPO" ] || return 0
    candidate="$DOTFILES_PRIVATE_REPO"

    if [ ! -d "$candidate" ]; then
      echo "error: DOTFILES_PRIVATE_REPO is not a directory: $candidate" >&2
      return 1
    fi
  else
    candidate="${public_repo}-private"
    [ -d "$candidate" ] || return 0
  fi

  DOTFILES_RESOLVED_PRIVATE_REPO="$(cd "$candidate" && pwd)"
}
