#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

if ! dotfiles_is_macos; then
  exit 0
fi

if command -v brew >/dev/null 2>&1; then
  echo "==> Homebrew already installed"
  exit 0
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "==> Homebrew already installed"
  exit 0
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  echo "==> Homebrew already installed"
  exit 0
fi

echo "==> Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
