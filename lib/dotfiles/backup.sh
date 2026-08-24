#!/usr/bin/env bash

# Back up an existing regular file before replacing it with a managed symlink.
# Missing files and symlinks are left unchanged, making this safe to re-run.
#
# Usage:
#
#   source "${DOTFILES_LIB:?}/backup.sh"
#   dotfiles_backup_file "$HOME/.config/example/config"

if [ -n "${DOTFILES_BACKUP_SH_LOADED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
DOTFILES_BACKUP_SH_LOADED=1

dotfiles_backup_file() {
  if [ "$#" -ne 1 ]; then
    echo "usage: dotfiles_backup_file <file>" >&2
    return 2
  fi

  local file="$1"

  if [ -L "$file" ] || [ ! -e "$file" ]; then
    return 0
  fi

  if [ ! -f "$file" ]; then
    echo "error: cannot back up non-regular file: $file" >&2
    return 1
  fi

  local timestamp backup suffix
  timestamp="$(date +%Y%m%d-%H%M%S)"
  backup="${file}.before-dotfiles-${timestamp}"
  suffix=1

  while [ -e "$backup" ] || [ -L "$backup" ]; do
    backup="${file}.before-dotfiles-${timestamp}-${suffix}"
    suffix=$((suffix + 1))
  done

  echo "==> Backing up $file to $backup"
  mv "$file" "$backup"
}
