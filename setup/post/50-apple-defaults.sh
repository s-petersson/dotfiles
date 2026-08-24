#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

if ! dotfiles_is_macos; then
  exit 0
fi

defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false
