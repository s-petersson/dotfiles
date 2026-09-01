#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES_LIB:?}/platform.sh"

dotfiles_is_macos || exit 0

label=com.spetersson.dotfiles-theme-appearance
service="gui/$(id -u)/$label"
plist="$HOME/Library/LaunchAgents/$label.plist"

[ -f "$plist" ] || exit 0

if launchctl print "$service" >/dev/null 2>&1; then
  launchctl bootout "$service"
fi
launchctl bootstrap "gui/$(id -u)" "$plist"
