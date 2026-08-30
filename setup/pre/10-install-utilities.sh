#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

dotfiles_install_packages \
    curl \
    openssh \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
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
