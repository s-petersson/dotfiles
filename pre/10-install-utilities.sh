#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

dotfiles_install_packages \
    openssh \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    stow \
    fzf \
    neovim \
    starship \
    zoxide \
    fnm \
    uv \
    eza \
    bat \
    tuicr \
    --macos FelixKratz/formulae/borders \
    --arch curl \
    ghostty \
    obsidian

dotfiles_install_homebrew_casks \
    ghostty \
    nikitabobko/tap/aerospace \
    obsidian
