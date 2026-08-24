#!/usr/bin/env bash

# Resolve the optional private work dotfiles repository.
#
# By default it is expected next to the public repository with a "-work"
# suffix. Set DOTFILES_WORK_REPO to another path, or to an empty value to
# disable work dotfiles explicitly.
dotfiles_resolve_work_repo() {
  local public_repo="$1"
  local candidate

  DOTFILES_RESOLVED_WORK_REPO=""

  if [ "${DOTFILES_WORK_REPO+x}" = x ]; then
    [ -n "$DOTFILES_WORK_REPO" ] || return 0
    candidate="$DOTFILES_WORK_REPO"

    if [ ! -d "$candidate" ]; then
      echo "error: DOTFILES_WORK_REPO is not a directory: $candidate" >&2
      return 1
    fi
  else
    candidate="${public_repo}-work"
    [ -d "$candidate" ] || return 0
  fi

  DOTFILES_RESOLVED_WORK_REPO="$(cd "$candidate" && pwd)"
}
