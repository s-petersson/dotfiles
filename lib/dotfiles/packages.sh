#!/usr/bin/env bash

# Package install helpers for setup scripts.
#
# Usage from pre/*.sh or post/*.sh:
#
#   source "${DOTFILES_LIB:?}/packages.sh"
#   dotfiles_install_packages <package_name>...
#   dotfiles_install_packages --macos <package_name>... --arch <package_name>...
#   dotfiles_install_homebrew_casks <cask_name>...
#
# Platform selectors apply to every package that follows, up to the next
# selector. Unqualified packages are installed on both supported platforms.

if [ -n "${DOTFILES_PACKAGES_SH_LOADED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
DOTFILES_PACKAGES_SH_LOADED=1

source "${DOTFILES_LIB:?}/platform.sh"

# Print the packages from "$@" that are absent from the newline-separated
# list on stdin. Tap-qualified names are matched on their final component.
dotfiles_select_missing() {
  local installed
  installed="$(cat)"

  local package
  for package in "$@"; do
    grep -qxF "${package##*/}" <<<"$installed" || printf '%s\n' "$package"
  done
}

dotfiles_install_homebrew_casks() {
  if ! dotfiles_is_macos || [ "$#" -eq 0 ]; then
    return 0
  fi

  local missing_casks=()
  while IFS= read -r cask; do
    missing_casks+=("$cask")
  done < <(brew list --cask -1 | dotfiles_select_missing "$@")

  if [ "${#missing_casks[@]}" -gt 0 ]; then
    brew install --cask "${missing_casks[@]}"
  fi
}

dotfiles_install_packages() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi

  local platform
  if dotfiles_is_macos; then
    platform=macos
  elif dotfiles_is_arch; then
    platform=arch
  else
    echo "error: unsupported platform for package installation: $(dotfiles_platform)" >&2
    return 1
  fi

  # Select unqualified packages and packages for the current platform.
  local package_platform=all
  local packages=()
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --macos) package_platform=macos ;;
      --arch) package_platform=arch ;;
      *)
        if [ "$package_platform" = all ] || [ "$package_platform" = "$platform" ]; then
          packages+=("$1")
        fi
        ;;
    esac
    shift
  done

  # Ask the package manager once which selected packages are already installed.
  local list_installed=(pacman -Qq)
  if [ "$platform" = macos ]; then
    list_installed=(brew list --formula -1)
  fi

  local missing_packages=()
  local package
  while IFS= read -r package; do
    missing_packages+=("$package")
  done < <("${list_installed[@]}" | dotfiles_select_missing "${packages[@]}")

  if [ "${#missing_packages[@]}" -eq 0 ]; then
    return 0
  fi

  # Install all missing packages in one package-manager call.
  if [ "$platform" = macos ]; then
    brew install "${missing_packages[@]}"
  else
    sudo pacman -S --needed "${missing_packages[@]}"
  fi
}
