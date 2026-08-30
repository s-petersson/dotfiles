#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

# Install tools available through the platform package manager.
# Keep this file limited to packages handled by lib/dotfiles/packages.sh
# (Homebrew on macOS, pacman on Arch). Tools that require custom installers
# belong in setup/pre/20-install-external-tools.sh instead.
dotfiles_install_packages \
    curl \
    openssh \
    zsh \
    stow \
    fzf \
    neovim \
    starship \
    fnm \
    uv \
    eza \
    bat \
    --arch ghostty

dotfiles_install_homebrew_casks ghostty
