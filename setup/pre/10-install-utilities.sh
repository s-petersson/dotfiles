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
    --macos FelixKratz/formulae/borders \
    --arch ghostty \
    obsidian

dotfiles_install_homebrew_casks \
    ghostty \
    nikitabobko/tap/aerospace \
    obsidian
