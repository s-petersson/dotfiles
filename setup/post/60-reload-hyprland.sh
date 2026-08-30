#!/usr/bin/env bash
set -euo pipefail

command -v hyprctl >/dev/null 2>&1 || exit 0
command -v pgrep >/dev/null 2>&1 || exit 0
pgrep -u "$(id -u)" -x Hyprland >/dev/null || exit 0

hyprctl reload
