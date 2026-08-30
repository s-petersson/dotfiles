#!/usr/bin/env bash

# Resolve the optional private dotfiles repository next to the public repository.
dotfiles_resolve_private_repo() {
  local candidate="${1}-private"

  DOTFILES_RESOLVED_PRIVATE_REPO=""
  [ -d "$candidate" ] || return 0

  DOTFILES_RESOLVED_PRIVATE_REPO="$(cd "$candidate" && pwd)"
}
