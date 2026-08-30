#!/usr/bin/env bash
set -euo pipefail

command -v omarchy >/dev/null 2>&1 || exit 0

state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
migration_file="$state_home/dotfiles/migrations/20-omarchy-stow-conflicts"

# These paths may be files or directories, but must be relative to $HOME.
conflicts=(
  ".config/ghostty/config"
  ".config/tmux/tmux.conf"
  ".config/nvim"
  ".local/share/nvim"
  ".local/state/nvim"
  ".cache/nvim"
  ".pi/agent/settings.json"
  ".config/hypr"
  ".config/starship.toml"
  ".config/herdr/config.toml"
)

for relative in "${conflicts[@]}"; do
  case "$relative" in
    "" | /* | . | .. | ../* | */../* | */..)
      echo "error: unsafe Omarchy conflict path: $relative" >&2
      exit 1
      ;;
  esac

  target="$HOME/$relative"

  if [ -f "$migration_file" ] && grep -Fqx -- "$relative" "$migration_file"; then
    continue
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "==> Removing initial Omarchy config conflict: $target"
    rm -rf -- "$target"
  fi

  mkdir -p "$(dirname "$migration_file")"
  printf '%s\n' "$relative" >>"$migration_file"
done
